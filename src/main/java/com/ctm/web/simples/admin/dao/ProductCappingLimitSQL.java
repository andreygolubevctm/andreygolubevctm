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

    public static final String GET_PRODUCT_NAME = "SELECT LongTitle as productName\n" +
            "FROM product_master product\n" +
            "INNER JOIN product_properties_search props ON product.ProductId = props.ProductId\n" +
            "WHERE product.ProductCat = 'HEALTH'\n" +
            "  AND product.Status != 'X'\n" +
            "  AND product.ProviderId = ?\n" +
            "  AND product.LongTitle = ?\n" +
            "  AND (? between product.EffectiveStart and product.EffectiveEnd)\n" +
            "  AND (? between product.EffectiveStart and product.EffectiveEnd)\n";

    public static final String GET_PRODUCT_NAME_WITH_STATE_AND_MEMBERSHIP = GET_PRODUCT_NAME +
            "  AND props.state = ?\n" +
            "  AND props.membership = ?\n";

    public static final String GET_PRODUCT_NAME_WITH_STATE = GET_PRODUCT_NAME +
            "  AND props.state = ?\n";

    public static final String GET_PRODUCT_NAME_WITH_MEMBERSHIP = GET_PRODUCT_NAME +
            "  AND props.membership = ?\n";

    public static final String DELETE_BY_ID = "DELETE\n" +
            "FROM health_product_capping_limit\n" +
            "WHERE id = ?;";

    public static final String FIND_BY_LIMIT_PARAMS = "SELECT *\n" +
            "FROM health_product_capping_limit limits\n" +
            "WHERE limit_type = ?\n" +
            "  AND product_name = ?\n" +
            "  AND (limits.state = 'All' OR limits.state = ?)\n" +
            "  AND (limits.membership = 'All' OR limits.membership = ?)" +
            "  AND ((? BETWEEN limits.effective_start_date AND limits.effective_end_date)\n" +
            "       OR (? BETWEEN limits.effective_start_date AND limits.effective_end_date))\n" +
            "  AND limits.effective_end_date >= curDate();";
    public static final String CREATE =
            "INSERT INTO health_product_capping_limit (cap_limit, limit_type, limit_category, effective_start_date, effective_end_date, product_name, provider_id, membership, state)\n" +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);";
    public static final String UPDATE_BY_ID = "UPDATE health_product_capping_limit\n" +
            "SET limit_type = ?,\n" +
            "    limit_category = ?,\n" +
            "    effective_start_date = ?,\n" +
            "    effective_end_date = ?,\n" +
            "    cap_limit = ?\n" +
            "WHERE id = ?;";
    private static final String GET_ALL_RECORDS_SNIPPET = "SELECT id AS cappingLimitId,\n" +
            "          provider_id AS providerId,\n" +
            "          providerName,\n" +
            "          product_name,\n" +
            "          state,\n" +
            "          membership AS healthCvr,\n" +
            "          limit_type AS limitType,\n" +
            "          cap_limit AS cappingAmount,\n" +
            "          ifnull(currentJoinCount, 0) AS currentJoinCount,\n" +
            "          effective_start_date AS effectiveStart,\n" +
            "          effective_end_date AS effectiveEnd,\n" +
            "          limit_category AS cappingLimitCategory,\n" +
            "          (curDate() BETWEEN effective_start_date AND effective_end_date) AS isCurrent\n" +
            "   FROM (\n" +
            "           (SELECT limits.*,\n" +
            "                   providers.Name AS providerName,\n" +
            "                   product_joins.currentJoinCount\n" +
            "            FROM health_product_capping_limit limits\n" +
            "            INNER JOIN provider_master providers ON providers.providerId = limits.provider_id\n" +
            "            LEFT JOIN\n" +
            "              (SELECT date(joins.joinDate),\n" +
            "                      count(rootId) AS currentJoinCount,\n" +
            "                      products.LongTitle,\n" +
            "                      products.providerId,\n" +
            "                      props.state,\n" +
            "                      props.membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE date(joins.joinDate) = date(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        props.state,\n" +
            "                        props.membership,\n" +
            "                        date(joins.joinDate) DESC\n" +
            "               UNION SELECT date(joins.joinDate),\n" +
            "                            count(rootId) AS currentJoinCount,\n" +
            "                            products.LongTitle,\n" +
            "                            products.providerId,\n" +
            "                            'All' AS state,\n" +
            "                            'All' AS membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE date(joins.joinDate) = date(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        date(joins.joinDate) DESC\n" +
            "               UNION SELECT date(joins.joinDate),\n" +
            "                            count(rootId) AS currentJoinCount,\n" +
            "                            products.LongTitle,\n" +
            "                            products.providerId,\n" +
            "                            'All' AS state,\n" +
            "                            props.membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE date(joins.joinDate) = date(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        props.membership,\n" +
            "                        date(joins.joinDate) DESC\n" +
            "               UNION SELECT date(joins.joinDate),\n" +
            "                            count(rootId) AS currentJoinCount,\n" +
            "                            products.LongTitle,\n" +
            "                            products.providerId,\n" +
            "                            props.state,\n" +
            "                            'All' AS membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE date(joins.joinDate) = date(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        props.state,\n" +
            "                        date(joins.joinDate) DESC) product_joins ON product_joins.LongTitle = limits.product_name\n" +
            "            AND product_joins.state = limits.state\n" +
            "            AND product_joins.membership = limits.membership\n" +
            "            WHERE limits.limit_type = 'Daily'\n" +
            "              AND limits.effective_end_date >= DATE_ADD(CURDATE(), INTERVAL -3 MONTH))\n" +
            "         UNION\n" +
            "           (SELECT limits.*,\n" +
            "                   providers.Name AS providerName,\n" +
            "                   product_joins.currentJoinCount\n" +
            "            FROM health_product_capping_limit limits\n" +
            "            INNER JOIN provider_master providers ON providers.providerId = limits.provider_id\n" +
            "            LEFT JOIN\n" +
            "              (SELECT year(joins.joinDate),\n" +
            "                      month(joins.joinDate),\n" +
            "                      count(rootId) AS currentJoinCount,\n" +
            "                      products.LongTitle,\n" +
            "                      products.providerId,\n" +
            "                      props.state,\n" +
            "                      props.membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE year(joins.joinDate) = year(curDate())\n" +
            "                 AND month(joins.joinDate) = month(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        props.state,\n" +
            "                        props.membership,\n" +
            "                        year(joins.joinDate) DESC, month(joins.joinDate) DESC\n" +
            "               UNION SELECT year(joins.joinDate),\n" +
            "                            month(joins.joinDate),\n" +
            "                            count(rootId) AS currentJoinCount,\n" +
            "                            products.LongTitle,\n" +
            "                            products.providerId,\n" +
            "                            'All' AS state,\n" +
            "                            'All' AS membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE year(joins.joinDate) = year(curDate())\n" +
            "                 AND month(joins.joinDate) = month(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        year(joins.joinDate) DESC, month(joins.joinDate) DESC\n" +
            "               UNION SELECT year(joins.joinDate),\n" +
            "                            month(joins.joinDate),\n" +
            "                            count(rootId) AS currentJoinCount,\n" +
            "                            products.LongTitle,\n" +
            "                            products.providerId,\n" +
            "                            'All' AS state,\n" +
            "                            props.membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE year(joins.joinDate) = year(curDate())\n" +
            "                 AND month(joins.joinDate) = month(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        props.membership,\n" +
            "                        year(joins.joinDate) DESC, month(joins.joinDate) DESC\n" +
            "               UNION SELECT year(joins.joinDate),\n" +
            "                            month(joins.joinDate),\n" +
            "                            count(rootId) AS currentJoinCount,\n" +
            "                            products.LongTitle,\n" +
            "                            products.providerId,\n" +
            "                            props.state,\n" +
            "                            'All' AS membership\n" +
            "               FROM product_master products\n" +
            "               INNER JOIN joins ON products.productId = joins.productId\n" +
            "               INNER JOIN product_properties_search props ON props.productId = products.productId\n" +
            "               WHERE year(joins.joinDate) = year(curDate())\n" +
            "                 AND month(joins.joinDate) = month(curDate())\n" +
            "               GROUP BY products.LongTitle,\n" +
            "                        products.providerId,\n" +
            "                        props.state,\n" +
            "                        year(joins.joinDate) DESC, month(joins.joinDate) DESC) product_joins ON product_joins.LongTitle = limits.product_name\n" +
            "            AND product_joins.state = limits.state\n" +
            "            AND product_joins.membership = limits.membership\n" +
            "            WHERE limits.limit_type = 'Monthly'\n" +
            "              AND limits.effective_end_date >= DATE_ADD(CURDATE(), INTERVAL -3 MONTH))) AS capped_join_data\n";
    public static final String GET_ALL_RECORDS_BY_PROVIDER_ID = GET_ALL_RECORDS_SNIPPET
            + "WHERE capped_join_data.provider_id = ?;";
    public static final String GET_RECORDS_BY_ID = GET_ALL_RECORDS_SNIPPET
            + "WHERE capped_join_data.id in (?);";
}