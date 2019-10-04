# Quip Nuclear Segmentation pyRadiomics
The pipeline consists of following workflows:
1. **VIPS2TIFF**: Convert vendor format to tiled, multires tiff format, it is conditionally executed when the input image is vendor. For details, see [GitHub](https://github.com/SBU-BMI/quip_converter.git)
2. **Segmentation**: Nuclear image synthesis and segmentation. For details, see [GitHub](https://github.com/SBU-BMI/quip_cnn_segmentation)
3. **Pyradiomics Features**: Generates patch level pyradiomics feature dataset and image level aggregational result. It also create histogram plot and percentile plot for each pyradiomics feature. For details, see [GitHub](https://github.com/SBU-BMI/pyradiomics_features).


# Sample Input Json File
* Run single tif image, see sample input file: ```input_one_tif.json```
* Run single compressed vsi image, see sample input file: ```input_one_vsi.json```
* Run multiple images, see sample input file: ```inputs_list.json```

Replace the url in field ```wf_quip_nuclear_segment_pyradiomics.imageToBeProcessed``` with your TIF or VSI image url on Google bucket.

# v1
* The input images must be in Google bucket
* If the image is nottiled, multires tiff format, it must be in .vsi format or compressed zip or tar.gz format.
* One ```nvidia-tesla-t4``` GPU is recommended
