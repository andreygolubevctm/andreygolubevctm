<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="A pair of date selectors representing a date range."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 		required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 		required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="inputClassName"	required="false" rtexprvalue="true"	 description="additional css class attribute for the input field" %>
<%@ attribute name="labelFrom" 		required="true"	 rtexprvalue="true"	 description="The label of the fromDate field (e.g. 'Departure Date')"%>
<%@ attribute name="labelTo" 		required="true"	 rtexprvalue="true"	 description="The label of the toDate field (e.g. 'Return Date')"%>
<%@ attribute name="titleFrom" 		required="true"	 rtexprvalue="true"	 description="The name/function of the fromDate field (e.g. 'departure')"%>
<%@ attribute name="titleTo" 		required="true"	 rtexprvalue="true"	 description="The name/function of the toDate field (e.g. 'return')"%>
<%@ attribute name="showIcon" 		required="false" rtexprvalue="true"	 description="Specifies if the calendar icon is to be shown (eg. 'true')"%>
<%@ attribute name="iconImageOnly" 	required="false" rtexprvalue="true"	 description="if the calendar icon is to be shown as an image only instead of included in a button (eg. 'true')"%>
<%@ attribute name="helpIdFrom" 	required="false" rtexprvalue="true"	 description="ID for help icon - from date"%>
<%@ attribute name="helpIdTo" 		required="false" rtexprvalue="true"	 description="ID for help icon - to date"%>
<%@ attribute name="helpClassName" 	required="false" rtexprvalue="true"	 description="Extra CSS class for the help icon"%>
<%@ attribute name="minDate" 		required="false" rtexprvalue="true"	 description="Minimum Date Value (DD/MM/YYYY) or 'today'"%>
<%@ attribute name="maxDate" 		required="false" rtexprvalue="true"	 description="Maximum Date Value (DD/MM/YYYY) or 'today'"%>
<%@ attribute name="prefill" 		required="false" rtexprvalue="true"	 description="if the field should be prefilled with current day and next week's date"%>
<%@ attribute name="minDateValidity"	required="false" rtexprvalue="true"	 description="Extra Time we can dynamically add to the calendar mindate based on the maxDate changing. Format: xY yM zD (eg 1Y 3M 15D) "%>
<%@ attribute name="maxDateValidity"	required="false" rtexprvalue="true"	 description="Extra Time we can dynamically add to the calendar maxdate based on the minDate changing. Format: xY yM zD (eg 1Y 3M 15D)"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="fromDateXpath" value="${xpath}/fromDate" />
<c:set var="toDateXpath" value="${xpath}/toDate" />
<c:set var="fromDate" value="${go:nameFromXpath(fromDateXpath)}" />
<c:set var="toDate" value="${go:nameFromXpath(toDateXpath)}" />
<c:set var="showIconJS">
	<c:if test="${showIcon=='true'}">showOn:'both',buttonImage:'common/images/calendar.gif',</c:if>
	<c:if test="${iconImageOnly=='true'}">buttonImageOnly:true,</c:if>
</c:set>

<c:set var="minDateValidity">
	<c:choose>
		<c:when test="${minDateValidity!=null}">${minDateValidity}</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>
<c:set var="maxDateValidity">
	<c:choose>
		<c:when test="${maxDateValidity!=null}">${maxDateValidity}</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>
<c:set var="prefill">
	<c:choose>
		<c:when test="${prefill!=null}">${prefill}</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>
<%-- HTML --%>
<form:row label="${labelFrom}" className="${className}">
	<c:if test="${helpIdFrom!=null}">
		<div class="help_icon <c:if test='${helpClassName!=null}'>${helpClassName}</c:if>" id="help_${helpIdFrom}"></div>
	</c:if>
	<input type="text" name="${fromDate}" id="${fromDate}" class="${inputClassName}" value="${data[fromDateXpath]}" title="${labelFrom}">
</form:row>
<form:row label="${labelTo}" className="${className}">
	<c:if test="${helpIdTo!=null}">
		<div class="help_icon <c:if test='${helpClassName!=null}'>${helpClassName}</c:if>" id="help_${helpIdTo}"></div>
	</c:if>
	<input type="text" name="${toDate}" id="${toDate}" class="${inputClassName}" value="${data[toDateXpath]}" title="${labelTo}">
