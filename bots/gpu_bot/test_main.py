import pytest
from main import run

def test_smoketest():
    result = run()
    #assert result == {"status_code": 200}