package com.ctm.web.creditcards.model;

import com.ctm.web.core.model.Product;

public class Rewards {

	private String standardCardClass;
	private Double standardCardPoints;
	private Double amexCardPoints;
	private Double bonusPoints;
	private String bonusPointsType;

	/**
	 * @return the standardCardClass
	 */
	public String getStandardCardClass() {
		return standardCardClass;
	}

	/**
	 * @param standardCardClass the standardCardClass to set
	 */
	public void setStandardCardClass(String standardCardClass) {
		this.standardCardClass = standardCardClass;
	}

	/**
	 * @return the bonusPoints
	 */
	public Double getBonusPoints() {
		return bonusPoints;
	}

	/**
	 * @param bonusPoints the bonusPoints to set
	 */
	public void setBonusPoints(Double bonusPoints) {
		this.bonusPoints = bonusPoints;
	}

	/**
	 * @return the amexCardPoints
	 */
	public Double getAmexCardPoints() {
		return amexCardPoints;
	}

	/**
	 * @param amexCardPoints the amexCardPoints to set
	 */
	public void setAmexCardPoints(Double amexCardPoints) {
		this.amexCardPoints = amexCardPoints;
	}

	/**
	 * @return the standardCardPoints
	 */
	public Double getStandardCardPoints() {
		return standardCardPoints;
	}

	/**
	 * @param standardCardPoints the standardCardPoints to set
	 */
	public void setStandardCardPoints(Double standardCardPoints) {
		this.standardCardPoints = standardCardPoints;
	}


	public String getBonusPointsType() {
		return bonusPointsType;
	}

	public void setBonusPointsType(String bonusPointsType) {
		this.bonusPointsType = bonusPointsType;
	}

	public void importFromProduct(Product product){

		setStandardCardClass(product.getPropertyAsString("rewards-standard-card-class"));
		setStandardCardPoints(product.getPropertyAsDouble("rewards-standard-card-points"));
		setAmexCardPoints(product.getPropertyAsDouble("rewards-amex-card-points"));
		setBonusPoints(product.getPropertyAsDouble("rewards-bonus-points"));
		setBonusPointsType(product.getPropertyAsString("rewards-bonus-points-type"));

	}
}