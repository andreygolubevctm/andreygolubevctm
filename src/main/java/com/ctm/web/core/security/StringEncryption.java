package com.ctm.web.core.security;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.Mac;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.GeneralSecurityException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Formatter;

public class StringEncryption {

	private static final Logger LOGGER = LoggerFactory.getLogger(StringEncryption.class);

	private static final int AUTHENTICATION_TAG_LENGTH = 128;
	private static final int NUMBER_OF_IV_BYTES = 12;
	private static final int GCM_TAG_LENGTH = 16;
	private static final int OFFSET_IN_SRC_WHERE_IV_STARTS = 0;
	private static final int SRC_POSITION = 0;
	private static final int DEST_POSITION = 0;
	private static final String ENCRYPTION_ALGORITHM = "AES";
	private static final String OPERATION_MODE = "GCM";
	private static final String PADDING_SCHEME = "NoPadding";

	// TODO: Should we be using a Keystore for this? Unsure why it was first implemented like this?
	// FYI There is duplicate use of the salt + key in another tag - maybe why it was implemented like this.
	// FYI: this code taken from HmaxSHA256Tag.java
	//TODO: this should be a different salt
	private String salt = "++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1ytN|E2qg";
	private String secretKey = "MzJmOGM@#^584kNGNViYTEzMmMTUwMw=";
	private String algorithm = "HmacSHA256";

	public StringEncryption() {

	}


	public static String encryptNoKey(String theString) throws GeneralSecurityException {
		StringEncryption encryption = new StringEncryption();
		String output = "";
		try {
			output  = encryption.encrypt(theString);
		} catch (GeneralSecurityException e) {
			LOGGER.error("Failed to encrypt", e);
			throw e;
		}
		return output;
	}

	public String encrypt(String theString) throws NoSuchAlgorithmException, InvalidKeyException{
		Mac algorithm = Mac.getInstance(this.algorithm);
		SecretKeySpec secretKey = new SecretKeySpec(this.secretKey.getBytes(), this.algorithm);
		algorithm.init(secretKey);

		return Base64.encodeBase64String((algorithm.doFinal((this.salt + theString).getBytes())));
	}

	public static String hash(String value) throws GeneralSecurityException {
		MessageDigest md = MessageDigest.getInstance("SHA-1");
		return byteArray2Hex(md.digest(value.getBytes()));
	}


	private static String byteArray2Hex(final byte[] hash) {
		Formatter formatter = new Formatter();
		for (byte b : hash) {
			formatter.format("%02x", b);
		}
		String output = formatter.toString();
		formatter.close();
		return output;

	}

	private static SecretKeySpec getSecretKeySpec(final String key) {
		// Convert the string version of the key to a SecretKey object
		byte[] encodedSecretKey = Base64.decodeBase64(key);
		final SecretKeySpec secretKeySpec = new SecretKeySpec(encodedSecretKey, "AES");
		return secretKeySpec;
	}

	private static Cipher getCipherInstance() throws NoSuchPaddingException, NoSuchAlgorithmException {
		return Cipher.getInstance(String.join("/", ENCRYPTION_ALGORITHM, OPERATION_MODE, PADDING_SCHEME));
	}

	public static String encrypt(String key, String content) throws GeneralSecurityException {
		String result = "";
		final SecretKeySpec secretKey = getSecretKeySpec(key);

		// Create Cipher object needed to do encryption/decryption
		Cipher cipherInstance;
		try {
			cipherInstance = getCipherInstance();
			cipherInstance.init(Cipher.ENCRYPT_MODE, secretKey);
			// Encrypt the content
			byte[] contentAsBytes = content.getBytes();
			byte[] contentAsByteCipherText = cipherInstance.doFinal(contentAsBytes);
			byte[] iv = cipherInstance.getIV();
			byte[] message = new byte[NUMBER_OF_IV_BYTES + contentAsBytes.length + GCM_TAG_LENGTH];
			System.arraycopy(iv, SRC_POSITION, message, DEST_POSITION, NUMBER_OF_IV_BYTES);
			System.arraycopy(contentAsByteCipherText, SRC_POSITION, message, NUMBER_OF_IV_BYTES, contentAsByteCipherText.length);
			result = Base64.encodeBase64URLSafeString(message);
		} catch (GeneralSecurityException e) {
			LOGGER.error("Failed to encrypt", e);
			throw e;
		}
		return result;
	}

	public static String decrypt(String key, String content) throws GeneralSecurityException {
		String output;
		try {
			SecretKeySpec secretKey = getSecretKeySpec(key);

			// Decrypt the content
			byte[] contentAsByteCipherText = Base64.decodeBase64(content);
			// Create Cipher object needed to do encryption/decryption
			Cipher cipherInstance = getCipherInstance();
			GCMParameterSpec params = new GCMParameterSpec(AUTHENTICATION_TAG_LENGTH, contentAsByteCipherText, OFFSET_IN_SRC_WHERE_IV_STARTS, NUMBER_OF_IV_BYTES);
			cipherInstance.init(Cipher.DECRYPT_MODE, secretKey, params);

			byte[] decryptedTextAsBytes = cipherInstance.doFinal(contentAsByteCipherText, NUMBER_OF_IV_BYTES, contentAsByteCipherText.length - NUMBER_OF_IV_BYTES);
			output = new String(decryptedTextAsBytes);
			// Important! keep this as debug and don't enable debug logging in production
			// as this may include credit card details (this is from the nib webservice)

		} catch(IllegalArgumentException | IllegalBlockSizeException | BadPaddingException e) {
			// content to be decrypted may be encrypted with the old method (using ECB),
			// try decrypting using old method
			output = decryptECB(key, content);
		}
		return output;
	}

	/**
	 * This is the old method to decrypt which is using ECB. Currently used as failover method
	 * for decrypting lingering tokens that have been encrypted using ECB.
	 * @param key
	 * @param content
	 * @return
	 * @throws GeneralSecurityException
	 */
	@Deprecated
	private static String decryptECB(String key, String content) throws GeneralSecurityException {
		String output;
		// Convert the string version of the key to a SecretKey object
		byte[] encoded_secret_key = Base64.decodeBase64(key);
		final SecretKeySpec secret_key = new SecretKeySpec(encoded_secret_key, "AES");

		// Create Cipher object needed to do encryption/decryption
		Cipher aes_cipher = Cipher.getInstance("AES");
		aes_cipher.init(Cipher.ENCRYPT_MODE, secret_key);

		// Decrypt the content
		aes_cipher.init(Cipher.DECRYPT_MODE, secret_key, aes_cipher.getParameters());
		byte[] content_as_byte_cipher_text = Base64.decodeBase64(content);
		byte[] decrypted_text_as_bytes = aes_cipher.doFinal(content_as_byte_cipher_text);
		output = new String(decrypted_text_as_bytes);
		// Important! keep this as debug and don't enable debug logging in production
		// as this may include credit card details (this is from the nib webservice)
		return output;
	}
}