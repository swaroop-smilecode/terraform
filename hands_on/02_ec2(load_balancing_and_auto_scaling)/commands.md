#### Terraform commands to create vpc
```python
terraform init
terraform plan # This step can be skipped.
terraform apply -auto-approve
```

#### Terraform commands to delete vpc
```python
terraform destroy -auto-approve
```

#### Windows commands to clean up files & folders that are created on execution of terraform commands
```python
rd -r ".terraform*"
rd -r terraform.tfstate*
```

#### Windows commands to clean up files & folders that are created on execution of terraform commands
```python
terraform output
```