package com.ctm.web.health.apply.model.request.application.applicant.previousFund;

import com.fasterxml.jackson.annotation.JsonValue;

/**
 * The CancelOption defines what is being cancelled if anything. The value should be a specific value in the following situations
 * <table>
 *     <tr>
 *         <th></th>
 *         <th>Purchasing Hospitals + Extras (C)</th>
 *         <th>Purchasing Hospital Only (H)</th>
 *         <th>Purchasing Extras Only (E)</th>
 *     </tr>
 *     <tr>
 *         <th>Previous Fund Hospital + Extras (C)</th>
 *         <td><i>Cancel Hospital + Extras (<b><u>C</u></b>)</i></td>
 *         <td>Cancel Hospital + Extras (<b><u>C</u></b>) OR Cancel Hospital Only (<b><u>H</u></b>)</td>
 *         <td>Cancel Hospital + Extras (<b><u>C</u></b>) OR Cancel Extras Only (<b><u>E</u></b>)</td>
 *     </tr>
 *     <tr>
 *         <th>Previous Fund Hospital Only (H)</th>
 *         <td><i>Cancel Hospital + Extras (<b><u>C</u></b>)</i></td>
 *         <td><i>Cancel Hospital Only (<b><u>H</u></b>)</i></td>
 *         <td>Cancel Hospital Only (<b><u>H</u></b>) OR Cancel Nothing (<b><u>N</u></b>)</td>
 *     </tr>
 *     <tr>
 *         <th>Previous Fund Extras Only (E)</th>
 *         <td><i>Cancel Hospital + Extras (<b><u>C</u></b>)</i></td>
 *         <td>Cancel Extras Only (<b><u>E</u></b>) OR Cancel Nothing (<b><u>N</u></b>)</td>
 *         <td><i>Cancel Extras Only (<b><u>E</u></b>)</i></td>
 *     </tr>
 * </table>
 */
public enum CancelOption {
    COMBINED("C"),  // Cancel Hospital + Extras
    HOSPITAL("H"),  // Cancel Hospital Only
    EXTRAS("E"),    // Cancel Extras Only
    NOTHING("N");   // Cancel Nothing


    private final String code;

    CancelOption(final String code) { this.code = code; }

    @Override
    public String toString() {
        return this.name();
    }



    /**
     * Get the CancelOption from a given cancellationType
     * @param cancellationType The cancellation option for the previous fund, from the xpath `health/previousFund/{applicant}/fundCancellationType`
     * @return The CancelOption enum, either one-to-one to the `cancellationType`, or `CancelOption.N` if the cancellationType is "KH" or "KE"
     */
    public static CancelOption fromCancellationType(final String cancellationType) {
        // If the cancellation type is "KH" (Keep Hospital) or "KE" (Keep Extras) then we return N as the scenarios that allow for these codes don't cancel anything
        if(cancellationType.matches("^(?:KE|KH)$")) {
            return CancelOption.NOTHING;
        }

        return CancelOption.fromCode(cancellationType);
    }


    /**
     * Get the default CancelOption derived from the given purchase type
     * @param purchaseType The type of cover being purchased, from the xpath `health/situation/coverType`
     * @return The CancelOption enum or `CancelOption.N` if purchaseType isn't one of "C", "H" or "E"
     */
    public static CancelOption fromPurchaseType(final String purchaseType) {
        return CancelOption.fromCode(purchaseType);
    }


    /**
     * Get a CancelOption enum value from a given code in string format
     * @param code The code of the value, i.e "C" or "H"
     * @return The matching enum value, or null if no matching name is found
     */
    public static CancelOption fromCode(final String code) {
        // Loop through each value
        for(final CancelOption opt : CancelOption.values()) {
            if(code.equals(opt.code)) {   // If the given code matches the option code
                return opt; // return the option enum
            }
        }

        // If no match is found, return null
        return null;
    }
}
