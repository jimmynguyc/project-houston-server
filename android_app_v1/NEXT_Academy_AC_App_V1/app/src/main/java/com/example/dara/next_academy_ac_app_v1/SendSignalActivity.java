package com.example.dara.next_academy_ac_app_v1;

import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

public class SendSignalActivity extends AppCompatActivity implements AdapterView.OnItemSelectedListener {
  private Button sendRequest;
    private Spinner spinner_status;
    private Spinner spinner_mode;
    private Spinner spinner_temperature;
    private Spinner spinner_fan_speed;
    private String[] arraySpinner_temperature;
    private String[] arraySpinner_fan_speed;
    private String[] arraySpinner_mode;
    private String[] arraySpinner_status;
    private TextView id;
    private TextView alias;
    static final int READ_BLOCK_SIZE = 100;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.activity_send_signal);
        sendRequest = (Button) findViewById(R.id.button_send_json);
        spinner_status = (Spinner) findViewById(R.id.status);
        spinner_mode = (Spinner) findViewById(R.id.spinner_mode);
        spinner_temperature = (Spinner) findViewById(R.id.spinner_temperature);
        spinner_fan_speed = (Spinner) findViewById(R.id.spinner_fan_speed);
        id = (TextView) findViewById(R.id.textView_ID);
        alias = (TextView) findViewById(R.id.textView_alias);
        id.setText("AIRCONDITIONER ID: "+(CharSequence) getIntent().getSerializableExtra("ID"));
        alias.setText("ALIAS: " + getIntent().getSerializableExtra("Alias"));
        this.arraySpinner_temperature = new String[] {
                "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"
        };
        this.arraySpinner_fan_speed = new String[]{
                "1", "2", "3", "AUTO"
        };
        this.arraySpinner_mode = new String[]{
                "WET", "COLD", "DRY"
        };
        this.arraySpinner_status = new String[]{
                "ON", "OFF"
        };

        //temperature
        int selectedItem = 0;
        final int[] laterSelected = {-1};
        final int[] finalLaterSelected = {laterSelected[0]};
        //status
        int selectedItem_status = 0;
        final int[] laterSelected_status = {-1};
        final int[] finalLaterSelected_status = {laterSelected_status[0]};
        //mode
        int selectedItem_mode = 0;
        final int[] laterSelected_mode = {-1};
        final int[] finalLaterSelected_mode = {laterSelected_mode[0]};
        //fan speed
        int selectedItem_fan_speed = 0;
        final int[] laterSelected_fan_speed = {-1};
        final int[] finalLaterSelected_fan_speed = {laterSelected_fan_speed[0]};

        //for loop for temperature
        for (int i=0;i<arraySpinner_temperature.length;i++) {
            if (arraySpinner_temperature[i].contains(getIntent().getSerializableExtra("Temperature").toString())) {
                selectedItem=i;
            }
        }
        //for loop for status
        for (int i=0;i<arraySpinner_status.length;i++){
            if (arraySpinner_status[i].contains(getIntent().getSerializableExtra("Status").toString())){
                selectedItem_status = i;
            }
        }
        //for looop for mode
        for (int i=0;i<arraySpinner_mode.length;i++){
            if (arraySpinner_mode[i].contains(getIntent().getSerializableExtra("Mode").toString())){
                selectedItem_mode = i;
            }
        }
        //for loop for fan speed
        for (int i=0;i<arraySpinner_fan_speed.length;i++){
            if (arraySpinner_fan_speed[i].contains(getIntent().getSerializableExtra("Fan Speed").toString())){
                selectedItem_fan_speed = i;
            }
        }

        // Creating adapter for spinner
        //status ArrayAdapter
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, arraySpinner_status){
            @Override
            public View getDropDownView(int position, View convertView, ViewGroup parent)
            {
                View v = null;
                v = super.getDropDownView(position, null, parent);
                if (position == finalLaterSelected_status[0]){
                    v.setBackgroundColor(Color.BLUE);
                }
                else {
                    // for other views
                    v.setBackgroundColor(Color.WHITE);
                }
                return v;
            }
        };

        //temperature ArrayAdapter
         ArrayAdapter<String> temperatureAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item,arraySpinner_temperature){
            @Override
            public View getDropDownView(int position, View convertView, ViewGroup parent)
            {
                View v = null;
                v = super.getDropDownView(position, null, parent);
               if (position == finalLaterSelected[0]){
                    v.setBackgroundColor(Color.BLUE);
                }
                else {
                    // for other views
                    v.setBackgroundColor(Color.WHITE);
                }
                return v;
            }
        };

        ArrayAdapter<String> modeAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item,arraySpinner_mode){
            @Override
            public View getDropDownView(int position, View convertView, ViewGroup parent)
            {
                View v = null;
                v = super.getDropDownView(position, null, parent);
                if (position == finalLaterSelected_mode[0]){
                    v.setBackgroundColor(Color.BLUE);
                }
                else {
                    // for other views
                    v.setBackgroundColor(Color.WHITE);
                }
                return v;
            }
        };

        ArrayAdapter<String> fanspeedAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item,arraySpinner_fan_speed){
            @Override
            public View getDropDownView(int position, View convertView, ViewGroup parent)
            {
                View v = null;
                v = super.getDropDownView(position, null, parent);
                if (position == finalLaterSelected_fan_speed[0]){
                    v.setBackgroundColor(Color.BLUE);
                }
                else {
                    // for other views
                    v.setBackgroundColor(Color.WHITE);
                }
                return v;
            }
        };

        // Drop down layout style - list view with radio button
        dataAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        modeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        fanspeedAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        temperatureAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // attaching data adapter to spinner
        //Status SET
        spinner_status.setAdapter(dataAdapter);
        spinner_status.setSelection(selectedItem_status);
        spinner_status.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String selectedItemText = (String) parent.getItemAtPosition(position);
                if (spinner_status.getSelectedItem().equals("OFF")){
                    spinner_mode.setEnabled(false);
                    spinner_temperature.setEnabled(false);
                    spinner_fan_speed.setEnabled(false);
                }
                else if (spinner_status.getSelectedItem().equals("ON")){
                    spinner_mode.setEnabled(true);
                    if (spinner_mode.getSelectedItem().equals("DRY")){
                        spinner_temperature.setEnabled(false);
                        spinner_fan_speed.setEnabled(true);
                    }
                    else if (spinner_mode.getSelectedItem().equals("WET")){
                        spinner_temperature.setEnabled(true);
                        spinner_fan_speed.setEnabled(false);
                    }
                    else if (spinner_mode.getSelectedItem().equals("COLD")) {
                        spinner_fan_speed.setEnabled(true);
                        spinner_temperature.setEnabled(true);
                    }
                }
                finalLaterSelected_status[0] = position;
            }
            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        //Temperature SET
        spinner_temperature.setAdapter(temperatureAdapter);
        spinner_temperature.setSelection(selectedItem);
        spinner_temperature.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            //    String selectedItemText = (String) parent.getItemAtPosition(position);
               finalLaterSelected[0] = position;
            }
            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        //mode SET
        spinner_mode.setAdapter(modeAdapter);
        spinner_mode.setSelection(selectedItem_mode);
        spinner_mode.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            //    String selectedItemText = (String) parent.getItemAtPosition(position);
                if (parent.getItemAtPosition(position).equals("COLD")){
                    spinner_fan_speed.setEnabled(true);
                    spinner_temperature.setEnabled(true);
                }
                else if (parent.getItemAtPosition(position).equals("DRY")){
                    spinner_temperature.setEnabled(false);
                    spinner_fan_speed.setEnabled(true);
                }
                else if (parent.getItemAtPosition(position).equals("WET")){
                    spinner_temperature.setEnabled(true);
                    spinner_fan_speed.setEnabled(false);
                }
                finalLaterSelected_mode[0] = position;
            }
            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        //Fan Speed SET
        spinner_fan_speed.setAdapter(fanspeedAdapter);
        spinner_fan_speed.setSelection(selectedItem_fan_speed);
        spinner_fan_speed.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
              //  String selectedItemText = (String) parent.getItemAtPosition(position);
                finalLaterSelected_fan_speed[0] = position;
            }
            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });
  }

    @Override
    protected void onStart() {
        super.onStart();
        sendRequest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                sendDataToServer();
                try {
                    FileInputStream fileIn=openFileInput("app_token.txt");
                    InputStreamReader InputRead= new InputStreamReader(fileIn);

                    char[] inputBuffer= new char[READ_BLOCK_SIZE];
                    String s="";
                    int charRead;

                    while ((charRead=InputRead.read(inputBuffer))>0) {
                        // char to string conversion
                        String readstring=String.copyValueOf(inputBuffer,0,charRead);
                        s +=readstring;
                    }
                    InputRead.close();
                    Toast.makeText(getApplicationContext(),s,Toast.LENGTH_SHORT);


                } catch (Exception e) {
                    e.printStackTrace();
                }
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
                super.onPostExecute(result);
            }
        }.execute();
    }

    private String formatDataAsJson() {
        //function in the activity that corresponds to the layout button
        spinner_status = (Spinner) findViewById(R.id.status);
        spinner_mode = (Spinner) findViewById(R.id.spinner_mode);
        spinner_temperature = (Spinner) findViewById(R.id.spinner_temperature);
        spinner_fan_speed = (Spinner) findViewById(R.id.spinner_fan_speed);
        //JSONObject
        JSONObject appToken = new JSONObject();
        JSONObject request = new JSONObject();

        try {
            FileInputStream fileIn=openFileInput("app_token.txt");
            InputStreamReader InputRead= new InputStreamReader(fileIn);

            char[] inputBuffer= new char[READ_BLOCK_SIZE];
            String s="";
            int charRead;

            while ((charRead=InputRead.read(inputBuffer))>0) {
                // char to string conversion
                String readstring=String.copyValueOf(inputBuffer,0,charRead);
                s +=readstring;
            }
            InputRead.close();
           // Toast.makeText(getApplicationContext(),s,Toast.LENGTH_SHORT);
            FileInputStream fileIn1=openFileInput("username.txt");
            InputStreamReader InputRead1= new InputStreamReader(fileIn1);

            char[] inputBuffer1 = new char[READ_BLOCK_SIZE];
            String s1="";
            int charRead1;

            while ((charRead1=InputRead1.read(inputBuffer1))>0) {
                // char to string conversion
                String readstring=String.copyValueOf(inputBuffer1,0,charRead1);
                s1 +=readstring;
                System.out.println("Username is "+s1);
            }
            InputRead1.close();
            //Toast.makeText(getApplicationContext(),s,Toast.LENGTH_SHORT);
            appToken.put("user_name", s1);
            appToken.put("app_token",s);
            appToken.put("aircond",request);
            request.put("status", spinner_status.getSelectedItem());
            request.put("mode", spinner_mode.getSelectedItem());
            if (spinner_mode.getSelectedItem().equals("WET")){
                request.put("fan_speed","");
                request.put("temperature", spinner_temperature.getSelectedItem());
            }
            else if (spinner_mode.getSelectedItem().equals("DRY")){
                request.put("fan_speed",spinner_fan_speed.getSelectedItem());
                request.put("temperature", "");
            }
            else {
                request.put("fan_speed",spinner_fan_speed.getSelectedItem());
                request.put("temperature", spinner_temperature.getSelectedItem());
            }
            return appToken.toString();
        } catch (JSONException e1) {

            Log.d("JWP", "Can't format JSON");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
    private String getServerResponse(String json) {
        HttpPost post = new HttpPost("https://55ff2fc4.ngrok.io/app_state/"+getIntent().getSerializableExtra("ID"));
        try {
            StringEntity entity = new StringEntity(json);
            post.setEntity(entity);
            post.setHeader("Content-type", "application/json");
            DefaultHttpClient client = new DefaultHttpClient();
            BasicResponseHandler handler = new BasicResponseHandler();
            String response = client.execute(post, handler);
            System.out.println(response);
            JSONObject jsonObject = (JSONObject) new JSONTokener(response).nextValue();
            String output = jsonObject.getString("response");
            System.out.println(output);
          //  Toast toast = Toast.makeText(getActivity(), "Success!", Toast.LENGTH_SHORT);
           // toast.show();
            return response;
        }
        catch (UnsupportedEncodingException e) {
            Log.d("JWP", e.toString());
        } catch (ClientProtocolException e) {
            Log.d("JWP", e.toString());
        } catch (IOException e) {
            Log.d("JWP", e.toString());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return "Unable to contact with Server";
    }
    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }
    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }
}