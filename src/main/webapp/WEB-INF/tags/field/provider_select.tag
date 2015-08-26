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
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- CSS --%>
<go:style marker="css-head">
#product_select_category,  #product_select_category input {
	text-transform:capitalize;
}
</go:style>


<%-- Database Query --%>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- This is used to return a full list of providers, such as where a client can select their current fund so does not need to go through provider validation --%>
<%-- Added the check to exclude expired products/providers --%>
<sql:query var="result">
	<c:choose>
		<c:when test="${pageSettings.getVerticalCode() eq 'car'}">
			SELECT GROUP_CONCAT(a.ProviderCode) AS ProviderCode, (
				CASE WHEN a.ProviderCode = 'AI' THEN 'AI'
				WHEN a.ProviderCode IN ('WOOL','REAL') THEN 'Hollard'
				ELSE 'Budget'
				END
			) AS Name
			FROM ctm.provider_master AS a
			JOIN ctm.provider_properties AS p USING (providerId)
			WHERE p.PropertyId='authToken' AND EXISTS (
				SELECT * FROM ctm.product_master b WHERE b.providerid = a.providerid
				and NOW() BETWEEN b.EffectiveStart and b.EffectiveEnd
				and b.Status NOT IN ('X','N')
				and b.productCat IN('${pageSettings.getVerticalCode()}')
			)
			GROUP BY p.Text
			ORDER BY Name;
		</c:when>
		<c:otherwise>
			SELECT a.ProviderId, a.ProviderCode, a.Name FROM ctm.provider_master a
			WHERE
			EXISTS (
			SELECT * FROM ctm.product_master b WHERE b.providerid = a.providerid
			and NOW() BETWEEN b.EffectiveStart and b.EffectiveEnd
			and b.Status NOT IN ('X','N')
			and b.productCat IN(
			<c:forTokens items="${productCategories}" delims="," var="cat" varStatus="status">
				'${cat}' <c:if test="${!status.last}">,</c:if>
			</c:forTokens>
			) )
			ORDER BY a.Name;
		</c:otherwise>
	</c:choose>
</sql:query>

<c:if test="${value == ''}">
	<c:set var="sel" value="selected" />
</c:if>


<%-- HTML --%>
<div class="select">
	<span class=" input-group-addon" >
		<i class="icon-sort"></i>
	</span>
	<select name="${name}" id="${name}" class="form-control ${className}">
	<%-- Write the initial "please choose" option --%>
	<option value="">Please choose&hellip;</option>

	<%-- Write the options for each row --%>
	<c:forEach var="row" items="${result.rows}" varStatus='idx'>
			<c:if test="${pageSettings.getVerticalCode() == 'health'}">
		<c:choose>
			<c:when test="${row.ProviderId == value}">
				<option value="${row.ProviderId}" selected="selected">${row.Name}</option>
			</c:when>
			<c:otherwise>
				<option value="${row.ProviderId}">${row.Name}</option>
			</c:otherwise>
		</c:choose>
			</c:if>
			<c:if test="${pageSettings.getVerticalCode() ne 'health'}">
				<c:choose>
					<c:when test="${row.ProviderCode == value}">
						<option value="${row.ProviderCode}" selected="selected">${row.Name}</option>
					</c:when>
					<c:otherwise>
						<option value="${row.ProviderCode}">${row.Name}</option>
					</c:otherwise>
				</c:choose>
			</c:if>

	</c:forEach>
	</select>
</div>

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>
</c:if>