<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's date of birth."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 				required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="options" 			required="false" rtexprvalue="false" description="Some more potential datepicker options" %>
<%@ attribute name="addBusinessDays" 	required="false" rtexprvalue="false" description="If some business days need to be added to the minimum date" %>
<%@ attribute name="disableWeekends" 		required="false" rtexprvalue="false" description="Whether to disable the selection of weekends or not" %>
<%@ attribute name="disablePublicHolidays" 	required="false" rtexprvalue="false" description="Whether to disable the selection of public holidays or not" %>
<%@ attribute name="publicHolidaysCountry"	required="false" rtexprvalue="false" description="Number of Months to display" %>
<%@ attribute name="publicHolidaysRegion"	required="false" rtexprvalue="false" description="Number of Months to display" %>
<%@ attribute name="minDate" 				required="false" rtexprvalue="true"	 description="Minimum Date Value (DD/MM/YYYY) or 'today'"%>
<%@ attribute name="maxDate" 				required="false" rtexprvalue="true"	 description="Maximum Date Value (DD/MM/YYYY) or 'today'"%>
<%@ attribute name="numberOfMonths" 	required="false" rtexprvalue="false" description="Number of Months to display" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${not empty options}"><c:set var="options">,${options}</c:set></c:if>
<c:if test="${empty numberOfMonths}"><c:set var="numberOfMonths">2</c:set></c:if>
<c:if test="${empty minDate}">
	<fmt:formatDate value="${go:AddDays(now,1)}" var="tomorrow" type="date" pattern="dd/MM/yyyy"/>
</c:if>
<c:choose>
	<c:when test="${empty maxDate}">
		<c:set var="maxDate">null</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="maxDate">'${maxDate}'</c:set>
	</c:otherwise>
</c:choose>

<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- VALIDATION --%>
<c:if test="${not empty minDate or not empty tomorrow}">
	data-rule-earliestAvailableDate='${required}' data-msg-earliestAvailableDate="Please enter a valid date, use the date picker to see which dates are available"
</c:if>
<c:if test="${maxDate ne 'null'}">
	data-rule-latestAvailableDate='${required}' data-msg-latestAvailableDate="Please enter a valid date, use the date picker to see which dates are available"
</c:if>
<c:if test="${disableWeekends eq 'true'}">
	data-rule-notWeekends='${required}' data-msg-notWeekends="The ${title} has to be a business day (i.e. not on the weekend)"
</c:if>
<c:if test="${disablePublicHolidays eq 'true'}">
	data-rule-notPublicHolidays='${required}' data-msg-notPublicHolidays="The ${title} has to be a business day (i.e. not a public holiday)"
	<go:validate selector="${name}" rule="${name}notPublicHolidays" parm="${required}" message="The ${title} has to be a business day (i.e. not a public holiday)" />
</c:if>

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="basic_date ${className}" value="${value}" title="${title}" size="12" required="${required}" data-rule-dateEUR='${required}' data-msg-dateEUR="Please enter a valid date in DD/MM/YYYY format">

<%-- JQUERY UI --%>
<go:script marker="js-head">
	<c:choose>
		<c:when test="${maxDate eq 'null'}"><c:set var="publicHolidaysToDate" value="" /></c:when>
		<c:otherwise><c:set var="publicHolidaysToDate" value="${maxDate}" /></c:otherwise>
	</c:choose>

	var BasicDateHandler = new Object();
	var ${name}Handler = new Object();

	<%-- generic JS --%>
	BasicDateHandler = {
		AddBusinessDays: function(weekDaysToAdd) {

			var curdate = new Date();
			var realDaysToAdd = 0;
			while (weekDaysToAdd > 0){
				curdate.setDate(curdate.getDate()+1);
				realDaysToAdd++;
				//check if current day is business day
				if ($.datepicker.noWeekends(curdate)[0]) {
					weekDaysToAdd--;
				}
			}
			return realDaysToAdd;

		},

		isNotWeekEnd: function(date){
			return $.datepicker.noWeekends(date)[0];
		}
	}

	<%-- field specific JS --%>
	${name}Handler = {

		<c:if test="${disablePublicHolidays eq 'true' and not empty publicHolidaysCountry}">
			_publicHolidays: eval(<get:public_holidays country="${publicHolidaysCountry}" region="${publicHolidaysRegion}" format="dates" fromDate="${tomorrow}" toDate="${publicHolidaysToDate}" />),
		</c:if>

		isNotWeekendAndNotPublicHoliday: function(date){

			<%-- not the weekend --%>
			if ( BasicDateHandler.isNotWeekEnd(date) ) {
				<%-- check if public holiday --%>
				return ${name}Handler.isNotPublicHoliday(date);
			<%-- weekend --%>
			} else {
				return false;
			}

		},

		isNotPublicHoliday: function(date) {

			function pad (str, max) {
				return str.length < max ? pad("0" + str, max) : str;
			}

			var d = pad(date.getDate().toString(), 2);
			var m = pad((date.getMonth()+1).toString(), 2);
			var y = date.getFullYear();

			if($.inArray(d + '/' + m + '/' + y, ${name}Handler._publicHolidays) != -1) {
				return [false];
			}

			return [true];
		}
	}



</go:script>

<go:script marker="jquery-ui">
	<c:choose>
		<c:when test="${not empty addBusinessDays}">
			var minDate = new Date();
			var weekDays = ${name}Handler.AddBusinessDays(${addBusinessDays});
			minDate.setDate(minDate.getDate() + weekDays);
		</c:when>
		<c:when test="${not empty tomorrow}">var minDate = '${tomorrow}';</c:when>
		<c:otherwise>var minDate = '${minDate}';</c:otherwise>
	</c:choose>
	
	jQuery("#${name}").datepicker({
		firstDay: 1,
		minDate: minDate,
		maxDate: ${maxDate},
		dateFormat: 'dd/mm/yy',
		numberOfMonths: ${numberOfMonths},
		yearRange: '+0Y:+3Y',
		constrainInput: true,
		autoSize: true,
		showAnim: 'blind',
		showOn: 'both',
        buttonImage: "common/images/calendar.gif",
        buttonImageOnly: true,
		<c:choose>
			<c:when test="${disableWeekends eq 'true' and disablePublicHolidays eq 'true' and not empty publicHolidaysCountry}">beforeShowDay: ${name}Handler.isNotWeekendAndNotPublicHoliday,</c:when>
			<c:when test="${disablePublicHolidays eq 'true' and not empty publicHolidaysCountry}">beforeShowDay: ${name}Handler.isNotPublicHoliday,</c:when>
			<c:when test="${disableWeekends eq 'true'}">beforeShowDay: $.datepicker.noWeekends,</c:when>
		</c:choose>
		onClose: function() {
			$(this).valid();
	  	}
	  	${options}
	});


</go:script>

<go:script marker="onready">
try {
	$("img.ui-datepicker-trigger").each(function(){
		if( $(this).attr("alt") == "..." ) {
			$(this).removeAttr("alt");
		}
		if( $(this).attr("title") == "..." ) {
			$(this).removeAttr("title");
		}
	});
} catch(e) { /* ignore */ }
</go:script>

<go:style marker="css-head">
	#${name} {
		margin-right: 5px;
	}
	
	.ui-datepicker {
		margin-left:0px;
		margin-top:0px;
	}
</go:style>