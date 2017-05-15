package com.ctm.web.core.content.services;

import com.ctm.web.core.content.model.ContentSupplement;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.RandomNumberGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public class RandomContentService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ContentService.class);

	private boolean hasSupplementaryValue;
	private String supplementaryValue;

	public void init(ContentService contentService, HttpServletRequest request, String contentKey) {
		hasSupplementaryValue = false;
		try {
			RandomNumberGenerator random = new RandomNumberGenerator();
			List<ContentSupplement> collection = contentService.getContentWithSupplementaryNonStatic(request, contentKey).getSupplementary();
			int size = collection.size();
			if(collection.isEmpty()) {
				LOGGER.error("Could not find content {}." , contentKey);
			} else {
				hasSupplementaryValue = true;
				supplementaryValue = collection.get(random.getRandomNumber(size)).getSupplementaryValue();
			}
		} catch (DaoException | ConfigSettingException e) {
			LOGGER.error("Could not find content {}." , contentKey);
		}

	}


	public boolean hasSupplementaryValue() {
		return hasSupplementaryValue;
	}

	public String getSupplementaryValue() {
		return supplementaryValue;
	}
}
