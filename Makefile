BUILD_DIR := $(shell pwd)/builddir

builddir:
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/adobeWebhook.zip: builddir
	$(eval VENV := $(shell cd adobe_webhook && pipenv --venv))
	@echo VENV $(VENV)
	cd $(VENV)/lib/python3.7/site-packages && zip -r9 $(BUILD_DIR)/adobeWebhook.zip ./*
	cd adobe_webhook && zip -r9 $(BUILD_DIR)/adobeWebhook.zip *.py

build: $(BUILD_DIR)/adobeWebhook.zip

clean:
	rm -rf builddir

$(BUILD_DIR)/terraform.plan: build
	terraform plan -out $(BUILD_DIR)/terraform.plan ./terraform

deploy: $(BUILD_DIR)/terraform.plan
	terraform apply -auto-approve $(BUILD_DIR)/terraform.plan

destroy: 
	terraform destroy -auto-approve ./terraform

.PHONY: clean deploy destroy
