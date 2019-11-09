from ..common.errors import BadRequestError


class NicknameError(BadRequestError):
    def __init__(self, code=400, message="Error nickname not defined"):
        super().__init__(code=code, message=message)


class ValidatorNickname:
    @staticmethod
    def validate(nickname: str):
        if isinstance(nickname, str) and nickname:
            return
        raise NicknameError()
