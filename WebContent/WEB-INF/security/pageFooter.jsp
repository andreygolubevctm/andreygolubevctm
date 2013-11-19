<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/security/core.jsp" %>

<c:choose>
	<c:when test="${ sessionScope != null and not empty(sessionScope.isLoggedIn) and sessionScope.isLoggedIn == 'true' }">
		<c:set var="logoutText" value="Log Out" />
		<c:set var="userInfo" value="${sessionScope.userDetails['displayName']} (${pageContext.request.remoteUser})" />
	</c:when>
	<c:otherwise>
		<c:set var="logoutText" value="Clear Session Details" />
		<c:set var="userInfo" value="" />
	</c:otherwise>
</c:choose>

						</div>
						<div class="footer"></div>
					</div>

					<%-- Copyright notice --%>
					<!-- div class="clearfix"><agg:copyright_notice /></div -->

				</div>
			</div>
		</div>
	</body>
</html>
