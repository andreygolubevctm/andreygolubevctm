<%@ tag description="Load the application settings"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Application settings --%>


<c:if test="${empty applicationSettings}">
	<jsp:useBean id="applicationSettings" class="com.disc_au.web.go.Data" scope="application" />
	<go:setData dataVar="applicationSettings" xpath="application" value="*DELETE" />
	<c:set var="applicationXml">
		<%-- merge all settings together based on brand and environment and current vertical --%>
		<brands>
			<ctm>
				<brand>
					<name>Compare the Market</name>
				</brand>
			</ctm>
		</brands>
	</c:set>
	<go:setData dataVar="applicationSettings" xpath="application" xml="${applicationXml}" />
</c:if>