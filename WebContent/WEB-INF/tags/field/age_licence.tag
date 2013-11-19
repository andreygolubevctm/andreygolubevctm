<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the age the driver obtained their full Australian driver licence "%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the radio buttons" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="The rows help id (if non provided, help is not shown)" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>

<div>
	<div class="floatLeft">
		<input type="text" name="${name}" id="${name}" class="age_licence numeric ${className}" value="${data[xpath]}" maxlength="2" title="${title}" size=2 />
	</div>

	<c:if test="${helpId != null && helpId != ''}">
		<div class="floatLeft">
			<span class="help_icon" id="help_${helpId}"></span>
		</div>
	</c:if>
</div>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the age the ${title} driver obtained a driver's licence"/>
<go:validate selector="${name}" rule="ageLicenceObtained" parm="${required}" message="Age licence obtained invalid due to ${title} driver's age."/>

<%-- CSS --%>
<go:style marker="css-head">
	.floatLeft {float:left;}
</go:style>
