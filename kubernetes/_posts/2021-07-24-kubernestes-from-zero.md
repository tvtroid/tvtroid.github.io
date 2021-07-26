---
layout: post
title: "Kubernestes from Zero"
permalink: "/kubernetes/kubernestes-from-zero"
date: 2021-07-24 11:24:45 +0700
category: kubernetes
---
<h2>What is Kubernetes (k8s)?</h2>

**Ofical definition**
* Open source `container orchestration tool`
* Developed by `Google`
* Hepls you `manage containerized applications` (e.g. Docker) in different `deployment environments` (phycial, virtual, cloud machine)

**Why we need a container orchestration tool?**
* Trend from Monolith to `Microservices`
* Increased usage of `containers`
* Demand for a `proper way` of `managing` those hundreds of containers

**What features do orchestration tools offer?**
* `High Availability` or no downtime (app is always accessable)
* `Scalability` or high performance (load fast, response fast to users actions)
* `Disaster recovery` - backup and restore (data is lost, server error,... we still have mechanism to backup and restore -> not lose data)
