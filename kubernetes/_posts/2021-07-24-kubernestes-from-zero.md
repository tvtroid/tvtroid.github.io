---
layout: post
title: "Kubernestes from Zero"
permalink: "/kubernetes/kubernestes-from-zero"
date: 2021-07-24 11:24:45 +0700
category: kubernetes
---
## What is Kubernetes (k8s)?

**Ofical definition:**
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

## Kubernetes components

**Pod:**
* Smallest unit of K8s
* Abstraction over container (it creates a running environmennt or a layer on top of the containers -> we only interact with the Kubernetes layer)
* Usually 1 application per Pod
* Each Pod gets its own IP address (each pod can communicate each other via the IP address)
* New IP address on re-creation (hard to communicate -> Service will solve the problem)

<img width="200" src="https://user-images.githubusercontent.com/87863039/127009930-2926f6c8-66fe-4e12-be39-3dcd9e84720e.png">

**Service**
* static/permanent IP address (attach to each Pod)
* lifecyle of Pod and Service NOT connected (When Pod dead, Service is still alive => IP address is still accessable)
* external service -> open to public requests/browsers
* internal service -> not open to public requets (e.g. database)

**Ingress**
* Requests go to Ingress and it will be forwarded to Service
