package com.disc_au.web.go;

import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;

import com.ctm.data.PageSettings;
import com.disc_au.web.go.tags.CallD3TTag;

public class ISeriesConnection {

	private static Logger logger = Logger.getLogger(ISeriesConnection.class.getName());

	private String iSeries;
	private int port;

	public ISeriesConnection(PageContext pageContext) {
		// Attempt to fetch the iSeries from the page's settings
		PageSettings pageSettings = (PageSettings) pageContext.getAttribute("pageSettings", PageContext.REQUEST_SCOPE);
		if(pageSettings != null) {
			try {
				this.iSeries = pageSettings.getSetting("iSeriesName");
				this.port = Integer.parseInt(pageSettings.getSetting("iSeriesPort"));
			} catch (Exception e) {
				logger.error("failed to get iSeries connection details" , e);
			}
		} else {
			logger.error("page settings are not set" );
		}
	}

	public String getISeries() {
		return this.iSeries;
	}

	public int getPort() {
		return this.port;
	}

}
