---
title: Linode
start: "2018-11-05T08:00:00.000Z"
end: "2019-03-22T17:00:00.000Z"
description: "QA Automation Engineer"
---

<a href="https://www.linode.com/" target="_blank">Linode</a>

## Role Recap

Was on the front-end team responsible for modernizing the Cloud Manager UI to a React single page application. Created test cases in the <a href="https://webdriver.io/" target="_blank">Webdriver.io</a> automated test suite, maintained the Jenkins jobs for running the automated tests, performed manual testing prior to each release, was responsible for the manual process of upgrading the .debian package with a new version of the UI on the production server for each bi-weekly release, publishing the release notes, as well as developing developer efficiency tooling.

## Accomplishments

- Contributed to the Webdriver.io test suite against the application as well as the Storybook components. Added support for utilizing multiple Test accounts with different levels of permission sets.

- Maintained and contributed to CircleCI PR gates.

- Developed a POC image diff framework that leveraged Webdriver.io to capture screenshots of the Cloud Manager UI components and compare against baseline images using <a href="https://www.npmjs.com/package/resemblejs" target="_blank">resemble.js</a> for image comparison. The back-end application was mocked with static responses served by <a href="http://www.mbtest.org/docs/api/mocks" target="_blank">mountebank</a>. I created a Docker build for mocked front-end with Mountebank, and a Docker-Compose file to run in detached mode so the Webdriver.io against the local build in CI. The results were published to an allure report.

- Developed a Python script to generate release notes based on conventional commit messages.

- Worked with the DevOps team to streamline the Jenkins job for deploying changes to the development environment.

## Reason for Leaving

Upper management was rapidly shifting project priorities, and I had the opportunity to return to Nuix which ultimately at the time felt like a better fit for where I was at in my career. But the position was a very good learning experience, and I gained a lot of technical knowledge especially with Docker and Python.
