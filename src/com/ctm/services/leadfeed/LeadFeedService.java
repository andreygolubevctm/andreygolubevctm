package com.ctm.services.leadfeed;

import com.ctm.services.AccessTouchService;

public abstract class LeadFeedService {

	protected Boolean recordTouch(Long transactionId, String touchType) {
		AccessTouchService touchService = new AccessTouchService();
		return touchService.recordTouch(transactionId, touchType);
	}
}
