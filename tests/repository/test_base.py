import pytest
from unittest.mock import Mock
from photorec.repository.photo import RepoPhoto


@pytest.fixture()
def database():
    table = Mock()
    table.scan.return_value = {'Items': []}
    table.query.return_value = {'Items': []}

    database = Mock()
    database.Table.return_value = table
    return database


def test_given_repository_when_list_with_no_query_filter_then_scan(database):
    repo = RepoPhoto(db=database, config=Mock())
    repo.list()

    table = repo.table
    table.scan.assert_called_once_with()


def test_given_repository_when_list_with_with_filter_then_scan(database):
    filters = {'like__between': (1, 100)}
    repo = RepoPhoto(db=database, config=Mock())
    repo.list(filters=filters)

    table = repo.table
    table.scan.assert_called_once()


def test_given_repository_when_list_with_with_query_then_scan(database):
    query = {'nickname': 'nickname'}
    repo = RepoPhoto(db=database, config=Mock())
    repo.list(query=query)

    table = repo.table
    table.query.assert_called_once()
