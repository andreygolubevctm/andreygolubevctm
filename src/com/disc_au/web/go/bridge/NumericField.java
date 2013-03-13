package com.disc_au.web.go.bridge;

import java.math.BigDecimal;

import com.ibm.as400.access.AS400DataType;
import com.ibm.as400.access.AS400PackedDecimal;
import com.ibm.as400.access.AS400ZonedDecimal;

// TODO: Auto-generated Javadoc
/**
 * The Class NumericField.
 * 
 * @author aransom
 * @version 1.0
 */

public class NumericField {
	
	/** The converter. */
	private AS400DataType converter;
	
	/** The length. */
	private int length;

	/** The value. */
	int value = 0;

	/**
	 * Instantiates a new numeric field.
	 *
	 * @param length the length
	 * @param type the type
	 * @param decimal the decimal
	 */
	public NumericField(int length, char type, int decimal) {
		this.length = length;
		switch (type) {
		case 'p':
			this.converter = new AS400PackedDecimal(length, decimal);
			break;
		default:
			this.converter = new AS400ZonedDecimal(length, decimal);
			break;
		}
	}

	/**
	 * Gets the bytes.
	 *
	 * @return the bytes
	 */
	public byte[] getBytes() {
		BigDecimal num;
		try {
			num = new BigDecimal(this.value);
		} catch (NumberFormatException e) {
			num = new BigDecimal(0);
		}
		return this.converter.toBytes(num);
	}

	/**
	 * Gets the length.
	 *
	 * @return the length
	 */
	public int getLength() {
		return this.length;
	}

	/**
	 * Gets the value.
	 *
	 * @return the value
	 */
	public int getValue() {
		return this.value;
	}

	/**
	 * Sets the bytes.
	 *
	 * @param b the new bytes
	 */
	public void setBytes(byte[] b) {
		BigDecimal num;
		try {
			num = (BigDecimal) this.converter.toObject(b);
			this.value = Integer.valueOf(num.toString());
		} catch (NumberFormatException e) {
			this.value = 0;
		}
	}

	/**
	 * Sets the value.
	 *
	 * @param value the new value
	 */
	public void setValue(int value) {
		this.value = value;
	}
}