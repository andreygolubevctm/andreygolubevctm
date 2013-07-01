package com.disc_au.web.socket;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.nio.CharBuffer;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.apache.catalina.websocket.StreamInbound;
import org.apache.catalina.websocket.WsOutbound;
import org.eclipse.jdt.internal.compiler.ast.ThisReference;

import com.disc_au.web.go.Gadget;

public class ChatStreamInbound extends StreamInbound {
	private static String FLASH_POLICY_REQUEST = "<policy-file-request/>";
	private static String DEFAULT_FLASH_POLICY_RESPONSE = "<cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\" /></cross-domain-policy>";

	private WsOutbound outbound;
	private int pollingSecs;
	private String flashPolicyResponse;

	public ChatStreamInbound(int pollingSecs) {
		this(pollingSecs, null);
	}
	public ChatStreamInbound(int pollingSecs,String flashPolicyResponse) {
		this.pollingSecs = pollingSecs;
		if (flashPolicyResponse != null){
			this.flashPolicyResponse = flashPolicyResponse;
		} else {
			this.flashPolicyResponse = DEFAULT_FLASH_POLICY_RESPONSE;
		}
	}


	@Override
	protected void onOpen(WsOutbound outbound) {
		super.onOpen(outbound);

		this.outbound = outbound;

		System.out.println("Socket Opened!!");
	}


	@Override

	protected void onClose(int status) {
		super.onClose(status);

		System.out.println("Socket Closed!! Status is "+status);

	}

	@Override
	protected void onBinaryData(InputStream i) throws IOException {
		// Do nothing
	}

	@Override
	protected void onTextData(Reader r) throws IOException {
		System.out.println("On Text Data");
		String resp;
		StringBuffer sb = new StringBuffer();
		BufferedReader br = new BufferedReader(r);
		JSONObject obj = new JSONObject();

		JSONParser parser = new JSONParser();

		int c;
		while ((c = br.read()) != -1) {
			sb.append((char) c);
		}

		String req = sb.toString();

		// Handle Flash policy requests
		if (req.equals(FLASH_POLICY_REQUEST)){
			resp = flashPolicyResponse;
		} else {

			try {

				String x = Gadget.JSONtoXML(req);
				System.out.println(x);
				Object jsonReq = parser.parse(req);
				JSONObject jsonObject = (JSONObject) jsonReq;

				// Handle the events sent to us and process them accordingly
				String event =  (String) jsonObject.get("event");

				switch (event) {
					case "connect":
						// Here we'll get previous transcript from a chat ID
						String chat_id = (String) jsonObject.get("chat_id");
						System.out.println("Client connected. Chat ID: " + chat_id);

						this.send(obj);

						obj.put("event", "consultants");
						obj.put("total", this.getAvailableConsultants());
						this.send(obj);
						break;

					case "message":
						// Store the message data on the iSeries
						obj.put("message", "You said: " + (String) jsonObject.get("message") );
						obj.put("event", "message");

						this.send(obj);
						break;

					case "endSession":
						System.out.println("User terminated session");
						break;

					default:
						break;
				}

			}
			catch (ParseException e) {
				e.printStackTrace();
			}
		}

	}

	protected int getAvailableConsultants() throws IOException {
		return 4;
	}

	protected char loadTranscript() throws IOException {
		return 'a';
	}

	protected void send(JSONObject obj) throws IOException {
		String resp = obj.toJSONString();

		this.outbound.writeTextMessage(CharBuffer.wrap(resp));
	}

}
