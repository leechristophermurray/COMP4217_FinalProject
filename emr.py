import re
from flask import Flask, request, redirect, render_template, url_for, jsonify
import json
import dataconnector
import icdservice
import json

app = Flask(__name__)

app.config['SQL_HOST'] = 'localhost'
app.config['SQL_CRED'] = {'USR': '', 'PWD': ''}
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


@app.route('/autocomplete_icd', methods=['GET', 'POST'])
def autocomplete_icd():
    search = request.args.get('q')
    results = icdservice.search_term(search)
    final_result = []
    for result in results:
        text = re.sub('<[^<]+?>', '', result['title'])
        final_result.append({'value': result['id'], 'text': text})
    final_result = jsonify(final_result)
    return final_result


@app.route('/reg_patient', methods=['POST'])
def reg_patient():
    error = None
    if request.method == 'POST':
        if app.config['SQL_CRED']['USR'] == '' or app.config['SQL_CRED']['PWD'] == '':
            error = 'Invalid Credentials. Please try again.'
        else:
            with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
                con.add_patient(request.form['fname'], request.form['lname'], request.form['dob'],
                                request.form['address'], request.form['phone'])
                return render_template('home.html', usr=app.config['SQL_CRED']['USR'])
    return render_template('home.html', usr=app.config['SQL_CRED']['USR'])


# CONTEXT PROCESSORS

@app.context_processor
def utility_processor():
    def get_role():
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            tuple = con.get_role()
        return tuple

    def get_doctors():
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            doctors = con.get_doctors()
        return doctors

    def get_nurses():
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            nurses = con.get_nurses()
        return nurses

    def get_patients(q):
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            nurses = con.get_patients(q)
        return nurses

    return {'get_role': get_role, 'get_doctors': get_doctors, 'get_nurses': get_nurses, 'reg_patient': reg_patient, 'get_patients': get_patients}
