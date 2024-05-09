## Getting Started

Follow the instructions to get the project up and running (This instructins are based on a UNIX OS system), if you are using Windows follow the instructions in the Makefile file:

### 1.- Setup ECR (Elastic Container Registry)

1. Clone the repository : `git clone https://.../prefect-workflow.git && cd prefect-workflow`
    * Change directory: `cd terraform`
    * (Optional) Change variable in the `locals.tf` file, make sure you change the name of the `project_name` variable if you wish to change.
    * If this is the first time running this project, then initialize terraform: `make tf-init`. This will inicialize Terraform.
    * Create ECR repository: `make tf-apply-ecr`, after running the command the prompt should show the arn and url of the ECR, make sure you copy them since we will need them later.
    * Create an ssh rsa key call id_rsa an place it in your ~/.ssh directory
