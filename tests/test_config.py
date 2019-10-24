import os
from photorec.config import get_config, DefaultConfig, LocalConfig


def test_get_config_when_no_env_set_then_return_default_config():
    config = get_config()
    assert config == DefaultConfig


def test_get_config_when_local_env_set_then_return_local_config():
    os.environ["LOCAL"] = "True"
    config = get_config()
    assert config == LocalConfig
    os.environ.pop("LOCAL")


def test_get_config_when_debug_set_then_return_dev_config():
    os.environ["DEBUG"] = "True"
    config = get_config()
    assert config.DEBUG
    os.environ.pop("DEBUG")
