local mi = import 'mixin.libsonnet';

{
  _config+:: {
    namespace: 'monitoring',
    
    prometheus+::{
      name: 'prometheus',
      rules: {},
    }
  },

  prometheus+:: {
    [if mi.prometheusAlerts != null && mi.prometheusAlerts != {} then 'rules']:
      {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'PrometheusRule',
        metadata: {
          labels: {
            prometheus: $._config.prometheus.name,
            role: 'alert-rules',
          },
          name: 'prometheus-' + $._config.prometheus.name + '-rules',
          namespace: $._config.namespace,
        },
        spec: {
          groups: mi.prometheusAlerts.groups,
        },
      },
  }
}
