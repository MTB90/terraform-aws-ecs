import json

from config import get_config
from services.image import ServiceImage
from services.random import ServiceRandom
from services.storage import ServiceStorageS3
from use_cases.create_thumbnail import CreateThumbnail


def handler(event, context):
    message = json.loads(event['Records'][0]['Sns']['Message'])
    photo_key = message['Records'][0]['s3']['object']['key']

    if not photo_key:
        return {
            'statusCode': 400,
            'body': json.dumps(f'Object key : {photo_key}')
        }

    config = get_config()

    print(f"Start create thumbnail: {photo_key} with config: {config}")
    use_case = CreateThumbnail(
        service__image=ServiceImage(),
        service__storage=ServiceStorageS3(
            config=config,
            service__random=ServiceRandom()
        )
    )
    use_case.execute(photo_key=photo_key)

    return {
        'statusCode': 200,
        'body': json.dumps(f'Successfully added new thumbnail for: {photo_key}')
    }
