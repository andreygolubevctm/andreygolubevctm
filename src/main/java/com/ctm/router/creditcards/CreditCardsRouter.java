package com.ctm.router.creditcards;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import com.ctm.exceptions.UploaderException;
import com.ctm.model.Error;
import com.ctm.model.creditcards.CreditCardProduct;
import com.ctm.model.creditcards.UploadRequest;
import com.ctm.model.creditcards.Views.ComparisonView;
import com.ctm.model.creditcards.Views.DetailedView;
import com.ctm.model.creditcards.Views.MapView;
import com.ctm.model.creditcards.Views.SummaryView;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.router.FileUploadRouter;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import com.ctm.services.SettingsService;
import com.ctm.services.creditcards.ProductService;
import com.ctm.services.creditcards.UploadService;
import com.ctm.utils.creditcards.CreditCardsSortAlgorithms;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;


@WebServlet(urlPatterns = {
		"/creditcards/products/details.json",
		"/creditcards/products/list.json",
		"/creditcards/products/productIdMap.json",
		"/creditcards/products/import",
})
public class CreditCardsRouter extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(CreditCardsRouter.class.getName());
	private static final long serialVersionUID = 70L;

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
			SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.CREDITCARD.getCode());
			String authToken = request.getParameter("authorisationToken");
			PageSettings settings = SettingsService.getPageSettingsByCode(ApplicationService.getBrandFromRequest(request).getCode(), VerticalType.CREDITCARD.getCode());

			if(authToken == null || (authToken != null && !authToken.equals(settings.getSetting("CreditCardsApiAuthToken")))) {
				logger.error("/creditcards AuthToken provided does not match");

				JSONObject json = null;
				Error error = new Error();
				error.addError(new Error("Unauthorised"));
				json = error.toJsonObject(true);
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				writer.print(json.toString());
				FatalErrorService.logFatalError(0, uri, request.getSession().getId(), true, "Authorisation Failure", "Token provided: " + authToken, null);
				return;
			}

			// Route the requests ///////////////////////////////////////////////////////////////////////////////
			ProductService productService = new ProductService();

			if (uri.endsWith("/creditcards/products/details.json")) {

				// Get params
				ArrayList<String> productCodes = getParamAsArray(request.getParameter("productCodes"));
				boolean showFeatures = getParamAsBoolean(request.getParameter("showFeatures"));
				boolean showInformation = getParamAsBoolean(request.getParameter("showInformation"));

				// Call the database and get the products

				ArrayList<CreditCardProduct> creditCards = productService.getProductsByCode(request, productCodes);

				// Write the JSON Object
				objectMapper = new ObjectMapper();
				ObjectWriter wr;


				if(showInformation){
					wr = objectMapper.writerWithView(DetailedView.class); // DetailedView includes ComparisonView & SummaryView
				}else if(showFeatures){
					wr = objectMapper.writerWithView(ComparisonView.class);
				}else{
					wr = objectMapper.writerWithView(SummaryView.class);
				}

				wr.writeValue(writer, creditCards);

			} else if (uri.endsWith("/creditcards/products/list.json")) {

				// Get params
				int numberOfResultsToReturn = getParamAsInt(request.getParameter("numberOfResultsToReturn"));

				String categoryCode = request.getParameter("categoryCode");
				categoryCode = categoryCode == null || categoryCode.equals("") ? null : categoryCode;

				String providerCode = request.getParameter("providerCode");
				providerCode = providerCode == null || providerCode.equals("") ? null : providerCode;

				String sortField = request.getParameter("sortField");
				sortField = sortField == null || sortField.equals("") ? "interestRate" : sortField;


				ArrayList<CreditCardProduct> creditCards = productService.getProducts(request, categoryCode, providerCode, numberOfResultsToReturn);
				/**
				 * Sorting using collections and custom sortRules.
				 */
				Comparator<CreditCardProduct> sortRule = CreditCardsSortAlgorithms.getSortAlgorithm(sortField);
				if(sortRule != null) {
					Collections.sort(creditCards, sortRule);
				}
				objectMapper = new ObjectMapper();
				ObjectWriter wr = objectMapper.writerWithView(SummaryView.class);
				wr.writeValue(writer, creditCards);

			} else if (uri.endsWith("/creditcards/products/productIdMap.json")) {

				ArrayList<CreditCardProduct> creditCards = productService.getWordpressSlugToCodeMap(request);
				objectMapper = new ObjectMapper();
				ObjectWriter wr = objectMapper.writerWithView(MapView.class);
				wr.writeValue(writer, creditCards);
			}


		}catch (Exception e) {

			logger.error("/creditcards json failed: ", e);

			JSONObject json = null;
			Error error = new Error();
			error.addError(new Error("Failed to get results"));
			json = error.toJsonObject(true);

			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

			writer.print(json.toString());

			FatalErrorService.logFatalError(e, 0, uri, request.getSession().getId(), true);

		}

	}

	/* TODO: Whenever a refactor is done, will need to look at TravelRouter.java as it was a copy of the doPost function */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();

		if(uri.endsWith("/creditcards/products/import")){
			try {
				UploadRequest file = null;
				FileUploadRouter router = new FileUploadRouter();
				file = router.Upload(request, response);

				String attachmentName = file.jira+"_import_creditcard_"+file.providerCode+".sql";
				InputStream input =
						new ByteArrayInputStream(UploadService.getRates(file).getBytes("UTF-8"));

				response.setContentType("text/plain");
				response.addHeader("Content-Disposition", "attachment; filename="+attachmentName);

				OutputStream responseOutputStream = response.getOutputStream();
				int bytes;
				while ((bytes = input.read()) != -1) {
					responseOutputStream.write(bytes);
				}
				input.close();
				responseOutputStream.flush();
				responseOutputStream.close();


			} catch (UploaderException e) {
				logger.error("{}",e);
			}
		}
	}

	private ArrayList<String> getParamAsArray(String param){
		ArrayList<String> arrayList = new ArrayList<String>();
		if(param != null){
			String pcs[] = param.split(",");
			arrayList.addAll(Arrays.asList(pcs));
		}
		return arrayList;
	}

	private boolean getParamAsBoolean(String param){
		return param != null && param.equals("true");
	}

	private int getParamAsInt(String param){
		if(param != null && param.equals("") == false){
			return Integer.parseInt(param);
		}
		return -1;
	}

}
