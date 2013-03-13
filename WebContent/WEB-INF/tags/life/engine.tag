<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES  --%>
<%@ attribute name="xpathCover" 			required="true"	 rtexprvalue="true"	 description="cover field group's xpath" %>
<%@ attribute name="xpathDetailsPrimary" 	required="true"	 rtexprvalue="true"	 description="primary field group's xpath" %>
<%@ attribute name="xpathContactDetails" 	required="true"	 rtexprvalue="true"	 description="contact details field group's xpath" %>


<%-- VARIABLES --%>
<c:set var="nameCover" 				value="${go:nameFromXpath(xpathCover)}" />
<c:set var="nameDetailsPrimary" 	value="${go:nameFromXpath(xpathDetailsPrimary)}" />
<c:set var="nameContactDetails" 	value="${go:nameFromXpath(xpathContactDetails)}" />


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var LifeEngine = {
		_init: function(){
			<%-- Create Query Objects for faster iteration --%>
			LifeEngine.$_detailsPrimary = $('#${nameDetailsPrimary}');
			
			<%-- Fire the init settings --%>
			this.setTerm();
			this.setTPD();
			this.setTrauma();
		},
		
		<%-- Main on/off functions for the questions/areas --%>
		setTerm: function(){
	   		if( $('#${nameCover}_term:checked').length > 0 ){
	   			LifeEngine._setCover('.life_details_insurance_term_group', true);
	   		} else {
	   			LifeEngine._setCover('.life_details_insurance_term_group', false);
	   		};			
		},
		
		setTPD: function(){
	   		if( $('#${nameCover}_tpd:checked').length > 0 ){
	   			LifeEngine._setCover('.life_details_insurance_tpd_group', true);
	   		} else {
	   			LifeEngine._setCover('.life_details_insurance_tpd_group', false);
	   		};			
		},
		
		setTrauma: function(){
	   		if( $('#${nameCover}_trauma:checked').length > 0 ){
	   			LifeEngine._setCover('.life_details_insurance_trauma_group', true);
	   		} else {
	   			LifeEngine._setCover('.life_details_insurance_trauma_group', false);
	   		};			
		},
		
		_setCover: function(obj, show){
			if(show){
				$(LifeEngine.$_detailsPrimary).find(obj).show();
			} else {
				$(LifeEngine.$_detailsPrimary).find(obj).hide();
				$(LifeEngine.$_detailsPrimary).find(obj).find(":input").val("");
			};
		}			
	
	};
</go:script>


<go:script marker="onready">
	LifeEngine._init();
</go:script>


<%-- CSS --%>
<go:style marker="css-head">
</go:style>