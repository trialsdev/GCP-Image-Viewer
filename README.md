# Setting up a GCP DICOM Store and an Image Viewer

This code repository contains code to setup a DICOM store in Google Cloud Platform (GCP) and then use the <a href = "https://ohif.org/"> OHIF viewer </a> to access the DICOM store to view/edit the files.

<img src = "https://user-images.githubusercontent.com/85404022/210579845-2d5db80a-1273-466c-a2bc-ab4fad58f99a.png" width = 950, height = 500></img>




## Importing data from the storage bucket to DICOM-store

Multiple files
```
gcloud healthcare dicom-stores import gcs my-dicom-store --dataset=example-dataset --location=us-east1 --gcs-uri=gs://image_archive_bucket/dicomfiles/**.dcm
```


