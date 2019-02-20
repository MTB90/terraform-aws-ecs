import pytest
from unittest.mock import Mock
from repository.photo import PhotoRepo


def test_given_empty_db_when_no_conditions_then_empty_array():
    empty_db = Mock()
    repo = PhotoRepo(empty_db)
    assert len(repo.list()) == 0


def test_given_repo_when_query_with_unknown_params_then_key_error():
    repo = PhotoRepo(Mock())
    with pytest.raises(KeyError):
        repo.list(query={'unknown': 'unknown'})


def test_given_repo_when_query_with_two_params_then_value_error():
    repo = PhotoRepo(Mock())
    with pytest.raises(ValueError):
        repo.list(query={'nickname': 'nickname', 'tag': 'tag'})


def test_given_repo_when_filter_with_unknown_params_then_key_error():
    repo = PhotoRepo(Mock())
    with pytest.raises(KeyError):
        repo.list(filters={'unknown': 'unknown'})


def test_given_repo_when_filter_with_unknown_operator_then_value_error():
    repo = PhotoRepo(Mock())
    with pytest.raises(ValueError):
        repo.list(filters={'likes__zt': 100})


def test_given_repo_when_filter_begins_with_no_str_then_value_error():
    repo = PhotoRepo(Mock())
    with pytest.raises(ValueError):
        repo.list(filters={'likes__begins_with': 100})


def test_given_repo_when_filter_int_operator_with_str_then_value_error():
    repo = PhotoRepo(Mock())
    for operator in ['eq', 'lt', 'gt', 'lte', 'gte']:
        with pytest.raises(ValueError):
            repo.list(filters={f'likes__{operator}': 'str'})


def test_given_repo_when_filter_between_operator_with_int_then_value_error():
    repo = PhotoRepo(Mock())
    with pytest.raises(ValueError):
        repo.list(filters={f'likes__between': 100})

