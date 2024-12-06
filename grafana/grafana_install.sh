echo 'Creating Admin Password Secret'
kubectl create secret generic grafana-admin-pw -n monitoring --from-literal=password="$GRAFANA_PASSWORD" 
echo 'Grabbing Grafana Helm Chart configuration'
curl -o ~/grafana_values.yaml https://raw.githubusercontent.com/december-man/rsschool-devops-course-software/refs/heads/task_8/grafana/grafana_values.yaml
echo 'Grabbing Grafana Dashboard .JSON'
curl -o ~/grafana_dash.json https://github.com/december-man/rsschool-devops-course-software/blob/task_8/grafana/grafana_dash.json
kubectl create configmap grafana-dash -n monitoring --from-file=grafana_dash.json
echo 'Installing Grafana...'
helm upgrade --install grafana bitnami/grafana -n monitoring -f ~/grafana_values.yaml
sleep 90
echo 'Checking installation'
kubectl get svc,pods,deployment -n monitoring