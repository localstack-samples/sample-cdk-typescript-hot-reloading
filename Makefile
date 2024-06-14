export AWS_ACCESS_KEY_ID ?= test
export AWS_SECRET_ACCESS_KEY ?= test
export AWS_DEFAULT_REGION ?= us-east-1

usage:       ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

check:    ## Check if all required prerequisites are installed
	@command -v docker > /dev/null 2>&1 || { echo "Docker is not installed. Please install Docker and try again."; exit 1; }
	@command -v node > /dev/null 2>&1 || { echo "Node.js is not installed. Please install Node.js and try again."; exit 1; }
	@command -v aws > /dev/null 2>&1 || { echo "AWS CLI is not installed. Please install AWS CLI and try again."; exit 1; }
	@command -v python > /dev/null 2>&1 || { echo "Python is not installed. Please install Python and try again."; exit 1; }
	@command -v localstack > /dev/null 2>&1 || { echo "LocalStack is not installed. Please install LocalStack and try again."; exit 1; }
	@echo "All required prerequisites are available."

install:     ## Install dependencies
	@which awslocal || pip install awscli-local
	@which cdk || npm install -g aws-cdk
	@which cdklocal || npm install -g aws-cdk-local
	@if [ ! -d "node_modules" ]; then \
		echo "node_modules not found. Running npm install..."; \
		npm install; \
	else \
		echo "node_modules already installed."; \
	fi
	@echo "All required dependencies are available."

deploy:      ## Deploy the CDK stack to the local environment
	@echo "Deploying the CDK stack to LocalStack..."
	@cdklocal bootstrap
	@cdklocal deploy --require-approval never

run:         ## Run a test invocation
	@awslocal lambda invoke --function-name test-hotreload outfile && cat outfile

watch:
	npm run watch

start:       ## Start LocalStack
	LAMBDA_RUNTIME_ENVIRONMENT_TIMEOUT=300 localstack start -d

stop:        ## Stop LocalStack
	@echo
	localstack stop

ready:       ## Wait until LocalStack is ready
	@echo Waiting on the LocalStack container...
	@localstack wait -t 30 && echo Localstack is ready to use! || (echo Gave up waiting on LocalStack, exiting. && exit 1)

logs:        ## Retrieve LocalStack logs
	@localstack logs > logs.txt

test-ci:     ## Run CI tests
	make check start install ready deploy run; return_code=`echo $$?`;\
	make logs; make stop; exit $$return_code;

.PHONY: usage check install run start stop ready logs test-ci
