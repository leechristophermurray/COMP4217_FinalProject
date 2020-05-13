#!/usr/bin/python3

import pymysql


class Connection:
    SQL_HOST = 'localhost'
    SQL_USR = ''
    SQL_PWD = ''
    SQL_DB = 'HOSPITAL'

    # return an database connection
    def __init__(self, usr, pwd):
        self.USR = usr
        self.PWD = pwd

    # return an database connection
    def __enter__(self):

        # Open database connection
        self.CON = pymysql.connect("localhost", self.USR, self.PWD, "HOSPITAL")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        # make sure the dbconnection gets closed
        self.CON.close()

    def get_doctors(self):
        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:

                # execute SQL query using execute() method.
                cursor.execute("CALL sp_get_doctors();")

                # Fetch a single row using fetchone() method.
                # data = cursor.fetchone()

                # Fetch all the rows in a list of lists.
                data = cursor.fetchall()

                # access from data as below
                # for doc_record in data:
                #     print("fname: {0}, lname: {1}".format(doc_record[0], doc_record[1]))

                return data

        finally:
            return data

    def login(self):

        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:

                # execute SQL query using execute() method.
                cursor.execute("SELECT current_user();")

                # Fetch a single row using fetchone() method.
                # data = cursor.fetchone()

                data = cursor.fetchone()
                # access from data as below
                # for doc_record in data:
                #     print("fname: {0}, lname: {1}".format(doc_record[0], doc_record[1]))
                data = data[0].replace('localhost', '').replace('@', '').replace('%', '')

        finally:
            return data
