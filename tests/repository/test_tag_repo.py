import pytest
from repository.tag import RepoTag


@pytest.fixture
def empty_db(mocker):
    db = mocker.Mock()
    return db


def test_given_photos_repo_when_init_then_object_created(empty_db):
    tag_repo = RepoTag(empty_db)
    assert tag_repo
