from pyioc.containers import NamespacedContainer

from repository.like import RepoLike
from repository.photo import RepoPhoto
from repository.tag import RepoTag

from services.image import ServiceImage
from services.random import ServiceRandom
from services.storage import ServiceStorageS3

from validators.nickname import ValidatorNickname
from validators.photo import ValidatorPhoto

from database import create_db


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


def initialization(config):
    db = create_db(config)
    repo.register_object('db', db)
    repo.register_object('config', config)
    service.register_object('config', config)
