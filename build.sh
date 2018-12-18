#!/bin/sh
echo 'Generating prometheus_alerts.yaml'
jsonnet  -S -e 'std.manifestYamlDoc((import "alert-object.libsonnet").prometheus.rules)' > prometheus_alerts.yaml
echo 'Generating prometheus_rules.yaml'
jsonnet -S -e 'std.manifestYamlDoc((import "rule-object.libsonnet").prometheus.rules)' > prometheus_rules.yaml
echo 'Finished.'
