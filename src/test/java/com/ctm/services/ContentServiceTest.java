package com.ctm.services;

import com.ctm.cache.ContentControlCache;
import com.ctm.dao.ContentDao;
import com.ctm.model.content.Content;
import org.junit.Before;
import org.junit.Test;

import java.util.Date;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.*;
import static org.powermock.api.mockito.PowerMockito.when;

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
        contentDao = mock(ContentDao.class);
        contentControlCache = mock(ContentControlCache.class);
        content = new Content();
        content.setContentValue(contentValue);

        contentFromCache = new Content();
        contentFromCache.setContentValue(contentFromCacheValue);

        contentService = new ContentService(contentDao, contentControlCache);
        cacheKey = contentKey + "_" + brandId + "_" + verticalId + "_" + includeSupplementary;
    }

    @Test
    public void testShouldGetContentFromDaoWhenNotInCache() throws Exception {
        when(contentControlCache.get(cacheKey)).thenReturn(null);
        Content content = new Content();
        content.setContentValue(contentValue);
        when(contentDao.getByKey(eq(contentKey), eq(brandId), eq(verticalId), anyObject(), eq(false))).thenReturn(content);
        Content returnedContent = contentService.getContent(contentKey, brandId, verticalId, null, includeSupplementary);
        assertEquals(contentValue , returnedContent.getContentValue());
        verify(contentDao).getByKey(eq(contentKey), eq(brandId), eq(verticalId), anyObject(), eq(false));
    }
    @Test
    public void testShouldGetContentFromCacheWhenInCache() throws Exception {
        when(contentControlCache.get(cacheKey)).thenReturn(contentFromCache);
        Content returnedContent = contentService.getContent(contentKey, 1, 1, null, false);
        assertEquals(contentFromCacheValue, returnedContent.getContentValue());
        verifyZeroInteractions(contentDao);
    }

    @Test
    public void testShouldGetContentFromDaoIfDateSent() throws Exception {
        Date contentDate = new Date();
        when(contentControlCache.get(cacheKey)).thenReturn(contentFromCache);
        Content contentNew = new Content();
        String contentNewValue = "contentNewValue";
        contentNew.setContentValue(contentNewValue);
        when(contentDao.getByKey(contentKey, brandId, verticalId, contentDate, false)).thenReturn(contentNew);

        //If date is set always get from database
        Content returnedContent = contentService.getContent(contentKey, brandId, verticalId, contentDate, includeSupplementary);
        assertEquals(contentNewValue , returnedContent.getContentValue());
        verify(contentDao).getByKey(contentKey, brandId, verticalId, contentDate, false);
    }
}