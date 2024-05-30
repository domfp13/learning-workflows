## Getting Started

Follow the instructions to get the project up and running (This instructins are based on a UNIX OS system), if you are using Windows follow the instructions in the Makefile file:

### 1.- Setup ECR (Elastic Container Registry)

1. Clone the repository : `git clone https://.../prefect-workflow.git && cd prefect-workflow`
    * Change directory: `cd terraform`
    * (Optional) Change variable in the `locals.tf` file, make sure you change the name of the `project_name` variable if you wish to change.
    * TODO: ADD steps to setup terraform cloud so the state is save there instead of the local git repository. The key should be safe in the directory where the docker-comppose is pointing to.
    * TODO: Generate an SSH id_rsa.pub, add documentation for this part.
    * If this is the first time running this project, then initialize terraform: `make tf-init`. This will inicialize Terraform.
    * Create ECR repository: `make tf-apply-target`, you need to pass the following flag `aws_ecr_repository.workflow_ecr` after running the command the prompt should show the arn and url of the ECR, make sure you copy them since we will need them later.
    * Create User that will be used in the Github actions (CI/CD) to deploy changes to the registry. Run `make tf-apply-target` you need to pass the following flag: `aws_iam_user_policy_attachment.workflow-ecr-user-policy`. This creates a user and attached the policy to it. After running it, you need to add the following:
        * ECR_REPOSITORY_NAME (use repository_name from the output from before). This is a VARIABLE.
        * AWS_ACCESS_KEY_ID (Secret) for the user created.
        * AWS_SECRET_ACCESS_KEY (Secret) for the user created.
    * Push changes to a remote branch so the the image is build and push the registry.
    