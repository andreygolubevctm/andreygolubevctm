<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core:js_template id="more-info-template">

	{{ var template = $("#provider-logo-template").html(); }}
	{{ var companyLogo = _.template(template); }}
	{{ companyLogo = companyLogo(obj); }}

	<div class="displayNone more-info-content">
		<%-- Header --%>
		<div class="row headerBar">
			<div class="col-xs-12 col-sm-9">
				<div class="col-xs-3 col-sm-2 logoContainer">{{= companyLogo}}</div>
				<div class="col-xs-9 col-sm-10 verticalCenterContainer"><h2>{{= obj.des }}</h2></div>
			</div>
			<div class="col-xs-12 col-sm-3 verticalCenterContainer">
				<a href="javascript:;" class="btn btn-cta btn-block btn-apply" data-productid="{{= obj.productId }}">
							<c:choose>
								<c:when test="${param['j'] == 2}">Continue to Insurer</c:when>
								<c:otherwise>Buy Now</c:otherwise>
							</c:choose></a>
			</div>
		</div>
		<%-- Benefits --%>
		<div class="row">
			<div class="col-xs-12">
				<table class="benefitsContainer">
				<%-- loop through newly sorted alphabetical order. tag[1] returns medical, luggage etc... --%>
				{{ $.each(obj.sorting, function(index, tag){ }} 
					{{ if((typeof obj.info[tag[1]] === 'object') && obj.info[tag[1]].value && obj.info[tag[1]].value > 0  ) { }}
						<tr>
							<td class="col-xs-8 col-sm-6">{{= obj.info[tag[1]].desc }}</td>
							<td class=" col-xs-4 col-sm-6">{{= obj.info[tag[1]].text }}</td>
						</tr>
					{{ } }}
				{{ }); }}
				</table>
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
</core:js_template>

