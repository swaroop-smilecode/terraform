#### What is state file?
Think like this..</br>
state file is the database for terraform where it stores the state of the infrastructure it created.</br>

Let's see what happens when this kind of mechanism is not present.</br>
Suppose you created security group to allow respective IP addresses.</br>
After some time, you have decided to add one more IP address to the security group.</br>
If state file is present, now terraform can just update the security group by just adding new IP address.</br>
If state file is not present, terraform doesn't know any thing whether such security group is there/not.</br>
Then obvious solution is to delete the security group if it is present & then create fresh one.</br>
Instead of creating resource each & everytime, if would be nice if terraform knows what is there in the cloud already
& what the user is asking now. So, that the work of terraform will be efficient.</br>

#### desired state & current state
desired state = resources present in the terraform config file.
current state = real resources present in the cloud.
