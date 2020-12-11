package com.polidea.flutter_ble_lib_example;

import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.reactivex.plugins.RxJavaPlugins;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    RxJavaPlugins.setErrorHandler(throwable -> Log.w("GlobalErrorHandler", throwable));
  }
}
