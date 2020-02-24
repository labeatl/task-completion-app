from flask import Flask, jsonify, request, render_template, g
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Resource, Api
from flask_migrate import Migrate
from flask import send_file, g
from itsdangerous import (TimedJSONWebSignatureSerializer as Serializer, BadSignature, SignatureExpired)
import os
import base64





app = Flask(__name__)
api = Api(app)
APP_ROOT = os.path.dirname(os.path.abspath(__file__))
auth = HTTPBasicAuth()



# Database connection information
dbParam = 'mysql+pymysql://taskuser:LENAnalytics2019@localhost/taskr'
app.config['SQLALCHEMY_DATABASE_URI'] = dbParam
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Flask secret key
app.config['SECRET_KEY'] = 'thEejrdaR5$wE3yY4wsehn4wASHR' #Change this for production


user_skills = db.Table('user_skills',
                       db.Column('id_user', db.Integer, db.ForeignKey('accounts.id_user'), primary_key=True),
                       db.Column('id', db.Integer, db.ForeignKey('skills.id'), primary_key=True,
                                 ))

# TODO Move models to models file
class Accounts(db.Model):
    id_user = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    surName = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(50), nullable=False)
    password = db.Column(db.Text)
    userBio = db.Column(db.String(256), nullable=True)
    skills = db.relationship('Skills', secondary=user_skills, lazy='subquery', backref=db.backref('accounts.id_user', lazy=True))
    profile_pic = db.Column(db.String(200), nullable=False)
    # profile_pic = db.relationship("ProfilePic", backref="acc", lazy=True)


# class ProfilePic(db.Model):
#     filename = db.Column(db.String, primary_key=True)
#     person_id = db.Column(db.Integer, db.ForeignKey("acc.id"), nullable=False)
#
#
# class Tasks(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     taskName = db.Column(db.String, nullable=False)


class Tasks(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(512), nullable=False)
    category = db.Column(db.String(20), nullable=False)
    et = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Integer, nullable=False)
    location = db.Column(db.String(20), nullable=False)
    author = db.Column(db.Integer, primary_key=True)  # link to user
    picture = db.Column(db.String(80), nullable=True)


# Adding skill: INSERT INTO skills *press enter* VALUE (0,'Programming','Building stuff with electrical impulses');
class Skills(db.Model):
    id = db.Column(db.Integer, primary_key=True, )
    name = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(50), nullable=False)

#END MODELS



class hello(Resource):
    def get(self):
        return 'live'


api.add_resource(hello, '/')

class Summary(Resource):
     def post(self):
         summary = request.form['Summary']
         userAccount = Accounts.query.filter_by(id_user=1).first()
         userAccount.userBio = summary
         db.session.commit()
         print("Summary:")
         print(summary)
         return 'success'



api.add_resource(Summary, '/summary')

class getSummary(Resource):
    def get(self):
        sum = db.session.query(Accounts.userBio).filter_by(id_user=1).first()
        return sum[0]


api.add_resource(getSummary, '/getSummary')

class UserSignUp(Resource):
    def put(self):
        name = request.form['name']
        surName = request.form['surName']
        usrEmail = request.form['email']
        unhashedPassword = request.form['password']
        # check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)

        # Make sure the email is not already taken
        if Accounts.query.filter_by(email=usrEmail).first() is None:
            createAccount = Accounts(email=usrEmail, name=name, surName=surName, \
                                     password=hashedPassword)

            # Add account to the database
            db.session.add(createAccount)
            db.session.commit()
            status = "success"

        else:
            status = "failed"
        return status


api.add_resource(UserSignUp, '/signup')


class TasksAdded(Resource):
    def put(self):
        Title = request.form['title']
        Description = request.form['description']
        Category = request.form['category']
        Et = request.form['et']
        Price = request.form['price']
        Location = request.form['location']
        Picture = request.form['picture']
        createTask = Tasks(title=Title, description=Description, category=Category, et=Et, price=Price,
                           location=Location, author=1, picture=Picture)
        db.session.add(createTask)
        db.session.commit()


api.add_resource(TasksAdded, '/addtask')


def generate_token(id, self, expiration=5000):
    s = Serializer(app.config['SECRET_KEY'], expires_in=expiration)
    return s.dumps({'id': id})


@auth.verify_password
def verify_password(username, password):
    s = Serializer(app.config['SECRET_KEY'])
    try:  #Check if username is a valid token
        loggedUser = s.loads(username)
        user = Accounts.query.filter_by(email=loggedUser).first()
        g.user = user.id_user

    except SignatureExpired:
        return None
    except BadSignature:  #     If invalid then check if username and password are a valid login
        if Accounts.query.filter_by(email=username).first() is not None:

            user = Accounts.query.filter_by(email=username).first()
            if check_password_hash(user.password, password):
                loggedUser = user.id_user
                g.user = loggedUser
                return loggedUser, generate_token(user.id_user)
            else:
                return None
        else:
            return None
    return loggedUser





