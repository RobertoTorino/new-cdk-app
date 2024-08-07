import { App } from "aws-cdk-lib";
import { env } from '../bin/cdk-app-example';
import { CdkAppExampleStack } from '../lib/cdk-app-example-stack';


describe("Synthesize tests", () => {
    const app = new App();

    test("Creates the stack without exceptions", () => {
        expect(() => {
            new CdkAppExampleStack(app, "CdkAppExampleStack", {
                description: "CdkAppExampleStack",
                env,
            });
        }).not.toThrow();
    });

    test("This app can synthesize completely", () => {
        expect(() => {
            app.synth();
        }).not.toThrow();
    });
});
