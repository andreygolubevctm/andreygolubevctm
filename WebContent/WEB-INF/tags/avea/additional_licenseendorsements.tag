<%@ tag language="java" pageEncoding="ISO-8859-1" %>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="countId" 		required="true"   rtexprvalue="true" description="Current ID count. Must be a unique number. Eg. 0, 1, 2..." %>
<%@ attribute name="className" 		required="false"  rtexprvalue="true" description="Custom Class to apply to the container" %>
<%@ attribute name="hideSeparator" 	required="false"  rtexprvalue="true" description="Set to hide the separating line under the fields" %>
<%@ attribute name="hideAdd" 		required="false"  rtexprvalue="true" description="Set to hide the Add Another link" %>
<%@ attribute name="xpath" 			required="true"  rtexprvalue="true" description="Set the xpath base" %>

<%-- HTML --%>

	<div id="licenseEndorsements_${countId}" class="additional licenseEndorsements <c:if test="${className!=null}"> ${className}</c:if>">

		
		<div class="additional_head additional_licenseEndorsements_head">
			<div class="col1">Driver</div>
			<div class="col2">Date Refused</div>
			<div class="col3">Period of Suspension</div>
			<div class="col4">Details</div>
			<core:clear />
		</div>
		
		<div class="additional_row additional_licenseEndorsements_row">
			<div class="col1"><field:array_select className="driver_dropdown" items="" xpath="${xpath}/driver" title="Driver" required="true" /></div>
			<div class="col2 hide_date_label"><field:date_text_entry xpath="${xpath}/date" title="Date" required="true" /></div>
			<div class="col3"><field:input xpath="${xpath}/period" title="Period of Suspension" required="true" maxlength="2" /> <span class="font9">(months)</span></div>
			<div class="col4"><field:input xpath="${xpath}/details" title="Details" required="true" maxlength="200" /></div>
			<core:clear />
		</div>
		
		<c:if test="${hideAdd==null || hideAdd=='false'}">
			<core:clear />
			<a href="javascript:;" id="add_licenseEndorsements_${countId}" class="add_link add_licenseEndorsements">Add another</a>
		</c:if>
		<a href="javascript:;" id="remove_licenseEndorsements_${countId}" class="remove_link remove_licenseEndorsements">Remove</a>
		<core:clear />
		
	</div>



<%-- STYLES --%>
<go:style marker="css-head">
	.additional_licenseEndorsements_head .col1, .additional_licenseEndorsements_row .col1{float:left; width:155px;}
	.additional_licenseEndorsements_head .col2, .additional_licenseEndorsements_row .col2{float:left; width:115px;}
	.additional_licenseEndorsements_head .col3, .additional_licenseEndorsements_row .col3{float:left; width:165px;}
	.additional_licenseEndorsements_head .col4, .additional_licenseEndorsements_row .col4{float:left; width:370px;}
	.additional_licenseEndorsements_row .col4 input{width:370px;}
</go:style>
<avea:additional_styles />
<avea:additional_scripts countId="${countId}" idIns="licenseEndorsements" maxRows="5" />

