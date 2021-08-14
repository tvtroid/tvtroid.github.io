---
layout: post
title: "Minikube and kubectl"
permalink: "/kubernetes/minikube-and-kubectl"
date: 2021-08-13 11:24:45 +0700
category: kubernetes
---
## What is `Minikube`?
<img width="500" src="https://user-images.githubusercontent.com/87863039/129361051-42894cfe-3c76-477e-8494-34c44933a7bc.png">
<img width="500" src="https://user-images.githubusercontent.com/87863039/129361129-6fd31a58-1dc8-4fc7-beb7-2d0a6a1031f9.png">

## What is `kubectl`?
It's the command line tool to interact with Minikube cluster or Cloud cluster
<img width="500" src="https://user-images.githubusercontent.com/87863039/129361592-b9dd6cf2-f543-407f-a2c9-4ae85a3fbc76.png">

## Main `kubectl` commands
<img width="500" src="https://user-images.githubusercontent.com/87863039/129447534-920821cd-5670-48bd-886d-d15b863133a7.png">

* `kubectl get nodes`
* `kubectl get pods`
* `kubectl get services`

**Create Deployment - abstraction of Pod**

* `kubectl create deployment nginx-depl --image=nginx`
* `kubectl get deployment`
* `kubectl get pod`
* `kubectl get replicaset`

* ReplicaSet is a layer between Deployment and Pod

<img width="500" src="https://user-images.githubusercontent.com/87863039/129447973-083d3f95-af6e-43df-873b-d0eca39626e8.png">

**Edit Deployment**

* `kubectl edit deployment nginx-depl`
* `kubectl get pod`
* `kubectl get replicaset`

**Debug**

`kubectl logs [pod-name]`

**Login to terminal of the Pod**

* `kubectl exec -it [pod-name] -- bin/bash`
* `ls`
* `exit`

**Delete Deployment (Pod)**

* `kubectl delete deployment mongo-depl`

**Apply the config file**

* `kubectl apply -f [filename]`





