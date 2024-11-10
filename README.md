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
│       └── jenkins_setup.yml
├── .gitignore
├── jenkins
│   ├── jcasc.yaml
│   ├── jenkins_install_dummy.sh
│   ├── jenkins_install.sh
│   ├── jenkins-values.yaml
│   └── jenkins-volume.yaml
├── README.md
├── screenshots
└── ssh_config_xmpl.sh
```

**.github/workflows/jenkins_setup.yml:**
 * This file is part of GitHub Actions workflows. It defines a CI/CD workflow for automating tasks related to jenkins installation & configuration.

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
 * Manually trigger the workflow in *Actions* tab, or modify the `on:` setting in *.github/workflows/software_config.yml* with `push:` or `pull_request` triggers
 * The `jenkins_install.sh` script will deploy a pod with jenkins. To access the Jenkins UI, ensure that you've thoroughly read and understood how to set up ssh SOCKS5 proxy and `KUBECONFIG` to run `kubectl` locally.
 * Run ssh SOCKS5 proxy.
 * In another terminal, locally forward Jenkin's 8080 port to localhost's 8080:

   `kubectl port-forward svc/jenkins 8080:8080 -n jenkins`
 
 * Now you can access Jenkins from your local machine! Just type in localhost:8080 in your browser.