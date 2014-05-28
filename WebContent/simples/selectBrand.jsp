<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<settings:setVertical verticalCode="${param.verticalCode}" />
<session:getAuthenticated />

<c:set var="brands" value="${applicationService.getEnabledBrandsForVertical(param.verticalCode)}"/>

<c:choose>
	<c:when test="${brands.size() > 1}">

		<%-- More than one brand is enabled for this vertical, force the operator to select the brand they want --%>

		<c:set var="pageTitle" value="Brands available for new ${fn:toLowerCase(param.verticalCode)} quote" />
		<%@ include file="/WEB-INF/security/pageHeader.jsp" %>

		<%-- Simple hack to prevent simples users from double clicking links and to give instant feedback that their click worked. --%>
		<script>
			$(document).ready(function() {
				$(".brandLink").click(function(event){				
					$("#brandListUl").hide();
					$("#loading").show();
				});
			});
		</script>
		
		<div class="fieldrow">
	
			<div class="fieldrow_label">Select brand</div>
			<div class="fieldrow_value">
				<ul id="brandListUl">
					<c:forEach items="${brands}" var="brand">				
						
						<li style="padding:5px 0px;">						
							<a style="font-size:14px;" class="brandLink" href="simples/redirectToBrand.jsp?brandId=${brand.getId()}&verticalCode=${param.verticalCode}">
								${brand.getName()}
							</a>
						</li>
						
					</c:forEach>
				</ul>
				<div id="loading" style="display:none;padding:15px;">Loading...</div>
			</div>
			<div style="clear:both"></div>
		</div>

		<%@ include file="/WEB-INF/security/pageFooter.jsp" %>

	</c:when>
	<c:when test="${brands.size() == 1}">
		
		<%-- Only one brand is enabled, redirect automatically. --%>
		<c:set var="brand" value="${brands.get(0)}" />
		<c:redirect url="${pageSettings.getBaseUrl()}simples/redirectToBrand.jsp?brandId=${brand.getId()}&verticalCode=${param.verticalCode}"/>

	</c:when>
	<c:otherwise>
		
		<%-- This shouldn't happen --%>
		<h1>ERROR - no brands enabled for this vertical - check database settings and params sent to this page.</h1>

	</c:otherwise>
</c:choose>