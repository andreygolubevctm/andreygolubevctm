package com.disc_au.web.go.bridge;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.disc_au.web.go.bridge.messages.Message;

/**
 * The Class Bridge.
 *
 * @author aransom
 * @version 1.0
 */

public class Bridge {

	private static final Logger logger = LoggerFactory.getLogger(Bridge.class.getName());

	/** The Constant CONF_LEN. */
	static final int CONF_LEN = 12;

	/** The Constant BUFFER_SIZE. */
	static final int BUFFER_SIZE = 500;

	/** The Constant TIMEOUT. */
	static final int TIMEOUT = 10000;

	/** The Constant LOG_LEVEL_MINIMAL. */
	public static final int LOG_LEVEL_MINIMAL = 0;

	/** The Constant LOG_LEVEL_VERBOSE. */
	public static final int LOG_LEVEL_VERBOSE = 1;

	/** The server. */
	String server;

	/** The port. */
	int port;

	/** The log level. */
	int logLevel = LOG_LEVEL_MINIMAL;

	/**
	 * Instantiates a new bridge.
	 *
	 * @param server the server
	 * @param port the port
	 */
	public Bridge(String server, int port) {
		this.server = server;
		this.port = port;
	}

	/**
	 * Gets the port.
	 *
	 * @return the port
	 */
	public int getPort() {
		return port;
	}

	/**
	 * Gets the server.
	 *
	 * @return the server
	 */
	public String getServer() {
		return server;
	}

	/**
	 * Send receive.
	 *
	 * @param req the req
	 * @return the message
	 */
	public Message sendReceive(Message req) throws IOException {

		InputStream in = null;
		OutputStream out = null;
		Message resp = null;
		Socket socket = null;
		try {
			logger.debug("Connecting to " + server + " " + port);
			socket = new Socket(server, port);

			int len = req.getLength();
			NumericField reqLength = new NumericField(CONF_LEN, 's', 0);
			reqLength.setValue(req.getLength() + CONF_LEN);
			// Send the request
			out = socket.getOutputStream();
			out.write(reqLength.getBytes());
			out.write(req.getBytes(), 0, len);
			out.flush();

			// Read the length of the result
			in = socket.getInputStream();

			byte[] reqLengthBytes = new byte[reqLength.getLength()];
			in.read(reqLengthBytes);
			reqLength.setBytes(reqLengthBytes);

			int responseLength = reqLength.getValue();

			if (responseLength > 0) {

				int remainingData = responseLength - CONF_LEN;
				byte[] buffer = new byte[remainingData];
				int pos = 0;

				// Set a timeout .. just in case
				long timeout = System.currentTimeMillis() + TIMEOUT;

				while (pos < remainingData
						&& System.currentTimeMillis() < timeout) {
					int toRead = remainingData - pos;
					int readBytes = in.read(buffer, pos, toRead);
					pos += readBytes;
				}

				// Create a Message to hold the result
				resp = new Message(req.getHeader(), "");

				resp.setBytes(buffer);

				NumericField confirmationLength = new NumericField(CONF_LEN,
						's', 0);
				confirmationLength.setValue(remainingData + CONF_LEN);
				out.write(confirmationLength.getBytes());
				out.flush();
			}


			return resp;
		} finally {
			if(in != null){
				in.close();
			}
			if(out != null){
				out.close();
			}
			if(socket != null){
				socket.close();
			}
		}
	}

	/**
	 * Sets the port.
	 *
	 * @param port the new port
	 */
	public void setPort(int port) {
		this.port = port;
	}

	/**
	 * Sets the server.
	 *
	 * @param server the new server
	 */
	public void setServer(String server) {
		this.server = server;
	}
}
