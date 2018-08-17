<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a DD MM YYYY field with a date picker or inline calendar."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 					required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 				required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 				required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="mobileClassName" 		required="false" rtexprvalue="true"	 description="additional css class attribute for mobile" %>
<%@ attribute name="calAdditionalAttributes" required="false" rtexprvalue="true"   description="When you want to send in additional attributes" %>
<%@ attribute name="title" 					required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="minDate" 				required="false" rtexprvalue="true"	 description="Minimum Inclusive Date Value (rfc3339 yyyy-MM-dd) (or strings supported by the JS bootstrap-datepicker control for mode of component ONLY)"%>
<%@ attribute name="maxDate" 				required="false" rtexprvalue="true"	 description="Maximum Inclusive Date Value (rfc3339 yyyy-MM-dd) (or strings supported by the JS bootstrap-datepicker control for mode of component ONLY)"%>
<%@ attribute name="validateMinMax" 		required="false" rtexprvalue="true"	 description="Validate Min Max values passed in - Defaults to True (should be set to false to disable range validation when using the strings supported by the JS bootstrap-datepicker)"%>
<%@ attribute name="startView" 				required="false" rtexprvalue="true"	 description="The view either 0:Month|1:Year|2:Decade|"%>
<%@ attribute name="mode"	 				required="false" rtexprvalue="true"	 description="Component: Display as input with a click bound calendar. Inline: embedded calendar (with hidden field). Separated: DD MM YYYY inputs with a calendar click bound button and hidden input."%>
<%@ attribute name="nonLegacy" 				required="false" rtexprvalue="true"	 description="If the component is non legacy, format the dates as to be expected. So that Min/Max validation works."%>
<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="disableRowHack" 		required="false" 	rtexprvalue="true"    	 description="Disable the row-hack class" %>
<%@ attribute name="analyticsPrefix" 		required="false" 	rtexprvalue="true"    	 description="The prefix applied to the data analytics label" %>
<%@ attribute name="showCalendarOnXS" 		required="false" 	rtexprvalue="true"    	 description="Show the calendar date picker on xs devices" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<fmt:formatDate var="todayDateEuro" value="${now}" pattern="dd/MM/yyyy" />
<c:if test="${not empty analyticsPrefix}">
	<c:set var="analyticsPrefix" value="${analyticsPrefix} " />
</c:if>

<c:if test="${empty mode}"> <%-- Supports component, inline or separated --%>
	<c:set var="mode">component</c:set>
</c:if>
<c:if test="${empty validateMinMax}"> <%-- Supports component, inline or separated --%>
	<c:set var="validateMinMax">true</c:set>
</c:if>

<c:if test="${not empty minDate}">
	<c:set var="minDateAttribute" />
	<c:set var="minDateEuro" />
	<c:choose>
		<c:when test="${mode == 'component' and empty nonLegacy}">
			<c:set var="minDateAttribute"> data-date-start-date="${minDate}"</c:set>
		</c:when>
		<c:otherwise>
			<fmt:parseDate value="${minDate}" var="parsedMinDate" pattern="yyyy-MM-dd" />
			<fmt:formatDate var="minDateEuro" pattern="dd/MM/yyyy" value="${parsedMinDate}" />
			<c:set var="minDateAttribute"> data-date-start-date="${minDateEuro}"</c:set>
		</c:otherwise>
	</c:choose>
</c:if>

<c:if test="${not empty maxDate}">
	<c:set var="maxDateAttribute" />
	<c:set var="maxDateEuro" />
	<c:choose>
		<c:when test="${mode == 'component' and empty nonLegacy}">
			<c:set var="maxDateAttribute"> data-date-end-date="${maxDate}"</c:set>
		</c:when>
		<c:otherwise>
			<fmt:parseDate value="${maxDate}" var="parsedMaxDate" pattern="yyyy-MM-dd" />
			<fmt:formatDate var="maxDateEuro" pattern="dd/MM/yyyy" value="${parsedMaxDate}" />
			<c:set var="maxDateAttribute"> data-date-end-date="${maxDateEuro}"</c:set>
		</c:otherwise>
	</c:choose>
