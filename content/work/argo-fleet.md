---
title: argo-fleet
weight: 30
tagline: Four ways to deliver one Git repository to a Kubernetes fleet, weighed up to 10,000 clusters.
summary: Four ways to run the same applications across a fleet of Kubernetes clusters from one Git repository, weighed for one cluster, a few hundred and ten thousand.
headline:
  value: 1 → 10,000
  label: clusters modelled
facts:
  - label: Approaches, runnable
    value: "4"
  - label: Fleet sizes weighed
    value: 1 · 100s · 10,000
  - label: Tested on
    value: Argo CD 3.5
repo: https://github.com/ashtonian/argo-fleet
---

## Problem

Running the same applications on many clusters from one repository forces decisions that look small at one cluster and dominate at ten thousand. How clusters are grouped, how a revision is pinned, how a change is promoted, and how many directories someone has to maintain.

## Approach

- Four runnable approaches built on ApplicationSets: overlay, matrix, lovely with charmap, and native Kustomize.
- Each is weighed at three fleet sizes, assuming 20 base applications and two addons per cluster.
- CI installs the lovely and native approaches into kind clusters, with External Secrets delivering each cluster's identity, and validates the overlay and matrix manifests against Argo CD's schemas.

## Result

What the comparison shows at 10,000 clusters:

| Decision | Finding |
|---|---|
| Topology | A central Argo CD would reconcile 220,000 Applications. One per cluster avoids it. |
| Revision pinning | Tracking a branch costs about 56 Git requests a second, against GitHub's guidance of 15 per repository. Full commit SHAs cost none. |
| Directories to maintain | Native 31, lovely 30, matrix 30,125, overlay 220,025. |
