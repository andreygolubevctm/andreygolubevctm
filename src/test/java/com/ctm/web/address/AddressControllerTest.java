package com.ctm.web.address;

import com.ctm.web.address.services.AddressService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.address.model.Address;
import com.ctm.web.address.model.AddressSuburb;
import com.ctm.web.address.model.AddressSuburbRequest;

import org.junit.Before;
import org.junit.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.Assert.assertEquals;

public class AddressControllerTest {
    private AddressService addressService;

    @Before
    public void setup(){
      addressService = new AddressService();
      ReflectionTestUtils.setField(addressService, "url", "https://dev.comparethemarket.com.au/api/address");
    }

    @Test
    public void testGetSuburbsEmpty() throws Exception {
      Address[] suburbs = addressService.getSuburbs("0000");
      assertEquals(1 , suburbs.length);
    }

    @Test
    public void testGetSuburbs() throws Exception {
        Address[] suburbs = addressService.getSuburbs("4066");
      assertEquals(5 , suburbs.length);
    }

    @Test
    public void testGetMultipleAddress() throws Exception {
      AddressSuburbRequest request = new AddressSuburbRequest("80 Jephson St, Toowong QLD 4066", "4066");
        AddressSuburb[] suburbs = addressService.getStreet(request);
      assertEquals(1 , suburbs.length);
    }

    @Test
    public void testGetAddress() throws Exception {
        AddressSuburbRequest request = new AddressSuburbRequest("19 William St, Rosewood QLD 4340", "4340");
        AddressSuburb[] suburbs = addressService.getStreet(request);
        assertEquals(1 , suburbs.length);
    }


}