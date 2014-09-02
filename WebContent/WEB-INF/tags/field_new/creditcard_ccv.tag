<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="The CCV number on credit card." %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 	required="true"		rtexprvalue="true"	description="is this field required?" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div class="row">
	<div class="col-xs-9">
		<field_new:input xpath="${xpath}" required="${required}" title="CCV number on card" maxlength="4" pattern="[0-9]*" className="sessioncamexclude" />
	</div>
	<div class="col-xs-2">
		<img src="framework/images/icon_card_ccv.png" alt="CCV" class="ccv" style="margin-top:10px" />
	</div>
</div>

<go:validate selector="${name}" rule="ccv" parm="${required}" message="Please enter a valid CCV" />
