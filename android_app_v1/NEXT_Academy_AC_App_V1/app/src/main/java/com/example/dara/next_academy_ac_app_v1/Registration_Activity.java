package com.example.dara.next_academy_ac_app_v1;

import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

public class Registration_Activity extends AppCompatActivity {


    private EditText Username;
    private EditText Password;
    private Button Register;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registration_);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Username = (EditText) findViewById(R.id.editText_username_registration);
        Password = (EditText) findViewById(R.id.editText_pass_registration);
        Register = (Button) findViewById(R.id.button_registration_request);

        Register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                sendDataToServer();
            }
        });
    }


    public void sendDataToServer() {

        final String json = formatDataAsJson();

        new AsyncTask<Void, Void, String>() {

            @Override
            protected String doInBackground(Void... voids) {
                return getServerResponse(json);
            }

            @Override
            protected void onPostExecute(String result) {
  //              TextView output = (TextView) findViewById(R.id.output);
//                output.setText(result);
                super.onPostExecute(result);
            }

        }.execute();


    }


    private String formatDataAsJson() {
        //function in the activity that corresponds to the layout button
       Username = (EditText) findViewById(R.id.editText_username_registration);
        Password = (EditText) findViewById(R.id.editText_pass_registration);
        //JSONObject
        JSONObject request = new JSONObject();


        try {

            request.put("user_name", Username.getText().toString());
            request.put("password", Password.getText().toString());

            System.out.println(request);
            return request.toString();
        } catch (JSONException e1) {

            Log.d("JWP", "Can't format JSON");
        }

        return null;

        /*if (post_dict.length() > 0) {
            new SendJsonDataToServer().execute(String.valueOf(post_dict));
            //call to async class
        }*/

    }
    private String getServerResponse(String json) {

        HttpPost post = new HttpPost("https://55ff2fc4.ngrok.io/app_create");

        try {
            StringEntity entity = new StringEntity(json);

            post.setEntity(entity);
            post.setHeader("Content-type", "application/json");

            DefaultHttpClient client = new DefaultHttpClient();

            BasicResponseHandler handler = new BasicResponseHandler();

            String response = client.execute(post, handler);

            return response;

        } catch (UnsupportedEncodingException e) {
            Log.d("JWP", e.toString());
        } catch (ClientProtocolException e) {
            Log.d("JWP", e.toString());
        } catch (IOException e) {
            Log.d("JWP", e.toString());
        }

        return "Unable to contact with Server";
    }


}


