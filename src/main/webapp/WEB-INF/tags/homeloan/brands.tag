<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Brands Renderer"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<core:js_template id="brands-template">

	<%-- To add another brand, just add another item to the list and
		remember to add a new class in framework\modules\less\homeloan\logos.less --%>

	<c:set var="brands"
		value="${fn:split('ADLB,AFG,AMP,ANZ,BANKAUST,BOC,BOM,BANKSA,BANKWEST,BLUESTONE,BOQ,CBA,CITI,HERITAGE,HOMESTART,ING,KEY,LATROBE,LIBERTY,MACQ,ME,MKM,NAB,NABBROKER,PN,PEPPER,QPCU,GEORGE,SUNCORP,ROCK,WESTPAC,AUSWIDE',',')}" />

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

</core:js_template>
