package com.ctm.services;

import com.ctm.cache.ContentControlCache;
import com.ctm.dao.ContentDao;
import com.ctm.model.content.Content;
import junit.framework.TestCase;

import java.util.Date;

import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.*;
import static org.powermock.api.mockito.PowerMockito.when;

public class ContentServiceTest extends TestCase {

    public void testShouldGetContentFromCache() throws Exception {
        String contentValue = "contentValue";
        String contentKey = "test";
        int brandId = 1;
        int verticalId = 1;
        boolean includeSupplementary = false;

        ContentDao contentDao = mock(ContentDao.class);
        ContentControlCache contentControlCache = mock(ContentControlCache.class);
        when(contentControlCache.get(contentKey + "_" + brandId + "_" + verticalId + "_" + includeSupplementary)).thenReturn(null);
        Content content = new Content();
        content.setContentValue(contentValue);
        when(contentDao.getByKey(eq(contentKey), eq(brandId), eq(verticalId), (Date)anyObject(), eq(false))).thenReturn(content);
        ContentService contentService = new ContentService(contentDao, contentControlCache);
        Content returnedContent = contentService.getContent(contentKey, brandId, verticalId, null, includeSupplementary);
        assertEquals(contentValue , returnedContent.getContentValue());
        verify(contentDao).getByKey(eq(contentKey), eq(brandId), eq(verticalId), (Date) anyObject(), eq(false));

        when(contentControlCache.get(contentKey + "_" + brandId + "_" + verticalId + "_" + includeSupplementary)).thenReturn(content);
        returnedContent = contentService.getContent(contentKey, 1, 1, null, false);
        assertEquals(contentValue, returnedContent.getContentValue());
        verifyNoMoreInteractions(contentDao);


        //If date is set always get from database
        Date now = new Date();
        Content contentNew = new Content();
        String contentNewValue = "contentNewValue";
        contentNew.setContentValue(contentNewValue);
        when(contentDao.getByKey(contentKey, brandId, verticalId, now, false)).thenReturn(contentNew);
        returnedContent = contentService.getContent(contentKey, brandId, verticalId, now, includeSupplementary);
        assertEquals(contentNewValue , returnedContent.getContentValue());
        verify(contentDao).getByKey(contentKey, brandId, verticalId, now, false);

    }
}