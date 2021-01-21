<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select element for what type of cover you're after eg Combined, Hospital or Extras"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="fieldXpath" value="${xpath}/coverType" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="benefits coverType" quoteChar="\"" /></c:set>

<div id="health-benefits-coverType-container">
	<h1 class="step-count">1.</h1>
	<h3>Let's find the right cover for you</h3>

	<form_v4:row hideRowBorder="true" label="What type of cover would you like?" fieldXpath="${fieldXpath}" className="" renderLabelAboveContent="true">
		<field_v2:array_radio xpath="${fieldXpath}"
			required="true"
			className="row health-benefits-coverType has-icons has-copy"
			items="C=Hospital & Extras,H=Hospital only,E=Extras only"
			id="${go:nameFromXpath(fieldXPath)}"
			style="radio-rounded"
			title="the type of cover would you like"
			additionalLabelAttributes="${analyticsAttr}"
		    wrapCopyInSpan="true"
			defaultValue="C" />
	</form_v4:row>
</div>