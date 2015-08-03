package com.ctm.utils.creditcards;

import java.util.Comparator;

import com.ctm.model.creditcards.CreditCardProduct;
import com.ctm.model.creditcards.Data;

/**
 * This class applies the sorting algorithms to the credit cards object
 * Each column has a different sorting mechanism that can be sorted on by default.
 *
 * NOTE: As Secure does not maintain the list of columns, we do not perform sorting on all columns here.
 * We do an initial sort based on the primary sort field in java, and then sort it again on Wp side.
 * The WP sorting is located in credit-cards/wp-content/themes/salient-child/credit-cards/lib/CreditCardsSorting.php
 *		The WP sorting functions by sorting based on all columns displayed for a category, and then applies that sort index
 *		to its columns data object, for Datatables (the client-side JS) to sort on ASC/DESC.
 * @author bthompson
 * @documentation http://confluence:8090/display/CM/Credit+Card+Categories
 */
public class CreditCardsSortAlgorithms {

	final static int BEFORE = -1;
	final static int EQUAL = 0;
	final static int AFTER = 1;

	public static Comparator<CreditCardProduct> getSortAlgorithm(String sortField) {

		switch(sortField) {
			case "interestRate":
				return interestRateComparator();
			case "balanceTransferRate":
				return balanceTransferRateComparator();
			case "annualFee":
				return annualFeeComparator();
			case "cashAdvanceRate":
				return cashAdvanceRateComparator();
			case "bonusPoints":
				return bonusPointsComparator();
			case "pointsPerDollarSpentStandard":
				return pointsPerDollarSpentStandardComparator();
			case "pointsPerDollarSpentAmex":
				return pointsPerDollarSpentAmexComparator();
		}
		return null;
	}

	/**
	 * Sort by cash advance rate
	 * Default order is ASC
	 * @return Comparator<CreditCardProduct>
	 */
	private static Comparator<CreditCardProduct> cashAdvanceRateComparator() {
		Comparator<CreditCardProduct> comp = new Comparator<CreditCardProduct>() {
			public int compare(CreditCardProduct lhs, CreditCardProduct rhs) {
				Double leftData = lhs.getData().getCashAdvanceRate().getPercentage();
				Double rightData = rhs.getData().getCashAdvanceRate().getPercentage();
				return numericCompareAscending(leftData, rightData);
			}
		};
		return comp;
	}

	/**
	 * Annual Fee sorts by introductoryFee ASC within introductoryPeriodMonths DESC within fee ASC
	 * If a card has no annual fee, we set the intro fee to be the ongoing fee in the sort, just so it can sort properly.
	 * @return
	 */
	private static Comparator<CreditCardProduct> annualFeeComparator() {
		Comparator<CreditCardProduct> comp = new Comparator<CreditCardProduct>() {
			public int compare(CreditCardProduct lhs, CreditCardProduct rhs) {
				Data leftData = lhs.getData();
				Data rightData = rhs.getData();

				// A null introductory percentage needs to be treated as the ongoing introductory percentage
				// in order for it to sort correctly.
				Double lhsFee = leftData.getAnnualFee().getIntroductoryFee();
						lhsFee = lhsFee == null ? leftData.getAnnualFee().getFee() : lhsFee;
				Double rhsFee = rightData.getAnnualFee().getIntroductoryFee();
				rhsFee = rhsFee == null ? rightData.getAnnualFee().getFee() : rhsFee;

				int compareResult = compareFieldsAscending(lhsFee, rhsFee);
				if(compareResult != EQUAL) {
					return compareResult;
				}

				compareResult = compareFieldsDescending(leftData.getAnnualFee().getIntroductoryPeriodMonths(), rightData.getAnnualFee().getIntroductoryPeriodMonths());
				if(compareResult != EQUAL) {
					return compareResult;
				}

				compareResult = compareFieldsAscendingNullsAtEnd(leftData.getAnnualFee().getFee(), rightData.getAnnualFee().getFee());
				if(compareResult != EQUAL) {
					return compareResult;
				}

				return EQUAL;
			}
		};
		return comp;
	}

