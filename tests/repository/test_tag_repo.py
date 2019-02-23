import pytest
from repository.tag import RepoTag
from repository.exceptions import UnsupportedFilterOperator, UnsupportedFilter
from repository.exceptions import UnsupportedQuery, MissingArguments
from boto3.dynamodb.conditions import Key


@pytest.fixture
def empty_db(mocker):
    db = mocker.Mock()
    table = db.Table()
    table.query.return_value = {'Items': []}
    table.scan.return_value = {'Items': []}
    return db


def test_when_no_conditions_then_empty_array(empty_db):
    repo = RepoTag(empty_db)
    assert len(repo.list()) == 0


def test_when_query_with_unknown_params_then_unsupported_query(empty_db):
    repo = RepoTag(empty_db)
    with pytest.raises(UnsupportedQuery):
        repo.list(query={'unknown': 'unknown'})


def test_when_query_with_two_params_then_unsupported_query(empty_db):
    repo = RepoTag(empty_db)
    with pytest.raises(UnsupportedQuery):
        repo.list(query={'nickname': 'nickname', 'tag': 'tag'})


def test_when_filter_with_unknown_params_then_unsupported_filter(empty_db):
    repo = RepoTag(empty_db)
    with pytest.raises(UnsupportedFilter):
        repo.list(filters={'unknown': 'unknown'})


def test_when_filter_with_unknown_operator_then_unsupported_filter_operator(empty_db):
    repo = RepoTag(empty_db)
    with pytest.raises(UnsupportedFilterOperator):
        repo.list(filters={'score__zt': 100})


def test_when_filter_begins_with_no_str_then_unsupported_filter_operator(empty_db):
    repo = RepoTag(empty_db)
    with pytest.raises(UnsupportedFilterOperator):
        repo.list(filters={'score__begins_with': 100})


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

    repo.list(query={'type': 'nickname'})
    condition_expresion = Key('type').eq('nickname')
    table.query.assert_called_once_with(KeyConditionExpression=condition_expresion)


def test_when_correct_filters_then_called_with_filters(empty_db):
    table = empty_db.Table()
    repo = RepoTag(empty_db)

    repo.list(filters={'score__eq': 10})

    filter_expression = Key('score').eq(10)
    table.scan.assert_called_once_with(FilterExpression=filter_expression)


def test_when_correct_query_and_filters_then_called_with_query_and_filters(empty_db):
    table = empty_db.Table()
    repo = RepoTag(empty_db)

    repo.list(
        query={'type': 'nickname'},
        filters={'score__between': (10, 100)}
    )

    condition_expresion = Key('type').eq('nickname')
    filter_expression = Key('score').between(10, 100)

    table.query.assert_called_once_with(
        KeyConditionExpression=condition_expresion,
        FilterExpression=filter_expression
    )


def test_when_add_element_with_missing_params_then_missing_arguments(empty_db):
    repo = RepoTag(empty_db)

    with pytest.raises(MissingArguments):
        repo.add({'nickname', 'nick'})


def test_when_get_element_with_wrong_params_then_missing_arguments(empty_db):
    repo = RepoTag(empty_db)

    with pytest.raises(MissingArguments):
        repo.get({'nickname', 'nick'})


def test_when_delete_element_with_wrong_params_then_missing_arguments(empty_db):
    repo = RepoTag(empty_db)

    with pytest.raises(MissingArguments):
        repo.delete({'nickname', 'nick'})
