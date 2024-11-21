#### <ins>Architecture</ins>
![image](https://github.com/user-attachments/assets/5166c2fd-524f-4409-9472-ddeb4c00e89a)

#### <ins>How end users acess your servers from internet ?</ins>
![image](https://github.com/user-attachments/assets/93d9215c-b605-4e27-b359-cf7d4bfb9c72)

#### <ins>How your servers present in Private subnet access internet ?</ins> 
![image](https://github.com/user-attachments/assets/e1716893-f616-40b7-9f7d-73461c45a956)

#### <ins>Note</ins>
I did not showed 2 things in the diagram, as it is making too clumpsy. They are:
#### ---------------------------------------------------------------------------------------
1.
- I am deploying apache server inside the EC2 instance.
#### ---------------------------------------------------------------------------------------
2. 
- I am creating an ec2 instance with the name `bastion host` inside public subnet & </br>
  attaching a fresh security group to allow traffic from internet to bastion host.
- Then i am adding same security group to auto scaling group also</br>
  so that traffic from bastion host is allowed to reach the ec2 servers spinned up inside the private subnet.
Why is this?</br>
Let's consider there is some problem inside the EC2 servers.</br>
You can't connect EC2 servers, since they are inside the private subnet.</br>
So, work around is you --> bastian host --> EC2 server.
#### ---------------------------------------------------------------------------------------
