BUILD_DIR := $(CURDIR)/builddir

builddir:
	@echo mkfile: $(CURDIR)
	mkdir "$(BUILD_DIR)"

$(BUILD_DIR)/adobe_webhook.zip: builddir
	cd adobe_webhook && zip -r9 $(BUILD_DIR)/adobe_webhook.zip adobe_webhook.py
#	$(eval VENV := $(shell cd adobe_webhook && pipenv --venv))
#	@echo VENV $(VENV)
#	cd $(VENV)/lib/python3.7/site-packages && zip -r9 $(BUILD_DIR)/adobeWebhook.zip ./*

build: $(BUILD_DIR)/adobe_webhook.zip

clean:
	rm -rf builddir

nuke: clean
	rm -rf terraform/.terraform

terraform/.terraform:
	cd terraform && terraform init

taint: terraform/.terraform
	cd terraform && terraform taint aws_lambda_function.adobe_webhook

$(BUILD_DIR)/terraform.plan: build terraform/.terraform
	cd terraform && terraform plan -out $(BUILD_DIR)/terraform.plan

plan: $(BUILD_DIR)/terraform.plan

deploy: $(BUILD_DIR)/terraform.plan
	cd terraform && terraform apply -auto-approve $(BUILD_DIR)/terraform.plan

destroy: terraform/.terraform
	cd terraform && terraform destroy -auto-approve

.PHONY: clean plan deploy destroy nuke taint
