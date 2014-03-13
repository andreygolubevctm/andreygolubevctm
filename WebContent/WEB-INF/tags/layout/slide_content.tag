<%@ tag description="Layout for a full width slide"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="title" 			required="false"	description="Title of the slide"%>



<div>
	<c:if test="${not empty title}"><h2>${title}</h2></c:if>
	<jsp:doBody />
</div>
