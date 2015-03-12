package com.ctm.services.health;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.HealthAltPriceException;
import com.ctm.model.content.Content;
import com.ctm.model.content.ContentSupplement;
import com.ctm.model.health.HealthPriceResult;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.util.ArrayList;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;

public class HealthPriceDetailServiceTest {
	
	HealthPriceDao healthPriceDao = mock(HealthPriceDao.class);
	private HttpServletRequest request = mock(HttpServletRequest.class);
	private ArrayList<ContentSupplement> sup = new ArrayList<>();

	@Test
	public void testIsAlternatePriceDisabled() throws SQLException, DaoException, HealthAltPriceException {
		ContentSupplement contentSupplement = new ContentSupplement();
		contentSupplement.setSupplementaryKey("disabledFunds");
		contentSupplement.setSupplementaryValue("BUD,AUF,GMF");
		sup.add(contentSupplement);
		Integer styleCodeId = 1;
		Content alternatePricingContent = new Content();
		alternatePricingContent.setSupplementary(sup);
		HealthPriceDetailService healthPriceDetailService = new HealthPriceDetailService( healthPriceDao ,  styleCodeId,  alternatePricingContent);

		HealthPriceResult targetHealthResult= new HealthPriceResult();
		targetHealthResult.setFundCode("BUD");

		assertEquals("wrong fund dual pricing disabled", true, healthPriceDetailService.isAlternatePriceDisabledForResult(request , targetHealthResult));

		targetHealthResult.setFundCode("FRA");
		assertEquals("wrong fund dual pricing disabled", false, healthPriceDetailService.isAlternatePriceDisabledForResult(request , targetHealthResult));
	}

}
