<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box for main database categories"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 				required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="productCategories" 	required="true"  rtexprvalue="true"	 description="the product categories (delimited by ,) for which to look for the providers" %>

<%-- whitelist to prevent SQL injection --%>
<c:set var="productCategories" value='<%=productCategories.replaceAll("[^a-zA-Z,]","")%>' />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<%-- CSS --%>
<go:style marker="css-head">
#product_select_category,  #product_select_category input {
	text-transform:capitalize;
}
</go:style>


<%-- Database Query --%>

<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="result">
	SELECT a.ProviderId, a.Name FROM provider_master a
	WHERE
	EXISTS (
		Select * from product_master b where b.providerid = a.providerid
		and b.productCat IN(
			<c:forTokens items="${productCategories}" delims="," var="cat" varStatus="status">
				'${cat}' <c:if test="${!status.last}">,</c:if>
			</c:forTokens>
		) )
	ORDER BY a.Name;
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
			<c:when test="${row.ProviderId == value}">
				<option value="${row.ProviderId}" selected="selected">${row.Name}</option>
			</c:when>
			<c:otherwise>
				<option value="${row.ProviderId}">${row.Name}</option>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</select>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>
</c:if>