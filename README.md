# Prometheus Monitoring Mixin for Gluster

A set of Grafana dashboards and Prometheus alerts for Gluster.

The scope of this project is to provide Gluster specific Grafana dashboard configs and Prometheus rule files using Prometheus Mixins.

## Prerequisites
* Jsonnet [[Install Jsonnet]](https://github.com/google/jsonnet#building-jsonnet)

   [Jsonnet](https://jsonnet.org/learning/getting_started.html) is a data templating language for app and tool developers.

   The mixin project uses Jsonnet to provide reusable and configurable configs for Grafana Dashboards and Prometheus Alerts.
* Jsonnet-bundler [[Install Jsonnet-bundler]](https://github.com/jsonnet-bundler/jsonnet-bundler#install)

   [Jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler) is a package manager for jsonnet.
* Promtool
  1. [Download](https://golang.org/dl/) Go (>=1.11) and [install](https://golang.org/doc/install) it on your system.
  2. Setup the [GOPATH](http://www.g33knotes.org/2014/07/60-second-count-down-to-go.html) environment.
  3. Run `$ go get -d github.com/prometheus/prometheus/cmd/promtool`  


## How to use?
### Manually generate configs and rules
You can clone this repository and manually generate Grafana Dashboard configs and Prometheus Rules files, and apply it according to your setup.

```
$ git clone https://github.com/gluster/gluster-mixins.git
$ cd gluster-mixins
```

**To get dependencies**

`$ jb install`


**To generate Prometheus Alert file**

`$ make prometheus_alerts.yaml`

**To generate Prometheus Rule file**

`$ make prometheus_rules.yaml`

**To generate Grafana Dashboard configs**

`$ make dashboards_out`

The **prometheus_alerts.yaml** and **prometheus_rules.yaml** files then needs to be passed to your Prometheus Server, and the files in **dashboards_out** needs to be passed to your Grafana server.

## Background
* [Prometheus Monitoring Mixin design doc](https://docs.google.com/document/d/1A9xvzwqnFVSOZ5fD3blKODXfsat5fg6ZhnKu9LK3lB4/edit#)
