from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return 'Index Page'

@app.route('/app')
def hello(username):
    return 'Hello, ' % escape(username)