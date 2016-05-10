<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="The CCV number on credit card." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 	required="true"		rtexprvalue="true"	description="is this field required?" %>
<%@ attribute name="placeHolder"			required="false" rtexprvalue="true"	 description="Placeholder text" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div class="row">
	<div class="col-xs-9">
		<field_v2:input xpath="${xpath}" required="${required}" title="CCV number on card" maxlength="4" pattern="[0-9]*" className="sessioncamexclude" additionalAttributes=" data-rule-ccv='${required}' " placeHolder="${placeHolder}" />
	</div>
	<div class="col-xs-2">
		<img data-defer-src="assets/graphics/icon_card_ccv.png" alt="CCV" class="ccv" style="margin-top:10px" />
	</div>
</div>