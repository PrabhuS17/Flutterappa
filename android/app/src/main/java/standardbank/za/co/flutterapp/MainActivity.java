package standardbank.za.co.flutterapp;

import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  Double latitude, longitude;

  private int requestCode=12332;
  NotificationService notifier;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    notifier = new NotificationService(getApplicationContext());
    if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
      ActivityCompat.requestPermissions(this,
              new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION},
              requestCode);


    } else {
      Intent service = new Intent(getApplicationContext(), GoogleService.class);

      this.startService(service);
//      registerReceiver(broadcastReceiver, new IntentFilter(GoogleService.str_receiver));
    }
  }

  @Override
  public void onRequestPermissionsResult(int requestCode,
                                         String permissions[], int[] grantResults) {
    switch (requestCode) {
      case 1: {
        // If request is cancelled, the result arrays are empty.
        if (grantResults.length > 0
                && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
          Intent service = new Intent(getApplicationContext(), GoogleService.class);
          this.startService(service);
//          registerReceiver(broadcastReceiver, new IntentFilter(GoogleService.str_receiver));
        } else {
          // permission denied, boo! Disable the
          // functionality that depends on this permission.
        }
        return;
      }

      // other 'case' lines to check for other
      // permissions this app might request.
    }
  }


  private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {

      latitude = Double.valueOf(intent.getStringExtra("latutide"));
      longitude = Double.valueOf(intent.getStringExtra("longitude"));
      if (!notifier.isNotificationVisible()) {
        notifier.createNotification("Gautrain balance is low","You are running low on balance on your Gautrain card. Tap to recharge");
      }

      Toast.makeText(context, "Latitude =" + latitude + "Longitude= " + longitude, Toast.LENGTH_SHORT).show();
    }
  };
}
