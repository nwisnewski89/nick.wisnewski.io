---
title: Nuix
start: "2019-03-11T08:00:00.000Z"
end: "2021-01-14T17:00:00.000Z"
description: "Senior SDET"
---

<a href="https://www.nuix.com/" target="_blank">Nuix</a>

## Role Recap

Re-joined the Investigate (formally Web Review) QA team after my brief tenure at Linode. Focused primarily on continuing scaling out the  <a href="https://gebish.org/" target="_blank">Geb</a> test automation suite for the Investigate product and develop new automation to support all aspects of the software development lifecyle. Then started to take on the role of the DevOps specialist on the Investigate team contributing to the Ansible Playbooks, Terraform deployments, and Jenkins jobs for provisioning ephemeral testing environments. Coached junior team members to be solid automation contributors, triaged customer issues, developed automated test cases for new features each sprint, and preformed regression prior to product releases.

## Accomplishments

* Wrote a Python script to check the git diff in a PR, and depending on the test case run the appropriate Gradle test target restricted to just the test class. Developed a Jenkins job to run the PR test job, which greatly improved the performance of the nightly runs of the test suite, ensuring that only quality tests were merged into main.

* Wrote a Python script that migrated all Nuix Cases in the test inventory using the Investigate migration API when a new engine version was incorporated into the product. Streamlined the process of getting test environments ready for release regression.

* Assisted the DevOps team in developing a framework to capture AMIs of test environments to speed up the cycles of testing different Investigate upgrade paths.

* Developed a Terraform deployment of Ubuntu 16.04 EC2 instance with Security Groups open for the Selenium Hub port and VNC ports and an Ansible playbook to install Docker and Docker-Compose then run a detached Docker-Compose file with Selenium Hub and Selenium Node images allowing the user to specify the number of nodes and the WebDriver type the node would run. Added this process to the test automation Jenkins job so that each run would have its own ephemeral Selenium Grid. The same logic was added to local test runs so that the test team could run against the same environment as the nightly regression runs. Additionally, I wrote a Bash script that supported opening a VNC viewer process into each Selenium Node container to get visual feedback of the test runs.

* Developed a Python CLI application that converted the <a href="https://spockframework.org/" target="_blank">Spock</a> BDD test classes to Cucumber files that would then publish the scenarios to <a href="https://cucumber.io/" target="_blank">Cucumber Test Studio</a> (formerly known as HipTest). Once the resources were published, a JSON file that mapped the test class name to the scenario ID was stored with the repo. Then I developed a Spock <a href="https://spockframework.org/spock/docs/1.1/extensions.html" target="_blank">interceptor</a> interface to publish the test results to capture the results of an automated test and publish to Cucumber Test Studio regression test runs.

* Was a major contributor to the Ansible playbook for provisioning ephemeral Investigate test and developer environments. I was the main contributor to the HA environments when Investigate was upgraded to using Spring Boot Cloud, provisioning multiple Investigate application servers, as well as the Registration and Gateway services. I developed the logic to set up Relaying party trusts against the testing ADFS server for and configure the Investigate and UMS service to utilize federated authentication so the team could efficiently test SAML authentication. My final contribution was adding the Terraform deployment of an Ubuntu 18.04 instance that ran an Nginx reverse proxy to multiple Gateway services, since many customers inquired if that setup would work.

## Reason for Leaving

Desired to focus more on automation and the manager of the DevOps team Nick Eldrige supported my interest to transition over.
