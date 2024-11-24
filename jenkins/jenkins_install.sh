#!/bin/bash
# Create Separate Namespace for Jenkins
kubectl create ns jenkins

# Create Persistent Volume for Jenkins
echo "apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins-pv
  namespace: jenkins
spec:
  storageClassName: jenkins-pv
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 4Gi
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/jenkins-volume/

---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: jenkins-pv
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer" >> ~/jenkins-volume.yaml

sudo mkdir /data/jenkins -p
sudo chown -R 1000:1000 /data/jenkins
kubectl apply -f jenkins-volume.yaml

# Create Custom Account for Jenkins
curl https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml >> ~/jenkins-sa.yaml
kubectl apply -f jenkins-sa.yaml

# Create Custom Configuration for Jenkins
curl https://raw.githubusercontent.com/december-man/rsschool-devops-course-software/refs/heads/task_4/jenkins/jenkins-values.yaml >> ~/jenkins-values.yaml

helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm search repo jenkinsci
chart=jenkinsci/jenkins
helm install jenkins -n jenkins -f jenkins-values.yaml $chart