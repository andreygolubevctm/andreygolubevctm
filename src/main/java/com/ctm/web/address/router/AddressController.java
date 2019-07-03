package com.ctm.web.address.router;

import com.ctm.web.address.model.Address;
import com.ctm.web.address.model.AddressSuburb;
import com.ctm.web.address.model.AddressSuburbRequest;
import com.ctm.web.address.services.AddressService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/rest/address")
public class AddressController {
    private static final Logger LOGGER = LoggerFactory.getLogger(AddressController.class);

    @Autowired
    private AddressService addressService;

    @RequestMapping(value = "/suburbs/get.json",
                    method = RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public Address[] getSuburbs(HttpServletRequest request) {
        String postcode = request.getParameter("postCode");
        return addressService.getSuburbs(postcode);
    }

    @RequestMapping(value = "/suburbsflat/get.json",
                    method = RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public String[] getSuburbsFlatArray(HttpServletRequest request) {
        String postcode = request.getParameter("postCode");
        Address[] suburbs = addressService.getSuburbs(postcode);

        ArrayList<String> flatSuburbs = new ArrayList<String>();
        for(Integer i = 0; i < suburbs.length; i++) {
            Address suburb = suburbs[i];
            flatSuburbs.add(suburb.getSuburb() + " " + suburb.getPostCode() + " " + suburb.getState());
        }

        String[] flatSuburbsArr = new String[flatSuburbs.size()];
        flatSuburbsArr = flatSuburbs.toArray(flatSuburbsArr);

        return flatSuburbsArr;
    }

    @RequestMapping(value = "/streetsuburb/get.json",
                    method = RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public AddressSuburb[] getStreetSuburb(HttpServletRequest request) {
        String addressLine = request.getParameter("addressLine");
        String postCodeOrSuburb = request.getParameter("postCodeOrSuburb");
        AddressSuburbRequest addressSuburbRequest = new AddressSuburbRequest(addressLine, postCodeOrSuburb);

        return addressService.getStreetSuburb(addressSuburbRequest);
    }

        @RequestMapping(value = "/street/get.json",
                    method = RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public AddressSuburb[] getStreet(HttpServletRequest request) {
        String addressLine = request.getParameter("addressLine");
        String postCodeOrSuburb = request.getParameter("postCodeOrSuburb");
        AddressSuburbRequest addressSuburbRequest = new AddressSuburbRequest(addressLine, postCodeOrSuburb);

        return addressService.getStreet(addressSuburbRequest);
    }
}
