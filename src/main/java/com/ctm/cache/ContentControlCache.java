package com.ctm.cache;

import com.ctm.model.content.Content;
import net.sf.ehcache.CacheManager;

/**
 * Cache container for Content Control values.
 */
public class ContentControlCache extends EhcacheWrapper<String, Content> {

    public ContentControlCache(CacheManager cacheManager) {
        super("contentControlCache", cacheManager);
    }
}
