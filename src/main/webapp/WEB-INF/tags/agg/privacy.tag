<%@ tag description="This controls areas and makes them private (hides on and off). This can be grouped with other Ajax type functions, e.g. to Pause phone recording and hide/show area"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--

	@todo This should be converted into a js module.
	I've already moved the CSS to privacyControl.less

--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"						required="true"		rtexprvalue="true"	 description="The xpath to the content" %>
<%@ attribute name="make_private"				required="true"		rtexprvalue="true"	 description="Whether the area should be controlled, true for control, false for letting the content through." %>
<%@ attribute name="control_label_makeVisible"	required="false"	rtexprvalue="false"	 description="The button label for enabling/showing the private area, default: Pause Recording" %>
<%@ attribute name="control_label_makeHidden"	required="false"	rtexprvalue="false"	 description="The button label for disabling/hiding the private area, default: Resume Recording" %>
<%@ attribute name="callback"					required="false"	rtexprvalue="false"	 description="Allows a callback function to be fired before any of the toggle features work" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:choose>
	<%-- Pass through --%>
	<c:when test="${make_private != true or make_private != 'true'}">
		<jsp:doBody />
	</c:when>
	<c:otherwise>

		<%-- Labels --%>
		<c:if test="${empty control_label_makeVisible}">
			<c:set var="control_label_makeVisible" value="Pause Recording" />
		</c:if>
		<c:if test="${empty control_label_makeHidden}">
			<c:set var="control_label_makeHidden" value="Resume Recording" />
		</c:if>

		<div class="agg_privacy" id="${name}">
			<button class="agg_privacy_button btn btn-save"><span>${control_label_makeVisible}</span></button>

			<div class="agg_privacy_container invisible">
				<jsp:doBody />
			</div>

			<button class="agg_privacy_button btn btn-save"><span>${control_label_makeVisible}</span></button>
		</div>

		<%-- CSS --%>
		<%-- MOVED TO privacyControl.less --%>

		<%-- Javascript --%>
		<c:if test="${empty callback}">
			<c:set var="callback" value="true;" />
		</c:if>

		<go:script marker="js-head">
			var privacy = {
				<%-- Use this call-back to try advanced functionality and return a true (success)/false(fail) (ajax with async false is recommended) --%>
				callback: function(state){
						return ${callback}
					},
				toggle: function($_obj){
					$_parent = $($_obj).closest('.agg_privacy');
					$_container =  $($_parent).find('.agg_privacy_container');
					var state = $_container.hasClass("invisible"); <%-- This is hidden/private --%>
					<%-- Check the callback --%>
					if(privacy.callback(state) !== true){
						return false;
					};
					<%-- This turns on/off the privacy control --%>
					if( state === true ){
						privacy.show($_parent, $_container);
					} else {
						privacy.hide($_parent, $_container);
					};
				},
				hide: function($_parent, $_container){
					$_container.addClass('invisible');
					$_parent.find('.agg_privacy_button span').html('${control_label_makeVisible}');
				},
				show: function($_parent, $_container){
					$_container.removeClass('invisible');
					$_parent.find('.agg_privacy_button span').html('${control_label_makeHidden}');
				},
			};
		</go:script>

		<go:script marker="onready">
			$('.agg_privacy').on('click', '.agg_privacy_button', function(event) {
				event.preventDefault();

				privacy.toggle($(this));
			});
		</go:script>

	</c:otherwise>
</c:choose>