<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Renders the alternate premium"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="false"	rtexprvalue="false"  description="This is the same as the Help ID attribute" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>

<%-- HTML --%>
<h4 class="altPremiumDisplay <c:if test="${not empty className}">${className}</c:if>" <c:if test="${not empty id}">id="${id}"</c:if>>
	<span class="apd_content">[#= altPremiumContent #]</span>
</h4>

<%-- SCRIPT --%>
<go:script marker="js-head">
var altPremium = {
		from : false, // Switch to false to disable rendering of alt premium content
		
		exists : function() {
			return altPremium.from !== false;
		},
		
		getHTML : function( obj ) {
			if( altPremium.from !== false && obj.value == 0 ) {
				return "1st " + altPremium.from + " price is not available<a href='javascript:void()'><!-- empty --></a>";
			} else if ( altPremium.from !== false ) {
				return "<span class='apd_premium'>" + obj.text + "</span> - Price from <span class='apd_from'>" + altPremium.from + "</span><a href='javascript:void(0)' onClick='altPremium.showInfo(this);'><!-- empty --></a>";
			} else {
				return "";
			}
		},
		
		showInfo : function(e) {
			Help.update(517, $(e));
		}
};
</go:script>

<%-- CSS --%>
<go:style marker="css-head">

	.health .altPremiumDisplay {
		font-weight:			bold;
		border:					1px solid #E3E8EC;
		border-width:			1px 0;
		background:				#E3E8EC;
		font-size:				14px;
		padding:				4px 8px;
		overflow:				hidden;
		text-overflow:			ellipsis;
		height:					20px;
		text-align:				center;
		display:				none;
	}
	
	.health .hasAltPremium .altPremiumDisplay {
		display:				table;
	}
	
	.health  .hasAltPremium .altPremiumDisplay span.apd_content {
		display:				table-cell;
		vertical-align:			middle;
		height:					20px;
	}
	
	.health .hasAltPremium .altPremiumDisplay a {
		display:				inline-block;
		width:					14px;
		height:					14px;
		margin-left: 			4px;
		margin-bottom: 			-2px;
		background: 			#E3E8EC url(brand/ctm/images/icon_help_alt.png) 0 0 no-repeat;
		float:					none !important;
	}
	
	/* RESULTS PAGE */	
	.health #resultsPage.hasAltPremium .altPremiumDisplay {
		position:				absolute;
		top:					78px;
		left:					0px;
		width:					208px;
	}
	
	/* POLICY DETAILS */
	.health #policy_details.hasAltPremium .altPremiumDisplay {
		width: 					283px;
		margin: 				8px 0 0 -15px;
	}
	
	/* POLICY DETAILS */
	.health #update-premium.hasAltPremium .altPremiumDisplay {
		display:				inline-block;
		width: 					auto;
		margin: 				0 0 0 24px;
	}
</go:style>