import { App } from 'aws-cdk-lib';

describe("Synthesize tests", () => {
  const app = new App();

  test("Creates the stack without exceptions", () => {
    expect(() => {
      new Stack(app, "Stack", {
        description: "Stack",
        env: lvkProd,
      });
    }).not.toThrow();
  });

  test("This app can synthesize completely", () => {
    expect(() => {
      app.synth();
    }).not.toThrow();
  });
});

