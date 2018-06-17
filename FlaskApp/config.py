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
"Central configuration"
import os

PHOTOS_BUCKET = os.environ['PHOTOS_BUCKET']
FLASK_SECRET = os.environ['FLASK_SECRET']

DATABASE_HOST = os.environ['DATABASE_HOST']
DATABASE_USER = os.environ['DATABASE_USER']
DATABASE_PASSWORD = os.environ['DATABASE_PASSWORD']
DATABASE_DB_NAME = os.environ['DATABASE_DB_NAME']

AWS_REGION = "us-west-2"
COGNITO_POOL_ID = os.environ['COGNITO_POOL_ID']
COGNITO_CLIENT_ID = os.environ['COGNITO_CLIENT_ID']
COGNITO_CLIENT_SECRET = os.environ['COGNITO_CLIENT_SECRET']
COGNITO_DOMAIN = os.environ['COGNITO_DOMAIN']
BASE_URL = os.environ['BASE_URL']
