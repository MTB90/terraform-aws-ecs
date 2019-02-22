import pytest
from repository.like import RepoLike
from repository.exceptions import MissingArguments


@pytest.fixture
def empty_db(mocker):
    db = mocker.Mock()
    return db


def test_when_add_elemnt_with_missing_params_then_missing_arguments(empty_db):
    repo = RepoLike(empty_db)

    with pytest.raises(MissingArguments):
        repo.add({'nickname', 'nick'})


def test_when_delete_elemnt_with_missing_params_then_missing_arguments(empty_db):
    repo = RepoLike(empty_db)

    with pytest.raises(MissingArguments):
        repo.delete({'nickname', 'nick'})