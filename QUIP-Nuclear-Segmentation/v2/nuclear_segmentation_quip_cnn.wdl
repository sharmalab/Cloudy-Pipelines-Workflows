task wsi_seg {
  File imageInput
  String result
  String CUDA_VISIBLE_DEVICES
  Int NPROCS
  String SEG_DOCKER_TAG
  Int SEG_MEMORY_GB
  String SEG_ZONES
  Int SEG_CPU_COUNT
  Int SEG_MAX_RETRIES
  Int SEG_DISK_GB
  Int SEG_BOOT_DISK_GB
  Int SEG_PREEMPTIBLE_COUNT
  String SEG_GPU_TYPE
  String SEG_NVIDIA_DRIVER_VERSION
  command {
    echo "$(date): Task: wsi_seg started"
    export NPROCS=${NPROCS}
    export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES}"
    mkdir -p /data/wsi_seg_local_data/seg_tiles
    mkdir -p /data/wsi_seg_local_data/logs
    mkdir -p /data/wsi_seg_local_data/svs
    mv ${imageInput} /data/wsi_seg_local_data/svs/
    cd /root/quip_cnn_segmentation/segmentation-of-nuclei
    time ./run_wsi_seg.sh
    tar -czf ${result} /data/wsi_seg_local_data/seg_tiles /data/wsi_seg_local_data/logs
    ls -alt ${result}
    mv ${result} /cromwell_root/${result}
    echo "$(date): Task: nuclear_segmentation_quip_cnn finished"
  }
  output {
    File out="${result}"
  }
  runtime {
    docker: "us.gcr.io/cloudypipelines/nuclear_seqmentation_quip_cnn_tensorflow-latest-gpu:" + SEG_DOCKER_TAG
    bootDiskSizeGb: SEG_BOOT_DISK_GB
    disks: "local-disk " + SEG_DISK_GB + " SSD"
    memory:  SEG_MEMORY_GB + " GB"
    cpu: SEG_CPU_COUNT
    gpuCount: 1
    zones: SEG_ZONES
    gpuType: SEG_GPU_TYPE
    nvidiaDriverVersion: SEG_NVIDIA_DRIVER_VERSION
    maxRetries: SEG_MAX_RETRIES
    preemptible: SEG_PREEMPTIBLE_COUNT
  }
}

workflow wf_nuclear_segmentation_quip_cnn {
  call wsi_seg
  output {
     wsi_seg.out
  }
}
