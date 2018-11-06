<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for level of excess."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>
<%@ attribute name="name" 		required="true" rtexprvalue="true"	 description="Filter's name" %>

<%-- VARIABLES --%>
<c:if test="${not empty xpath}">
	<c:set var="idAttribute" value='id="${go:nameFromXpath(xpath)}_${name}_container"' />
	<c:set var="selectFieldName" value="${go:nameFromXpath(xpath)}_filterBar_${name}" />
	<c:set var="hiddenFieldName" value="${go:nameFromXpath(xpath)}_${name}" />
</c:if>

<%-- HTML --%>
<div ${idAttribute} class="health-filter-excess">
	<select name="${selectFieldName}" class="form-control">
		<c:set var="excessOptions" value="1=No Excess,2=$1 - $250,3=$251 - $500,4=ALL" />
		<c:forTokens items="${excessOptions}" delims="," var="excessOption">
			<c:set var="val" value="${fn:substringBefore(excessOption,'=')}" />
			<c:set var="des" value="${fn:substringAfter(excessOption,'=')}" />
			<option value="${val}">${des}</option>
		</c:forTokens>
	</select>
	<input name="${hiddenFieldName}" value="" type="hidden">

</div>
