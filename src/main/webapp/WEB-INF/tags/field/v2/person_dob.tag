<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's date of birth, where the min and max age can be dynamically changed"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('tag.field_new.person_dob')}" />

<%--
	See corresponding module formDateInput.js
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 					required="true"	 	rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 				required="true"	 	rtexprvalue="true"	 description="is this field required?" %>
<%@ attribute name="className" 				required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 					required="true"	 	rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="ageMax" 				required="false"  	rtexprvalue="true"	 description="Min Age requirement for Person, e.g. 16" %>
<%@ attribute name="ageMin" 				required="false"  	rtexprvalue="true"	 description="Max Age requirement for Person, e.g. 99" %>
<%@ attribute name="validateYoungest" 		required="false"  	rtexprvalue="true"	 description="Add validation for youngest person" %>
<%@ attribute name="additionalAttributes" 	required="false"  	rtexprvalue="true"	 description="Add additional attributes" %>
<%@ attribute name="outputJS" 	required="false"  	rtexprvalue="true"	 description="Whether to output the JS" %>

<%-- VARIABLES --%>
<c:if test="${empty outputJS}"><c:set var="outputJS" value="${true}" /></c:if>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${empty ageMin}">
	<c:set var="ageMin" value="16" />
</c:if>

<c:if test="${empty ageMax}">
	<c:set var="ageMax" value="99" />
</c:if>

<c:set var="isRequired">
	<c:if test="${required eq true}">
		required data-msg-required='Please enter ${fn:escapeXml(title)} date of birth'
	</c:if>
</c:set>
<c:set var="youngestDOB">
	<c:choose>
		<c:when test="${outputJS}"> data-rule-youngestDOB='{"ageMin":"dob_${name}.ageMin"}'</c:when>
		<c:otherwise> data-rule-youngestDOB='${ageMin}' </c:otherwise>
	</c:choose>
	data-msg-youngestDOB='${fn:escapeXml(title)} age cannot be under ${ageMin}'
</c:set>
<c:set var="oldestDOB">
	<c:choose>
		<c:when test="${outputJS}"> data-rule-oldestDOB='{ "ageMax":"dob_${name}.ageMax"}' </c:when>
		<c:otherwise> data-rule-oldestDOB='${ageMax}' </c:otherwise>
	</c:choose>
	 data-msg-oldestDOB='${fn:escapeXml(title)} age cannot be over ${ageMax}'
</c:set>

<c:set var="youngRegularDriversAgeCheck">
	<c:if test="${validateYoungest eq true}">
		data-rule-youngRegularDriversAgeCheck='true' data-msg-youngRegularDriversAgeCheck='Youngest driver should not be older than the regular driver'
	</c:if>
</c:set>

<jsp:useBean id="nowLessAgeMinYears" class="java.util.GregorianCalendar" />
<% nowLessAgeMinYears.add(java.util.GregorianCalendar.YEAR, -Integer.parseInt(ageMin)); %>
<fmt:formatDate var="nowLessAgeMinYears" pattern="yyyy-MM-dd" value="${nowLessAgeMinYears.time}" />
${logger.trace('DOB Restricted to max: {},{}' , log:kv('nowLessAgeMinYears', nowLessAgeMinYears), log:kv('name', name))}

<c:set var="minYear" value="${java.util.GregorianCalendar.YEAR - Integer.parseInt(ageMax)}" />

<%-- HTML --%>
<div class="dateinput_container" data-provide="dateinput">
	<div class="row dateinput-tripleField">
		<div class="col-sm-2 col-xs-4 dayContainer">
			<field_v2:input type="text" className="sessioncamexclude dateinput-day dontSubmit ${className}" xpath="${xpath}InputD" maxlength="2" pattern="[0-9]*" placeHolder="DD" required="false" requiredMessage="Please enter the day" />
		</div>
		<div class="col-sm-2 col-xs-4 monthContainer">
			<field_v2:input type="text" className="sessioncamexclude dateinput-month dontSubmit ${className}" xpath="${xpath}InputM" maxlength="2" pattern="[0-9]*" placeHolder="MM" required="false" requiredMessage="Please enter the month" />
		</div>
		<div class="col-sm-3 col-xs-4">
			<field_v2:input type="text" className="sessioncamexclude dateinput-year dontSubmit ${className}" xpath="${xpath}InputY" maxlength="4" pattern="[0-9]*" placeHolder="YYYY" required="false" requiredMessage="Please enter the year" />
		</div>
	</div>
	<div class="hidden select dateinput-nativePicker">
		<span class="input-group-addon"><i class="icon-calendar"></i></span>
		<input type="date" name="${name}Input" id="${name}Input" class="form-control dontSubmit" value="${value}" min="${minYear}-01-01" max="${nowLessAgeMinYears}" data-msg-required="Please enter the ${title} date of birth" placeHolder="DD/MM/YYYY">
	</div>

	<field_v2:validatedHiddenField xpath="${xpath}" className="serialise" additionalAttributes=" ${isRequired} ${additionalAttributes} data-rule-dateEUR='true'  ${youngestDOB} ${oldestDOB} ${youngRegularDriversAgeCheck}" />
</div>

<%-- JAVASCRIPT --%>
<%-- LEGACY... required by various health funds question sets --%>
<c:if test="${outputJS}">
<go:script marker="js-head">
	var dob_${name} = { ageMin: ${ageMin},  ageMax: ${ageMax},  message: '' };
</go:script>
</c:if>