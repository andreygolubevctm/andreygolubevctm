package com.ctm.web.samesite.router;

import com.ctm.web.samesite.model.BankInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Since the advent of the SameSite security restriction and Chrome's disallowing this form of access,
 * the 'old way' of sending a POST via an iFrame from the Westpac Gateway, no longer works.
 * <p>
 * Instead, this server based Controller may be used as a proxy, where it takes the POST based parameters
 * and associates them with an HTTP GET, thus maintaining the session.
 *
 * @see <a href="https://web.dev/samesite-cookies-explained/">SameSite Explained</a>
 */
@Controller
@RequestMapping("/samesite")
public class SameSiteProxyController {
    public static final Logger LOG = LoggerFactory.getLogger(SameSiteProxyController.class);
    public static final String RETURN_URL = "redirect:/ajax/html/health_paymentgateway_return.jsp";

    @RequestMapping(value = "/proxy", method = RequestMethod.POST)
    public String sameSiteProxy(@ModelAttribute("bankInfo") BankInfo bankInfo) {
        LOG.debug("Received POST from Payment Gateway for account alias {}", bankInfo.getNm_account_alias());
        return getRedirectUrl(bankInfo);
    }

    private String getRedirectUrl(BankInfo bankInfo) {
        String url = new StringBuilder().append(RETURN_URL)
                .append("?cd_prerego=").append(bankInfo.getCd_prerego())
                .append("&nm_card_scheme=").append(bankInfo.getNm_card_scheme())
                .append("&dt_expiry=").append(bankInfo.getDt_expiry())
                .append("&nm_card_holder=").append(bankInfo.getNm_card_holder())
                .append("&fl_success=").append(bankInfo.getFl_success())
                .append("&cd_community=").append(bankInfo.getCd_community())
                .append("&action=").append(bankInfo.getAction())
                .append("&cd_supplier_business=").append(bankInfo.getCd_supplier_business())
                .append("&tx_response=").append(bankInfo.getTx_response()).toString();
        LOG.debug("Redirecting to url {}", url);
        return url;
    }
}
