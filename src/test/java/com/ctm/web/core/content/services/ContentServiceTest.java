package com.ctm.web.core.content.services;

import com.ctm.web.core.content.cache.ContentControlCache;
import com.ctm.web.core.content.dao.ContentDao;
import com.ctm.web.core.content.model.Content;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Matchers;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;

import java.util.Date;

public class ContentServiceTest {

    private ContentDao contentDao;
    String contentValue = "contentValue";
    String contentFromCacheValue = "contentFromCache";
    String contentKey = "test";
    int brandId = 1;
    int verticalId = 1;
    boolean includeSupplementary = false;
    private ContentControlCache contentControlCache;
    private Content content;
    private ContentService contentService;
    private String cacheKey;
    private Content contentFromCache;

    @Before
    public void setup() {
        contentDao = Mockito.mock(ContentDao.class);
        contentControlCache = Mockito.mock(ContentControlCache.class);
        content = new Content();
        content.setContentValue(contentValue);

        contentFromCache = new Content();
        contentFromCache.setContentValue(contentFromCacheValue);

        contentService = new ContentService(contentDao, contentControlCache);
        cacheKey = contentKey + "_" + brandId + "_" + verticalId + "_" + includeSupplementary;
    }

    @Test
    public void testShouldGetContentFromDaoWhenNotInCache() throws Exception {
        PowerMockito.when(contentControlCache.get(cacheKey)).thenReturn(null);
        Content content = new Content();
        content.setContentValue(contentValue);
        PowerMockito.when(contentDao.getByKey(Matchers.eq(contentKey), Matchers.eq(brandId), Matchers.eq(verticalId), Matchers.anyObject(), Matchers.eq(false))).thenReturn(content);
        Content returnedContent = contentService.getContent(contentKey, brandId, verticalId, null, includeSupplementary);
        Assert.assertEquals(contentValue, returnedContent.getContentValue());
        Mockito.verify(contentDao).getByKey(Matchers.eq(contentKey), Matchers.eq(brandId), Matchers.eq(verticalId), Matchers.anyObject(), Matchers.eq(false));
    }
    @Test
    public void testShouldGetContentFromCacheWhenInCache() throws Exception {
        PowerMockito.when(contentControlCache.get(cacheKey)).thenReturn(contentFromCache);
        Content returnedContent = contentService.getContent(contentKey, 1, 1, null, false);
        Assert.assertEquals(contentFromCacheValue, returnedContent.getContentValue());
        Mockito.verifyZeroInteractions(contentDao);
    }

    @Test
    public void testShouldGetContentFromDaoIfDateSent() throws Exception {
        Date contentDate = new Date();
        PowerMockito.when(contentControlCache.get(cacheKey)).thenReturn(contentFromCache);
        Content contentNew = new Content();
        String contentNewValue = "contentNewValue";
        contentNew.setContentValue(contentNewValue);
        PowerMockito.when(contentDao.getByKey(contentKey, brandId, verticalId, contentDate, false)).thenReturn(contentNew);

        //If date is set always get from database
        Content returnedContent = contentService.getContent(contentKey, brandId, verticalId, contentDate, includeSupplementary);
        Assert.assertEquals(contentNewValue, returnedContent.getContentValue());
        Mockito.verify(contentDao).getByKey(contentKey, brandId, verticalId, contentDate, false);
    }
}