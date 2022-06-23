import json
import os

from mastodon import Mastodon
import requests

def run():
    try:
        products, products_toots = _get_available_products()

        m, mastodon_api_key = _get_mastodon_api_token()
        m.toot("THESE GPUS ARE NOW AVAILABLE!\n\n" + '\n'.join(products_toots))

        return {
                'status_code': 200
            }

    except Exception as err:
        return {
                'status_code': 500,
                'error': err
            }

def _get_mastodon_api_token():
    m = Mastodon(
        os.environ.get('MASTODON_CLIENT_ID', '2q4Y_BZ9KeghifpjKiL72x6xbixwH_GDb9omDhSGjBc'),
        os.environ.get('MASTODON_CLIENT_SECRET', 'MsxxXutxjKUB4dX5SJr7tweyP1aQvKDc8p421NxKPG0'),
        api_base_url = os.environ.get('MASTODON_BASE_URL', 'https://tavern.antinet.work')
    )
    return m, m.log_in(
        os.environ.get('MASTODON_EMAIL', 'hjw.dev.96@gmail.com'),
        os.environ.get('MASTODON_PASSWORD', '7bMuA9LYMH6UJTP'),
        scopes=['read', 'write']
    )

def _get_available_products():
        url = "https://api.bestbuy.com/v1/products"
        query = '(manufacturer=nvidia&categoryPath.name=GPU*)'
        params = {
            'format': 'json',
            'show': 'name,orderable,addToCartUrl,regularPrice',
            'apiKey': os.environ.get('BESTBUY_API_KEY', 'SN7OrPLoQ4xkkAAmAUAEcjEv')
        }
        response = requests.get(url + query, params=params)
        response = response.json()

        products = []
        products_toots = []
        for product in response['products']:
            if product['orderable'] == 'Available':
                products.append(product)
                products_toots.append('${} <{}> at {}'.format(
                    product['regularPrice'],
                    product['name'],
                    product['addToCartUrl']
                ))
        return products, products_toots

if __name__ == '__main__':
    print(run())