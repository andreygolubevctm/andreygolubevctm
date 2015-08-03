package com.disc_au.web.go.bridge.messages;

import java.math.BigDecimal;

import com.ibm.as400.access.AS400Text;
import com.ibm.as400.access.AS400ZonedDecimal;

// TODO: Auto-generated Javadoc
/**
 * The Class MessageHeader.
 * 
 * @author aransom
 * @version 1.0
 */

public class EcomMessageHeader implements MessageHeader{
	
	/** The Constant DEFAULT_MODE. */
	public static final String DEFAULT_MODE = "D";
	
	/** The Constant HEADER_LENGTH. */
	public static final int HEADER_LENGTH = 63;

	/** The transaction id. */
	private String transactionId;
	
	/** The page id. */
	private String pageId;
	
	/** The client ip address. */
	private String clientIpAddress;
	
	/** The style. */
	private String style;
	// private BigDecimal logLevel;
	/** The mode. */
	private String mode;

	/**
	 * Instantiates a new message header.
	 *
	 * @param transactionId the transaction id
	 * @param pageId the page id
	 * @param clientIpAddress the client ip address
	 * @param style the style
	 * @param mode the mode
	 */
	public EcomMessageHeader(String transactionId, String pageId,
			String clientIpAddress, String style, String mode) {
		this.transactionId 	= transactionId == null ? "" : transactionId;
		this.pageId 		= pageId == null ? "" : pageId;
		this.clientIpAddress = clientIpAddress == null ? "" : clientIpAddress;
		this.style 			= style == null ? "" : style;
		this.mode 			= mode == null ? DEFAULT_MODE : mode;
	}

	/**
	 * Gets the bytes.
	 *
	 * @return the bytes
	 */
	public byte[] getBytes() {

		byte[][] fieldData = new byte[6][];
		fieldData[0] = new AS400Text(9).toBytes(this.transactionId);
		fieldData[1] = new AS400Text(6).toBytes(this.pageId);
		fieldData[2] = new AS400Text(15).toBytes(this.clientIpAddress);
		fieldData[3] = new AS400Text(30).toBytes(this.style);
		fieldData[4] = new AS400ZonedDecimal(2, 0).toBytes(new BigDecimal(0));
		fieldData[5] = new AS400Text(1).toBytes(this.mode);

		byte[] result = new byte[HEADER_LENGTH];
		int destPos = 0;
		for (byte[] field : fieldData) {
			System.arraycopy(field, 0, result, destPos, field.length);
			destPos += field.length;
		}
		return result;

	}

	/**
	 * Gets the length.
	 *
	 * @return the length
	 */
	public int getLength() {
		return HEADER_LENGTH;
	}

	/**
	 * Gets the page id.
	 *
	 * @return the page id
	 */
	public String getPageId() {
		return this.pageId;
	}

	/**
	 * Gets the transaction id.
	 *
	 * @return the transaction id
	 */
	public String getTransactionId() {
		return this.transactionId;
	}

	/**
	 * Sets the bytes.
	 *
	 * @param bytes the new bytes
	 */
	public void setBytes(byte[] bytes) {

		this.transactionId 		= (String) (new AS400Text(9)).toObject(bytes, 0);
		this.pageId 			= (String) (new AS400Text(6)).toObject(bytes, 9);
		this.clientIpAddress 	= (String) (new AS400Text(15)).toObject(bytes, 15);
		this.style 				= (String) (new AS400Text(30)).toObject(bytes, 30);
		this.mode 				= (String) (new AS400Text(1)).toObject(bytes, 62);

	}
	public String getName(){
		return this.transactionId + ":" + this.pageId;
	}
}
