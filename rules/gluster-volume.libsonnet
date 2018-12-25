{
  prometheusRules+:: {
    groups+: [
      {
        name: 'gluster-volume.rules',
        rules: [
          {
            expr: |||
              sum(max(gluster_subvol_capacity_used_bytes{%(glusterExporterSelector)s}) BY (volume, subvolume)) BY (volume)
            ||| % $._config,
            record: 'gluster:volume_capacity_used_bytes_total:sum',
          },
          {
            expr: |||
              sum(max(gluster_subvol_capacity_total_bytes{%(glusterExporterSelector)s}) BY (volume, subvolume)) BY (volume)
            ||| % $._config,
            record: 'gluster:volume_capacity_total_bytes:sum',
          },
        ],
      },
    ],
  },
}
