<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

Potential changes to Lifetime Health Cover loading effective<br/>1 July. For more information <a href='javascript:void(0);' id='lifetimecoverchanges'>click here</a>

<ui:dialog
		id="lifetimecover_changes"
		title="Policy Information"
		titleDisplay="false"
		contentBorder="true"
		width="650"
		>
<h4><span>Industry Alert!</span> Probable Australian Government changes to Lifetime Health Cover loading</h4>
<p>A proposed Government legislative change to Lifetime Health Cover loading is due to be passed shortly.</p>
<p>What will this mean to customers who pay an LHC loading?</p>
<p>This change will remove the private health insurance rebate from any LHC loading applied to the costs of a policy from 1 July 2013. If these proposed changes are passed your health fund will let you know of any changes to your premium.</p>
<p>Example:</p>
<p><b>Current premium calculation structure</b></p>
<p>Brad has hospital cover with his current health insurance provider and pays $100. A LHC loading of $40 applies to Brad's premium.</p>
<p>He is retired and has an income has been means tested and he is eligible for a 40% rebate on his premium.  Brad's premium value is calculated as follows:</p>
<p>$100 (hospital cover premium) + $40 (LHC loading) = $140</p>
<p>$140- 40% (rebate) = $84 (total premium less rebate)</p>
<p><b>Proposed premium calculation structure</b></p>
<p>$100 - 40% (rebate) = $60</p>
<p>$60 + ($40 LHC loading) = $100</p>
<p>Should this legislation be passed it will increase the cost of health insurance for those customers who pay an LHC loading. The LHC loading component of the health insurance premium will no longer be eligible for the rebate even though the customer is eligible for the overall rebate.</p>
<p>If this impacts you, you may be able to save costs by purchasing your health insurance cover before the changes come into effect on 1 July 2013.  For further information call one of our expert consultants on: 1800 77 77 12</p>

</ui:dialog>

<go:script marker="onready">
$('#lifetimecoverchanges').on('click', lifetimecover_changesDialog.open);
</go:script>

<go:style marker="css-head">
#lifetimecover_changesDialog h4 span {
	color:			#E54200;
}

#lifetimecover_changesDialog h4,
#lifetimecover_changesDialog p {
	padding:		7px 20px;
}

#lifetimecover_changesDialog h4 {
	font-size:		14pt;
}

#lifetimecover_changesDialog p {
	font-size:		11pt;
}
</go:style>