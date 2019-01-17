local g = import 'grafana-builder/grafana.libsonnet';

{
  grafanaDashboards+:: {
    'k8s-storage-resources-glusterfs-pv.json':
      local tableStyles = {
        fop: {
          alias: 'File Operations',
        },
      };
      local statPanelArgs = {
        height: '75px',
        span: 3,
      };
      local brickStatPanelArgs = {
        height: '75px',
        span: 4,
      };
      local graphPanelArgs = {
        span: 6,
      };

      // Following panels to be added in Volume Summary after IOPS panel (Once metrics are availabe)
      // .addPanel(
      //     g.panel('Rebalance-Files') +
      //     statPanelArgs +
      //     g.statPanel('')
      //   )
      //   .addPanel(
      //     g.panel('Rebalance-Size') +
      //     statPanelArgs +
      //     g.statPanel('')
      //   )
      //   .addPanel(
      //     g.panel('Rebalance-Skipped') +
      //     statPanelArgs +
      //     g.statPanel('')
      //   )
      //   .addPanel(
      //     g.panel('Rebalance-Failed') +
      //     statPanelArgs +
      //     g.statPanel('')
      //   )
      // The below variables needs to chanaged when cluster_id is introduced in the metrics
      // local queryLabels = "{job='$OCS_Cluster', volume='$Volume'}";
      // local fopQueryLabel = "{job='$OCS_Cluster', volume='$Volume', fop!=''}";
      // Below variables are defined considering that there is only one gluster cluster.
      local queryLabels = "{volume='$Volume'}";
      local fopQueryLabel = "{volume='$Volume', fop!=''}";
      local fopLockQueryLabel = "{volume='$Volume',fop='LOCK_OPS'}";
      local fopInodeQueryLabel = "{volume='$Volume',fop='INODE_OPS'}";
      local fopEntryQueryLabel = "{volume='$Volume',fop='ENTRY_OPS'}";
      local fopReadWriteQueryLabel = "{volume='$Volume',fop='READ_WRITE_OPS'}";

      // g.dashboard(
      //   'K8s / Storage Resources / Persistent Volume / glusterfs',
      //   uid=($._config.grafanaDashboardIDs['k8s-storage-resources-glusterfs-pv.json']),
      // ).addTemplate('OCS_Cluster', 'gluster_volume_up', 'job')
      // .addTemplate('Volume', 'gluster_volume_up{job = "$OCS_Cluster"}', 'volume')
      g.dashboard(
        'K8s / Storage Resources / Persistent Volume / glusterfs',
        uid=($._config.grafanaDashboardIDs['k8s-storage-resources-glusterfs-pv.json']),
      )
      .addTemplate('Volume', 'gluster_volume_up', 'volume')
      .addRow(
        (g.row('Volume Summary') +
         {
           showTitle: false,
           panels: self._panels,
         })
        .addPanel(
          g.panel('Status') +
          statPanelArgs +
          g.statPanel('gluster_volume_up{volume = "$Volume"}') +
          {
            valueMaps: [
              {
                op: '=',
                text: 'DOWN',
                value: '0',
              },
              {
                value: '1',
                op: '=',
                text: 'UP',
              },
            ],
            thresholds: '0.9,1.1',
            colors: [
              '#cc0000',
              '#92d400',
              '#FFFFFF',
            ],
            colorValue: true,
          }
        )
        .addPanel(
          g.panel('Capacity Utilization') +
          statPanelArgs +
          g.statPanel('gluster:volume_capacity_used_bytes_total:sum%s / gluster:volume_capacity_total_bytes:sum%s' % [queryLabels, queryLabels])
        )
        .addPanel(
          g.panel('Available Capacity') +
          statPanelArgs +
          g.statPanel('gluster:volume_capacity_total_bytes:sum%s - gluster:volume_capacity_used_bytes_total:sum%s' % [queryLabels, queryLabels], 'decbytes')
        )
        .addPanel(
          g.panel('IOPS') +
          statPanelArgs +
          g.statPanel('(sum (gluster_volume_profile_total_reads_interval%s) + sum(gluster_volume_profile_total_writes_interval%s))/max(gluster_volume_profile_duration_secs_interval%s)' % [queryLabels, queryLabels, queryLabels], 'none')
        )
        .addPanel(
          g.panel('Capacity Utilization') +
          graphPanelArgs +
          g.queryPanel('gluster:volume_capacity_used_bytes_total:sum%s' % queryLabels, '{{$Volume}}') +
          g.stack +
          { yaxes: g.yaxes('decbytes') },
        )
        .addPanel(
          g.panel('IOPS') +
          {
            span: 6,
            legend+: { show: false },
          } +
          g.queryPanel('(sum (gluster_volume_profile_total_reads_interval%s) + sum(gluster_volume_profile_total_writes_interval%s))/max(gluster_volume_profile_duration_secs_interval%s)' % [queryLabels, queryLabels, queryLabels], '{{$Volume}}') +
          g.stack
        )
      )
      .addRow(
        g.row('LVM Summary')
        .addPanel(
          g.panel('LVM Thin Pool Metadata %') +
          g.queryPanel('100*(gluster_thinpool_metadata_used_bytes%s / gluster_thinpool_metadata_total_bytes%s)' % [queryLabels, queryLabels], '{{thinpool_name}}')
        )
        .addPanel(
          g.panel('LVM Thin Pool Data Usage  %') +
          g.queryPanel('100*(gluster_thinpool_data_used_bytes%s / gluster_thinpool_data_total_bytes%s)' % [queryLabels, queryLabels], '{{thinpool_name}}')
        )
      )
      .addRow(
        (g.row('Bricks (Volume Subcomponent) Summary') +
         {
           showTitle: false,
           panels: self._panels,
         })
        .addPanel(
          g.panel('Bricks-Total') +
          brickStatPanelArgs +
          g.statPanel('gluster_volume_brick_count%s' % queryLabels, 'none')
        )
        .addPanel(
          g.panel('Bricks-Up') +
          brickStatPanelArgs +
          g.statPanel('count (gluster_brick_up%s == 1)' % queryLabels, 'none') +
          {
            thresholds: '0.1,0.9',
            colors: [
              '#FFFFFF',
              '#FFFFFF',
              '#92d400',
            ],
            colorValue: true,
          }
        )
        .addPanel(
          g.panel('Bricks-Down') +
          brickStatPanelArgs +
          g.statPanel('count(gluster_brick_up%s) - count (gluster_brick_up%s == 1)' % [queryLabels, queryLabels], 'none') +
          {
            thresholds: '0.1,0.9',
            colors: [
              '#FFFFFF',
              '#FFFFFF',
              '#cc0000',
            ],
            colorValue: true,
          }
        )
        .addPanel(
          g.panel('Capacity Utilization-Average') +
          brickStatPanelArgs +
          g.statPanel('avg (gluster_brick_capacity_used_bytes%s / gluster_brick_capacity_bytes_total%s)' % [queryLabels, queryLabels])
        )
        .addPanel(
          g.panel('Capacity Utilization-Min') +
          brickStatPanelArgs +
          g.statPanel('min (gluster_brick_capacity_used_bytes%s / gluster_brick_capacity_bytes_total%s)' % [queryLabels, queryLabels])
        )
        .addPanel(
          g.panel('Capacity Utilization-Max') +
          brickStatPanelArgs +
          g.statPanel('max (gluster_brick_capacity_used_bytes%s / gluster_brick_capacity_bytes_total%s)' % [queryLabels, queryLabels])
        )
        .addPanel(
          g.panel('Brick Usage < 80%') +
          brickStatPanelArgs +
          g.statPanel('count((gluster_brick_capacity_used_bytes%s / gluster_brick_capacity_bytes_total%s) < 0.8)' % [queryLabels, queryLabels], 'none')
        )
        .addPanel(
          g.panel('Brick Usage > 80% < 90%') +
          brickStatPanelArgs +
          g.statPanel('count((gluster_brick_capacity_used_bytes%s / gluster_brick_capacity_bytes_total%s) < 0.9) - count((gluster_brick_capacity_used_bytes%s / gluster_brick_capacity_bytes_total%s) < 0.8)' % [queryLabels, queryLabels, queryLabels, queryLabels], 'none')
        )
        .addPanel(
          g.panel('Brick Usage > 90%') +
          brickStatPanelArgs +
          g.statPanel('count(gluster_brick_capacity_used_bytes%s) - count((gluster_brick_capacity_used_bytes%s / gluster_brick_capacity_bytes_total%s) < 0.9)' % [queryLabels, queryLabels, queryLabels], 'none')
        )
        .addPanel(
          g.panel('IOPS - Avg') +
          brickStatPanelArgs +
          g.statPanel('avg((gluster_volume_profile_total_reads_interval%s + gluster_volume_profile_total_writes_interval%s) /gluster_volume_profile_duration_secs_interval%s)' % [queryLabels, queryLabels, queryLabels], 'none')
        )
        .addPanel(
          g.panel('IOPS - Min') +
          brickStatPanelArgs +
          g.statPanel('min((gluster_volume_profile_total_reads_interval%s + gluster_volume_profile_total_writes_interval%s) /gluster_volume_profile_duration_secs_interval%s)' % [queryLabels, queryLabels, queryLabels], 'none')
        )
        .addPanel(
          g.panel('IOPS - Max') +
          brickStatPanelArgs +
          g.statPanel('max((gluster_volume_profile_total_reads_interval%s + gluster_volume_profile_total_writes_interval%s) /gluster_volume_profile_duration_secs_interval%s)' % [queryLabels, queryLabels, queryLabels], 'none')
        )
        .addPanel(
          g.panel('Heal Counts-Total Files') +
          brickStatPanelArgs + { span: 6 } +
          g.statPanel('sum (gluster_volume_heal_count%s)' % queryLabels, 'none')
        )
        .addPanel(
          g.panel('Heal Counts-Files in Split-Brain') + { span: 6 } +
          brickStatPanelArgs + { span: 6 } +
          g.statPanel('sum (gluster_volume_split_brain_heal_count%s)' % queryLabels, 'none')
        )
      )
      .addRow(
        (g.row('Volume Profiling') +
         {
           showTitle: false,
           panels: self._panels,
         })
        .addPanel(
          g.panel('Top file operation') +
          {
            span: 4,
          } +
          g.tablePanel([
            'sort(sum(gluster_volume_profile_fop_avg_latency%s)by (fop))' % fopQueryLabel,
            '',
          ], tableStyles {
            Value: { alias: 'Avg Latency' },
          })
        )
        .addPanel(
          g.panel('File Operations For Locks Trends') +
          {
            span: 4,
            legend+: { show: false },
          } +
          g.queryPanel('sum(gluster_volume_profile_fop_total_hits_on_aggregated_fops%s) by (volume)' % fopLockQueryLabel, '') +
          g.stack
        )
        .addPanel(
          g.panel('File Operations for Read/Write') +
          {
            span: 4,
            legend+: { show: false },
          } +
          g.queryPanel('sum(gluster_volume_profile_fop_total_hits_on_aggregated_fops%s) by (volume)' % fopReadWriteQueryLabel, '') +
          g.stack
        )
        .addPanel(
          g.panel('File Operations for Inode Operations') +
          {
            span: 6,
            legend+: { show: false },
          } +
          g.queryPanel('sum(gluster_volume_profile_fop_total_hits_on_aggregated_fops%s) by (volume)' % fopInodeQueryLabel, '') +
          g.stack
        )
        .addPanel(
          g.panel('File Operations for Entry Operations') +
          {
            span: 6,
            legend+: { show: false },
          } +
          g.queryPanel('sum(gluster_volume_profile_fop_total_hits_on_aggregated_fops%s) by (volume)' % fopEntryQueryLabel, '') +
          g.stack
        )
      ),
  },
}
