<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag
	description="Display Current Transaction Id for Local/Dev Environments"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Output Dev Env Debug Info --%>
<c:set var="env" value="${data['settings/environment']}" />
<c:if
	test="${env eq 'localhost' or env eq 'NXI' or env eq 'NXQ' or env eq 'NXS'}">

	<c:if test="${data.settings.vertical != 'DEFAULT'}">

		<%-- Import Manifest to grab buildIdentifier --%>
		<c:import var="manifestContent" url="/META-INF/MANIFEST.MF" />
		<c:set var="buildIdentifier" value="" />
		<%-- It appears a delimiter of a new line needs to be broken to a new line with no tab/spacing in between. --%>
		<c:forTokens items="${manifestContent}" var="manifestEntry"
			delims="
">
			<c:if
				test="${ empty buildIdentifier and not empty manifestEntry and fn:startsWith(manifestEntry, 'Identifier: ') }">
				<c:set var="buildIdentifier"
					value="${fn:trim(fn:substringAfter(manifestEntry, 'Identifier: '))}" />
			</c:if>
		</c:forTokens>

		<c:set var="secondaryDevEnvDialog" value="" />
		<c:if test="${data.settings.environment eq 'NXI'}">
			<c:set var="secondaryDevEnvDialog" value="secondaryDevEnvDialog" />
		</c:if>

		<jsp:useBean id="now" class="java.util.Date" />
		<div class="fixedDevEnvDialog ${secondaryDevEnvDialog}">

			<div class="closeDevEnvDialog" title="Show/Hide Debug Info">
				<img src="${data['settings/root-url']}${data['settings/styleCode']}/common/images/dialog/close.png">
			</div>

			<c:if test="${not empty data.current.transactionId}">
				<div>
					<strong>transactionId</strong>:&emsp; <span id="js-debugTxId">${data.current.transactionId}</span>
				</div>
			</c:if>
			<div>
				<strong>environment</strong>:&emsp; ${env} @ <span
					id="js-debugCurTime"> <fmt:formatDate type="both"
						dateStyle="short" timeStyle="short" value="${now}" /></span>
			</div>
			<c:if test="${not empty buildIdentifier}">
				<div>
					<strong>build identifier</strong>: ${buildIdentifier}
				</div>
			</c:if>
		</div>

		<%-- Monitor ajaxComplete of access_touch, which returns updated transactionId fields. --%>
		<go:script>
			$(document).ajaxComplete(function (event, xhr, settings) {
				if (settings.url == "ajax/json/access_touch.jsp" && xhr.responseText.length > 0) {
					var obj = JSON.parse(xhr.responseText);
					if (typeof obj.result != 'undefined' && typeof obj.result.transactionId != 'undefined') {
						$('#js-debugTxId').html(obj.result.transactionId);
						var d = new Date(),
							m = d.getMonth() + 1,
							day = d.getDate();
						$('#js-debugCurTime').html((day < 10 ? '0' + day : day) + '/' + (m < 10 ? '0' + m : m) + '/' + (d.getFullYear() + "").substring(2) + ' ' + d.getHours() + ':' + d.getMinutes())
					}
				}
			}).ready(function() {
				$('.closeDevEnvDialog').on('click', function() {
					$('.fixedDevEnvDialog').find('div:not(.closeDevEnvDialog)').toggle().end().toggleClass('debugInfoHidden');
				});
			});
		</go:script>
	</c:if>

</c:if>