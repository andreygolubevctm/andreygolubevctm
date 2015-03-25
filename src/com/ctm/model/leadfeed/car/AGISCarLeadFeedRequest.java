package com.ctm.model.leadfeed.car;

import org.joda.time.LocalDate;
import org.joda.time.LocalTime;

import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;

public class AGISCarLeadFeedRequest extends AGISLeadFeedRequest {

	/**
	 * Map CTM White label codes to AGIS Lead Feed codes
	 *
	 */
	public static enum StyleCodeMapping {
		COMPARE_THE_MARKET("CTM"),
		CAPTAIN_COMPARE("CC"),
		CHOOSI("CHOO");

		private final String ctmCode;

		StyleCodeMapping(String ctmCode) {
			this.ctmCode = ctmCode;
		}

		public String getCtmCode() {
			return ctmCode;
		}
	}

	/**
	 * A&G Lead Feed Messages queues available (source and message are both prefixed with the code from the mapping object above.
	 *
	 */
	public static enum MessageData {
		CTM_REQUEST_CALLBACK( "CTMCAR", "CTM - Car Vertical - Call me now", "CTM0000300"),
		CTM_BEST_PRICE("CTBESTPRC", "CTM - Car Vertical - Best price", "CTM0000300"),
		CHOOSI_REQUEST_CALLBACK("CHCAR", "CH - Car Vertical - Call me now", "CHI0000300"),
		CHOOSI_BEST_PRICE("CHBESTPRC", "CH - Car Vertical - Best price", "CHI0000300"),
		CAPTAIN_COMPARE_REQUEST_CALLBACK("CCCAR", "CC - Car Vertical - Call me now", "CCX0000300"),
		CAPTAIN_COMPARE_BEST_PRICE("CCBESTPRC", "CC - Car Vertical - Best price", "CCX0000300");

		private final String source;
		private final String message;
		private final String partnerId;

		MessageData(String source, String message, String partnerId) {
			this.source = source;
			this.message = message;
			this.partnerId = partnerId;
		}

		public String getSource() {
			return source;
		}

		public String getMessage() {
			return message;
		}

		public String getPartnerId() {
			return partnerId;
		}

	}

	/**
	 * Create a SOAP request object to send to AGIS
	 * @param messageData
	 * @param leadData
	 */
	public AGISCarLeadFeedRequest(MessageData messageData, LeadFeedData leadData) {

		super();

		setMessageSource(messageData.getSource());
		setMessageText(messageData.getMessage());

		setPartnerId(messageData.getPartnerId()); // hardcoded above for now - to be dynamic in CAR-886
		setSourceId("0000000002"); // hardcoded for now - to be dynamic in CAR-886

		importLeadData(leadData);

		setCallbackDate(new LocalDate());
		setCallbackTime(new LocalTime());

	}
}
