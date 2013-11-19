<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for Vehicle Selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false"  rtexprvalue="true"	 description="title of the select box" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="comms-calendar ${className}" title="Calendar"></div>


<%-- CSS --%>
<go:style marker="css-head">
.comms-calendar {
	min-with:380px;
}
</go:style>


<%-- JAVASCRIPT --%>
<go:script href="common/js/fullcalendar/fullcalendar.min.js" />
<go:script marker="js-head">
var commsCalendar = new Object();
commsCalendar = {
		init: function(){
			var date = new Date();
			var d = date.getDate();
			var m = date.getMonth();
			var y = date.getFullYear();
			var calendar = $('#${name}').fullCalendar({
				aspectRatio: 2,		
				header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,agendaWeek,agendaDay'
				},
				editable: true,
				selectable: true,
				selectHelper: true,
				select: function(start, end, allDay) {
					var title = prompt('Event Title:');
					if (title) {
						calendar.fullCalendar('renderEvent',
							{
								title: title,
								start: start,
								end: end,
								allDay: allDay
							},
							true // make the event "stick"
						);
					}
					calendar.fullCalendar('unselect');
				},				
				eventClick: function(calEvent, jsEvent, view) {
						var dat = {calEvent:calEvent, jsEvent:jsEvent, view:view};
				        FatalErrorDialog.display('Event: ' + calEvent.title, dat);
				        FatalErrorDialog.display('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY, dat);
				        FatalErrorDialog.display('View: ' + view.name, dat);
				
				        // change the border color just for fun
				        $(this).css('border-color', 'red');
				
				 },				
				eventSources: [ {
								url:'ajax/load/diary_entries.jsp',
								backgroundColor: '#86C65E',
								textColor:'white',
								borderColor:'#4E9733'	
								}]
			});
		},
		update: function() {
		 	$('#${name}').fullCalendar( 'refetchEvents' );		 	
			$('#${name}').fullCalendar( 'rerenderEvents' );
		}
};
</go:script>


<go:script marker="onready">
	commsCalendar.init();
</go:script>