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

workflow wf_quip_converter_vsi_to_tiff {
  call convert
  output {
     convert.out
  }
}