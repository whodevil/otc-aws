BUILD_DIR := $(shell pwd)/builddir

builddir:
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/adobe_webhook.zip: builddir
	#$(eval VENV := $(shell cd adobe_webhook && pipenv --venv))
	#@echo VENV $(VENV)
	#cd $(VENV)/lib/python3.7/site-packages && zip -r9 $(BUILD_DIR)/adobeWebhook.zip ./*
	cd adobe_webhook && zip -r9 $(BUILD_DIR)/adobe_webhook.zip *.py

build: $(BUILD_DIR)/adobe_webhook.zip

clean:
	rm -rf builddir

nuke: clean
	rm -rf terraform/.terraform

terraform/.terraform:
	cd terraform && terraform init

taint: terraform/.terraform
	cd terraform && terraform taint aws_lambda_function.adobe_webhook

$(BUILD_DIR)/terraform.plan: build terraform/.terraform taint
	cd terraform && terraform plan -out $(BUILD_DIR)/terraform.plan

deploy: $(BUILD_DIR)/terraform.plan
	cd terraform && terraform apply -auto-approve $(BUILD_DIR)/terraform.plan

destroy: terraform/.terraform
	cd terraform && terraform destroy -auto-approve

.PHONY: clean deploy destroy nuke taint
