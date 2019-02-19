from repository.photo import PhotoRepo


def test_given_photos_repo_when_init_then_object_created():
    photo_repo = PhotoRepo()
    assert photo_repo
