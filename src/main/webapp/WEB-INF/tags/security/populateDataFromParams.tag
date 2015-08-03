<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="rootPath" required="true" rtexprvalue="true" description="root Path like (e.g. travel)" %>
<%@ attribute name="createRootPath" required="false" rtexprvalue="true" description="append onto the data" %>
<%@ attribute name="delete" required="false" rtexprvalue="true" description="delete exisitng data from this bucket" %>

<c:if test="${empty delete}"><c:set var="delete" value="true" /></c:if>

<c:if test="${not empty rootPath}">
	<c:import url="/WEB-INF/xslt/validation/sanitiseInput.xsl" var="xsltFile"/>

	<% request.setAttribute("paramData", new com.disc_au.web.go.Data()); %>

	<c:choose>
		<c:when test="${createRootPath}">
			<go:setData dataVar="paramData" value="*PARAMS" xpath="${rootPath}" />
		</c:when>
		<c:otherwise>
			<go:setData dataVar="paramData" value="*PARAMS" />
		</c:otherwise>
	</c:choose>
	<c:if test="${delete}">
		<go:setData dataVar="data" xpath="${rootPath}" value="*DELETE" />
	</c:if>
	<c:if test="${paramData[rootPath].size() > 0}">
		<c:set var="sanitisedParamDataXml">
			<x:transform doc="${go:getEscapedXml(paramData[rootPath])}" xslt="${xsltFile}" />
		</c:set>
		<go:setData dataVar="data" xml="${sanitisedParamDataXml}"  />
	</c:if>

</c:if>