package com.ctm.utils;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class NGramTest {

    private NGram ngram;
    private NGram ngram_list;

    @Test
    public void shouldValidateGivenName(){
        Integer expectedScore = 3;
        String expectedList =  "[<span style=\"color:green\">Matches given name trigram:tes</span>, <span style=\"color:green\">Matches given name trigram:est</span>, <span style=\"color:red\">Rare given name trigram:st1</span>, <span style=\"color:red\">Rare given name trigram:t11</span>, <span style=\"color:red\">Rare given name trigram:111</span>, <span style=\"color:red\">Matches triple:111</span>]";
        String textInvalid = "test111";
        Integer givenNames = 1;
        Integer englishLanguage = 0;
        Integer sequences = 1;
        Integer triples = 1;
        Integer patterns = 1;
        Integer reversePatterns = 1;

        createNGame(givenNames, englishLanguage, sequences, triples, patterns, reversePatterns, textInvalid);

        Integer score = ngram.score();
        String list = ngram_list.list().toString();
        assertEquals(expectedScore, score);
        assertEquals(expectedList, list);


        String textValid = "Jane";
        expectedScore = 1;
        expectedList ="[<span style=\"color:red\">Rare given name trigram:Jan</span>, <span style=\"color:green\">Matches given name trigram:ane</span>]";
        createNGame(givenNames, englishLanguage, sequences, triples, patterns, reversePatterns, textValid);

        score = ngram.score();
        assertEquals(expectedScore, score);
        list = ngram_list.list().toString();
        assertEquals(expectedList, list);


        String text = "ghfghhgfh";
        expectedScore = 7;
        expectedList ="[<span style=\"color:red\">Rare given name trigram:ghf</span>, <span style=\"color:red\">Rare given name trigram:hfg</span>, " +
                "<span style=\"color:red\">Rare given name trigram:fgh</span>, <span style=\"color:red\">Matches sequence:fgh</span>, <span style=\"color:red\">" +
                "Rare given name trigram:ghh</span>, <span style=\"color:red\">Rare given name trigram:hhg</span>, <span style=\"color:red\">" +
                "Matches reverse pattern:hhg</span>, <span style=\"color:red\">Rare given name trigram:hgf</span>, <span style=\"color:red\">" +
                "Matches sequence:hgf</span>, <span style=\"color:red\">Rare given name trigram:gfh</span>, <span style=\"color:red\">" +
                "Matches reverse pattern:gfh</span>]";
        createNGame(givenNames, englishLanguage, sequences, triples, patterns, reversePatterns, text);

        score = ngram.score();
        assertEquals(expectedScore, score);
        list = ngram_list.list().toString();
        assertEquals(expectedList, list);
    }

    private void createNGame(Integer givenNames, Integer englishLanguage, Integer sequences, Integer triples, Integer patterns, Integer reversePatterns, String textValid) {
        ngram = new NGram(textValid, 3);
        ngram_list = new NGram(textValid,3);
        ngram.setGivenNamesScore(givenNames);
        ngram.setEnglishLanguageScore(englishLanguage);
        ngram.setSequencesScore(sequences);
        ngram.setTriplesScore(triples);
        ngram.setPatternsScore(patterns);
        ngram.setReversePatternsScore(reversePatterns);

        ngram_list.setGivenNamesScore(givenNames);
        ngram_list.setEnglishLanguageScore(englishLanguage);
        ngram_list.setSequencesScore(sequences);
        ngram_list.setTriplesScore(triples);
        ngram_list.setPatternsScore(patterns);
        ngram_list.setReversePatternsScore(reversePatterns);
    }
}
