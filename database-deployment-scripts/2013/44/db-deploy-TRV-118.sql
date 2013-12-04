-- TEST
SELECT * FROM aggregator.product_properties
WHERE ProductId = 20 AND PropertyId = 'subTitle';

-- DEPLOY
UPDATE aggregator.product_properties SET Text = 'Family cover - &lt;a href=&quot;https://www.magroup-online.com/AEX/AU/EN/AEX_AU_en_TCs.pdf&quot; target=&quot;_new&quot;&gt;See PDS&lt;/a&gt;' WHERE ProductId = 20 AND PropertyId = 'subTitle';