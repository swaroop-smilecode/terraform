#### <ins>Step 1</ins>
Download the terraform installation file & install it</br>
https://developer.hashicorp.com/terraform/install
#### <ins>Step 2</ins>
- Think about this. Suppose you are creating infrastructure inside AWS cloud using terraform.</br>
- Then terraform has to login into AWS console to do work on behalf of you, right?</br>
  With which ID & password terraform has to login?</br>
- For that purpose, first you login into AWS console as root user & create an IAM user</br>
  with respective policies attached to it, that are good enough to create any AWS service.</br>
  It would be nice to attach the administrator policy to IAM user.
- Upon creation of IAM user, you will receive Access key ID & Access key. Once you have them, let's execute below command.
```python
aws configure
Access key ID:
Access key:
Default region name: `us-east-1`
Default output format: # You can skip entering this value, just press enter.
```
