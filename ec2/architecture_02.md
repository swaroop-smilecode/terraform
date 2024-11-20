Let's see, how we are going to setup auto scaling group & load balancer.</br>

<ins>Load balancer:</ins></br>
1. Create security group to allow internet traffic & attach it to load balancer.
2. Define listner/rule, to dictate how the load balancer should distrubute </br>
   incoming requests evenly between the servers that are going to be created by auto scaling group.</br>

<ins>Auto scaling group:</ins></br>
1. Create security group to allow internet traffic only from load balancer & attach it to auto scaling group.</br>
   (Remember that even though you are attaching security group to auto scaling group,</br>
   it's actually an security group for underlying ec2 instances).
3. Inside auto scaling group, will use launch template to define EC2 instances configuration.

![image](https://github.com/user-attachments/assets/91684b7e-b996-4c66-b11f-888986182af9)
