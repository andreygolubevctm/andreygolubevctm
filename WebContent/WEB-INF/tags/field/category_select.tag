<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box for main database categories"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="type" 		required="true"	 rtexprvalue="true"	 description="type code on general table" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>


<%-- HTML --%>
<sql:setDataSource dataSource="jdbc/aggregator"/>



<sql:query var="result">
	SELECT ProductCat, Description FROM aggregator.product_catagory_master;
</sql:query>


<c:if test="${value == ''}">
	<c:set var="sel" value="selected" />
</c:if>


<%-- HTML --%>

<select name="${name}" id="${name}" class="form-control ${className}">
	<%-- Write the initial "please choose" option --%>
	<option value="">Please choose&hellip;</option>

	<%-- Write the options for each row --%>
	<c:forEach var="row" items="${result.rows}" varStatus='idx'>
		<c:choose>
			<c:when test="${not empty value and row.ProductCat == value}">
				<option value="${row.ProductCat}" selected="selected">${row.Description}</option>
			</c:when>
			<c:otherwise>
				<option value="${row.ProductCat}">${row.Description}</option>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</select>
