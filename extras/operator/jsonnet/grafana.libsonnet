local k = import 'ksonnet/ksonnet.beta.3/k.libsonnet';

{
  _config+:: {
    namespace: 'default',
  },
  grafana+:: {
    dashboardDefinitions:
      local configMap = k.core.v1.configMap;
      [
        local dashboardName = 'grafana-dashboard-' + std.strReplace(name, '.json', '');
        configMap.new(dashboardName, { [name]: std.manifestJsonEx($._config.grafana.dashboards[name], '    ') }) +
        configMap.mixin.metadata.withNamespace($._config.namespace)
        for name in std.objectFields($._config.grafana.dashboards)
      ],
  },
}
