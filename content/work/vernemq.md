---
title: VerneMQ
weight: 20
tagline: Cluster fixes merged into an Erlang/OTP broker, and a chaos suite for testing them.
summary: Fixes contributed to VerneMQ, the Erlang/OTP MQTT broker, and a benchmark and chaos suite for testing its clusters under failure.
headline:
  value: "6"
  label: PRs merged upstream
facts:
  - label: Merged upstream
    value: "6"
  - label: Open upstream
    value: "6"
  - label: Chaos scenarios
    value: "11"
repo: https://github.com/ashtonian/vernemq-stress-test
---

## Problem

A VerneMQ cluster has to stay correct while nodes fail, restart, partition and rejoin. Those failures are hard to reproduce on a laptop and easy to miss in unit tests.

## Approach

- A benchmark and chaos suite provisions clusters on AWS with Terraform and Ansible, or runs the same scenarios locally in Docker, and drives load with emqtt-bench.
- Eleven scenarios: baseline throughput, node failure recovery, connection storms, node flapping, graceful shutdown, network partitions, slow nodes, rolling upgrades, cluster rebalance, netsplit recovery and subscription storms.
- Any git ref can be benchmarked, so a change is measured A/B against the release it modifies, or across several versions at once.

## Merged upstream

Into the broker, vernemq/vernemq:

{{< upstream repo="vernemq/vernemq" >}}

Into the container image and chart, vernemq/docker-vernemq:

{{< upstream repo="vernemq/docker-vernemq" >}}

## In review

Cluster auto-balancing, dynamic gossip, a fix for subscription loss under concurrent subscribes, modern TLS cipher suites, faster shared-subscription selection, and exponential backoff for inter-node connects.
