Prerequisites
Terraform CLI installed (v1.1+ recommended)

AWS CLI configured (aws configure)

IAM user/role with permission to manage:

VPC, Subnets, IGW, Route Tables

S3 bucket (for backend)

⚙️ Backend Setup (S3 + DynamoDB)
Before running Terraform, create:

1. S3 Bucket (to store state)
bash
Copy
Edit
aws s3api create-bucket --bucket your-terraform-state-bucket --region us-east-1
2. DynamoDB Table (for state locking)
bash
Copy
Edit
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
📄 backend.tf
hcl
Copy
Edit
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
⚠️ Update bucket name and region before running terraform init

🚀 How to Run
1. Initialize Terraform
bash
Copy
Edit
terraform init
2. Validate the Configuration
bash
Copy
Edit
terraform validate
3. Preview the Changes
bash
Copy
Edit
terraform plan
4. Apply the Changes
bash
Copy
Edit
terraform apply
Approve when prompted with yes

📦 Example Variable File (terraform.tfvars)
hcl
Copy
Edit
vpc_cidr         = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
region           = "us-east-1"
project_name     = "myproject"
📤 Outputs
After apply, Terraform will show:

VPC ID

Subnet IDs

IGW ID

Route Table IDs

🧹 Destroy Infrastructure
bash
Copy
Edit
terraform destroy
🔐 Note
Never commit terraform.tfstate, .tfvars or AWS credentials to Git.

Add .gitignore:

gitignore
Copy
Edit
*.tfstate
*.tfstate.backup
*.tfvars
.terraform/
