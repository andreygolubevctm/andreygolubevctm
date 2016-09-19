package com.ctm.web.core.jaxb;

import org.joda.time.LocalDateTime;

import javax.xml.bind.annotation.adapters.XmlAdapter;

public class LocalDateTimeAdapter extends XmlAdapter<String, LocalDateTime> {

    @Override
    public LocalDateTime unmarshal(final String s) throws Exception {
        return LocalDateTime.parse(s);
    }

    @Override
    public String marshal(final LocalDateTime localDateTime) throws Exception {
        return localDateTime.toString();
    }
}