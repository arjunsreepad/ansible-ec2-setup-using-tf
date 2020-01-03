
# Setup Ansible with 3 nodes on AWS EC2 machines using terraform
Hello world project to setup 4 EC2 Machines using Terraform. 1 machine acts as Ansible master & rest as nodes 

## Getting Started

Set AWS secret key, access key,ec2 key & default region in vars.tfvars file.

### Prerequisites

 - Terraform
 - AWS account (Free tier also works out)

### Installation

Run below terraform commands to initialize and create ec2 instance with security group which open port 22 and 80 for external connections

Say what the step will be

```
terraform init
terraform apply -auto-approve -var-file=vars.tfvars
```
This will create 4 EC2 machines all of t2.micro then install ansible on master machine & adds the ssh key to master so that master can communicate with all other nodes

Successful apply of terarform will print the public IP of Master and private IP's of slaves

```
Outputs:
	ansible-master = 52.6.177.16
	ansible-nodes = [
		"3.94.112.63",
		"3.81.215.78",
		"3.85.176.178"]
```

Update the inventory file with these IP's and copy them to the ansible master. 

To test everything is working as expected run the below command to ping all nodes

```
ansible all -i inventory.ini -m ping
```

