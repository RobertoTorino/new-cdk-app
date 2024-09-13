#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import {CdkAppExampleStack} from '../lib/cdk-app-example-stack';
import {Stack, Tags} from "aws-cdk-lib";

export const env = {
    account: process.env.CDK_SYNTH_ACCOUNT || process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_SYNTH_REGION || process.env.CDK_DEFAULT_REGION,
};

enum Environment {
    dev = 'dev'
}

const application = 'cnca-cdk-example';

const addTags = (stack: Stack, environment: Environment) => {
    Tags.of(stack).add('Application', application, {
        applyToLaunchedInstances: true,
        includeResourceTypes: [],
    });
    Tags.of(stack).add('Stage', environment, {
        applyToLaunchedInstances: true,
        includeResourceTypes: [],
    });
    Tags.of(stack).add('Stackname', stack.stackName, {
        applyToLaunchedInstances: true,
        includeResourceTypes: [],
    });
};

const app = new cdk.App();
const cdkAppExampleStack = new CdkAppExampleStack(app, 'CdkAppExampleStack', {
    stackName: 'CdkAppExampleStack',
    description: 'Example stack for CF&D onboarding.',
    env,
});
addTags(cdkAppExampleStack, Environment.dev);

app.synth();
