package com.ctm.services.creditcards;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.ProductDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.CreditCardServiceException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Product;
import com.ctm.model.creditcards.CreditCardProduct;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;

public class ProductService {

	public ProductService(){
		productDao = new ProductDao();
	}

	private static Logger logger = Logger.getLogger(ProductService.class.getName());
	private ProductDao productDao;

	public void setProductDao(ProductDao productDao) {
		this.productDao = productDao;
	}


	/**
	 * Return products for a specific category and/or provider code
	 *
	 * @param request
	 * @param categoryCode Optional
	 * @param providerCode Optional
	 * @param numberOfProductsToReturn -1 returns all products
	 * @return
	 */
	public ArrayList<CreditCardProduct> getProducts(HttpServletRequest request, String categoryCode, String providerCode, int numberOfProductsToReturn){

		String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
		try {
			ArrayList<Product> products;

			if(categoryCode == null && providerCode == null){
				throw new CreditCardServiceException("At least one category code or provider code must be provided");
			}else if(categoryCode == null){
				products = productDao.getByProviderCode(verticalCode, providerCode, ApplicationService.getApplicationDate(request), false, false);
			}else{
				products = productDao.getByCategoryCode(verticalCode, categoryCode, ApplicationService.getApplicationDate(request), providerCode, false, false);
			}

			ArrayList<CreditCardProduct> creditCards = new ArrayList<CreditCardProduct>();

			for(Product product: products){
				CreditCardProduct creditCard = new CreditCardProduct();
				creditCard.importFromProduct(product);
				creditCards.add(creditCard);
			}

			// TODO SORTING RULES GO HERE

			if(numberOfProductsToReturn != -1 && creditCards.size() > numberOfProductsToReturn){
				ArrayList<CreditCardProduct> filteredList = new ArrayList<>();
				filteredList.addAll(creditCards.subList(0, numberOfProductsToReturn));
				creditCards = filteredList;
			}

			return creditCards;

		} catch (DaoException e) {
			throw new CreditCardServiceException(e.getMessage());
		}

	}

	public ArrayList<CreditCardProduct> getProductsByCodeAsString(HttpServletRequest request, String productCode) {
		ArrayList<String> arrayList = new ArrayList<String>();
		arrayList.add(productCode);
		return getProductsByCode(request, arrayList);

	}
	/**
	 *
	 * @param request
	 * @param code
	 * @return
	 */
	public ArrayList<CreditCardProduct> getProductsByCode(HttpServletRequest request, ArrayList<String> productCodes){
		String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
		try {
			ArrayList<CreditCardProduct> creditCards = new ArrayList<CreditCardProduct>();

			for(String productCode : productCodes){
				Product product = productDao.getByCode(verticalCode, productCode, ApplicationService.getApplicationDate(request), false, true);
				if(product != null) {
					CreditCardProduct creditCard = new CreditCardProduct();
					creditCard.importFromProduct(product);
					creditCards.add(creditCard);
				} else {
					logger.warn("/creditcards could not find product '" + productCode + "'");
				}
			}

			return creditCards;

		} catch (DaoException e) {
			throw new CreditCardServiceException(e.getMessage());
		}

	}

	/**
	 * Only used to retrieve a mapping in the form: slug:product-code, slug:product-code
	 * so we can map URLs to a product in WordPress.
	 * @param request
	 * @return
	 */
	public ArrayList<CreditCardProduct> getWordpressSlugToCodeMap(HttpServletRequest request) {

		try {

			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			ArrayList<CreditCardProduct> creditCards = new ArrayList<CreditCardProduct>();


			ArrayList<Product> products = productDao.getByVertical(pageSettings.getVertical().getCode(), ApplicationService.getApplicationDate(request), false, false);
			for(Product product : products) {
				if(product.getPropertyAsString("slug") != null) {
					CreditCardProduct creditCard = new CreditCardProduct();
					creditCard.setSlug(product.getPropertyAsString("slug"));
					creditCard.setCode(product.getCode());
					creditCard.setId(product.getId());
					creditCard.setProvider(product.getProvider());
					creditCards.add(creditCard);
				}
			}
			return creditCards;

		} catch (ConfigSettingException | DaoException e) {
			throw new CreditCardServiceException(e.getMessage());
		}
	}
}
