package com.ctm.web.core.utils;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class NGramTest {

    private NGram ngram;
    private NGram ngramList;

    @Test
    public void shouldValidateGivenName(){
        String repeatedPattern = "222";
        Integer expectedScore = 1;
        String expectedList =  "[t:" + repeatedPattern + "]";
        String textInvalid = "test" + repeatedPattern;
        Integer sequences = 1;
        Integer triples = 1;
        Integer patterns = 1;
        Integer reversePatterns = 1;

        createNGame(sequences, triples, patterns, reversePatterns, textInvalid);

        Integer score = ngram.score();
        String list = ngramList.list().toString();
        assertEquals(expectedScore, score);
        assertEquals(expectedList, list);


        String textValid = "Jane";
        expectedScore = 0;
        expectedList ="[]";
        createNGame(sequences, triples, patterns, reversePatterns, textValid);

        score = ngram.score();
        assertEquals(expectedScore, score);
        list = ngramList.list().toString();
        assertEquals(expectedList, list);


        String text = "ghfghhgfh";
        expectedScore = 4;
        expectedList ="[s:fgh, r:hhg, s:hgf, r:gfh]";
        createNGame(sequences, triples, patterns, reversePatterns, text);

        score = ngram.score();
        assertEquals(expectedScore, score);
        list = ngramList.list().toString();
        assertEquals(expectedList, list);
    }

    private void createNGame( Integer sequences, Integer triples, Integer patterns, Integer reversePatterns, String textValid) {
        ngram = new NGram(textValid, 3);
        ngramList = new NGram(textValid,3);
        ngram.setSequencesScore(sequences);
        ngram.setTriplesScore(triples);
        ngram.setPatternsScore(patterns);
        ngram.setReversePatternsScore(reversePatterns);

        ngramList.setSequencesScore(sequences);
        ngramList.setTriplesScore(triples);
        ngramList.setPatternsScore(patterns);
        ngramList.setReversePatternsScore(reversePatterns);
    }
}
