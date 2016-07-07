package com.ctm.web.life.apply.response;

import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class SelectDetailsTest {

    private String pds = "pds";
    private String url = "url";

    @Test
    public void testGetPds() throws Exception {
        SelectDetails details= new SelectDetails.Builder().pds(pds).build();
        assertEquals(pds, details.getPds());
    }

    @Test
    public void testGetInfo_url() throws Exception {
        SelectDetails details= new SelectDetails.Builder().infoUrl(url).build();
        assertEquals(url, details.getInfo_url());
    }
}