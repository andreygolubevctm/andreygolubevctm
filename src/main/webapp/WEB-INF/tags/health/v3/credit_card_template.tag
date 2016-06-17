<%@ tag description="The Health credit card template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="credit-card-template" type="text/html">
	<c:choose>
		<c:when test="${not empty callCentre}">
			{{ var checked = obj.inputSelected === true ? 'selected="selected"': '' }}
			<option id="{{=obj.inputid}}" value="{{=obj.inputvalue}}" {{= checked }}>{{=obj.inputlabel}}</option>
		</c:when>
		<c:otherwise>
			{{ var checked = obj.inputSelected === true ? 'checked="checked"': '' }}
			<label class="btn btn-form-inverse {{=obj.inputSelected === true ? 'active': '' }}">
			<input type="radio" name="{{=obj.inputname}}" id="{{=obj.inputid}}" value="{{=obj.inputvalue}}" data-msg-required="Please choose type of credit card" required="required" aria-required="true" {{= checked }} />
			{{=obj.inputlabel}}</label>
		</c:otherwise>
	</c:choose>
</script>