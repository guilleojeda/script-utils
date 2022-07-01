#first you need to create the temp ssh key
#then replace all placeholders (yes, this should be parametrized)
aws ec2-instance-connect send-ssh-public-key --instance-id [instance-id] --availability-zone [availability-zone] --instance-os-user ssm-user --ssh-public-key file://temp.pub
ssh -i temp -N -f -M -S temp-ssh.sock -L [local-port]:[db-host]:[db-port] ssm-user@[instance-id] -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" -o ProxyCommand="aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p"
read -rsn1 -p "Press any key to close session."; echo
ssh -O exit -S temp-ssh.sock *

#after you run this, leave the terminal open, and in another terminal connect to the db as if it were on localhost:[local-port]
#for example psql -h localhost -p 3306 -U master postgres