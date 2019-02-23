import pytest
from repository.tag import RepoTag
from repository.exceptions import UnsupportedFilterOperator
from boto3.dynamodb.conditions import Key


@pytest.fixture
def empty_db(mocker):
    db = mocker.Mock()
    table = db.Table()
    table.query.return_value = {'Items': []}
    table.scan.return_value = {'Items': []}
    return db


def test_when_filter_int_operator_with_str_then_unsupported_filter_operator(empty_db):
    repo = RepoTag(empty_db)
    for operator in ['lt', 'gt', 'lte', 'gte']:
        with pytest.raises(UnsupportedFilterOperator):
            repo.list(filters={f'score__{operator}': 'str'})


def test_when_filter_between_operator_with_int_then_unsupported_filter_operator(empty_db):
    repo = RepoTag(empty_db)
    with pytest.raises(UnsupportedFilterOperator):
        repo.list(filters={f'score__between': 100})


def test_when_correct_query_then_called_with_query(empty_db):
    table = empty_db.Table()
    repo = RepoTag(empty_db)

    repo.list(query={'type': 'type'})
    condition_expresion = Key('type').eq('type')
    table.query.assert_called_once_with(KeyConditionExpression=condition_expresion)


def test_when_correct_filters_then_called_with_filters(empty_db):
    table = empty_db.Table()
    repo = RepoTag(empty_db)

    repo.list(filters={'score__lte': 200})

    filter_expression = Key('score').lte(200)
    table.scan.assert_called_once_with(FilterExpression=filter_expression)
