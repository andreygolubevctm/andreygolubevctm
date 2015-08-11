<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Display Countdown Timer for NXI"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:if test="${environmentService.getEnvironmentAsString() == 'NXI'}">

	<c:import var="manifestContent" url="/META-INF/MANIFEST.MF"/>

	<c:set var="buildTime" value="" />
	<c:set var="env" value="" />
	<c:forTokens items="${manifestContent}" var="manifestEntry" delims="
	">
		<c:if test="${ empty buildTime and not empty manifestEntry and fn:startsWith(manifestEntry, 'Built-On: ') }">
			<c:set var="buildTime" value="${fn:trim(fn:substringBefore(fn:substringAfter(manifestEntry, 'Built-On: '), ' EST'))}" />
		</c:if>
		<c:if test="${ empty env and not empty manifestEntry and fn:startsWith(manifestEntry, 'Target: ') }">
			<c:set var="env" value="${fn:trim(fn:substringAfter(manifestEntry, 'Target: '))}" />
		</c:if>
	</c:forTokens>

	<c:if test="${ env == 'NXI'}">

		<fmt:parseDate value="${buildTime}" var="parsedBuildTime" pattern="yyyy-MM-dd HH:mm:ss" />
		<fmt:formatDate type="both" value="${parsedBuildTime}" pattern="MM/dd/yyyy HH:mm:ss" var="formatedBuildTime" />

		<%-- HTML --%>
		<div id="aggTimer" class="fixedDevEnvDialog">
			<div><strong>NXI will be built in: </strong><span class="aggTimerCount"></span></div>
			<div><strong>Last built on: </strong><span class="aggTimerBuild"><c:out value="${buildTime}" /></span></div>
		</div>

		<%-- SCRIPT --%>
		<go:script>
			var target_time = new Date("${formatedBuildTime}").getTime() + 900000;
			var minutes, seconds;
			var $_timer = $('#aggTimer'), counter = $_timer.find('.aggTimerCount');

			var timer = setInterval(function () {

				var current_time = new Date().getTime();

				if (target_time < current_time){
					target_time += 900000 * Math.ceil((current_time-target_time)/900000);
					if(target_time-current_time >= 840000 ){
						$_timer.addClass('warning').find('div:first-child').html("<strong>NXI is building: refresh browser in 1 min</strong>");
						clearInterval(timer);
					}
				}

				var seconds_left = (target_time - current_time) / 1000;

				minutes = parseInt(seconds_left / 60);
				seconds = parseInt(seconds_left % 60);

				counter.html((minutes==0?"":minutes + "m, ") + seconds + "s");

			}, 1000);
		</go:script>
	</c:if>
</c:if>