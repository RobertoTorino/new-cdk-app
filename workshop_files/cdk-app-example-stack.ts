import * as cdk from 'aws-cdk-lib';
import {aws_iam, aws_s3, RemovalPolicy} from 'aws-cdk-lib';
import {Construct} from 'constructs';


export class CdkAppExampleStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);

        const myExampleBucket = new aws_s3.Bucket(this, 'my-cnca-demo-bucket', {
            bucketName: 'my-cnca-demo-bucket',
            // disable access control lists (ACLs) and take ownership of every object in your bucket.
            objectOwnership: aws_s3.ObjectOwnership.BUCKET_OWNER_ENFORCED,
            // permissions on new objects are private by default and don’t allow public access.
            blockPublicAccess: aws_s3.BlockPublicAccess.BLOCK_ALL,
            encryption: aws_s3.BucketEncryption.S3_MANAGED,
            enforceSSL: true,
            versioned: true,
            removalPolicy: RemovalPolicy.DESTROY,
            // with this setting cdk will deploy a lambda and a custom resource.
            autoDeleteObjects: true,
        });
        // give the AWS account owner read access
        myExampleBucket.grantRead(new aws_iam.AccountRootPrincipal());
    }
}
