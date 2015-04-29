<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Edit Details Dropdown"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="action" required="true" rtexprvalue="true" description="action request param received" %>

<%-- Load in copy for template --%>
<c:set var="contentItem" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "loadQuoteCopy")}' />
<c:set var="copy" value="${contentItem.getSupplementaryValueByKey(action)}" />

<c:if test="${pageSettings.getVerticalCode() eq 'home'}">
	<c:set var="coverType">
		<c:choose>
			<c:when test="${fn:contains(data.home.coverType, 'Home Cover')}">home</c:when>
			<c:when test="${fn:contains(data.home.coverType, 'Home & Contents')}">home &amp; contents</c:when>
			<c:otherwise>contents</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="copy" value="${fn:replace(copy,'{coverType}',coverType)}" />
</c:if>

<%-- Additional template copy --%>
<div class="panel-group accordion accordion-xs" id="edit-details-expired-panel-group">
	<div class="panel accordion-panel expired-panel col-xs-12 col-sm-12 col-lg-24">
		<div class="accordion-collapse collapse in expired-panel">
			<div class="accordion-body">
				${copy}
				<div class="column col-xs-12 col-sm-9 col-md-7">
					<form id="modal-commencement-date-form" method="post" class="form-horizontal">
						<div class="form-group row fieldrow">
							<label for="quote_options_commencementDate_mobile" class="column col-xs-12 col-sm-7 control-label">Please select a new commencement date</label>
							<div class="column col-xs-12 col-sm-5 row-content">
								<field_new:mobile_commencement_date_dropdown xpath="${xpath}" required="true" title="commencement" startDate="${data[xpath]}" />
							</div>
							<div class="fieldrow_legend" id="quote_options_commencementDate_mobile_row_legend"></div>
						</div>
					</form>
				</div>
				<div class="column col-xs-12 col-sm-3 col-md-5">
					<a id="modal-commencement-date-get-quotes" class="btn btn-success btn-block" data-slide-control="next" href="javascript:;">Get Quotes <span class="icon icon-arrow-right"></span></a>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
</div>