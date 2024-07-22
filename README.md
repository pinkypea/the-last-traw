# 1. Client installation
## a. install gcloud
```bash
sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates gnupg curl -y

curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt-get update && sudo apt-get install google-cloud-cli

sudo apt-get install google-cloud-cli-gke-gcloud-auth-plugin

gcloud init

gcloud auth login

# list compute engine

gcloud compute instances list
```

## b. install kubectl
```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.0/2024-05-12/bin/linux/amd64/kubectl

chmod +x ./kubectl

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

kubectl version
```
## c. install docker
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker engine 

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo docker ps
```
# 2. K8s deploy
## a. Prepair
- Pull docker images
```bash
sudo docker pull hoangbuii2711/natours-frontend
sudo docker pull hoangbuii2711/natours-backend
```
- Label the Nodes
```bash
kubectl label node <frontend-node-name> role=frontend
kubectl label node <backend-node-name> role=backend
```
- Create namespace
```bash
kubectl create namespace frontend
kubectl create namespace backend
```
## b. Create resource
## c. Apply Manifests
- Apply service and get ipaddress
```bash
kubectl apply -f frontend-service.yaml
kubectl apply -f backend-service.yaml
```
- Modify in envfile
- Create secret
```bash
kubectl create secret generic the-last-straw-frontend-env --from-env-file=frontend.env -n frontend
kubectl create secret generic the-last-straw-backend-env --from-env-file=backend.env -n backend
```
- Apply Deployment
```bash
  kubectl apply -f frontend-deployment.yaml
  kubectl apply -f backend-deployment.yaml
```
- Install metric Server
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
- Apply HPA
```bash
kubectl apply -f hpa.yaml
```
# 3. Gitlab Runner
## a.Setup gitlab runner
- create VM
- Install gitlab runner
```bash
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

sudo apt-get install gitlab-runner
```
- Setup user
```bash
sudo visudo
```
add ```gitlab-runner ALL=(ALL) NOPASSWD:ALL``` after root user
```bash
sudo su - gitlab-runner
```
## b. Install requirement package
- Docker
- Google cloud 
- Kubernetes
- NodeJS
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs
node -v
npm -v
```
## c. Run gitlab runner
- Follow gitlab runnner setup instruction
- Run gitlab runner
```bash
gitlab-runner run
```
# 4. Setup CI/CD
- Create staging namespace
```bash
kubectl create namespace frontend
kubectl create namespace backend
```
# 5. Connect kubectl to eks
```bash
aws eks update-kubeconfig --region ap-southeast-1 --name the-last-straw-cluster
```
psql "postgresql://postgres:postgres@terraform-20240720032754650300000001.cb6ge2e4gfe1.ap-southeast-1.rds.amazonaws.com:5432/postgres"
