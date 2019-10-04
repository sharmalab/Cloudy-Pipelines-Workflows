# Nuclear Segmentation
Nuclear image synthesis and segmentation
[GitHub](https://github.com/SBU-BMI/quip_cnn_segmentation)
* Run single tif image, see sample input file: ```input_one_tif.json```
* Run single compressed vsi image, see sample input file: ```input_one_vsi.json```
* Run multiple images, see sample input file: ```inputs_list.json```

Replace the url in field ```wf_quip_nuclear_segment_pyradiomics.imageToBeProcessed``` with your TIF or VSI image url on Google bucket.

## v1
* The input images must be in Google bucket
* If the image is vsi format, it must be in .vsi or compressed format in .zip or .tar.gz.
* One ```nvidia-tesla-t4``` GPU is recommended
