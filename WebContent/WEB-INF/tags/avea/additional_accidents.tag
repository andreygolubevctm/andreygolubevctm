<%@ tag language="java" pageEncoding="ISO-8859-1" %>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="countId" 		required="true"   rtexprvalue="true" description="Current ID count. Must be a unique number. Eg. 0, 1, 2..." %>
<%@ attribute name="className" 		required="false"  rtexprvalue="true" description="Custom Class to apply to the container" %>
<%@ attribute name="hideSeparator" 	required="false"  rtexprvalue="true" description="Set to hide the separating line under the fields" %>
<%@ attribute name="hideAdd" 		required="false"  rtexprvalue="true" description="Set to hide the Add Another link" %>
<%@ attribute name="xpath" 			required="true"  rtexprvalue="true" description="Set the xpath base" %>

<%-- HTML --%>

	<div id="accidents_${countId}" class="additional accidents <c:if test="${className!=null}"> ${className}</c:if>">

		<div class="additional_head additional_accidents_head">
			<div class="col1">Driver</div>
			<div class="col2">Date of Incident</div>
			<div class="col3">Amount of Damage ($)</div>
			<div class="col4">Driver at Fault</div>
			<div class="col5">Stolen/Malicious Damage?</div>
			<div class="col6">Fire Damaged?</div>
			<core:clear />
		</div>
		
		<div class="additional_row additional_accidents_row">
		
		
			<div class="col1"><field:array_select className="driver_dropdown" items="" xpath="${xpath}/driver" title="Driver" required="true" /></div>
			<div class="col2 hide_date_label"><field:date_text_entry xpath="${xpath}/date" title="Date" required="true" /></div>
			<div class="col3"><field:input xpath="${xpath}/amount" title="Amount of Damage" required="true" className="amount_damage" maxlength="8"  /></div>
			<div class="col4">

			<field:array_radio xpath="${xpath}/driverFault" className="driver_fault_radio" required="true" items="Y=Yes,N=No" title="Driver at Fault" />
			
			</div>
	
			
			<div class="col5"><field:checkbox value="1" xpath="${xpath}/malicious" title="Stolen/Malicious Damage" required="false" /></div>
			<div class="col6"><field:checkbox value="1" xpath="${xpath}/fire" title="Fire Damaged" required="false" /></div>
			<core:clear />
		</div>
		
		<div class="additional_head additional_accidents_head2">
			<div class="col7">Insurer at time of incident</div>
			<div class="col8">Details</div>
			<core:clear />
		</div>
		
		<div class="additional_row additional_accidents_row">
			<div class="col7"><field:input xpath="${xpath}/incidentInsurer" title="Insurer" required="true" maxlength="200"  /></div>
			<div class="col8"><field:input xpath="${xpath}/incidentDetails" title="Details" required="true" maxlength="200"  /></div>
			<core:clear />
		</div>
		
		<c:if test="${hideAdd==null || hideAdd=='false'}">
			<core:clear />
			<a href="javascript:;" id="add_accidents_${countId}" class="add_link add_accidents">Add another</a>
		</c:if>
		<a href="javascript:;" id="remove_accidents_${countId}" class="remove_link remove_accidents">Remove</a>
		<core:clear />
		
	</div>



<%-- STYLES --%>
<go:style marker="css-head">
	.additional_accidents_head .col1, .additional_accidents_row .col1{float:left; width:155px;}
	.additional_accidents_head .col2, .additional_accidents_row .col2{float:left; width:115px;}
	.additional_accidents_head .col3, .additional_accidents_row .col3{float:left; width:165px;}
	.additional_accidents_head .col4, .additional_accidents_row .col4{float:left; width:105px;}
	.additional_accidents_head .col5, .additional_accidents_row .col5{float:left; width:165px;}
	.additional_accidents_head .col6, .additional_accidents_row .col6{float:left; width:105px;}
	.additional_accidents_head2 .col7, .additional_accidents_row .col7{float:left; width:210px;}
	.additional_accidents_head2 .col8, .additional_accidents_row .col8{float:left; width:590px;}
	.additional_accidents_head2{
		margin-top:-10px;
		-moz-border-radius:0; 
		-webkit-border-radius:0; 
		-khtml-border-radius:0; 
		border-radius:0;
	}
	.additional_accidents_row .col7 input{width:190px;}
	.additional_accidents_row .col8 input{width:590px;}
	.driver_dropdown{width:145px;}
</go:style>
<avea:additional_styles />
<avea:additional_scripts countId="${countId}" idIns="accidents" maxRows="5" />

