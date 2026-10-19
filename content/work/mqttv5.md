---
title: mqttv5
weight: 10
tagline: A complete MQTT v5 client for Go, with failover, fan-out and durable delivery across brokers.
summary: A complete MQTT v5 client for Go. Reconnects, session resumption and durable publishing are built in, and three composable patterns span many brokers. Standard library only at its core.
headline:
  value: "3"
  label: multi-broker patterns
facts:
  - label: Multi-broker patterns
    value: "3"
  - label: Brokers in conformance CI
    value: "3"
  - label: Latest release
    value: v0.12.0
repo: https://github.com/ashtonian/mqttv5
---

## Problem

MQTT applications keep rebuilding the same supervision layer: reconnects, session resumption, redelivery of in-flight messages and re-subscription. Each part is easy to get subtly wrong, and it gets harder once an application talks to more than one broker. At high message rates, allocations on the publish path also show up as latency and garbage-collection load.

## Approach

- A supervisor inside every client handles reconnects, session resumption, in-flight replay and re-subscription.
- Delivery is the caller's choice: channels, bounded queues or callbacks, with manual acknowledgement and per-subscription backpressure.
- Durable publishing keeps working through broker outages and process restarts, using file-backed queues and session stores.
- The core uses only the standard library. Persistence, WebSocket transport and payload codecs are optional modules.

Three patterns cover talking to more than one broker, and they compose:

| Need | API | Connections |
|---|---|---|
| Fail over among interchangeable brokers or cluster nodes | `WithBrokers` | One at a time |
| Reach independent brokers that hold separate data | `ClientGroup` | One per member, all live |
| Publish faster to the same broker or brokers | `WithPublisherPool` | Extra publish-only connections |

Composed, they give bridging, regional high availability, quorum writes and sharding, each with a recipe in the documentation.

## Result

A conformance suite runs against mosquitto, EMQX and HiveMQ, alongside fuzzing and model-based tests.

Allocations per publish with a 1 KiB payload, against the same pinned mosquitto broker. Median of 10 runs, recorded 9 October 2026.

| QoS | mqttv5 | autopaho (v5) | paho (v3.1.1) |
|---|--:|--:|--:|
| 0 | **0** | 15 | 23 |
| 1 | **5** | 53 | 42 |
| 2 | **6** | 92 | 62 |
