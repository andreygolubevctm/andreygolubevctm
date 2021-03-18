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
<%@ attribute name="outputJS" 				required="false"  	rtexprvalue="true"	 description="Whether to output the JS" %>
<%@ attribute name="disableErrorContainer" 	required="false" rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="type" 					required="false"  	rtexprvalue="true"	 description="What type of date input do you want?" %>

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

<jsp:useBean id="userAgentSniffer" class="com.ctm.web.core.services.UserAgentSniffer" />
<c:set var="deviceType" value="${userAgentSniffer.getDeviceType(pageContext.getRequest().getHeader('user-agent'))}" />
<%--
    If type is undefined use the deviceType to determine input type.
    For mobile type would be type text according to HLT-4236
 --%>
<c:if test="${empty type}">
    <c:set var="type">
        <c:choose>
            <c:when test="${deviceType eq 'MOBILE'}">
                input
            </c:when>
            <c:otherwise>
                select
            </c:otherwise>
        </c:choose>
    </c:set>
</c:if>

<%-- HTML --%>
<div class="dateinput_container" data-provide="dateinput">
	<c:choose>
		<c:when test="${type eq 'select'}">
			<div class="row dateinput-tripleField">
				<div class="col-md-3 col-xs-4 dayContainer">
					<field_v2:import_select xpath="${xpath}InputD"
											title="the day"
											required=""
											omitPleaseChoose="Y"
											url="/WEB-INF/option_data/day.html"
											className="sessioncamexclude dateinput-day dontSubmit data-hj-suppress ${className}" />
				</div>
				<div class="col-md-4 col-xs-4 monthContainer">
					<field_v2:import_select xpath="${xpath}InputM"
											title="the month"
											required=""
											omitPleaseChoose="Y"
											url="/WEB-INF/option_data/month_full_v2.html"
											className="sessioncamexclude dateinput-month dontSubmit data-hj-suppress ${className}" />
				</div>
				<div class="col-md-3 col-xs-4">
					<jsp:useBean id="date" class="java.util.Date" />
					<fmt:formatDate value="${date}" pattern="yyyy" var="currentYear" />

					<c:set var="sep" value="" />
					<c:set var="years">
						<c:forEach  var="newYear" begin="${ageMin}" end="${ageMax}" >
							${sep}${currentYear - newYear}=${currentYear - newYear}
							<c:set var="sep">,</c:set>
						</c:forEach>
					</c:set>
					<field_v2:array_select xpath="${xpath}InputY"
										   required=""
										   title="the year"
										   items="=Year,${years}"
										   className="sessioncamexclude dateinput-year dontSubmit data-hj-suppress ${className}" />
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="row dateinput-tripleField">
				<div class="col-sm-3 col-xs-4 dayContainer">
					<field_v2:input type="number" className="sessioncamexclude dateinput-day dontSubmit data-hj-suppress ${className}" xpath="${xpath}InputD" maxlength="2" pattern="[0-9]*" placeHolder="DD" required="false" requiredMessage="Please enter the day" />
				</div>
				<div class="col-sm-3 col-xs-4 monthContainer">
					<field_v2:input type="number" className="sessioncamexclude dateinput-month dontSubmit data-hj-suppress ${className}" xpath="${xpath}InputM" maxlength="2" pattern="[0-9]*" placeHolder="MM" required="false" requiredMessage="Please enter the month" />
				</div>
				<div class="col-md-4 col-sm-5 col-xs-4">
					<field_v2:input type="number" className="sessioncamexclude dateinput-year dontSubmit data-hj-suppress ${className}" xpath="${xpath}InputY" maxlength="4" pattern="[0-9]*" placeHolder="YYYY" required="false" requiredMessage="Please enter the year" />
				</div>
			</div>
		</c:otherwise>
	</c:choose>


	<div class="hidden select dateinput-nativePicker">
		<span class="input-group-addon"><i class="icon-calendar"></i></span>
		<input type="date" name="${name}Input" id="${name}Input" class="form-control dontSubmit" value="${value}" min="${minYear}-01-01" max="${nowLessAgeMinYears}" data-msg-required="Please enter the ${title} date of birth" placeHolder="DD/MM/YYYY">
	</div>

	<field_v2:validatedHiddenField xpath="${xpath}" className="serialise" additionalAttributes=" ${isRequired} ${additionalAttributes} data-rule-dateEUR='true'  ${youngestDOB} ${oldestDOB} ${youngRegularDriversAgeCheck}" disableErrorContainer="${disableErrorContainer}" />
</div>

<%-- JAVASCRIPT --%>
<%-- LEGACY... required by various health funds question sets --%>
<c:if test="${outputJS}">
	<go:script marker="js-head">
		var dob_${name} = { ageMin: ${ageMin},  ageMax: ${ageMax},  message: '' };
	</go:script>
</c:if>