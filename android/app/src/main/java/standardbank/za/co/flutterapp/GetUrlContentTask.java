package standardbank.za.co.flutterapp;

import android.os.AsyncTask;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

public abstract class GetUrlContentTask extends AsyncTask<String, Integer, String> {
    protected String doInBackground(String... urls) {
        try {
            URL url = new URL(urls[0]);
            HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
//            connection.setDoOutput(true);
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            connection.connect();
            BufferedReader rd = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String content = "", line;
            while ((line = rd.readLine()) != null) {
                content += line + "\n";
            }
            return content;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    protected void onProgressUpdate(Integer... progress) {
    }

    abstract protected void onPostExecute(String result);
}
