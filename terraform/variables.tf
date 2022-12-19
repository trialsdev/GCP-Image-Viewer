variable "billing_account_name" {
    default = "" #enter billing account name here
}

variable "user" {
    default = "" #enter user email address here
}

locals {

    project_name = "dicomimageviewer${random_id.id.hex}" #enter your project name
    project = "${local.project_name}"
    region = "us-east1"

    #storage bucket info
    image_archive_bucket = "div_image_archive_bucket" #enter your image archive storage bucket name

    #container image name
    container_image_name = "div_image" #enter your container image name
    image_name = "gcr.io/${local.project}/${local.container_image_name}"
    image_tag = "latest"
    image_uri = "${local.image_name}:${local.image_tag}"

    #service name
    cloudrun_service_name = "div-cloudrun"

}


resource "random_id" "id" {
    byte_length = 2
}