package com.disc_au.web.go;

public class StringUtils {

	public static String encodeAmpersands(String input) {
		final String regex = "&([^;\\W]*([^;\\w]|$))";
		final String replacement = "&amp;$1";
		return input.replaceAll(regex, replacement).replaceAll(regex, replacement);
	}

}
