package com.ctm.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class NGram {

	private int sequencesScore = 1;
	private int triplesScore = 1;
	private int patternsScore = 1;
	private int reversePatternsScore = 1;

	private final int n;
	private String text;

	private final int[] indexes;
	private int index = -1;
	private int found = 0;

	public int getSequencesScore() {
		return this.sequencesScore;
	}

	public void setSequencesScore(int score) {
		this.sequencesScore = score;
	}

	public int getTriplesScore() {
		return this.triplesScore;
	}

	public void setTriplesScore(int score) {
		this.triplesScore = score;
	}

	public int getPatternsScore() {
		return this.patternsScore;
	}

	public void setPatternsScore(int score) {
		this.patternsScore = score;
	}

	public int getReversePatternsScore() {
		return this.reversePatternsScore;
	}

	public void setReversePatternsScore(int score) {
		this.reversePatternsScore = score;
	}

	public NGram(String text, int n) {
		this.text = text;
		this.n = n+1;
		indexes = new int[n+1];
	}

	private boolean seek() {
		if (index >= text.length()) {
			return false;
		}
		push();
		while(++index < text.length()) {
				found++;
				if (found<n) {
					push();
				} else {
					return true;
				}
		}
		return true;
	}

	private void push() {
		for (int i = 0; i < n-1; i++) {
			indexes[i] = indexes[i+1];
		}
		indexes[n-1] = index+1;
	}

	private Integer calculate(Integer score, Integer value) {
		return score + value;
	}

	public List<String> split() {
		List<String> ngrams = new ArrayList<String>();
		while (seek()) {
			ngrams.add(get());
		}
		return ngrams;
	}

	public Integer score() {
		Integer score = 0;
		List<String> ngrams = new ArrayList<String>();
		List<String> previous = new ArrayList<String>();
		List<String> reversed = new ArrayList<String>();

		NGram ngram_s = new NGram("012345678909876543210abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcbasdfghjklkjhgfdsaqwertyuiopoiuytrewqzxcvbnmnbvcxz",n-1);
		List<String> sequence = ngram_s.split();

		List<String> triple = Arrays.asList("111", "222", "333", "444", "555", "666",
			"777", "888", "999", "000", "aaa", "bbb", "ccc", "ddd", "eee", "fff",
			"ggg", "hhh", "iii", "jjj", "kkk", "lll", "mmm", "nnn", "ooo", "ppp",
			"qqq", "rrr", "sss", "ttt", "uuu", "vvv", "www", "xxx", "yyy", "zzz");

		while (seek()) {
			String item = get();
			String reverse = new StringBuilder(item).reverse().toString();

			// Evaluate for sequence
			if(getSequencesScore() > 0) {
				if(sequence.contains(item)) {
					ngrams.add("s:" + item);
					score = calculate(score,getSequencesScore());
					continue;
				}
			}

			// Evaluate for triples
			if(getTriplesScore() > 0) {
				if(triple.contains(item)) {
					ngrams.add("t:" + item);
					score = calculate(score,getTriplesScore());
					continue;
				}
			}

			// Evaluate for repeating patterns
			if(getPatternsScore() > 0) {
				if(previous.contains(item)) {
					ngrams.add("p:" + item);
					score = calculate(score,getPatternsScore());
					continue;
				}

				previous.add(item);
			}

			// Evaluate for repeating reverse patterns
			if(getReversePatternsScore() > 0) {
				if(reversed.contains(item)) {
					ngrams.add("r:" + item);
					score = calculate(score,getReversePatternsScore());
					continue;
				}

				if(!(item.equals(reverse))) {
					reversed.add(reverse);
				}
			}
		}

		return score;
	}

	public String list() {
		List<String> ngrams = new ArrayList<String>();
		List<String> previous = new ArrayList<String>();
		List<String> reversed = new ArrayList<String>();

		NGram ngram_s = new NGram("012345678909876543210abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcbasdfghjklkjhgfdsaqwertyuiopoiuytrewqzxcvbnmnbvcxz",n-1);
		List<String> sequence = ngram_s.split();

		List<String> triple = Arrays.asList("111", "222", "333", "444", "555", "666",
			"777", "888", "999", "000", "aaa", "bbb", "ccc", "ddd", "eee", "fff",
			"ggg", "hhh", "iii", "jjj", "kkk", "lll", "mmm", "nnn", "ooo", "ppp",
			"qqq", "rrr", "sss", "ttt", "uuu", "vvv", "www", "xxx", "yyy", "zzz");

		while (seek()) {
			String item = get();
			String reverse = new StringBuilder(item).reverse().toString();

			// Evaluate for sequence
			if(getSequencesScore() > 0) {
				if(sequence.contains(item)) {
					ngrams.add("s:" + item);
					continue;
				}
			}

			// Evaluate for triples
			if(getTriplesScore() > 0) {
				if(triple.contains(item)) {
					ngrams.add("t:" + item);
					continue;
				}
			}

			// Evaluate for repeating patterns
			if(getPatternsScore() > 0) {
				if(previous.contains(item)) {
					ngrams.add("p:" + item);
					continue;
				}

				previous.add(item);
			}

			// Evaluate for repeating reverse patterns
			if(getReversePatternsScore() > 0) {
				if(reversed.contains(item)) {
					ngrams.add("r:" + item);
					continue;
				}

				if(!(item.equals(reverse))) {
					reversed.add(reverse);
				}
			}
		}

		return ngrams.toString();
	}

	private String get() {
		return text.substring(indexes[0], index);
	}
}