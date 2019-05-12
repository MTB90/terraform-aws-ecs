import os
from photorec.config import get_config, ProdConfig, LocalConfig, DevConfig


def test_get_config_when_no_env_set_then_return_prod_config():
    config = get_config()
    assert config == ProdConfig


def test_get_config_when_local_env_set_then_return_local_config():
    os.environ["LOCAL"] = "True"
    config = get_config()
    assert config == LocalConfig
    os.environ.pop("LOCAL")


def test_get_config_when_debug_set_then_return_dev_config():
    os.environ["DEBUG"] = "True"
    config = get_config()
    assert config == DevConfig
    os.environ.pop("DEBUG")
