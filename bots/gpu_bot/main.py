import json
import os

from mastodon import Mastodon
import requests

def run(event, context):
    try:

        products, products_toots = _get_available_products()

        if os.environ.get('SEND_TOOTS', True) is True:
            m, mastodon_api_key = _get_mastodon_api_token()
            m.toot("THESE GPUS ARE NOW AVAILABLE!\n\n" + '\n'.join(products_toots))

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

def _get_available_products():
        url = "https://api.bestbuy.com/v1/products"
        query = '(manufacturer=nvidia&categoryPath.name=GPU*)'
        params = {
            'format': 'json',
            'show': 'name,orderable,addToCartUrl,regularPrice',
            'apiKey': os.environ.get('BESTBUY_API_KEY', '')
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