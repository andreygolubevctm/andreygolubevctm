<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds an accordion panel"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 				required="true"		rtexprvalue="true"	 description="the title of the panel" %>
<%@ attribute name="heading" 			required="false"	rtexprvalue="true"	 description="the tag to use as the heading" %>
<%@ attribute name="headingClassName" 	required="false"	rtexprvalue="true"	 description="optional class for the heading" %>
<%@ attribute name="id"		 			required="false"	rtexprvalue="true"	 description="optional id for the content container" %>
<%@ attribute name="className" 			required="false"	rtexprvalue="true"	 description="optional class for the content container" %>

<%-- VARIABLES --%>
<c:if test="${empty heading}"><c:set var="heading">h3</c:set></c:if>
<c:set var="title"><${heading} class="${headingClassName}">${title}</${heading}></c:set>

<%-- HTML --%>
${title}
<div id="${id}" class="${className}">
	<jsp:doBody />
</div>

<%-- JavaScript --%>
<go:script marker="jquery-ui">
    
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	
</go:style>