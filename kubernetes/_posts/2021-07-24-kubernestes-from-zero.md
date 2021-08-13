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

**Pod**
* smallest unit of K8s
* abstraction over container (it creates a running environmennt or a layer on top of the containers -> we only interact with the Kubernetes layer)
* usually 1 application per Pod
* each Pod gets its own IP address (each pod can communicate each other via the IP address)
* new IP address on re-creation (hard to communicate -> Service will solve the problem)

<img width="500" src="https://user-images.githubusercontent.com/87863039/127009930-2926f6c8-66fe-4e12-be39-3dcd9e84720e.png">

**Service**
* static/permanent IP address (attach to each Pod)
* load balancer
* lifecyle of Pod and Service NOT connected (When Pod dead, Service is still alive => IP address is still accessable)
* external service -> open to public requests/browsers
* internal service -> not open to public requets (e.g. database)

**Ingress**
* requests go to Ingress and it will be forwarded to Service

**ConfigMap**
* external configuration of your application (urls of database or other services. Pod gets data from configMap. It helps Pods communicate wihout re-build images when we change endpoint of database, etc.)

**Secret**
* just like configMap but to store secret data
* base64 encoded

<img width="500" src="https://user-images.githubusercontent.com/87863039/127171992-58cf109a-d71f-4a90-8dd0-10d4353ac439.png">

**Volumes**
* is data storage of Pod
* physical storage in local or remote
* when DB Pod restarted, volumes keep data there
* K8s doesn't manage data persistance!

**Deployment**
* blueprint for my-app pods (define how many replica of Pods. When a Pod dies, app will connect to another Pod)
* you create Deployments
* abstraction of Pods
* DB can't be replicated via Deployment!
* for stateLESS apps

**StatefulSet**
* for stateFUL apps or Databases

=> Deployment and StatefulSet used for Replication -> avoid downtime

<img width="500" src="https://user-images.githubusercontent.com/87863039/127174947-d054bab5-30da-46bf-bb53-9836b54fcea7.png">

## Kubernetes Architecture
**Node (working machine in k8s cluster)
* each Node has multiple Pods on it
* 3 processes must be installed in every Node (Container runtime such as Docker, Kubelet - interacts with container runtime and Node/Machine, Kube Proxy - forwards the requests)
* Worker Nodes do the actual work

**Master Node
* 4 processes (API server-cluster gateway,acts as a gatekeeper for authentication; Scheduler-just decides on which Node new Pod should be scheduled,kubelet in each Node will do the actual schedule;Controller Manager-detects cluster state changes such as Pods die;etcd-cluster brain,key value store,cluster changes get stored into key value store,application data is NOT stored in etcd)
* `Api server` is load balanced
* `etcd` is distributed across all Master Nodes

<img width="500" src="https://user-images.githubusercontent.com/87863039/129358967-4f422878-b356-4106-b8ee-a1b7b0d78c2c.png">
<img width="500" src="https://user-images.githubusercontent.com/87863039/129358994-debb08c0-caad-4c92-acf1-d876713b7bcf.png">
<img width="500" src="https://user-images.githubusercontent.com/87863039/129359425-7d462d74-656a-4523-ac87-46622e994e7d.png">


