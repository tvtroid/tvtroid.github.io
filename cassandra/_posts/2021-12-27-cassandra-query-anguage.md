---
layout: post
title: "Cassandra Query Language
permalink: "/cassandra/cassandra-query-language"
date: 2021-12-27 16:24:45 +0700
category: cassandra
---

## Create a keyspace

```
CREATE KEYSPACE demo WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
```
