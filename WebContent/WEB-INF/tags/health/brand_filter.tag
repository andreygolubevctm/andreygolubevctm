<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Brand filter for the health search. Note this uses a negative filter 'N' to reduce database load"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- FIX //refine //fix
This should be run off an SQL statement where it can pull off the product master status and generate instead of being hand coded.
This will allow us to easily turn on/off brands via the database with no need to touch files.
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="health_brand-filter">
	<ui:button theme="blue" id="${name}_open" >Select brands</ui:button>
</div>

<%-- Dialog --%>
<ui:dialog
		id="${name}_content"
		title="Select to compare benefits"
		titleDisplay="false"
		contentBorder="true"
		width="896"
		height="410"
		onClose="HealthBrandFilter.revert();"
		onOpen="HealthBrandFilter.populate(); HealthBrandFilter.capture();"
		>

		<div id="${name}_content">
			<h3>Select to compare benefits</h3>
			<p class="intro">Some text here to explain this section.</p>
			<ul>
				<%--
					Note if changing these providers:
					Remember this also maps in:
						* ProviderNameToId template in PHIO_outbound.xsl
						* <brandFilter> section in PHIO_outbound.xsl
				--%>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/ahm" label='ahm' 				title='<img src="/ctm/common/images/logos/health/AHM.png" alt="ahm" /> <span>ahm</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/auf" label='Australian Unity'	title='<img src="/ctm/common/images/logos/health/AUF.png" alt="Australian Unity" /> <span>Australian Unity</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/cbh" label='CBHS'				title='<img src="/ctm/common/images/logos/health/CBH.png" alt="CBHS" /> <span>CBHS</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/cua" label='CUA'					title='<img src="/ctm/common/images/logos/health/CUA.png" alt="CUA" /> <span>CUA</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/fra" label='Frank'				title='<img src="/ctm/common/images/logos/health/FRA.png" alt="Frank" /> <span>Frank</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/gmf" label='GMF'					title='<img src="/ctm/common/images/logos/health/GMF.png" alt="GMF" /> <span>GMF</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/gmh" label='GMHBA'				title='<img src="/ctm/common/images/logos/health/GMH.png" alt="GMHBA" /> <span>GMHBA</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/hcf" label='HCF'					title='<img src="/ctm/common/images/logos/health/HCF.png" alt="HCF" /> <span>HCF</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/hif" label='HIF'					title='<img src="/ctm/common/images/logos/health/HIF.png" alt="HIF" /> <span>HIF</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/nib" label='nib'					title='<img src="/ctm/common/images/logos/health/NIB.png" alt="nib" /> <span>nib</span>' /></li>
				<li><field:checkbox required="false" value="N" xpath="${xpath}/wfd" label='Westfund'			title='<img src="/ctm/common/images/logos/health/WFD.png" alt="Westfund" /> <span>Westfund</span>' /></li>
				<%--
				<li class="off"><img src="/ctm/common/images/logos/health/WFD.png" alt="Westfund" /> <span>Westfund <em>Out of Stock</em></span></li>
				--%>
			</ul>
			<div class="buttons">
				<ui:button theme="green" id="${name}_update">Update search</ui:button>
				<a class="" title="" id="${name}_all" href="javascript:void(0);">View all brands</a>
			</div>
		</div>

</ui:dialog>




<%-- CSS --%>
<go:style marker="css-head">
	#${name}_content h3 {
		margin-top:24px;
		margin-left:12px;
	}
	#${name}_content .buttons {
		clear:both;
		padding:24px 12px;
		text-align:center;
	}
	#${name}_all {
		margin-left:24px;
	}
	#${name}_content .intro {
		position:absolute;
		right:24px;
		top:24px;
		font-size:.9em;
	}
	#${name}_content ul input {
		position:absolute;
		left:-9999em;
	}
	#${name}_content ul {
		border-top:1px solid #CCC;
		margin:24px 0 24px 12px;
	}
	#${name}_content li {
		float:left;
		width:265px;
		height:auto;
		border-top:1px solid #CCC;
		padding:10px 0px;
		margin:-1px 12px 0px 0px;
		position:relative;
	}
	#${name}_content li label {
		display:block;
		cursor:pointer;
	}
	#${name}_content li span {
		font-weight:bold;
		font-size:.85em;
		position:absolute;
		left:120px;
		top:25px;
	}
	#${name}_content li img {
		max-size:20px;
	}
	#${name}_content li.N img {
		opacity:.5;
	}
	#${name}_content li.N {
		color:#bbb;
	}
	#${name}_content li.off {
		color:#EB5300;
	}
		#${name}_content li.off img {
			opacity:.5;
		}
		#${name}_content li.off em {
			font-size:.8em;
			font-weight:normal;
		}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var HealthBrandFilter = {
	reset: function(){
		$('#${name}_content').find('input:checkbox').removeAttr('checked').trigger('change');
	},
	update: function( $_this ){
		var $_obj = $_this.closest('li');
		if( $_this.is(':checked')){
			$_obj.addClass('N');
		} else {
			$_obj.removeClass('N');
		};
	},
	capture: function(){
		HealthBrandFilter._capture = $('#${name}_content').find('ul').clone(true);
	},
	revert: function(){
		if( HealthBrandFilter._capture.html() != $('#${name}_content').find('ul').html() ){
			$('#${name}_content').find('ul').replaceWith(HealthBrandFilter._capture);
		};
	},
	submit: function(){
		HealthBrandFilter.capture();
		Health.fetchPrices();
		${name}_contentDialog.close();

	},
	<%-- //refine //fix Move to ui:dialog so that items can be form present --%>
	populate: function(){
		$(".${name}_contentDialogContainer").parent().appendTo($("form:first"));
	}
}
</go:script>

<go:script marker="onready">
	$('#${name}_open').on('click', function(){
		${name}_contentDialog.open();
	});

	$('#${name}_all').on('click', function(){
		HealthBrandFilter.reset();
	});

	$('#${name}_update').on('click', function(){
		HealthBrandFilter.submit();
	});

	$('#${name}_content').on('change', 'input', function(){
		HealthBrandFilter.update($(this));
	});
</go:script>