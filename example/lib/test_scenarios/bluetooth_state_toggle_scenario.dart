part of test_scenarios;

class BluetoothStateTestScenario implements TestScenario {
  @override
  Future<void> runTestScenario(Logger log, Logger errorLogger) async {
    BleManager bleManager = BleManager.getInstance();

    log("SCENARIO WON'T WORK IF BLUETOOTH IS ENABLED");
    log("Waiting 10 seconds for user to turn BT off");
    await Future.delayed(Duration(seconds: 10));

    log("Creating client...");
    await bleManager.createClient();
    log("Created client");

    log("Enabling radio...");
    try {
      await bleManager.enableRadio();
    } catch (e) {
      errorLogger(e);
    }

    log("Enabled radio!");

    log("Waiting 10 seconds before disabling radio...");
    await Future.delayed(Duration(seconds: 10));

    log("Disabling radio...");
    await bleManager.disableRadio().catchError((error) => errorLogger(error));
    log("Disabled radio!");

    log("Destroying client");
    await bleManager.destroyClient();
    log("Destroyed client!");
  }
}
