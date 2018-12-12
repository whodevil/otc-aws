BUILD_DIR := $(CURDIR)/builddir
TERRAFORM_CACHE := $(CURDIR)/terraform/.terraform

$(BUILD_DIR)/adobe_webhook.zip: 
	mkdir "$(BUILD_DIR)" || true
	cd adobe_webhook && \
	    pipenv install && \
	    pipenv lock -r > requirements.txt && \
	    pipenv run pip install -r requirements.txt -t vendor/ && \
	    zip -r9 $(BUILD_DIR)/adobe_webhook.zip *

$(BUILD_DIR)/image_fetcher.zip:
	mkdir "$(BUILD_DIR)" || true
	cd image_fetcher && pipenv install && \
	    pipenv lock -r > requirements.txt && \
	    pipenv run install -r requirements.txt -t vendor/ && \
	    zip -r9 $(BUILD_DIR)/image_fetcher.zip *

$(BUILD_DIR)/image_sync.zip:
	mkdir "$(BUILD_DIR)" || true
	cd image_sync && pipenv install && \
	    pipenv lock -r > requirements.txt && \
	    pipenv run pip install -r requirements.txt -t vendor/ && \
	    zip -r9 $(BUILD_DIR)/image_sync.zip *

build: $(BUILD_DIR)/adobe_webhook.zip $(BUILD_DIR)/image_fetcher.zip $(BUILD_DIR)/image_sync.zip

clean:
	rm -rf builddir
	rm adobe_webhook/requirements.txt
	rm -rf adobe_webhook/vendor
	rm image_sync/requirements.txt
	rm -rf image_sync/vendor
	rm image_fetcher/requirements.txt
	rm -rf image_fetcher/vendor

nuke: clean
	rm -rf terraform/.terraform

$(TERRAFORM_CACHE):
	cd terraform && terraform init

taint: $(TERRAFORM_CACHE)
	cd terraform && terraform taint aws_lambda_event_source_mapping.image_sync_job_queue
	cd terraform && terraform taint -module=adobe_webhook_api_method aws_lambda_permission.allow_api_gateway
	cd terraform && terraform taint -module=adobe_webhook_lambda aws_lambda_function.lambda
	cd terraform && terraform taint -module=image_sync_lambda aws_lambda_function.lambda
	cd terraform && terraform taint -module=image_fetcher_lambda aws_lambda_function.lambda

$(BUILD_DIR)/terraform.plan: $(TERRAFORM_CACHE)
	mkdir builddir || true
	cd terraform && terraform plan -out $(BUILD_DIR)/terraform.plan

plan: $(BUILD_DIR)/terraform.plan

deploy: $(BUILD_DIR)/terraform.plan
	cd terraform && terraform apply -auto-approve $(BUILD_DIR)/terraform.plan

destroy: $(TERRAFORM_CACHE)
	cd terraform && terraform destroy -auto-approve

.PHONY: clean plan deploy destroy nuke taint
