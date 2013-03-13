<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Create mbox for Adobe Test and Target"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="mboxId" 	required="true"	 rtexprvalue="true"	 description="mbox Id" %>
<%@ attribute name="pagename" 	required="true"	 rtexprvalue="true"	 description="mbox Page Name" %>

<go:script marker="js-href" href="common/js/mbox/mbox.js" />
<go:script marker="onready">
try { var mboxSessionId = mboxFactoryDefault.getSessionId().getId(); } catch(e) { var mboxSessionId = ""; };
if (mboxSessionId) {
	jQuery("a[href^='https://ecommerce.disconline.com.au']").each(function() {
		switch (true) { 
		case (this.href.charAt(this.href.length-1)=="?"): 
			var sep = ""; 
			break; // href ends with "?" 
		case this.href.indexOf("?")==-1: 
			var sep = "?"; 
			break;
		default: 
			var sep = "&"; 
		}
		this.href += sep + "mboxSession=" + mboxSessionId;
	});
};
</go:script>
<div class="mboxDefault"></div>
<script type="text/javascript">
	mboxCreate('${mboxId}', 'pagename=${pagename}');
</script>