import json
import os

from mastodon import Mastodon
import requests

def run(event, context):
    try:
        
        url = "https://clickbait-generator.herokuapp.com/api"
        response = requests.get(url).json()

        if os.environ.get('SEND_TOOTS', True):
            m, mastodon_api_key = _get_mastodon_api_token()
            m.toot(response['title'])

        return json.dumps({
                'statusCode': 200
            })

    except Exception as err:
        return json.dumps({
                'statusCode': 500,
                'error': str(err)
            })

def _get_mastodon_api_token():
    m = Mastodon(
        os.environ.get('MASTODON_CLIENT_ID', ''),
        os.environ.get('MASTODON_CLIENT_SECRET', ''),
        api_base_url = os.environ.get('MASTODON_BASE_URL', 'https://tavern.antinet.work')
    )
    return m, m.log_in(
        os.environ.get('MASTODON_EMAIL', ''),
        os.environ.get('MASTODON_PASSWORD', ''),
        scopes=['read', 'write']
    )

if __name__ == '__main__':
    print(run())