import json


def handler(event, context):
    print("Hello from Lambda!")
    print(event)
    print(context)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
