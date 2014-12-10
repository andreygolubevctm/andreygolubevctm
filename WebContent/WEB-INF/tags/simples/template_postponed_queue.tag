<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-postponed-queue" type="text/html">

	<%-- POSTPONED --%>

	{{ if (typeof obj.messages !== 'undefined' && obj.messages.length > 0) { }}

		{{ _.each(obj.messages, function(message) { }}
			{{ var whenToAction = Date.parse(message.whenToAction) || false; }}
			{{ if (whenToAction !== false) { }}
			{{     whenToAction = new Date(whenToAction); }}
			{{     var inThePast = (whenToAction <= new Date()) ? ' in-the-past' : ''; }}
			{{     var upcoming  = (whenToAction <= (new Date().setHours(new Date().getHours() + 2))) ? ' upcoming-reminder' : ''; }}
			{{     var ampm = 'am'; }}
			{{     var hours = whenToAction.getHours(); }}
			{{     if (hours < 10) { }}
			{{         hours = '0' + hours; }}
			{{     } else if (hours == 12) { }}
			{{         ampm = 'pm'; }}
			{{     } else if (hours > 12) { }}
			{{         ampm = 'pm'; hours -= 12; }}
			{{     } }}
			{{     var minutes = (whenToAction.getMinutes() < 10) ? '0' + whenToAction.getMinutes() : whenToAction.getMinutes(); }}
			{{     whenToAction = whenToAction.getDayNameShort() + ' ' + whenToAction.getDate() + ' ' + whenToAction.getMonthNameShort() + ' ' + hours + ':' + minutes + ampm; }}
			{{ } else { }}
			{{     whenToAction = message.whenToAction; }}
			{{ } }}
			<a class="displayBlock well simples-postponed-message{{= inThePast }}{{= upcoming }}" data-messageId="{{= message.messageId }}" title="View this message">
				<ul>
					<li><strong>Tran ID:</strong> {{= message.transactionId }}</li>
					<li><strong>Name:</strong> {{= message.contactName }}</li>
					<%-- <li><strong>State:</strong> {{= message.state }}</li> --%>
					<li class="reminder"><strong>Reminder:</strong> {{= whenToAction }}</li>
				</ul>
			</a>
		{{ }) }}

	{{ } else { }}

		<p>No upcoming postponed messages.</p>

	{{ }/*postponed*/ }}

</script>