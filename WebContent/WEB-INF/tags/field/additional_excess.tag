<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from imported option."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="omitPleaseChoose" required="false"	rtexprvalue="true"	 description="should 'please choose' be omitted?" %>
<%@ attribute name="minVal" 	required="true"	rtexprvalue="true"	 description="minimum excess value" %>
<%@ attribute name="increment" 	required="true"	rtexprvalue="true"	 description="excess increment" %>
<%@ attribute name="maxCount"   required="true"	rtexprvalue="true"	 description="maximum number of excesses to choose from" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<%-- CSS --%>
<go:style marker="css-head">
	.selectBox {
		font-size: 1.1em;
		line-height: 1.1;
	}
</go:style>

<%-- HTML --%>


<%-- Substitute the value="X" --%>
<c:set var="findVal" 	value="value=\"${value}\"" />
<c:set var="replaceVal" value="value='${value}' selected='selected'" />

<jsp:element name="select">
	<jsp:attribute name="name">${name}</jsp:attribute>
	<jsp:attribute name="id">${name}</jsp:attribute>
	<jsp:attribute name="class">${className}</jsp:attribute>
	<jsp:body>
		<%-- Write the initial "please choose" option --%>
		<c:choose>
			<c:when test="${omitPleaseChoose == 'Y'}"></c:when>
			<c:when test="${value == ''}">
				<option value="" selected="selected">Please choose..</option>
			</c:when>
			<c:otherwise>
				<option value="">Please choose..</option>
			</c:otherwise>
		</c:choose>
		<c:set var="excessVal" value="${minVal}" />
		<c:forEach var="i" begin="1" end="${maxCount}" step="1">
			<c:choose>
				<c:when test="${excessVal == value}">
					<option value="${excessVal}" selected="selected">$${excessVal}</option>
				</c:when>
				<c:otherwise>
					<option value="${excessVal}">$${excessVal}</option>
				</c:otherwise>
			</c:choose>
			<c:set var="excessVal" value="${excessVal + increment}" />
		</c:forEach>
	</jsp:body>
</jsp:element>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="true" message="Please choose ${title}"/>
</c:if>
