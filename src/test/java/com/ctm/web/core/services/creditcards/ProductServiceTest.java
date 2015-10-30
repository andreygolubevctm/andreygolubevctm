package com.ctm.services.creditcards;

import com.ctm.web.core.dao.ProductDao;
import com.ctm.web.creditcards.exceptions.CreditCardServiceException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.Product;
import com.ctm.web.creditcards.model.CreditCardProduct;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.creditcards.services.ProductService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.Random;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest(ProductService.class)
public class ProductServiceTest {

	private HttpServletRequest request;
	private ProductDao productDao;
	private String verticalCode;
	@Before
	public void setUp() throws Exception {
		request = mock(HttpServletRequest.class);
		productDao = mock(ProductDao.class);
		verticalCode = VerticalType.CREDITCARD.getCode();
		when(request.getAttribute("verticalCode")).thenReturn(verticalCode);
	}

	@Test
	public void testGetProductByCategoryCodeLimtedToOne() throws DaoException {

		ProductService productService = new ProductService();
		productService.setProductDao(productDao);

		String categoryCode = "TEST";
		String providerCode = null;
		int numberOfProductsToReturn = 1;
		ArrayList<Product> products = new ArrayList<Product>();
		products.add(new Product());
		products.add(new Product());
		products.add(new Product());

		when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(), (String) anyObject(), anyBoolean() ,anyBoolean())).thenReturn(products);

		ArrayList<CreditCardProduct> productsReturned = productService.getProducts(request, categoryCode, providerCode, numberOfProductsToReturn);


		assertEquals(numberOfProductsToReturn, productsReturned.size());
	}

	@Test
	public void testGetProductByCategoryCodeUnlimited() throws DaoException {

		ProductService productService = new ProductService();
		productService.setProductDao(productDao);
		String categoryCode = "TEST";
		String providerCode = null;
		int numberOfProductsToReturn = -1;
		ArrayList<Product> products = new ArrayList<Product>();
		int x = 1;
		int max = new Random().nextInt((20 - 3) + 1) + 3;
		while( x <= max) {
			products.add(new Product());
			x++;
		}

		when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(),
				(String) anyObject(), anyBoolean() , anyBoolean())).thenReturn(products);
		ArrayList<CreditCardProduct> productsReturned = productService.getProducts(request, categoryCode, providerCode, numberOfProductsToReturn);

		assertEquals(max, productsReturned.size());
	}

	@Test(expected=CreditCardServiceException.class)
	public void testCreditCardServiceException() {
		ProductService productService = new ProductService();
		productService.setProductDao(productDao);
		String categoryCode = null;
		String providerCode = null;
		int numberOfProductsToReturn = 1;
		ArrayList<Product> products = new ArrayList<Product>();
		products.add(new Product());
		products.add(new Product());
		products.add(new Product());
		ArrayList<CreditCardProduct> productsReturned;

		try {
			when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(),
					(String) anyObject(), anyBoolean() ,anyBoolean())).thenReturn(products);
			productsReturned = productService.getProducts(request, categoryCode, providerCode, numberOfProductsToReturn);
			fail("CreditCardServiceException expected.");
		} catch (DaoException e) {

		}

	}

	@Test
	public void testGetProductByProviderCodeLimtedToOne() throws DaoException {

		ProductService productService = new ProductService();
		productService.setProductDao(productDao);
		String categoryCode = null;
		String providerCode = "ANZ";
		int numberOfProductsToReturn = 1;
		ArrayList<Product> products = new ArrayList<Product>();
		products.add(new Product());
		products.add(new Product());
		products.add(new Product());

		when(productDao.getByProviderCode(eq(verticalCode), eq(providerCode), (Date) anyObject() , anyBoolean() ,anyBoolean())).thenReturn(products);
		ArrayList<CreditCardProduct> productsReturned = productService.getProducts(request, categoryCode, providerCode, numberOfProductsToReturn);

		assertEquals(numberOfProductsToReturn, productsReturned.size());
	}

	@Test
	public void testGetProductByCategoryCodeAndProviderCodeUnlimited() throws DaoException {

		ProductService productService = new ProductService();
		productService.setProductDao(productDao);
		String categoryCode = "TEST";
		String providerCode = "ANZ";
		int numberOfProductsToReturn = -1;
		ArrayList<Product> products = new ArrayList<Product>();
		int x = 1;
		int max = new Random().nextInt((20 - 3) + 1) + 3;
		while( x <= max) {
			products.add(new Product());
			x++;
		}

		when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(),
				eq(providerCode), anyBoolean() ,anyBoolean())).thenReturn(products);

		ArrayList<CreditCardProduct> productsReturned = productService.getProducts(request, categoryCode, providerCode, numberOfProductsToReturn);

		assertEquals(max, productsReturned.size());
	}

}
