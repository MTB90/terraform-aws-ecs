from pyioc.containers import NamespacedContainer

from photorec.database import create_db
from photorec.repository.like import RepoLike
from photorec.repository.photo import RepoPhoto
from photorec.repository.tag import RepoTag
from photorec.services.image import ServiceImage
from photorec.services.random import ServiceRandom
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


def initialization(config):
    db = create_db(config)
    repo.register_object('db', db)
    repo.register_object('config', config)
    service.register_object('config', config)
