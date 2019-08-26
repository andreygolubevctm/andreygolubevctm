<%@ attribute name="shortTitle" 	required="true"	 rtexprvalue="true"	 description="determines if we should render the short link" %>

<div class="abd-modal-trigger">
  <a class="dialogPop" data-content="This is a Test" title="What is the Age-Based Discount?">${shortTitle ? "What's this?" : "What is an Age-Based Discount?" }</a>
</div>