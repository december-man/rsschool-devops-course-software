#!/bin/bash

# Create Custom Account for Jenkins
curl https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml >> ~/jenkins-sa.yaml
kubectl apply -f jenkins-sa.yaml