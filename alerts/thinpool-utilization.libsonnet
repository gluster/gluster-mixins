{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'thinpool-utilization',
        rules: [
          {
            alert: 'GlusterThinpoolDataUtilization',
            expr: |||
              gluster_thinpool_data_used_bytes{%(glusterExporterSelector)s} / gluster_thinpool_data_total_bytes{%(glusterExporterSelector)s} > 0.8
            ||| % $._config,
            'for': $._config.thinpoolAlertTriggerTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Gluster Thinpool {{ $labels.thinpool_name }} Data Utilization more than 80%',
            },
          },
          {
            alert: 'GlusterThinpoolDataUtilization',
            expr: |||
              gluster_thinpool_data_used_bytes{%(glusterExporterSelector)s} / gluster_thinpool_data_total_bytes{%(glusterExporterSelector)s} > 0.9
            ||| % $._config,
            'for': $._config.thinpoolAlertTriggerTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Gluster Thinpool {{ $labels.thinpool_name }} Data Utilization more than 90%',
            },
          },
          {
            alert: 'GlusterThinpoolMetadataUtilization',
            expr: |||
              gluster_thinpool_metadata_used_bytes{%(glusterExporterSelector)s} / gluster_thinpool_metadata_total_bytes{%(glusterExporterSelector)s} > 0.8
            ||| % $._config,
            'for': $._config.thinpoolAlertTriggerTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Gluster Thinpool {{ $labels.thinpool_name }} Metadata Utilization more than 80%',
            },
          },
          {
            alert: 'GlusterThinpoolMetadataUtilization',
            expr: |||
              gluster_thinpool_metadata_used_bytes{%(glusterExporterSelector)s} / gluster_thinpool_metadata_total_bytes{%(glusterExporterSelector)s} > 0.9
            ||| % $._config,
            'for': $._config.thinpoolAlertTriggerTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Gluster Thinpool {{ $labels.thinpool_name }} Metadata Utilization more than 90%',
            },
          },
        ],
      },
    ],
  },
}
