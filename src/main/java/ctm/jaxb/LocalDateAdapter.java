package com.ctm.jaxb;

import org.joda.time.LocalDate;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class LocalDateAdapter extends XmlAdapter<String, LocalDate> {

    @Override
    public LocalDate unmarshal(final String s) throws Exception {
        return new LocalDate(s);
    }

    @Override
    public String marshal(final LocalDate localDate) throws Exception {
        return localDate.toString();
    }
}
