-- database deploy
UPDATE ctm.dialogue
SET text = 'Now let&#39;s see if we can save you some money.<br />The Australian Government offers rebates to certain people.<br /><br />Would you like to find out if this applies to you and have it applied as a reduction to your premium?<br /><br />And how many dependants do you have?<br /><br />And income &#45; will your estimated combined taxable household income be (less than $176,000 for Family? &#45; less than $88,000 for Single)<br /><br />Okay, I just need to share some legal information with you.'
		WHERE dialogueID = 8
COMMIT;

-- rollback
SET text = 'Now let&#39;s see if we can save you some money.<br />The Australian Government offers rebates to certain people.<br /><br />Would you like to find out if this applies to you and have it applied as a reduction to your premium?<br /><br />And how many dependants do you have?<br /><br />And income &#45; will your estimated combined taxable household income be (less than $168,000 for Family? &#45; less than $84,000 for Single)<br /><br />Okay, I just need to share some legal information with you.'
			WHERE dialogueID = 8