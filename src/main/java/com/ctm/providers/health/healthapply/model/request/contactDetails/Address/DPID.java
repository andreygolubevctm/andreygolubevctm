package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.ctm.interfaces.common.types.ValueType;

/**
 * Digital Postal ID. This is the barcode used by AusPost
 */
public class DPID extends ValueType<String> {

    private DPID(final String value) {
        super(value);
    }

    public static DPID instanceOf(final String value) {
        return new DPID(value);
    }

}