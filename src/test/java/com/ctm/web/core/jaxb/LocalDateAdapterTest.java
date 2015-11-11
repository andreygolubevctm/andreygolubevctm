package com.ctm.web.core.jaxb;

import org.joda.time.LocalDate;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class LocalDateAdapterTest {

    @Test
    public void unmarshal() throws Exception {
        LocalDateAdapter adapter = new LocalDateAdapter();
        assertEquals(new LocalDate(2014, 11, 6), adapter.unmarshal("2014-11-06"));
        assertEquals(new LocalDate(2000, 1, 1), adapter.unmarshal("2000-01-01"));
    }

    @Test
    public void marshal() throws Exception {
        LocalDateAdapter adapter = new LocalDateAdapter();
        assertEquals("2014-11-06", adapter.marshal(new LocalDate(2014, 11, 6)));
        assertEquals("2000-01-01", adapter.marshal(new LocalDate(2000, 1, 1)));
    }
}