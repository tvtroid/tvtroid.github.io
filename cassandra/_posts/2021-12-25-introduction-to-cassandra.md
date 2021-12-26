---
layout: post
title: "Introduction to Cassandra"
permalink: "/cassandra/introduction-to-cassandra"
date: 2021-12-25 16:24:45 +0700
category: cassandra
---

## What is Cassandra?

Cassandra is a free and open-source, distributed, wide-column store, NoSQL database management system designed to handle large amounts of data across many commodity servers, providing high availability with no single point of failure. (_Wikipedia_)

<div style="text-align:center">
  <img src="https://user-images.githubusercontent.com/26586150/147382065-54ead0db-039b-4df5-9976-bcca579ea9c8.png" />
  <div style="text-align:center !important"><i>Cirles are Nodes, blue lines are distributed architechture</i></div>
</div>


### What is wide-column store database?

- It stores data using a column-oriented model
- Data is stored in cells grouped in columns of data rather than rows of data
- They use concept of keyspace (like schema in relational DB)
- Keyspace contain colum families (like tables), which contains rows, which contains columns

<div style="text-align:center">
  <img src="https://user-images.githubusercontent.com/26586150/147385596-ac6de2f1-db27-4a56-a45f-22f379f84766.png" />
</div>


### What is NoSQL database?
 
Typically, "NoSQL database" means non-relational database. Some people say "NoSQL" is "non SQL" while others say "not only SQL". Either way, most agree that NoSQL databases are databases that store in a format other than relational tables.

### Advantages

- Flexible schemas (Unlike relational DB, it requires a table's schema before inserting data, NoSQL can have diferrent numbers column/document)
- Horizontal scaling (refers to bringing additional nodes to share the load when vertical scaling refers to increasing the power of a single server or cluster)
- Fast queries due to data model
- Ease of use for developers

### Types of NoSQL database

There are four major types:
- **Document databases** store data in documents similar to JSON
- **Key-value databases** each item contains keys and values 
- **Wide-column store** stores data in tables, rows, and dynamic columns
- **Graph databases** store data in nodes and edges

<div style="text-align:center">
  <img src="https://user-images.githubusercontent.com/26586150/147398613-22b1d3e0-7d91-49cd-889d-0490551cc2e1.png" />
</div>

## Components of Cassandra Architecture

<div style="text-align:center">
  <img src="https://user-images.githubusercontent.com/26586150/147398729-731a9eb3-d7ef-445e-a3ad-9b60febb59c6.png" />
</div>

### Node

Node is a place where data is stored. It's the basic component of Cassandra.

### Data Center

A collection of nodes are called data center. Many node are caegoried as a data center.

### Cluster

The cluster is the collection of many data centers.

### Commit Log

Every write operation is written to Commit Log. It is used for crash recovery.

### Mem-table

After data written in Commit Log, data is written in Mem-table. Data is written in Mem-table temporarily.

### SSTable

When Mem-table reaches a certain threshold, data is flushed to a SSTable disk file.

## Data replication in Cassandra

As hardware problem can occur or link can be down at any time during data process, a solution is required to provide a backup when the problem is occured. So data is replicated for assuring no single point of failure.

Cassandra places replicas of data on different nodes based on two factors:
- **Replication Strategy**: where to place next replica
- **Replication Factor**: total numbers of replicas on different nodes.

One replication factor means that there is only a single copy of data while three replication factor mean that there are three copies of the data on three different nodes.

For ensuring no single point of failure, **replication factor must be three.**

There are 2 kinds of replication strategies in Cassandra:
- **SimpleStrategy** is used when you have just one data center.
- **NetworkTopologyStrategy** is used when you have (or plan to have) multiple data centers.

## Write operation in Cassandra

The coordinnator sends a write request to replicas. If all the replicas are up, they will receive write request regardless of their consitency level.

**Consistency level** determines how many nodes will respond back with the success acknowledgment.

The node will respond back with the success acknowledgment if data is written successfully to the commit log and mem-table.

> In a single data center with replication factor is three, three replicas will receive write request. If consistency level is one, only one replica will respond back with the success acknowledgment, and the remaining two will remain formant.

> Suppose if remaining two replicas lose data due to node down oe something else, Cassandra will make the row connsistent by it's built-in repair mechanism.

1. When write request comes to the node, first of all, it logs in the commit log.
2. Then Cassandra writes data in the mem-table. Data written in mem-table on each write request also writes in commit log separately. Mem-table is a temporarily stored data in the memmory while Commit log logs the transaction records for backup purposes.
3. When mem-table is full, data is flushed to the SSTable data file. 

<div style="text-align:center">
  <img src="https://user-images.githubusercontent.com/26586150/147400231-a7f96ae3-6e46-4534-9b53-cb11f2a30061.png" />
</div>

## Read operation in Cassandra

There are 3 types of read request: direct, digest and read repair request.

The coordinator sends direct request to one of the replicas. After that, the coordinator sends the digest request to the numbers of replicas specified by Consitency level and checks whether the returned data is an updated data.

After that, the coordinator send digest request to all the remaining replicas. If any node gives out of date value, a background read repair request will update that data. This process is called read repair mechanism.

## Cassandra data model rules


