package com.ctm.web.life.apply.response;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class SelectionTest {

    @Test
    public void testGetPartner() throws Exception {
        SelectDetails partner = new SelectDetails.Builder().build();
        Selection selection = new Selection.Builder().partner(partner).build();
        assertEquals(partner, selection.getPartner());

    }

    @Test
    public void testGetClient() throws Exception {
        SelectDetails client = new SelectDetails.Builder().build();
        Selection selection = new Selection.Builder().client(client).build();
        assertEquals(client, selection.getClient());
    }
}