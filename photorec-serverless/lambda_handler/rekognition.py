import json

from config import get_config
from database import create_db
from repository.photo import RepoPhoto
from repository.tag import RepoTag
from services.recognition import ServiceRekognition
from use_cases.detect_photo_tag import DetectPhotoTag


def handler(event, context):
    try:
        message = json.loads(event['Records'][0]['Sns']['Message'])
        photo_key = message['Records'][0]['s3']['object']['key']
    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps(f"Can't parse event message: {event}")
        }

    config = get_config()
    db = create_db(config)

    print(f"Get tag for photo: {photo_key} with config: {config}")

    use_case = DetectPhotoTag(
        repo__photo=RepoPhoto(db, config),
        repo__tag=RepoTag(db, config),
        service__rekognition=ServiceRekognition(config)
    )
    photo_tag = use_case.execute(photo_key=photo_key)

    return {
        'statusCode': 200,
        'body': json.dumps(f'Successfully added tag {photo_tag} for: {photo_key}')
    }
