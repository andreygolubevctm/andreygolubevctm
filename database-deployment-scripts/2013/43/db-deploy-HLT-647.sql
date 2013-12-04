--
-- New Simples scripting dialogue
--

-- STAGING
/*
INSERT INTO ctm_staging.dialogue (dialogueId, text)
VALUES
*/

-- PRODUCTION
INSERT INTO ctm.dialogue (dialogueId, text)
VALUES
(34, '<h3 class="toggle">Closing</h3><div>Ask for the sale – ‘How would you like to proceed with the policy today?’<br/><strong>IF OBJECTION</strong><br/>Further question the customer to explore objection and ensure you have covered all information</div>')
, (33, '<h3 class="toggle">Presenting solutions</h3><div>1. Talk about the benefits that relate to customers\' needs<br/>2. Give overview of the product<br/>3. Involve the customer in the decision making<br/>4. Summarise the customer’s needs</div>')
, (32, '<h3 class="toggle">Exploring needs</h3><div>What is your monthly budget for Private Health Insurance?<br/>Is having the excess waived for day surgery or dependent children important to you?<br/>Are there any extras you would like to claim on straight away?<br/>How often do you use............ (Selected benefit)?<br/>How much do you pay for.......... (Selected benefit)?<br/>Would you prefer a group or individual limit for your dental?<br/>Would you prefer a percentage back or dollar value each time you use the service?<br/>Would you like me to go over the hospital or extras on the policy again?<br/>Do you require any further information about the policy or fund today?<br/>Do you require any further information on the agreement hospitals?</div>')
, (31, 'I have read all the "Next Steps" Information and Essential Information to the customer and they have agreed and understood.')
, (30, 'May I have the Medicare details of the Primary Policy Holder? (this is the first customer on the policy)')
, (29, 'Your first payment will include a month in advance and a pro-rata payment which covers you from your start date to your first payment date. If you have a direct debit set up with your current fund we suggest that you cancel the request as soon as possible.  You can do this through your fund\'s online member service area.')
, (28, 'Today we will be comparing some products from our \'participating brands\' and these brands can vary from time to time. For a full list of our \'particpating brands\' please see our website comparethemarket.com.au.  If you decide to purchase from us, we will arrange the sale on behalf of the fund and we\'ll receive a commission from them so we don\'t charge you a fee for our service.<br/><br/>We also compare a restricted Health Fuind with Commonwealth Bank of Australia called CBHS, may I ask if you or anyone close to you work for or have worked for CBA, Colonial State Bank or Bank West?<br/><br/><strong>SIS Confirmation</strong><br/>\'Based on the Standard Information Statement I have in front of me provided by privatehealth.gov.au\'')
, (27, 'In order to provide you with a Health insurance comparison, I will need to collect some personal information from you. Compare the market will provide your information to your health insurer if you decide to purchase a policy.')
, (26, 'We confirm that, based on the information provided by you, it is likely you will be eligible for a rebate of xxx%.  This rebate will  be applied as a discount to your premium.  We confirm that this is an estimate only and may be increased or decreased depending on  the assessment of your taxable income by the Australian Taxation Office.<br/>LHC - Based on the information provided by you there will be an LHC loading amount of XX% to be included in your premium.')
, (25, '<h3>If follow up call</h3><em>On our last call I went through.....</em><br/>1. What Hospital Insurance will cover you for.<br/>2. The waiting periods and exclusions on the policy.<br/>3. The excess and/or co-payments applicable.<br/>4. And covered the rebate and LHC.<br/>5. Extras limits and waiting periods.<br/><em>Would you like me to cover these again for you?</em>')
, (24, '<strong><em>Read the script APPLICABLE to the level of hospital cover the customer chooses;</em></strong><br/><br/>\'<strong><u>Private Hospital</u></strong> Insurance will cover you as a private patient in a private hosital, with your choice of doctor and will cover you up to the Medicare Schedule of Fees for anything considered to be medically or clinically necessary for those services you choose to include on your cover provided Medicare pay a benefit towards the procedure.\'<br/><strong><u>OR</u></strong><br/><br/>\'<strong><u>Private patient in a public hospital</u></strong> will cover you for hosptial treatment, including accommodation as a private patient in a shared room in a public hospital only. It will cover you up to the Medicare Schedule of Fees for anything to be considered medically or clinically necessary provided Medicare pay a benefit towards the procedure.\'<br/><br/><strong><u>What are the waiting periods:</u></strong> 12 months for pregnancy, birth related services and for pre-existing conditions;  2 months for psychiatric care, rehabilitation and palliative care even where these are pre-existing conditions, and  2 months for all other services.<br/><br/><strong><u>ONLY READ IF SWITCHING FUNDS</u></strong><br/>Any waiting periods that you have already served with your current fund will transfer with you to the same or lower level of cover.<br>If you choose to upgrade and include new services, higher limits or change your excess you may need to serve the waiting periods for those services.')
, (23, '<h3 class="toggle">Hospital/extras</h3><div><strong>Hospital</strong><br/>Would you like to be covered in a Private Hospital? Or Private Patient in a Public Hospital?<br/>When it comes to hospital cover you can lower your premiums by excluding certain services that you may not be using at this time, I will cover the exclusions now and if you can let me know if there are any that you would like to keep in the cover I can add those to the search.<br/>Keep in mind that you can add these services on at anytime, you will just need to serve the applicable waiting periods on anything you add.<br/><br/><strong>Extras</strong><br/>Extras normally come as a package and include a range of benefits; I will run through what you can include. Please let me know if any of these are important to you so that I can look for policies with enough limits for your needs.</div>')
, (22, '<h3 class="toggle">Exploring needs</h3><div>And what else is important for you to have covered?<br/>I can certainly help you &lt;insert need&gt; today.<br/>May I ask you a few questions to determine what you need, and then we can look at a number of different policies that match? This will take 10-15 minutes</div>')
, (21, '3 point security check<br/>I just need to advise this call is recorded for quality purposes')
, (20, '<h3 class="toggle">Greeting outbound</h3><div>Good Morning/Afternoon/Evening, this is &lt;name&gt; from Compare the Market. How are you today? Am I speaking with &lt;customer\'s name&gt;?<br/><br/>I\'m a Health Insurance Specialist and noticed you were on our website looking at &lt;insert policy type&gt;.....(pause)<br/><br/>I\'ve called to save you time with your Health Insurance, may I ask what\'s prompted you to compare policies with us?</div>')
, (19, '<h3 class="toggle">Greeting inbound</h3><div><strong>Welcome to Compare the Market, you\'re speaking with &lt;name&gt;, how may I help you? May I ask your name, please?</strong><br/>May I ask what\'s prompted you to compare policies today?</div>')
;

UPDATE ctm.dialogue SET text =
'Just confirming that we\'ll send your confirmation here.<br />Do you agree to receive news and offer emails from Compare the Market?'
WHERE dialogueID = 14;




-- ROLLBACK
/*
DELETE FROM ctm.dialogue
WHERE dialogueId BETWEEN 19 AND 34
*/
