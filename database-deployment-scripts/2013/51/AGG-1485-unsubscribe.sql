-- TEST
SELECT * FROM ctm.scrapes WHERE id = 134;

-- INSERT
INSERT INTO ctm.scrapes
(`id`,
`group`,
`url`,
`path`,
`cssSelector`,
`html`)
VALUES
(134,'meerkat','http://www.comparethemeerkat.com.au/','','',
'<p>The Compare the Meerkat website and the Compare the Meerkat brand and trading name are owned by, licensed to and/or operated by <a href="http://www.comparethemarket.com.au" target="_blank">Compare The Market</a> Pty Ltd (“CTM”) ACN 117323 378, AFSL 422926. This website is an advertisement feature of CTM that allows you to meet and compare our very special and unique team of meerkat characters. It also enables you to access the comparison services provided by CTM on the Compare the Market website by clicking on the link from this website. <a href="https://secure.comparethemarket.com.au/ctm/legal/website_terms_of_use.pdf" target="_blank">Website Terms of Use</a> <a href="https://secure.comparethemarket.com.au/ctm/legal/privacy_policy.pdf" target="_blank">Privacy Policy</a><br><i> </i></p>'
);
