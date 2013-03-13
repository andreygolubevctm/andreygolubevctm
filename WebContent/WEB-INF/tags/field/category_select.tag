<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
<c:set var="value" value="${data[xpath]}" />


<%-- HTML --%>
<sql:setDataSource dataSource="jdbc/aggregator"/>



<sql:query var="result">
	SELECT ProductCat, Description FROM aggregator.product_catagory_master;
</sql:query>


<c:if test="${value == ''}">
	<c:set var="sel" value="selected" />
</c:if>


<%-- HTML --%>

<select name="${name}" id="${name}" class="${className}">
	<%-- Write the initial "please choose" option --%>
	<c:choose>
		<c:when test="${value == ''}">
			<option value="" selected="selected">Please choose..</option>
		</c:when>
		<c:otherwise>
			<option value="">Please choose..</option>
		</c:otherwise>
	</c:choose>
	<%-- Write the options for each row --%>
	<c:forEach var="row" items="${result.rows}" varStatus='idx'>
		<c:choose>
			<c:when test="${row.ProductCat == value}">
				<option value="${row.ProductCat}" selected="selected">${row.Description}</option>
			</c:when>
			<c:otherwise>
				<option value="${row.ProductCat}">${row.Description}</option>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</select>
