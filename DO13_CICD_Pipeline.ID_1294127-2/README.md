# Continuous integration and delivery 

💡 [Tap here](https://new.oprosso.net/p/4cb31ec3f47a4596bc758ea1861fb624) **to leave your feedback on the project**. It's anonymous and will help our team make your educational experience better. We recommend completing the survey immediately after the project.

## Contents

1. [Chapter I](#chapter-i) 
2. [Chapter II](#chapter-ii) \
   2.1. [CI and CD setup](#part-1-ci-and-Cd-setup)

## Chapter I

**CI/CD** is a set of practices that allows developers to streamline the application deployment process. With continuous integration, the application development process is presented as a sequence of small iterations, each of which aims to maintain continuity when integrating changes. This means that code modifications are automatically built and tested in the version control system with each significant change. Continuous delivery deploys the built application to the target environment. Thus, CI/CD principles enable changes to safely and continuously reach production.

## Chapter II

The result of the work must be a report with detailed descriptions and screenshots of the implementation of each point. Prepare the report as a Markdown file in the `src` directory named `REPORT.MD`.

## Part 1. CI and CD Setup

### Task:

1. Clone a working repository.

2. Get access to a remote Kubernetes cluster.

3. Create a separate namespace for the GitLab Runner.

4. Install a GitLab Runner in a Kubernetes cluster: use the Helm chart for the GitLab Runner to install it in your Kubernetes cluster. The Helm chart automatically creates a deployment for the Runner, which creates one or more modules that execute application container jobs.

5. Create a secret to store the GitLab registration token.

6. Create a `config.toml` configuration file to use the Kubernetes Runner installed on the given cluster. In this file, you must also specify the resource limits and the Docker image (e.g., `docker:stable`). Register the installed Runner using the configuration file.

7. Develop the following Pipeline:

   - build — building the application (run automatically for branches with the prefix `feature_`);
   - test — running unit tests and Postman functional tests via the Newman utility (run automatically for branches with the prefix `feature_`);
   - staging — running an application in a staging environment (run manually and only for tags).

8. Use secrets to pass private keys to services for authorization (`application.properties` file in the services' source code directory).

9. Make a change to the application code. Add a new dependency to the `pom.xml` file and commit the change.