package com.ctm.web.core.cache;

import net.sf.ehcache.CacheManager;

public class ApplicationCacheManager {

    private static final CacheManager cacheManager = CacheManager.newInstance();
    private static ContentControlCache contentControlCache;

    public static ContentControlCache getContentControlCache(){
        if(contentControlCache == null) {
            contentControlCache = new ContentControlCache(cacheManager);
        }
        return contentControlCache;
    }

    /**
     * Clear all caches
     */
    public static void clearAll(){
        cacheManager.clearAll();
    }

}