	/**
	 * IntroductoryPercentage ASC, within introductoryPeriodMonths DESC, within percentage ASC
	 * Cards with no introductory rate and period go first. The order in brackets at the end is how
	 * this function should resort it.
	 * @example
	 * Row 1: 0% intro, 16 months, revert to 12% 		(2)
	 * Row 2: null intro (as 12), null months, 12%		(5)
	 * Row 3: 5% intro, 12 months, revert to 12% 		(4)
	 * Row 4: 0% intro, 12 months, revert to 18% 		(3)
	 * Row 5: null intro (as 0), null months, 0% 		(1)
	 * @return
	 */
	private static Comparator<CreditCardProduct> interestRateComparator(){
		Comparator<CreditCardProduct> comp = new Comparator<CreditCardProduct>() {
			public int compare(CreditCardProduct lhs, CreditCardProduct rhs) {

				// Store the data object
				Data leftData = lhs.getData();
				Data rightData = rhs.getData();

				// A null introductory percentage needs to be treated as the ongoing introductory percentage
				// in order for it to sort correctly.
				Double lhsPercentage = leftData.getInterestRate().getIntroductoryPercentage();
						lhsPercentage = lhsPercentage == null ? leftData.getInterestRate().getPercentage() : lhsPercentage;
				Double rhsPercentage = rightData.getInterestRate().getIntroductoryPercentage();
						rhsPercentage = rhsPercentage == null ? rightData.getInterestRate().getPercentage() : rhsPercentage;
				int compareResult = compareFieldsAscending(lhsPercentage, rhsPercentage);
				// if not equal, continue to next sort.
				if(compareResult != EQUAL) {
					return compareResult;
				}

				compareResult = compareFieldsDescending(leftData.getInterestRate().getIntroductoryPeriodMonths(), rightData.getInterestRate().getIntroductoryPeriodMonths());
				if(compareResult != EQUAL) {
					return compareResult;
				}

				compareResult = compareFieldsAscending(leftData.getInterestRate().getPercentage(), rightData.getInterestRate().getPercentage());
				if(compareResult != EQUAL) {
					return compareResult;
				}
				return EQUAL;
			}
		};
		return comp;
	}

	/**
	 * IntroductoryPercentage ASC within introductoryPeriodMonths DESC within percentage ASC
	 * Currently the same as Interest Rate, EXCEPT some cards may not offer balance transfer at all.
	 * In those cases, they will be deferred to the end, by setting their rate to 999 for sorting purposes.
	 * @example
	 * Row 1: 1% intro, 16 months, revert to 12% 	(1)
	 * Row 2: null intro, null months, 12%		 	(4)
	 * Row 3: 5% intro, 12 months, revert to 12% 	(3)
	 * Row 4: 1% intro, 16 months, revert to 18% 	(2)
	 * Row 5: null intro, null months, null ongoing (5)
	 * @return
	 */
	private static Comparator<CreditCardProduct> balanceTransferRateComparator() {
		Comparator<CreditCardProduct> comp = new Comparator<CreditCardProduct>() {
			public int compare(CreditCardProduct lhs, CreditCardProduct rhs) {
				Data leftData = lhs.getData();
				Data rightData = rhs.getData();
				int compareResult = compareFieldsAscendingNullsAtEnd(leftData.getBalanceTransferRate().getIntroductoryPercentage(), rightData.getBalanceTransferRate().getIntroductoryPercentage());
				if(compareResult != EQUAL) {
					return compareResult;
				}

				compareResult = compareFieldsDescendingNullsAtEnd(leftData.getBalanceTransferRate().getIntroductoryPeriodMonths(), rightData.getBalanceTransferRate().getIntroductoryPeriodMonths());
				if(compareResult != EQUAL) {
					return compareResult;
				}

				Double lhsPercentage = leftData.getBalanceTransferRate().getPercentage();
					lhsPercentage = lhsPercentage == null ? 999.00 : lhsPercentage;
				Double rhsPercentage = rightData.getBalanceTransferRate().getPercentage();
					rhsPercentage = rhsPercentage == null ? 999.00 : rhsPercentage;
				compareResult = compareFieldsAscendingNullsAtEnd(lhsPercentage, rhsPercentage);
				if(compareResult != EQUAL) {
					return compareResult;
				}
				return EQUAL;

			}
		};
		return comp;
	}

	/**
	 * Sort by points per dollar spent (for AMEX)
	 * Default order is DESC
	 * @return Comparator<CreditCardProduct>
	 */
	private static Comparator<CreditCardProduct> pointsPerDollarSpentAmexComparator() {
		Comparator<CreditCardProduct> comp = new Comparator<CreditCardProduct>() {
			public int compare(CreditCardProduct lhs, CreditCardProduct rhs) {
				Double leftData = lhs.getData().getRewards().getAmexCardPoints();
				Double rightData = rhs.getData().getRewards().getAmexCardPoints();
				return numericCompareDescending(leftData, rightData);
			}
		};
		return comp;
	}

