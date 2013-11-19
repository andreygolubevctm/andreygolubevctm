<%@ tag language="java" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="now" class="java.util.Date" />

<%@ attribute name="countId" 		required="true"   rtexprvalue="true" description="Current ID count. Must be a unique number. Eg. 0, 1, 2..." %>
<%@ attribute name="className" 		required="false"  rtexprvalue="true" description="Custom Class to apply to the container" %>
<%@ attribute name="hideSeparator" 	required="false"  rtexprvalue="true" description="Set to hide the separating line under the fields" %>
<%@ attribute name="hideAdd" 		required="false"  rtexprvalue="true" description="Set to hide the Add Another link" %>
<%@ attribute name="xpath" 			required="true"  rtexprvalue="true" description="Set the xpath base" %>

<%-- HTML --%>

	<div id="motoringOffences_${countId}" class="additional motoringOffences <c:if test="${className!=null}"> ${className}</c:if>">
	
		<div class="additional_head additional_motoringOffences_head">
			<div class="col1">Driver</div>
			<div class="col2">Date of Offence</div>
			<div class="col3">Demerit Points</div>
			<div class="col4">Details</div>
			<core:clear />
		</div>

		<div class="additional_row additional_motoringOffences_row">
			<div class="col1"><field:array_select className="driver_dropdown" items="" xpath="${xpath}/driver" title="Driver" required="true" /></div>
			<div class="col2 hide_date_label"><field:date_text_entry xpath="${xpath}/date" title="Offence" required="true" /></div>
			<div class="col3"><field:input xpath="${xpath}/demeritPoints" title="Demerit Points" className="demerit_points" required="true" maxlength="2" /></div>
			<div class="col4"><field:input xpath="${xpath}/details" title="Details" required="true" maxlength="200" /></div>
			<core:clear />
		</div>
		
		<c:if test="${hideAdd==null || hideAdd=='false'}">
			<core:clear />
			<a href="javascript:;" id="add_motoringOffences_${countId}" class="add_link add_motoringOffences">Add another</a>
		</c:if>
		<a href="javascript:;" id="remove_motoringOffences_${countId}" class="remove_link remove_motoringOffences">Remove</a>
		<core:clear />
		
	</div>



<%-- STYLES --%>
<go:style marker="css-head">
	.additional_motoringOffences_head .col1, .additional_motoringOffences_row .col1{float:left; width:155px;}
	.additional_motoringOffences_head .col2, .additional_motoringOffences_row .col2{float:left; width:115px;}
	.additional_motoringOffences_head .col3, .additional_motoringOffences_row .col3{float:left; width:180px;}
	.additional_motoringOffences_head .col4, .additional_motoringOffences_row .col4{float:left; width:350px;}
	.additional_motoringOffences_row .col4 input{width:350px;}
</go:style>
<avea:additional_styles />
<avea:additional_scripts countId="${countId}" idIns="motoringOffences" maxRows="5" />


<%-- JAVASCRIPT --%>
<fmt:setLocale value="en_GB" scope="session" />
<go:script marker="js-href" href="common/js/utils.js" />
<go:script marker="js-head">
	function get_offset_date(yearOffset) {

		var MyDate = new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>,
								<fmt:formatDate value="${now}" type="DATE" pattern="MM"/>,
								<fmt:formatDate value="${now}" type="DATE" pattern="dd"/>);
		var MyDateString;

		MyDate.setYear(MyDate.getFullYear()+yearOffset);
		MyDateString = MyDate.getFullYear().toString()
					  + twoDigits(MyDate.getMonth())
					  + twoDigits(MyDate.getDate());
		return MyDateString;
	}

</go:script>


<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

	$.validator.addMethod("aveaMax5years",
			function(value, elem, parm) {

				var offence_date = $('#quote_avea_motoringOffences_'+parm+'_date').val().split('/');
				var int_offence_date = parseInt(offence_date[2]+''+offence_date[1]+''+offence_date[0]);
				var int_compare_date = parseInt(get_offset_date(-5));

				if(String(int_offence_date).length == 8 && String(int_compare_date).length == 8){
					if(int_offence_date > int_compare_date) {
						return true;
					}else{
						return false;
					}
				}
				
			},
			""
	);

</go:script>


<%-- VALIDATION --%>
<go:validate selector="quote_avea_motoringOffences_${countId}_date" rule="aveaMax5years" parm="'${countId}'" message="Motoring offences only within the last 5 years" />




