from config.access_token_requester import request_access_token

print(request_access_token())
import requests

headers = {
    'authority': 'regex101.com',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'ru,en-US;q=0.9,en;q=0.8,ru-RU;q=0.7,uk-UA;q=0.6,uk;q=0.5',
    'cache-control': 'max-age=0',
    'dnt': '1',
    'if-none-match': 'W/"f067-KaLiRDI6/jrjB0KI4jA9QROKKfA"',
    'sec-ch-ua': '"Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Windows"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'navigate',
    'sec-fetch-site': 'same-origin',
    'upgrade-insecure-requests': '1',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36',
}

response = requests.get('https://regex101.com/', headers=headers)

if __name__ == '__main__':
    print(response)
