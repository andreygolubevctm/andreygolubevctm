<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Calendar that can be controlled by an object - uses days only as date ranges"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<form:row label="What date would you like your cover to start">
	<field:basic_date xpath="${xpath}/start" title="start date" required="true" className="health-payment_details-start" /><!--<label class="calendar ui-datepicker-trigger" for="${name}_start"><img src="common/images/calendar.gif" /></label>-->
</form:row>


<%-- CSS --%>
<go:script marker="js-head">
healthCalendar = {
	reset: function(){
		this._min = 0;
		this._max = 90;
		this.update();
		return;
	},
	update: function(){
		$('#${name}_start').datepicker('option', {
			'minDate':'+'+ healthCalendar._min  +'d',
			'maxDate':'+'+ healthCalendar._max  +'d',
			'yearRange':'+'+ healthCalendar._min  +'d:+'+ healthCalendar._max  +'d'
		});
		
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
	},
	<%-- Allow the updating of the crucial dates --%>
	setDates: function(_min, _max){
		if( _min < _max ){
			return false;
		} else {
			this._min = _min;
			this._max = _max;
		};
		this.update();
	}
};

$.validator.addMethod("calendarDates",
	function(value, element) {
		<%-- set the date variables --%>		
		var maxDate = new Date();
			maxDate.setDate( maxDate.getDate() + (healthCalendar._max) );
			maxDate.setHours(23,59,59); //latest possible time of that day
		var minDate = new Date();
			minDate.setDate( minDate.getDate() + (healthCalendar._min - 1) );
		var chosenDate = $(element).datepicker('getDate');
		
		if( (maxDate < chosenDate) || (minDate > chosenDate) ){
			return false;
		} else {
			return true;
		};
		
	},
	"Custom message"
);
</go:script>

<go:script marker="onready">
	healthCalendar.reset();
</go:script>

<go:validate selector="${name}_start" rule="calendarDates" parm="true" message="Please select a date within the calendar range" />