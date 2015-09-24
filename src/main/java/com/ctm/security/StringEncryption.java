package com.ctm.security;

import java.security.GeneralSecurityException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Formatter;

import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.logging.LoggingArguments.kv;

public class StringEncryption {

	private static final Logger LOGGER = LoggerFactory.getLogger(StringEncryption.class);

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
	
	public static String encrypt(String key, String content) throws GeneralSecurityException {
		String result = "";
		// Convert the string version of the key to a SecretKey object
		byte[] encoded_secret_key = Base64.decodeBase64(key);
		final SecretKeySpec secret_key = new SecretKeySpec(encoded_secret_key, "AES");

		// Create Cipher object needed to do encryption/decryption
		Cipher aes_cipher;
		try {
			aes_cipher = Cipher.getInstance("AES");
			aes_cipher.init(Cipher.ENCRYPT_MODE, secret_key);
			// Encrypt the content
			byte[] content_as_bytes = content.getBytes();
			byte[] content_as_byte_cipher_text = aes_cipher.doFinal(content_as_bytes);
			result = Base64.encodeBase64URLSafeString(content_as_byte_cipher_text);
		} catch (GeneralSecurityException e) {
			LOGGER.error("Failed to encrypt", e);
			throw e;
		}
		return result;
	}

	public static String decrypt(String key, String content) throws GeneralSecurityException {
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