	/**
	 * Sort by points per dollar spent (for Visa/Mastercard)
	 * Default order is DESC
	 * @return Comparator<CreditCardProduct>
	 */
	private static Comparator<CreditCardProduct> pointsPerDollarSpentStandardComparator() {
		Comparator<CreditCardProduct> comp = new Comparator<CreditCardProduct>() {
			public int compare(CreditCardProduct lhs, CreditCardProduct rhs) {
				Double leftData = lhs.getData().getRewards().getStandardCardPoints();
				Double rightData = rhs.getData().getRewards().getStandardCardPoints();
				return numericCompareDescending(leftData, rightData);
			}
		};
		return comp;
	}

	/**
	 * Sort by bonus points.
	 * Default order is DESC
	 * @return Comparator<CreditCardProduct>
	 */
	private static Comparator<CreditCardProduct> bonusPointsComparator() {
		Comparator<CreditCardProduct> comp = new Comparator<CreditCardProduct>() {
			public int compare(CreditCardProduct lhs, CreditCardProduct rhs) {
				Double leftData = lhs.getData().getRewards().getBonusPoints();
				Double rightData = rhs.getData().getRewards().getBonusPoints();
				return numericCompareDescending(leftData, rightData);
			}
		};
		return comp;
	}
	/**
	 * Compare fields in ascending order
	 * @param lhs
	 * @param rhs
	 * @return
	 */
	private static int compareFieldsAscending(Double lhs, Double rhs) {
		if(lhs == null && rhs == null) {
			return EQUAL;
		}

		if(lhs == null) {
			return BEFORE;
		}
		if(rhs == null) {
			return AFTER;
		}

		int compared = lhs.compareTo(rhs);
		if(compared != EQUAL) {
			return compared;
		}

		return EQUAL;
	}

	/**
	 * Compare fields in ascending order with nulls flipped.
	 * E.G. used for columns where you encounter a NULL and want it to be at the end, instead of the start.
	 * @param lhs
	 * @param rhs
	 * @return
	 */
	private static int compareFieldsAscendingNullsAtEnd(Double lhs, Double rhs) {
		if(lhs == null && rhs == null) {
			return EQUAL;
		}

		if(lhs == null) {
			return AFTER;
		}
		if(rhs == null) {
			return BEFORE;
		}

		int compared = lhs.compareTo(rhs);
		if(compared != EQUAL) {
			return compared;
		}

		return EQUAL;
	}

	/**
	 * Compare fields in descending order with nulls flipped to the standard.
	 * Returns BEFORE if lhs is null and AFTER if rhs is null (as opposed to compareFieldsDescending)
	 * @param lhs
	 * @param rhs
	 * @return
	 */
	private static int compareFieldsDescending(Double lhs, Double rhs) {
		// Doesn't seem to get to the end if both are null.
		if(lhs == null && rhs == null) {
			return EQUAL;
		}

		if(lhs == null) {
			return BEFORE;
		}
		if(rhs == null) {
			return AFTER;
		}

		int compared = rhs.compareTo(lhs);
		if(compared != EQUAL) {
			return compared;
		}

		return EQUAL;
	}

	/**
	 * Compare fields in descending order with nulls flipped to the standard.
	 * Returns AFTER if lhs is null and BEFORE if rhs is null (as opposed to compareFieldsDescending)
	 * E.G. used for columns where you encounter a NULL and want it to be at the end, instead of the start.
	 * @param lhs
	 * @param rhs
	 * @return
	 */
	private static int compareFieldsDescendingNullsAtEnd(Double lhs, Double rhs) {
		// Doesn't seem to get to the end if both are null.
		if(lhs == null && rhs == null) {
			return EQUAL;
		}

		if(lhs == null) {
			return AFTER;
		}
		if(rhs == null) {
			return BEFORE;
		}

		int compared = rhs.compareTo(lhs);
		if(compared != EQUAL) {
			return compared;
		}

		return EQUAL;
	}

	/**
	 * Compare numerically in ascending order. Lower rates are better.
	 * @param lhs
	 * @param rhs
	 * @return
	 */

	private static int numericCompareAscending(Double lhs, Double rhs) {
		if(lhs == null && rhs == null) {
			return EQUAL;
		}
		if(lhs == null) {
			return AFTER;
		}

		if(rhs == null) {
			return BEFORE;
		}


		return lhs.compareTo(rhs);
	}

	/**
	 * Compare numerically in descending order. Higher points are better.
	 * @param lhs
	 * @param rhs
	 * @return
	 */
	private static int numericCompareDescending(Double lhs, Double rhs) {
		if(lhs == null && rhs == null) {
			return EQUAL;
		}

		if(lhs == null) {
			return BEFORE;
		}

		if(rhs == null) {
			return AFTER;
		}

		return rhs.compareTo(lhs);
	}

}
