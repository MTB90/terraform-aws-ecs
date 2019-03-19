from pyioc.containers import NamespacedContainer

from repository.like import RepoLike
from repository.photo import RepoPhoto
from repository.tag import RepoTag
from services.storage import ServiceStorage
from database import create_db


repo = NamespacedContainer('repo')

repo.register_callable_with_deps('like', RepoLike)
repo.register_callable_with_deps('photo', RepoPhoto)
repo.register_callable_with_deps('tag', RepoTag)

service = NamespacedContainer('service')
service.register_callable_with_deps('storage', ServiceStorage)
service.add_sub_container(repo)

cq = NamespacedContainer('cq')
cq.add_sub_container(repo)
cq.add_sub_container(service)


def initialization(config):
    repo.register_object('db', create_db(config))
