# terraform-gcp-cloud-run-api
This Terraform module creates a Cloud Run API in Google Cloud Platform (GCP).

## Resources Created

- Google Cloud Run Service
- Google Cloud Scheduler Job (optional)
- Google Cloud Run Domain Mapping (optional)
- Google IAM Policy (optional)
- Google Cloud Run Service IAM Policy

## How to use
Here is an example of how to use this module in your Terraform code:

```hcl
module "cloud-run-api" {
  source  = "graphnode-technologies/cloud-run-api/gcp"
  version = "1.1.1"

  name         = "my-cloud-run-api"
  image_url    = "gcr.io/my-project/my-image:v1"
}
```

## Input Variables

| Name | Type | Description | Default Value |
|------|------|-------------|--------------|
| name | string | The name of the Cloud Run service. | `"main"` |
| namespace | string | The namespace where the Cloud Run service will be created. | `"default"` |
| keep_alive | bool | Whether to create a Cloud Scheduler job to keep the instance warm. | `false` |
| cron_schedule | string | The cron schedule for the Cloud Scheduler job. | `"*/1 * * * 1-5"` |
| location | string | The location of the Cloud Run service. | `"us-central1"` |
| extra_annotations | map | Extra annotations to add to the Cloud Run service. | `{}` |
| domain_name | string | The domain name for the Cloud Run service. | `""` |
| environment_vars | map | Environment variables for the container. | `{}` |
| min_replicas | int | The minimum number of replicas for the Cloud Run service. | `1` |
| max_replicas | int | The maximum number of replicas for the Cloud Run service. | `1` |
| port | Port for the Cloud Run Service. | number | `3000` |
| image_url | URL of the image for the Cloud Run Service. | string | n/a |
| service_account_name | Name of the Service Account for the Cloud Run Service. | string | `""` |
| requests | Resource requests for the Cloud Run Service. | object | `{ memory = "50Mi", cpu = "10m" }` |
| limits | Resource limits for the Cloud Run Service. | object | `{ memory = "500Mi", cpu = "250m" }` |


## Outputs

| Name | Description |
|------|-------------|
| `resource_records` | The resource records for the domain name. If the domain name is an empty string, the value will be an empty list. |
