{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'gluster-utilization',
        rules: [
          {
            alert: 'GlusterVolumeUtilization',
            expr: |||
              100 * gluster:volume_capacity_used_bytes_total:sum
                  / gluster:volume_capacity_total_bytes:sum > 80
            |||,
            'for': $._config.volumeUtilizationAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Gluster Volume {{$labels.volume}} Utilization more than 80%',
            },
          },
          {
            alert: 'GlusterVolumeUtilization',
            expr: |||
              100 * gluster:volume_capacity_used_bytes_total:sum
                  / gluster:volume_capacity_total_bytes:sum > 90
            |||,
            'for': $._config.volumeUtilizationAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Gluster Volume {{$labels.volume}} Utilization more than 90%',
            },
          },
          {
            alert: 'GlusterBrickUtilization',
            expr: |||
              100 * gluster_brick_capacity_used_bytes{%(glusterExporterSelector)s}
                  / gluster_brick_capacity_bytes_total{%(glusterExporterSelector)s} > 80
            ||| % $._config,
            'for': $._config.volumeUtilizationAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Gluster Brick {{$labels.host}}:{{$labels.brick_path}} Utilization more than 80%',
            },
          },
          {
            alert: 'GlusterBrickUtilization',
            expr: |||
              100 * gluster_brick_capacity_used_bytes{%(glusterExporterSelector)s}
                  / gluster_brick_capacity_bytes_total{%(glusterExporterSelector)s} > 90
            ||| % $._config,
            'for': $._config.volumeUtilizationAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Gluster Brick {{$labels.host}}:{{$labels.brick_path}} Utilization more than 90%',
            },
          },
        ],
      },
    ],
  },
}
