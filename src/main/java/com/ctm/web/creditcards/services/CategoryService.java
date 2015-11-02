package com.ctm.web.creditcards.services;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.creditcards.category.model.Category;
import com.ctm.web.creditcards.dao.CategoryDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

public class CategoryService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CategoryService.class);

	public static ArrayList<Category> getCategories(HttpServletRequest request) {
		CategoryDao categoryDao = new CategoryDao();
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			return categoryDao.getCategories(pageSettings.getVertical().getId(), pageSettings.getBrandId());
		}
		catch (Exception e) {
			LOGGER.error("Failed to retrieve categories", e);
		}

		return null;
	}

}
