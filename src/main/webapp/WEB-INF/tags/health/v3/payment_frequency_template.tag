<script id="payment_frequency_options" type="text/html">
	{{ var selected = ''; }}
	{{ _.each(obj.paymentTypePremiums[obj.paymentNode], function(item, key) { }}
		{{ if (item.value > 0) { }}
			{{ selected = obj._selectedFrequency == key ? "selected" : "" }}
			{{ var label = ''; }}
			{{ if (key == 'annually') { }}
			{{ 		label = 'annual';  }}
			{{ } else if (key == 'halfyearly') { }}
			{{ 		label = 'half-yearly'; }}
			{{ } else { }}
			{{ 		label = key; }}
			{{ } }}
			<option value="{{= key}}" {{= selected}}>{{= item.text}} {{= label }} premium</option>
		{{ } }}
	{{ }); }}
</script>