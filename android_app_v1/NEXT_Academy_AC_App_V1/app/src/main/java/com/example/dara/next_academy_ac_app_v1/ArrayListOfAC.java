package com.example.dara.next_academy_ac_app_v1;

import java.io.Serializable;
import java.util.HashMap;

/**
 * Created by Dara on 23/01/2017.
 */

public class ArrayListOfAC implements Serializable {
    private String ID;
    private String status;
    private String mode;
    private String fan_speed;
    private String temperature;
    private String size;
    private String alias;

    public  ArrayListOfAC(){

    }
    public  ArrayListOfAC(String ID, String status, String mode, String fan_speed, String temperature, String size, String alias){
        this.ID = ID;
        this.status = status;
        this.mode = mode;
        this.fan_speed = fan_speed;
        this.temperature = temperature;
        this.size = size;
        this.alias = alias;
    }



    public String getTemperature() {
        return temperature;
    }

    public void setTemperature(String temperature) {
        this.temperature = temperature;
    }

    public String getFan_speed() {
        return fan_speed;
    }

    public void setFan_speed(String fan_speed) {
        this.fan_speed = fan_speed;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }
    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public HashMap<String,String> toFirebaseObject() {
        HashMap<String,String> todo =  new HashMap<String,String>();

        todo.put("airconds", ID);
        todo.put("status", status);
        todo.put("mode", mode);
        todo.put("fan_speed", fan_speed);
        todo.put("temperature",temperature);
        todo.put("size", size);
        todo.put("alias",alias);
        return todo;
    }



}
