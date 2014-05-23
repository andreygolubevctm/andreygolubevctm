package com.disc_au.web.go;

import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;

import java.util.Hashtable;

import com.ctm.data.PageSettings;
import com.disc_au.web.ISeriesConfig;

public class ISeriesConnection {

	private static Logger logger = Logger.getLogger(ISeriesConnection.class.getName());

	private String iSeries = null;
	private int port = -1;

	public ISeriesConnection(PageContext pageContext) {

		//-----------------
		// Attempt to retrieve iSeries connection information from relevant server environment variable
		Hashtable<String, String> envConn = null;
		try {
			// style and feature parameters removed from the following call because it appeared that we never sent anything !?!??!?
			envConn = ISeriesConfig.getEnvironmentConfig(pageContext.getRequest().getServletContext());
			if ( envConn != null ) {
				this.iSeries = envConn.get("serverName");
				this.port = Integer.parseInt(envConn.get("serverPort"));
				System.out.println("CallD3TTag doEndTag: iSeries environment details for  / result: " + envConn + " / using server " + this.iSeries + ", port " + this.port);
			}
		} catch (Exception e) {
			logger.debug("Caught trying to get iSeries variables on environment");
		}



		//----------

		// If we couldn't get the value from the server settings, then fall back to DB settings.
		if(this.iSeries == null || this.port == -1){
		// Attempt to fetch the iSeries from the page's settings
		PageSettings pageSettings = (PageSettings) pageContext.getAttribute("pageSettings", PageContext.REQUEST_SCOPE);
		if(pageSettings != null) {
			try {
				this.iSeries = pageSettings.getSetting("iSeriesName");
				this.port = Integer.parseInt(pageSettings.getSetting("iSeriesPort"));
					logger.debug("Loaded iseries and port from DB settings");
			} catch (Exception e) {
				logger.error("failed to get iSeries connection details" , e);
			}
		} else {
			logger.error("page settings are not set" );
		}
	}




	}

	public String getISeries() {
		return this.iSeries;
	}

	public int getPort() {
		return this.port;
	}

}
