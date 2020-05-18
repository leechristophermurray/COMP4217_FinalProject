import re
from flask import Flask, request, redirect, render_template, url_for, jsonify
import json
import dataconnector
import icdservice
import datetime
from datetime import datetime
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
                return render_template('home.html', usr=usr[0])
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


@app.route('/get_patients/', methods=['GET', 'POST'])
def get_patients():
    search = request.args.get('search')
    # print(search)
    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
        pats = con.get_patients(search)
        columns = ['pat_ID', 'fname', 'lname', 'dob', 'address', 'phone']
        pats = jsonify([{k: str(val) for val, k in zip(row, columns)} for row in pats])
        print(pats)
    return pats


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


@app.route('/make_diagnosis', methods=['POST'])
def make_diagnosis():
    error = None

    # docID = request.form['docID']
    patID = request.form['patID']
    icdID = request.form['icdID']
    # icdDesc = request.form['desc']
    icdname = request.form['desc']  # icdname
    specifics = request.form['specs']

    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
        usr = con.login()
        docID = usr[1]

    icdDesc = icdservice.get_entity_description(icdID)

    if request.method == 'POST':
        if app.config['SQL_CRED']['USR'] == '' or app.config['SQL_CRED']['PWD'] == '':
            error = 'Invalid Credentials. Please try again.'
        else:
            with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
                print(docID, patID, icdID, icdDesc, icdname, specifics)
                con.make_diagnosis(docID, patID, icdID, icdDesc, icdname, specifics)
                return render_template('home.html', usr=app.config['SQL_CRED']['USR'])
    return render_template('home.html', usr=app.config['SQL_CRED']['USR'])


@app.route('/get_patient_by_diagnosis_and_date', methods=['GET', 'POST'])
def get_patient_by_diagnosis_and_date():
    search = request.args.get('search')
    # print(search)
    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
        pats = con.get_patient_by_diagnosis_and_date(request.form['start_date'], request.form['end_date'],
                                                     request.form['diag_ID'])
        columns = ['pat_ID', 'fname', 'lname', 'dob', 'address', 'phone']
        pats = jsonify([{k: str(val) for val, k in zip(row, columns)} for row in pats])
        print(pats)
        return pats


@app.route('/get_allergens_of_patient', methods=['GET', 'POST'])
def get_allergens_of_patient():
    search = request.args.get('search')
    # print(search)
    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
        allergens = con.get_allergens_of_patient(request.form['patID'])
        columns = ['Allergen']
        allergens = jsonify([{k: str(val) for val, k in zip(row, columns)} for row in allergens])
        print(allergens)
        return allergens


@app.route('/get_medicine_allergy_by_most_patients', methods=['GET', 'POST'])
def get_medicine_allergy_by_most_patients():
    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
        # DO WE NEED THIS?
        med_allergies = con.get_medicine_allergy_by_most_patients(request.form['patID'])
        columns = ['med_ID', 'gen_name']
        med_allergies = jsonify([{k: str(val) for val, k in zip(row, columns)} for row in med_allergies])
        print(med_allergies)
        return med_allergies


@app.route('/get_results_by_patient', methods=['GET', 'POST'])
def get_results_by_patient():
    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
        pat_results = con.get_results_by_patient(request.form['patID'])
        columns = ['test_result', 'scn_img_ID']
        pat_results = jsonify([{k: str(val) for val, k in zip(row, columns)} for row in pat_results])
        print(pat_results)
        return pat_results


@app.route('/get_nurses_by_patient_and_date', methods=['GET', 'POST'])
def get_nurses_by_patient_and_date():
    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
        nurses = con.get_nurses_by_patient_and_date(request.form['start_date'], request.form['end_date'],
                                                    request.form['patID'])
        columns = ['nurse_id', 'fname', 'lname']
        nurses = jsonify([{k: str(val) for val, k in zip(row, columns)} for row in nurses])
        print(nurses)
        return nurses


@app.route('/get_interns_by_most_patients', methods=['GET', 'POST'])
def get_interns_by_most_patients():
    with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['USR']) as con:
        # DO WE NEED THIS?
        interns = con.get_interns_by_most_patients(request.form['start_date'], request.form['end_date'],
                                                   request.form['patID'])
        columns = ['fname', 'lname']
        interns = jsonify([{k: str(val) for val, k in zip(row, columns)} for row in interns])
        print(interns)
        return interns


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

    def get_patients(q=""):
        with dataconnector.Connection(app.config['SQL_CRED']['USR'], app.config['SQL_CRED']['PWD']) as con:
            pats = con.get_patients(q)
            # columns = ['pat_ID', 'fname', 'lname', 'dob', 'address', 'phone']
            pats = [[str(val) for val in row] for row in pats]
            # print(pats)
            # print(type(pats))
        return pats

    return {'get_role': get_role, 'get_doctors': get_doctors, 'get_nurses': get_nurses, 'reg_patient': reg_patient,
            'get_patients': get_patients}
