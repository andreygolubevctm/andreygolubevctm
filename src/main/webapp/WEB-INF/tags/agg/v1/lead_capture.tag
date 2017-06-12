<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="vertical" required="true" description="vertical checkbox to show" %>
<%@ attribute name="label" required="true" description="checkbox label" %>
<%@ attribute name="heading" required="true" description="heading" %>
<%@ attribute name="info" required="false" description="info label" %>
<%@ attribute name="baseXpath" required="true" rtexprvalue="true"	description="variable's xpath" %>

<c:set var="xpath" value="${baseXpath}/leadCapture/${vertical}" scope="session" />
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<span class="optional-tag">optional</span>
<form_v2:fieldset className="lead-capture" legend="${heading}">
  <c:if test="${not empty info}">
    <div class="info">${info}</div>
  </c:if>
  <div class="radioBtnContainer clearfix">
    <ui:bubble variant="help">
      <h4>Hi</h4>
      <p><content:get key="leadCaptureWellHelpText"/></p>
    </ui:bubble>
    <div class="radioBtn">
      <input type="hidden" value="N" id="${name}" name="${name}" />
      <input name="${vertical}-crosssell-checkbox" id="${vertical}-crosssell-checkbox" type="checkbox" />
      <label for="${vertical}-crosssell-checkbox" class="${name}">
        <div class="tick-checkbox">
          <i class="icon-tick"></i>
        </div>
        <i class="icon-${vertical}"></i>
      </label>
      <div class="product-name">${label}</div>
    </div>
  </div>
</form_v2:fieldset>
