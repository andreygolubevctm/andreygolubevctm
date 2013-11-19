<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES  --%>
<%@ attribute name="xpathInsurance" 		required="true"	 rtexprvalue="true"	 description="Insurance field group's xpath" %>
<%@ attribute name="xpathPrimary" 			required="true"	 rtexprvalue="true"	 description="Primary field group's xpath" %>
<%@ attribute name="xpathPartner" 			required="true"	 rtexprvalue="true"	 description="Partner field group's xpath" %>
<%@ attribute name="xpathContactDetails" 	required="true"	 rtexprvalue="true"	 description="Contact details field group's xpath" %>


<%-- VARIABLES --%>
<c:set var="nameInsurance" 		value="${go:nameFromXpath(xpathInsurance)}" />
<c:set var="namePrimary" 		value="${go:nameFromXpath(xpathPrimary)}" />
<c:set var="namePartner" 		value="${go:nameFromXpath(xpathPartner)}" />
<c:set var="nameContactDetails" value="${go:nameFromXpath(xpathContactDetails)}" />


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var LifeEngine = {
		_init: function(){
			<%-- Create Query Objects for faster iteration --%>
			LifeEngine.$_insurance = $('#${nameInsurance}');
			LifeEngine.$_primary = $('#${namePrimary}');
			LifeEngine.$_partner = $('#${namePartner}');

			<%-- Fire the init settings --%>
			this.setTerm();
			this.setTPD();
			this.setTrauma();
		},

		<%-- Main on/off functions for the questions/areas --%>
		setTerm: function(){
			LifeEngine._setCover('.life_insurance_term_group', true);
		},

		setTPD: function(){
			LifeEngine._setCover('.life_insurance_tpd_group', true);
		},

		setTrauma: function(){
			LifeEngine._setCover('.life_insurance_trauma_group', true);
		},

		_setCover: function(obj, show){
			if(show){
				$(LifeEngine.$_primary).find(obj).show();
			} else {
				$(LifeEngine.$_primary).find(obj).hide();
				$(LifeEngine.$_primary).find(obj).find(":input").val("");
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