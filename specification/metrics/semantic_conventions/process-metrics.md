# Semantic Conventions for OS Process Metrics

This document describes instruments and labels for common OS process level
metrics in OpenTelemetry. Also consider the general [semantic conventions for
system metrics](system-metrics.md) when creating instruments not explicitly
defined in this document. OS process metrics are not related to the specific
runtime environment of the program, and should take measurements from the
operating system. For runtime environment metrics see [semantic conventions
for runtime environment metrics](runtime-environment-metrics.md).

<!-- Re-generate TOC with `markdown-toc --no-first-h1 -i` -->

<!-- toc -->

- [Metric Instruments](#metric-instruments)
  * [Standard Process Metrics - `process.`](#standard-process-metrics---process)

<!-- tocstop -->

## Metric Instruments

### Standard Process Metrics - `process.`

TODO