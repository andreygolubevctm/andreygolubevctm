<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Bumping Production --%>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<core:doctype />
<go:html>
	<core:head title="HCF Connection Test" />
	<body>
		<h1>
		<%--
		<c:import url="https://nxq.secure.comparethemarket.com.au/ctm/ajax/html/suburbs.jsp">
			<c:param name="postCode" value="4066"/>
		</c:import>
		--%>
		FAIL SECURITY: https://nxq.secure.comparethemarket.com.au/ctm/ajax/html/suburbs.jsp
		</h1>
		<h2>
		<c:import url="http://nxq.secure.comparethemarket.com.au/ctm/ajax/html/suburbs.jsp">
			<c:param name="postCode" value="4066"/>
		</c:import>
		</h2>
		<h3>
		<c:import url="https://qa.ecommerce.disconline.com.au/ctm/ajax/html/suburbs.jsp">
			<c:param name="postCode" value="4066"/>
		</c:import>
		</h3>
		<h4>
		<c:import url="https://qa.secure.comparethemarket.com.au/ctm/ajax/html/suburbs.jsp">
			<c:param name="postCode" value="4066"/>
		</c:import>
		</h4>
	</body>
</go:html>