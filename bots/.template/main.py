import os

from mastodon import Mastodon

def run():
    try:

        if os.environ.get('SEND_TOOTS', True):
            m, mastodon_api_key = _get_mastodon_api_token()
            #m.toot("Hello, world! It's me, Test Bot!")

        return {
                'statusCode': 200
            }

    except Exception as err:
        return {
                'statusCode': 500,
                'error': err
            }

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