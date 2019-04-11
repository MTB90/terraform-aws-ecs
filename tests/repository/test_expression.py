import pytest
from photorec.repository.base import Expression, UnsupportedExpression


@pytest.mark.parametrize("expression", [
    {'like__t': 8},
    {'like__zt': 42},
    {'like__betwen': 100},
    {'tag__': (1, 100)}
])
def test_when_expression_with_unknown_operator_then_unsupported_expression(expression):
    with pytest.raises(UnsupportedExpression):
        Expression(expression)


@pytest.mark.parametrize("expression", [
    {'like__lt': '8'},
    {'like__gt': '42'},
    {'like__between': 100},
    {'tag': (1, 100)},
    {'tag__begins_with': 100}
])
def test_when_expression_with_invalid_value_then_unsupported_expression(expression):
    with pytest.raises(UnsupportedExpression):
        Expression(expression)


@pytest.mark.parametrize("expression", [
    {'like__eq': 8},
    {'like__lt': 42},
    {'like__between': (1, 100), 'tag': 'tag'},
    {'tag': 'tag'},
    {'tag__begins_with': 'begins_with'}
])
def test_when_valid_expression_then_no_error(expression):
    try:
        assert Expression(expression) is not None
    except UnsupportedExpression:
        pytest.fail("Unexpected expression error ...")
