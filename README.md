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
Initialize terraform
```
terraform init
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

In order to import the data from the storage bucket to the DICOM-store we can use the following code. You can find other ways to do this <a href = "https://cloud.google.com/healthcare-api/docs/how-tos/dicom-import-export#gcloud">here</a>.

```
gcloud healthcare dicom-stores import gcs my-dicom-store --dataset=example-dataset --location=us-east1 --gcs-uri=gs://image_archive_bucket/dicomfiles/**.dcm
```

## Deleting the infrastructure

```
terraform destroy
```

## Setting up the OHIF Viewer

We will be using the OHIF viewer to view the images from the DICOM store. The OHIF viewer will be setup locally by using the docker image. A detailed explanation can be found <a href = "https://docs.ohif.org/history/v1/connecting-to-image-archives/google-cloud-healthcare.html">here</a> in their website. (Follow instructions 6 through 8 in the Setup a Google Cloud Healthcare Project)

#### OAuth Consent Screen ####

- Go to APIs & Services > Credentials to create an OAuth Consent screen and fill in your application details.
    - Under Scopes for Google APIs, click "manually paste scopes".
    - Add the following scopes
        - https://www.googleapis.com/auth/cloudplatformprojects.readonly
        - https://www.googleapis.com/auth/cloud-healthcare

- Go to APIs & Services > Credentials to create a new set of credentials
    - Choose the "Web Application" type
    - Set up an OAuth 2.0 Client ID
    - Add your domain ```http://localhost:3000``` to Authorized JavaScript origins.
    - Add ```http://localhost:3000``` and ```http://localhost:3000/_oauth/google``` to Authorized Redirect URIs.
    - Save your Client ID for later

#### Opening the OHIF Viewer Using Docker ####

Run the following docker command to open your DICOM-store in OHIF viewer. Replace YOUR_CLIENT_ID with the client ID created in the step above.

```
docker run --env CLIENT_ID={YOUR_CLIENT_ID}.apps.googleusercontent.com --publish 3000:80 ohif/viewer-google-cloud
```
