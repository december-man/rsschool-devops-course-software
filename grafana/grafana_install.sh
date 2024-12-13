#!/bin/bash
echo 'Creating Admin Password & SMTP Credentials Secrets...'
kubectl create secret generic grafana-admin-pw -n monitoring --from-literal=password="$GRAFANA_PASSWORD" 
kubectl create secret generic grafana-smtp-ses -n monitoring --from-literal=user="$GRAFANA_SMTP_SES_USER" --from-literal=password="$GRAFANA_SMTP_SES_PASSWORD"

echo 'Grabbing Grafana Helm Chart configuration...'
curl -o ~/grafana_values.yaml https://raw.githubusercontent.com/december-man/rsschool-devops-course-software/refs/heads/task_9/grafana/grafana_values.yaml

echo 'Grabbing Grafana Dashboard .JSON Model...'
curl -o ~/grafana_dash.json https://raw.githubusercontent.com/december-man/rsschool-devops-course-software/refs/heads/task_9/grafana/grafana_dash.json
kubectl create configmap grafana-dash -n monitoring --from-file=grafana_dash.json

echo 'Setting up Grafana Alerting System...'
echo 'Setting up Alerts and Email Notifications...'
curl -o ~/grafana_values.yaml https://raw.githubusercontent.com/december-man/rsschool-devops-course-software/refs/heads/task_9/grafana/grafana_alerts.yaml
kubectl create configmap grafana-alerts -n monitoring --from-file=grafana_alerts.yaml

echo 'Installing Grafana...'
helm upgrade --install grafana bitnami/grafana -n monitoring -f ~/grafana_values.yaml
sleep 90

echo 'Checking installation...'
kubectl get svc,pods,deployment -n monitoring