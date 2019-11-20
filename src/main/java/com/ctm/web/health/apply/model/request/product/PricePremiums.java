package com.ctm.web.health.apply.model.request.product;

import java.math.BigDecimal;
import java.util.Optional;

public class PricePremiums {

	private BigDecimal annualLhc;
	private BigDecimal annualPremium;
	private BigDecimal grossAnnualPremium;
	private BigDecimal annualPayableAmount;

	private BigDecimal halfYearlyLHC;
	private BigDecimal halfYearlyPremium;
	private BigDecimal grossHalfYearlyPremium;
	private BigDecimal halfYearlyPayableAmount;

	private BigDecimal quarterlyLHC;
	private BigDecimal quarterlyPremium;
	private BigDecimal grossQuarterlyPremium;
	private BigDecimal quarterlyPayableAmount;

	private BigDecimal monthlyLHC;
	private BigDecimal monthlyPremium;
	private BigDecimal grossMonthlyPremium;
	private BigDecimal monthlyPayableAmount;

	private BigDecimal fortnightlyLHC;
	private BigDecimal fortnightlyPremium;
	private BigDecimal grossFortnightlyPremium;
	private BigDecimal fortnightlyPayableAmount;


	private BigDecimal weeklyLHC;
	private BigDecimal weeklyPremium;
	private BigDecimal grossWeeklyPremium;
	private BigDecimal weeklyPayableAmount;

	private PricePremiums(Builder builder) {
		annualLhc = builder.annualLhc;
		annualPremium = builder.annualPremium;
		grossAnnualPremium = builder.grossAnnualPremium;
		annualPayableAmount = builder.annualPayableAmount;
		halfYearlyLHC = builder.halfYearlyLHC;
		halfYearlyPremium = builder.halfYearlyPremium;
		grossHalfYearlyPremium = builder.grossHalfYearlyPremium;
		halfYearlyPayableAmount = builder.halfYearlyPayableAmount;
		quarterlyLHC = builder.quarterlyLHC;
		quarterlyPremium = builder.quarterlyPremium;
		grossQuarterlyPremium = builder.grossQuarterlyPremium;
		quarterlyPayableAmount = builder.quarterlyPayableAmount;
		monthlyLHC = builder.monthlyLHC;
		monthlyPremium = builder.monthlyPremium;
		grossMonthlyPremium = builder.grossMonthlyPremium;
		monthlyPayableAmount = builder.monthlyPayableAmount;
		fortnightlyLHC = builder.fortnightlyLHC;
		fortnightlyPremium = builder.fortnightlyPremium;
		grossFortnightlyPremium = builder.grossFortnightlyPremium;
		fortnightlyPayableAmount = builder.fortnightlyPayableAmount;
		weeklyLHC = builder.weeklyLHC;
		weeklyPremium = builder.weeklyPremium;
		grossWeeklyPremium = builder.grossWeeklyPremium;
		weeklyPayableAmount = builder.weeklyPayableAmount;
	}

	public static Builder newBuilder() {
		return new Builder();
	}

	public Optional<BigDecimal> getAnnualLhc() {
		return Optional.ofNullable(annualLhc);
	}

	public Optional<BigDecimal> getAnnualPremium() {
		return Optional.ofNullable(annualPremium);
	}

	public Optional<BigDecimal> getGrossAnnualPremium() {
		return Optional.ofNullable(grossAnnualPremium);
	}

	public Optional<BigDecimal> getAnnualPayableAmount() {
		return Optional.ofNullable(annualPayableAmount);
	}

	public Optional<BigDecimal> getHalfYearlyLHC() {
		return Optional.ofNullable(halfYearlyLHC);
	}

	public Optional<BigDecimal> getHalfYearlyPremium() {
		return Optional.ofNullable(halfYearlyPremium);
	}

	public Optional<BigDecimal> getGrossHalfYearlyPremium() {
		return Optional.ofNullable(grossHalfYearlyPremium);
	}

	public Optional<BigDecimal> getHalfYearlyPayableAmount() {
		return Optional.ofNullable(halfYearlyPayableAmount);
	}

	public Optional<BigDecimal> getQuarterlyLHC() {
		return Optional.ofNullable(quarterlyLHC);
	}

	public Optional<BigDecimal> getQuarterlyPremium() {
		return Optional.ofNullable(quarterlyPremium);
	}

	public Optional<BigDecimal> getGrossQuarterlyPremium() {
		return Optional.ofNullable(grossQuarterlyPremium);
	}

	public Optional<BigDecimal> getQuarterlyPayableAmount() {
		return Optional.ofNullable(quarterlyPayableAmount);
	}

	public Optional<BigDecimal> getMonthlyLHC() {
		return Optional.ofNullable(monthlyLHC);
	}

	public Optional<BigDecimal> getMonthlyPremium() {
		return Optional.ofNullable(monthlyPremium);
	}

	public Optional<BigDecimal> getGrossMonthlyPremium() {
		return Optional.ofNullable(grossMonthlyPremium);
	}

	public Optional<BigDecimal> getMonthlyPayableAmount() {
		return Optional.ofNullable(monthlyPayableAmount);
	}

	public Optional<BigDecimal> getFortnightlyLHC() {
		return Optional.ofNullable(fortnightlyLHC);
	}

