variable "billing_account_name" {
    default = "" #enter billing account name here
}

variable "user" {
    default = "" #enter user email address here
}

locals {

    project_name = "dicom-store-${random_id.id.hex}" #enter your project name
    project = "${local.project_name}"
    region = "us-east1"

    #storage bucket info
    image_archive_bucket = "image_archive_bucket" #enter your image archive storage bucket name

    #dicom store name
    dicom_store_name = "my-dicom-store"

}


resource "random_id" "id" {
    byte_length = 2
}