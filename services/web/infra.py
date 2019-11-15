import os

from pyioc.containers import NamespacedContainer

from config import DefaultConfig, LocalConfig
from photorec.database import create_db
from photorec.repository.like import RepoLike
from photorec.repository.photo import RepoPhoto
from photorec.repository.tag import RepoTag
from photorec.services.image import ServiceImage
from photorec.services.random import ServiceRandom
from photorec.services.ssm import ServiceSSM
from photorec.services.storage import ServiceStorageS3
from photorec.validators.nickname import ValidatorNickname
from photorec.validators.photo import ValidatorPhoto

repo = NamespacedContainer('repo')
repo.register_callable_with_deps('like', RepoLike)
repo.register_callable_with_deps('photo', RepoPhoto)
repo.register_callable_with_deps('tag', RepoTag)

service = NamespacedContainer('service')
service.register_callable_with_deps('image', ServiceImage)
service.register_callable_with_deps('random', ServiceRandom)
service.register_callable_with_deps('storage', ServiceStorageS3)
service.add_sub_container(repo)

validator = NamespacedContainer('validator')
validator.register_callable_with_deps('nickname', ValidatorNickname)
validator.register_callable_with_deps('photo', ValidatorPhoto)
validator.add_sub_container(repo)

cq = NamespacedContainer('cq')
cq.add_sub_container(repo)
cq.add_sub_container(service)
cq.add_sub_container(validator)


def initialization():
    config = _create_config()

    db = create_db(config)
    repo.register_object('db', db)
    repo.register_object('config', config)
    service.register_object('config', config)

    return config


def _create_config():
    config = LocalConfig if os.getenv("LOCAL", False) else DefaultConfig
    config.DEBUG = bool(os.getenv('DEBUG', False))

    service_ssm = ServiceSSM(config)
    prefix = f"{config.PROJECT}-{config.ENVIRONMENT}"

    config.AUTH_URL = service_ssm.get_parameter(name=f"{prefix}-auth-url")
    config.AUTH_JWKS_URL = service_ssm.get_parameter(name=f"{prefix}-auth-jwks-url")

    config.URL = service_ssm.get_parameter(name=f"{prefix}-web-url")
    config.SECRET_KEY = service_ssm.get_parameter(name=f"{prefix}-web-secret-key", with_decryption=True)

    config.AUTH_CLIENT_ID = service_ssm.get_parameter(name=f"{prefix}-auth-client-id", with_decryption=True)
    config.AUTH_CLIENT_SECRET = service_ssm.get_parameter(name=f"{prefix}-auth-client-secret", with_decryption=True)

    config.FILE_STORAGE = service_ssm.get_parameter(name=f"{prefix}-file-storage")
    config.DATABASE = service_ssm.get_parameter(name=f"{prefix}-database-name")

    return config
