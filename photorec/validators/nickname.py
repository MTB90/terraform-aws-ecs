from exceptions.domian_errors import ValidationError


class NicknameError(ValidationError):
    def __init__(self, code=404, message="Error nickname not defined"):
        super().__init__(code=code, message=message)


class ValidatorNickname:
    @staticmethod
    def validate(nickname: str):
        if isinstance(nickname, str) and nickname:
            return
        raise NicknameError()
