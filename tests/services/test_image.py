import pytest
from photorec.services.image import DataImageJpeg, ServiceImage, UnableToOpenImageError


def test_given_empty_data_when_create_data_image_jpeg_then_raise_error():
    with pytest.raises(UnableToOpenImageError):
        DataImageJpeg(image=None, data=None)


@pytest.mark.parametrize("image, size", [
    ('../tests/fixtures/image.png', (300, 300)),
    ("../tests/fixtures/image.jpg", (300, 300)),
    ('../tests/fixtures/image.png', (1200, 1200)),
    ("../tests/fixtures/image.jpg", (1200, 1200))
])
def test_given_image_when_resize_image_then_return_resized_image(image, size):
    service_image = ServiceImage()
    with open(image, "rb") as file:
        data_image_jpeg = service_image.load(file)
        resize_data_image_jpeg = service_image.resize(data_image_jpeg, *size)
        assert resize_data_image_jpeg.image.size == size
