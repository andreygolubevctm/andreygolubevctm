<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag import="java.net.Socket,java.io.*" %>
<%@ tag description="This uses the Verint RCAPI service to talk to the phone system to retrieve an extension. The function returns an http error or a #### number"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<c:set var="logger" value="${log:getLogger('tag:core.verint_rcapi_extension')}" />

<%-- ATTRIBUTES --%>
<%@ attribute name="agentId" 	required="true"		rtexprvalue="true"	description="The agent ID, typically a four digit code"%>
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
		${logger.error('SocketError', socketError)}
		<c:set var="error" scope="request" value="${socketError}" />
		<%  response.sendError(412, "Could not connect to the socket: " + request.getAttribute("error") ); if(true) return; %>
	</c:when>
	<c:otherwise>
		<c:catch var="soapError">
		<c:set var="xmlResponse">
		<%
			String xmlData = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ilap=\"http://ps.verint/ilApi\">"
					+"<soapenv:Header/>"
					+"<soapenv:Body>"
						+"<ilap:GetExtensionByAgentId>"
							+"<!--Optional:-->"
							+"<ilap:switchNum>2</ilap:switchNum>"
							+"<!--Optional:-->"
							+"<ilap:agentID>" + agentId + "</ilap:agentID>"
						+"</ilap:GetExtensionByAgentId>"
					+"</soapenv:Body>"
					+"</soapenv:Envelope>";

				BufferedWriter wr = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"), 200000 );

				/* SEND HEADER and CONTENT */
				wr.write("POST http://192.168.1.22:8778/Services/PSIntellilinkBasic HTTP/1.0" + "\r\n");
				wr.write("Host: 192.168.1.22:8778" + "\r\n");
				wr.write("Content-Length: " + xmlData.length()  + "\r\n");
				wr.write("Content-Type: text/xml;charset=UTF-8" + "\r\n");
				//wr.write("Accept-Encoding: gzip,deflate" + "\r\n");
				wr.write("SOAPAction: \"http://ps.verint/ilApi/I_Intellilink/GetExtensionByAgentId\"" + "\r\n");
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
			<c:when test="${not empty soapError}">
				<c:set var="error" scope="request" value="${soapError}" />
				<%  response.sendError(412, "Packet was not successfully delivered and returned: " + request.getAttribute("error") ); if(true) return; %>
			</c:when>
			<%-- Interpret the message for success or not --%>
			<c:otherwise>
				<c:choose>
					<c:when test="${fn:containsIgnoreCase(xmlResponse, '<extension/>')}">
						<% response.sendError(405, "No extension was returned: blank"); if(true) return; %>
					</c:when>
					<c:otherwise>
						<%-- Return only the telphone extension --%>
						<c:set var="response" value="${fn:substringAfter(xmlResponse, '<extension>') }"/>
						<c:set var="response" value="${fn:substringBefore(response, '</extension>') }"/>
						${response}
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>

	</c:otherwise>
</c:choose>