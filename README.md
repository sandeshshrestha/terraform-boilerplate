
# Terraform boilerplate for Kubernetes cluster

Terraform config that creates a basic kubernetes cluster that host a nginx server. This project is meant to be used as a boilerplate only.

```
HTTP(S) -> Public IP -> Ingress -> Service -> Deployment
```

### Requirement 

- Install [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

### Features

- Autoscaling of node
- Autoscaling of pods
- SSL certificate for domain

### Steps

#### Step 1: Get SSL Certificate

You can use existing SSL Certificate or create using  [Letsencrypt ssl certificate generator](https://github.com/sandeshshrestha/letsencrypt-ssl-certificate-generator).
Copy it in **./certificate** folder

  - ./certificate/fullchain.pem
  - ./certificate/privkey.pem 

#### Step 2: Create IAM profile

Visit [Google Console](https://console.cloud.google.com/iam-admin/iam) to create an IAM profile. While creating the profile, it lets you download `gcloud-service.json` file. Place it in root folder.

#### Step 3: Customize your cluster

Create `terraform.tfvars` on root folder. For example.

```
gcp_project                      = "gcp-project-1234"
dev_cluster_master_auth_username = "cluster_username"
dev_cluster_master_auth_password = "cluster_password"
```

#### Step 4: Change the domain

Change `host` in `network.tf`.

#### Step 5: Push to Google could

Run these commands
```
terraform init
terraform plan
terraform apply
```

#### Step 6: Update DNS

Update DNS config of the domain by added a new `A` record with the `ip` printed while running `terraform apply` on `step 5`.
