---
title: Nuix
start: "2021-01-15T08:00:00.000Z"
end: "2022-05-13T17:00:00.000Z"
description: "DevOps Engineer"
---

<a href="https://www.nuix.com/" target="_blank">Nuix</a>

## Role Recap

Joined the DevOps team as the organization was nearly wrapped up migrating resources from OpenStack to AWS. The manager of the team, Nick Eldridge was an inspiring mentor who taught me most of what I know. It was a 2-person team that later added a 3rd member after 4 months on the team. The primary focus of the role was acting as the SREs of the internal application infrastructure, multiple Jenkins instances, JFrog Artifactory, Bitbucket, SonarQube, and SVN server with Fisheye Crucible. I was responsible for developing the Jenkins shared pipeline library, Terraform modules for application deployments, Ansible playbooks for application provisioning, and a 2-week on-call rotation for developer support. We operated in SAFe (Scaled Agile Framework), and at the end of each 2-week sprint, we would demo to application teams.

## Accomplishments

* Engineered a self-healing Jenkins deployment. Provisioned an AMI with Packer using a Ubuntu 18.04.6 LTS base image that leveraged the cloud-init framework. It ran an Ansible playbook to mount an EFS share to the Jenkins home directory, download the wildcard certificate key bundle issued by the IT team from S3, then create a systemd service that ran a docker-compose file consisting of the Jenkins image with an Nginx reverse proxy. The Jenkins home directory was set as a volume in the docker-compose file, as well as the certificate bundle. Developed the Terraform deployment that consisted of an Auto-Scaling group and a Classic Load Balancer performing TCP/UDP passthrough for SSL termination at the nginx reverse proxy. Finally, migrated to the new framework by performing an rsync of the Jenkins home from the previous instance to the EFS and updated DNS. An improvement was later added that consisted of an SNS notification when an Auto-Scaling instance termination cycle occurred. It triggered a Lambda function written in Python that sent a Slack notification to the `#DevOps-Announcements` slack channel that Jenkins is unavailable. When the instance launch event occurred, the Lambda would trigger again and update the Route53 record for the EC2 instance with the IP address of the new instance, then poll the Jenkins login page for a 200 response. Once that occurred, the Lambda would send a Slack message to the same channel that Jenkins is available once again and trigger a Jenkins job that ran the Sensu monitoring Ansible playbook to install monitoring on the new Jenkins instance.

* Upgraded and migrated the Bitbucket server from the IT managed AWS account to the UAT account managed by the US DevOps team. Took an RDS snapshot of the current Postgres SQL database and shared it with the UAT account. Took an EBS snapshot of the repository volumes and shared it with the UAT account. Developed Terraform to deploy an EC2 instance with the EBS snapshot mounted, and an RDS Postgres SQL instance from the snapshot, and a Route53 A record pointed to the IP address of the instance. Manually went through the process of mounting the EBS volume with the repository data, setting up a systemd service to run a docker-compose file with an Nginx reverse proxy and the upgraded version of the Bitbucket server image. Prior to starting the service, the database schema upgrade script present in the container was run using docker exec, then the service was started. After running through the process manually with success, I wrote an Ansible playbook to perform all the steps during the live upgrade process.

* Migrated the SVN and Fisheye Crucible server from a datacenter that was soon to be deprecated to the AWS UAT account. Wrote an Ansible Playbook to provision the server with SVN, gather all repos on the previous host, then run `svnrdump` to migrate each repo over to the new Ubuntu 18.04.6 LTS host. Ran the Fisheye Crucible in a docker-compose file with an nginx reverse proxy as a systemd service. Developed Terraform to deploy the EC2 instance, the Postgres SQL RDS instance, and the Route53 A record.

* Was a major contributor to the Jenkins shared pipeline utilized by application teams. Developed the jobs to build Packer AMIs and share to multiple regions and AWS accounts in the organization, the jobs to run Terraform deployments, and the jobs to run Ansible playbooks. All accepted map inputs that allowed for a lot of flexibility.

* Contributed to the Sensu monitoring framework.

## Reason for Leaving

Wanted to gain experience managing publicly facing sites rather than just internal development infrastructure. 