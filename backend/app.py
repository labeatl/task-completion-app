from flask import Flask, jsonify, request, render_template, make_response
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Resource, Api
from flask_migrate import Migrate
from flask import send_file, g
from itsdangerous import (TimedJSONWebSignatureSerializer as Serializer, BadSignature, SignatureExpired)
from itsdangerous.url_safe import URLSafeSerializer
import os
import base64
from flask_mail import Mail, Message
from flask_jwt_extended import (
    JWTManager, jwt_required, create_access_token,
    get_jwt_identity)




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

#Token stuff
app.config['JWT_SECRET_KEY'] = 's6e5BY5YtyzThru^yjGT6tfrgdj%^#'  # Change this!
jwt = JWTManager(app)


user_skills = db.Table('user_skills',
                       db.Column('id_user', db.Integer, db.ForeignKey('accounts.id_user'), primary_key=True),
                       db.Column('id', db.Integer, db.ForeignKey('skills.id'), primary_key=True,


                                 ))

app.config['MAIL_SERVER'] = "smtp.gmail.com"
app.config['MAIL_PORT'] = 465
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_DEFAULT_SENDER'] = "lendevelopmentmail@gmail.com"
app.config['MAIL_USERNAME'] = "lendevelopmentmail@gmail.com"
app.config['MAIL_PASSWORD'] = "PASSWORDHERE"
mail = Mail(app)

s = URLSafeSerializer("RYJ5k67yr57K%$YHErenT46wjrrtdrmnwtrdnt")
b = Serializer(app.config['SECRET_KEY'], expires_in=860000)


class Tasks(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(512), nullable=False)
    category = db.Column(db.String(20), nullable=False)
    et = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Integer, nullable=False)
    location = db.Column(db.String(20), nullable=False)
    picture = db.Column(db.String(80), nullable=True)
    owner_id = db.Column(db.Integer, db.ForeignKey("accounts.id_user"))
    task_completer = db.Column(db.Integer, db.ForeignKey("accounts.id_user"), nullable=True)


# TODO Move models to models file
class Accounts(db.Model):
    id_user = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    surName = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(50), nullable=False)
    password = db.Column(db.Text)
    userBio = db.Column(db.String(256), nullable=True)
    skills = db.relationship('Skills', secondary=user_skills, lazy='subquery', backref=db.backref('accounts.id_user', lazy=True))
    tasks = db.relationship('Tasks', backref='accounts')
    profile_pic = db.Column(db.String(200), nullable=True)
    confirmed = db.Column(db.Boolean, default=False)
    balance = db.Column(db.Integer)
    # profile_pic = db.relationship("ProfilePic", backref="acc", lazy=True)

class Transactions(db.Model):
    transaction_id = db.Column(db.Integer, primary_key=True)
    task = db.Column(db.Integer, db.ForeignKey('tasks.id'))
    issuer = db.Column(db.Integer, db.ForeignKey("accounts.id_user"))
    completer = db.Column(db.Integer, db.ForeignKey("accounts.id_user"))

class Task_Reports(db.Model):
    report_id = db.Column(db.Integer, primary_key=True)
    task = db.Column(db.Integer, db.ForeignKey('tasks.id'))
    reason = db.Column(db.String(200), nullable=True)

# class ProfilePic(db.Model):
#     filename = db.Column(db.String, primary_key=True)
#     person_id = db.Column(db.Integer, db.ForeignKey("acc.id"), nullable=False)
#
#
# class Tasks(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     taskName = db.Column(db.String, nullable=False)


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
     @jwt_required
     def post(self):
         summary = request.form['Summary']
         print("Identitiy is: " + get_jwt_identity())
         userAccount = Accounts.query.filter_by(id_user=get_jwt_identity()).first()
         userAccount.userBio = summary
         db.session.commit()
         return 'success'



api.add_resource(Summary, '/summary')

class getSummary(Resource):
    @jwt_required
    def get(self):
        sum = db.session.query(Accounts.userBio).filter_by(id_user=1).first()
        if sum == None:
            sum = "Tell us something about yourself"
        return sum


api.add_resource(getSummary, '/getSummary')


class apply(Resource):
    def put(self):
        Id = request.form['id']
        x = Tasks.query.filter_by(id = Id).first()
        applier = Accounts.filter_by(id_user=1).first()
        x.task_completer = applier.id_user
        db.session.commit()
        return 'success'


api.add_resource(apply, '/apply')


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
            encodedUser = s.dumps(usrEmail)
            msg = Message('Confirm Email',
                  recipients=[usrEmail])
            emailBody = "Plase click the link to confirm your email http://167.172.59.89:5000/" + encodedUser
            msg.body = emailBody
            mail.send(msg)

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
        owner = Accounts.query.filter_by(id_user=1).first()
        createTask = Tasks(title=Title, description=Description, category=Category, et=Et, price=Price, location=Location, picture=Picture, owner_id=owner.id_user)
        db.session.add(createTask)
        db.session.commit()

api.add_resource(TasksAdded, '/addtask')


