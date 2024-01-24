---
title: Philanthropi
start: "2022-05-16T08:00:00.000Z"
end: "2023-06-03T17:00:00.000Z"
description: "Senior DevOps Engineer"
---

<a href="https://philanthropi.com/" target="_blank">Philanthropi</a>

## Role Recap

Was the second DevOps engineer hired at an early stage startup. In my first 6 months, I was mentored by a great Lead DevOps engineer Michael Trihn. He left 6 months into my time in the role, leaving me as the sole DevOps and AWS Infrastructure engineer. Was responsible for developing the Github Actions to support developer and release workflows, develop AWS automation to support the testing team, implementing GitOps with Terraform and Ansible, supporting Bi-Weekly production releases, supporting the operation team's Payroll workflows, triage customer issues, and on-call site support.

## Accomplishments

- Implemented service discovery, service-to-service communication, and end-to-end encryption for applications running as ECS services using Consul service mesh. Deployed ECS services using the Hashicorp Consul <a href="https://github.com/hashicorp/terraform-aws-consul-ecs/tree/main/modules/mesh-task" target="_blank">mesh-task</a> module. Installed Consul server on an EC2 instance with an Ansible playbook.

- Developed a standardized Docker Nginx build with an entry point to configure front-end applications for different deployment environments. Utilized in the Consul service-mesh solution, the Nginx server was essentially the ingress into the mesh. The `/` path served the static front-end build, and the `/api/` path proxy passed to the API ECS service via the Consul data plane.

- Re-architected the Cloudfront and ALBs to act as reverse proxies into the Consul service-mesh, without caching the API responses. The ALB forwarded to the front-end ECS service, there was a separate A record created in Route53 and a lister rule that required a specific host name and forwarding header with a particular guid, the Cloudfront distribution acted as a reverse proxy to the ALB via the DNS record and appended the required header to the request.

- Implemented observability and monitoring in the ElasticSearch cloud. Assisted the development teams with implementing the Elastic APM/RUM tools in the code and transitioning backend logging to an elastic common schema compatible format. Wrote Ansible playbooks to provision the application Heartbeat health checks, AWS resource monitoring with MetricBeat, and AWS resource log collection with FileBeat. Built out meaningful dashboards and alerts from the data feeds in Kibana. Forwarded ECS application logs to ElasticSearch using a FluentBit sidecar container.

- Developed the Terraform modules, Ansible Playbooks, and Github Actions to implement GitOps.

- Created reusable Github Action callable workflows to standardize pull request checks, builds, and deployments across multiple repos. Developed repo-specific Composite Actions to capture repeated logic.

- Developed a framework in Github Actions to support the builds and deployments of a .NET monorepo, that made adding a new service relatively straightforward so the development team can add without needing DevOps team to intervene.

- Developed the build and publish workflows for the NPM component library using Github Actions and semantic release.

- Developed a solution for storing SSM parameters as IAC using Terraform <a href="https://registry.terraform.io/providers/bouk/ejson/latest" target="_blank">ejson module</a> and <a href="https://github.com/Shopify/ejson" target="_blank">ejson</a> to encrypt sensitive data. Created a Docker image to ease the developer workflow for adding SSM parameters, consisted of a custom YAML file that followed the format:

```
parameters:
    {environment: dev, test, stg, preprd, dr, prod}:
        - parameter: {parameter_name}
          value: {value}
          type: String || SecureString

```

the Docker image mounted in the YAML file. The ejson binary was installed during image build. The entry point was a Python script that parsed the YAML file and wrote the new parameters to the environment-specific Terraform vars file that was in JSON format that was a map of entries where the key was the name of the parameter and the only attribute was the parameter type, and create the entry in the environment-specific ejson file. String type parameters were prefixed with a `_` in the e ejson file and stored as plain text in git, SecureString were added to the ejson file without the prefix. Once all parameters were added the ejson binary was run to encrypt the data. The private keys for the environment-specific ejson files were stored in AWS Secret Manager.

- Implemented a Playwright test framework to provide comprehensive test coverage in PR and as a gate CI deployments. Leveraged a custom webpack built that injected the <a href="https://github.com/istanbuljs/babel-plugin-istanbul" target="_blank">babel-plugin-istanbul</a> plugin and upload coverage reports to <a href="https://about.codecov.io/" target="_blank">codecov.io</a>.

## Reason for Leaving

Was concerned with the stability of the company due to struggles finding funding, as well as the loss of key resources - Lead QA Engineer position vacated and not backfilled, as well as Lead DevOps Engineer.
