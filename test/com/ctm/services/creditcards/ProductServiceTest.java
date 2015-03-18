package com.ctm.services.creditcards;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.Date;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import com.ctm.dao.ProductDao;
import com.ctm.exceptions.CreditCardServiceException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Product;
import com.ctm.model.creditcards.CreditCardProduct;
import com.ctm.model.settings.Vertical.VerticalType;

@RunWith(PowerMockRunner.class)
@PrepareForTest(ProductService.class)
public class ProductServiceTest {
	/*
	private HttpServletRequest request;
	private ProductDao productDao;
	private String verticalCode;
	@Before
	public void setUp() throws Exception {
		request = mock(HttpServletRequest.class);
		productDao = mock(ProductDao.class);
		verticalCode = VerticalType.CREDITCARD.getCode();
		request.setAttribute("verticalCode", verticalCode);
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

		when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(), (String) anyObject())).thenReturn(products);

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

		when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(), (String) anyObject())).thenReturn(products);
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
			when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(), (String) anyObject())).thenReturn(products);
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

		when(productDao.getByProviderCode(eq(verticalCode), eq(providerCode), (Date) anyObject())).thenReturn(products);
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

		when(productDao.getByCategoryCode(eq(verticalCode), eq(categoryCode), (Date) anyObject(), eq(providerCode))).thenReturn(products);
		ArrayList<CreditCardProduct> productsReturned = productService.getProducts(request, categoryCode, providerCode, numberOfProductsToReturn);

		assertEquals(max, productsReturned.size());
	}
*/
}
