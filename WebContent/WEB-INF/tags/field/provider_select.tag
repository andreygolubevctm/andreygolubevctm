<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Select box for main database categories"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 				required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="productCategories" 	required="true"  rtexprvalue="true"	 description="the product categories (delimited by ,) for which to look for the providers" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />

<%-- CSS --%>
<go:style marker="css-head">
#product_select_category,  #product_select_category input {
	text-transform:capitalize;
}
</go:style>



<%-- HTML --%>
<sql:setDataSource dataSource="jdbc/ctm"/>


<c:set var="catCondition" value="" />
<c:forTokens items="${productCategories}" delims="," var="cat">
	<c:set var="catCondition" value="${catCondition}b.productCat = '${cat}' OR " />
</c:forTokens>
<c:set var="catCondition" value="(${fn:substring(catCondition, 0, fn:length(catCondition)-3 )})" />

<sql:query var="result">
	SELECT a.ProviderId, a.Name FROM provider_master a
	WHERE
	EXISTS (Select * from product_master b where b.providerid = a.providerid and ${catCondition} )
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