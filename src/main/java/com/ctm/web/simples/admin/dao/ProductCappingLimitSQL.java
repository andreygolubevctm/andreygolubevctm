package com.ctm.web.simples.admin.dao;

public class ProductCappingLimitSQL {

    public static final String GET_PROVIDER_SUMMARY = "SELECT providers.ProviderId,\n" +
            "       providerCodes.`Text` AS providerCode,\n" +
            "       providers.Name AS providerName,\n" +
            "       ifnull(capCount, 0) AS currentProductCapCount\n" +
            "FROM provider_master providers\n" +
            "INNER JOIN (SELECT `ProviderId`, `Text` FROM provider_properties WHERE PropertyId ='FundCode') providerCodes on providers.providerId = providerCodes.providerId\n" +
            "LEFT JOIN\n" +
            "  (SELECT count(id) AS capCount,\n" +
            "          provider_id\n" +
            "   FROM health_product_capping_limit h\n" +
            "   WHERE curdate() BETWEEN h.effective_start_date AND h.effective_end_date\n" +
            "   GROUP BY h.provider_id) limits ON limits.provider_id = providers.providerId\n" +
            "WHERE providers.ProviderId IN (\n" +
            "   SELECT DISTINCT providerId\n" +
            "   FROM product_master\n" +
            "   WHERE productCat = 'HEALTH'\n" +
            ")\n" +
            "ORDER BY providerName ASC ;";

    public static final String GET_PRODUCT_CODE = "SELECT productCode\n" +
            "FROM product_master product\n" +
            "INNER JOIN product_properties_search props ON product.ProductId = props.ProductId\n" +
            "WHERE product.ProductCat = 'HEALTH'\n" +
            "  AND product.Status != 'X'\n" +
            "  AND product.ProviderId = ?\n" +
            "  AND product.LongTitle = ?\n" +
            "  AND props.state= ?\n" +
            "  AND props.membership = ?\n" +
            "  AND (? between product.EffectiveStart and product.EffectiveEnd)\n" +
            "  AND (? between product.EffectiveStart and product.EffectiveEnd);";

    public static final String DELETE_BY_ID = "DELETE\n" +
            "FROM health_product_capping_limit\n" +
            "WHERE id = ?;";

    public static final String FIND_BY_LIMIT_PARAMS = "SELECT *\n" +
            "FROM health_product_capping_limit limits\n" +
            "WHERE limit_type = ?\n" +
            "  AND product_code = ?\n" +
            "  AND ((? BETWEEN limits.effective_start_date AND limits.effective_end_date)\n" +
            "       OR (? BETWEEN limits.effective_start_date AND limits.effective_end_date))\n" +
            "  AND limits.effective_end_date >= curDate();";
    public static final String CREATE =
            "INSERT INTO health_product_capping_limit (cap_limit, limit_type, limit_category, effective_start_date, effective_end_date, product_code, provider_id, membership, state)\n" +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);";
    public static final String UPDATE_BY_ID = "UPDATE health_product_capping_limit\n" +
            "SET limit_type = ?,\n" +
            "    limit_category = ?,\n" +
            "    effective_start_date = ?,\n" +
            "    effective_end_date = ?,\n" +
            "    cap_limit = ?\n" +
            "WHERE id = ?;";
    private static final String GET_ALL_RECORDS_SNIPPET = "SELECT id AS cappingLimitId,\n" +
            "       provider_id AS providerId,\n" +
            "       providerName,\n" +
            "       product_code AS productCode,\n" +
            "       productName,\n" +
            "       state,\n" +
            "       membership AS healthCvr,\n" +
            "       limit_type AS limitType,\n" +
            "       cap_limit AS cappingAmount,\n" +
            "       ifnull(currentJoinCount, 0) AS currentJoinCount,\n" +
            "       effective_start_date AS effectiveStart,\n" +
            "       effective_end_date AS effectiveEnd,\n" +
            "       limit_category AS cappingLimitCategory,\n" +
            "       (curDate() BETWEEN effective_start_date AND effective_end_date) AS isCurrent\n" +
            "FROM (\n" +
            "        (SELECT limits.*,\n" +
            "\n" +
            "           (SELECT longTitle\n" +
            "            FROM product_master\n" +
            "            WHERE productCode = limits.`product_code`\n" +
            "            ORDER BY productId DESC LIMIT 1) AS productName,\n" +
            "                providers.Name AS providerName,\n" +
            "                product_joins.currentJoinCount\n" +
            "         FROM health_product_capping_limit limits\n" +
            "         INNER JOIN provider_master providers ON providers.providerId = limits.provider_id\n" +
            "         LEFT JOIN\n" +
            "           (SELECT count(rootId) AS currentJoinCount,\n" +
            "                   products.productCode,\n" +
            "                   products.LongTitle\n" +
            "            FROM product_master products\n" +
            "            INNER JOIN joins ON products.productId = joins.productId\n" +
            "            WHERE date(joins.joinDate) = date(curDate())\n" +
            "            GROUP BY products.productCode,\n" +
            "                     date(joins.joinDate) DESC) product_joins ON product_joins.productCode = limits.product_code\n" +
            "         WHERE limits.limit_type = 'Daily'\n" +
            "         AND limits.effective_end_date >= DATE_ADD(CURDATE(), INTERVAL -3 MONTH))\n" +
            "      \n" +
            "      UNION\n" +
            "        (SELECT limits.*,\n" +
            "\n" +
            "           (SELECT longTitle\n" +
            "            FROM product_master\n" +
            "            WHERE productCode = limits.`product_code`\n" +
            "            ORDER BY productId DESC LIMIT 1) AS productName,\n" +
            "                providers.Name AS providerName,\n" +
            "                product_joins.currentJoinCount\n" +
            "         FROM health_product_capping_limit limits\n" +
            "         INNER JOIN provider_master providers ON providers.providerId = limits.provider_id\n" +
            "         LEFT JOIN\n" +
            "           (SELECT count(rootId) AS currentJoinCount,\n" +
            "                   products.productCode,\n" +
            "                   products.LongTitle\n" +
            "            FROM product_master products\n" +
            "            INNER JOIN joins ON products.productId = joins.productId\n" +
            "            WHERE year(joins.joinDate) = year(curDate())\n" +
            "              AND month(joins.joinDate) = month(curDate())\n" +
            "            GROUP BY products.productCode,\n" +
            "                     year(joins.joinDate) DESC, month(joins.joinDate) DESC) product_joins ON product_joins.productCode = limits.product_code\n" +
            "         WHERE limits.limit_type = 'Monthly'\n" +
            "      AND limits.effective_end_date >= DATE_ADD(CURDATE(), INTERVAL -3 MONTH))) AS capped_join_data\n";
    public static final String GET_ALL_RECORDS_BY_PROVIDER_ID = GET_ALL_RECORDS_SNIPPET
            + "WHERE capped_join_data.provider_id = ?;";
    public static final String GET_RECORDS_BY_ID = GET_ALL_RECORDS_SNIPPET
            + "WHERE capped_join_data.id in (?);";
}