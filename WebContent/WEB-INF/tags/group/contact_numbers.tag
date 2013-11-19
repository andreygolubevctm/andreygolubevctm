<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"		rtexprvalue="true"	 description="" %>
<%@ attribute name="required" 	required="true" 	rtexprvalue="true"	 description="" %>
<%@ attribute name="helptext" 	required="false"	rtexprvalue="true"	 description="" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<form:row label="Mobile" className="halfrow" >
	<field:contact_mobile xpath="${xpath}/mobile" size="15" required="false" title="mobile number" />
</form:row>

<form:row label="Other Number" className="halfrow right" >
	<field:contact_telno xpath="${xpath}/other" size="15" required="false" isLandline="true" title="other number"  />
</form:row>

<core:clear />

<c:if test="${not empty helptext}">
	<form:row label=" " className="helpTextOuter" >
		<div class="helptext">${helptext}</div>
	</form:row>
</c:if>

<go:log>${xpath} required: ${required}</go:log>
<c:if test="${required}" >
	<go:validate selector="${name}_mobileinput" rule="requiredOneContactNumber" parm="true" message="Please include at least one phone number" />
</c:if>
<go:style marker="css-head">
	.helpTextOuter {
		min-height: 10px;
	}
</go:style>