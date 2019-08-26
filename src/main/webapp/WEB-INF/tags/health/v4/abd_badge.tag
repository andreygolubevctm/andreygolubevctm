<%@ attribute name="adbType" 	required="true"	 rtexprvalue="A"	 description="Returns an ADB badge" %>

<div class="abd-badge">
  ${adbType === 'A' : "Receive Age-Based Discount" : ""}
  ${adbType === 'R' : "Retain Age-Based Discount" : ""}
</div>