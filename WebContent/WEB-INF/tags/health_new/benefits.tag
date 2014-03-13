<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="dropdown-container">
	<form class="benefits-component">

		<div class="hidden-xs">
			<h2>What matters to you?</h2>
			<p>
				When considering health policies, it's important you review the included hospital and extras benefits. Personalise these quotes by choosing benefits to suit your needs.
			</p>
		</div>

		<div class="hr hidden-xs mt"></div>

		<div class="scrollable row">

			<div class="benefits-list col-sm-12">
				<div class="row">
					<%-- Note: ${resultTemplateItems} is a request scoped variable on health_quote.jsp page - as it is used in multiple places --%>
					<c:forEach items="${resultTemplateItems}" var="selectedValue">
						<health_new:benefitsItem item="${selectedValue}" />
					</c:forEach>
				</div>
			</div>


			<div class="ambulance col-sm-12">
				<div class="hr mb mt"></div>
				<%-- FYI, ambulance is not in the correct place as in the concept designs, if this is an issue and needs to move, you will have to do it via js --%>
				<h6>Ambulance Cover</h6>
				<p>
					Health policies can include varying levels of ambulance cover. We will present a range of options available in our product results.
				</p>
			</div>



		</div><%-- /scrollable --%>



		<div class=" footer">

				<button type="button" class="btn btn-default btn-cancel popover-mode">Cancel</button>
				<button type="button" class="btn btn-primary btn-save popover-mode">Save changes</button>
				<a type="button" class="btn btn-primary btn-save journey-mode" href="javascript:;">Get Prices <span class="icon icon-arrow-right"></span></a>

		</div>

	</form>
</div>