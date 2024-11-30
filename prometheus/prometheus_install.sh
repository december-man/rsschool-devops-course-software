# Add bitnami helm repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
# Add k3s namespace for monitoring utilities
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
# Install prometheus in the monitoring namespace
helm upgrade prometheus bitnami/kube-prometheus --install --namespace monitoring
# Wait for the installation to complete
echo 'Waiting for the installation to complete ...'
sleep 90
# Move Prometheus Service to NodePort
echo "Updating Prometheus service to NodePort ..."
kubectl patch svc prometheus-kube-prometheus-prometheus -n monitoring \
  --type='json' -p='[
    {"op": "replace", "path": "/spec/type", "value": "NodePort"},
    {"op": "add", "path": "/spec/ports/0/nodePort", "value": 32000}
  ]'
sleep 5
# Check all the prometheus pods for issues
kubectl get pods -n monitoring
# Check Monitoring Services
kubectl get svc -n monitoring
# Check prometheus UI availability
curl http://localhost:32000/graph
