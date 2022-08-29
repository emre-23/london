# Terraform & Kubernetes

## Usage
Source Code can be downloaded from [here](https://github.com/emre-23/london.git).

Then you can begin to setup your infrastructe with terraform with the command like below:
```shell
$ terraform init 
```

```shell
$ terraform plan 
```

```shell
$ terraform apply
```

> Note that above command will create two ec2 instances, security group related a network interface which allows all traffic to enable ssh and http requests also keypair as .pem file to be able to remote secure shell connection. Firstly you need to install [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) to import your authorization credentials such as AccessKeyId&SecretKey and take a quick look at [terraform official documents](https://learn.hashicorp.com/tutorials/terraform/aws-build) included educating videos.
