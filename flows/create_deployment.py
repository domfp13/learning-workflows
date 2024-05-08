from my_gh_workflow import post_flow
from prefect import flow

if __name__ == "__main__":
    post_flow.serve(
        name="my-first-deployment",
        cron="1 * * * *",
        tags=["testing", "tutorial"],
        description="Given a GitHub repository, logs repository statistics for that repo.",
        version="tutorial/deployments",
    ).deploy(
        name="my-first-deployment",
        work_pool_name="my-docker-pool", 
    )