</c:if>

<c:if test="${empty startView}">
	<c:set var="startView" value="0" />
</c:if>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>


<c:if test="${required}">
	<c:set var="requiredAttribute" value='required data-msg-required="Please enter the ${title}"' />
</c:if>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:set var="todaysDate" value="today's date" />
<c:set var="minDateEurRule">
	<c:if test="${not empty minDateEuro and validateMinMax == true}">
		data-rule-earliestDateEUR='${minDateEuro}' data-msg-earliestDateEUR='Please enter a date on or after ${fn:escapeXml(todayDateEuro == minDateEuro ? todaysDate : minDateEuro)}'
	</c:if>
</c:set>
<c:set var="maxDateEurRule">
	<c:if test="${not empty maxDateEuro and validateMinMax == true}">
		data-rule-latestDateEUR='${maxDateEuro}' data-msg-latestDateEUR='Please enter a date on or before ${fn:escapeXml(todayDateEuro == maxDateEuro ? todaysDate : maxDateEuro)}'
	</c:if>
</c:set>

<c:set var="dateEurRule">
	data-rule-dateEUR='${required}' data-msg-dateEUR="Please enter a valid ${title} date for DD MM YYYY"
</c:set>
<%--
	Datepicker useful links for devs:
		http://bootstrap-datepicker.readthedocs.org/
		http://eternicode.github.io/bootstrap-datepicker/
--%>

