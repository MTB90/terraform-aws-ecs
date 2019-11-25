from pyioc.containers import NamespacedContainer

from photorec.database import create_db
from photorec.repository.like import RepoLike

repo = NamespacedContainer('repo')
repo.register_callable_with_deps('like', RepoLike)

service = NamespacedContainer('service')

cq = NamespacedContainer('cq')
cq.add_sub_container(repo)
cq.add_sub_container(service)


def initialization(config):
    db = create_db(config)
    repo.register_object('db', db)
    repo.register_object('config', config)
    service.register_object('config', config)

    return config
