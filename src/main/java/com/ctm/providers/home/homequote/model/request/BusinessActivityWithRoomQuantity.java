package com.ctm.providers.home.homequote.model.request;

public class BusinessActivityWithRoomQuantity extends BusinessActivity {

    private int roomsUsed;

    private Integer numberOfEmployees;

    public int getRoomsUsed() {
        return roomsUsed;
    }

    public void setRoomsUsed(int roomsUsed) {
        this.roomsUsed = roomsUsed;
    }

    public Integer getNumberOfEmployees() {
        return numberOfEmployees;
    }

    public void setNumberOfEmployees(Integer numberOfEmployees) {
        this.numberOfEmployees = numberOfEmployees;
    }
}
