package com.example.dara.next_academy_ac_app_v1;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.Calendar;

public class ListOfACActivity extends AppCompatActivity implements AdapterView.OnItemClickListener {

    private Button Logout;
    private DatabaseReference mSearchedLocationReference;
    private int count=0;
    final ArrayListOfAC aircondsList = new ArrayListOfAC();
    final ArrayList<String> friends = new ArrayList<String>();
    final ArrayList<ArrayListOfAC> list = new ArrayList<ArrayListOfAC>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.activity_list_of_ac);
        mSearchedLocationReference = FirebaseDatabase
                .getInstance()
                .getReference()
                .child("airconds");
        final ListView listView = (ListView) findViewById(R.id.listView);
        
        mSearchedLocationReference.addValueEventListener(new ValueEventListener() {

            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                friends.clear();
                    count++;
                for (DataSnapshot snapshot : dataSnapshot.getChildren()) {
                   aircondsList.setID(snapshot.getValue().toString());
                    if (snapshot.hasChild("fan_speed")){
                        aircondsList.setFan_speed(snapshot.child("fan_speed").getValue().toString());
                    }
                    else{
                        aircondsList.setFan_speed(" ");
                    }

                    if (snapshot.hasChild("temperature")){
                        aircondsList.setTemperature(snapshot.child("temperature").getValue().toString());
                    }
                    else {
                        aircondsList.setTemperature(" ");

                    }
                    aircondsList.setID(snapshot.getKey());
                    aircondsList.setAlias(snapshot.child("alias").getValue().toString());
                    aircondsList.setMode(snapshot.child("mode").getValue().toString());
                    aircondsList.setStatus(snapshot.child("status").getValue().toString());
                    aircondsList.setSize(String.valueOf(count));

                    if (aircondsList.getStatus().toString().equals("OFF")){

                        friends.add("ID:"+aircondsList.getID() +"\n"+"Alias: "+aircondsList.getAlias()+ "\n"+" Status: " + aircondsList.getStatus()+ "\n");
                        list.add(new ArrayListOfAC(aircondsList.getID(),aircondsList.getStatus(),aircondsList.getMode(),aircondsList.getFan_speed(),aircondsList.getTemperature(),aircondsList.getSize(),aircondsList.getAlias()));
                    }
                    else {
                        if (aircondsList.getMode().toString().equals("DRY")){
                            friends.add("ID:"+aircondsList.getID() + "\n"+"Alias: "+aircondsList.getAlias()+"\n"+" Status: " + aircondsList.getStatus()+ "\n"+" Mode: " + aircondsList.getMode()+ "\n"+" Fan Speed: "+aircondsList.getFan_speed());
                            list.add(new ArrayListOfAC(aircondsList.getID(),aircondsList.getStatus(),aircondsList.getMode(),aircondsList.getFan_speed(),aircondsList.getTemperature(),aircondsList.getSize(),aircondsList.getAlias()));

                        }
                        else if (aircondsList.getMode().toString().equals("WET")){
                            friends.add("ID:"+aircondsList.getID() + "\n"+"Alias: "+aircondsList.getAlias()+"\n"+" Status: " + aircondsList.getStatus()+ "\n"+" Mode: " + aircondsList.getMode()+ "\n"+" Temperature: "+aircondsList.getTemperature());
                            list.add(new ArrayListOfAC(aircondsList.getID(),aircondsList.getStatus(),aircondsList.getMode(),aircondsList.getFan_speed(),aircondsList.getTemperature(),aircondsList.getSize(),aircondsList.getAlias()));

                        }
                        else {
                            friends.add("ID:" + aircondsList.getID() +"\n"+"Alias: "+aircondsList.getAlias()+ "\n" + " Status: " + aircondsList.getStatus() + "\n" + " Mode: " + aircondsList.getMode() + "\n" + " Temperature: " + aircondsList.getTemperature() + "\n" + " Fan Speed: " + aircondsList.getFan_speed());
                            list.add(new ArrayListOfAC(aircondsList.getID(),aircondsList.getStatus(),aircondsList.getMode(),aircondsList.getFan_speed(),aircondsList.getTemperature(),aircondsList.getSize(),aircondsList.getAlias()));

                        }
                    }


                    System.out.println("List: ");
                    System.out.println(aircondsList.getFan_speed());
                    System.out.println(aircondsList.getMode());
                    System.out.println(aircondsList.getStatus());
                    System.out.println(aircondsList.getTemperature());
                    System.out.println(aircondsList.getID());
                    System.out.println(aircondsList.getAlias());

                }

                ArrayAdapter arrayAdapter = new ArrayAdapter(ListOfACActivity.this, android.R.layout.simple_list_item_1,
                        friends);

                listView.setAdapter(arrayAdapter);


            }



            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
        listView.setOnItemClickListener(this);

    }


    @Override
    protected void onStart() {
        Logout = (Button) findViewById(R.id.button_logout);

        super.onStart();

        Logout.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent intent = new Intent (ListOfACActivity.this, MainActivity.class);
                startActivity(intent);
            }
        });
        //String currentDateTimeString = DateFormat.getDateTimeInstance().format(new Date());

        CountDownTimer newtimer = new CountDownTimer(1000000000, 1000) {

            public void onTick(long millisUntilFinished) {
                Calendar c = Calendar.getInstance();
            }
            public void onFinish() {

            }
        };
        newtimer.start();


            }


    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        final ListView listView = (ListView) findViewById(R.id.listView);
        Toast.makeText(getApplicationContext(), ((TextView) view).getText(),
                Toast.LENGTH_SHORT).show();
        System.out.println(list.get(i).getStatus());
        Intent activity = new Intent(getApplicationContext(), SendSignalActivity.class);
        activity.putExtra("Status", list.get(i).getStatus());
        activity.putExtra("Mode", list.get(i).getMode());
        activity.putExtra("ID", list.get(i).getID());
        activity.putExtra("Temperature", list.get(i).getTemperature());
        activity.putExtra("Fan Speed",list.get(i).getFan_speed());
        activity.putExtra("Alias", list.get(i).getAlias());
        startActivity(activity);

       // Log.i("HelloListView", "Your listview values are: "+listView.getChildAt(i).toString());
        // Then you start a new Activity via Intent

    }
}

