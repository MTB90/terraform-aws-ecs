from pyioc.containers import NamespacedContainer

from repository.like import RepoLike
from repository.photo import RepoPhoto
from repository.tag import RepoTag
from services.storage import ServiceStorageS3
from services.image import ServiceImage
from validators.nickname import ValidatorNickname
from validators.user_photo import ValidatorUserPhoto

from database import create_db


repo = NamespacedContainer('repo')
repo.register_callable_with_deps('like', RepoLike)
repo.register_callable_with_deps('photo', RepoPhoto)
repo.register_callable_with_deps('tag', RepoTag)

service = NamespacedContainer('service')
service.register_callable_with_deps('storage', ServiceStorageS3)
service.register_callable_with_deps('image', ServiceImage)
service.add_sub_container(repo)

validator = NamespacedContainer('validator')
validator.register_callable_with_deps('nickname', ValidatorNickname)
validator.register_callable_with_deps('user_photo', ValidatorUserPhoto)
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
