<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<c:set var="verticalCode" value="${param.verticalCode}" />
<c:set var="brands" value="${applicationService.getEnabledBrandsForVertical(verticalCode)}" />
<c:set var="baseUrl" value="${pageSettings.getBaseUrl()}" />

<c:choose>
	<c:when test="${brands.size() > 1}">

		<%-- More than one brand is enabled for this vertical, force the operator to select the brand they want --%>


		<c:set var="pageTitle" value="Brands available for new ${fn:toLowerCase(verticalCode)} quote" />

		<layout:simples_page>
			<jsp:attribute name="head">
			</jsp:attribute>

			<jsp:body>

				<layout:slide_columns sideHidden="true">

					<jsp:attribute name="rightColumn">
					</jsp:attribute>

					<jsp:body>

						<form_new:fieldset legend="${pageTitle}">
							<ul>
								<c:forEach items="${brands}" var="brand">

									<li style="padding:5px 0px;">
										<a style="text-decoration:underline" class="needs-loadsafe" href="${baseUrl}simples/redirectToBrand.jsp?brandId=${brand.getId()}&verticalCode=${verticalCode}&vdn=${param.vdn}">
											<c:out value="${brand.getName()}" />
										</a>
									</li>

								</c:forEach>
							</ul>
						</form_new:fieldset>

					</jsp:body>

				</layout:slide_columns>

			</jsp:body>
		</layout:simples_page>

	</c:when>
	<c:when test="${brands.size() == 1}">

		<%-- Only one brand is enabled, redirect automatically. --%>
		<c:set var="brand" value="${brands.get(0)}" />
		<c:redirect url="${baseUrl}simples/redirectToBrand.jsp?brandId=${brand.getId()}&verticalCode=${verticalCode}&vdn=${param.vdn}"/>

	</c:when>
	<c:otherwise>

		<%-- This shouldn't happen --%>
		<h1>ERROR - no brands enabled for this vertical - check database settings and params sent to this page.</h1>

	</c:otherwise>
</c:choose>