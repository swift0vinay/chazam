package com.example.chazam;

import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.lang.reflect.Array;
import java.util.ArrayList;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    static private MethodChannel channel;
    static private String channelName = "battery";
    static Handler handler = new Handler();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor(), channelName);
        channel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @RequiresApi(api = Build.VERSION_CODES.P)
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        if (call.method.equals("getBatteryLevel")) {
                            getBatteryLevel();
                            result.success(1);
                        } else {
                            result.notImplemented();
                        }
                    }
                }
        );
    }

    @RequiresApi(api = Build.VERSION_CODES.P)
    private void getBatteryLevel() {
        handler.post(sendBattery);
    }

    private final Runnable sendBattery = new Runnable() {
        @RequiresApi(api = Build.VERSION_CODES.P)
        @Override
        public void run() {
            try {
                float batteryLevel = -1.0f;
                long chargingTimeRemaining = 0;
                boolean isCharging = true;
                String chargingType = "";
                String batteryHealth = "";
                ArrayList<String> ans = new ArrayList<>();
                IntentFilter intentFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
                Intent battery = registerReceiver(null, intentFilter);
                int level = battery.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
                int scale = battery.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
                batteryLevel = (level * 100) / (float) scale;
                ans.add(Float.toString(batteryLevel));
                ans.add("0");
                int rs = battery.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
                isCharging = rs == BatteryManager.BATTERY_STATUS_CHARGING || rs == BatteryManager.BATTERY_STATUS_FULL;
                ans.add(Boolean.toString(isCharging));
                int chargePlug = battery.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1);
                chargingType = chargePlug == BatteryManager.BATTERY_PLUGGED_USB ? "USB" : chargePlug == BatteryManager.BATTERY_PLUGGED_AC ? "AC" : "NA";
                ans.add(chargingType);
                int health = battery.getIntExtra(BatteryManager.EXTRA_HEALTH, -1);
                switch (health) {
                    case BatteryManager.BATTERY_HEALTH_GOOD:
                        batteryHealth = "GOOD";
                        break;
                    case BatteryManager.BATTERY_HEALTH_COLD:
                        batteryHealth = "COLD";
                        break;
                    case BatteryManager.BATTERY_HEALTH_DEAD:
                        batteryHealth = "DEAD";
                        break;
                    case BatteryManager.BATTERY_HEALTH_UNKNOWN:
                        batteryHealth = "NA";
                        break;
                    case BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE:
                        batteryHealth = "OVER VOLTAGE";
                        break;
                    case BatteryManager.BATTERY_HEALTH_OVERHEAT:
                        batteryHealth = "OVERHEAT";
                        break;
                    case BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE:
                        batteryHealth = "NA";
                        break;
                    default:
                        batteryHealth = "NA";
                        break;
                }
                ans.add(batteryHealth);
                channel.invokeMethod("getList", ans);
                handler.postDelayed(this, 300);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };

}
