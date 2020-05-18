#!/usr/bin/python3

import pymysql


class Connection:
    SQL_HOST = 'localhost'
    SQL_USR = ''
    SQL_PWD = ''
    SQL_DB = 'HOSPITAL'

    # initialize database object
    def __init__(self, usr, pwd):
        self.USR = usr
        self.PWD = pwd

    # return an database connection
    def __enter__(self):

        # Open database connection
        self.CON = pymysql.connect("localhost", self.USR, self.PWD, "HOSPITAL", autocommit=True)
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        # make sure the database connection gets closed
        self.CON.close()

    def get_doctors(self):
        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:

                # execute SQL query using execute() method.
                cursor.execute("CALL sp_get_doctors();")

                # Fetch all the tuples in a list of lists.
                data = cursor.fetchall()

        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data

    def get_nurses(self):
        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL sp_get_nurses();")

                # Fetch all the tuples in a list of lists.
                data = cursor.fetchall()

        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data

    def get_patients(self, q=""):
        data = ()
        results = []

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL get_patients('"+str(q)+"');")

                # Fetch all the tuples in a list of lists.
                data = cursor.fetchall()

        except pymysql.err.OperationalError as e:
            print(e)
            return data

        finally:
            return data

    def add_patient(self, fname, lname, dob, address, phone):
        data = ()

        try:
            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL sp_add_patient('" + fname + "', '" + lname + "', '" + str(dob) + "', '" + address +
                               "', " + str(phone) + ");")
            self.CON.commit()


        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data

    def make_diagnosis(self, docID, patID, icdID, icdDesc, icdname, specifics):
        data = ()

        try:
            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL make_diagnosis(" + str(docID) + ", " + str(patID) + ", " + str(icdID) + ", '" +
                               icdDesc + "', '" + str(icdname) + "', '" + specifics + "');")


        except pymysql.err.OperationalError as e:
            return data

        finally:
            self.CON.commit()
            return data

    def login(self):

        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:

                # execute SQL query using execute() method.
                cursor.execute("CALL sp_get_currentuser('" + self.USR + "');")

                # gets only one tuple from the database's response
                data = cursor.fetchone()

        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data

    def get_role(self):

        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:

                # execute SQL query using execute() method.
                cursor.execute("CALL sp_get_currentuser('" + self.USR + "');")

                # gets only one tuple from the database's response
                data = cursor.fetchone()

        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data
