task histoqc {
  File imageListFile
  String outputFolder
  command {
    echo "$(date): Task: histoqc started"
    cd /opt/HistoQC
    cp ${imageListFile} ./images_to_be_processed.txt
    time ./process_histoqc.sh images_to_be_processed.txt ${outputFolder}
    mv /opt/HistoQC/summary.txt /cromwell_root/summary.txt
    echo "$(date): Task: histoqc finished"
  }
  output {
    File out="summary.txt"
  }
  runtime {
    docker: "gcr.io/cloudypipelines-com/histoqc:1.0"
    bootDiskSizeGb: 50
    disks: "local-disk 50 SSD"
    memory:  "12 GB"
    cpu: "2"
    preemptible: 3
    zones: "us-east1-b us-east1-c us-east1-d us-central1-a us-central1-b us-central1-c us-central1-f us-east4-a us-east4-b us-east4-c us-west1-a us-west1-b us-west1-c us-west2-a us-west2-b us-west2-c"
  }
}

workflow wf_histoqc {
  call histoqc
  output {
     histoqc.out
  }
}