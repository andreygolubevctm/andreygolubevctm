package com.ctm.web.lifebroker.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import org.json.XML;

/**
 * Created by msmerdon on 04/12/2017.
 */
@JsonAutoDetect(fieldVisibility= JsonAutoDetect.Visibility.ANY)
public class LifebrokerResponse {

    private boolean success;
    private String message;
	private String client_reference;

	public LifebrokerResponse() {}

    public LifebrokerResponse(final boolean success, final String message, final String client_reference) {
        this.success = success;
        this.message = message;
        this.client_reference = client_reference;
    }

	public LifebrokerResponse(final String client_reference) {
		this.success = true;
		this.message = null;
		this.client_reference = client_reference;
	}

	public LifebrokerResponse(final boolean success, final String message) {
		this.success = success;
		this.message = message;
		this.client_reference = null;
	}

	public void setSuccess(final boolean success) {
		this.success = success;
	}

	public void setMessage(final String message) {
		this.message = message;
	}

	public void setClientReference(final String client_reference) {
		this.client_reference = client_reference;
	}
}
