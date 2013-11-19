<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dialog to set a comparison reminder"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="src" 			required="false" rtexprvalue="true"	 description="whether this is from an external source or local" %>
<%@ attribute name="vertical" 		required="false" rtexprvalue="true"	 description="the vertical that this is associated with" %>
<%@ attribute name="loadjQuery" 	required="false" rtexprvalue="true"	 description="If jquery is needed to be loaded" %>
<%@ attribute name="loadjQueryUI" 	required="false" rtexprvalue="true"	 description="If jqueryUI is needed to be loaded" %>
<%@ attribute name="loadHead" 		required="false" rtexprvalue="true"	 description="If the main head content needs to be loaded" %>
<%@ attribute name="preSelect" 		required="false" rtexprvalue="true"	 description="List of options to be preselected" %>
<%@ attribute name="id" 			required="false" rtexprvalue="true"	 description="ID used primarily for anti css conflicting" %>

<c:if test="${empty vertical}"><c:set var="vertical">general</c:set></c:if>
<c:if test="${empty loadjQuery}"><c:set var="loadjQuery">true</c:set></c:if>
<c:if test="${empty loadjQueryUI}"><c:set var="loadjQueryUI">true</c:set></c:if>
<c:if test="${empty loadHead}"><c:set var="loadHead">true</c:set></c:if>

<c:choose>
	<c:when test="${src == 'ext'}">

		<core:wrapper loadjQuery="${loadjQuery}" loadjQueryUI="${loadjQueryUI}" loadHead="${loadHead}" vertical="${vertical}" id="${id}">
			<core:comparison_reminder_dialog xpath="reminder" vertical="${vertical}" preSelect="${preSelect }" src="${src}" id="${id}"/>
		</core:wrapper>
	</c:when>
	<c:otherwise>
		<core:comparison_reminder_dialog xpath="reminder" vertical="${vertical}" preSelect="${preSelect }" src="${src}" id="${id}"/>
	</c:otherwise>
</c:choose>