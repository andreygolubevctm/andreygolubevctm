-- database deploy
UPDATE ctm.dialogue
SET text = 'Today we&#39;ll be comparing some products from nib, HCF, GMF, GMHBA, Frank, Australian Unity and Westfund. If you decide to purchase through us, we will arrange the sale on behalf of the fund and we&#39;ll receive a commission from them so we don&#39;t charge you a fee for our service.'
			WHERE dialogueID = 11
COMMIT;
-- rollback
SET text = 'Today we&#39;ll be comparing some products from HCF, GMF, GMHBA, Frank, Australian Unity and Westfund. If you decide to purchase through us, we will arrange the sale on behalf of the fund and we&#39;ll receive a commission from them so we don&#39;t charge you a fee for our service.'
			WHERE dialogueID = 11