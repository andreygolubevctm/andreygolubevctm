<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:if test="${octoberComp}">
  <div class="octoberComp__navbarContainer">
    <div style="display: none;" class="octoberComp__navbar">
      <div class="col-sm-3 octoberComp__navbar__header">A winner every day!</div>
      <div class="col-sm-9">Buy home & contents insurance for your chance to win a share of $81,000. <a target="_blank" href="https://secure.comparethemarket.com.au/static/legal/october_promotion.pdf">T&C's apply</a></div>
    </div>
  </div>
</c:if>
