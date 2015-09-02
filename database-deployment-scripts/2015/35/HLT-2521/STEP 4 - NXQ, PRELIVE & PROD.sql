/* */
set @contentCtrlId=0;

select contentControlId into @contentCtrlId from ctm.content_supplementary where supplementaryKey='@extras' and supplementaryValue='Accident_Only_Hospital_and_Silver_Plus_Extras';
select @contentCtrlId;
update ctm.content_supplementary set supplementaryValue='Silver Plus Extras' where contentControlId=@contentCtrlId and supplementaryKey='@extras';
update ctm.content_supplementary set supplementaryValue='/HCF/Silver_Plus_Extras.pdf' where contentControlId=@contentCtrlId and supplementaryKey='extrasPDF';
update ctm.content_supplementary set supplementaryValue='Accident Only Hospital Cover' where contentControlId=@contentCtrlId and supplementaryKey='@hospital';
update ctm.content_supplementary set supplementaryValue='/HCF/Accident_Only_Hospital_Cover.pdf' where contentControlId=@contentCtrlId and supplementaryKey='hospitalPDF';


select contentControlId into @contentCtrlId from ctm.content_supplementary where supplementaryKey='@extras' and supplementaryValue='Basic_Hospital_and_Silver_Plus_Extras';
select @contentCtrlId;
update ctm.content_supplementary set supplementaryValue='Silver Plus Extras' where contentControlId=@contentCtrlId and supplementaryKey='@extras';
update ctm.content_supplementary set supplementaryValue='/HCF/Silver_Plus_Extras.pdf' where contentControlId=@contentCtrlId and supplementaryKey='extrasPDF';
update ctm.content_supplementary set supplementaryValue='Basic Hospital' where contentControlId=@contentCtrlId and supplementaryKey='@hospital';
update ctm.content_supplementary set supplementaryValue='/HCF/Basic_Hospital.pdf' where contentControlId=@contentCtrlId and supplementaryKey='hospitalPDF';

select contentControlId into @contentCtrlId from ctm.content_supplementary where supplementaryKey='@extras' and supplementaryValue='Mid_Hospital_and_Silver_Plus_Extras';
select @contentCtrlId;
update ctm.content_supplementary set supplementaryValue='Silver Plus Extras' where contentControlId=@contentCtrlId and supplementaryKey='@extras';
update ctm.content_supplementary set supplementaryValue='/HCF/Silver_Plus_Extras.pdf' where contentControlId=@contentCtrlId and supplementaryKey='extrasPDF';
update ctm.content_supplementary set supplementaryValue='Mid Hospital' where contentControlId=@contentCtrlId and supplementaryKey='@hospital';
update ctm.content_supplementary set supplementaryValue='/HCF/Mid_Hospital.pdf' where contentControlId=@contentCtrlId and supplementaryKey='hospitalPDF';

select contentControlId into @contentCtrlId from ctm.content_supplementary where supplementaryKey='@extras' and supplementaryValue='Premium_Hospital_and_Silver_Plus_Extras';
select @contentCtrlId;
update ctm.content_supplementary set supplementaryValue='Silver Plus Extras' where contentControlId=@contentCtrlId and supplementaryKey='@extras';
update ctm.content_supplementary set supplementaryValue='/HCF/Silver_Plus_Extras.pdf' where contentControlId=@contentCtrlId and supplementaryKey='extrasPDF';
update ctm.content_supplementary set supplementaryValue='Premium Hospital' where contentControlId=@contentCtrlId and supplementaryKey='@hospital';
update ctm.content_supplementary set supplementaryValue='/HCF/Premium_Hospital.pdf' where contentControlId=@contentCtrlId and supplementaryKey='hospitalPDF';


select contentControlId into @contentCtrlId from ctm.content_supplementary where supplementaryKey='@extras' and supplementaryValue='Silver_Plus_Extras';
select @contentCtrlId;
update ctm.content_supplementary set supplementaryValue='Silver Plus Extras' where contentControlId=@contentCtrlId and supplementaryKey='@extras';
update ctm.content_supplementary set supplementaryValue='/HCF/Silver_Plus_Extras.pdf' where contentControlId=@contentCtrlId and supplementaryKey='extrasPDF';