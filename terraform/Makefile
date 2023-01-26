dev-init:
	terraform init -backend-config="app-dev.config" -upgrade

dev-plan:
	terraform plan -var-file="dev.tfvars"

dev-apply:
	terraform apply -var-file="dev.tfvars"

dev-apply-refresh:
	terraform apply -var-file="dev.tfvars" -refresh-only

dev-destroy:
	terraform destroy -var-file="dev.tfvars"

demo-init:
	terraform init -backend-config="app-demo.config" -upgrade

demo-plan:
	terraform plan -var-file="demo.tfvars"

demo-apply:
	terraform apply -var-file="demo.tfvars"

demo-apply-refresh:
	terraform apply -var-file="demo.tfvars" -refresh-only

demo-destroy:
	terraform destroy -var-file="demo.tfvars"