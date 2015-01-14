<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component - Extra"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="className" required="false" rtexprvalue="true" description="Optional class name for panel element"%>

<c:if test="${pageSettings.getBrandCode() eq 'ctm'}"> <%-- Only render for CTM if at all --%>
	<jsp:useBean id="splitTests" class="com.ctm.services.tracking.SplitTestService" />
	<c:if test="${splitTests.isActive(pageContext.getRequest(), data.current.transactionId, 6)}">
		<div class="price-promise-panel ${className} hidden-xs">
			<div class="row">
				<div class="col-sm-12">
					<div class="partition"><!-- empty --></div>
					<table>
						<tbody>
							<tr>
								<td class="logo">
									<div><!-- empty --></div>
								</td>
								<td>
									<h6>Our Price Promise To You</h6>
									<p>Buy car insurance through us and if you then find a better price on the same policy from the same insurer within 30 days, we'll give you $50.
									<br><strong><small>see <a href="http://www.comparethemarket.com.au/car-insurance/price-promise/" target="_blank">terms and conditions</a></small></strong></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
	</c:if>
</c:if>