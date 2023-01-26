locals {
  domain_name = "asgmt-eng-api.${data.terraform_remote_state.platform.outputs.ecs_domain_name}"
}