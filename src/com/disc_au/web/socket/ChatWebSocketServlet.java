package com.disc_au.web.socket;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.catalina.websocket.StreamInbound;
import org.apache.catalina.websocket.WebSocketServlet;

public class ChatWebSocketServlet extends WebSocketServlet {
	private static final long serialVersionUID = 1L;

	private final String POLLING_INTERVAL_SECONDS = "polling_secs";

	private int pollingSecs = 1;

	@Override
	public void init() throws ServletException {
		super.init();

		try {
			this.pollingSecs = Integer.valueOf(this.getInitParameter(POLLING_INTERVAL_SECONDS));
		} catch (Exception e){};

	}


	@Override
	protected StreamInbound createWebSocketInbound(String arg0, HttpServletRequest arg1) {
		return new ChatStreamInbound(pollingSecs);
	}

}
