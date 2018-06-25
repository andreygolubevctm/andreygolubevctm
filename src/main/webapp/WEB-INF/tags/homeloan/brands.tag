<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Brands Renderer"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<core_v1:js_template id="brands-template">

	<%-- To add another brand, just add another item to the list and
		remember to add a new class in framework\modules\less\homeloan\logos.less --%>

	<c:set var="brands"
		value="${fn:split('ADLB,AFG,AMP,ANZ,AUSWIDE,BANKAUST,BOC,BOM,BOS,BANKSA,BANKWEST,BEYOND,BLUESTONE,BOQ,CBA,CITI,FIREFIGHTERS,HERITAGE,HOMELOANS,HOMESTART,IMB,ING,KEY,LATROBE,LIBERTY,MACQ,ME,MKM,MYSTATE,NAB,NABBROKER,NEWCASTLE,PN,PEPPER,QBANK,GEORGE,SUNCORP,TMB,UNIBANK,VIRG,WESTPAC,',',')}" />

	<div class="brands-content">
	{{ if(typeof obj !== 'undefined' && typeof obj.pretext !== 'undefined') { }}
	{{=obj.pretext }}
	{{ } }}
	<c:forEach items="${brands}" var="brand" varStatus="loop">
		<div class="col-lg-2 col-md-3 col-sm-4 col-xs-6">
			<div class="companyLogo logo_${brand}"></div>
		</div>
	</c:forEach>
	</div>

</core_v1:js_template>
