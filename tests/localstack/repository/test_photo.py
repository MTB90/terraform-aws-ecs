import pytest
from photorec.config import TestConfig
from photorec.database import create_db
from photorec.repository.photo import RepoPhoto


@pytest.fixture()
def repo_photo():
    db = create_db(config=TestConfig)

    return RepoPhoto(
        db=db,
        config=TestConfig
    )


def repo_photo_fill(repo_photo):
    user1 = 5
    for id_item in range(user1):
        item = {
            'nickname': 'user-1',
            'photo': 'photo_key',
            'thumb': 'thumb_key',
            'uuid': f'uuid{id_item}'
        }
        repo_photo.add(item=item)

    user2 = 2
    for id_item in range(user2):
        item = {
            'nickname': 'user-2',
            'photo': 'photo_key',
            'thumb': 'thumb_key',
            'uuid': f'uuid{id_item}'
        }
        repo_photo.add(item=item)

    return user1, user2


def test_when_add_new_photo_then_photo_is_store(repo_photo):
    item = {
        'nickname': 'nickname',
        'photo': 'photo_key',
        'thumb': 'thumb_key',
        'uuid': 'uuid'
    }

    response = repo_photo.add(item=item)
    assert response == 200
    result = repo_photo.get(key={'nickname': 'nickname', 'uuid': 'uuid'})
    item['likes'] = 0
    assert result == item


def test_when_add_photo_and_delete_then_no_item(repo_photo):
    item = {
        'nickname': 'delete',
        'photo': 'delete',
        'thumb': 'delete',
        'uuid': 'delete'
    }

    repo_photo.add(item=item)
    item = repo_photo.get(key={'nickname': 'delete', 'uuid': 'delete'})
    assert item is not None

    repo_photo.delete(key={'nickname': 'delete', 'uuid': 'delete'})
    item = repo_photo.get(key={'nickname': 'delete', 'uuid': 'delete'})
    assert item is None


def test_list_when_query_photos_then_return_all_photos(repo_photo):
    user1, user2 = repo_photo_fill(repo_photo)

    photos = repo_photo.list(query={'nickname': 'user-1'})
    assert len(photos) == user1

    photos = repo_photo.list(query={'nickname': 'user-2'})
    assert len(photos) == user2


def test_list_when_filter_photos_then_return_all_photos(repo_photo):
    user1, user2 = repo_photo_fill(repo_photo)

    photos = repo_photo.list(filters={'nickname__begins_with': 'user'})
    assert len(photos) == user1 + user2
