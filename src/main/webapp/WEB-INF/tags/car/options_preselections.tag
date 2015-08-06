<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for non-standard accessories"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var userOptionPreselections = {
		factory : ${go:XMLtoJSON(go:getEscapedXml(data.quote.opts))},
		accessories : ${go:XMLtoJSON(go:getEscapedXml(data.quote.accs))}
};
</go:script>