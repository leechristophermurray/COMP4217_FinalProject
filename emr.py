from flask import Flask, request, redirect, render_template, url_for
import dataconnector

app = Flask(__name__)


app.config['SQL_HOST'] = 'localhost'
app.config['SQL_USER'] = ''
app.config['SQL_PASSWORD'] = ''
app.config['SQL_DB'] = 'HOSPITAL'


@app.route('/', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username == '' or password == '':
            error = 'Invalid Credentials. Please try again.'
        else:
            result = dataconnector.login(username=username, password=password)
            # print(result)
            return render_template('home.html', username=result)
    return render_template('login.html', error=error)


@app.route('/home/<username>', methods=['GET', 'POST'])
def home(username):
    x = 0
