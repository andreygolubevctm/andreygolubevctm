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


<%-- JQUERY UI --%>
<go:script marker="jquery-ui">
	// Apply datepicker and rules
	var dates = $( "#${fromDate}, #${toDate}" ).datepicker({
		${showIconJS}
		numberOfMonths: 2,
		dateFormat: 'dd/mm/yy',
		yearRange: '+0Y:+2Y',
		onSelect: function( selectedDate ) {

			// new fix for TRV-8, extending the To Date to 1 year from the From Date
			var chosenDate = $("#${fromDate}").val().split('/');
			$("#${toDate}").datepicker( "option", "maxDate", new Date(parseInt(chosenDate[2])+1,parseInt(chosenDate[1]-1),parseInt(chosenDate[0])));

			$("#${toDate}").rules("remove", "maxToDate");
			$("#${toDate}").rules('add', {'maxToDate':parseInt(chosenDate[0])+'/'+(parseInt(chosenDate[1]))+'/'+(parseInt(chosenDate[2])+1), messages:{'maxToDate':'Return date can not be more than 1 year beyond the leaving date.'}});


			var option = this.id == "${fromDate}",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate(
					instance.settings.dateFormat ||
					$.datepicker._defaults.dateFormat,
					selectedDate, instance.settings );
			dates.not( this ).datepicker( "option", option, date );
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

	<c:if test="${prefill == 'true'}">
		// Set styles and initial dates
		$("#${fromDate}").val(get_todays_date(0));
		$("#${toDate}").val(get_todays_date(7));
	
		$("#${toDate},#${fromDate}").addClass('greyed');
	
		$("#${fromDate}").focus(function(){
			$("#${fromDate}").removeClass('greyed');
		});
		$("#${toDate}").focus(function(){
			$("#${toDate}").removeClass('greyed');
		});
	</c:if>


</go:script>


<%-- JS HEAD --%>
<go:script marker="js-href" href="common/js/utils.js" />
<go:script marker="js-head">
	function get_todays_date(dayOffset) {
		var MyDate = new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>,
								<fmt:formatDate value="${now}" type="DATE" pattern="MM"/>-1,
								<fmt:formatDate value="${now}" type="DATE" pattern="dd"/>);
		var MyDateString;
		MyDate.setDate(MyDate.getDate()+dayOffset);
		MyDateString = twoDigits(MyDate.getDate())
					+ '/' + twoDigits(MyDate.getMonth()+1)
					+ '/' + MyDate.getFullYear();
		return MyDateString;
	}
</go:script>

<go:style marker="css-head">
	.ui-datepicker {
		margin-left:0px;
		margin-top:0px;
	}
	.greyed{color:#999;}
	.help_icon{
		display:inline-block;
		margin-left:2px;
	}
</go:style>


<%-- JQUERY ONREADY --%>
<go:script marker="onready">
	var travelDateOffset = true;
	
	
	// Dates must be filled and toDate must be greater than fromDate
	$.validator.addMethod("toFromDates",
		function(value, element){
			if(date_gt_date($('#travel_dates_fromDate').val(), $('#travel_dates_toDate').val())){
				if(date_gt_date($('#travel_dates_fromDate').val(), $('#travel_dates_toDate').val(), 'toFromDates')){
				
					return true;
				}
			}
		},
		"Please enter valid dates."
	);
	
	$('#travel_dates_fromDate').focus(function() {
		travelDateFocus = false;
	});
	
	$('#travel_dates_fromDate').change(function() {
		var chosenDate = $("#${fromDate}").val().split('/');
		$("#${toDate}").datepicker( "option", "maxDate", new Date(parseInt(chosenDate[2])+1,parseInt(chosenDate[1]-1),parseInt(chosenDate[0])));
		$("#${toDate}").rules("remove", "maxToDate");
		$("#${toDate}").rules('add', {'maxToDate':parseInt(chosenDate[0])+'/'+(parseInt(chosenDate[1]))+'/'+(parseInt(chosenDate[2])+1), messages:{'maxToDate':'Return date can not be more than 1 year beyond the leaving date.'}});
	});

	$('#travel_dates_fromDate').blur(function(e){
		if(travelDateFocus){
			offset_to_date(7);
		}
	});
	
	$.validator.addMethod("minFromDate",
		function(value, element, param){
			if(date_gt_date(param, value)){
				return true;
			}
		},""
	);
	$.validator.addMethod("minToDate",
		function(value, element, param){
			if(date_gt_date(param, value)){
				return true;
			}
		},""
	);
	$.validator.addMethod("maxFromDate",
		function(value, element, param){
			if(date_gt_date(value, param)){
				return true;
			}
		},""
	);
	$.validator.addMethod("maxToDate",
		function(value, element, param){
			if(date_gt_date(value, param)){
				return true;
			}
		},""
	);
	
	$.validator.addMethod("fromToDate",
		function(value, element, param){
			toDate = $('#${toDate}').val();
			if(date_gt_date(value, toDate)){
				return true;
			}
		},""
	);

</go:script>
	

<%-- JS HEAD --%>
<go:script marker="js-head">

	function date2num(date_string){
		date_string = replaceAll(date_string, '/', '');
		return parseInt(date_string);
	}
	
	function date_gt_date(date1, date2){
		
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
		
	}
	
	function replaceAll(txt, replace, with_this) {
	  return txt.replace(new RegExp(replace, 'g'), with_this);
	}
	
	function get_today_date() {
		var MyDate = new Date();
		var MyDateString;
		MyDate.setDate(MyDate.getDate());
		MyDateString = MyDate.getFullYear()
					 +('0' + (MyDate.getMonth()+1)).slice(-2)
					 +('0' + MyDate.getDate()).slice(-2);
		return MyDateString;
	}
	
	function get_today_date_slashed() {
		var MyDate = new Date();
		var MyDateString;
		MyDate.setDate(MyDate.getDate());
		MyDateString = ('0' + MyDate.getDate()).slice(-2) + '/'
					  +('0' + (MyDate.getMonth()+1)).slice(-2)
					  + '/' + MyDate.getFullYear();
		return MyDateString;
	}
	
	function offset_to_date(offset_days){
		setTimeout("offset_date("+offset_days+")",150);
	}
	
	function offset_date(offset_days){
	
		d = $('#travel_dates_fromDate').val().split('/');
		var newDate=new Date();
		newDate.setFullYear(d[2],parseInt(d[1])-1,d[0]);
		newDate = new Date(newDate.getTime() + (86400000*parseInt(offset_days)))
		returnDateString = newDate.getDate()
					 +('/' + (newDate.getMonth()+1))
					 +('/' + newDate.getFullYear());
		$('#travel_dates_toDate').val(returnDateString);
		
	}

</go:script>


<%-- VALIDATION --%>
<go:validate selector="${fromDate}" rule="required" parm="${required}" message="Please enter a ${titleFrom} date"/>
<go:validate selector="${toDate}" rule="required" parm="${required}" message="Please enter a ${titleTo} date"/>

<go:validate selector="${fromDate}" rule="dateEUR" parm="${required}" message="Please enter a valid ${titleFrom} date in DD/MM/YYYY format"/>
<go:validate selector="${toDate}" rule="dateEUR" parm="${required}" message="Please enter a valid ${titleTo} date in DD/MM/YYYY format"/>

<go:validate selector="${fromDate}" rule="fromToDate" parm="'${required}'" message="The ${titleTo} date should be equal to or after the ${titleFrom} date" />

<c:if test="${minDate!=null}">
	<c:set var="errorMsg">
		<c:choose>
			<c:when test="${not empty minDateToday}">in the past</c:when>
			<c:otherwise>before the ${minDate}</c:otherwise>
		</c:choose>
	</c:set>
	<go:validate selector="${fromDate}" rule="minFromDate" parm="'${minDate}'" message="You can not select a ${titleFrom} date ${errorMsg}" />
	<go:validate selector="${toDate}" rule="minToDate" parm="'${minDate}'" message="You can not select a ${titleTo} date ${errorMsg}" />
</c:if>

<c:if test="${maxDate!=null}">
	<c:set var="errorMsg">
		<c:choose>
			<c:when test="${not empty maxDateToday}">in the future</c:when>
			<c:otherwise>after the ${maxDate}</c:otherwise>
		</c:choose>
	</c:set>
	<go:validate selector="${fromDate}" rule="maxFromDate" parm="'${maxDate}'" message="You can not select a ${titleFrom} date ${errorMsg}" />
	<go:validate selector="${toDate}" rule="maxToDate" parm="'${maxDate}'" message="You can not select a ${titleTo} date ${errorMsg}" />
</c:if>
