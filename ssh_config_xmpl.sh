### Configuration for Bastion host (jump host) # Note that the private key is being fed to ssh agent
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