def generate_token(id,expiration=86400):
    token = b.dumps(id)
    token = token.decode('utf-8')
    #token  = token.decode('utf8').replace("'", '"')
    return token


@auth.verify_password
def verify_password(username, password):
    print(username)
    try:  #Check if username is a valid token
        loggedUser = b.loads(username)
        authTokenConfirmed = create_access_token(identity=loggedUser)


    except SignatureExpired:
        return False
    except Exception as error:  #     If invalid then check if username and password are a valid login
        print(error)
        if Accounts.query.filter_by(email=username).first() is not None:

            user = Accounts.query.filter_by(email=username).first()
            if check_password_hash(user.password, password):
                loggedUser = user.id_user
                return [loggedUser, generate_token(user.id_user), create_access_token(identity=user.id_user)]
            else:
                return False
        else:
            return False

    return loggedUser, username, authTokenConfirmed



def getId(token):
    try:
        userId = b.loads(token)
    except Exception as error:
        print('Exception occured')
        return 'error'
    return userId



class UserLogin(Resource):
    def post(self):


        usrEmail = request.form['email']
        unhashedPassword = request.form['password']
        # check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)


        credentialCheck = verify_password(usrEmail, unhashedPassword)
        #userToken = status[1]
        if credentialCheck == False:
            status = 1
            print("Failed")
            returnList = {"status": status}

        else:
            print("Success")
            status = 0
            userToken = credentialCheck[1]
            authToken = credentialCheck[2]
            returnList = {"status": status, "userToken": userToken, "authToken" : authToken}
        return returnList


api.add_resource(UserLogin, '/login')


class TasksList(Resource):
    #@auth.login_required
    @jwt_required
    def get(self):
        tasks = Tasks.query
        list = []
        for task in tasks:
            dict_task = {"title": task.title, "description": task.description, "et": task.et, "category": task.category,
                         "price": task.price, "location": task.location, "id": task.id,}
            list.append(dict_task)
        return list


api.add_resource(TasksList, '/tasks')


class TaskDelete(Resource):
    def put(self):
        Id = request.form['id']
        Tasks.query.filter_by(id = Id).delete()
        db.session.commit()
        return 'success'

api.add_resource(TaskDelete, '/tDelete')

class TaskReplace(Resource):
    def put(self):
        Id = request.form['id']
        x = Tasks.query.filter_by(id = Id).first()
        x.title = request.form['title']
        x.description = request.form['description']
        x.et = request.form['et']
        x.price = request.form['price']
        x.location = request.form['location']
        x.category = request.form['category']
        db.session.commit()

api.add_resource(TaskReplace, '/tReplace')


# TODO: Implement frontend for deletion
class AccountDeletion(Resource):
    @jwt_required
    def put(self):
        accEmailToDelete = request.form['email']
        if Accounts.query.filter_by(is_user=get_jwt_identity()).first() is not None:
            Accounts.query.filter_by(id_user=get_jwt_identity()).delete()
            db.session.commit()
            return 'success'
        else:
            return 'failed'


api.add_resource(AccountDeletion, '/deleteaccount')


# Display skills to user, adding will be done with relational db in another class/func
class PostSkills(Resource):
    @jwt_required
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
    @jwt_required
    def put(self):
        usrid = request.form['userid']
        skillid = request.form['skill_id']
        print("Hmm:" + usrid + skillid)
        #if User_Skills.query.filter_by(id=usrid).first() is None:
        #addskill = Accounts.skills.append(id_user=usrid, id=skillid)
        #Accounts.append(id_user=usrid, id=skillid)
        theUser = Accounts.query.filter_by(id_user=get_jwt_identity()).first()
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
    @jwt_required
    def get(self):
        userSkills = Accounts.query.filter_by(id_user=get_jwt_identity()).all()
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



class uploadID(Resource):

    def post(self):
        print("biaaaatch")
        userID = db.session.query(Accounts.id_user).first()
        print("bitch")
        target = os.path.join(APP_ROOT, "%d/images/uploadID/" % userID[0])
        print(target)

        if not os.path.isdir(target):
            os.makedirs(target)

        fileName = request.form['name']
        image = request.form['image']

        path = target + fileName

        def convert_and_save(b64_string):
            with open(path, "wb") as fh:
                fh.write(base64.decodebytes(b64_string.encode()))

        convert_and_save(image)

api.add_resource(uploadID, "/uploadID")




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
            task = Tasks.query.filter_by(id=1).first()
            task.picture = fileName
            db.session.commit()

        path = target + fileName
        def convert_and_save(b64_string):
            with open(path, "wb") as fh:
                fh.write(base64.decodebytes(b64_string.encode()))

        convert_and_save(image)


    def get(self):

        userID = db.session.query(Accounts.id_user).first()
        task_PIC = db.session.query(Tasks.picture).filter_by(id=4).first()
        filename = "%d/tasks/%s" % (userID[0], task_PIC[0])
        return send_file(filename, mimetype="image/jpg")