</form:row>

<%-- CSS --%>
<go:style marker="css-head">
	.ui-datepicker {
		margin-left:0px;
		margin-top:0px;
	}
	.greyed{
		color:#999 !important;
	}
	.help_icon{
		display:inline-block;
		margin-left:2px;
	}
</go:style>

<%-- JS HEAD --%>
<go:script marker="js-href" href="common/js/utils.js" />
<go:script marker="js-head">

	var ${name}_date_range = new Object();
	${name}_date_range = {
		_prefill : ${prefill},
		_dates : null,
		_minDate : '${minDate}',
		_maxDate : '${maxDate}',
		_minDateValidity : '${minDateValidity}',
		_maxDateValidity : '${maxDateValidity}',
		_minDateValidityYear : 0,
		_minDateValidityMonth : 0,
		_minDateValidityDay : 0,
		_minDateValidityParsed : '',
		_maxDateValidityYear : 0,
		_maxDateValidityMonth : 0,
		_maxDateValidityDay : 0,
		_maxDateValidityParsed : '',

		newDatePicker : function () {
			dates = $( "#${fromDate}, #${toDate}" ).datepicker({
		${showIconJS}
		numberOfMonths: 2,
		dateFormat: 'dd/mm/yy',
		yearRange: '+0Y:+2Y',
				duration: 'fast',
		onSelect: function( selectedDate ) {


			var option = this.id == "${fromDate}",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate(
					instance.settings.dateFormat ||
					$.datepicker._defaults.dateFormat,
					selectedDate, instance.settings );
			dates.not( this ).datepicker( "option", option, date );

					if (${name}_date_range._minDateValidity != "false"){
						${name}_date_range.validate_minDate();
					}
					if (${name}_date_range._maxDateValidity != "false"){
						${name}_date_range.validate_maxDate();
					}
				},
				onClose: function(){
					if($( "#${fromDate}, #${toDate}" ).hasClass("error")){
						$( "#${fromDate}, #${toDate}" ).valid();
					}
				}
	});
	<c:if test="${minDate != null}">
		<c:if test="${minDate == 'today'}">
			<fmt:formatDate value="${now}" var="minDate" type="date" pattern="dd/MM/yyyy"/>
			<c:set var="minDateToday" value="true" />
		</c:if>
		<fmt:parseDate var="dateM" type="date" value="${minDate}" pattern="dd/MM/yyyy" parseLocale="en_GB"/>
		$(dates).datepicker( "option", "minDate", new Date(
			<fmt:formatDate type="date" pattern="yyyy" value="${dateM}"/>,
			<fmt:formatDate type="date" pattern="MM" value="${dateM}"/>-1,
			<fmt:formatDate type="date" pattern="dd" value="${dateM}"/>
		));
	</c:if>
	<c:if test="${maxDate != null}">
		<c:if test="${maxDate == 'today'}">
			<fmt:formatDate value="${now}" var="maxDate" type="date" pattern="dd/MM/yyyy"/>
			<c:set var="mxDateToday" value="true" />
		</c:if>
		<fmt:parseDate var="dateM" type="date" value="${maxDate}" pattern="dd/MM/yyyy" parseLocale="en_GB" />
		$(dates).datepicker( "option", "maxDate", new Date(
			<fmt:formatDate type="date" pattern="yyyy" value="${dateM}"/>,
			<fmt:formatDate type="date" pattern="MM" value="${dateM}"/>-1,
			<fmt:formatDate type="date" pattern="dd" value="${dateM}"/>
		));
	</c:if>
		},
		init: function(){
			${name}_date_range.newDatePicker();
			${name}_date_range.parseValidPeriods(${name}_date_range._minDateValidity, 'minDate');
			${name}_date_range.parseValidPeriods(${name}_date_range._maxDateValidity, 'maxDate');
			${name}_date_range.format_DateValidity();

			$('#${fromDate}').focus(function() {
				fromDateFocus = false;
			});
			if (${name}_date_range._maxDateValidity != "false"){
				$('#${toDate}').change(function(){
					${name}_date_range.validate_maxDate();
				});
			}
			if (${name}_date_range._minDateValidity != "false"){
				$('#${fromDate}').change(function(){
					${name}_date_range.validate_minDate();
				});
			}

			$('#${fromDate}').blur(function(e){
				if(fromDateFocus){
					${name}_date_range.offset_to_date(7);
				}
			});

			if (${name}_date_range._prefill == true){
		// Set styles and initial dates
				$("#${fromDate}").val(${name}_date_range.get_todays_date(0));
				$("#${toDate}").val(${name}_date_range.get_todays_date(7));
	
		$("#${toDate},#${fromDate}").addClass('greyed');
	
		$("#${fromDate}").focus(function(){
			$("#${fromDate}").removeClass('greyed');
		});
		$("#${toDate}").focus(function(){
			$("#${toDate}").removeClass('greyed');
		});
			}
		},
		parseValidPeriods : function (value, type) {
			value = value.toLowerCase();
			var values = value.split(" ");
			for(i=0; i < values.length; i++){
				if (type == "minDate"){
					if (values[i].indexOf("y") != -1){		var finalVal = values[i].split("y"); ${name}_date_range._minDateValidityYear 	= parseInt(finalVal[0], 10);}
					else if (values[i].indexOf("m") != -1){	var finalVal = values[i].split("m"); ${name}_date_range._minDateValidityMonth 	= parseInt(finalVal[0], 10);}
					else if (values[i].indexOf("d") != -1){	var finalVal = values[i].split("d"); ${name}_date_range._minDateValidityDay 	= parseInt(finalVal[0], 10);}
				}
				else if (type == "maxDate"){
					if (values[i].indexOf("y") != -1){		var finalVal = values[i].split("y"); ${name}_date_range._maxDateValidityYear 	= parseInt(finalVal[0], 10);}
					else if (values[i].indexOf("m") != -1){	var finalVal = values[i].split("m"); ${name}_date_range._maxDateValidityMonth 	= parseInt(finalVal[0], 10);}
					else if (values[i].indexOf("d") != -1){	var finalVal = values[i].split("d"); ${name}_date_range._maxDateValidityDay 	= parseInt(finalVal[0], 10);}
				}
			}

		},
		format_DateValidity : function () {
			var minDate = "";
			var maxDate = "";

			if (${name}_date_range.check_gt_one(${name}_date_range._minDateValidityYear)) 	{
				minDate = ${name}_date_range._minDateValidityYear + " year" + ${name}_date_range.check_plural(${name}_date_range._minDateValidityYear);
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._minDateValidityYear) && ${name}_date_range.check_gt_one(${name}_date_range._minDateValidityMonth)) 	{
				minDate = minDate + " ,";
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._minDateValidityMonth)) 	{
				minDate = minDate + ${name}_date_range._minDateValidityMonth + " month" + ${name}_date_range.check_plural(${name}_date_range._minDateValidityMonth);
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._minDateValidityDay) && ${name}_date_range.check_gt_one(${name}_date_range._minDateValidityMonth)) 	{
				minDate = minDate + " ,";
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._minDateValidityDay)) 	{
				minDate = minDate + ${name}_date_range._minDateValidityDay 	+ " day" + ${name}_date_range.check_plural(${name}_date_range._minDateValidityDay);
			}

			if (${name}_date_range.check_gt_one(${name}_date_range._maxDateValidityYear)) 	{
				maxDate = ${name}_date_range._maxDateValidityYear + " year" + ${name}_date_range.check_plural(${name}_date_range._maxDateValidityYear);
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._maxDateValidityYear) && ${name}_date_range.check_gt_one(${name}_date_range._maxDateValidityMonth)) 	{
				maxDate = maxDate + " ,";
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._maxDateValidityMonth)) 	{
				maxDate = maxDate + ${name}_date_range._maxDateValidityMonth + " month" + ${name}_date_range.check_plural(${name}_date_range._maxDateValidityMonth);
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._maxDateValidityDay) && ${name}_date_range.check_gt_one(${name}_date_range._maxDateValidityMonth)) 	{
				maxDate = maxDate + " ,";
			}
			if (${name}_date_range.check_gt_one(${name}_date_range._maxDateValidityDay)) 	{
				maxDate = maxDate + ${name}_date_range._maxDateValidityDay 	+ " day" + ${name}_date_range.check_plural(${name}_date_range._maxDateValidityDay);
			}
			${name}_date_range._minDateValidityParsed = minDate;
			${name}_date_range._maxDateValidityParsed = maxDate;
		},
		get_todays_date: function (dayOffset) {
		var MyDate = new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>,
								<fmt:formatDate value="${now}" type="DATE" pattern="MM"/>-1,
								<fmt:formatDate value="${now}" type="DATE" pattern="dd"/>);
		var MyDateString;
		MyDate.setDate(MyDate.getDate()+dayOffset);
		MyDateString = twoDigits(MyDate.getDate())
					+ '/' + twoDigits(MyDate.getMonth()+1)
					+ '/' + MyDate.getFullYear();
		return MyDateString;
		},
		offset_to_date : function (offset_days){
			setTimeout("${name}_date_range.offset_date("+offset_days+")",150);
		},

		offset_date : function (offset_days){
			d = $('#${fromDate}').val().split('/');
			var newDate=new Date();
			newDate.setFullYear(d[2],parseInt(d[1])-1,d[0]);
			newDate = new Date(newDate.getTime() + (86400000*parseInt(offset_days)))
			returnDateString = newDate.getDate()
						+('/' + (newDate.getMonth()+1))
						+('/' + newDate.getFullYear());
			$('#${toDate}').val(returnDateString);

		},
		validate_maxDate : function () {
			var chosenDate = $("#${fromDate}").val().split('/');
			var newYear = parseInt(chosenDate[2],10)+${name}_date_range._maxDateValidityYear;
			var newMonth = parseInt(chosenDate[1],10)-1+${name}_date_range._maxDateValidityMonth;
			var newDay = parseInt(chosenDate[0],10)+${name}_date_range._maxDateValidityDay;
			var newTitleTo = ${name}_date_range.capitaliseFirstLetter('${titleTo}');
			$("#${toDate}").datepicker( "option", "maxDate", new Date(newYear, newMonth, newDay));
			$("#${toDate}").rules("remove", "${name}_maxToDate");
			$("#${toDate}").rules('add', {'${name}_maxToDate':${name}_date_range.twoDigits(newDay)+'/'+${name}_date_range.twoDigits(newMonth+1)+'/'+newYear, messages:{'${name}_maxToDate':newTitleTo +' date can not be more than '+${name}_date_range._maxDateValidityParsed+' beyond the ${titleFrom} date.'}});
		},
		validate_minDate : function () {
		var chosenDate = $("#${fromDate}").val().split('/');
			var newYear = parseInt(chosenDate[2],10)+${name}_date_range._minDateValidityYear;
			var newMonth = parseInt(chosenDate[1],10)-1+${name}_date_range._minDateValidityMonth;
			var newDay = parseInt(chosenDate[0],10)+${name}_date_range._minDateValidityDay;
			var newTitleTo = ${name}_date_range.capitaliseFirstLetter('${titleTo}');
			$("#${toDate}").datepicker( "option", "minDate", new Date(newYear, newMonth, newDay));
			$("#${toDate}").rules("remove", "${name}_minToDate");
			$("#${toDate}").rules('add', {'${name}_minToDate':${name}_date_range.twoDigits(newDay)+'/'+${name}_date_range.twoDigits(newMonth+1)+'/'+newYear, messages:{'${name}_minToDate':newTitleTo +' date can not be more than '+${name}_date_range._minDateValidityParsed+' beyond the ${titleFrom} date.'}});
		},
		twoDigits : function (string) {
			string = string.toString();
			var length = string.length;
			if (string.length < 2) {
				return "0"+string;
			}
			else {
				return string;
			}
		},
		check_gt_one : function (string) {
			if (string > 0 ) {
				return true;
	}
		},
		check_plural : function (string){
			if (string > 1){
				return "s";
	}
			else {
				return "";
	}
		},
		date_gt_date : function (date1, date2){

			// Parse dates first
			d1 = date1.split('/');
			d2 = date2.split('/');

			// Prepend leading zeros
			for(var i=0;i<3;i++){
				if(parseInt(d1[i])<10 && d1[i].indexOf('0')==-1) d1[i]='0'+d1[i];
				if(parseInt(d2[i])<10 && d2[i].indexOf('0')==-1) d2[i]='0'+d2[i];
			}

			// Return true if Date 2 >= Date 1
			var datenum1 = parseInt(d1[2]+d1[1]+d1[0]);
			var datenum2 = parseInt(d2[2]+d2[1]+d2[0]);
			if(datenum2 >= datenum1){
				return true;
			}else{
				return false;
			}
	
		},
		capitaliseFirstLetter : function (string){
			return string.charAt(0).toUpperCase() + string.slice(1);
				}
			}
