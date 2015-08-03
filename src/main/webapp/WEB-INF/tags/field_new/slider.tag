<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Slider UI" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	Slider UI has corresponding module: framework/modules/js/sliders.js
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="value" 					required="true"  rtexprvalue="true"	 description="Initial value of the slider" %>
<%@ attribute name="range" 					required="true"  rtexprvalue="true"	 description="Value range 'min,max' e.g. '100,650'" %>
<%@ attribute name="legend"					required="false" rtexprvalue="true"	 description="(optional) Labels to display as a legend, comma separated e.g. '$0,$500,All'" %>
<%@ attribute name="markers"				required="false" rtexprvalue="true"	 description="(optional) How many step markers to show e.g. 3" %>
<%@ attribute name="step"					required="false" rtexprvalue="true"	 description="(optional) Slide increment value for each slide step" %>
<%@ attribute name="type" 					required="false" rtexprvalue="true"	 description="(optional) Special types of sliders e.g. 'excess'" %>
<%@ attribute name="xpath" 					required="false" rtexprvalue="true"	 description="(optional) If set, a hidden field will be added using this xpath." %>
<%@ attribute name="className" 				required="false" rtexprvalue="true"	 description="Additional css class attribute" %>
<%@ attribute name="useDefaultOutputField" 	required="false" rtexprvalue="true"	 description="Whether to use the default output field to store values or use the hardcoded health output field" %>


<%-- VARIABLES --%>
<c:if test="${not empty xpath}">
	<c:set var="name" value="${go:nameFromXpath(xpath)}" />
</c:if>

<c:if test="${empty markers}">
	<c:set var="markers" value="0" />
</c:if>

<c:if test="${empty step}">
	<c:set var="step" value="1" />
</c:if>

<c:if test="${empty useDefaultOutputField}">
	<c:set var="useDefaultOutputField" value="false" />
</c:if>


<%-- HTML --%>
<div class="slider-control ${className}">

	<div class="selection"></div>
	<div class="slider-legends"></div>
	<div class="slider" data-use-default-output="${useDefaultOutputField}" data-value="${value}" data-range="${range}" data-markers="${markers}" data-step="${step}" data-legend="${legend}" data-type="${type}"></div>

	<%-- If xpath was defined, add a hidden field to store it --%>
	<c:if test="${not empty name}">
		<input name="${name}" value="${value}" type="hidden">
	</c:if>
</div>