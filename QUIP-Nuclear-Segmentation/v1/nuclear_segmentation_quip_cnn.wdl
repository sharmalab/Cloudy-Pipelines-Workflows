task convert {
  File vsiInput
  String tifOutput = "multires.tif"
  command {
    echo "$(date): Task: convert started"
    cd /root
    chmod a+x ./converter_process.sh
    time ./converter_process.sh ${vsiInput} ${tifOutput}
    echo "$(date): Task: convert finished"
  }
  output {
    File out="${tifOutput}"
  }
  runtime {
    docker: "us.gcr.io/cloudypipelines/quip_converter_to_tiff:1.1"
    bootDiskSizeGb: 50
    disks: "local-disk 50 SSD"
    memory:  "12 GB"
    cpu: "2"
    maxRetries: 1
    zones: "us-east1-b us-east1-c us-east1-d us-central1-a us-central1-b us-central1-c us-central1-f us-east4-a us-east4-b us-east4-c us-west1-a us-west1-b us-west1-c us-west2-a us-west2-b us-west2-c"
  }
}

task wsi_seg {
  File imageInput
  File originalInput
  String result
  String CUDA_VISIBLE_DEVICES
  Int NPROCS
  command {
    echo "$(date): Task: wsi_seg started"
    cd /root/quip_cnn_segmentation/
    chmod a+x segmentation_process.sh 
    time ./segmentation_process.sh ${imageInput} ${result} ${CUDA_VISIBLE_DEVICES} ${NPROCS} ${originalInput}
    echo "$(date): Task: quip_nuclear_segmentation finished"
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

workflow wf_quip_nuclear_segmentation {
  File imageToBeProcessed
  call convert {input: vsiInput=imageToBeProcessed}
  call wsi_seg {input: imageInput=convert.out, originalInput=imageToBeProcessed}
  output {
     wsi_seg.out
  }
}