<%-- HTML --%>
<c:choose> <%-- TEST THE MODE and allow it to set the correct calendar --%>
	<%--
		Inline calendar needs to be inited on the below ID via JS somewhere else:
		http://eternicode.github.io/bootstrap-datepicker/?markup=embedded&format=dd%2Fmm%2Fyyyy&weekStart=1&startDate=today&endDate=%2B1m&startView=0&minViewMode=0&todayBtn=false&language=en&orientation=auto&multidate=&multidateSeparator=&autoclose=on&todayHighlight=on&forceParse=on#sandbox
	--%>
	<c:when test="${mode eq 'inline'}">
		<div id="${name}_calendar"></div>
		<field_v2:validatedHiddenField xpath="${xpath}" className="${className}" title="Please enter the ${title}" validationErrorPlacementSelector="#${name}_calendar" additionalAttributes=" required ${dateEurRule} ${minDateEurRule} ${maxDateEurRule}" disableErrorContainer="${disableErrorContainer}" />
	</c:when>
	<%--
		The calendar input picker's default component mode:
		http://eternicode.github.io/bootstrap-datepicker/?markup=component&format=dd%2Fmm%2Fyyyy&weekStart=1&startDate=today&endDate=%2B1m&startView=0&minViewMode=0&todayBtn=false&language=en&orientation=auto&multidate=&multidateSeparator=&autoclose=on&todayHighlight=on&forceParse=on#sandbox
	--%>
	<c:when test="${mode eq 'component'}">
		<%-- This was the old usage in the platform --%>
		<%-- Exposed some attributes here so the tag define a few JS settings --%>
		<c:set var="disableErrorContainer">
		<c:if test="${disableErrorContainer eq true}">
			data-disable-error-container='true'
		</c:if>
		</c:set>
		<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="${analyticsPrefix} Date" quoteChar="\"" /></c:set>
		<div class="input-group date ${mobileClassName}" data-provide="datepicker" data-date-mode="${mode}"
			${maxDateAttribute}
			${minDateAttribute} data-date-start-view="${startView}">
			<input type="text"
				placeHolder="DD/MM/YYYY"
				name="${name}"
				id="${name}"
				class="form-control dateinput-date ${className}"
				value="${value}"
				title="${title}" ${requiredAttribute} ${dateEurRule} ${disableErrorContainer} ${analyticsAttr}>
			<span class="input-group-addon">
				<i class="icon-calendar"></i>
			</span>
		</div>
	</c:when>
	<%--
		Separated: we want to render our custom separated input field with a calendar selection.
		The separated field code is derived from person_dob.tag. It has a corresponding module formDateInput.js in core.
		The datepicker module code is datepicker.js in core.
	--%>
	<c:when test="${mode eq 'separated'}">
		<c:set var="yearCols" value=" col-sm-5 col-md-4" />
		<c:if test="${disableRowHack eq true}">
			<c:set var="yearCols" value=" col-sm-3" />
		</c:if>

		<c:set var="xsCols" value="col-xs-4" />
		<c:set var="calXSCols" value="hidden-xs" />
		<c:if test="${showCalendarOnXS eq true}">
			<c:set var="xsCols" value="col-xs-3" />
			<c:set var="calXSCols" value="col-xs-3" />
		</c:if>

		<div class="dateinput_container" data-provide="dateinput">
			<div class="row dateinput-tripleField withDatePicker">
				<div class="${xsCols} col-sm-3 ">
					<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="${analyticsPrefix}Day" quoteChar="\"" /></c:set>
					<field_v2:input type="text" size="2" className="dateinput-day dontSubmit ${className}"  xpath="${xpath}InputD" maxlength="2" pattern="[0-9]*" placeHolder="DD" required="${required}" requiredMessage="Please enter the day" additionalAttributes=" data-rule-range='1,31' data-msg-range='Day must be between 1 and 31.' ${analyticsAttr}" />
				</div>
				<div class="${xsCols} col-sm-3 <c:if test="${not disableRowHack eq true}"> row-hack</c:if>"> <%-- special row hack to remove margins and hence allow us to squeeze into this size parent ---%>
					<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="${analyticsPrefix}Month" quoteChar="\"" /></c:set>
					<field_v2:input size="2" type="text" className="dateinput-month dontSubmit ${className}" xpath="${xpath}InputM" maxlength="2" pattern="[0-9]*" placeHolder="MM" required="${required}" requiredMessage="Please enter the month" additionalAttributes=" data-rule-range='1,12' data-msg-range='Month must be between 1 and 12.' ${analyticsAttr}" />
				</div>
				<div class="${xsCols} ${yearCols}">
					<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="${analyticsPrefix}Year" quoteChar="\"" /></c:set>
					<field_v2:input size="4" type="text" className="dateinput-year dontSubmit ${className}" xpath="${xpath}InputY" maxlength="4" pattern="[0-9]*" placeHolder="YYYY" required="${required}" requiredMessage="Please enter the year" additionalAttributes=" data-rule-range='1000,9999' data-msg-range='Year must be four numbers e.g. 2014.' ${analyticsAttr}" />
				</div>
				<div class="${calXSCols} col-sm-3 <c:if test="${not disableRowHack eq true}"> row-hack</c:if>"> <%-- special row hack to remove margins and hence allow us to squeeze into this size parent ---%>
					<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="${analyticsPrefix}Calendar" quoteChar="\"" /></c:set>
					<button tabindex="-1" id="${name}_button" type="button" class="input-group-addon-button date form-control" ${analyticsAttr}>
						<i class="icon-calendar" ${analyticsAttr}></i>
					</button>
				</div>
			</div>
			<div class="hidden select dateinput-nativePicker">
				<span class="input-group-addon"><i class="icon-calendar"></i></span>
				<input type="date" name="${name}Input" id="${name}Input" class="form-control dontSubmit" value="${value}" <c:if test="${not empty minDate}"> min="${minDate}"</c:if> <c:if test="${not empty maxDate}"> max="${maxDate}"</c:if> placeHolder="YYYY-MM-DD">
			</div>
			<field_v2:validatedHiddenField xpath="${xpath}" className="serialise hidden-datepicker" title="Please enter the ${title} date" additionalAttributes=" required ${calAdditionalAttributes} ${dateEurRule} ${minDateEurRule} ${maxDateEurRule} data-provide='datepicker' data-date-mode='${mode}' ${minDateAttribute} ${maxDateAttribute} " disableErrorContainer="${disableErrorContainer}" />
		</div>
	</c:when>
	<%-- A fallback warning if someone typo'd the mode name --%>
	<c:otherwise>
		<p style="color:red;">The mode attribute passed was not valid for the calendar tag</p>
	</c:otherwise>
</c:choose>