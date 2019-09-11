task convert {
  File vsiInput
  String tifOutput
  String CONVERTER_DOCKER_TAG
  Int CONVERTER_MEMORY_GB
  String CONVERTER_ZONES
  Int CONVERTER_CPU_COUNT
  Int CONVERTER_MAX_RETRIES
  Int CONVERTER_DISK_GB
  Int CONVERTER_BOOT_DISK_GB
  Int CONVERTER_PREEMPTIBLE_COUNT
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
    docker: "us.gcr.io/cloudypipelines/quip_converter_to_tiff:" + CONVERTER_DOCKER_TAG
    bootDiskSizeGb: CONVERTER_BOOT_DISK_GB
    disks: "local-disk " + CONVERTER_DISK_GB + " SSD"
    memory:  CONVERTER_MEMORY_GB + " GB"
    cpu: CONVERTER_CPU_COUNT
    maxRetries: CONVERTER_MAX_RETRIES
    zones: CONVERTER_ZONES + ""
    preemptible: CONVERTER_PREEMPTIBLE_COUNT
  }
}

workflow wf_quip_converter_vsi_to_tiff {
  call convert 
  output {
     convert.out
  }
}
