import { App, Stack } from 'aws-cdk-lib';
import { env } from '../bin/cdk-app-example';

describe("Synthesize tests", () => {
  const app = new App();

  test("Creates the stack without exceptions", () => {
    expect(() => {
      new Stack(app, "Stack", {
        description: "Stack",
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
