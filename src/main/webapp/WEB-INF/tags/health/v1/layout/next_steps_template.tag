<h2 class="text-hospital">Next steps with {{= fundName}}</h2>
{{ if( _.indexOf(['Budget Direct','Bupa','Frank','GMHBA'],fundName) === -1  && typeof policyNo !== "undefined" && policyNo != null && policyNo != -1 && policyNo != "") { }}
<p><span class="important-text">Your new health insurance policy number with {{= fundName}} is {{= policyNo }}.</span></p>
{{ } }}