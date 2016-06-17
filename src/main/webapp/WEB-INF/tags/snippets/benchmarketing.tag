<%-- TODO: FIX URLS FOR ALL REFERENCES TO ${assetUrl} -- They currently use ../ for scripts. We need to move scripts to the asset folder! --%>
<%@ tag description="The Page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="BenchMarketingScriptEnabled" value="${pageSettings.getSetting('BenchMarketingScriptEnabled') eq 'Y'}" />
<c:if test="${BenchMarketingScriptEnabled eq true}">
	<script type="text/javascript">
		(function(i,s,o,r,a,m){
			var g = 'https://benchtag.co/benchmarketingsmarttag/get?357ebe653e68ec1c276f78c60897b23808e0b2092459a645a797ef03ea4e66ab';
			i['TagObject']=r;i[r]=i[r]||function(){
						(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
					m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m);
		})(window,document,'script','bs');
	</script>
</c:if>