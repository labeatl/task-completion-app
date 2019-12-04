from flask import Flask, jsonify, request
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Resource, Api
from flask_marshmallow import Marshmallow
from marshmallow import Schema, fields
from marshmallow import pprint

app = Flask(__name__)
api = Api(app)
ma = Marshmallow(app)

#Database connection information

dbParam = 'mysql+pymysql://task:LENDev201912@localhost/taskr'
app.config['SQLALCHEMY_DATABASE_URI'] = dbParam

#Flask secret key
theKey = 'thEejrdaR5$wE3yY4wsehn4wASHR'

db = SQLAlchemy(app)

class Accounts(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20), nullable=False)
    surName = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(50), nullable=False)
    password = db.Column(db.Text)


class Tasks(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(20), nullable=False)
    category = db.Column(db.String(20), nullable=False)
    et = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Integer, nullable=False)
    location = db.Column(db.String(20), nullable=False)


#tasksSchema = Schema.from_dict(
#    {"description": fields.String()}
#)

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
        #check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)

        #Make sure the email is not already taken
        if Accounts.query.filter_by(email=usrEmail).first() is None:
            createAccount = Accounts(email=usrEmail, name=name, surName=surName, \
            password=hashedPassword)

            #Add account to the database
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
        createTask = Tasks(title=Title, description=Description, category=Category, et=Et, price=Price, location=Location)
        db.session.add(createTask)
        db.session.commit()

api.add_resource(TasksAdded, '/addtask')

class UserLogin(Resource):
    def post(self):
        usrEmail = request.form['email']
        unhashedPassword = request.form['password']
        #check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)

        #Make sure the email exists
        if Accounts.query.filter_by(email=usrEmail).first() is  not None:
            user = Accounts.query.filter_by(email=usrEmail).first()
            if check_password_hash(user.password, unhashedPassword):
                status = 0
                print("Correct password")
            else:
                status = 1
                print("InCorrect Password")

            #Add account to the database
        else: 
            status = 1
            print("Email does not exist")
        return status


api.add_resource(UserLogin, '/login')



TasksSchema = Schema.from_dict(
    {"title": fields.Str(), "description": fields.Str(), "et": fields.Integer(), "category": fields.Str(), "price": fields.Integer(), "location": fields.Str()}
)

class TasksList(Resource):
    def get(self):
        tasks = Tasks.query
        list = []
        for task in tasks:
            dict_task = {"title": task.title, "description": task.description, "et": task.et, "category": task.category, "price": task.price, "location": task.location}
            print(dict_task["title"])
            list.append(dict_task)
        return list

api.add_resource(TasksList, '/tasks')



#TODO: Implement frontend for deletion
class AccountDeletion(Resource):
    def put(self):
        accEmailToDelete = request.form['email']
        if Accounts.query.filter_by(email=accEmailToDelete).first() is not None:
            Accounts.query.filter_by(email=accEmailToDelete).delete()
            db.session.commit()
            return 'success'
        else :
            return 'failed'
        
api.add_resource(AccountDeletion, '/deleteaccount')

