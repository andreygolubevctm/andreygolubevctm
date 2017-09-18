<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Competition Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:if test="${octoberComp}">
  <div class="octoberComp">
    <div class="octoberComp__mobile octoberComp__mobile--active">
      <img class="octoberComp__mobile__image--active" src="/ctm/assets/brand/ctm/competition/octoberComp/mobile-active.png" />
      <img class="octoberComp__mobile__image" src="/ctm/assets/brand/ctm/competition/octoberComp/mobile.png" />
      <div class="octoberComp__mobile__trigger"><span class="octoberComp__mobile__trigger__icon icon-angle-down"></span></div>
    </div>
  </div>
</c:if>
