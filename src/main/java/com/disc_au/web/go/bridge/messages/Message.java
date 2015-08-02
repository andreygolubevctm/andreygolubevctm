package com.disc_au.web.go.bridge.messages;

import com.ibm.as400.access.AS400Text;

// TODO: Auto-generated Javadoc
/**
 * The Class Message.
 * 
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("unused")
public class Message{
	
	/** The header. */
	private MessageHeader header;
	
	/** The data. */
	private String data;

	/**
	 * String from bytes.
	 *
	 * @param src the src
	 * @return the string
	 */
	private static String stringFromBytes(byte[] src) {
		int BUFFER_SIZE = 1024;

		AS400Text as400Buffer = new AS400Text(BUFFER_SIZE);

		StringBuffer sb = new StringBuffer();
		// Convert the data from EBCDIC -> UTF-8
		int i = 0;
		while (i < src.length) {

			// Resize as400Buffer for the last iteration (when the data is
			// shorter)
			int dataSize = Math.min(BUFFER_SIZE, src.length - i);
			if (dataSize < BUFFER_SIZE) {
				as400Buffer = new AS400Text(dataSize);
			}

			byte[] chunk = new byte[dataSize];
			System.arraycopy(src, i, chunk, 0, dataSize);

			sb.append((String) as400Buffer.toObject(chunk));

			i += dataSize;
		}
		return sb.toString();
	}

	/**
	 * String to bytes.
	 *
	 * @param src the src
	 * @return the byte[]
	 */
	private static byte[] stringToBytes(String src) {
		int BUFFER_SIZE = 1024;

		int dataLen = src.length();
		byte[] result = new byte[dataLen];
		AS400Text as400Buffer = new AS400Text(BUFFER_SIZE);

		// Convert the data from UTF-8 -> EBCDIC
		int i = 0;
		while (i < dataLen) {

			// Resize as400Buffer for the last iteration (when the data is
			// shorter)
			int dataSize = Math.min(BUFFER_SIZE, dataLen - i);
			if (dataSize < BUFFER_SIZE) {
				as400Buffer = new AS400Text(dataSize);
			}

			String chunk = src.substring(i, i + dataSize);
			byte[] chunkBytes = as400Buffer.toBytes(chunk);

			System.arraycopy(chunkBytes, 0, result, i, dataSize);
			i += dataSize;
		}

		return result;
	}

	/**
	 * Instantiates a new message.
	 *
	 * @param bytes the bytes
	 */
	public Message(byte[] bytes) {
		this.setBytes(bytes);
	}

	/**
	 * Instantiates a new message.
	 *
	 * @param header The header for the message
	 * @param data the data
	 */
	public Message(MessageHeader header, String data) {
		this.header = header;
		this.data = data;
	}
	
	
	/**
	 * Gets the bytes.
	 *
	 * @return the bytes
	 */
	public byte[] getBytes() {
		
		byte[] header = this.header.getBytes();
		byte[] data = stringToBytes(this.data);
		
		byte[] result = new byte[header.length + data.length];
		System.arraycopy(header, 0, result, 0, header.length);
		System.arraycopy(data, 0, result, header.length, data.length);

		return result;
	}

	/**
	 * Gets the data.
	 *
	 * @return the data
	 */
	public String getData() {
		return data;
	}

	/**
	 * Gets the length.
	 *
	 * @return the length
	 */
	public int getLength() {
		return this.header.getLength() + this.data.length();
	}

	/**
	 * Gets the name.
	 *
	 * @return the name
	 */
	public String getName() {
		return this.header.getName();
	}

	/**
	 * Sets the bytes.
	 *
	 * @param newData the new bytes
	 */
	public void setBytes(byte[] newData) {

		int headerLength = this.header.getLength();
		
		// Set the header
		headerLength = Math.min(newData.length, headerLength);
		byte[] header = new byte[headerLength];
		System.arraycopy(newData, 0, header, 0, headerLength);

		// Set the data
		int remaining = newData.length - headerLength;
		if (remaining > 0){
			byte[] data = new byte[remaining];
			System.arraycopy(newData, headerLength, data, 0, data.length);
			this.data = stringFromBytes(data);
		}
	}

	/**
	 * Sets the data.
	 *
	 * @param data the new data
	 */
	public void setData(String data) {
		this.data = data;
	}

	/**
	 * Gets the header.
	 */
	public MessageHeader getHeader() {
		return header;
	}

}
