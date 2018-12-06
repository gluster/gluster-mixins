# Prometheus Monitoring Mixin for Gluster

A set of Grafana dashboards and Prometheus alerts for Gluster.

The scope of this project is to provide Gluster specific Grafana dashboard configs and Prometheus rule files using Prometheus Mixins.

## Prerequisites
1. Jsonnet [[Install Jsonnet]](https://github.com/google/jsonnet#building-jsonnet)

   [Jsonnet](https://jsonnet.org/learning/getting_started.html) is a data templating language for app and tool developers.

   The mixin project uses Jsonnet to provide reusable and configurable configs for Grafana Dashboards and Prometheus Alerts.

## How to use?
### Manually generate configs and rules
You can clone this repository and manually generate Grafana Dashboard configs and Prometheus Rules files, and apply it according to your setup.

```
$ git clone https://github.com/gluster/gluster-mixins.git
$ cd gluster-mixins
```

To generate Prometheus Alert file,

`$ make prometheus_alerts.yaml`

To generate Prometheus Rule file,

`$ make prometheus_rules.yaml`

To generate Grafana Dashboard configs,

`$ make dashboards_out`

The **prometheus_alerts.yaml** and **prometheus_rules.yaml** files then needs to be passed to your Prometheus Server, and the files in **dashboards_out** needs to be passed to your Grafana server.

## Background
* [Prometheus Monitoring Mixin design doc](https://docs.google.com/document/d/1A9xvzwqnFVSOZ5fD3blKODXfsat5fg6ZhnKu9LK3lB4/edit#)
