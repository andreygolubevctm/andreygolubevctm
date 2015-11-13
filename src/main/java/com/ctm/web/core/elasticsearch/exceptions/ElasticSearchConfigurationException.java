package com.ctm.web.core.elasticsearch.exceptions;

public class ElasticSearchConfigurationException extends Exception {

	private static final long serialVersionUID = 8394811600414723612L;
	private String description;

	public ElasticSearchConfigurationException(String message , Exception e) {
		super(message, e);
	}

	public ElasticSearchConfigurationException(String message) {
		super(message);
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}
	
}
