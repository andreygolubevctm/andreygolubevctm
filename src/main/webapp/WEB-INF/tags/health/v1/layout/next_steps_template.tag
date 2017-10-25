<h2 class="text-hospital">Next steps with {{= fundName}}</h2>
{{ if( _.indexOf(['Budget Direct','Bupa','Frank','GMHBA'],fundName) === -1  &&  policyNo && policyNo !== -1) { }}
<p><span class="important-text">Your new health insurance policy number with {{= fundName}} is {{= policyNo }}.</span></p>
{{ } }}