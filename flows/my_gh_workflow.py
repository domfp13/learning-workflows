import httpx   # an HTTP client library and dependency of Prefect
from prefect import flow, task
from typing import Optional

@task
def get_posts():
    """Get a list of posts"""
    response = httpx.get('https://jsonplaceholder.typicode.com/posts')
    response.raise_for_status()
    return response.json()

@task
def create_post():
    """Create a new post"""
    post_data = {
        "title": "foo",
        "body": "bar",
        "userId": 1
    }
    response = httpx.post('https://jsonplaceholder.typicode.com/posts', json=post_data)
    response.raise_for_status()
    return response.json()

@flow(retries=3, retry_delay_seconds=5, log_prints=True)
def post_flow():
    print("Starting Prefect 🤓")
    posts = get_posts()
    new_post = create_post()
    print(f"New post created: {new_post}")

if __name__ == "__main__":
    post_flow()
