<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's date of birth, where the min and max age can be dynamically changed"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	See corresponding module formDateInput.js
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 	rtexprvalue="true"	 description="is this field required?" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 	rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="ageMax" 	required="false"  	rtexprvalue="true"	 description="Min Age requirement for Person, e.g. 16" %>
<%@ attribute name="ageMin" 	required="false"  	rtexprvalue="true"	 description="Max Age requirement for Person, e.g. 99" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${empty ageMin}">
	<c:set var="ageMin" value="16" />
</c:if>

<c:if test="${empty ageMax}">
	<c:set var="ageMax" value="99" />
</c:if>

<jsp:useBean id="now" class="java.util.Date"/>
<fmt:formatDate var="nowDate" pattern="yyyy-MM-dd" value="${now}" />

<%-- HTML --%>
<div class="dateinput_container" data-provide="dateinput">
	<div class="row dateinput-tripleField">
		<div class="col-xs-4">
			<field_new:input type="text" className="dateinput-day dontSubmit" xpath="${xpath}InputD" maxlength="2" pattern="[0-9]*" placeHolder="DD" required="${required}" requiredMessage="Please enter the day" />
		</div>
		<div class="col-xs-4">
			<field_new:input type="text" className="dateinput-month dontSubmit" xpath="${xpath}InputM" maxlength="2" pattern="[0-9]*" placeHolder="MM" required="${required}" requiredMessage="Please enter the month" />
		</div>
		<div class="col-xs-4">
			<field_new:input type="text" className="dateinput-year dontSubmit" xpath="${xpath}InputY" maxlength="4" pattern="[0-9]*" placeHolder="YYYY" required="${required}" requiredMessage="Please enter the year" />
		</div>
	</div>
	<div class="hidden select dateinput-nativePicker">
		<span class="input-group-addon"><i class="icon-calendar"></i></span>
		<input type="date" name="${name}Input" id="${name}Input" class="form-control dontSubmit" value="${value}" min="1895-01-01" max="${nowDate}" required="${required}" data-msg-required="Please enter the ${title} date of birth" placeHolder="DD/MM/YYYY">
	</div>

	<field_new:validatedHiddenField xpath="${xpath}" className="serialise" title="Please enter ${title} date of birth" />
</div>

<%-- JAVASCRIPT --%>
<%-- LEGACY... required by various health funds question sets --%>
<go:script marker="js-head">
	var dob_${name} = { ageMin: ${ageMin},  ageMax: ${ageMax},  message: '' };
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}InputD" rule="range" parm="[1,31]" message="Day must be between 1 and 31" />
<go:validate selector="${name}InputM" rule="range" parm="[1,12]" message="Month must be between 1 and 12" />
<go:validate selector="${name}InputY" rule="regex" parm="'[0-9]{4}'" message="Year must be four numbers e.g. 1975" />
<go:validate selector="${name}" rule="dateEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="min_DateOfBirth" parm="{ ageMin:dob_${name}.ageMin }" message="${title} age cannot be under ${ageMin}" />
<go:validate selector="${name}" rule="max_DateOfBirth" parm="{ ageMax:dob_${name}.ageMax }" message="${title} age cannot be over ${ageMax}" />