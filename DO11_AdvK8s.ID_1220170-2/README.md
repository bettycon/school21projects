# Advanced Kubernetes

💡 [Tap here](https://new.oprosso.net/p/4cb31ec3f47a4596bc758ea1861fb624) **to leave your feedback on the project**. It's anonymous and will help our team make your educational experience better. We recommend completing the survey immediately after the project.

## Contents

1. [Chapter I](#chapter-i) 
2. [Chapter II](#chapter-ii) \
   2.1. [Deploying your own k3s cluster](#part-1-deploying-your-own-k3s-cluster) \

## Chapter I

Besides Docker Swarm, there are many other orchestration tools. One of the most popular is Kubernetes, a tool developed by Google. Kubernetes' main difference is its higher complexity and scale. Kubernetes is intended for more serious applications with a large number of services and complex interactions. It also has a number of additional built-in tools, such as an internal monitoring system.

## Chapter II

The result of the work must be a report with detailed descriptions and screenshots of the implementation of each point. Prepare the report as a Markdown file in the `src` directory named `REPORT.MD`.

## Part 1. Deploying your own k3s cluster

### Task 

1. Obtain a set of virtual machines for the cluster.

2. Install k3s on all three machines. During installation, do not use the standard Ingress Controller by adding the flag `--disable=traefik`.

3. Connect the nodes to the cluster using the `k3s server` command and the `-token` and `--server` flags for the worker and master nodes, respectively. Once k3s is installed, the environment variable `NODE_TOKEN` can be used.

4. Install the Ingress Controller Nginx instead of the default one. You can use the official nginx-based ingress controller manifest file available on GitHub.

5. Get a domain name and configure the `cert-manager` utility inside the cluster. This should generate a wildcard certificate for the domain.

6. Create an Ingress resource for your personal domain, and configure it to use the Nginx Ingress Controller and the obtained certificate.

7. Create a Persistent Volume (PV) for the PostgreSQL database in the manifest from the tenth project.

8. Run the application described in the manifest.

9. Run Postman functional tests to ensure that the application is working properly.

10. Install and run the Prometheus Operator to collect metrics in the system. Include the result of the `kubectl get pods -n monitoring` command in the report.