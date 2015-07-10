USE simples;

DROP TABLE simples.cross_sales_leads;

CREATE TABLE simples.cross_sales_leads (
  id int(11) NOT NULL AUTO_INCREMENT,
  transactionId int(11) NOT NULL DEFAULT 0,
  transactionIdNew int(11) NOT NULL DEFAULT 0,
  fund varchar(45) DEFAULT NULL,
  dateFetched datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  isProcessed tinyint(4) DEFAULT 0,
  PRIMARY KEY (id),
  INDEX tranId_ndx (transactionId),
  INDEX tranId_New (transactionIdNew)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET latin1
COLLATE latin1_swedish_ci;