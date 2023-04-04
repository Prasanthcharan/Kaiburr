# kaiburr


##jenkins pipeline stages 
[jenkins ul](http://44.201.183.75:8080/job/devops-multibranch/)
 
![image](https://user-images.githubusercontent.com/87360254/229893905-56b416d0-9b7a-40fa-8fe2-b8de9e8930d2.png)

##terraform folder
under terraform folder - to launcg ec2 instances and ansible playbook to install mongodb 

before running below terraform commands, aws configure has to setup. terraform launch ec2 instance and copy mongodb playbooks to ec2 instance and install mongodb through ansilbe playbooks
```shell
git clone https://github.com/Prasanthcharan/kaiburr.git
cd terraform
terraform init
terraform plan
terraform apply
```

##k8s cluster setup

eks-cluster.yaml file is used to launch eks cluster and nake sure eksctl installed from where you run below commands

```shell
eksctl create cluster -f eks-cluster.yaml
```

##helm folder

helm chart for application hackathon-starter


