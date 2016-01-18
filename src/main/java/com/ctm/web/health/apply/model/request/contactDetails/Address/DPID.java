package com.ctm.web.health.apply.model.request.contactDetails.Address;

import java.util.function.Supplier;

/**
 * Digital Postal ID. This is the barcode used by AusPost
 */
public class DPID implements Supplier<String> {

    private final String dpid;

    public DPID(String dpid) {
        this.dpid = dpid;
    }

    @Override
    public String get() {
        return dpid;
    }
}