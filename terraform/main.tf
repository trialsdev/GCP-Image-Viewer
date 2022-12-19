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

resource "google_storage_bucket" "image_archive_bucket" {

    name = local.image_archive_bucket
    location = "US"
    force_destroy = true
    
    depends_on = [
        google_project_iam_member.project_owner
    ]

}

resource "google_project_service" "cloud_registry_service" {

  service = "containerregistry.googleapis.com"
  disable_dependent_services = true

  depends_on = [
    google_project.project,
  ]

}

resource "google_project_service" "cloud_build_service" {

  service = "cloudbuild.googleapis.com"
  disable_dependent_services = true

  depends_on = [
    google_project.project,
    google_project_iam_member.project_owner
  ]

}

resource "google_project_service" "cloud_run_service" {

  service = "run.googleapis.com"
  disable_dependent_services = true

  depends_on = [
    google_project.project,
  ]

}

#create cloud run service using the image
resource "google_cloud_run_service" "default" {
  
  project = local.project_name
  name     = local.cloudrun_service_name #name the cloud run service
  location = local.region

  template {
    spec {
      containers {
        image = local.image_uri # Replace with newly created image gcr.io/<project_id>/pubsub

      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  depends_on = [
    google_project.project,
    google_project_service.cloud_run_service,
    null_resource.app_container, 
  ]
}

#create an the image from app directory.
resource "null_resource" "app_container" {

    provisioner "local-exec" {
        command = "cd ../app && gcloud config set project ${local.project} && gcloud builds submit --tag ${local.image_uri}"
    }

    depends_on = [
        google_project.project,
        google_project_service.cloud_build_service,
        google_project_iam_member.project_owner
    ]
}


#allowing authentication

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
