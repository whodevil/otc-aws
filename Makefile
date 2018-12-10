BUILD_DIR := $(CURDIR)/builddir

builddir:
	@echo mkfile: $(CURDIR)
	mkdir "$(BUILD_DIR)"

$(BUILD_DIR)/adobe_webhook.zip: builddir
	$(eval VENV := $(shell cd adobe_webhook && pipenv --venv))
	@echo VENV $(VENV)
	cd $(VENV)/lib/python3.7/site-packages && zip -r9 $(BUILD_DIR)/adobe_webhook.zip ./*
	cd adobe_webhook && zip -r9 $(BUILD_DIR)/adobe_webhook.zip adobe_webhook.py

$(BUILD_DIR)/image_fetcher.zip: builddir
	$(eval VENV := $(shell cd image_fetcher && pipenv --venv))
	@echo VENV $(VENV)
	cd $(VENV)/lib/python3.7/site-packages && zip -r9 $(BUILD_DIR)/image_fetcher.zip ./*
	cd image_fetcher && zip -r9 $(BUILD_DIR)/image_fetcher.zip image_fetcher.py

$(BUILD_DIR)/image_sync.zip: builddir
	$(eval VENV := $(shell cd image_sync && pipenv --venv))
	@echo VENV $(VENV)
	cd $(VENV)/lib/python3.7/site-packages && zip -r9 $(BUILD_DIR)/image_sync.zip ./*
	cd image_sync && zip -r9 $(BUILD_DIR)/image_sync.zip image_sync.py

build: $(BUILD_DIR)/adobe_webhook.zip $(BUILD_DIR)/image_fetcher.zip $(BUILD_DIR)/image_sync.zip

clean:
	rm -rf builddir

nuke: clean
	rm -rf terraform/.terraform

terraform/.terraform:
	cd terraform && terraform init

taint: terraform/.terraform
	cd terraform && terraform taint -module=adobe_webhook_lambda aws_lambda_function.lambda
	cd terraform && terraform taint -module=image_sync_lambda aws_lambda_function.lambda
	cd terraform && terraform taint -module=image_fetcher_lambda aws_lambda_function.lambda

$(BUILD_DIR)/terraform.plan: build terraform/.terraform
	cd terraform && terraform plan -out $(BUILD_DIR)/terraform.plan

plan: $(BUILD_DIR)/terraform.plan

deploy: $(BUILD_DIR)/terraform.plan
	cd terraform && terraform apply -auto-approve $(BUILD_DIR)/terraform.plan

destroy: terraform/.terraform
	cd terraform && terraform destroy -auto-approve

.PHONY: clean plan deploy destroy nuke taint
