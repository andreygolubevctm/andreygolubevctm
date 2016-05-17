<script id="payment_frequency_options" type="text/html">
	{{ var selected = ''; }}
	{{ _.each(obj.paymentTypePremiums[obj.paymentNode], function(item, key) { }}
		{{ if (item.value > 0) { }}
			{{ selected = obj._selectedFrequency == key ? "selected" : "" }}
			<option value="{{= key}}" {{= selected}}>{{= item.text}} {{= key }} premium</option>
		{{ } }}
	{{ }); }}
</script>