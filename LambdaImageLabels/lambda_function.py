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
"Lambda function for file upload events"
from __future__ import print_function
import json
import boto3
import mysql.connector

import config

def lambda_handler(event, context):
    "Process upload event, get labels and update database"
    s3_event = json.loads(event['Records'][0]["Sns"]["Message"])
    bucket = s3_event['Records'][0]["s3"]["bucket"]["name"]
    key = s3_event['Records'][0]["s3"]["object"]["key"]
    print("Received event. Bucket: [%s], Key: [%s]" % (bucket, key))

    rek = boto3.client('rekognition')
    response = rek.detect_labels(
        Image={
            'S3Object': {
                'Bucket': bucket,
                'Name': key
            }
        })
    all_labels = [label['Name'] for label in response['Labels']]
    csv_labels = ", ".join(all_labels)
    print("Detect_labels finished. Key: [%s], Labels: [%s]" % (key, csv_labels))

    conn = mysql.connector.connect(user=config.DATABASE_USER, password=config.DATABASE_PASSWORD,
                                   host=config.DATABASE_HOST,
                                   database=config.DATABASE_DB_NAME)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""SELECT object_key, description, labels, created_datetime
                      FROM photo WHERE object_key = %s""", (key,))
    result = cursor.fetchone()
    if result:
        print("Updating key:[%s] with labels:[%s]" % (key, csv_labels))
        conn.cursor().execute("UPDATE photo SET labels = %s WHERE object_key = %s",
                              (csv_labels, key))
        conn.commit()

    cursor.close()
    conn.close()
    return True

# This is used for debugging, it will only execute when run locally
if __name__ == "__main__":
    # simulated sns event
    fake_sns_event = {
        "Records": [
            {
                "EventSource": "aws:sns",
                "EventVersion": "1.0",
                "EventSubscriptionArn": "...",
                "Sns": {
                    "Message": """{\"Records\":[{\"eventVersion\":\"2.0\",
                    \"eventSource\":\"aws:s3\",\"awsRegion\":\"us-west-2\",
                    \"eventTime\":\"...\",\"eventName\":\"ObjectCreated:Put\",
                    \"s3\":{\"bucket\":{\"name\":\"fake-bucket\"},
                    \"object\":{\"key\":\"photos/8d2567bc34013c97.png\"}}}]}""",
                    "MessageAttributes": {}
                }
            }
        ]
    }
    fake_context = []
    lambda_handler(fake_sns_event, fake_context)
