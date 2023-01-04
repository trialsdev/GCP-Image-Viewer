# Setting up a GCP DICOM Store and an Image Viewer

This epository contains code to setup a DICOM store in Google Cloud Platform (GCP) and then use the <a href = "https://ohif.org/"> OHIF viewer </a> to access the DICOM store to view/edit the files locally. The code creates the following infrastructure in GCP.

<img src = "https://user-images.githubusercontent.com/85404022/210579845-2d5db80a-1273-466c-a2bc-ab4fad58f99a.png" width = 950, height = 500></img>

*Please note that in the current iteration, the OHIF viewer is not deployed to Google Cloud Platform. We will be using the OHIF docker image to locally open the app and connect to the DICOM-store in GCP*

## Billable Resources

1. <a href = "https://cloud.google.com/healthcare-api">Google Cloud Healthcare API</a>
2. <a href = "https://cloud.google.com/storage">Google Cloud Storage</a>

## Setup & Requirements

In order to run the code you need a billing enabled Google Cloud Platform Account. You will also need the GCP command line interface (CLI), terraform and docker installed and properly configured in your local machine. The following links are resources on how to setup the required software. 

1. <a href = "#">Google Cloud Platform</a>
2. <a href = "https://cloud.google.com/sdk/docs/install">Google Cloud CLI </a>
3. <a href = "https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli"> Terraform </a>
4. <a href = "https://docs.docker.com/get-docker/"> Docker </a>

## Add credentials ##

Before running the code, first you need to edit the var.tf file with your credentials. You can locate this file in the terraform folder and edit the billing account name and the user email address.

```
variable "billing_account_name" {
    default = "your billing account name"
}

variable "user" {
    default = "your GCP email address"
}
```

## Create DICOM-store ##

Follow the instructions below to create the DICOM store.

Clone the repository
```
https://github.com/trialsdev/GCP-Image-Viewer.git
```
Go to the terraform folder
```
cd terraform
```
View the infrastructure plan
```
terraform plan
```
Create the infrastructure in GCP
```
terraform apply
```

## Importing data from the storage bucket to DICOM-store

In order to import the data from the storage bucket to the DICOM-store we can use the following code. You can find other ways to do this <a href = "https://cloud.google.com/healthcare-api/docs/how-tos/dicom-import-export#gcloud>here</a>

```
gcloud healthcare dicom-stores import gcs my-dicom-store --dataset=example-dataset --location=us-east1 --gcs-uri=gs://image_archive_bucket/dicomfiles/**.dcm
```

## Deleting the infrastructure

```
terraform destroy
```

