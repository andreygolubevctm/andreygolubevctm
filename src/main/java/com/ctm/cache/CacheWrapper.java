package com.ctm.cache;

/**
 * Wrapper interface for Cache classes
 */
public interface CacheWrapper<K, V>
{
    void put(K key, V value);
    V get(K key);
    boolean isKeyInCache(K key);
}
