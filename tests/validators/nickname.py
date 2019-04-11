import pytest

from photorec.validators.nickname import ValidatorNickname, NicknameError


@pytest.mark.parametrize("nickname", [None, '', 1, {}])
def test_given_invalid_nickname_when_validate_nickname_then_error(nickname):
    with pytest.raises(NicknameError):
        ValidatorNickname.validate(nickname)
