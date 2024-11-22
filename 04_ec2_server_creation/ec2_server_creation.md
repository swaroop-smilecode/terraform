#### Let's create an ec2 server with as minimum code as possible(will use only the required arguments).
- Ideally, ec2 server should be created like we do in hands_on section.</br>
  For now, in order to understand how to create cloud infrastructure using terrform, will do this activity.
- main.tf
  ```python
  provider "aws" {
    region = "ap-southeast-2"
  }
  
  resource "aws_instance" "ec2demo" {
    ami           = "ami-09c8d5d747253fb7a"
    instance_type = "t2.micro"
    tags = {
      Name = "yt-instance"
    }
  }
  ```
#### How to know required attribute names for resource type?
- Terraform official documentation https://developer.hashicorp.com/terraform/docs
- Click on `Registry`
- Click on `Browser Providers`
- Click on `AWS`
- Click on `Documentation`
- There will be list of resource types

#### How to create infrastructure?
Ok, well and good. We wrote an file named `main.tf`(code is written in HCL language) saying which resources need to be created in AWS.</br>
Now, which terraform commands to be executed to create infrastructure?</br>
It's 3 step sequential proccess.
```python
terraform init --> terraform plan(This step can be skipped) --> terraform apply -auto-approve
```

#### `terraform.tfstate.backup`
- Upon execution of `terraform apply` command, a file named `terraform.tfstate.backup` will be created.</br>
- Once the resources are created inside AWS cloud, terraform stores the details of those recources inside this file.</br>
  For example; when we create an ec2 server inside the AWS cloud, AWS sends back resource ID in the response.</br>
  That request ID is stored in this file, which we can use later in our code, if needed.
- Just for example purpose, i have said about resource ID. But in reality, you will get most comprehensive details</br>
  about the resouce such as name, arn, associate_public_ip_address etc.
- Since this file contains all the information, it's nice to store it inside an secure place.</br>
  Will see about this in hands_on section.

#### How to destroy create infrastructure?
```python
terraform destroy -auto-approve
```

#### How to validate `main.tf` file?
```python
terraform validate
```

#### Exactly at this moment, how many resources are maintained by terraform?
```python
terraform state list
```
