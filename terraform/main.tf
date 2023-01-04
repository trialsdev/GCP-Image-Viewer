provider "google" {

    project = local.project
    region = local.region

}

data "google_billing_account" "account" {

    #this needs to be the literal name of the billing account. Change the billing account name in the variables.tf file
    display_name = var.billing_account_name

}


resource "google_project" "project" {

    name = local.project_name
    project_id = local.project
    billing_account = data.google_billing_account.account.id

}

resource "google_project_iam_member" "project_owner" {

    role = "roles/owner"
    member = "user:${var.user}"
    project = local.project_name

    depends_on = [
        google_project.project
    ]

}

resource "google_project_service" "resourcemanager" {

    project = local.project
    service = "cloudresourcemanager.googleapis.com"

    disable_dependent_services = true
}

resource "google_project_service" "healthcare" {
    
    project = local.project
    service = "healthcare.googleapis.com"

    disable_dependent_services = true
}

resource "google_storage_bucket" "image_archive_bucket" {

    name = local.image_archive_bucket
    location = "US"
    force_destroy = true
    
    depends_on = [
        google_project_iam_member.project_owner
    ]
}

#this is a null resource created to upload local dicom files to the storage bucket. 
resource "null_resource" "upload_files" {
    
    provisioner "local-exec" {
        command = "gcloud config set project ${local.project} && gcloud storage cp -r ../data/dicomfiles/ gs://${local.image_archive_bucket}/dicomfiles"
    }
    
    depends_on = [
        google_storage_bucket.image_archive_bucket,
    ]
}


resource "google_healthcare_dicom_store" "default" {
  
    name    = local.dicom_store_name
    dataset = google_healthcare_dataset.dataset.id

    depends_on = [
        google_project_iam_member.project_owner,
        google_project_service.healthcare
    ]

}

resource "google_healthcare_dataset" "dataset" {

    name     = "example-dataset"
    location = local.region

    depends_on = [
        google_project_iam_member.project_owner,
        google_project_service.healthcare
    ]

}

data "google_storage_project_service_account" "gcs_account"{
    depends_on = [
        google_project.project,
    ]
}


resource "google_storage_bucket_iam_binding" "binding" {
    bucket = google_storage_bucket.image_archive_bucket.name
    role = "roles/storage.admin"

    members = [
        "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
        "serviceAccount:service-${google_project.project.number}@gcp-sa-healthcare.iam.gserviceaccount.com", 
    ]
    
    depends_on = [
        google_project.project,
        google_project_service.healthcare
    ]
}


