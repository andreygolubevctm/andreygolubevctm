package com.disc_au.web.go;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.disc_au.web.go.xml.XmlNode;

public class TokenReplaceUtils {

	public static final String XML = "XML";

	public static String createFromTemplate(Map<String, String> tokens,
			String template, Pattern pattern) {
		Matcher matcher = pattern.matcher(template);
		StringBuffer sbuff = new StringBuffer();

		while (matcher.find()) {
			String[] found = matcher.group().replace("%", "").split(":");
			String replace ="";
			if(found.length >  1) {
				replace =  convert(found[0] , tokens.get(found[1]), TokenReplaceUtils.XML);
			} else {
				replace =  tokens.get(found[0]);
			}

			replace = replace.replaceAll("\\$","\\\\\\$");
			if(replace != null) {
				matcher.appendReplacement(sbuff, replace);
			}
		}
		matcher.appendTail(sbuff);

		return sbuff.toString();
	}

	public static String convert(String type, String value, String formatType) {

		switch(type) {
			case "C":
				value = covertToCurrency(value);
				break;
			case "N":
				value = covertToNumber(value);
				break;
			case "YN":
				value = covertToYN(value);
				break;
			case "YNDETAILS":
				if(formatType.equals(XML)) {
					value = covertToYNDetailsXML(value);
				} else {
					value = covertToYN(value);
				}
				break;
			case "YNO":
				value = covertToYNO(value);
				break;
			case "YNODETAILS":
				if(formatType.equals(XML)) {
					value = covertToYNODetailsXML(value);
				} else {
					value = covertToYNO(value);
				}
				break;
			case "YNOLIMIT":
				if(formatType.equals(XML)) {
					value = covertToYNOLIMITXML(value);
				} else {
					value = covertToYNOLIMIT(value);
				}
				break;
			case "YNINSUREDCHOICE":
				if(formatType.equals(XML)) {
					value = covertToYNYNINSUREDCHOICEXML(value);
				}
				break;
			case "B":
				value = covertToBoolean(value);
				break;
			case "DATE":
				value = convertToNewDate(value);
				break;
			case "DEBUG":
				System.out.println("TYPE: '" + type + "'| VALUE: '" + value + "' | formatType: " + formatType);
				break;
			default:
		}
		return value;
	}

	private static String covertToYNO(String value) {
		value = value.trim().toUpperCase();
		String yesNoOp = "";

		if (equatesToYes(value)){
			yesNoOp = "Y";
		} else if (equatesToOptional(value) ){
			yesNoOp = "O";
		} else if(equatesToNo(value)){
			yesNoOp = "N";
		}
		return yesNoOp;
	}

	protected static boolean equatesToOptional(String value) {
		return value.equals("OPTIONAL") || value.equals("O");
	}

	private static String covertToYNODetailsXML(String value) {
		String[] values = value.split(",");
		String yesNo = covertToYNO(values[0]);
		String details = "";
		if(values.length > 1) {
			details = values[1];
		} else {
			if(yesNo.isEmpty()) {
				details = value;
			}
		}
		return convertToValueDetails(details, yesNo);
	}

	private static String covertToYNOLIMITXML(String value) {
		String[] values = value.split(",");

		String first = values[0].trim().toUpperCase();

		String yesNo = "";
		boolean hasLimit = false;
		if (equatesToYes(first)){
			yesNo = "Y";
		} else if(equatesToNo(first)){
			yesNo = "N";
		}  else if(equatesToOptional(first)){
			yesNo = "O";
		} else if(hasLimit(first)){
			yesNo = "Y";
			hasLimit  = true;
		}

		String details = "";
		if(values.length > 1) {
			details = values[1];
		} else {
			if(hasLimit) {
				details = value;
			}
		}
		return convertToValueDetails(details, yesNo);
	}

	private static String covertToYNYNINSUREDCHOICEXML(String value) {
		String valueUpper = value.trim().replace("'", "").toUpperCase();

		String yesNo = "";
		if (equatesToYes(valueUpper)){
			yesNo = "Y";
		} else if(equatesToNo(valueUpper)){
			yesNo = "N";
		} else if(valueUpper.startsWith("INSUREDS CHOICE")){
			yesNo = "Y";
		} else if(valueUpper.startsWith("INSURERS CHOICE")){
			yesNo = "N";
		}

		String details = value;

		return convertToValueDetails(details, yesNo);
	}

