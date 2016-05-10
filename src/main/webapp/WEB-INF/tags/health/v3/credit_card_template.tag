<%@ tag description="The Health credit card template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- LOGO AND PRICES TEMPLATE --%>
<script id="credit-card-template" type="text/html">
		<label class="btn btn-form-inverse {{=obj.inputSelected === true ? 'active': '' }}">
		<input type="radio" name="{{=obj.inputname}}" id="{{=obj.inputid}}" value="{{=obj.inputvalue}}" data-msg-required="Please choose type of credit card" required="required" aria-required="true" {{= obj.inputSelected === true ? 'checked="checked"': '' }} />
		{{=obj.inputlabel}}</label>
</script>