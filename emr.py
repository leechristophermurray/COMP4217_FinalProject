from flask import Flask, request, redirect, render_template, url_for
import dataconnector

app = Flask(__name__)

app.config['SQL_HOST'] = 'localhost'
app.config['SQL_CRED'] = {}
app.config['SQL_DB'] = 'HOSPITAL'


@app.route('/', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        app.config.update(
            SQL_CRED=dict(USR=request.form['username'],
                          PWD=request.form['password'])
        )
        if app.config['SQL_CRED']['USR'] == '' or app.config['SQL_CRED']['PWD'] == '':
            error = 'Invalid Credentials. Please try again.'
        else:
            with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
                usr = con.login()
                return render_template('home.html', usr=usr)
    return render_template('login.html', error=error)


@app.route('/home/<usr>', methods=['GET', 'POST'])
def home(usr):
    try:
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            usr = con.login()
    except Exception as e:
        return render_template('home.html', error_msg=e)
    finally:
        return render_template('home.html', usr=usr + 'lol')


# CONTEXT PROCESSORS

@app.context_processor
def utility_processor():

    def get_doctors():
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            doctors = con.get_doctors()
        return doctors

    def get_nurses():
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            nurses = con.get_nurses()
        return nurses

    return {'get_doctors': get_doctors, 'get_nurses': get_nurses}
