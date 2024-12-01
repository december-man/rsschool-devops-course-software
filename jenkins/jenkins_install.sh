#!/bin/bash
# Create Separate Namespace for Jenkins
kubectl create ns jenkins

# Create Persistent Volume for Jenkins
curl https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-volume.yaml -o ~/jenkins-volume.yaml
sed -i 's/storage: 20Gi/storage: 4Gi/' ~/jenkins-volume.yaml
sudo mkdir -p /data/jenkins-volume
sudo chown -R 1000:1000 /data/jenkins-volume/
kubectl apply -f jenkins-volume.yaml

# Create Custom Account for Jenkins
curl https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml >> ~/jenkins-sa.yaml
kubectl apply -f jenkins-sa.yaml

# Create Custom Configuration for Jenkins
curl https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/values.yaml >> ~/jenkins-values.yaml
sed -i 's/size: "8Gi"/size: "4Gi"/' ~/jenkins-values.yaml
sed -i 's/nodePort:/nodePort: 32000/' ~/jenkins-values.yaml
sed -i 's/serviceType: ClusterIP/serviceType: NodePort/' ~/jenkins-values.yaml
sed -i 's/storageClass:/storageClass: jenkins-pv/' ~/jenkins-values.yaml
sed -i -e ':a;N;$!ba;s/name should be created\n  create: true/name should be created\n  create: false/g' ~/jenkins-values.yaml
sed -i -e ':a;N;$!ba;s/access-controlled resources\n  name:/access-controlled resources\n  name: jenkins/g' ~/jenkins-values.yaml

# Deploy Jenkins using Helm
helm repo add jenkinsci https://charts.jenkins.io && helm repo update
chart=jenkinsci/jenkins
helm install jenkins -n jenkins -f jenkins-values.yaml $chart

# Get Admin Password
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo