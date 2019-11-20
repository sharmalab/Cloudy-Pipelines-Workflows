# Quip Nuclear Segmentation pyRadiomics Workflow Pipeline
The workflow pipeline consists of followings: 
1. **VIPS2TIFF**: Convert vendor format to tiled, multires tiff format, it is conditionally executed when the input image is vendor format. For details, see [GitHub](https://github.com/SBU-BMI/quip_converter.git)
2. **Segmentation**: Nuclear image synthesis and segmentation. For details, see [GitHub](https://github.com/SBU-BMI/quip_cnn_segmentation)
3. **Pyradiomics Features**: Generates patch level pyradiomics feature dataset and image level aggregational result. It also create histogram plot and percentile plot for each pyradiomics feature. For details, see [GitHub](https://github.com/SBU-BMI/pyradiomics_features).

# v1
* The input images must be in Google bucket
* If the image is not tiled, multires tiff format, it must be in .vsi format or compressed zip or tar.gz format.
* One ```nvidia-tesla-t4``` GPU is recommended

## Sample Input Json File
* Run single tif image, see sample input file: ```input_one_tif.json```
* Run single compressed vsi image, see sample input file: ```input_one_vsi.json```
* Run multiple images, see sample input file: ```inputs_list.json```

### Notes
* Replace the url in field ```wf_quip_nuclear_segment_pyradiomics.imageToBeProcessed``` with your TIF or VSI image url on Google bucket.
* Replace the output file name in ```wf_quip_nuclear_segment_pyradiomics.pyradiomics_compute.result``` with meaningful  file name ending with ```.tar.gz```

## WDL File 
quip_nuclear_segment_pyradiomics.wdl

## Run the Pipeline
* Logon: https://cloudypipeline:9000/
* Select "Workflow Pipeline"
* Select "POST /ui/workflows/vi", then click "Try it out"
* Input the following fields:
  - email: your registered google email on CloudyPipelines
  - label: type the meaningful description for the pipelines
  - project: Google Project on which your jobs are going to run 
  - workflowInputs: choose input json files from your local that contains the images to be processed, see "Sample Input Json File" section to construct your json file.
  - workflowSource: choose WDL file: quip_nuclear_segment_pyradiomics.wdl
* Click "Execute"
* An email notification that includes label, requestId and individual jobId will be sent if the submission succeeds.

