from flask import Flask, jsonify, request, render_template
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Resource, Api
from flask_migrate import Migrate
import os, base64
from flask import send_file

app = Flask(__name__)
api = Api(app)
APP_ROOT = os.path.dirname(os.path.abspath(__file__))
# Database connection information

dbParam = 'mysql+pymysql://taskuser:LENAnalytics2019@localhost/taskr'
app.config['SQLALCHEMY_DATABASE_URI'] = dbParam

# Flask secret key
theKey = 'thEejrdaR5$wE3yY4wsehn4wASHR'

db = SQLAlchemy(app)

migrate = Migrate(app, db)

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
    picture = db.Column(db.String(80), nullable=False)


# Adding skill: INSERT INTO skills *press enter* VALUE (0,'Programming','Building stuff with electrical impulses');
class Skills(db.Model):
    id = db.Column(db.Integer, primary_key=True, )
    name = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(50), nullable=False)



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
        createTask = Tasks(title=Title, description=Description, category=Category, et=Et, price=Price,
                           location=Location,author=1)
        db.session.add(createTask)
        db.session.commit()


api.add_resource(TasksAdded, '/addtask')


class UserLogin(Resource):
    def post(self):
        usrEmail = request.form['email']
        unhashedPassword = request.form['password']
        # check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)

        # Make sure the email exists
        if Accounts.query.filter_by(email=usrEmail).first() is not None:
            user = Accounts.query.filter_by(email=usrEmail).first()
            if check_password_hash(user.password, unhashedPassword):
                status = 0
                print("Correct password")
            else:
                status = 1
                print("InCorrect Password")

            # Add account to the database
        else:
            status = 1
            print("Email does not exist")
        return status


api.add_resource(UserLogin, '/login')


class TasksList(Resource):
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
    def get(self):
        allSkills = Skills.query.all()
        skillList = []
        for i in allSkills:
            skilldict = {"id": i.id, "name": i.name, "description": i.description}
            skillList.append(skilldict)

        return skillList


api.add_resource(PostSkills, '/postskills')


class AddUserSkill(Resource):
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
        for i in userSkills:
            skilldict = {"skill_id": i.skills[0].name}
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
    def post(self):
        userID = db.session.query(Accounts.id_user).first()
        target = os.path.join(APP_ROOT, "%s/images/" % userID[0])

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
        filename = "/%d/images/%s" % (userID[0], profile_PIC[0])
        return send_file(filename, mimetype="image/jpg")

api.add_resource(ImageUpload, "/imageUpload")


class ImageUploadTask(Resource):
    def post(self):
        userID = db.session.query(Accounts.id_user).first()
        target = os.path.join(APP_ROOT, "%s/tasks/" % userID[0])

        if not os.path.isdir(target):
            os.makedirs(target)

        fileName = request.form['name']
        image = request.form['image']

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
        filename = "/" + taskID[0] + "/tasks/" + task_PIC[0]
        return send_file(filename, mimetype="image/jpg")

api.add_resource(ImageUploadTask, "/imageUploadTask")