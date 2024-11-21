#### <ins>What is Provider ?</ins>
Provider is the plug in, on which terraform depends to consume the API exposed by respective platform.
![image](https://github.com/user-attachments/assets/57658f59-50ae-4d0e-b88f-efa88f715437)

Each provider will have resource types
![image](https://github.com/user-attachments/assets/90648c84-42dc-46ca-8834-be8c5a5907bd)

Each resource type will have required arguments & optional arguments. For example; in case of</br>
aws resource named `aws_s3_bucket`, required argument is `bucket` & optional argument is `tags`.</br>
![image](https://github.com/user-attachments/assets/aba5d382-61ce-4968-8735-8f64e1009128)


#### <ins>What happens when you execute the command `terrafrom init` ?</ins>
![image](https://github.com/user-attachments/assets/58f80dad-6c1f-475a-b777-15d99af76085)
