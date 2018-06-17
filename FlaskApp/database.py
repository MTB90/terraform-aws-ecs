# Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except
# in compliance with the License. A copy of the License is located at
#
# https://aws.amazon.com/apache-2-0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
"Database layer"
import mysql.connector
import config

def list_photos(cognito_username):
    "Select all the photos from the database"
    conn = get_database_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""SELECT object_key, description, labels, created_datetime
        FROM photo WHERE cognito_username = %s
        ORDER BY created_datetime desc""", (cognito_username,))
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result

def add_photo(object_key, labels, description, cognito_username):
    "Add a photo to the database"
    conn = get_database_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""INSERT INTO photo (object_key, labels, description, cognito_username) VALUES
    (%s, %s, %s, %s);""", (object_key, labels, description, cognito_username))
    conn.commit()
    cursor.close()
    conn.close()

def delete_photo(object_key, cognito_username):
    "Delete a photo.  Users can only delete their photos!"
    conn = get_database_connection()
    cursor = conn.cursor()
    cursor.execute("""DELETE FROM photo WHERE object_key = %s AND cognito_username = %s;""",
                   (object_key, cognito_username))
    conn.commit()
    cursor.close()
    conn.close()

def get_database_connection():
    "Build a database connection"
    conn = mysql.connector.connect(user=config.DATABASE_USER, password=config.DATABASE_PASSWORD,
                                   host=config.DATABASE_HOST,
                                   database=config.DATABASE_DB_NAME,
                                   use_pure=True) # see https://bugs.mysql.com/90585
    return conn
