package com.ctm.cache;

import net.sf.ehcache.CacheManager;

/**
 * Cache container for Content Control values.
 */
public class ContentControlCache extends EhcacheWrapper {

    public ContentControlCache(CacheManager cacheManager) {
        super("contentControlCache", cacheManager);
    }
}
