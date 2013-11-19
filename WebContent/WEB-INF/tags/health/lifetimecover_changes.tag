<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Bank account details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

Government changes to Lifetime Health Cover loading effective<br/>1 July. For more information <a href='javascript:void(0);' id='lifetimecoverchanges'>click here</a>

<ui:dialog
		id="lifetimecover_changes"
		title="Policy Information"
		titleDisplay="false"
		contentBorder="true"
		width="650"
		>
<h4><span>Industry Alert!</span> Australian Government changes to Lifetime Health Cover loading</h4>
<p>
	On 27 June 2013, the Federal Government introduced changes to remove the Australian Government Rebate from the
	Lifetime Health Cover (LHC) loading on private health insurance.  The change is effective from 1 July 2013 and applies
	to every health fund.
</p>
<p>
	<b>What will this mean to customers who pay an LHC loading?</b>
</p>
<p>
	This change removes the private health insurance rebate from any LHC
	loading applied to the costs of a policy from 1 July 2013.
</p>
<p>
	<b>Premium Prices Quoted</b>
</p>
<p>
	Due to the late notice of the transition of this legislation through the Houses of the Australian Parliament not all
	funds will be ready to deduct the new rate from the 1st July. While the funds bring their systems in-line with this legislative
	requirement they will need to continue to bill you at the pre-July rates. You will have your first payment deducted at the
	pre 1st July price and all future payments will be at a higher rate to reflect the Government's LHC change.
</p>
<p>
	The premium amount provided by www.comparethemarket.com.au is subject to confirmation by your health insurance fund.
</p>
<p>
	If this applies to you, you will need to pay the rebate back to the Government via your FY2014 tax return in
	order to reconcile the difference.
</p>

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