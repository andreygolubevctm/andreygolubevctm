package com.ctm.web.core.jaxb;

import org.joda.time.LocalTime;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class LocalTimeAdapterTest {

    @Test
    public void unmarshal() throws Exception {
        LocalTimeAdapter adapter = new LocalTimeAdapter();
        assertEquals(new LocalTime(11, 29, 44), adapter.unmarshal("11:29:44"));
        assertEquals(new LocalTime(13, 51, 12), adapter.unmarshal("13:51:12"));
    }

    @Test
    public void marshal() throws Exception {
        LocalTimeAdapter adapter = new LocalTimeAdapter();
        assertEquals("11:29:44", adapter.marshal(new LocalTime(11, 29, 44)));
        assertEquals("13:51:12", adapter.marshal(new LocalTime(13, 51, 12, 300)));
    }
}