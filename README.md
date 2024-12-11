## AWS DevOps Software & CI/CD Repository
 **This is a dedicated repository for software installation/manupulation during AWS DevOps Course that compliments the one dedicated to the infrastructure [(rsschool-devops-course-infrastrutture)](https://github.com/december-man/rsschool-devops-course-infrastrutture/)**
 
 * **The idea is to separate infrastructure and software development because the infrastracture is seldomly updated, whereas the software updates & installations occur on a daily basis.**

 * **In order to use this repository, you need to deploy the infrastructure first, using the aformentioned *rsschool-devops-course-infrastrutture* repository. Just follow the [README file](https://github.com/december-man/rsschool-devops-course-infrastrutture/blob/main/README.md) there to setup a Private k3s Cluster with Helm preinstalled**

 ### Current infrastructure configuration:
 ![alt text](/screenshots/task_4/aws_devops_t4.png)

### Repo Contents
``` bash
├── .github
│   └── workflows
│       ├── grafana_setup.yml
│       ├── jenkins_setup.yml
│       ├── prometheus_setup.yml
│       └── wordpress_deploy.yml
├── .gitignore
├── grafana
│   ├── grafana_dash.json
│   ├── grafana_install.sh
│   └── grafana_values.yaml
├── jenkins
│   ├── jcasc.yaml
│   ├── jenkins_install_dummy.sh
│   ├── jenkins_install.sh
│   ├── jenkins-values.yaml
│   └── jenkins-volume.yaml
├── README.md
├── prometheus
│   └── prometheus_install.sh
├── screenshots
├── ssh_config_xmpl.sh
└── wordpress
    ├── charts
    ├── Chart.yaml
    ├── .helmignore
    ├── templates
    │   ├── deployment.yaml
    │   ├── _helpers.tpl
    │   ├── mysql-deployment.yaml
    │   ├── mysql-pvc.yaml
    │   ├── mysql-service.yaml
    │   ├── pvc.yaml
    │   └── service.yaml
    ├── values.yaml
    └── wordpress_setup.sh

```

**.github/workflows/:**
 * This file is part of GitHub Actions workflows. It defines a CI/CD workflow for automating tasks related to software installation & configuration.

**.gitignore:**
 * This file specifies intentionally untracked files that Git should ignore. It includes patterns for files generated during builds, temporary files, or sensitive configuration files that should not be shared.

**README.md:**
 * This is the file you are reading now.

**screenshots:**
 * This directory contains all the screenshots related to the tasks, grouped by task folders.

**ssh_config_xmpl.sh:**
 * This contains SSH configuration. It eases up the use of ssh ProxyJump, as well as other settings to fully automate ssh connection to the private k3s server node from gha pipeline

### Jenkins folder contents

**jenkins/jcasc.yaml:**
 * This YAML file is used for Jenkins Configuration as Code (JCasC). It defines Jenkins settings, including security realms, job configurations, and plugins, allowing for automated Jenkins setup and configuration.

**jenkins/jenkins_install_dummy.sh:**
 * This shell script serves as a placeholder or example for installing Jenkins. Used during development process to test out ssh connection to k3s server instance from gha pipeline

**jenkins/jenkins_install.sh:**
 * This shell script is intended to automate the installation of Jenkins. It contains commands to install Jenkins and configure it on a k3s cluster. It also has a basic check to see if jenkins is already installed.

**jenkins/jenkins-values.yaml:**
 * This YAML file is used for configuring Helm charts for Jenkins deployment on Kubernetes. It contains values that customize the Helm chart installation, specifying things like resource limits, replicas, and configurations for Jenkins.

**jenkins/jenkins-volume.yaml:**
 * This file defines a Kubernetes persistent volume configuration for Jenkins. It specifies how data should be stored outside the Jenkins container, ensuring that data persists across deployments and restarts.

### Jenkins Installation:
 * In order to install jenkins, you obviously need to clone this repository
 * Then set up all the necessary github secrets, that are mentioned in the *.github/workflows/jenkins_setup.yml*
   - SSH_PASSPHRASE: ${{ secrets.SSH_PASSPHRASE }} - passphrase for your ssh key that was used in k3s cluster setup
   - SSH_PRIVATE_KEY: ${{ secrets.SSH_PRV }} - private ssh key that was used in k3s cluster setup 
   - SSH_CONFIG: ${{ secrets.SSH_CONFIG }} - ssh configuration that defines connections, e.g.:
   ```bash
    ### Configuration for Bastion host
    Host bastion_host
        HostName your_bastion_host_ip
        User ec2-user
        ForwardAgent yes
        StrictHostKeyChecking no

    ### Configuration for connecting to the k3s Server via the Bastion host
    Host k3s_server_node
        HostName your_k3s_server_ip
        User ec2-user
        ProxyJump bastion_host
        StrictHostKeyChecking no
   ```
    This really comes in handy in the rest of `ssh` command calls.
 * Manually trigger the workflow in *Actions* tab, or modify the `on:` setting in *.github/workflows/jenkins_setup.yml* with `push:` or `pull_request` triggers
 * The `jenkins_install.sh` script will deploy a pod with jenkins. To access the Jenkins UI, ensure that you've thoroughly read and understood how to set up ssh SOCKS5 proxy and `KUBECONFIG` to run `kubectl` locally.
 * Run ssh SOCKS5 proxy.
 * In another terminal, locally forward Jenkin's 8080 port to localhost's 8080:

   `kubectl port-forward svc/jenkins 8080:8080 -n jenkins`
 
 * Now you can access Jenkins from your local machine! Just type in localhost:8080 in your browser.

### Wordpress folder contents:

**Chart.yaml:**

  * This file contains metadata about the WordPress helm chart, such as its name, version, description. It's essential for Helm to understand the chart's purpose and versioning.

**.helmignore:**

  * This file works similarly to .gitignore. It specifies files and directories that should be ignored by Helm when packaging the chart. Common entries might include logs, temporary files, or any other unnecessary files.

**templates/:**

  * This directory contains the Kubernetes resource templates that Helm will use to generate the final manifests. Each file corresponds to a Kubernetes resource or a helper function.

    **deployment.yaml:**
      -  This template defines the Kubernetes Deployment for the WordPress application. It specifies how to manage the WordPress pods, including the container image, replicas, and environment variables.

    **_helpers.tpl:**
      -  This file contains reusable template snippets or functions that can be called from other templates. It helps to keep the templates DRY (Don't Repeat Yourself).

    **mysql-deployment.yaml:**
      -  This template defines the Deployment for the MySQL database that WordPress will use. It includes specifications for the MySQL container and its configuration.

    **mysql-pvc.yaml:**
      -  This template creates a PersistentVolumeClaim (PVC) for the MySQL database, ensuring that data persists even if the MySQL pod is restarted.

    **mysql-service.yaml:**
      -  This template defines a Kubernetes Service for the MySQL database, allowing other pods (like the WordPress pod) to communicate with it.

    **pvc.yaml:**
      -  This template creates a PersistentVolumeClaim (PVC) for the WordPress application, ensuring that data persists even if the WordPress pod is restarted.

    **service.yaml:**
      -  This template defines a Service for the WordPress application, which makes it accessible over the network.

**values.yaml:**

  * This file contains default configuration values for the chart. Users can override these values when installing or upgrading the chart. It usually includes settings for replicas, image versions, resource limits, and any other configurable options.

**wordpress_setup.sh:**

  * This script is used for initial setup tasks related to the WordPress installation via Github Actions Pipeline.

### Wordpress Installation:
 * In order to install wordpress, you obviously need to clone this repository
 * Just as with jenkins, you will need to set up all the necessary github secrets, that are mentioned in the *.github/workflows/wordpress_setup.yml*
   - SSH_PASSPHRASE: ${{ secrets.SSH_PASSPHRASE }} - passphrase for your ssh key that was used in k3s cluster setup
   - SSH_PRIVATE_KEY: ${{ secrets.SSH_PRV }} - private ssh key that was used in k3s cluster setup 
   - SSH_CONFIG: ${{ secrets.SSH_CONFIG }} - ssh configuration that defines connections
   - SSH_WORDPRESS_PASSWORD" ${{ secrets.WORDPRESS_PASSWORD }} - password to use for WordPress application and its backend database
 * Manually trigger the workflow in *Actions* tab, or modify the `on:` setting in *.github/workflows/wordpress_deploy.yml* with `push:` or `pull_request` triggers
 * The `wordpress_install.sh` script will deploy a pod with wordpress, exposing the default 32000 port to access WordPress application using http protocol
 * The Reverse-Proxy setup on Bastion Host will automatically forward the :32000 node port to port :80 on it, thus making WordPress application publically available via Cluster's EIP over http
 * Open your browser and connect to your bastion's public ip using port 80 (or just http://)
 * Now you can setup your WordPress Application!

### Prometheus folder contents

**prometheus/prometheus_install.sh:**
 * This shell script is intended to automate the installation of Prometheus. It contains commands to install Prometheus and configure it on a k3s cluster. It also has a basic check to see if Prometheus is already installed.

### Prometheus Installation:
 * Just like in any other case, in order to install Prometheus, you need to clone this repository.
 * Then set up all the necessary github secrets, that are mentioned in the *.github/workflows/prometheus_setup.yml*
   - SSH_PASSPHRASE: ${{ secrets.SSH_PASSPHRASE }} - passphrase for your ssh key that was used in k3s cluster setup
   - SSH_PRIVATE_KEY: ${{ secrets.SSH_PRV }} - private ssh key that was used in k3s cluster setup 
   - SSH_CONFIG: ${{ secrets.SSH_CONFIG }} - ssh configuration that defines connections (example is shown above)
 * Manually trigger the workflow in *Actions* tab, or modify the `on:` setting in *.github/workflows/prometheus_setup.yml* with `push:` or `pull_request` triggers
 * The `prometheus_install.sh` script will deploy Prometheus on your k3s cluster, exposing port 32000 for Prometheus UI (http protocol)
 * The Reverse-Proxy setup on Bastion Host will automatically forward the :32000 node port to port :80 on it, thus making Prometheus application publically available via Cluster's EIP over http. Don't forget to check your reverse-proxy setup in Bastion Host to match the k3s server private ip address! The nginx proxy config executes during [Bastion Host deployement (user_data) ](https://github.com/december-man/rsschool-devops-course-infrastrutture/blob/main/bastion_host.sh)
 * Open your browser and connect to your bastion's public ip (EIP) using port 80 (or just http://)
 * Now you can use Prometheus UI to query some informative metrics about your cluster!

### Grafana folder contents

**grafana_dash.json:**
 * A JSON Model of a Dashboard to be used for metrics visualization.

**grafana_install.sh:**
 * This shell script is intended to automate the installation of Grafana. It contains commands to install and configure Grafana on a k3s cluster. It also has a basic check to see if Grafana is already installed.

**grafana_values.yaml:**
 * Grafana Chart Configuration file for Helm deployment

### Grafana Installation

#### Grafana can be installed only if Prometheus is deployed. Hence, the pipeline in Github Actions includes a step with Prometheus installation as well.
 * Clone this repository and prepare [k3s cluster infrastracture](https://github.com/december-man/rsschool-devops-course-infrastrutture/blob/main/)
 * On k3s cluster, **run Prometheus installation script**. Don't forget about GitHub Secrets:
   - GRAFANA_PASSWORD: Admin user password to authenticate into Grafana UI.
   - SSH secrets (see Prometheus installation)
 * After installing Prometheus, use `grafana_install.sh` script to deploy Grafana on your k3s cluster, exposing port 32001 for Grafana UI (http protocol)
 * The Reverse-Proxy setup on Bastion Host will automatically forward the :32001 node port to port :80 on it, leaving Prometheus on the same address but on a special path: `<BASTION_PUBLIC_IP>/app` thus making Grafana UI publically available via Cluster's EIP over http. Don't forget to check your reverse-proxy setup in Bastion Host: [Bastion Host deployement (user_data) ](https://github.com/december-man/rsschool-devops-course-infrastrutture/blob/main/bastion_host.sh)
 * Open your browser and connect to your bastion's public ip (EIP) using port 80 (or just http://). Note that the main (/) path will direct you to Grafana, and `/app` path will direct you to Prometheus.
 * Now you can use Grafana to build some fancy dashboards, containing various, Prometheus-based metrics about your cluster!