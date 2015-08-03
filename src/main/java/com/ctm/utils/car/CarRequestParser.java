package com.ctm.utils.car;

import com.ctm.model.request.Person;
import com.ctm.model.request.car.CarRequest;
import com.ctm.model.request.car.Driver;
import com.disc_au.web.go.Data;

/**
 * Created by voba on 6/07/2015.
 */
public class CarRequestParser {
    public static CarRequest parseRequest(Data data) {
        CarRequest carRequest = new CarRequest();
        Driver driver = new Driver();
        Person person = new Person();
        person.firstname = data.getString("quote/drivers/regular/firstname");
        person.surname = data.getString("quote/drivers/regular/surname");

        driver.setRegular(person);
        carRequest.setDrivers(driver);

        return carRequest;
    }
}
