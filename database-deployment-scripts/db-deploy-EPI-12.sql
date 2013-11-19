-- database deploy
CREATE INDEX providerId_index ON aggregator.product_master (providerId);
COMMIT;
-- rollback
DROP INDEX providerId_index ON aggregator.product_master