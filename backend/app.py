from flask import Flask, jsonify, request
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Resource, Api
from flask_migrate import Migrate

app = Flask(__name__)
api = Api(app)

# Database connection information

dbParam = 'mysql+pymysql://taskuser:LENAnalytics2019@localhost/taskr'
app.config['SQLALCHEMY_DATABASE_URI'] = dbParam

# Flask secret key
theKey = 'thEejrdaR5$wE3yY4wsehn4wASHR'

db = SQLAlchemy(app)

migrate = Migrate(app, db)


# TODO Move models to models file
class Accounts(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    surName = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(50), nullable=False)
    password = db.Column(db.Text)
    userBio = db.Column(db.String(256), nullable=False)


class Tasks(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(512), nullable=False)
    category = db.Column(db.String(20), nullable=False)
    et = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Integer, nullable=False)
    location = db.Column(db.String(20), nullable=False)
    author = db.Column(db.Integer, primary_key=True)  # link to user


# Adding skill: INSERT INTO skills *press enter* VALUE (0,'Programming','Building stuff with electrical impulses');
class Skills(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(50), nullable=False)


class User_Skills(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)  # link to user
    skill_id = db.Column(db.Integer, nullable=False)  # link to skill
    skillLevel = db.Column(db.Integer, nullable=False)  # On scale of 1 to 10


class hello(Resource):
    def get(self):
        return 'live'


api.add_resource(hello, '/')


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
                           location=Location)
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
        #if User_Skills.query.filter_by(id=usrid).first() is None:
        addskill = User_Skills(user_id=usrid, skill_id=skillid, skillLevel=10)

        # Add account to the database
        db.session.add(addskill)
        db.session.commit()
        status = "success"
        if status == "success":

            return status

            #status = "failed"
    #return status



api.add_resource(AddUserSkill, '/adduserskill')
'''
class ListUserTasks(Resource):
    def post(self):
        allSkills = Skills.query.all()
        
        return allSkills

api.add_resource(TasksAdded, '/listusertasks')
'''
