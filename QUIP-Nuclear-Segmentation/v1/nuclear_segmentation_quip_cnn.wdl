task wsi_seg {
  File imageInput
  String result
  String CUDA_VISIBLE_DEVICES
  Int NPROCS
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
    docker: "us.gcr.io/cloudypipelines/nuclear_seqmentation_quip_cnn_tensorflow-latest-gpu:1.0"
    bootDiskSizeGb: 70
    disks: "local-disk 70 SSD"
    memory:  "64 GB"
    cpu: "12"
    maxRetries: 1
    gpuCount: 1
    zones: "us-central1-a us-central1-b us-east1-d us-east1-c us-west1-a us-west1-b southamerica-east1-c europe-west4-b europe-west4-c"
    gpuType: "nvidia-tesla-t4"
    nvidiaDriverVersion: "418.40.04"
  }
}

workflow wf_nuclear_segmentation_quip_cnn {
  call wsi_seg
  output {
     wsi_seg.out
  }
}
