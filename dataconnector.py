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
            cursor.execute("CALL getDoctors();")

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
