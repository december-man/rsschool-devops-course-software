#!/bin/bash
sudo yum install git -y
cd ~
git clone --branch task_5 https://github.com/december-man/rsschool-devops-course-software.git
cd rss*/wordpress
helm install wordpress . --set dbPassword=$WORDPRESS_PASSWORD
helm list
