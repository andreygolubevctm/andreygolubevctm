package com.ctm.services.creditcards;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.CategoryDao;
import com.ctm.model.Category;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SettingsService;

public class CategoryService {

	private static Logger logger = Logger.getLogger(CategoryService.class.getName());

	public static ArrayList<Category> getCategories(HttpServletRequest request) {
		CategoryDao categoryDao = new CategoryDao();
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			return categoryDao.getCategories(pageSettings.getVertical().getId(), pageSettings.getBrandId());
		}
		catch (Exception e) {
			logger.error(e);
		}

		return null;
	}

}
