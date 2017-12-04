package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import org.json.XML;

/**
 * Created by msmerdon on 04/12/2017.
 */
@JsonAutoDetect(fieldVisibility= JsonAutoDetect.Visibility.ANY)
public class LifebrokerLead {

    private String affiliate_id;
    private String email;
    private String phone;
    private String postcode;
    private LifebrokerLeadClient client;
    private LifebrokerLeadMediaCode additional;
    private String call_time;

    public LifebrokerLead(String affiliate_id, String email, String phone, String postcode, String name, String call_time) {
        this.affiliate_id = affiliate_id;
        this.email = email;
        this.phone = phone;
        this.postcode = postcode;
        this.client = new LifebrokerLeadClient(name);
        this.additional = new LifebrokerLeadMediaCode();
        this.call_time = call_time;
    }

	public String get() throws Exception {
		return XML.toString(this);
	}
}
