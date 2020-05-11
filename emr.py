from flask import Flask, request, redirect, render_template, url_for

app = Flask(__name__)


@app.route('/')
def index():
    return 'Index Page'


@app.route('/app')
def hello(username):
    return 'Hello, ' % str(username)


@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != 'admin' or request.form['password'] != 'admin':
            error = 'Invalid Credentials. Please try again.'
        else:
            print(request.form['username'])
            return redirect(url_for('home'))
    return render_template('login.html', error=error)


@app.route('/home', methods=['GET', 'POST'])
def home():
    error = None
    if request.method == 'POST':
        if request.form['username'] != 'admin' or request.form['password'] != 'admin':
            error = 'Invalid Credentials. Please try again.'
        else:
            print(request.form['username'])
            return redirect(url_for('home'))
    return render_template('login.html', error=error)