<%@ tag language="java" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="" %>
<%@ attribute name="heading" 	required="true"  rtexprvalue="true"	 description="" %>
<%@ attribute name="id" 		required="true"  rtexprvalue="true"	 description="" %>
<%@ attribute name="xpath" 		required="true"  rtexprvalue="true"	 description="" %>
<%@ attribute name="className" 	required="true"  rtexprvalue="true"	 description="" %>
<%@ attribute name="countIds" 	required="true"  rtexprvalue="true"	 description="" %>
<%@ attribute name="tagPath" 	required="true"  rtexprvalue="true"	 description="" %>
<%@ attribute name="helpId" 	required="false" rtexprvalue="true"  description="" %>
<%@ attribute name="required" 	required="true"  rtexprvalue="true"	 description="" %>


<%-- HTML --%>

<c:if test="${helpId!=null}">
	<form:row label="${heading}" className="${className}" helpId="${helpId}">
		<field:array_radio id="${id}" xpath="${xpath}" required="${required}" items="Y=Yes,N=No" title="${title}" />
	</form:row>
</c:if>

<c:if test="${helpId==null}">
	<form:row label="${heading}" className="${className}">
		<field:array_radio id="${id}" xpath="${xpath}" required="${required}" items="Y=Yes,N=No" title="${title}" />
	</form:row>
</c:if>

<core:clear />

<c:set var="ids">${countIds}</c:set>

<c:forEach items="${ids}" var="row" varStatus="status">

	<c:set var="hideAdd" value="false" />
	<c:if test="${tagPath=='avea:additional_driver'}">				<avea:additional_driver 			 countId="${row}"  	xpath="quote/avea/drivers/${row}"	className="hidden" 	hideAdd="${hideAdd}" />				<core:clear/></c:if>
	<c:if test="${tagPath=='avea:additional_motoringoffences'}">	<avea:additional_motoringoffences 	 countId="${row}"   xpath="quote/avea/motoringOffences/${row}"	className="hidden"	hideAdd="${hideAdd}" />		<core:clear/></c:if>
	<c:if test="${tagPath=='avea:additional_accidents'}">			<avea:additional_accidents 			 countId="${row}"   xpath="quote/avea/accidents/${row}"	className="hidden"	hideAdd="${hideAdd}" />				<core:clear/></c:if>
	<c:if test="${tagPath=='avea:additional_licenseendorsements'}">	<avea:additional_licenseendorsements countId="${row}" 	xpath="quote/avea/licenseEndorsements/${row}" className="hidden" hideAdd="${hideAdd}" />	<core:clear/></c:if>
	<c:if test="${tagPath=='avea:additional_criminalconvictions'}">	<avea:additional_criminalconvictions countId="${row}"   xpath="quote/avea/criminalConvictions/${row}"	className="hidden"	hideAdd="${hideAdd}" />	<core:clear/></c:if>
	<c:if test="${tagPath=='avea:additional_insurancerefused'}">	<avea:additional_insurancerefused 	 countId="${row}"   xpath="quote/avea/insuranceRefused/${row}"	className="hidden" 	hideAdd="${hideAdd}" />		<core:clear/></c:if>

</c:forEach>

<core:clear/>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

	$("#quote_avea_incidentsClaimsOther_${id}_Y, #quote_avea_incidentsClaimsOther_${id}_N").change(function(){
		changed_radio('quote_avea_incidentsClaimsOther_${id}', '${id}'); 
	});
	
</go:script>
		
		
<%-- JAVASCRIPT --%>
<go:script marker="js-head">


	<%-- User Changed the main YES/NO Row selector --%>
	function changed_radio(radio_id, item_id){
	
		<%-- User selected YES --%>
		if($("#"+radio_id+"_Y:checked").val()=='Y'){
			$('#'+item_id+'_'+item_id+'0').slideDown(500, function(){ 
				re_show_links(item_id);
				popupateDriverDropdowns();
			});
		}
		
		<%-- User selected NO --%>
		if($("#"+radio_id+"_N:checked").val()=='N'){
			
			$('.'+item_id+' input').each(function(index){
				if( $(this).attr('id').indexOf('driverFault') == -1 && $(this).attr('id').indexOf('malicious') == -1 && $(this).attr('id').indexOf('fire') == -1 ){
					$(this).attr("value","");
				}
			});
			
			$('.'+item_id+' select').attr("value","");
			$('.'+item_id+' input').attr('checked', false);
			$('.'+item_id).slideUp(500, function(){ re_show_links(item_id); });
		}
		
	}
	
	
	<%-- Re-display the links for the newly-appeared row --%>
	function re_show_links(id){
		$('#'+id+' .add_link').show();
		$('#'+id+' .remove_link').show();
		$('.add_'+id).show();
	}
	
	
</go:script>
	