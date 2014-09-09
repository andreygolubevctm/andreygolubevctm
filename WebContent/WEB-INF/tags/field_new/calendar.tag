<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a DD MM YYYY field with a date picker or inline calendar."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 					required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 				required="true"	 rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" 				required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="mobileClassName" 		required="false" rtexprvalue="true"	 description="additional css class attribute for mobile" %>
<%@ attribute name="title" 					required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="minDate" 				required="false" rtexprvalue="true"	 description="Minimum Inclusive Date Value (rfc3339 yyyy-MM-dd) (or strings supported by the JS bootstrap-datepicker control for mode of component ONLY)"%>
<%@ attribute name="maxDate" 				required="false" rtexprvalue="true"	 description="Maximum Inclusive Date Value (rfc3339 yyyy-MM-dd) (or strings supported by the JS bootstrap-datepicker control for mode of component ONLY)"%>
<%@ attribute name="validateMinMax" 		required="false" rtexprvalue="true"	 description="Validate Min Max values passed in - Defaults to True (should be set to false to disable range validation when using the strings supported by the JS bootstrap-datepicker)"%>
<%@ attribute name="startView" 				required="false" rtexprvalue="true"	 description="The view either 0:Month|1:Year|2:Decade|"%>
<%@ attribute name="mode"	 				required="false" rtexprvalue="true"	 description="Component: Display as input with a click bound calendar. Inline: embedded calendar (with hidden field). Separated: DD MM YYYY inputs with a calendar click bound button and hidden input."%>
<%@ attribute name="nonLegacy" 				required="false" rtexprvalue="true"	 description="If the component is non legacy, format the dates as to be expected. So that Min/Max validation works."%>


<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<fmt:formatDate var="todayDateEuro" value="${now}" pattern="dd/MM/yyyy" />

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
		<field_new:validatedHiddenField xpath="${xpath}" className="${className}" title="Please enter the ${title}" validationErrorPlacementSelector="#${name}_calendar" />
	</c:when>
	<%--
		The calendar input picker's default component mode:
		http://eternicode.github.io/bootstrap-datepicker/?markup=component&format=dd%2Fmm%2Fyyyy&weekStart=1&startDate=today&endDate=%2B1m&startView=0&minViewMode=0&todayBtn=false&language=en&orientation=auto&multidate=&multidateSeparator=&autoclose=on&todayHighlight=on&forceParse=on#sandbox
	--%>
	<c:when test="${mode eq 'component'}">
		<%-- This was the old usage in the platform --%>
		<%-- Exposed some attributes here so the tag define a few JS settings --%>
		<div class="input-group date ${mobileClassName}" data-provide="datepicker" data-date-mode="${mode}"
			${maxDateAttribute}
			${minDateAttribute} data-date-start-view="${startView}">
			<input type="text"
				placeHolder="DD/MM/YYYY"
				name="${name}"
				id="${name}"
				class="form-control dateinput-date ${className}"
				value="${value}"
				title="${title}" ${requiredAttribute}>
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
		<div class="dateinput_container" data-provide="dateinput">
			<div class="row dateinput-tripleField withDatePicker">
				<div class="col-xs-4 col-sm-3 col-md-3 ">
					<field_new:input type="text" size="2" className="dateinput-day dontSubmit ${className}" xpath="${xpath}InputD" maxlength="2" pattern="[0-9]*" placeHolder="DD" required="${required}" requiredMessage="Please enter the day" />
				</div>
				<div class="col-xs-4 col-sm-3 col-md-3 row-hack"> <%-- special row hack to remove margins and hence allow us to squeeze into this size parent ---%>
					<field_new:input size="2" type="text" className="dateinput-month dontSubmit ${className}" xpath="${xpath}InputM" maxlength="2" pattern="[0-9]*" placeHolder="MM" required="${required}" requiredMessage="Please enter the month" />
				</div>
				<div class="col-xs-4 col-sm-5 col-md-4">
					<field_new:input size="4" type="text" className="dateinput-year dontSubmit ${className}" xpath="${xpath}InputY" maxlength="4" pattern="[0-9]*" placeHolder="YYYY" required="${required}" requiredMessage="Please enter the year" />
				</div>
				<div class="hidden-xs col-sm-3 col-md-3 row-hack"> <%-- special row hack to remove margins and hence allow us to squeeze into this size parent ---%>
					<button tabindex="-1" id="${name}_button" type="button" class="input-group-addon-button date form-control">
						<i class="icon-calendar"></i>
					</button>
				</div>
			</div>
			<div class="hidden select dateinput-nativePicker">
				<span class="input-group-addon"><i class="icon-calendar"></i></span>
				<input type="date" name="${name}Input" id="${name}Input" class="form-control dontSubmit" value="${value}" min="${minDate}" max="${maxDate}" placeHolder="YYYY-MM-DD">
			</div>
			<field_new:validatedHiddenField attributeInjection='data-provide="datepicker" data-date-mode="${mode}" ${minDateAttribute} ${maxDateAttribute}' xpath="${xpath}" className="serialise hidden-datepicker" required="${required}" title="Please enter the ${title} date" />
		</div>
	</c:when>
	<%-- A fallback warning if someone typo'd the mode name --%>
	<c:otherwise>
		<p style="color:red;">The mode attribute passed was not valid for the calendar tag</p>
	</c:otherwise>
</c:choose>


<%-- VALIDATION --%>
<go:validate selector="${name}InputD" rule="range" parm="[1,31]" message="Day must be between 1 and 31" />
<go:validate selector="${name}InputM" rule="range" parm="[1,12]" message="Month must be between 1 and 12" />
<go:validate selector="${name}InputY" rule="range" parm="[1000,9999]" message="Year must be four numbers e.g. 2014" />
<go:validate selector="${name}" rule="dateEUR" parm="${required}" message="Please enter a valid ${title} date for DD MM YYYY"/>

<c:if test="${not empty minDateEuro and validateMinMax == true}">
	<go:log>${name} : ${minDateEuro}</go:log>
	<go:validate selector="${name}" rule="minDateEUR" parm="'${minDateEuro}'" message="Please enter a date on or after ${todayDateEuro == minDateEuro ? 'today’s date' : minDateEuro}" />
</c:if>
<c:if test="${not empty maxDateEuro and validateMinMax == true}">
	<go:log>${name} : ${maxDateEuro}</go:log>
	<go:validate selector="${name}" rule="maxDateEUR" parm="'${maxDateEuro}'" message="Please enter a date on or before ${todayDateEuro == maxDateEuro ? 'today’s date' : maxDateEuro}" />
</c:if>