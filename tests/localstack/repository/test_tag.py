import pytest
from photorec.config import LocalConfig
from photorec.database import create_db
from photorec.repository.tag import RepoTag


@pytest.fixture()
def repo_tag():
    db = create_db(config=LocalConfig)

    return RepoTag(
        db=db,
        config=LocalConfig
    )


def test_when_add_new_tag_then_tag_is_store(repo_tag):
    item = {
        'tag': 'new_tag'
    }

    response = repo_tag.add(item=item)
    assert response == 200
    result = repo_tag.get(key=item)
    assert result == {'tag': item['tag'], 'score': 1, 'tags': 'tag'}


def test_add_when_multiple_times_tag_then_tag_score_should_match(repo_tag):
    item = {
        'tag': 'score_tag'
    }
    score = 5
    for _ in range(score):
        response = repo_tag.add(item=item)
        assert response == 200

    result = repo_tag.get(key=item)
    assert result == {'tag': item['tag'], 'score': score, 'tags': 'tag'}
