<%@ tag description="Returns an ADB badge a dialog link"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="abdModalContent" scope="request"><content:get key="abdModalContent"/></c:set>

<div class="abd-badge abd-modal-trigger">
  <a class="dialogPop" data-content="${abdModalContent}" title="What is the Age-Based Discount?">
    <div class="aged-based-inline">Aged based&nbsp;</div>
    <div class="word-discount-and-help-icon-inline">discount
      <span class="help-icon icon-info"></span>
    </div>
  </a>
</div>

