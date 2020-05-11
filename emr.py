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
        app.config.update(
            SQL_USER = request.form['username'],
            SQL_PASSWORD = request.form['password']
        )
        if app.config['SQL_USER'] == '' or app.config['SQL_PASSWORD'] == '':
            error = 'Invalid Credentials. Please try again.'
        else:
            app.config.update(
                SQL_USER= dataconnector.login(username=app.config['SQL_USER'], password=app.config['SQL_PASSWORD'])
            )
            # print(result)
            return render_template('home.html', username=app.config['SQL_USER'])
    return render_template('login.html', error=error)


@app.route('/home/<username>', methods=['GET', 'POST'])
def home(username):
    x = 0
