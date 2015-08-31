<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag import="java.net.Socket,java.io.*" %>
<%@ tag description="This uses the Verint RCAPI service to talk to the phone system. Note this can affect compliance greatly."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${go:getLogger('verint_rcapi_mute_jsp')}" />

<%-- ATTRIBUTES --%>
<%@ attribute name="action" 		required="true"		rtexprvalue="true"	description="The recorder action: PauseRecord or ResumeRecord"%>
<%@ attribute name="agentId" 		required="true"		rtexprvalue="true"	description="The operator's agentId: ####"%>
<%@ attribute name="contentType"	required="true"		rtexprvalue="true"	description="The ContentType: Audio, Video, AudioVideo" %>

<settings:setVertical verticalCode="HEALTH" />

<%
	response.setContentType("text/plain");
	response.setCharacterEncoding("UTF-8");
%>
${logger.info('action: {}', action)}
<%-- THIS IS THE SYSTEM to TURN ON/OFF Recording --%>
<c:catch var="packetError">
	<c:set var="xmlResponse" value="${phoneService.pauseResumeRecording(pageSettings, agentId, contentType, action)}" />
</c:catch>

<%-- Deliver the packet message --%>
<c:choose>
	<c:when test="${not empty packetError}">
		<c:set var="error" scope="request" value="${packetError}" />
		<%
			response.setStatus(412);
			response.getWriter().write("Packet was not successfully delivered and returned: " + request.getAttribute("error"));
			if(true) return; 
		%>
	</c:when>
	<%-- Interpret the message for success or not --%>
	<c:otherwise>
		<c:choose>
			<c:when test='${xmlResponse.get("success/text()") != "true" }'>
				<c:set var="message" scope="request" value='${xmlResponse.get("errorMessage/text()")}'/>
				<%
					response.setStatus(405);
					response.getWriter().write("The action failed: " + request.getAttribute("message"));
					if(true) return; 
				%>
			</c:when>
			<c:when test='${xmlResponse.get("isMaster/text()") != "true" }'>
				<%
					response.setStatus(405);
					response.getWriter().write("The action failed: Responding RIS is not a master");
					if(true) return; 
				%>
			</c:when>
			<c:otherwise>
				${xmlResponse.getXML()}
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>