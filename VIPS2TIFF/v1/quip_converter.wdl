task convert {
  File vsiInput
  String tifOutput
  command {
    echo "$(date): Task: convert started"
    set -x
    mkdir -p /quip_convert/vsi
    mkdir -p /quip_convert/tif
    mv ${vsiInput} /quip_convert/vsi/$(basename ${vsiInput})
    cd /quip_convert/vsi
    [[ /quip_convert/vsi/$(basename ${vsiInput}) =~ \.tar\.gz$ ]] && ( echo "input is tar.gz file"; tar xzvf ./*.tar.gz )
    [[ /quip_convert/vsi/$(basename ${vsiInput}) =~ \.zip$ ]] && ( echo "input is zip file"; unzip ./*.zip )
    cd /root
    time run_convert_wsi.sh $( ls /quip_convert/vsi/*.vsi ) /quip_convert/tif/big.tif /quip_convert/tif/multi.tif
    mv /quip_convert/tif/multi.tif /cromwell_root/${tifOutput}
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
