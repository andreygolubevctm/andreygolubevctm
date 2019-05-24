package com.ctm.web.core.dao;

import com.ctm.web.core.model.Touch;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Repository
public class TouchRepository {

    public static final String INSERT_TOUCH =
            "INSERT INTO ctm.touches (transaction_id, date, time, operator_id, type) " +
            "VALUES (:transactionId, now(), now(), :operatorId, :type)";
    public static final String INSERT_TOUCH_PRODUCT_PROPERTY =
            "INSERT INTO ctm.touches_products (touchesId, productCode) " +
            "VALUES (:touchesId, :productCode)";
    public static final String INSERT_TOUCH_COMMENT_PROPERTY =
            "INSERT INTO ctm.touches_comments (touchesId, comment) " +
            "VALUES (:touchesId, :comment)";

    private final NamedParameterJdbcTemplate jdbcTemplate;


    @Autowired
    @SuppressWarnings("SpringJavaAutowiringInspection")
    public TouchRepository(final NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Transactional
    public Touch store(Touch touch) {
        storeTouch(touch);
        storeTouchProductProperty(touch);
        storeTouchCommentProperty(touch);
        return touch;
    }

    private void storeTouchCommentProperty(Touch touch) {
        if (touch.getTouchCommentProperty() != null) {
            final GeneratedKeyHolder touchCommentPropertyKeyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(
                    INSERT_TOUCH_COMMENT_PROPERTY,
                    new MapSqlParameterSource()
                            .addValue("touchesId", touch.getId())
                            .addValue("comment", touch.getTouchCommentProperty().getComment()),
                    touchCommentPropertyKeyHolder);
            touch.getTouchCommentProperty().setId(touchCommentPropertyKeyHolder.getKey().longValue());
        }
    }

    private void storeTouchProductProperty(Touch touch) {
        if (touch.getTouchProductProperty() != null) {
            final GeneratedKeyHolder touchProductPropertyKeyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(
                    INSERT_TOUCH_PRODUCT_PROPERTY,
                    new MapSqlParameterSource()
                            .addValue("touchesId", touch.getId())
                            .addValue("productCode", touch.getTouchProductProperty().getProductCode()),
                    touchProductPropertyKeyHolder);
            touch.getTouchProductProperty().setId(touchProductPropertyKeyHolder.getKey().longValue());
        }
    }

    private void storeTouch(Touch touch) {
        final MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("transactionId", touch.getTransactionId())
                .addValue("operatorId",
                        Optional.ofNullable(
                                StringUtils.trimToNull(touch.getOperator()))
                                .orElse(Touch.ONLINE_USER))
                .addValue("type", touch.getType().getCode());
        final GeneratedKeyHolder touchKeyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(INSERT_TOUCH, params, touchKeyHolder);
        touch.setId(touchKeyHolder.getKey().intValue());
    }
}