api.add_resource(ImageUploadTask, "/imageUploadTask")

class PasswordResetRequest(Resource):
    def post(self):
        #Get user id from email,send email with encoded userId link. On link click call another method that decodes and allows pw changetest@test.com
        email = request.form['email']
        user = Accounts.query.filter_by(email=email).first()
        userID = user.id_user
        s = URLSafeSerializer("RYJ5k67yr57K%$YHErenT46wjrrtdrmnwtrdnt")
        encodedUser = s.dumps(user.id_user)
        msg = Message('Confirm Email',
                  recipients=[user.email])
        emailBody = "Plase click the link to confirm your email http://167.172.59.89:5000/reset/" + encodedUser
        msg.body = emailBody
        mail.send(msg)

api.add_resource(PasswordResetRequest, "/resetpassword")


@app.route("/reset/<string:reset_id>", methods=['GET', 'POST'])
def resetpassword(reset_id):
    headers = {'Content-Type': 'text/html'}
    decoded = s.loads(reset_id)
    user = Accounts.query.filter_by(id_user=decoded).first()
    if request.method == 'POST':
        password = request.form['password']
        newPassword = request.form['password']
        hashedPassword = generate_password_hash(newPassword)
        user.password = hashedPassword
        db.session.commit()
        return 'Password Reset'

    return make_response(render_template('resetpassword.html'),200,headers)




class ConfirmEmail(Resource):
    def get(self, reset_id):
        resetID = reset_id
        decoded = s.loads(resetID)
        confirmUser = Accounts.query.filter_by(email=decoded).first()
        confirmUser.confirmed = True
        db.session.commit()
        return 'Email Confirmed'

api.add_resource(ConfirmEmail, "/<string:reset_id>")



class PostUserTasks(Resource):
    @jwt_required
    def get(self):
        user = Tasks.query.filter_by(owner_id=get_jwt_identity()).all()
        userTaskList = []
        i = 0
        while i < len(user):
            dict_task = {"title": user[i].title, "description": user[i].description, "et": user[i].et, "category": user[i].category,
                         "price": user[i].price, "location": user[i].location, "id": user[i].id,}
            userTaskList.append(dict_task)
            i = i + 1
        return userTaskList

api.add_resource(PostUserTasks, '/postUserTasks')



class FilteringTasks(Resource):
    def post(self):
        category = request.form["Category"]
        min_et = request.form["et_min"]
        max_et = request.form["et_max"]
        min_price = request.form["min_price"]
        max_price = request.form["max_price"]
        location = request.form["Location"]

        tasks = Tasks.query.filter_by(location=location, category=category).all()

        list = []
        for task in tasks:
            dict_task = {"title": task.title, "description": task.description, "et": task.et, "category": task.category,
                         "price": task.price, "location": task.location, "id": task.id,}
            list.append(dict_task)

        return list

api.add_resource(FilteringTasks, '/filtering')

class Balance(Resource):
    def get(self):
        user = Accounts.query.filter_by(id_user=1).first()
        user_balance = user.balance
        return  {"balance": user_balance}
    def put(self):
        balance = request.form["balance"]
        user = Accounts.query.filter_by(id_user=1).first()
        user.balance = balance
api.add_resource(Balance, "/balance")

class ReportTask(Resource):
    def post(self):

        taskId = int(request.form["task_id"])
        reportReason = request.form["reason"]
        flaggedTask = Tasks.query.filter_by(id=taskId).first()
        reportTask = Task_Reports(task=taskId, reason=reportReason)
        db.session.add(reportTask)

        db.session.commit()
        return "Task Reported"

api.add_resource(ReportTask, "/reporttask")


@app.route("/administration", methods=['GET', 'POST'])
def administration():

    reportedTasks = Task_Reports.query.with_entities(Task_Reports.task, Task_Reports.reason).all()
    reportedTaskId = [task for task in reportedTasks]
    reportedTaskList = []
    for id in reportedTaskId:
        task  = Tasks.query.filter_by(id=int(id.task)).first()
        title = task.title
        description = task.description
        location = task.location
        price = task.price
        reportedTaskList.append({'id':int(id.task), 'title':title, 'description':description, 'location': location,'price':price,})

    if request.method == 'POST':

        if request.form.get('Delete'):
            deleteRequestedTask = Tasks.query.filter_by(id=request.form.get('Delete')).delete()
            deleteReport = Task_Reports.query.filter_by(task=request.form.get('Delete')).delete()
            db.session.commit()
            return 'task deleted'
        elif request.form.get('Ignore'):
            deleteReport = Task_Reports.query.filter_by(task=request.form.get('Ignore')).delete()
            db.session.commit()
            return 'task ignored'




    return make_response(render_template('adminpanel.html', reportedList=reportedTaskList),200)


class GetName(Resource):
    print("bllablla")
    def get(self):
        user = Accounts.query.filter_by(name="labi").first()
        print(user)
        userN= user.name
        print(userN)
        user_name= user.name
        print(user)
        return user_name

api.add_resource(GetName, '/getName')