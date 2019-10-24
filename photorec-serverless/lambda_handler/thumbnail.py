import json

from config import get_config
from services.image import ServiceImage
from services.random import ServiceRandom
from services.storage import ServiceStorageS3
from use_cases.create_thumbnail import CreateThumbnail


def handler(event, context):
    records = [x for x in event.get('Records', []) if x.get('eventName') == 'ObjectCreated:Put']
    sorted_events = sorted(records, key=lambda e: e.get('eventTime'))

    if not sorted_events:
        return {
            'statusCode': 400,
            'body': json.dumps(f'Event not supported {event}')
        }

    info_s3_event = sorted_events[-1].get('s3', {})
    photo_key = info_s3_event.get('object', {}).get('key')

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
