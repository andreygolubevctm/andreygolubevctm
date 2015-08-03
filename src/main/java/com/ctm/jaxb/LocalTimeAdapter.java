package com.ctm.jaxb;

import org.joda.time.LocalTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class LocalTimeAdapter extends XmlAdapter<String, LocalTime>{
    private final DateTimeFormatter formatter = DateTimeFormat.forPattern("HH:mm:ss");

    @Override
    public LocalTime unmarshal(final String s) throws Exception {
        return new LocalTime(s);
    }

    @Override
    public String marshal(final LocalTime localTime) throws Exception {
        return localTime.toString(formatter);
    }
}
