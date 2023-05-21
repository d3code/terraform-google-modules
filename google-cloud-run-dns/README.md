

```sh
terraform -chdir="terraform" plan -var-file="local.tfvars" -target="module.domain_mapping_root.google_cloud_run_domain_mapping.mapping"
```