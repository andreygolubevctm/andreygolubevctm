<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's date of birth."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 				required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 			required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 				required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="options" 			required="false" rtexprvalue="false" description="Some more potential datepicker options" %>
<%@ attribute name="addBusinessDays" 	required="false" rtexprvalue="false" description="If some business days need to be added to the minimum date" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${not empty options}"><c:set var="options">,${options}</c:set></c:if>

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="basic_date" value="${data[xpath]}" title="${title}" size="12">

<%-- JQUERY UI --%>
<go:script marker="js-head">
	var BasicDateHandler = new Object();
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
		}
	}
</go:script>

<go:script marker="jquery-ui">
	<c:choose>
		<c:when test="${not empty addBusinessDays}">
			var minDate = new Date();
			var weekDays = BasicDateHandler.AddBusinessDays(${addBusinessDays});
			minDate.setDate(minDate.getDate() + weekDays);
		</c:when>
		<c:otherwise>var minDate = '+1d';</c:otherwise>
	</c:choose>
	
	jQuery("#${name}").datepicker({
		minDate: minDate,
		dateFormat: 'dd/mm/yy',
		numberOfMonths: 2,
		yearRange: '+0Y:+3Y',
		constrainInput: true,
		autoSize: true,
		showAnim: 'blind',
		showOn: 'both',
        buttonImage: "common/images/calendar.gif",
        buttonImageOnly: true,
		onClose: function() {
			$(this).valid();
	  	}
	  	${options}
	});
	jQuery("#${name}").click(function(){
		jQuery("#${name}").val('');
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

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="dateEUR" parm="${required}" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter ${title}"/>
