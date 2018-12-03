#!/bin/sh
echo 'Removing prometheus_alerts.yaml'
rm prometheus_alerts.yaml
echo 'Removing dashboards_out/*'
rm -rf dashboards_out
echo 'Removing prometheus_rules.yaml'
rm prometheus_rules.yaml
echo 'Finished. Cleaned.'
