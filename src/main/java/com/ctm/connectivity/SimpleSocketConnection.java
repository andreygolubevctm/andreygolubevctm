package com.ctm.connectivity;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.Socket;
import java.util.ArrayList;

import static com.ctm.logging.LoggingArguments.kv;


public class SimpleSocketConnection {

	private static final Logger logger = LoggerFactory.getLogger(SimpleSocketConnection.class);

	private String address;
	private int port;
	private String uri;

	public SimpleSocketConnection(String address, int port, String uri){
		setAddress(address);
		setPort(port);
		setUri(uri);
	}

	public String get(String request, String[] additionalHeaders){

		Socket socket = null;
		String response = null;

		try{

			socket = new Socket(getAddress(), getPort());

			BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"), 200000);

			wr.write("POST http://"+getAddress()+":"+getPort()+getUri()+" HTTP/1.0" + "\r\n");
			wr.write("Host: "+getAddress()+":"+getPort()+ "\r\n");
			wr.write("Content-Length: " + request.length()  + "\r\n");
			wr.write("Content-Type: text/xml;charset=UTF-8" + "\r\n");
			for(String additionalHeader: additionalHeaders){
				wr.write(additionalHeader + "\r\n");
			}
			wr.write("\r\n");
			wr.write(request);
			wr.flush();

			BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream()));

			ArrayList<String> lines = new ArrayList<String>();
			String line;
			while ((line = rd.readLine()) != null) {
				lines.add(line);
			}

			response = lines.get(lines.size()-1);
			logger.trace("Socket response {}", kv("response", response));
			wr.close();

		}catch(Exception e){
			logger.error("Error making socket get request {},{}", kv("address", address), kv("port", port), kv("uri", uri),
				kv("request", request), kv("additionalHeaders", additionalHeaders));
		}finally{

			try {
				socket.close();
			} catch (IOException e) {
				logger.error("Failed closing socket connection", e);
			}

			logger.debug("Socket Disconnected {}", kv("socket", socket));
		}

		return response;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public String getUri() {
		return uri;
	}

	public void setUri(String uri) {
		this.uri = uri;
	}


}
