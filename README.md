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

> If it's preferred that provisioning machines locally such as Vagrant and Vbox provider, you can just run the command below where you are on the Vagrantfile located at. You can find example Vagrantfile [here](https://github.com/bilalcaliskan/vagrant-ansible-lab/blob/master/Vagrantfile).

```shell
$ vagrant up
```
## Configuration
### Inventory
You can configure **kubespray inventory like below** (just replace with the IPv4s of your machines) also please look at other kube children group under kubespray/inventory/sample/inventory.ini:
```
[all]
k8s-master ansible_host=127.0.0.1  ip=127.0.0.1 etcd_member_name=etcd1
node-1 ansible_host=127.0.0.1      ip=127.0.0.1 etcd_member_name=etcd2
node-2 ansible_host=127.0.0.1      ip=127.0.0.1 etcd_member_name=etcd3
```

```shell
$ ansible-playbook -i  kubespray/inventory/sample/inventory.ini kubespray/cluster.yml -b -u vagrant
```

### Jenkins
You can use simply ansible/jenkins/inventory.ini file and run the ansible-playbook command to dpeloy jenkins on your kubernetes:

```shell
$ ansible-playbook -i  ansible/jenkins/inventory.ini ansible/jenkins/playbook.yml -b -u vagrant
```
Here you can use simple docker build stage with the given example **Jenkinsfile** on the root directory. Push to docker hub and deploy on k8s stages will be maintained as well in this project.

### Nginx
As similar to **Jenkins**, you can just use simple playbook to deploy nginx as a service on k8s-master
```shell
$ ansible-playbook -i ansible/nginx/inventory.ini ansible/nginx/nginx_playbook.yml -b -u vagrant
```
### EFK Stack on K8S
Here needs some troubleshooting which locally setup k8s doesn't work properly while tracing the container logs but below ansible playbook will setup the **stack** without any issue.
```shell
$ ansible-playbook -i efk/inventory.ini efk/setup_efk.yml -b -u vagrant
```

### Some troubleshooting parts before/while setting up
- Add these lines on your local under/etc/vbox/networks.conf if you prefer to use Vagrant&VirtualBox combine because we need to use 'Host only Network Adapter'
```shell
    * 10.0.0.0/8 192.168.0.0/16
    * 2001::/64
```
- After provisioning your VMs, you need to replace 'hersuite' with existing packages such as 'focal' under /etc/apt/source.list
```shell
    * Reason: Cache Update | APT will give timeout error due to non-existing package.
```
- After provisioning your VMs, you need to replace **"flannel_interface: net_adapter"** because kubespray will add hosts as 10.0.2.15 for each machines which will break kubelet. 

        Located at: kubespray/roles/network_plugin/flannel/main.yml

    Example usage below:
```shell
    * flannel_interface: eth1
```