</go:script>
<%-- JQUERY UI --%>
	
<go:script marker="onready">

	${name}_date_range.init();

	$.validator.addMethod("${name}_minFromDate",
		function(value, element, param){
			if(${name}_date_range.date_gt_date(param, value)){
				return true;
			}
		},""
	);
	$.validator.addMethod("${name}_minToDate",
		function(value, element, param){
			if(${name}_date_range.date_gt_date(param, value)){
				return true;
			}
		},""
	);
	$.validator.addMethod("${name}_maxFromDate",
		function(value, element, param){
			if(${name}_date_range.date_gt_date(value, param)){
				return true;
			}
		},""
	);
	$.validator.addMethod("${name}_maxToDate",
		function(value, element, param){
			if(${name}_date_range.date_gt_date(value, param)){
				return true;
			}
		},""
	);
	
	$.validator.addMethod("${name}_fromToDate",
		function(value, element, param){
			toDate = $('#${toDate}').val();
			if(${name}_date_range.date_gt_date(value, toDate)){
				return true;
			}
		},""
	);
	// Dates must be filled and toDate must be greater than fromDate
	$.validator.addMethod("${name}_toFromDates",
		function(value, element){
			if(${name}_date_range.date_gt_date($('#${fromDate}').val(), $('#${toDate}').val())){
				if(${name}_date_range.date_gt_date($('#${fromDate}').val(), $('#${toDate}').val(), '${name}_toFromDates')){
			return true;
		}
	}
		},
		"Please enter valid dates."
	);
