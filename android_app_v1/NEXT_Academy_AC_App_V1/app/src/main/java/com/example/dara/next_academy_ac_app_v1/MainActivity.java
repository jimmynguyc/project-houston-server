package com.example.dara.next_academy_ac_app_v1;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.SimpleAdapter;
import android.widget.Toast;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;

public class MainActivity extends AppCompatActivity {

    private EditText Username;
    private EditText Password;
    private Button Login;
    private Button Register;
    RelativeLayout notificationCount1;
    private ListView lv;
    ArrayList<HashMap<String, String>> contactList;
    private ProgressDialog pDialog;
    private String TAG = MainActivity.class.getSimpleName();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getSupportActionBar().hide();

        setContentView(R.layout.activity_main);


    }


    @Override
    protected void onStart() {
        super.onStart();

        Login = (Button) findViewById(R.id.button_login);
        Register = (Button) findViewById(R.id.button_register);

        Register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(MainActivity.this, Registration_Activity.class));
            }
        });

        Login.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                String url = "https://55ff2fc4.ngrok.io/get_token";
                Username = (EditText) findViewById(R.id.editText_username_login);
                Password = (EditText) findViewById(R.id.editText_pass_login);
                connectWithHttpGet(Username.getText().toString(), Password.getText().toString());


                    /* Intent intent = new Intent (MainActivity.this, SendSignalActivity.class);
                    startActivity(intent);


                    System.out.println(Username.getText().toString());
                    System.out.println(Password.getText().toString());
                    AlertDialog.Builder helpBuilder = new AlertDialog.Builder(MainActivity.this);
                    helpBuilder.setTitle("Error");
                    helpBuilder.setMessage("Wrong username or password.");
                    helpBuilder.setPositiveButton("Ok",
                            new DialogInterface.OnClickListener() {

                                public void onClick(DialogInterface dialog, int which) {
                                    // Do nothing but close the dialog

                                }
                            });

                    // Remember, create doesn't show the dialog
                    final AlertDialog helpDialog = helpBuilder.create();
                    helpBuilder.show();
*/
            }
        });



    }



    private void connectWithHttpGet(String givenUsername, String givenPassword) {

        // Connect with a server is a time consuming process.
        //Therefore we use AsyncTask to handle it
        // From the three generic types;
        //First type relate with the argument send in execute()
        //Second type relate with onProgressUpdate method which I haven't use in this code
        //Third type relate with the return type of the doInBackground method, which also the input type of the onPostExecute method
        class HttpGetAsyncTask extends AsyncTask<String, Void, String>{

            @Override
            protected String doInBackground(String... params) {

                // As you can see, doInBackground has taken an Array of Strings as the argument
                //We need to specifically get the givenUsername and givenPassword
                String paramUsername = params[0];
                String paramPassword = params[1];
                System.out.println("paramUsername" + paramUsername + " paramPassword is :" + paramPassword);

                // Create an intermediate to connect with the Internet
                HttpClient httpClient = new DefaultHttpClient();

                // Sending a GET request to the web page that we want
                // Because of we are sending a GET request, we have to pass the values through the URL
                HttpGet httpGet = new HttpGet("https://55ff2fc4.ngrok.io/get_token?user_name=" + paramUsername + "&password=" + paramPassword);

                try {
                    // execute(); executes a request using the default context.
                    // Then we assign the execution result to HttpResponse
                    HttpResponse httpResponse = httpClient.execute(httpGet);
                    System.out.println("httpResponse");
                            // getEntity() ; obtains the message entity of this response
                            // getContent() ; creates a new InputStream object of the entity.
                            // Now we need a readable source to read the byte stream that comes as the httpResponse
                            InputStream inputStream = httpResponse.getEntity().getContent();

                    // We have a byte stream. Next step is to convert it to a Character stream
                    InputStreamReader inputStreamReader = new InputStreamReader(inputStream);

                    // Then we have to wraps the existing reader (InputStreamReader) and buffer the input
                    BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                    // InputStreamReader contains a buffer of bytes read from the source stream and converts these into characters as needed.
                    //The buffer size is 8K
                    //Therefore we need a mechanism to append the separately coming chunks in to one String element
                    // We have to use a class that can handle modifiable sequence of characters for use in creating String
                    StringBuilder stringBuilder = new StringBuilder();

                    String bufferedStrChunk = null;

                    // There may be so many buffered chunks. We have to go through each and every chunk of characters
                    //and assign a each chunk to bufferedStrChunk String variable
                    //and append that value one by one to the stringBuilder
                    while((bufferedStrChunk = bufferedReader.readLine()) != null){
                        stringBuilder.append(bufferedStrChunk);
                    }

                    // Now we have the whole response as a String value.
                    //We return that value then the onPostExecute() can handle the content
                    System.out.println("Returninge of doInBackground :" + stringBuilder.toString());

                    // If the Username and Password match, it will return "working" as response
                    // If the Username or Password wrong, it will return "invalid" as response
                    return stringBuilder.toString();

                } catch (ClientProtocolException cpe) {
                    System.out.println("Exceptionrates caz of httpResponse :" + cpe);
                    cpe.printStackTrace();
                } catch (IOException ioe) {
                    System.out.println("Secondption generates caz of httpResponse :" + ioe);
                    ioe.printStackTrace();
                }

                return null;
            }

            // Argument comes for this method according to the return type of the doInBackground() and
            //it is the third generic type of the AsyncTask
            @Override
            protected void onPostExecute(String result) {
                super.onPostExecute(result);
                System.out.println(result);
                String search = "app_token";
                String filename = "app_token.txt";
                String filename1 = "username.txt";
                Username = (EditText) findViewById(R.id.editText_username_login);
                System.out.println("Your username is: " + Username.getText().toString());
                JSONObject json= null;
                String json2 = null;

                try {
                    json = (JSONObject) new JSONTokener(result).nextValue();
                    System.out.println("JSON ="+json);
                    json2 = json.getString("app_token");
                    System.out.println("JSON2 ="+json2);

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                String string = String.valueOf(json2);
                System.out.println("String value of JSON2 ="+string);

                FileOutputStream outputStream;
                FileOutputStream outputStream1;
                try {
                    outputStream = openFileOutput(filename, Context.MODE_PRIVATE);
                    outputStream.write(string.getBytes());
                    System.out.println("Your app token after convertion " +string.getBytes());
                    outputStream.close();
                    outputStream1 = openFileOutput(filename1, Context.MODE_PRIVATE);
                    outputStream1.write(Username.getText().toString().getBytes());
                    System.out.println("Username after convertion "+Username.getText().toString().getBytes());
                    outputStream1.close();
                    System.out.println("File saved successfully!");

                } catch (Exception e) {
                    e.printStackTrace();
                }

                if(result.toLowerCase().indexOf(search.toLowerCase()) != -1 ){
                    Toast.makeText(getApplicationContext(), "You have successfully logged in.", Toast.LENGTH_LONG).show();
                    startActivity(new Intent (MainActivity.this, ListOfACActivity.class));
                }else{
                    Toast.makeText(getApplicationContext(), "Invalid username or password.", Toast.LENGTH_LONG).show();
                }
            }
        }

        // Initialize the AsyncTask class
        HttpGetAsyncTask httpGetAsyncTask = new HttpGetAsyncTask();
        // Parameter we pass in the execute() method is relate to the first generic type of the AsyncTask
        // We are passing the connectWithHttpGet() method arguments to that
        httpGetAsyncTask.execute(givenUsername, givenPassword);

    }



}





 /*@Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle presses on the action bar items
        switch (item.getItemId()) {
            case R.id.logout:
                //logout code
                Intent intent = new Intent (MainActivity.this, SendSignalActivity.class);
                startActivity(intent);
            default:
                return super.onOptionsItemSelected(item);
        }
    }*/
//rest of app


//  getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
//        WindowManager.LayoutParams.FLAG_FULLSCREEN);
// requestWindowFeature(Window.FEATURE_NO_TITLE);
//getSupportActionBar().setBackgroundDrawable(new ColorDrawable(getResources().getColor(R.color.colorPrimaryDark)));
//  getSupportActionBar().setBackgroundDrawable(new ColorDrawable(Color.parseColor("#000000")));
//getSupportActionBar().setTitle("");
//getSupportActionBar();


//getSupportActionBar().setDisplayUseLogoEnabled(true);
//getSupportActionBar().setLogo(R.drawable.ic_next_logo);