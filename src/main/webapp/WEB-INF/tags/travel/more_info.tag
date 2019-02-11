<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_v1:js_template id="more-info-template">

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var companyLogo = _.template(template); }}
	{{ companyLogo = companyLogo(obj); }}
	{{ var hasSpecialOffer = !_.isEmpty(obj.offer) && _.isObject(obj.offer) && !_.isEmpty(obj.offer.copy) && !_.isEmpty(obj.offer.terms) }}

	<div class="displayNone more-info-content {{= hasSpecialOffer ? 'specialOffer' : ''}}">
		<%-- Header --%>
		<div class="row headerBar">
			<div class="col-xs-12 col-sm-9">
				<div class="col-xs-3 col-sm-2 logoContainer">{{= companyLogo}}</div>
				<div class="col-xs-9 col-sm-10 verticalCenterContainer"><h2 class="productTitle">{{= obj.des }}</h2></div>
			</div>
			<div class="col-xs-12 col-sm-3 verticalCenterContainer">
				<a href="javascript:;" class="btn btn-cta btn-block btn-apply" data-productid="{{= obj.productId }}">
							Continue to Insurer</a>
			</div>
		</div>
		<%-- Benefits --%>
		<div class="row">
			<div class="col-xs-12">
				<table class="benefitsContainer">
					{{ if(hasSpecialOffer) { }}
						<tr><td colspan="2">
							<div class="promotion">
								<span class="icon icon-tag"></span> {{= obj.offer.copy }}
								<a class="small offerTerms" href="javascript:;">Offer terms</a>
								<div class="offerTerms-content hidden">{{= obj.offer.terms }}</div>
							</div>
						</td></tr>
					{{ } }}
				<%-- loop through newly sorted alphabetical order. tag[1] returns medical, luggage etc... --%>
					{{ $.each(obj.sorting, function(index, tag){ }}
					{{ if((typeof obj.sorting[index] === 'object')) { }}
						<tr>
							<td class="col-xs-8 col-sm-6">{{= obj.sorting[index].desc }}</td>
							<td class=" col-xs-4 col-sm-6">
								{{ if(obj.sorting[index].desc.indexOf("Excess") >= 0 ) { }}
									{{ if(obj.sorting[index].text === 'Nil') { }}
										{{= '$0' }}
									{{ } else if ((obj.sorting[index].text.indexOf('$') < 0) && (obj.sorting[index].text.indexOf(".") >= 0) ) { }}
										{{= '$' + obj.sorting[index].text.substring(0, obj.sorting[index].text.indexOf(".")) }}
									{{ } else if (obj.sorting[index].text.indexOf('$') < 0 ) { }}
										{{= '$' + obj.sorting[index].text }}
									{{ } else if (obj.sorting[index].text.indexOf(".") >= 0 ) { }}
										{{= obj.sorting[index].text.substring(0, obj.sorting[index].text.indexOf(".")) }}
									{{ } else { }}
										{{= obj.sorting[index].text }}
									{{ } }}
								{{ } else { }}
									{{= obj.sorting[index].text }}
								{{ } }}
							</td>
						</tr>
					{{ } }}
				{{ }); }}
				</table>
			</div>
		</div>
		<div class="row about">
			<div class="col-xs-12">
				<p><strong>Before choosing a policy, please be aware that exclusions and/or sub-limits will apply to most sections. It is important to read the Product Disclosure Statement (PDS) before making any purchase to ensure the cover provided matches your specific requirements.</strong></p>
			</div>
		</div>
		<%-- PDS Link --%>
		<div class="row">
			<div class="col-xs-12 col-sm-6 col-sm-offset-3 ">
				<a href="{{= obj.subTitle}}" target="_blank" class="showDoc btn btn-block btn-download PDS-btn"> Product Disclosure Statement</a>
			</div>
		</div>
		<%-- About Provider --%>
		<div class="row about">
			<div class="col-xs-12">
				<p>{{= obj.infoDes}}</p>
			</div>
		</div>
	</div>
</core_v1:js_template>

