<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="SIMPLES" />

<%@ include file="/WEB-INF/security/core.jsp" %>

<layout:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>

		<c:choose>
			<c:when test="${!isRoleSupervisor}">
				<div class="alert alert-danger">You are not authorised to view this page ('supervisor' only).</div>
			</c:when>
			<c:otherwise>


				<h2>Hawking Status</h2>

				<div data-provide="simples-harking-status">

					<field_new:array_radio xpath="health/simples/hawking" items="ON=ON,OFF=OFF" required="true" title="Hawking On/Off" />

				</div>

				<script>
					$(document).ready(function() {
						if (window.parent.meerkat && window.parent.meerkat.modules.paymentGateway) {
							window.parent.meerkat.modules.simplesActions.setHawkingInput();
						}
					});
				</script>

			</c:otherwise>
		</c:choose>

	</jsp:body>
</layout:simples_page>