	private static String covertToYNOLIMIT(String value) {
		String[] values = value.split(",");

		String first = values[0].trim().toUpperCase();

		String yesNo = "";
		boolean hasLimit = false;
		if (equatesToYes(first)){
			yesNo = "Y";
		} else if(equatesToNo(first)){
			yesNo = "N";
		} else if(equatesToOptional(first)){
			yesNo = "O";
		} else if(hasLimit(first)){
			yesNo = "Y";
			hasLimit  = true;
		}

		if(values.length > 1) {
			return yesNo + "," + values[1];
		} else {
			if(hasLimit) {
				return yesNo + "," + value;
			}
			return yesNo;
		}
	}

	private static boolean hasLimit(String value) {
		return value.startsWith("COMBINED LIMIT") || value.startsWith("LIMIT") || value.startsWith("LIMITED");
	}

	private static String covertToYN(String value) {
		value = value.trim().toUpperCase();
		String yesNo = "";

		if (equatesToYes(value)){
			yesNo = "Y";
		}else if(equatesToNo(value)){
			yesNo = "N";
		}
		return yesNo;
	}

	private static String covertToYNDetailsXML(String value) {
		String[] values = value.split(",");
		String yesNo = covertToYN(values[0]);
		String details = "";
		if(values.length > 1) {
			details = values[1];
		}
		return convertToValueDetails(details, yesNo);
	}
	private static String convertToNewDate(String value) {
		if (!value.isEmpty()){
			SimpleDateFormat sf = new SimpleDateFormat("dd/MM/yyyy");
			Date date = null;
			String formattedDate = "";
			try {
				date = sf.parse(value);
				sf = new SimpleDateFormat("yyyy-MM-dd");
				formattedDate = sf.format(date);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				System.out.println(" Kevin gets upset if there's nothing done with an exception.. :" + e);
			}
			return formattedDate;
		}
		else {
			return "";
		}
	}

	protected static String convertToValueDetails(String details, String yesNo) {
		return "<covered>"+ yesNo + "</covered>" +
		"<details>" + details + "</details>";
	}

	private static boolean equatesToYes(String value) {
		return value.equals("YES") || value.equals("Y") || value.equals("1");
	}
	private static boolean equatesToNo(String value) {
		return value.equals("NO") || value.equals("N") || value.equals("0")|| value.equals("-") || value.equals("NOT APPLICABLE");
	}

	private static String covertToBoolean(String value) {
		value = value.trim().toUpperCase();
		if (value.equals("YES") || value.equals("Y") || value.equals("1") || value.equals("TRUE")){
			value = "true";
		} else {
			value = "false";
		}
		return value;
	}

	private static String covertToCurrency(String value) {
		DecimalFormat formatter = new DecimalFormat("$#,###,##0.00");
		value = covertToNumber(value);
		// Convert to BigDecimal
		try {
			BigDecimal d = new BigDecimal(value);
			formatter.setRoundingMode(RoundingMode.HALF_UP);
			value = formatter.format(d);
		} catch (Exception e){}
		return value;
	}

	private static String covertToNumber(String value) {
		value = value.replaceAll("[^0-9]", "");
		if(value.isEmpty()) value = "0";
		return value;
	}

	public static String getXML(String[] values, String template, int start, int end, boolean encodeHtml, boolean getDimensions, int lineNo)
			throws IOException {
		Pattern pattern = createPattern(start , end);
		return getXML(values,
				template, pattern, start , end, encodeHtml, getDimensions, lineNo);
	}

	public static String getXML(String[] values, String template, int start, int end, boolean encodeHtml)
			throws IOException {
		Pattern pattern = createPattern(start , end);
		return getXML(values,
				template, pattern, start , end, encodeHtml, false, 0);
	}

	public static String getXML(String[] values, String template, Pattern pattern, int start, int end, boolean encodeHtml, boolean getDimensions, int lineNo)
			throws IOException {

		Map<String, String> tokens = new HashMap<String, String>();
		for (int i = 0; i < values.length; i++) {
			String value = values[i];
			if(encodeHtml) {
				value = XmlNode.escapeMysqlChars(value);
			}
			tokens.put(String.valueOf(i), value);
		}
		if(getDimensions == true){
			return Integer.toString(end) + ":" + lineNo;
		}
		return TokenReplaceUtils.createFromTemplate(tokens, template, pattern);
	}

	public static Pattern createPattern(int start, int end) {
		StringBuilder sb = new StringBuilder();
		for (int i = start; (i <= end); i++) {
			sb.append(String.valueOf(i));
			sb.append("|");
		}
		String joined = sb.toString();
		String patternString = "%[A-Z:]*("
				+ joined.substring(0, (joined.length() - 1)) + ")%";

		return Pattern.compile(patternString);
	}
}
