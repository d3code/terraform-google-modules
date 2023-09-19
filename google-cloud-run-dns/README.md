# Cloud Run Domain Mapping

This one is a bit tricky and have yet to find a way around it without compromises that are not potentially destructive.

Running this plan from scratch without following the steps below will result in the following error.

```
The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, and so Terraform cannot determine the full set of keys that will identify the instances of this resource.

When working with unknown values in for_each, it's better to define the map keys statically in your configuration and place apply-time results only in the map values.

Alternatively, you could use the -target planning option to first apply only the resources that the for_each value depends on, and then apply a second time to fully converge.
```


Though you could define the keys to get around this error, it would mean that if the keys are not present in the response, it will also fail.

To get the keys from the response, the map has been created dynamically and therefore the resources for `google_cloud_run_domain_mapping` need to be run in advance to the DNS `google_dns_record_set` can be created.

Do do this, run the following plan. Subsequent plan runs will not fail as the resources will exist and the keys will be known.


```sh
terraform plan -target="module.{module}.google_cloud_run_domain_mapping.mapping"
```


If you are running the plan from another directory and with a `.tfvars` use the following command.

```sh
terraform -chdir="terraform" plan -var-file="local.tfvars" -target="module.{module}.google_cloud_run_domain_mapping.mapping"
```

