import json
import os
from typing import NamedTuple

from photorec.services.image import ServiceImage
from photorec.services.random import ServiceRandom
from photorec.services.storage import ServiceStorageS3
from photorec.use_cases.create_thumbnail import CreateThumbnail


class ConfigEnvironment(NamedTuple):
    FILE_STORAGE: str


def get_config_env(config_class):
    config_class.AWS_ENDPOINTS = {}
    config = {}
    for key in config_class._fields:
        item = os.environ[key]
        config[key] = item
    return config_class(**config)


def handler(event, context):
    try:
        message = json.loads(event['Records'][0]['Sns']['Message'])
        photo_key = message['Records'][0]['s3']['object']['key']
    except KeyError:
        return {
            'statusCode': 400,
            'body': json.dumps(f"Can't parse event message: {event}")
        }

    config = get_config_env(ConfigEnvironment)
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
