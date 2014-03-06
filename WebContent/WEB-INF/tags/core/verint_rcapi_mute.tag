<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag import="java.net.Socket,java.io.*" %>
<%@ tag description="This uses the Verint RCAPI service to talk to the phone system. Note this can affect compliance greatly."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="audio" 		required="true"		rtexprvalue="true"	description="The audio action: 1 for mute OR 0 for resume recording"%>
<%@ attribute name="extension" 	required="true"		rtexprvalue="true"	description="The operator's phone extension: ####"%>
<%@ attribute name="machine" 	required="true"		rtexprvalue="true"	description="The Verint system's IP address/host" %>
<%@ attribute name="port" 		required="true"		rtexprvalue="true"	description="The Verint system's port address"%>

<c:set var="machinePort" value="${machine}:${port}" scope="request" />

<%-- THIS IS THE SYSTEM to TURN ON/OFF Recording --%>
<c:catch var="socketError">
	<%
		//Connect the socket details
		machine = machine.toString();
		String portString = port;
		int port = Integer.parseInt(portString);
		/*
		System.out.println(port);
		System.out.println(machine);
		System.out.println(audio);
		System.out.println(extension);
		System.out.println("Socket Connecting to: " + machine + ":" + port);
		*/
	%>
	<%! Socket socket; %>
	<%
		socket = new Socket(machine, port);
		System.out.println("Socket Connected: " + socket);
	%>
</c:catch>

<%-- Socket Test --%>
<c:choose>
	<c:when test="${not empty socketError}">
		<c:set var="error" scope="request" value="${socketError}" />
		<%  response.sendError(412, "Could not connect to the socket: " + request.getAttribute("error") ); if(true) return; %>
	</c:when>
	<c:otherwise>
		<c:catch var="soapError">
		<c:set var="xmlResponse">
		<%
			String xmlData = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ilap=\"http://ps.verint/ilApi\" xmlns:arr=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\">"
							+"<soapenv:Header/>"
							+"<soapenv:Body>"
								+"<ilap:RCAPI_AudioMute>"
									+"<!--Optional:-->"
									+"<ilap:switchNum>2</ilap:switchNum>"
									+"<!--Optional:-->"
									+"<ilap:extension>" + extension + "</ilap:extension>"
									+"<!--Optional:-->"
									+"<ilap:mute>" + audio + "</ilap:mute>"
									+"<!--Optional:-->"
									+"<ilap:data>"
									+" <!--Zero or more repetitions:-->"
										+"<arr:KeyValueOfstringstring>"
										+"<arr:Key></arr:Key>"
										+"<arr:Value></arr:Value>"
										+"</arr:KeyValueOfstringstring>"
									+"</ilap:data>"
								+"</ilap:RCAPI_AudioMute>"
							+"</soapenv:Body>"
				+"</soapenv:Envelope>";

				BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"), 200000 );

				/* SEND HEADER and CONTENT */
				wr.write("POST http://" + request.getAttribute("machinePort") + "/Services/PSIntellilinkBasic HTTP/1.0" + "\r\n");
				wr.write("Host: " + request.getAttribute("machinePort") + "\r\n");
				wr.write("Content-Length: " + xmlData.length()  + "\r\n");
				wr.write("Content-Type: text/xml;charset=UTF-8" + "\r\n");
				//wr.write("Accept-Encoding: gzip,deflate" + "\r\n");
				wr.write("SOAPAction: \"http://ps.verint/ilApi/I_Intellilink/RCAPI_AudioMute\"" + "\r\n");
				//wr.write("Connection: Keep-Alive" + "\r\n");
				wr.write("\r\n");
				wr.write(xmlData);
				wr.flush();

				/* Capture the Response and send to the browser */
				BufferedReader rd = new BufferedReader(new InputStreamReader(socket.getInputStream()));
				String line;
				while ((line = rd.readLine()) != null) {
					/*
					System.out.println("Response :"+line);
					*/
					%><%= line%><%
				}

				wr.close();
		%>
		</c:set>
		</c:catch>
		<c:catch var="socketClose">
			<%
				socket.close();
				System.out.println("Socket Disconnected: " + socket);
			%>
		</c:catch>

		<%-- Deliver the packet message --%>
		<c:choose>
			<c:when test="${not empty packetError}">
				<c:set var="error" scope="request" value="${packetError}" />
				<%  response.sendError(412, "Packet was not successfully delivered and returned: " + request.getAttribute("error") ); if(true) return; %>
			</c:when>
			<%-- Interpret the message for success or not --%>
			<c:otherwise>
				<c:choose>
					<c:when test="${fn:containsIgnoreCase(xmlResponse, 'Failed')}">
						<c:set var="message" value="${fn:substringBefore(xmlResponse,'</RCAPI_AudioMuteResult>')}"/>
						<c:set var="message" scope="request" value="${fn:substringAfter(message,'<RCAPI_AudioMuteResult>')}"/>
						<%  response.sendError(405, "The action failed: " + request.getAttribute("message")); if(true) return; %>
					</c:when>
					<c:otherwise>
						<?xml version="1.0" encoding="UTF-8"?>
						<response>${xmlResponse}</response>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>

	</c:otherwise>
</c:choose>