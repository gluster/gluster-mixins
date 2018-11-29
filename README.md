# Prometheus Monitoring Mixin for Gluster

A set of Grafana dashboards and Prometheus alerts for Gluster.

The scope of this project is to provide Gluster specific Grafana dashboard configs and Prometheus rule files using Prometheus Mixins. 

## Prerequisites
1. Jsonnet ([How to Install Jsonnet?](https://github.com/google/jsonnet#building-jsonnet))

## How to use?
1. `$ git clone https://github.com/gluster/gluster-mixins.git`
2. `$ cd gluster-mixins`
3. `$ make prometheus_alerts.yaml`
4. `$ make prometheus_rules.yaml`
5. `$ make dashboards_out`

The `prometheus_alerts.yaml` and `prometheus_rules.yaml` files then needs to be passed to your Prometheus Server, and the files in `dashboards_out` needs to be passed to your Grafana server.

## Background
* [Prometheus Monitoring Mixin design doc](https://docs.google.com/document/d/1A9xvzwqnFVSOZ5fD3blKODXfsat5fg6ZhnKu9LK3lB4/edit#)
