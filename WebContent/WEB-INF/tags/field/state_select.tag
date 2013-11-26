<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className"	 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 			required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="useFullNames" 	required="false" rtexprvalue="true"	 description="whether to use full state names in the select options" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${required}">

	<c:set var="titleText">
		<c:choose>
			<c:when test="${not empty title}">${title}</c:when>
			<c:otherwise>state</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="requiredAttribute"> required="required" </c:set>

</c:if>

<%-- HTML --%>
<select name="${name}" id="${name}" class="${className}" data-msg-required="Please enter the ${titleText}"  ${requiredAttribute} >

	<c:choose>
		<c:when test="${empty useFullNames}">
			<c:set var="states">=Please choose...,ACT=ACT,NSW=NSW,NT=NT,QLD=QLD,SA=SA,TAS=TAS,VIC=VIC,WA=WA</c:set>
		</c:when>
		<c:otherwise>
			<c:set var="states">=Please choose...,ACT=Australian Capital Territory,NSW=New South Wales,NT=Northern Territory,QLD=Queensland,SA=South Australia,TAS=Tasmania,VIC=Victoria,WA=Western Australia</c:set>
		</c:otherwise>
	</c:choose>


	<c:forTokens items="${states}" delims="," var="state">

		<c:set var="val" value="${fn:substringBefore(state,'=')}" />
		<c:set var="des" value="${fn:substringAfter(state,'=')}" />

		<c:choose>
			<c:when test="${not empty value and value eq val}">
				<c:set var="selectedAttribute"> selected="selected" </c:set>
			</c:when>
			<c:otherwise>
				<c:set var="selectedAttribute"> </c:set>
			</c:otherwise>
		</c:choose>
		<c:set var="attributes"> ${selectedAttribute} value="${val}" </c:set>
		<option ${attributes} >${des}</option>
	</c:forTokens>

</select>

