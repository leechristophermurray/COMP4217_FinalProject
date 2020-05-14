import os

os.environ["FLASK_APP"] = "emr.py"
os.environ["FLASK_DEBUG"] = "1"
os.system('python -m flask run')