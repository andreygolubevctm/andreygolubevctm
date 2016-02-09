package com.ctm.web.core.utils;

import java.util.Random;


public class RandomNumberGenerator {

    public Integer getRandomNumber(Integer maxValue) {
        Random randomGenerator = new Random();

        return randomGenerator.nextInt(maxValue);
    }
}