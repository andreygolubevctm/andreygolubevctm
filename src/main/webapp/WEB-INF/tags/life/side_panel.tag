<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:style marker="css-head">
  .right-panel {
    margin-top: 68px;
  }

  #sidePanel h1,
  #sidePanel h2 {
    color: #0CB24E;
  }

  #sidePanel h1 {
    font-size: 19px;
  }

  #sidePanel h2 {
    font-size: 16px;
    font-weight: normal;
    margin-top: 5px;
  }

  #sidePanel p {
    margin-top: 10px;
    line-height: 16px;
    text-align: justify;
  }
</go:style>

<agg:panel>
  <div id="sidePanel">
    <h1>Need help?</h1>
    <h2>Use our cover calculator</h2>
    <life:popup_calculator />
    <p>The calculated amount of insurance cover is an estimate that is indicative of the level of cover likely to be appropriate for persons with similar details to those which you have supplied. It may not be appropriate to you after having regard to other factors such as your objectives or particular needs.</p>
  </div>
</agg:panel>