BAD_REQUEST_ERROR_MESSAGE = "Bad request error"
PERMISSION_DENIED_ERROR_MESSAGE = "Permission denied"


class BaseError(Exception):
    def __init__(self, code, message):
        self.code = code
        self.message = message
        super().__init__(message)


class BadRequestError(BaseError):
    def __init__(self, code=400, message=BAD_REQUEST_ERROR_MESSAGE):
        super().__init__(code=code, message=message)


class PermissionDeniedError(BaseError):
    def __init__(self, code=403, message=PERMISSION_DENIED_ERROR_MESSAGE):
        super().__init__(code=code, message=message)
