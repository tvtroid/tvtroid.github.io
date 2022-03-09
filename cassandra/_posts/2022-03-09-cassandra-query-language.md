---
layout: post
title: "Cassandra Query Language"
permalink: "/cassandra/cassandra-query-language"
date: 2022-03-09 16:25:45 +0700
category: cassandra
---

## Create a keyspace

```
CREATE KEYSPACE demo WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
```

A keyspace (similar to database in relational DB) is a collection of database objects together, such as:
- tables (or column families)
- user-defined types
- user-defined functions
- replication settings
- and more!

The keyspace also controls the replication behavior for all of the data stored in the keyspace.
