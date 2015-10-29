package com.ctm.web.creditcards.category.router;

import com.ctm.web.creditcards.category.model.Category;
import com.ctm.model.Error;
import com.ctm.services.SettingsService;
import com.ctm.web.creditcards.services.CategoryService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;


@WebServlet(urlPatterns = {
		"/category/list.json"
})
public class CategoryRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(CategoryRouter.class);
	private static final long serialVersionUID = 72L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		try {

			ObjectMapper objectMapper;
			// Set the vertical in the request object - required for loading of Settings and Config.
			SettingsService.setVerticalAndGetSettingsForPage(request, request.getParameter("verticalCode"));

			// Route the requests ////////////////

			if (uri.endsWith("/category/list.json")) {

				ArrayList<Category> Category = CategoryService.getCategories(request);
				objectMapper = new ObjectMapper();
				objectMapper.writeValue(writer, Category);
			}

		}catch (Exception e) {

			LOGGER.error("Category fetch failed", e);

			JSONObject json = null;
			Error error = new Error();
			error.addError(new Error("An error occurred fetching categories."));
			json = error.toJsonObject(true);

			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

			writer.print(json.toString());
		}

	}

}
