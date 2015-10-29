package com.ctm.services.health;

import com.ctm.web.health.dao.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.web.health.exceptions.HealthAltPriceException;
import com.ctm.model.content.Content;
import com.ctm.model.content.ContentSupplement;
import com.ctm.web.health.model.HealthPriceResult;
import com.ctm.services.ContentService;
import com.ctm.web.health.services.HealthPriceDetailService;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class HealthPriceDetailServiceTest {

	HealthPriceDao healthPriceDao = mock(HealthPriceDao.class);
	private HttpServletRequest request = mock(HttpServletRequest.class);
	private ArrayList<ContentSupplement> sup = new ArrayList<>();
	private ContentService contentService = mock(ContentService.class);

	@Test
	public void testIsAlternatePriceDisabled() throws SQLException, DaoException, HealthAltPriceException {
		HealthPriceResult targetHealthResult= new HealthPriceResult();
		ContentSupplement contentSupplement = new ContentSupplement();
		contentSupplement.setSupplementaryKey("disabledFunds");
		contentSupplement.setSupplementaryValue("BUD,AUF,GMF");
		sup.add(contentSupplement);
		Integer styleCodeId = 1;
		Content alternatePricingContent = new Content();
		alternatePricingContent.setSupplementary(sup);
		when(contentService.getContent(eq("alternatePricingActive"), eq(styleCodeId), anyInt(), (Date) anyObject(), eq(true))).thenReturn(alternatePricingContent);

		HealthPriceDetailService healthPriceDetailService = new HealthPriceDetailService( healthPriceDao, contentService);

		targetHealthResult.setFundCode("BUD");


		assertEquals("wrong fund dual pricing disabled", true, healthPriceDetailService.isAlternatePriceDisabledForResult(request, styleCodeId, targetHealthResult));

		targetHealthResult.setFundCode("FRA");
		assertEquals("wrong fund dual pricing disabled", false, healthPriceDetailService.isAlternatePriceDisabledForResult(request, styleCodeId, targetHealthResult));
	}

}
