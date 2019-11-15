from flask import Flask, jsonify
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import generate_password_hash, check_password_hash
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

#Database connection information
dbParam = 'mysql+pymysql://root@localhost/taskr'

#Flask secret key
theKey = 'thEejrdaR5$wE3yY4wsehn4wASHR'

db=SQLAlchemy(app)

class Accounts(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    surName = db.Column(db.String)
    email = db.Column(db.String)
    password = db.Column(db.String)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/signup', methods['GET','POST'])
def usr_signup():
    
    if request.method == 'POST':
    #implement  'on_json_loading_failed()'
        signUpData =  request.get_json()

        #signUpData['name']
        name = signUpData['name']
        surName = signUpData['surName']
        usrEmail = signUpData['email']
        unhashedPassword = signUpData['password']
        #check password is same on frontend
        hashedPassword = generate_password_hash(unhashedPassword)

        #Make sure the email is not already taken
        if Accounts.query.filter_by(email=email).first() is None:
            createAccount = Accounts(email=email, name=name, surName=surName \
             password=hashedPassword )

            #Add account to the database
             db.session.add(createAccount)
             db.session.commit()
             status = 'success'

        else: 
            status = 'failed'
    else: 
        status = jsonify('failed')



    return status

@app.route('/login')
def usr_login():
    return 0


