{
  prometheusRules+:: {
    groups+: [
      {
        name: 'gluster-volume.rules',
        rules: [
          {
            expr: |||
               sum(max(gluster_subvol_capacity_used_bytes) by (job, volume, subvolume)) by (job, volume)
            ||| % $._config,
            record: 'gluster:volume_capacity_used_bytes_total:sum',
          },
        ],
      },
    ],
  },
}
