# Nuclear Segmentation
Nuclear image synthesis and segmentation
[GitHub](https://github.com/SBU-BMI/quip_cnn_segmentation)

1. Conditionally call VIPS2TIFF if the input is vsi 
2. Run Segmentation

* Run single image, see sample input file: ```input_one.json```
* Run multiple images, see sample input file: ```inputs_list.json```

Replace the url in field ```wf_nuclear_segmentation_quip_cnn.wsi_seg.imageInput``` with your TIF image url on Google bucket.

## v1
* Support the input tif image located in Google bucket.
* One ```nvidia-tesla-t4``` GPU is recommended

## v2
* Support the input tif image located in Google bucket.
* One ```nvidia-tesla-t4``` GPU is recommended
* Allow users to specify [Runtime attributes](https://cromwell.readthedocs.io/en/develop/RuntimeAttributes/), such as CPU count, Memory, Disk size,  GPU type, Nvidia driver version, etc. in the inputs.
