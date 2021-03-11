# OpenTelemetry Metrics

**Status**: [Experimental](../document-status.md)

**Owner:**

* [Reiley Yang](https://github.com/reyang)

**Domain Experts:**

* [Bogdan Brutu](https://github.com/bogdandrutu)
* [Josh Suereth](https://github.com/jsuereth)
* [Joshua MacDonald](https://github.com/jmacd)

Note: this specification is subject to major changes. To avoid thrusting
language client maintainers, we don't recommend OpenTelemetry clients to start
the implementation unless explicitly communicated via
[OTEP](https://github.com/open-telemetry/oteps#opentelemetry-enhancement-proposal-otep).

<details>
<summary>
Table of Contents
</summary>

* [Overview](#overview)
  * [Design Goals](#design-goals)
  * [Concepts](#concepts)
    * [API](#api)
    * [SDK](#sdk)
* [Specifications](#specifications)
  * [Metrics API](./api.md)
  * Metrics SDK (not available yet)
  * Metrics Data Model and Protocol (not available yet)
  * [Semantic Conventions](./semantic_conventions/README.md)

</details>

## Overview

### Design Goals

Given there are many well-established metrics solutions that exist today, it is
important to understand the goals of OpenTelemetry’s metrics effort:

* **Being able to connect metrics to other signals**. For example, metrics and
  traces can be correlated via exemplars, and metrics dimensions can be enriched
  via [Baggage](../baggage/api.md) and [Context](../context/context.md).
  Additionally, [Resource](../resource/sdk.md) can be applied to
  [logs](../overview.md#log-signal)/[metrics](../overview.md#metric-signal)/[traces](../overview.md#tracing-signal)
  in a consistent way.

* **Providing a path for [OpenCensus](https://opencensus.io/) customers to
  migrate to OpenTelemetry**. This was the original goal of OpenTelemetry -
  converging OpenCensus and OpenTracing. We will focus on providing the
  semantics and capability, instead of doing a 1-1 mapping of the APIs.

* **Working with existing metrics instrumentation protocols and standards**. The
  minimum goal is to provide full support for
  [Prometheus](https://prometheus.io/) and
  [StatsD](https://github.com/statsd/statsd) - users should be able to use
  OpenTelemetry clients and [Collector](../overview.md#collector) to collect and export metrics, with the
  ability to achieve the same functionality as their native clients.

### Concepts

#### API

The **OpenTelemetry Metrics API** ("the API" hereafter) serves two purposes:

* Capturing raw measurements efficiently and simultaneously.
* Allowing [SDK](#sdk) injection at runtime.

If there is no [SDK](#sdk) injected, all the data reported via the API will be
dropped on the floor.

#### SDK

The **OpenTelemetry Metrics SDK** ("the SDK" hereafter) implements the API,
providing functionality and extensibility such as configuration, aggregation,
processors and exporters.

OpenTelemetry requires a [separation of the API from the
SDK](../library-guidelines.md#requirements), so that different SDKs can be
configured at run time.

#### Programming Model

```text
MeterProvider
  Meter A
    Measurement X
    Measurement Y
  Meter B
    Measurement Z
```

## Specifications

* [Metrics API](./api.md)
* Metrics SDK (not available yet)
* Metrics Data Model and Protocol (not available yet)
* [Semantic Conventions](./semantic_conventions/README.md)

## References

* Scenarios for Metrics API/SDK Prototyping ([OTEP 146](https://github.com/open-telemetry/oteps/blob/main/text/metrics/0146-metrics-prototype-scenarios.md))