---
title: Independence Blue Cross
start: "2023-06-05T08:00:00.000Z"
end: "2023-12-28T17:00:00.000Z"
description: "Senior Cloud Engineer"
---

<a href="https://www.ibx.com/" target="_blank">Independence Blue Cross</a>

## Role Recap

Assisted in the handoff of the AWS Organization developed by an outside consulting team <a href="https://www.citiustech.com/" target="_blank">Citius Tech</a>. Was responsible for maintaining and updating the Terraform for the hub-and-spoke network model located in a dedicated networking account. Consited of a Customer Gateway, Transit Gateway, Site-to-Site VPN tunnels, and Route53 Resolver Rules for internal DNS resolution. The Transit Gateway and Route53 resolver rule was shared to all accounts via AWS Resource Access Manager. Worked with the networking team to create VPCs for the majority of the accounts in the Organization, each new VPC required new routes to be added to the Asscoiation and Propigation route tables for the shared Transit Gateway. Fulfilled requests to grant SSO AWS access and permission updates using AWS IAM Identity Center. Worked with the ESM team to establish monitoring of the AWS organization using Dynatrace. Developed and contributed Terraform modules to deploy two serverless applications.

## Accomplishments

* Developed the Terraform to implement Dynatrace monitoring. Consisted of an EC2 server running the activegate agent, a VPC endpoint pointed to the SAAS Dynatrace instance with a private Route53 zone with an A record that pointed VPC endpoint DNS name to resolve the Dynatrace instance internally within the AWS backbone, VPC peering connections to the application accounts, updates to the route tables in Private subnets to facilitate the peering connections, and cross-account IAM roles to grant the EC2 instance access to the application accounts.

* Engineered a complex Terraform deployment for a serverless IVR application consisting of Amazon Connect, Lambda functions, and Lex Bots. Developed a platform in Azure DevOps to support the promotion of manually created Lex Bots, Connect Flows, and Connect Modules in the Dev account to be incorporated into the Terraform deployment for the QA and Production accounts, consisted of Python scripts leveraging the boto3 library as well as local JSON data stores to maintain environment-specific ARNs in the resources. Worked with the DevOps team to establish a framework to separate the IAC from the standard developer workflow, which consisted of Jenkins jobs that invoked Azure DevOps pipelines.

* Assited in the implimentation of the SIEM tool that monitored CloudTrail and Gaurd Duty logs for all accounts in the AWS organization.

* Assisted in the design and implementation of DR for the IVR application utilizing the Global Resliency Connect feature, and lead the Well-Architected Review with AWS Enterprise Support. Developed Terraform and Azure DevOps pipeline logic to support replicating production resources to the back up region.

## Reason for Leaving

Disagreed with project management style, infrastructure and development teams were treated as two distinct silos. I felt the organization wanted automation without embracing the DevOps principles of collaboration and removing silos. Left to focus on personal developemnt, upskilling, and finding role that is a better fit. Gained valuable experience in AWS, particularly around networking.
