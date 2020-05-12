#!/usr/bin/python3

import pymysql


def get_doctors():
    # Open database connection
    connection = pymysql.connect("localhost", "sysAdmin", "sysAdmin123", "HOSPITAL")
    data = ()

    try:

        # prepare a cursor object using cursor() method
        with connection.cursor() as cursor:

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

        # disconnect from server
        connection.close()


def login(username, password):
    # Open database connection
    connection = pymysql.connect("localhost", username, password, "HOSPITAL")
    data = ()

    try:

        # prepare a cursor object using cursor() method
        with connection.cursor() as cursor:

            # execute SQL query using execute() method.
            cursor.execute("SELECT current_user();")

            # Fetch a single row using fetchone() method.
            # data = cursor.fetchone()

            data = cursor.fetchone()
            print(data[0])
            # access from data as below
            # for doc_record in data:
            #     print("fname: {0}, lname: {1}".format(doc_record[0], doc_record[1]))
            data = data[0].replace('localhost', '').replace('@', '').replace('%', '')
            print(data)

    finally:
        return data

        # disconnect from server
        connection.close()
