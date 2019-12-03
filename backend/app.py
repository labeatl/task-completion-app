from flask import Flask, jsonify, request
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)
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

api.add_resource(TasksAdded, '/addTask')

class UserLogin(Resource):
    def post(self):
        #request.form("data")
        loginData = request.get_json()

        #signUpData['name']
        usrEmail = request.form['email']
        unhashedPassword = request.form['password']
        #check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)

        #Make sure the email is not already taken
        if Accounts.query.filter_by(email=usrEmail,password=hashedPassword).first() is  None:
            #Login and send token
            
            

            #Add account to the database
            status = 0
        else: 
            status = 1
        return status


api.add_resource(UserLogin, '/login')

