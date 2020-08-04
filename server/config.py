import os

basedir = os.path.abspath(os.path.dirname(__file__))


class BaseConfig(object):
    """Base configuration."""


class DevelopmentConfig(BaseConfig):
    """Development configuration."""


class TestingConfig(BaseConfig):
    """Testing configuration."""


class ProductionConfig(BaseConfig):
    """Production configuration."""
