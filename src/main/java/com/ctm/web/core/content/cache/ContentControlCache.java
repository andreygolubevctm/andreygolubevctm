package com.ctm.web.core.content.cache;

import com.ctm.web.core.cache.EhcacheWrapper;
import com.ctm.web.core.content.model.Content;
import net.sf.ehcache.CacheManager;

/**
 * Cache container for Content Control values.
 */
public class ContentControlCache extends EhcacheWrapper<String, Content> {

    public ContentControlCache(CacheManager cacheManager) {
        super("contentControlCache", cacheManager);
    }
}
