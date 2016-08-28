<h2 class="text-hospital">Next steps with {{= fundName}}</h2>
{{ if( fundName !== 'Bupa' &&  policyNo && policyNo !== -1) { }}
<p><span>Your new health insurance policy number with {{= fundName}} is {{= policyNo }}.</span></p>
{{ } }}