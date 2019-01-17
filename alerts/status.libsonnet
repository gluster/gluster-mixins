{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'status-alert.rules',
        rules: [
          {
            alert: 'GlusterBrickStatus',
            expr: |||
              gluster_brick_up{%(glusterExporterSelector)s} == 0
            ||| % $._config,
            'for': $._config.statusAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Gluster Brick {{$labels.hostname}}:{{$labels.brick_path}} is down.',
            },
          },
          {
            alert: 'GlusterVolumeStatus',
            expr: |||
              gluster_volume_up{%(glusterExporterSelector)s} == 0
            ||| % $._config,
            'for': $._config.statusAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Gluster Volume {{$labels.volume}} is down.',
            },
          },
        ],
      },
    ],
  },
}
