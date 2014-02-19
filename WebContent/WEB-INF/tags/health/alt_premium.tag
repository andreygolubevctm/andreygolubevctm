<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Renders the alternate premium"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="false"	rtexprvalue="false"  description="This is the same as the Help ID attribute" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>

<%-- VARIABLES --%>
<jsp:useBean id="date" class="java.util.Date" />
<fmt:formatDate value="${date}" pattern="yyyy" var="currentYear" />
<sql:setDataSource dataSource="jdbc/test" />
<c:catch var="error">
	<sql:query var="find_setting">
		SELECT description
		FROM test.general
		WHERE type = 'healthSettings' AND code = 'dual-pricing'
		LIMIT 1;
	</sql:query>
</c:catch>
<c:set var="dual_pricing">
	<c:choose>
		<c:when test="${empty error and not empty find_setting}">
			<c:choose>
				<c:when test="${find_setting.rows[0]['description'] ne '0'}">${find_setting.rows[0]['description']}</c:when>
				<c:otherwise>0</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>0</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div class="altPremiumDisplay <c:if test="${not empty className}">${className}</c:if>" <c:if test="${not empty id}">id="${id}"</c:if>>[#= altPremiumContent #]</div>

<%-- SCRIPT --%>
<go:script marker="js-head">
var altPremium = {

<c:choose>
	<c:when test="${dual_pricing eq '0'}">
		from : false, // Switch to false to disable rendering of alt premium content
	</c:when>
	<c:otherwise>
		from : '${find_setting.rows[0]['description']}', // Switch to false to disable rendering of alt premium content
	</c:otherwise>
</c:choose>

		exists : function() {
			return altPremium.from !== false;
		},

		moreInfo : function() {
			altpremium_moreinfoDialog.open();
		},

		getHTML : function( obj, max_premium ) {

			max_premium = max_premium || false;

			if( altPremium.from !== false && obj.value == 0 ) {
				if( obj.specialcase ) {
					return "<div class='wrapper alt'><div class='ap_title'>APPROX PRICING FROM " + altPremium.from + " <c:out value="${currentYear}" /></div><div class='ap_amount'>Coming Soon</div></div><div class='ap_breakdown'>We are pleased to welcome<br>Teachers Health Fund to our panel!</div>";
				} else {
					return "<div class='wrapper alt'><div class='ap_title'>APPROX PRICING FROM " + altPremium.from + " <c:out value="${currentYear}" /></div><div class='ap_amount'>Coming Soon</div><a href='javascript:altPremium.moreInfo();' class='ap_moreinfo'>click here for more information</a></div>";
				}
			} else if ( altPremium.from !== false ) {
				var frequency_term = altPremium.getFrequencyTerm();
				var price = max_premium === false ? obj.lhcfreetext : obj.text;
				var details = max_premium === false ? obj.lhcfreepricing : obj.pricing
				return "<div class='wrapper'><div class='ap_title'>APPROX PRICING FROM " + altPremium.from + " <c:out value="${currentYear}" /></div><div class='ap_amount'>" + price + "</div><div class='ap_frequency'>Per " + frequency_term + "</div><a href='javascript:altPremium.moreInfo();' class='ap_moreinfo'>more information</a></div><div class='ap_breakdown'>" + details + "</div>";
			} else {
				return "";
			}
		},

		getFrequencyTerm : function() {

			var freq = paymentSelectsHandler.getFrequency();
			if(freq == ''){

				<%-- Get frequency from the results filter --%>
				switch( Results._getFilterType() ) {
					case 'F':
						freq = 'Fortnight';
						break;
					case 'A':
						freq = 'Year';
						break;
					default:
						freq = 'Month';
						break;
				};
			}else{

				<%-- Otherwise get the selected frequency from the payment page --%>
				switch( freq )
				{
					case 'W':
						freq = 'Week';
						break;
					case 'F':
						freq = 'Fortnight';
						break;
					case 'Q':
						freq = 'Quarter';
						break;
					case 'H':
						freq = 'Half Year';
						break;
					case 'A':
						freq = 'Year';
						break;
					default:
						freq = 'Month';
						break;
				};
			}

			return freq;
		},

		toggleFrequency : function(freq) {
		}
};
</go:script>

<%-- CSS --%>
<go:style marker="css-head">

	.health .altPremiumDisplay {
		height:					65px;
		padding-top:			5px;
		background:				#FFFFFF;
		display:				none;
	}

	.health .hasAltPremium .altPremiumDisplay {
		display:				block;
	}

	.health .altPremiumDisplay div {
		font-size:					10px;
		font-weight:				bold !important;
	}

	.health .altPremiumDisplay div.wrapper {
		position:				relative;
		border:						none;
		background:					none;
		border-radius:				none;
	}

	.health .altPremiumDisplay .ap_title {
		color:						#E54200;
		text-transform:				uppercase;
		text-align:					center;
		margin-bottom:				5px;
	}

	.health .altPremiumDisplay .ap_amount {
		width:						50%;
		color:						#0CB24E;
		font-size:					190%;
		text-align:					right;
		margin:						0 5px 0 0;
		clear:						right;
	}

	.health .altPremiumDisplay .alt .ap_amount {
		width:						auto;
		text-align:					center;
		margin:						0;
	}

	.health .altPremiumDisplay .ap_frequency,
	.health .altPremiumDisplay .ap_moreinfo {
		position:					absolute;
		left:						50%;
		margin-left:				5px;
		font-weight:				bold;
	}

	.health .altPremiumDisplay .ap_frequency {
		top:						15px;
		color:						#747474;
		font-size:					90%;
	}

	.health .altPremiumDisplay .ap_moreinfo {
		top:						25px;
		color:						#0CB24E !important;
		font-size:					83%;
		text-decoration:			none !important;
	}

	.health .altPremiumDisplay .alt .ap_moreinfo {
		position:					static;
		display:					block;
		color:						#A29195 !important;
		text-align:					center;
		font-size:					100%;
		width:						100%;
		margin:						5px 0 0 0;
	}

	.health .altPremiumDisplay .ap_moreinfo:hover {
		text-decoration:			underline !important;
	}

	.health .altPremiumDisplay .ap_breakdown {
		color:						#A29195;
		text-align:					center;
		margin-top:					5px;
	}

	/* RESULTS PAGE */
	.health #resultsPage.hasAltPremium .altPremiumDisplay {
		position:					absolute;
		top:						78px;
		left:						0px;
		width:						224px;
		background:					#E3E8EC;
	}

	/* POLICY DETAILS */
	.health #policy_details.hasAltPremium .altPremiumDisplay {
		width:						296px;
		background:					#E3E8EC;
		margin-left:				-13px;
		margin-top:					5px;
	}

	/* MORE INFO AND CONFIRMATION */
	.health #snapshotSide.hasAltPremium .altPremiumDisplay {
		height: 					70px;
	}

	.health #snapshotSide.hasAltPremium .altPremiumDisplay div.wrapper,
	.health #update-premium.hasAltPremium .altPremiumDisplay div.wrapper {
		padding:					5px 0;
		border:						1px solid #E3E8EC;
		background:					#F4F9FE;
		-moz-border-radius: 		5px;
		-webkit-border-radius: 		5px;
		border-radius: 				5px;
	}

	.health #update-premium.hasAltPremium .altPremiumDisplay .ap_breakdown {
		display: 					none;
	}

	.health #snapshotSide.hasAltPremium .altPremiumDisplay div.wrapper .ap_frequency {
		top: 						21px;
	}

	.health #confirmation-order-summary #policy_details.hasAltPremium .altPremiumDisplay div.wrapper .ap_frequency {
		top: 						15px;
	}

	.health #snapshotSide.hasAltPremium .altPremiumDisplay div.wrapper .ap_moreinfo {
		top: 						32px;
	}

	.health #confirmation-order-summary #policy_details.hasAltPremium .altPremiumDisplay div.wrapper .ap_moreinfo {
		top: 						25px;
	}

	/* UPDATE PREMIUM */
	.health #update-premium.hasAltPremium .altPremiumDisplay {
		padding-top:				0;
		margin-left:				20px;
		width:						220px;
		height:						48px;
	}

	.health #update-premium.hasAltPremium .altPremiumDisplay .ap_frequency {
		top:						20px;
	}

	.health #update-premium.hasAltPremium .altPremiumDisplay .ap_moreinfo {
		top:						30px;
	}
</go:style>