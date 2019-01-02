local k = import 'ksonnet/ksonnet.beta.3/k.libsonnet';
local configMapList = k.core.v1.configMapList;

(import 'grafana.libsonnet') +
(import 'prometheus.libsonnet') +
(import 'gluster-mixins/mixin.libsonnet') + {
  kubePrometheus+:: {
    namespace: k.core.v1.namespace.new($._config.namespace),
  },
  grafana+:: {
    dashboardDefinitions: configMapList.new(super.dashboardDefinitions),
  },
} + {
  _config+:: {
    namespace: 'default',

    prometheus+:: {
      rules: $.prometheusRules + $.prometheusAlerts,
    },
    grafana+:: {
      dashboards: $.grafanaDashboards,
    },
  },
}
