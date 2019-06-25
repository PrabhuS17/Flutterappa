package standardbank.za.co.flutterapp;

import android.annotation.SuppressLint;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.InetAddress;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by deepshikha on 24/11/16.
 */

public class GoogleService extends Service implements LocationListener {

    boolean isGPSEnable = false;
    boolean isNetworkEnable = false;
    double latitude, longitude;
    LocationManager locationManager;
    Location location;
    private Handler mHandler = new Handler();
    private Timer mTimer = null;
    long notify_interval = 30000;
    public static String str_receiver = "servicetutorial.service.receiver";
    Intent intent;
    //    static String url = "http://10.0.2.2:8082";
    static String url = "https://mttg65bzj1.execute-api.us-east-2.amazonaws.com";

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return  START_STICKY;
    }
    NotificationService notifier;
    public GoogleService() {

    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    int delay=60000;
    @Override
    public void onCreate() {
        super.onCreate();
        notifier = new NotificationService(getApplicationContext());
        mTimer = new Timer();
        mTimer.schedule(new TimerTaskToGetLocation(), 1000, notify_interval);
        intent = new Intent(str_receiver);
//        fn_getlocation();
    }

    @Override
    public void onLocationChanged(Location location) {

    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }

    @SuppressLint("MissingPermission")
    private void fn_getlocation() {
        locationManager = (LocationManager) getApplicationContext().getSystemService(LOCATION_SERVICE);
        isGPSEnable = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        isNetworkEnable = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

        if (!isGPSEnable && !isNetworkEnable) {

        } else {

            if (isNetworkEnable) {
                location = null;
                locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, delay, 0, this);
                if (locationManager != null) {
                    location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
                    if (location != null) {

                        Log.e("latitude", location.getLatitude() + "");
                        Log.e("longitude", location.getLongitude() + "");

                        latitude = location.getLatitude();
                        longitude = location.getLongitude();
                        fn_update(location);
                    }
                }

            }


            if (isGPSEnable) {
                location = null;
                locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, delay, 0, this);
                if (locationManager != null) {
                    location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                    if (location != null) {
                        Log.e("latitude", location.getLatitude() + "");
                        Log.e("longitude", location.getLongitude() + "");
                        latitude = location.getLatitude();
                        longitude = location.getLongitude();
                        fn_update(location);
                    }
                }
            }


        }

    }

    private class TimerTaskToGetLocation extends TimerTask {
        @Override
        public void run() {

            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    fn_getlocation();
                }
            });

        }
    }

    private void fn_update(Location location) {

        intent.putExtra("latutide", location.getLatitude() + "");
        intent.putExtra("longitude", location.getLongitude() + "");
        updateLocationToUser(intent);
    }


    public void notifyUser(){
        if (!notifier.isNotificationVisible()) {
            notifier.createNotification("Gautrain balance is low","You are running low on balance on your Gautrain card. Tap to recharge");
        }

        Toast.makeText(getApplicationContext(), "Latitude =" + latitude + "Longitude= " + longitude, Toast.LENGTH_SHORT).show();
    }
    public void updateLocationToUser(final Intent intent) {
        System.out.println(new Date().toString() + " The location is");
        System.out.println(location.getLatitude());
        System.out.println(location.getLongitude());
        try {
            if (isNetworkConnected()) {
                try {
                    new GetUrlContentTask() {

                        @Override
                        protected void onPostExecute(String result) {
                            System.out.println(result);
                            if("".equals(result))
                            {
                                return;
                            }
                            JSONObject obj = null;
                            try {
                                obj = new JSONObject(result);

                                System.out.println(location);
                                if (GoogleService.this.checkIfUserNeedsToBeUpdated(location, obj, 500)) {
                                    System.out.println("Updating as true");
//                new GetUrlContentTask().execute(url+"/sb/updateLocation?lat=" + location.getLatitude() + "&lon=" + location.getLongitude());
                                    notifyUser();
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    }.execute(url + "/api/gsgl");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                Map<String, ?> pairs = getSharedPreferences(LOCATION_PREFERENCE, MODE_PRIVATE).getAll();
                for (Map.Entry e : pairs.entrySet()) {
                    String[] data = e.getValue().toString().split(",");
                    if (checkIfUserNeedsToBeAlerted(location, Double.parseDouble(data[0]), Double.parseDouble(data[1]), Double.parseDouble(data[2]), e.getKey().toString())) {
                        notifyUser();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    static final String LOCATION_PREFERENCE = "LOCATION_PREFERENCE";

    void storeLocation(String key, String value) {
        SharedPreferences.Editor editor = getSharedPreferences(LOCATION_PREFERENCE, MODE_PRIVATE).edit();
        editor.putString(key, value);
        editor.apply();
    }

    private boolean isNetworkConnected() {
        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        System.out.println("IsNetWorkConnected : " + (cm.getActiveNetworkInfo() != null));
        return cm.getActiveNetworkInfo() != null;
    }

    public boolean isInternetAvailable() {
        try {
            InetAddress ipAddr = InetAddress.getByName("google.com");
            System.out.println("isInternetAvailable : " + (!ipAddr.equals("")));
            return !ipAddr.equals("");

        } catch (Exception e) {
            System.out.println("isInternetAvailable : " + false);
            return false;
        }
    }

    boolean checkIfUserNeedsToBeUpdated(Location loc, JSONObject stations, double thresholdDistance) throws JSONException {
        Iterator iterator = stations.keys();
        while (iterator.hasNext()) {
            String key = (String) iterator.next();
            JSONObject latLon = (JSONObject) stations.get(key);
            double latitude = Double.parseDouble((String) latLon.get("latitude"));
            double longitude = Double.parseDouble((String) latLon.get("longitude"));
            double threshold = (int) latLon.get("threshold");
            storeLocation(key, String.valueOf(latitude) + "," + String.valueOf(longitude) + "," + String.valueOf(threshold));
            if (checkIfUserNeedsToBeAlerted(loc, latitude, longitude, threshold, key)) {
                return true;
            }
        }
        return false;
    }

    boolean checkIfUserNeedsToBeAlerted(Location loc, double latitude, double longitude, double threshold, String stationName) {
        double distance = distance(loc.getLatitude(), loc.getLongitude(), latitude, longitude);
        System.out.println("Distance is: " + distance + "and Threshold distance =" + threshold);
        if (threshold >= distance) {
            return true;
        }
        return false;
    }

    /**
     * Calculate distance between two points in latitude and longitude taking
     * into account height difference. If you are not interested in height
     * difference pass 0.0. Uses Haversine method as its base.
     * <p>
     * lat1, lon1 Start point lat2, lon2 End point el1 Start altitude in meters
     * el2 End altitude in meters
     *
     * @returns Distance in Meters
     */
    public static double distance(double lat1, double lon1, double lat2,
                                  double lon2) {

        final int R = 6371; // Radius of the earth

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = R * c * 1000; // convert to meters

//        double height = el1 - el2;
//
        distance = Math.pow(distance, 2) + Math.pow(1, 2);

        return Math.sqrt(distance);
    }

}