</go:script>
	
	
		



<!-- VALIDATION -->
<go:validate selector="${fromDate}" rule="required" parm="${required}" message="Please enter the ${titleFrom} date"/>
<go:validate selector="${toDate}" rule="required" parm="${required}" message="Please enter the ${titleTo} date"/>

<go:validate selector="${fromDate}" rule="dateEUR" parm="${required}" message="Please enter a valid ${titleFrom} date in DD/MM/YYYY format"/>
<go:validate selector="${toDate}" rule="dateEUR" parm="${required}" message="Please enter a valid ${titleTo} date in DD/MM/YYYY format"/>

<go:validate selector="${fromDate}" rule="${name}_fromToDate" parm="'${required}'" message="The ${titleTo} date should be equal to or after the ${titleFrom} date" />

<c:if test="${minDate!=null}">
	<c:set var="errorMsg">
		<c:choose>
			<c:when test="${not empty minDateToday}">in the past</c:when>
			<c:otherwise>before the ${minDate}</c:otherwise>
		</c:choose>
	</c:set>
	<go:validate selector="${fromDate}" rule="${name}_minFromDate" parm="'${minDate}'" message="You cannot select a ${titleFrom} date ${errorMsg}" />
	<go:validate selector="${toDate}" rule="${name}_minToDate" parm="'${minDate}'" message="You cannot select a ${titleTo} date ${errorMsg}" />
</c:if>

<c:if test="${maxDate!=null}">
	<c:set var="errorMsg">
		<c:choose>
			<c:when test="${not empty maxDateToday}">in the future</c:when>
			<c:otherwise>after the ${maxDate}</c:otherwise>
		</c:choose>
	</c:set>
	<go:validate selector="${fromDate}" rule="${name}_maxFromDate" parm="'${maxDate}'" message="You cannot select a ${titleFrom} date ${errorMsg}" />
	<go:validate selector="${toDate}" rule="${name}_maxToDate" parm="'${maxDate}'" message="You cannot select a ${titleTo} date ${errorMsg}" />
</c:if>
