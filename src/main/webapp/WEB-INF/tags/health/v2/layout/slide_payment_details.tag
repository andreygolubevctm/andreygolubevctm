<%@ tag description="The Health Journey's 'Payment Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="paymentForm">

	<layout_v1:slide_columns sideHidden="true">

		<jsp:attribute name="rightColumn">
			<health_v1:policySummary showProductDetails="true" />
			<health_v2_content:sidebar />
		</jsp:attribute>

		<jsp:body>

			<layout_v1:slide_content>

				<health_v2:payment xpath="${pageSettings.getVerticalCode()}/payment" />

				<simples:dialogue id="38" vertical="health" mandatory="true" className="simples-dialog-inbound" />
				<simples:dialogue id="40" vertical="health" mandatory="true" className="simples-dialog-inbound" />
				<simples:dialogue id="94" vertical="health" mandatory="true" className="simples-dialog-referral" />
				<simples:dialogue id="95" vertical="health" mandatory="true" className="simples-dialog-referral" />

				<health_v2:declaration xpath="${pageSettings.getVerticalCode()}/declaration" />
				<health_v1:contactAuthority xpath="${pageSettings.getVerticalCode()}/contactAuthority" />
				<health_v2:whats-next />

				<c:if test="${callCentre and not empty worryFreePromo and worryFreePromo eq '35'}">
					<div class="simples-dialogue row-content  optionalDialogue">
						<c:set var="simplesCompCopy"><content:get key="worryFreePromoSimplesCopy_Body" /></c:set>
						<h3><content:get key="worryFreePromoSimplesCopy_Title" /></h3>
						<div>
							<field_v2:checkbox
									xpath="${pageSettings.getVerticalCode()}/competition/optin"
									value="Y"
									className="validate"
									required="false"
									label="${true}"
									title="${simplesCompCopy}"
									errorMsg="" />
						</div>
					</div>
				</c:if>

				<form_v2:row id="confirm-step" hideHelpIconCol="true">
					<a href="javascript:void(0);" class="btn btn-next col-xs-12 col-sm-8 col-md-5 journeyNavButton" id="submit_btn" <field_v1:analytics_attr analVal="nav link" quoteChar="\"" />>Submit Application <span class="icon icon-arrow-right"></span></a>
				</form_v2:row>

				<health_v2_confirmation:modal />

			</layout_v1:slide_content>

		</jsp:body>

	</layout_v1:slide_columns>

</layout_v1:slide>