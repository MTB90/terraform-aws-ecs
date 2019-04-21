from PIL import Image
from io import BytesIO
from common.errors import BaseError


class UnableToOpenImageError(BaseError):
    pass


class DataImageJpeg:
    def __init__(self, data=None, image=None):
        if image is None:
            try:
                self._image = Image.open(data)
            except IOError:
                raise UnableToOpenImageError(message='Unable to open image')
        else:
            self._image = image
        self._bytes_stream = self._get_bytes_stream()

    def _get_bytes_stream(self):
        bytes_stream = BytesIO()
        self._image.save(bytes_stream, "JPEG")
        return bytes_stream

    @property
    def size(self):
        return self._bytes_stream.tell()

    @property
    def image(self):
        return self._image

    def bytes(self):
        return self._bytes_stream.getvalue()


class ServiceImage:
    EXIF_ORIENTATION = 274

    def __init__(self, config):
        self._config = config

    @staticmethod
    def load(data):
        return DataImageJpeg(data=data)

    @staticmethod
    def resize(data_image: DataImageJpeg, width: int = 150, height: int = 150) -> DataImageJpeg:
        image = data_image.image
        try:
            exif = dict(image._getexif().items())
            if exif[ServiceImage.EXIF_ORIENTATION] == 3:
                image = image.rotate(180, expand=True)
            elif exif[ServiceImage.EXIF_ORIENTATION] == 6:
                image = image.rotate(270, expand=True)
            elif exif[ServiceImage.EXIF_ORIENTATION] == 8:
                image = image.rotate(90, expand=True)
        except Exception:
            pass

        dest_ratio = width / height
        source_ratio = image.width / float(image.height)

        if image.size < (width, height):
            new_width, new_height = image.size
        elif dest_ratio > source_ratio:
            new_width = int(image.width * height / float(image.height))
            new_height = height
        else:
            new_width = width
            new_height = int(image.width * width / float(image.height))

        image = image.resize((new_width, new_height), resample=Image.LANCZOS)

        resize_image = Image.new("RGB", (width, height))
        topleft = (int((width - new_width) / float(2)),
                   int((height - new_height) / float(2)))

        resize_image.paste(image, topleft)
        return DataImageJpeg(image=resize_image)
