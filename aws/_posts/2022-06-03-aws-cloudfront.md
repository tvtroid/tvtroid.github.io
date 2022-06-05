---
layout: post
title: "AWS Cloudfront"
permalink: "/aws/aws-cloudfront"
date: 2022-06-03 16:25:45 +0700
category: aws

---

## What is AWS CloudFront?

CloudFront is a fast **content delivery network** (CDN) service that **securely** delivers contents (data, videos, applications, and APIs) to customers globally with **low latency, high transfer speeds**, all within a **developer-friendly environment**.

It speeds up distribution of the static and dynamic web content (.html, .css, .js, and image files) to end users through a worldwide network of data centers called **edge locations**.

Other CDN providers: StackPath, Sucuri, Cloudflare, KeyCDN, Rackspace, Google Cloud CDN, CacheFly

## How does CloudFront work?

![cloudfront](https://user-images.githubusercontent.com/87863039/172003279-b7b45713-86c1-48b0-9064-c9933de770a4.jpeg)

When a user requests content that is serving with CloudFront, the request is routed to the edge location that provides the lowest latency (time delay), so that content is delivered with the best possible performance.
- If the content is already in the edge location with the lowest latency, CloudFront delivers it immediately. -> increase reliability and availability because copies of contents are now cached in multiple edge locations around the world.
- Otherwise, CloudFront retrieves it from an origin that we’ve defined (S3, EC2 or a web server). The content will be cached for later requests.

## Low latency and high transfer speeds

- Amazon CloudFront is massively scaled and globally distributed. It includes 225+ points of presence (PoPs)/ Edge locations
- The AWS backbone is a private network built on a global, fully redundant, parallel 100 GbE metro fiber network linked via trans-oceanic cables across the Atlantic, Pacific, and Indian Oceans, as well as, the Mediterranean, Red Sea, and South China Seas.
- It automatically maps network conditions and intelligently routes the user’s traffic to the most performant AWS edge location. It provides ulti-tiered caching architecture (Endpoint cache, Regional cache, CDN cache, Metadata server cache) by default that improves cache size and origin protection.

## Securely

- CloudFront is a highly secure CDN that provides both network and application level protection. All CloudFront distributions are defended by default with AWS Shield Standard which will against the most frequently occurring network and transport layer DDoS attacks that target the websites or applications.
- We can also add a flexible security to against more complex attacks by integrating CloudFront with AWS Shield Advanced and AWS Web Application Firewall (WAF).

## Developer-friendly environment

- CloudFront is integrated with AWS services such as S3, EC2, Elastic Load Balancing, Route 53, and Elemental Media Services for easy set-up.
- As developers, we can use the AWS management console or familiar developer tools to observe metrics and logs easily via Cloudwatch and Kinesis.
- With edge compute features CloudFront Functions and Lambda@Edge, you can easily run code across AWS locations globally, allowing you to personalize content and respond to your end users with improved latency.
- CloudFront Functions:
- Lambda@Edge

## Use cases

- Deliver fast, secure websites: a news website Reuters delivers websites to billions securely. (https://aws.amazon.com/blogs/storage/a-look-inside-how-global-multimedia-agency-reuters-uses-amazon-web-services/?pg=ln&sec=c)
- Accelerate dynamic content delivery and APIs: Slack uses Amazon CloudFront to improve their security posture (https://www.youtube.com/watch?v=oVaTiRl9-v0)
- Stream live and on-demand video: Hulu uses Amazon CloudFront to consistently stream high-quality video (https://www.youtube.com/watch?v=EJQkBd_-CMo&t=168s)
- Distribute patches and updates: King delivers game updates to 200+ countries with Amazon CloudFront (https://aws.amazon.com/blogs/aws/king-using-amazon-cloudfront-to-deliver-mobile-games-to-over-200-countries/?pg=ln&sec=c)

## Common issues in CND

- Delay in content to customers
- Caching issues

## References: 
- https://aws.amazon.com/cloudfront/
- https://medium.com/mindful-engineering/today-we-will-learn-about-cloudfront-690bf3a8819a
- https://wpforms.com/best-cdn-providers/
- https://aws.amazon.com/blogs/aws/introducing-cloudfront-functions-run-your-code-at-the-edge-with-low-latency-at-any-scale/
- https://www.missioncriticalmagazine.com/articles/89804-multi-tier-caching-speeds-cloud-storage
