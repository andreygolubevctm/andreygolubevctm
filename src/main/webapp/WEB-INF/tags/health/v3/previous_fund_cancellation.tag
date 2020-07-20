<%@ tag description="The Simples Previous Fund Cancellation"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="previous cancellation's xpath" %>
<%@ attribute name="type" required="true"	 rtexprvalue="true"	 description="the person type" %>

			<div class="simples-dialogue-cancellation-type-${type} simples-dialogue row-content mandatory hidden">
				<div class="wrapper">
					<field_v2:checkbox
						xpath="health/simples/dialogue-checkbox-cancel-funds-${type}"
						value="Y"
						required="true"
						label="true"
						errorMsg="Please confirm each mandatory dialog has been read to the client"
						className="checkbox-custom simples_dialogue-checkbox-cancel-funds-${type}"
						title="You are purchasing only Hospital. Would you like to cancel your current Extras cover or just Hospital?" />

          <c:set var="fieldXpath" value="${xpath}/${type}/fundCancellationType" />
          <field_v2:array_radio id="health_previous_fund_cancellation_type_${type}" xpath="${fieldXpath}" required="true" items="C=Cancel Hospital + Extras,E=Cancel Extras Only,H=Cancel Hospital Only,KH=Keep Hospital Only,KE=Keep Extras Only" title="" className="hidden health-cover-cancel-funds" />
				</div>
		</div>