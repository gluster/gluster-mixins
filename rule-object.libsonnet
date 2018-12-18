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
    [if mi.prometheusRules != null && mi.prometheusRules != {} then 'rules']:
      {
        apiVersion: 'monitoring.coreos.com/v1',
        kind: 'PrometheusRule',
        metadata: {
          labels: {
            prometheus: $._config.prometheus.name,
            role: 'recording-rules',
          },
          name: 'prometheus-' + $._config.prometheus.name + '-rules',
          namespace: $._config.namespace,
        },
        spec: {
          groups: mi.prometheusRules.groups,
        },
      },
  }
}