class UserLogin(Resource):
    def post(self):


        usrEmail = request.form['email']
        unhashedPassword = request.form['password']
        # check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)


        #status = verify_password(usrEmail, unhashedPassword)
        #userToken = status[1]
        if False:
            status = 1
            print("Failed")
        else:
            print("Success")
            status = 0
            userToken = None
        return status, userToken


api.add_resource(UserLogin, '/login')


class TasksList(Resource):
    @auth.login_required
    def get(self):
        tasks = Tasks.query
        list = []
        for task in tasks:
            dict_task = {"title": task.title, "description": task.description, "et": task.et, "category": task.category,
                         "price": task.price, "location": task.location}
            list.append(dict_task)
        return list


api.add_resource(TasksList, '/tasks')


# TODO: Implement frontend for deletion
class AccountDeletion(Resource):
    @auth.login_required
    def put(self):
        accEmailToDelete = request.form['email']
        if Accounts.query.filter_by(email=accEmailToDelete).first() is not None:
            Accounts.query.filter_by(email=accEmailToDelete).delete()
            db.session.commit()
            return 'success'
        else:
            return 'failed'


api.add_resource(AccountDeletion, '/deleteaccount')


# Display skills to user, adding will be done with relational db in another class/func
class PostSkills(Resource):
    @auth.login_required
    def get(self):
        allSkills = Skills.query.all()
        skillList = []
        i = 0
        while i < len(allSkills):
            skilldict = {"id": allSkills[i].id, "name": allSkills[i].name, "description": allSkills[i].description}
            skillList.append(skilldict)
            i = i + 1

        return skillList


api.add_resource(PostSkills, '/postskills')


class AddUserSkill(Resource):
    @auth.login_required
    def put(self):
        usrid = request.form['userid']
        skillid = request.form['skill_id']
        print("Hmm:" + usrid + skillid)
        #if User_Skills.query.filter_by(id=usrid).first() is None:
        #addskill = Accounts.skills.append(id_user=usrid, id=skillid)
        #Accounts.append(id_user=usrid, id=skillid)
        theUser = Accounts.query.filter_by(id_user=usrid).first()
        theSkill = Skills.query.filter_by(id=skillid).first()
        theUser.skills.append(theSkill)
        # Add account to the database
        #db.session.add(addskill)
        db.session.commit()
        status = "success"
        if status == "success":

            return status

            #status = "failed"
    #return status
api.add_resource(AddUserSkill, '/adduserskill')

class GetUserSkills(Resource):
    def get(self):
        userSkills = Accounts.query.filter_by(id_user=1).all()
        skillList = []
        counter = 0
        for i in userSkills:
            for j in i.skills:
                print(i)
                skilldict = {"skill_id": j.name}
                print(skilldict)
                skillList.append(skilldict)
        return skillList
api.add_resource(GetUserSkills, '/getuserskill')

'''
class ListUserTasks(Resource):
    def post(self):
        allSkills = Skills.query.all()
        return allSkills

api.add_resource(TasksAdded, '/listusertasks')
'''

class ImageUpload(Resource):
    @auth.login_required


    def post(self):
        userID = db.session.query(Accounts.id_user).first()
        target = os.path.join(APP_ROOT, "%d/images/" % userID[0])

        if not os.path.isdir(target):
            os.makedirs(target)

        fileName = request.form['name']
        image = request.form['image']

        userAccount = Accounts.query.filter_by(id_user=1).first()
        userAccount.profile_pic = fileName
        db.session.commit()

        path = target + fileName
        def convert_and_save(b64_string):
            with open(path, "wb") as fh:
                fh.write(base64.decodebytes(b64_string.encode()))

        convert_and_save(image)



    def get(self):
        profile_PIC = db.session.query(Accounts.profile_pic).filter_by(id_user=1).first()
        userID = db.session.query(Accounts.id_user).first()
        filename = "%d/images/%s" % (userID[0], profile_PIC[0])
        return send_file(filename, mimetype="image/jpg")

api.add_resource(ImageUpload, "/imageUpload")


class ImageUploadTask(Resource):
    #@auth.login_required

    def post(self):
        userID = db.session.query(Accounts.id_user).first()
        target = os.path.join(APP_ROOT, "%s/tasks/" % userID[0])

        if not os.path.isdir(target):
            os.makedirs(target)

        fileName = request.form['name']
        image = request.form['image']

        if Tasks.query.filter_by(id=1).first() is not None:
            taskID = Tasks.query.filter_by(id=1).first()
            taskID.picture = fileName
            db.session.commit()

        path = target + fileName
        def convert_and_save(b64_string):
            with open(path, "wb") as fh:
                fh.write(base64.decodebytes(b64_string.encode()))

        convert_and_save(image)



    def get(self):
        task_PIC = db.session.query(Tasks.picture).filter_by(id=1).first()
        taskID = db.session.query(Tasks.id).first()
        filename = "./" + taskID[0] + "/tasks/" + task_PIC[0]
        return send_file(filename, mimetype="image/jpg")

api.add_resource(ImageUploadTask, "/imageUploadTask")
