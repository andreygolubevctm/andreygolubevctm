package com.ctm.web.car.utils;

import com.ctm.web.core.model.request.Person;
import com.ctm.web.car.model.request.CarRequest;
import com.ctm.web.car.model.request.Driver;
import com.ctm.web.core.web.go.Data;

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
