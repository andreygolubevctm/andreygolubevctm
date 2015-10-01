<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:new verticalCode="UTILITIES" authenticated="true" />

<core_new:quote_check quoteType="utilities" />
<c:set var="callCentreNumber" scope="request"><content:get key="genericCallCentreNumber"/></c:set>
<c:set var="callCentreHelpNumber" scope="request"><content:get key="genericCallCentreHelpNumber"/></c:set>

<layout:journey_engine_page title="Energy Confirmation">

	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:attribute name="head_meta">
	</jsp:attribute>

	<jsp:attribute name="header">
		<div class="navbar-collapse header-collapse-contact collapse">
			<ul class="nav navbar-nav navbar-right">
				<c:if test="${not empty callCentreNumber}">
					<li>
						<div class="navbar-text hidden-xs" data-livechat="target">
							<h4>Call us on</h4>

							<h1><span class="noWrap" id="navbar-call-center-number">${callCentreNumber}</span></h1>
							<div class="opening-hours">
                            <span>
                                <span class="today-hours"><content:get key="utilitiesOpeningHours" /></span>
                            </span>
							</div>
						</div>
						<div class="navbar-text hidden-xs" data-poweredby="header">&nbsp;</div>
					</li>
				</c:if>
			</ul>
		</div>
	</jsp:attribute>

	<jsp:attribute name="navbar">
		<ul class="nav navbar-nav confirmation">
          <li><a href="javascript:window.print();" class="btn-email"><span class="icon icon-blog"></span> <span>Print Page</span></a></li>
            <li>
              <a href="${pageSettings.getBaseUrl()}utilities_quote.jsp" class="btn-cta needsclick"><span class="icon icon-undo"></span> <span>Start a new quote</span> <span class="icon icon-arrow-right hidden-xs"></span></a>
            </li>
        </ul>
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
		<core:whitelabeled_footer/>
	</jsp:attribute>

	<jsp:attribute name="vertical_settings">
		<utilities_new:settings/>
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:attribute name="before_close_body">
      <content:get key="beforeCloseBody" suppKey="confirmation" />
	</jsp:attribute>

  <jsp:body>
    <utilities_new_layout:slide_confirmation />
  </jsp:body>

</layout:journey_engine_page>