	public Optional<BigDecimal> getFortnightlyPremium() {
		return Optional.ofNullable(fortnightlyPremium);
	}

	public Optional<BigDecimal> getGrossFortnightlyPremium() {
		return Optional.ofNullable(grossFortnightlyPremium);
	}

	public Optional<BigDecimal> getFortnightlyPayableAmount() {
		return Optional.ofNullable(fortnightlyPayableAmount);
	}

	public Optional<BigDecimal> getWeeklyLHC() {
		return Optional.ofNullable(weeklyLHC);
	}

	public Optional<BigDecimal> getWeeklyPremium() {
		return Optional.ofNullable(weeklyPremium);
	}

	public Optional<BigDecimal> getGrossWeeklyPremium() {
		return Optional.ofNullable(grossWeeklyPremium);
	}

	public Optional<BigDecimal> getWeeklyPayableAmount() {
		return Optional.ofNullable(weeklyPayableAmount);
	}

	public static final class Builder {
		private BigDecimal annualLhc;
		private BigDecimal annualPremium;
		private BigDecimal grossAnnualPremium;
		private BigDecimal annualPayableAmount;
		private BigDecimal halfYearlyLHC;
		private BigDecimal halfYearlyPremium;
		private BigDecimal grossHalfYearlyPremium;
		private BigDecimal halfYearlyPayableAmount;
		private BigDecimal quarterlyLHC;
		private BigDecimal quarterlyPremium;
		private BigDecimal grossQuarterlyPremium;
		private BigDecimal quarterlyPayableAmount;
		private BigDecimal monthlyLHC;
		private BigDecimal monthlyPremium;
		private BigDecimal grossMonthlyPremium;
		private BigDecimal monthlyPayableAmount;
		private BigDecimal fortnightlyLHC;
		private BigDecimal fortnightlyPremium;
		private BigDecimal grossFortnightlyPremium;
		private BigDecimal fortnightlyPayableAmount;
		private BigDecimal weeklyLHC;
		private BigDecimal weeklyPremium;
		private BigDecimal grossWeeklyPremium;
		private BigDecimal weeklyPayableAmount;

		private Builder() {
		}

		public Builder annualLhc(BigDecimal val) {
			annualLhc = val;
			return this;
		}

		public Builder annualPremium(BigDecimal val) {
			annualPremium = val;
			return this;
		}

		public Builder grossAnnualPremium(BigDecimal val) {
			grossAnnualPremium = val;
			return this;
		}

		public Builder annualPayableAmount(BigDecimal val) {
			annualPayableAmount = val;
			return this;
		}

		public Builder halfYearlyLHC(BigDecimal val) {
			halfYearlyLHC = val;
			return this;
		}

		public Builder halfYearlyPremium(BigDecimal val) {
			halfYearlyPremium = val;
			return this;
		}

		public Builder grossHalfYearlyPremium(BigDecimal val) {
			grossHalfYearlyPremium = val;
			return this;
		}

		public Builder halfYearlyPayableAmount(BigDecimal val) {
			halfYearlyPayableAmount = val;
			return this;
		}

		public Builder quarterlyLHC(BigDecimal val) {
			quarterlyLHC = val;
			return this;
		}

		public Builder quarterlyPremium(BigDecimal val) {
			quarterlyPremium = val;
			return this;
		}

		public Builder grossQuarterlyPremium(BigDecimal val) {
			grossQuarterlyPremium = val;
			return this;
		}

		public Builder quarterlyPayableAmount(BigDecimal val) {
			quarterlyPayableAmount = val;
			return this;
		}

		public Builder monthlyLHC(BigDecimal val) {
			monthlyLHC = val;
			return this;
		}

		public Builder monthlyPremium(BigDecimal val) {
			monthlyPremium = val;
			return this;
		}

		public Builder grossMonthlyPremium(BigDecimal val) {
			grossMonthlyPremium = val;
			return this;
		}

		public Builder monthlyPayableAmount(BigDecimal val) {
			monthlyPayableAmount = val;
			return this;
		}

		public Builder fortnightlyLHC(BigDecimal val) {
			fortnightlyLHC = val;
			return this;
		}

		public Builder fortnightlyPremium(BigDecimal val) {
			fortnightlyPremium = val;
			return this;
		}

		public Builder grossFortnightlyPremium(BigDecimal val) {
			grossFortnightlyPremium = val;
			return this;
		}

		public Builder fortnightlyPayableAmount(BigDecimal val) {
			fortnightlyPayableAmount = val;
			return this;
		}

		public Builder weeklyLHC(BigDecimal weeklyLHC) {
			this.weeklyLHC = weeklyLHC;
			return this;
		}

		public Builder weeklyPremium(BigDecimal weeklyPremium) {
			this.weeklyPremium = weeklyPremium;
			return this;
		}

		public Builder grossWeeklyPremium(BigDecimal grossWeeklyPremium) {
			this.grossWeeklyPremium = grossWeeklyPremium;
			return this;
		}

		public Builder weeklyPayableAmount(BigDecimal val) {
			weeklyPayableAmount = val;
			return this;
		}

		public PricePremiums build() {
			return new PricePremiums(this);
		}
	}
}
