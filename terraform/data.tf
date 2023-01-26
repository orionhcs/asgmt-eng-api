
data "aws_route53_zone" "ecs_domain" {
  name            = data.terraform_remote_state.platform.outputs.ecs_domain_name
  private_zone    = false
}