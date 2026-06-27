import re
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests

from .repository import Repository

STARRED_URL = 'https://api.github.com/users/{username}/starred'
PER_PAGE = 100
DEFAULT_MAX_WORKERS = 10


def _parse_last_page(link_header):
    if not link_header:
        return 1
    for part in link_header.split(','):
        if 'rel="last"' in part:
            match = re.search(r'[?&]page=(\d+)', part)
            if match:
                return int(match.group(1))
    return 1


def _repo_from_rest(data):
    return Repository(
        name=data['full_name'],
        description=data.get('description') or '',
        language=data.get('language') or '',
        url=data.get('html_url') or '',
        stargazer_count=data.get('stargazers_count') or 0,
        is_private=data.get('private') or False,
        topics=list(data.get('topics') or []),
    )


class GitHubREST:
    def __init__(self, token, max_workers=DEFAULT_MAX_WORKERS):
        self.token = token
        self.max_workers = max_workers
        self._headers = {
            'Authorization': f'Bearer {token}',
            'Accept': 'application/vnd.github+json',
        }

    def _fetch_page(self, username, page):
        response = requests.get(
            STARRED_URL.format(username=username),
            headers=self._headers,
            params={
                'per_page': PER_PAGE,
                'page': page,
                'sort': 'created',
                'direction': 'desc',
            },
            timeout=60,
        )
        response.raise_for_status()
        return page, response.json(), response.headers.get('Link', '')

    def get_user_starred_by_username(self, username):
        _, repos, link_header = self._fetch_page(username, 1)
        if not repos:
            return []

        last_page = _parse_last_page(link_header)
        pages = {1: repos}

        if last_page > 1:
            with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
                futures = {
                    executor.submit(self._fetch_page, username, page): page
                    for page in range(2, last_page + 1)
                }
                for future in as_completed(futures):
                    page_num, page_repos, _ = future.result()
                    pages[page_num] = page_repos

        items = []
        for page in range(1, last_page + 1):
            for repo in pages[page]:
                items.append(_repo_from_rest(repo))
        return items
