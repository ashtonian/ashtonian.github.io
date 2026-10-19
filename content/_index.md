---
title: Ashton Kinslow
lede: I design and build distributed systems in Go, from device messaging and brokers to the Kubernetes fleets they run on.
principles:
  - text: Measure before changing anything. Profiles, benchmarks and conformance suites decide, not intuition.
    evidence:
      - page: /work/mqttv5
  - text: Make failure explicit. Validate before applying, fail closed, change all or nothing.
    evidence:
      - page: /work/argo-fleet
      - name: pkg/config
        url: https://github.com/ashtonian/pkg/tree/main/config
  - text: Fix problems where they live, upstream when that is where the bug is.
    evidence:
      - page: /work/vernemq
      - page: /open-source
also:
  - name: pkg/config
    url: https://github.com/ashtonian/pkg/tree/main/config
    text: typed, layered configuration; validated, hot-reloaded, redacted
  - name: pkg/httpx
    url: https://github.com/ashtonian/pkg/tree/main/httpx
    text: retries, circuit breaking and caching as http.RoundTripper layers
  - name: pkg/gowalker
    url: https://github.com/ashtonian/pkg/tree/main/gowalker
    text: struct-tag plumbing for libraries configured by tags
  - name: gitten
    url: https://github.com/ashtonian/gitten
    text: repo sync across forges
  - name: go-ci-actions
    url: https://github.com/ashtonian/go-ci-actions
    text: Go CI caching
  - name: charmap
    url: https://github.com/ashtonian/charmap
    text: manifest value substitution
---
