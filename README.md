# Hot Reloading TypeScript Lambda Functions with Cloud Development Kit (CDK)

| Key          | Value                             |
| ------------ | --------------------------------- |
| Environment  | LocalStack                        |
| Services     | Lambda                            |
| Integrations | Cloud Development Kit             |
| Categories   | Serverless; Developer Experience  |

## Introduction

A demonstration of how to hot reload TypeScript Lambda functions with the Cloud Development Kit (CDK) using LocalStack. For more details on LocalStack's Hot Reloading feature, see the [documentation](https://docs.localstack.cloud/user-guide/lambda-tools/hot-reloading/).

## Prerequisites

* A valid [LocalStack for AWS license](https://localstack.cloud/pricing). Your license provides a [`LOCALSTACK_AUTH_TOKEN`](https://docs.localstack.cloud/aws/getting-started/auth-token/) to activate LocalStack.
* [`lstk` CLI](https://docs.localstack.cloud/aws/developer-tools/running-localstack/lstk/), installed via `npm install -g @localstack/lstk` or `brew install localstack/tap/lstk`.
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html), required by `lstk aws`.
* [Node.js](https://nodejs.org/en/download/)
* [Docker](https://docs.docker.com/get-docker/)
* [AWS CDK](https://docs.aws.amazon.com/cdk/latest/guide/work-with-cdk-typescript.html), deployed via the `lstk cdk` proxy.

## Check prerequisites

```bash
make check
```

## Installation

```bash
make install
```

## Start LocalStack

```bash
export LOCALSTACK_AUTH_TOKEN=<your-auth-token>
make start
```

## Deploy the Application

```bash
make deploy
```

The deployment process:

* Compiles the TypeScript Lambda function.
* Bootstraps the CDK application.
* Deploys the CDK stack to LocalStack.

## Run a test invocation

```bash
make run
```

Go to `lib/fn/index.ts` and make a change to the Lambda function. Save the file and re-run the test invocation. The changes should be reflected in the output.

## Cleanup

```bash
make stop
```

## License

This code is available under the Apache 2.0 license.
