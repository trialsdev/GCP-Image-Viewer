# Setting up a GCP DICOM Store and an Image Viewer

This epository contains code to setup a DICOM store in Google Cloud Platform (GCP) and then use the <a href = "https://ohif.org/"> OHIF viewer </a> to access the DICOM store to view/edit the files locally. The code creates the following infrastructure in GCP.

<img src = "https://user-images.githubusercontent.com/85404022/210579845-2d5db80a-1273-466c-a2bc-ab4fad58f99a.png" width = 950, height = 500></img>

*Please note that in the current iteration, the OHIF viewer is not deployed to Google Cloud Platform. We will be using the OHIF docker image to locally open the app and connect to the DICOM-store in GCP*

## Billable Resources

1. <a href = "https://cloud.google.com/healthcare-api">Google Cloud Healthcare API</a>
2. <a href = "https://cloud.google.com/storage">Google Cloud Storage</a>

## Setup & Requirements

In order to run the code you need a billing enabled Google Cloud Platform Account. You will also need the GCP command line interface (CLI), terraform and docker installed and properly configured in your local machine. The following links are resources on how to setup the required software. 



## Importing data from the storage bucket to DICOM-store

Multiple files
```
gcloud healthcare dicom-stores import gcs my-dicom-store --dataset=example-dataset --location=us-east1 --gcs-uri=gs://image_archive_bucket/dicomfiles/**.dcm
```


