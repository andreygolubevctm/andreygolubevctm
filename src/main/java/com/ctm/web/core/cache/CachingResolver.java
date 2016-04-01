package com.ctm.web.core.cache;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.interceptor.CacheOperationInvocationContext;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.stream.Collectors;

@Component
public class CachingResolver implements org.springframework.cache.interceptor.CacheResolver {

    @Autowired
	@SuppressWarnings("SpringJavaAutowiringInspection")
	private CacheManager cacheManager;

	@Override
	public Collection<Cache> resolveCaches(final CacheOperationInvocationContext<?> context) {
        return context.getOperation().getCacheNames().stream().map(cacheManager::getCache).collect(Collectors.toSet());
	}
}
