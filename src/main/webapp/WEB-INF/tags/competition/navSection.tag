<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical" required="true" description="vertical"%>

<c:if test="${octoberComp}">
  <div class="octoberComp__navbarContainer" style="display: none;">
    <div class="octoberComp__navbar">
      <div class="col-sm-3 octoberComp__navbar__header">A winner every day!</div>
      <div class="col-sm-9">Buy ${vertical} for your chance to win a share of $81,000. <br /><a target="_blank" href="https://www.comparethemarket.com.au/competition/october_promotion_2017.pdf">T&C's apply</a></div>
    </div>
  </div>
</c:if>
