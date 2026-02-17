# Final Project

💡 [Tap here](https://new.oprosso.net/p/4cb31ec3f47a4596bc758ea1861fb624) **to leave your feedback on the project**. It's anonymous and will help our team make your educational experience better. We recommend completing the survey immediately after the project.

## Contents

1. [Chapter I](#chapter-i) 
2. [Chapter II](#chapter-ii) \
   2.1. [CI and CD setup](#part-1-ci-and-cd-setup)

## Chapter I

Now it's time to apply all the knowledge you've gained in this course to a final project dedicated to the full cycle of applying DevOps practices to an application. For this task, find a microservice application and walk it through all the stages, from containerization to pipeline setup on a working GitLab repository.

## Chapter II

The final product must be a report containing detailed descriptions of how each point was implemented, accompanied by screenshots. Prepare the report as a Markdown file in the `src` directory named `REPORT.MD`.

## Part 1. CI and CD Setup

### Task:

1. Find an open-source project on GitHub or GitLab consisting of at least three microservices, one service with a database, and one frontend.

2. Write Dockerfiles for the selected project, if necessary.

3. Write unit tests for microservices with application business logic, if necessary.

4. Develop a Helm chart for deploying the selected application.

5. Develop a pipeline for deploying the application consisting of four stages:
   - build,
   - test,
   - staging,
   - prod.

6. Set up CI/CD to deploy the application using the GitLab Runner in Kubernetes.