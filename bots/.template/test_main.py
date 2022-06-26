import pytest
from main import run

def test_smoketest():
    result = run()
    assert result == {"statusCode": 200}