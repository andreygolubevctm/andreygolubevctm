<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Filter for level of excess."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="false" rtexprvalue="true"	 description="(optional) Filter's xpath" %>
<%@ attribute name="name" 		required="true" rtexprvalue="true"	 description="Filter's name" %>

<%-- VARIABLES --%>
<c:if test="${not empty xpath}">
	<c:set var="idAttribute" value='id="${go:nameFromXpath(xpath)}_${name}_container"' />
	<c:set var="radioGroupName" value="${go:nameFromXpath(xpath)}_filterBar_${name}" />
	<c:set var="hiddenFieldName" value="${go:nameFromXpath(xpath)}_${name}" />
</c:if>

<%-- HTML --%>
<div ${idAttribute} class="health-filter-excess">
	<field_v2:array_radio xpath="${radioGroupName}" title="your insurance excess amount" required="true" items="1=No Excess||2=$1 - $250||3=$251 - $500||5=$501 - $750||4=ALL" delims="||" style="radio-as-checkbox" wrapCopyInSpan="true" outerWrapperClassName="col-xs-12 col-sm-12 col-md-12 col-lg-12 vertical" className="${radioGroupName} radio-as-checkbox" additionalAttributes="${analyticsAttr} data-attach=true" />
	<input name="${hiddenFieldName}" value="" type="hidden">
</div>
