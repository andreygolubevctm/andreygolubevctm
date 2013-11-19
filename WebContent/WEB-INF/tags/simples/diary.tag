<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for Vehicle Selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false"  rtexprvalue="true"	 description="title of the select box" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="comms-diary ${className}" title="Diary">
<div class="comms-diary-form" style="display:none;" title="Diary Entry"></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">
.comms-diary {
	min-with:380px;
}
</go:style>


<%-- JAVASCRIPT --%>
<go:script href="common/js/fullcalendar/fullcalendar.min.js" />
<go:script marker="js-head">
var commsDiary = new Object();
commsDiary = {
		init: function(){
			var date = new Date();
			var d = date.getDate();
			var m = date.getMonth();
			var y = date.getFullYear();
			var diary = $('#${name}').fullCalendar({
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
					commsDiary.formbox( {"commsId":0, "title":'Create new diary entry', "startDate":start, "endDate":end, "allDay":allDay }  );
					diary.fullCalendar('unselect');
				},				
				eventClick: function(calEvent, jsEvent, view) {				
						commsDiary.formbox( {"commsId":calEvent.id, "title":calEvent.title}  );			
				 },				
				eventSources: [ {
								url:'ajax/load/diary_entries.jsp',
								backgroundColor: '#86C65E',
								textColor:'white',
								borderColor:'#4E9733'	
								}],
				eventBackgroundColor: '#86C65E',
				eventTextColor:'white',
				eventBorderColor:'#4E9733'
			});
		},
		update: function() {
		 	$('#${name}').fullCalendar( 'refetchEvents' );		 	
			$('#${name}').fullCalendar( 'rerenderEvents' );
		},
		formbox: function(jsonData) {		
		   //calling the ajax form with the SQL	   
		   $.ajax({
			   type: 'GET',
		       async: false,
		       timeout: 30000,			   
			   url: "ajax/load/diary_entry.jsp",
			   data: $.param(jsonData),
			   dataType: "html",
			   async: false,
			   cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
			   error: function(){ FatalErrorDialog.display('Apologies: There was an error getting the messages', $.param(jsonData)) },
			   success: function(data){
				   if(data != undefined) {				   		
				   		$('.comms-diary-form').html(data).attr('title', jsonData.title).dialog({ width:560, modal: true } );
				   		//BIND THE EVENTS
				   		commsDiary.bind( $('.comms-diary-form') );
				   };
			   }		   
		   });
		},
		bind: function(obj) {
			$(obj).find('.all-day').change( function(){
	   			if( $(this).find(':checked').val() == 'Y' ) {
	   				$(obj).find('.timeEnd, .timeStart').fadeOut();
	   			} else {
	   				$(obj).find('.timeEnd, .timeStart').fadeIn();
	   			};
	   		});
	   		$(obj).find('.save').click( function(){ commsDiary.save(obj) });
			$(obj).find('.complete').click( function() { commsDiary.complete(obj); });			   			   					
		},
		save: function(obj){
		   //calling the ajax to save the form
		   var dat = $(obj).find('input,select,textarea,checkbox,radio').serialize();
		   $.ajax({
			   type: 'POST',
		       async: false,
		       timeout: 30000,			   
			   url: "ajax/write/comms_update_diary.jsp",
			   dataType: "json",
			   data: dat,
			   async: false,
			   cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
			   error: function(){ FatalErrorDialog.display('Apologies: There was an error saving your diary event', dat) },
			   success: function(data){
				   if(data != undefined && data.status == 'OK') {
				   	$(obj).dialog('close');
				   	commsDiary.update();
				   } else {
				   		FatalErrorDialog.display('error: ' + data.error, dat);
				   };
			   }		   
		   });		
		},
		complete: function(obj){
			   //calling the ajax to complete the form	 
			   var dat = $(obj).find('input').serialize();  
			   $.ajax({
				   type: 'POST',
			       async: false,
			       timeout: 30000,			   
				   url: "ajax/write/comms_completed.jsp",
				   dataType: "json",
				   data: dat,
				   async: false,
				   cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
				   error: function(){ FatalErrorDialog.display('Apologies: There was an error completing the diary event', dat) },
				   success: function(data){
					   if(data != undefined && data.status == 'OK') {
					   		$(obj).dialog('close');
					   		commsDiary.update();
					   } else {
					   		FatalErrorDialog.display('error: ' + data.error, dat);
					   };
				   }		   
			   });		
			}						
};
</go:script>


<go:script marker="onready">
	commsDiary.init();
	$('.comms-diary-new, #comms-menuBar li.new.diary').click( function() {
		<%-- Keeping the data as JSON as that's what's expected --%>
		commsDiary.formbox( {"commsId":"0", "title":"Create new diary entry"} );
	});
</go:script>