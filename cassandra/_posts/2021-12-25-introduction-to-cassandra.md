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
- Horizontal scaling (refers to bringing additional nnodes to share the load when vertical scaling refers to increasing the power of a single server or cluster)
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


