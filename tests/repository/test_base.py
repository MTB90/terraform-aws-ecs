from unittest.mock import Mock
from photorec.repository.photo import RepoPhoto


def test_given_repository_when_list_with_no_query_filter_then_scan():
    table = Mock()
    table.scan.return_value = {'Items': []}

    database = Mock()
    database.Table.return_value = table

    repo = RepoPhoto(db=database, config=Mock())
    repo.list()

    table.scan.assert_called_once_with()


