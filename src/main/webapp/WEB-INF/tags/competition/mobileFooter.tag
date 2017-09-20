<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical" required="true" description="vertical"%>

<c:if test="${octoberComp}">
  <div class="octoberComp">
    <div class="octoberComp__mobile">
      <h2>A winner every day!</h2>
      <p>Buy ${vertical} insurance for your chance to win a share of $81,000. <a target="_blank" href="https://secure.comparethemarket.com.au/static/legal/october_promotion.pdf
">T&C's apply.</a></p>
      <div class="octoberComp__mobile__trigger"><span class="octoberComp__mobile__trigger__icon icon-angle-up"></span></div>
    </div>
  </div>
</c:if>
