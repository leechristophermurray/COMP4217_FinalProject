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

    def GetMedicineAllergyByMostPatients(self):
        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL GetMedicineAllergyByMostPatients();")

                # Fetch all the tuples in a list of lists.
                data = cursor.fetchall()

        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data

    def GetInternsByMostPatient(self):
        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL GetInternsByMostPatient();")

                # Fetch all the tuples in a list of lists.
                data = cursor.fetchall()

        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data

    def GetInternPerformanceData(self):
        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL GetInternPerformanceData();")

                # Fetch all the tuples in a list of lists.
                data = cursor.fetchall()

        except pymysql.err.OperationalError as e:
            return data

        finally:
            return data

    def get_patients(self, q=""):
        data = ()

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

    def GetPatientByDiagnosisAndDate(self, start_date, end_date, diagnosis=""):
        data = ()

        # prepare a cursor object using cursor() method
        with self.CON.cursor() as cursor:

            # execute SQL query using execute method
            cursor.execute("CALL GetPatientByDiagnosisAndDate('" + str(start_date) + "', '"
                            + str(end_date) + "', '" + str(diagnosis) + "');")

            # fetch all the tuples in a list of lists
            data = cursor.fetchall()
        return data

    def get_allergens_of_patient(self, patID):
        data = ()

        try:

            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL get_allergens_of_patient('"+str(patID)+"');")

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

    def check_vitals(self, nurseID, patID, temp, pulse_arg, bp, resp):
        data = ()

        try:
            # prepare a cursor object using cursor() method
            with self.CON.cursor() as cursor:
                # execute SQL query using execute() method.
                cursor.execute("CALL check_vitals(" + str(nurseID) + ", " + str(patID) + ", " + str(temp) + ", '" +
                               str(pulse_arg) + "', '" + str(bp) + "', '" + str(resp) + "');")


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

    def GetNursesByPatientAndDate(self, start_date, end_date, pat_ID):
        data = ()

        # prepare a cursor object using cursor() method
        with self.CON.cursor() as cursor:

            # execute SQL query using execute method
            cursor.execute("CALL GetNursesByPatientAndDate('" + str(start_date) + "', '"
                            + str(end_date) + "', '" + str(pat_ID) + "');")

            # fetch all the tuples in a list of lists
            data = cursor.fetchall()
        return data

    def get_allergens_of_patient(self,patID):
        data = ()

        # prepare a cursor object using cursor() method
        with self.CON.cursor() as cursor:

            # execute SQL query using execute method
            cursor.execute("CALL get_allergens_of_patient('" + str(patID) + "');")

            # fetch all the tuples in a list of lists
            data = cursor.fetchall()
        return data

    def get_medicine_allergy_by_most_patients(self):
        data = ()

        # prepare a cursor object using cursor() method
        with self.CON.cursor() as cursor:

            # execute SQL query using execute method
            cursor.execute("CALL get_medicine_allergy_by_most_patients();")

            # fetch all the tuples in a list of lists
            data = cursor.fetchall()
        return data

    def GetResultsByPatient(self,patID):
        data = ()

        # prepare a cursor object using cursor() method
        with self.CON.cursor() as cursor:

            # execute SQL query using execute method
            cursor.execute("CALL GetResultsByPatient('" + str(patID) + "');")

            # fetch all the tuples in a list of lists
            data = cursor.fetchall()
        return data

    def get_nurses_by_patient_and_date(self,start_date, end_date, patID):
        data = ()

        # prepare a cursor object using cursor() method
        with self.CON.cursor() as cursor:

            # execute SQL query using execute method
            cursor.execute("CALL get_nurses_by_patient_and_date('" + str(start_date) + "', '" + str(end_date) + "', '"
                            + str(patID) + "');")

            # fetch all the tuples in a list of lists
            data = cursor.fetchall()
        return data

    def get_interns_by_most_patients(self):
        data = ()

        # prepare a cursor object using cursor() method
        with self.CON.cursor() as cursor:

            # execute SQL query using execute method
            cursor.execute("CALL get_interns_by_most_patients();")

            # fetch all the tuples in a list of lists
            data = cursor.fetchall()
        return data
