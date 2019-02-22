import pytest
from repository.photo import PhotoRepo
from repository.exceptions import MissingArguments, UnsupportedQuery, UnsupportedFilter, UnsupportedFilterOperator
from boto3.dynamodb.conditions import Key


@pytest.fixture
def empty_db(mocker):
    db = mocker.Mock()
    table = db.Table()
    table.query.return_value = {'Items': []}
    table.scan.return_value = {'Items': []}
    return db


def test_when_no_conditions_then_empty_array(empty_db):
    repo = PhotoRepo(empty_db)
    assert len(repo.list()) == 0


def test_when_query_with_unknown_params_then_unsupported_query(empty_db):
    repo = PhotoRepo(empty_db)
    with pytest.raises(UnsupportedQuery):
        repo.list(query={'unknown': 'unknown'})


def test_when_query_with_two_params_then_unsupported_query(empty_db):
    repo = PhotoRepo(empty_db)
    with pytest.raises(UnsupportedQuery):
        repo.list(query={'nickname': 'nickname', 'tag': 'tag'})


def test_when_filter_with_unknown_params_then_unsupported_filter(empty_db):
    repo = PhotoRepo(empty_db)
    with pytest.raises(UnsupportedFilter):
        repo.list(filters={'unknown': 'unknown'})


def test_when_filter_with_unknown_operator_then_unsupported_filter_operator(empty_db):
    repo = PhotoRepo(empty_db)
    with pytest.raises(UnsupportedFilterOperator):
        repo.list(filters={'likes__zt': 100})


def test_when_filter_begins_with_no_str_then_unsupported_filter_operator(empty_db):
    repo = PhotoRepo(empty_db)
    with pytest.raises(UnsupportedFilterOperator):
        repo.list(filters={'likes__begins_with': 100})


def test_when_filter_int_operator_with_str_then_unsupported_filter_operator(empty_db):
    repo = PhotoRepo(empty_db)
    for operator in ['lt', 'gt', 'lte', 'gte']:
        with pytest.raises(UnsupportedFilterOperator):
            repo.list(filters={f'likes__{operator}': 'str'})


def test_when_filter_between_operator_with_int_then_unsupported_filter_opeartor(empty_db):
    repo = PhotoRepo(empty_db)
    with pytest.raises(UnsupportedFilterOperator):
        repo.list(filters={f'likes__between': 100})


def test_when_correct_query_then_called_with_query(empty_db):
    table = empty_db.Table()
    repo = PhotoRepo(empty_db)

    repo.list(query={'nickname': 'nickname'})
    condition_expresion = Key('nickname').eq('nickname')
    table.query.assert_called_once_with(KeyConditionExpression=condition_expresion)


def test_when_correct_filters_then_called_with_filters(empty_db):
    table = empty_db.Table()
    repo = PhotoRepo(empty_db)

    repo.list(filters={'nickname__eq': 'nick', 'tag__begins_with': 'mat'})

    filter_expression = Key('nickname').eq('nick') & Key('tag').begins_with('mat')
    table.scan.assert_called_once_with(FilterExpression=filter_expression)


def test_when_correct_query_and_filters_then_called_with_query_and_filters(empty_db):
    table = empty_db.Table()
    repo = PhotoRepo(empty_db)

    repo.list(
        query={'nickname': 'nickname'},
        filters={'nickname__eq': 'nick', 'tag__begins_with': 'mat'}
    )

    condition_expresion = Key('nickname').eq('nickname')
    filter_expression = Key('nickname').eq('nick') & Key('tag').begins_with('mat')

    table.query.assert_called_once_with(
        KeyConditionExpression=condition_expresion,
        FilterExpression=filter_expression
    )


def test_when_add_elemnt_with_missing_params_then_missing_arguments(empty_db):
    repo = PhotoRepo(empty_db)

    with pytest.raises(MissingArguments):
        repo.add({'nickname', 'nick'})


def test_when_get_elemnt_with_missing_params_then_missing_arguments(empty_db):
    repo = PhotoRepo(empty_db)

    with pytest.raises(MissingArguments):
        repo.get({'nickname', 'nick'})


def test_when_delete_elemnt_with_missing_params_then_missing_arguments(empty_db):
    repo = PhotoRepo(empty_db)

    with pytest.raises(MissingArguments):
        repo.delete({'nickname', 'nick'})
