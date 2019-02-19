from repository.tag import TagRepo


def test_given_photos_repo_when_init_then_object_created():
    tag_repo = TagRepo()
    assert tag_repo