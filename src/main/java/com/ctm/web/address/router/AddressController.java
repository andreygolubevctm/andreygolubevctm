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

    @RequestMapping(value = "/streetsuburb/get.json",
                    method = RequestMethod.GET,
                    produces = MediaType.APPLICATION_JSON_VALUE)
    public AddressSuburb[] getStreetSuburb(HttpServletRequest request) {
        String addressLine = request.getParameter("addressLine");
        String postCodeOrSuburb = request.getParameter("postCodeOrSuburb");
        AddressSuburbRequest addressSuburbRequest = new AddressSuburbRequest(addressLine, postCodeOrSuburb);

        return addressService.getStreetSuburb(addressSuburbRequest);
    }
}
