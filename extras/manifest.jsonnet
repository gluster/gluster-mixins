local mi = import 'gluster-mixins/mixin.libsonnet';

{
  _config+:: {
    namespace: 'monitoring',
    
    prometheus+::{
      name: 'prometheus',
      rules: mi.prometheusAlerts + mi.prometheusRules,
    }
  },

  prometheus+:: {
    [if $._config.prometheus.rules != null && $._config.prometheus.rules != {} then 'rules']:
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
          groups: $._config.prometheus.rules.groups,
        },
      },
  }
}
