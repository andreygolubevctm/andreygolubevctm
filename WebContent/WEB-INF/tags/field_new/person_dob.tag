<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's date of birth, where the min and max age can be dynamically changed"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	See corresponding module formDateInput.js
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 	rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 	rtexprvalue="true"	 description="is this field required?" %>
<%@ attribute name="className" 			required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 				required="true"	 	rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="ageMax" 			required="false"  	rtexprvalue="true"	 description="Min Age requirement for Person, e.g. 16" %>
<%@ attribute name="ageMin" 			required="false"  	rtexprvalue="true"	 description="Max Age requirement for Person, e.g. 99" %>
<%@ attribute name="validateYoungest" 	required="false"  	rtexprvalue="true"	 description="Add validation for youngest person" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${empty ageMin}">
	<c:set var="ageMin" value="16" />
</c:if>

<c:if test="${empty ageMax}">
	<c:set var="ageMax" value="99" />
</c:if>

<jsp:useBean id="nowLessAgeMinYears" class="java.util.GregorianCalendar" />
<% nowLessAgeMinYears.add(java.util.GregorianCalendar.YEAR, -Integer.parseInt(ageMin)); %>
<fmt:formatDate var="nowLessAgeMinYears" pattern="yyyy-MM-dd" value="${nowLessAgeMinYears.time}" />
<go:log level="TRACE">DOB Restricted to max: ${nowLessAgeMinYears} (${name})</go:log>

<%-- HTML --%>
<div class="dateinput_container" data-provide="dateinput">
	<div class="row dateinput-tripleField">
		<div class="col-lg-4 col-md-4 col-sm-3 col-xs-4">
			<field_new:input type="text" className="dateinput-day dontSubmit ${className}" xpath="${xpath}InputD" maxlength="2" pattern="[0-9]*" placeHolder="DD" required="false" requiredMessage="Please enter the day" />
		</div>
		<div class="col-lg-4 col-md-4 col-sm-3 col-xs-4">
			<field_new:input type="text" className="dateinput-month dontSubmit ${className}" xpath="${xpath}InputM" maxlength="2" pattern="[0-9]*" placeHolder="MM" required="false" requiredMessage="Please enter the month" />
		</div>
		<div class="col-lg-4 col-md-4 col-sm-6 col-xs-4">
			<field_new:input type="text" className="dateinput-year dontSubmit ${className}" xpath="${xpath}InputY" maxlength="4" pattern="[0-9]*" placeHolder="YYYY" required="false" requiredMessage="Please enter the year" />
		</div>
	</div>
	<div class="hidden select dateinput-nativePicker">
		<span class="input-group-addon"><i class="icon-calendar"></i></span>
		<input type="date" name="${name}Input" id="${name}Input" class="form-control dontSubmit" value="${value}" min="1895-01-01" max="${nowLessAgeMinYears}" data-msg-required="Please enter the ${title} date of birth" placeHolder="DD/MM/YYYY">
	</div>

	<field_new:validatedHiddenField xpath="${xpath}" required="${required}" className="serialise" title="Please enter ${title} date of birth" />
</div>

<%-- JAVASCRIPT --%>
<%-- LEGACY... required by various health funds question sets --%>
<go:script marker="js-head">
	var dob_${name} = { ageMin: ${ageMin},  ageMax: ${ageMax},  message: '' };
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="dateOfBirthEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="dateOfBirthEURValidYear" parm="true" message="Please enter a four digit number for the year."/>
<go:validate selector="${name}" rule="min_DateOfBirthYearException" parm="{ ageMin:dob_${name}.ageMin }" message="${title} age cannot be under ${ageMin}" />
<go:validate selector="${name}" rule="max_DateOfBirthYearException" parm="{ ageMax:dob_${name}.ageMax }" message="${title} age cannot be over ${ageMax}" />
<c:if test="${validateYoungest eq true}">
	<go:validate selector="${name}" rule="youngRegularDriversAgeCheck" parm="true" message="Youngest driver should not be older than the regular driver"/>
</c:if>