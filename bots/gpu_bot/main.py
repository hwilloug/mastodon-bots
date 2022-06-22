import json

def run():
    try:
        status = _determine_availability()
        if status:
            # toot with gpu name, price, store, and link to store
            print('gpu is in stock')
            
        return {
                'status_code': 200
            }

    except:
        return {
                'status_code': 500
            }

def _scrape_web():
    return 'something something'

def _determine_availability():
    # scrape_web()
    # If it's in stock return true, and false if not
    return False

if __name__ == '__main__':
    print(run())