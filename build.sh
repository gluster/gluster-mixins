#!/bin/sh
echo 'Generating prometheus_alerts.yaml'
#jsonnet -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' > prometheus_alerts.yaml
jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "prometheus.libsonnet").prometheus.rules)' > prometheus_alerts.yaml
echo 'Generating dashboards_out/*'
mkdir -p dashboards_out
jsonnet -m dashboards_out -e '(import "mixin.libsonnet").grafanaDashboards'
echo 'Generating prometheus_rules.yaml'
jsonnet -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)' > prometheus_rules.yaml
echo 'Finished.'
