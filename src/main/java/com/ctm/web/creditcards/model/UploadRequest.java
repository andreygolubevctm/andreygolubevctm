package com.ctm.web.creditcards.model;

import java.io.InputStream;

public class UploadRequest {

	public boolean success = false;
	public String providerCode;
	public String effectiveDate = "";
	public String jira;
	public String fileName;
	public InputStream uploadedStream = null;
	public String deleteId;
}
