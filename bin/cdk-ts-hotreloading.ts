#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import {CdkTsHotreloadStack} from "../lib/cdk-ts-hotreload-stack";

const app = new cdk.App();
new CdkTsHotreloadStack(app, 'CdkTsHotreloadStack', {});