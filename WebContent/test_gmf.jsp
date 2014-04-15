<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<go:log>
	trying to get extension:
	port = 8778
	machine = 192.168.1.22
	agentId = ${authenticatedData.login.user.agentId}
</go:log>
<c:set var="extension"><core:verint_rcapi_extension port="8778" machine="192.168.1.22" agentId="${authenticatedData.login.user.agentId}" /></c:set>
<go:log>extension: ${extension}</go:log>
	<p>trying to get extension:</p>
<p>	port = 8778</p>
<p>	machine = 192.168.1.22</p>
<p>	agentId = ${authenticatedData.login.user.agentId}</p>
<p>extension: ${extension}</p>


<p><xmp><core:verint_rcapi_mute port="8778" machine="192.168.1.22" audio="${param.audio}" extension="${extension}" /></xmp></p>



<%--
<core:verint_rcapi_extension port="8778" machine="192.168.1.22" agentId="${param.agentId}" />
--%>


<c:import url="https://ctmtest.bupa.com.au:446/default.htm" var="bob" />

and we have ${bob}