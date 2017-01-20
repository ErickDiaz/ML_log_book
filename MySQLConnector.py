#impot MySQL client library
import pymysql.cursors
import sys


class MySQLConnector:

    def __init__(self, password, db, charset, host='127.0.0.1', user='root'):
        self.host = host
        self.user = user
        self.password = password
        self.db = db
        self.charset = charset

    # Connect to the database
    def initConnection(self):
        self.connection = pymysql.connect(host= self.host,
                                     user= self.user,
                                     password= self.password,
                                     db= self.db,
                                     charset= self.charset,
                                     cursorclass=pymysql.cursors.DictCursor)

    # Close the connection to the database
    def closeConnection(self):
        self.connection.close()

    # Insert data
    def insertData(self, tablename, **kwargs):
        try:
            query = "INSERT INTO " + tablename + " ("
            colNames = ""
            values = ""
            for key in kwargs:
                colNames += "`" + key + "`" + ", "
                if isinstance(kwargs[key], int):
                    values += str(kwargs[key]) + ", "
                else:
                    values += "'" + str(kwargs[key]) + "'" + ", "

            query += colNames[:-2] + ") VALUES (" + values[:-2] + ");"
            #print(query)  #debug
            with self.connection.cursor() as cursor:
                # Create a new record
                cursor.execute(query)

            # connection is not autocommit by default. So you must commit to save your changes.
            self.connection.commit()
        except:
            print (":( Unexpected error:", sys.exc_info()[0])
            raise


    def printQuery(self):
        try:
            with self.connection.cursor() as cursor:
                # Read a single record
                sql = "SELECT * from ClassificationExperiment limit 2;"
                cursor.execute(sql)
                result = cursor.fetchone()
                print(result)
        except:
            print (":( Unexpected error:", sys.exc_info()[0])
            raise