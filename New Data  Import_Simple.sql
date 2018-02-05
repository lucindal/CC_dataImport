use commoncause

--LAST UPDATED BY LUCINDA(APR 2017) WITH GIFTS THROUGH 


-- select * from gifthist_new
      
update gifthist_new 
set gift=[PAYMENT AMOUNT (TRANSACTIONS)],
	gift_date=cast([GIFT DATE (TRANSACTIONS)] as datetime)

update gifthist_new set giftdate = convert(char(8),gift_date,112)

select count(*) from gifthist where gift_date >= '2017-07-01'

select min(gift_date), max(gift_date), sum(gift),count(*) from gifthist_new 
select min(gift_date), max(gift_date), sum(gift),count(*)  from gifthist


delete from gifthist where gift_date >= '2017-07-01'

--check this
--UPDATE TO INCLUDE GIFT KIND AND SOFT CREDIT TYPE

insert into GIFTHIST
([ACCOUNT_ID]
      ,[GIFTDATE_CHAR]
      ,[SOURCE]
      ,[DESCRIPTION]
      ,[TRANSACTION_TYPE]
      ,[GIFT_KIND]
      ,[SOFT_CREDIT_TYPE]
      ,[PAYMENT_AMOUNT]
      ,[gift]
      ,[gift_date]
      ,[giftdate]
      ,[donor_id])
SELECT [ACCOUNT ID (TRANSACTIONS)]
      ,[GIFT DATE (TRANSACTIONS)]
      ,[SOURCE (TRANSACTIONS)]
      ,[DESCRIPTION (SOURCES) (Giver)]
      ,[TRANSACTION TYPE]
      ,[GIFT KIND (TRANSACTIONS)]
      ,[SOFT CREDIT TYPE]
      ,[PAYMENT AMOUNT (TRANSACTIONS)]
      ,[gift]
      ,[gift_date]
      ,[giftdate]
,[ACCOUNT ID (TRANSACTIONS)]
FROM GIFTHIST_NEW



update gifthist set fy_cash=year(gift_date) where month(gift_date) between 1 and 6 and gift_date >= '2017-07-01' --fy_cash is null ---and gift_date>= '2014-07-01'
update gifthist set fy_cash=year(dateadd(year,1,gift_date)) where month(gift_date) between 7 and 12 and gift_date >= '2017-07-01' ---fy_cash is null --and gift_date>= '2014-07-01'



--SELECT SUBSTRING(SOURCE,1,2),COUNT(*) FROM GIFTHIST WHERE FY_CASH = 2014
--GROUP BY SUBSTRING(SOURCE,1,2)
--ORDER BY SUBSTRING(SOURCE,1,2)

--SELECT SUBSTRING(SOURCE,1,2),COUNT(*) FROM GIFTHIST WHERE FY_CASH = 2016
--GROUP BY SUBSTRING(SOURCE,1,2)
--ORDER BY SUBSTRING(SOURCE,1,2)

--STATES


--NEED TO AMMEND TO INCLUDE NEW FY15+ SOURCES!!!!!!!!??
--IT APPEARS THAT THE BASIC ROOT STRUCTURE DID NOT CHANGE?

--alter table gifthist add states int, track int

update gifthist set states=1 where ([source] like 'AS%' or [source] like 'YS%') 
and states is null and gift_date>= '2017-07-01'
update gifthist set states=0 where states is null and gift_date>= '2017-07-01'

select states, count(*) from gifthist
group by states

--select fy_cash,states, count(*) from gifthist
--group by fy_cash,states
--order by fy_cash,states

--TRACK
select states, count(*) from gifthist where fy_cash = 2017 group by states
select track, count(*) from gifthist where fy_cash = 2017 group by track
 --TRACKING OF GIFTS PRIMARILY BEGINS IN FY05
 --THIS IS THE KNOWLEDGE THAT NANCY AND DENNIS HAD, FY05+

--SELECT FY_CASH,track,COUNT(*) FROM GIFTHIST where gift> 0 
--and states=0  
--  group by fy_cash,track order by fy_cash,track
    
--SELECT FY_CASH,(COUNT(*)-SUM(track)+.00000001)/COUNT(*) AS PERCENTAGE_UNTRACKED ,
--COUNT(*)-SUM(track) AS UNTRACKED,COUNT(*)AS TOTAL,SUM(track) AS TRACKED FROM GIFTHIST where gift> 0 and states=0  
--  group by fy_cash order by fy_cash

--update gifthist set track=0

update gifthist set track=1 where ([source] like 'A%' or
[source] like 'Y%') --and gift<1000  --A IS ANNUAL RENEWAL C4, Y IS 501(C)3 EDUCATION FUND
and [source] not like 'YPB%'--EXCLUDE PLANNED GIVING C3 NATIONAL
and [source] not like 'YSB%'--EXCLUDE PLANNED GIVING C3 STATE
and [source] not like 'YEE%'--EXCLUDE EVENTS C3 NATIONAL
and [source] not like 'YSE%'--EXCLUDE EVENTS C3 STATE
and [source] not like 'YDF%'--EXCLUDE FOUNDATIONS C3 NATIONAL
and [source] not like 'YSF%'--EXCLUDE FOUNDATIONS C3 STATE
and [source] not in (select [source] from Source_Codes_No_Tracking) and gift_date >= '2017-07-01'--- and track is null--EXCLUDE A LIST OF CODES NOT SURE WHERE THESE CAME FROM
--THE SOURCE_CODES_NO_TRACKING ARE C3 AND A MAJORITY ARE YSY--C3 STATE

update gifthist set track=0 where gift_date >= '2017-07-01' and track is null
update gifthist set track=0 where (source like 'AD%' or source like 'YD%') and gift>=1000--EXCLUDE DEVELOPMENT $1,000+ NATIONAL
update gifthist set track=0 where states=1 and gift>10000 and gift_date>= '2017-07-01'--EXCLUDE STATE GIFTS ABOVE $10,000


--select transaction_type,gift_kind,soft_credit_type,count(*) from gifthist where track = 1 and gift > 0
--group by transaction_type,gift_kind,soft_credit_type
--order by transaction_type,gift_kind,soft_credit_type

--E F AND P CODES ARE NOT MENTIONED AND THUS EXCLUDED BY DEFAULT
--THEY ARE EVENT FOUNDATION AND PLANNED GIVING

--select fy_cash, count(*),sum(track) from gifthist where source in (select [source] from Source_Codes_No_Tracking)
--group by fy_cash
--order by fy_cash

--select source, count(*) as gifts,sum(gift) as rev from gifthist
--where source in (select [source] from Source_Codes_No_Tracking)
--group by source
--order by source

--select fy_cash, count(*) as gifts,sum(track) as tracked_gifts,(sum(track)+.01)/count(*) as percent_tracked from gifthist where gift >0
--group by fy_cash
--order by fy_cash

--select count(*),sum(gift) from gifthist where [source] in (select [source] from Source_Codes_No_Tracking)
--and gift>=1000 and track=1

--select [source],sum(gift) from gifthist where [source] in (select [source] from Source_Codes_No_Tracking)
--and gift>=1000 and track=1
--group by source


--NEED TO AMMEND TO INCLUDE NEW FY15+ SOURCES!?
--IT APPEARS THAT THE BASIC ROOT STRUCTURE DID NOT CHANGE?

update gifthist set c4=1 where [source] like 'A%' and c4 is null and gift_date>= '2014-07-01' 
update gifthist set c4=0 where c4 is null and gift_date>= '2014-07-01'

--select c4, count(*) from gifthist
--group by c4

--select fy_cash,c4, count(*) from gifthist
--group by fy_cash,c4
--order by fy_cash,c4

--C3
--alter table gifthist add c3 int

--NEED TO AMMEND TO INCLUDE NEW FY15+ SOURCES!!!!!!!!?
--IT APPEARS THAT THE BASIC ROOT STRUCTURE DID NOT CHANGE?

update gifthist set c3=1 where [source] like 'Y%' and c3 is null and gift_date>= '2014-07-01'
update gifthist set c3=0 where c3 is null and gift_date>= '2014-07-01'

--select c3, count(*) from gifthist
--group by c3

--select fy_cash,c3, count(*) from gifthist
--group by fy_cash,c3
--order by fy_cash,c3

--select channel, count(*) from gifthist where track=1
--group by channel
--First Gift

--ALTER TABLE gifthist DROP COLUMN fg_date
--ALTER TABLE gifthist ADD fg_date DATETIME

--SELECT DISTINCT fg_date FROM GIFTHIST

--update gifthist set fg_date = null
--update gifthist set fg_amt = null
--update gifthist set join_year = null
--update gifthist set fg_date_overall = null

--select * from gifthist where source_bak is null 

--sp_dash is merlin gifts
--dash does not use that filter
--dash considers national and tracked
--select fy_cash,count(*)as gifts,
--sum(track) as tracked,cast(sum(track) as float)/count(*) as perc_tracked,
--sum(sp_dash) as merlin,cast(sum(sp_dash) as float)/count(*) as perc_merlin, sum(gift) 
--from gifthist
--where states = 0
--group by fy_cash
--order by fy_cash

--USE COMMONCAUSE

--UPDATE GIFTHIST SET fg_date = NULL, FG_AMT = NULL, JOIN_YEAR = NULL

--IN SEPT16 IT WAS DECIDED TO FINALIZE AND CONFIRM THE NEW JOIN DEFINITION:
--FIRST EVER GIFT (REGARDLESS OF PROGRAM) WILL BE CONSIDERED THE DONOR'S JOIN GIFT

--SELECT TOP 1000 * FROM GIFTHIST

--UPDATE GIFTHIST SET
--FG_AMT = NULL,
--FG_RANGE= NULL,
--FG_DATE= NULL,
--JOIN_YEAR= NULL

--IN SEPT16 IT WAS DECIDED TO CHANGE TO METHODOLOGY:
--FIRST EVER GIFT (REGARDLESS OF PROGRAM) WILL BE CONSIDERED THE DONOR'S JOIN GIFT
with summary as
(select * , row_number() over (partition by donor_id
 order by gift_date asc, gift desc) 
as ronumb from gifthist where gift > 0 ) 
merge gifthist using summary
on summary.donor_id=gifthist.donor_id
when matched and ronumb=1 and gifthist.fg_date is null 
then update set gifthist.fg_date=summary.gift_date, 
gifthist.fg_amt=summary.gift;
;
/*
WITH
	SecondGiftSetup AS (
		SELECT
			donor_id,
			gift,
			gift_date,
			fg_date,
			ROW_NUMBER() OVER (PARTITION BY donor_id ORDER BY gift_date) AS RN
		FROM
			gifthist
		WHERE
			gift_date > fg_date
			AND gift > 0
	),
	
	SecondGiftSelect AS (
		SELECT
			donor_id,
			gift,
			gift_date,
			fg_date
		FROM
			SecondGiftSetup
		WHERE
			RN = 1
	)
	
UPDATE gifthist
SET
	SGDate = SG.gift_date,
	SGAmount = SG.gift
FROM
	gifthist GH
	INNER JOIN SecondGiftSelect SG
	ON GH.donor_id = SG.donor_id
;
*/
update gifthist set join_year=year(fg_date) where month(fg_date)
 between 1 and 6 and join_year is null
update gifthist set join_year=year(dateadd(year,1,fg_date))
 where month(fg_date) between 7 and 12 and join_year is null


--IMPORTANT!
--IN THE CONFUSION OF THE APPROPRIATE WAY TO CREATE FG_DATE, SOME INCONSISTENCIES RESULTED
--CURRENTLY THE FG_DATE IS CREATED BY LOOKING AT THE FIRST NON-ZERO TRACKED GIFT
--OTHER METHODS HAVE BEEN USED IN THE PAST FOR VARIOUS USES (FIRST NON-ZERO, FIRST NON-ZERO TRACKED NON-STATES, ETC.)
--A SOLID CONSENSES ON THIS MAY NEED TO HAPPEN SOON
--BECAUSE THE TRACKING METHODS ARE ONLY 100% RELEVANT THROUGH 2005 IT MAY MAKE THE MOST SENSE TO USE AN OVERALL FIRST GIFT DATE
--IF INCONSISTENCIES ARE FOUND IN MFA OR DASHBOARD REGARDING NEW JOINS AND OTHER MEMBER COUNTS - THIS IS LIKELY THE REASON
--FOR NOW RUN THIS UPDATE IMMEDIATELY BELOW
--First TRACKED Gift
--with summary as
--(select * , row_number() over (partition by donor_id order by gift_date asc, gift desc) as ronumb from gifthist 
--where gift > 0 and track=1 ) 
--merge gifthist using summary
--on summary.donor_id=gifthist.donor_id
--when matched and ronumb=1 and gifthist.fg_date is null 
--then update set gifthist.fg_date=summary.gift_date, gifthist.fg_amt=summary.gift;

--select donor_id,count(distinct fg_date) from gifthist
--group by donor_id
--order by count(*) desc

--select * from gifthist where track is null
--order by gift_date desc

--for dashboard compare--not a big difference in AG at all

--36.336
 --(select avg(gift) from gifthist where fy_cash = 2016 and gift > 0 and track=1 and states=0
 -- and donor_id not in (select donor_id from gifthist where fy_cash < 2015 and
 --    gift > 0 and track=1 and states=0 AND donor_id IS NOT NULL)
 -- and gift_date = fg_date)

--36.336
 --(select avg(gift) from gifthist where fy_cash = 2016 and gift > 0 and track=1 and states=0
 -- and donor_id not in (select donor_id from gifthist where fy_cash < 2015 and
 --    gift > 0 and track=1 and states=0 AND donor_id IS NOT NULL)
 -- and gift_date = fg_date_overall)

--FIRST GIFT OVERALL FOR JY FY ANALYSIS
--what other analyses should use this version of first gift?


--SELECT DISTINCT fg_date_overall FROM GIFTHIST

--with summary as
--(select * , row_number() over (partition by donor_id order by gift_date asc,gift desc ) as ronumb from gifthist
--where gift > 0)
--merge gifthist using summary
--on summary.donor_id=gifthist.donor_id
--when matched and ronumb=1 and gifthist.fg_date_overall is null 
--then update set gifthist.fg_date_overall=summary.gift_date;

--select donor_id,count(distinct fg_date_overall) from gifthist
--group by donor_id
--order by count(*) desc

--use fg_date or fg_date overall for join_year?
--update gifthist set join_year=null

--FOR NOW DON'T RUN THIS
--USING FIRST OVERALL GIFT
--update gifthist set join_year=year(fg_date_overall) where month(fg_date_overall) between 1 and 6
--update gifthist set join_year=year(dateadd(year,1,fg_date_overall)) where month(fg_date_overall) between 7 and 12


--Source Codes
--Kate No Longer Modifies Sustainer Sources
--OLD METHOD WAS TO ADD 'SG' update gifthist set source = source + 'SG' where gift_kind = 'SG'
--SHOULD NOT BE NECESSARY TO MODIFY SOURCES ANYMORE--AUG 31, 2015

--alter table gifthist add source_bak varchar(50)
update gifthist set source_bak = source where gift_date >= '2017-07-01'

UPDATE gifthist SET source = LTRIM(RTRIM(source)) where gift_date >= '2017-07-01'
go


update gifthist set sp_dash = 0 where sp_dash is null

--RUN MISKEYS FIRST!
--UPDATE INDICES

declare @vchSRC varchar(50)
declare @vchMK varchar(50)

declare curX cursor for   
 select SrcCode, Miskey from SQL02.Merlin06Prod.dbo.[Sources MISKEY],
 SQL02.Merlin06Prod.dbo.Sources 
   where [Sources MISKEY].ClientGrpID = 102
   and Sources.SrcID = [Sources MISKEY].SrcID
   AND SUSTAINER = 0


open curX

FETCH NEXT FROM curX INTO @vchSRC,@vchMK
WHILE (@@FETCH_STATUS <> -1) 
BEGIN
  UPDATE GIFTHIST set [SOURCE] = @vchSRC  
     where [SOURCE] = @vchMK  
  FETCH NEXT FROM curX INTO @vchSRC,@vchMK
END
  
CLOSE curX
DEALLOCATE curX


declare @vchSRC varchar(50)
declare @vchMK varchar(50)
declare @dteSD datetime
declare @dteED datetime

declare curX cursor for   
 select RekeyDuplicateCode,MiskeyDuplicateCode,RekeyBeginDate,RekeyEndDate 
     from SQL02.Merlin06Prod.dbo.[Sources MISKEY - DUPES]
   where [Sources MISKEY - DUPES].ClientGroupID = 102 ---Always change ClientGrpID in cursors before running queries!!!!!!!!!!
   
   
open curX

FETCH NEXT FROM curX INTO @vchSRC,@vchMK,@dteSD,@dteED
WHILE (@@FETCH_STATUS <> -1) 
BEGIN
  UPDATE GIFTHIST set [SOURCE] = @vchSRC  
     where [SOURCE] = @vchMK and GIFT_DATE between @dteSD and @dteED
  FETCH NEXT FROM curX INTO @vchSRC,@vchMK,@dteSD,@dteED
END
  
CLOSE curX
DEALLOCATE curX
 
 --select * from gifthist where sp_dash is null 
 
 --updATE gifthist set sp_dash = 0 where sp_dash is null 

--WHAT IS THE SP_DASH FIELD USED FOR NOW?------ANS BY LUCINDA: IT WAS USED AS A FILTER IN THE DASH SP.
----- NOW IT IS JUST  FOR TRACKING AVALON CODES
update gifthist set sp_dash = 1 where source in 
(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
and pkgdetailid in (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] 
where effortid in(select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
(select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
and CpgTypeID <> 10)))) AND gift > 0 and sp_dash = 0
     
--     SELECT SOURCE,COUNT(*) FROM GIFTHIST WHERE GIFT_DATE > '2015-07-01' AND SP_DASH = 0
--     GROUP BY SOURCE
--     ORDER BY SOURCE
     
--select fy_cash, count(*) as gifts, sum(gift) as revenue from gifthist where sp_dash = 1 group by fy_cash order by fy_cash
--select count(*) as gifts, sum(gift) as revenue from gifthist where gift_date between '2014-10-01' and '2015-09-30'
--and  sp_dash = 1 
--select count(*) from gifthist where join_year=1980 and fg_date<>'1980-01-01'

--select * from gifthist --where sp_dash is null
--order by gift_date desc

/************************************************
--FOR ALL CHANNEL ALLOCATIONS: FOR YEARS WHERE MERLIN IS ACCURATE, 
--MAKE SURE TO INCLUDE THOSE SOURCES AS WELL WHEN CLASSIFYING THE GIFTS TO CHANNEL
************************************************/

--NEED TO CHECK THE ALLOCATION OF CHANNELS FOR FY15+
--IS THE ORIGINAL CHANNEL ALLOCATION INVALID FOR FY15+
--IS THE NEW ALLOCATION IN ADDITION TO THE ORIGINAL ALLOCATION?
--CARRYOVER FROM FY14 TO FY15 COMPLICATES?
--would the channel/source identification for codes prior to FY15 be valid moving beyond FY15?  Until what point?
--Would these sources be repurposed for another channel?
--at what point would this script not be run?

--DM

update gifthist set dm=1 where ([source] like 'AM%' or [source] like 'AD%' or [source] like 'AS%' 
or [source] like 'YM%' or [source] like 'YD%' or [source] like 'YSQ%' or [source] like 'YSY%') 
and [source] not like 'YDF%' and [source] not like 'YDW%' and [source] not like 'YMW%'
and substring([source],8,1) <>'T' and [source] 
not like 'AMW%' and [source] not like 'ADW%' and [source] not like 'ASW%' and dm is null

update gifthist set dm=0 where dm is null

--select count(*) as count,dm,SUBSTRING(LTRIM(SOURCE),1,3) as source3,SUBSTRING(LTRIM(SOURCE),8,1) as eighth from gifthist 
--where dm = 1 and GIFT_DATE >= '2014-07-01'
--group by dm,SUBSTRING(LTRIM(SOURCE),1,3),SUBSTRING(LTRIM(SOURCE),8,1)
--order by dm,SUBSTRING(LTRIM(SOURCE),1,3),SUBSTRING(LTRIM(SOURCE),8,1)

--SOURCE LIKE 'AM%' AND SUBSTRING(LTRIM(SOURCE),8,1)='D' AND SUBSTRING(LTRIM(SOURCE),3,1) IN ('Q','A','R','S','L')

--NEW SOURCE CODE LOGIC FOR DM APPLIED ON CAMPAIGNS FY15 AND FORWARD

UPDATE GIFTHIST SET DM = 1 WHERE SOURCE LIKE 'AM%' AND SUBSTRING(LTRIM(SOURCE),8,1)='D' AND SUBSTRING(LTRIM(SOURCE),3,1) IN ('Q','A','R','S','L')
--OR (SUBSTRING(LTRIM(SOURCE),1,3) IN ('ASA','YSA'))) --STATES GIFTS WILL NOT BE CALLED DM FOR OUR ANALYSES UNLESS WE WANT TO STUDY STATES DM SPECIFICALLY
AND GIFT_DATE >= '2014-07-01' and (dm is null or dm = 0)

--SELECT DM,TM,WEB,EMAIL,WM,COUNT(*) FROM GIFTHIST
--WHERE FY_CASH >= 2012 AND SOURCE IN
--(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
--  and pkgdetailid in 
--  (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] where effortid in
--  (select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
--  (select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
--     and MEDIAID = 1 AND CPGTYPEID <> 10))))
--     GROUP BY DM,TM,WEB,EMAIL,WM
--     ORDER BY DM,TM,WEB,EMAIL,WM
     
UPDATE GIFTHIST SET DM = 1 WHERE
FY_CASH >= 2012 AND SOURCE IN
(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
  and pkgdetailid in 
  (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] where effortid in
  (select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
  (select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
     and MEDIAID = 1 AND CPGTYPEID <> 10)))) AND DM = 0 AND TM = 0 AND WEB = 0

--ACKNOWLEDGEMENTS?

--SELECT * FROM GIFTHIST WHERE SOURCE LIKE 'AMK%' AND SUBSTRING(LTRIM(SOURCE),8,1)='D'

--TM
--is national/state coded?

--alter table gifthist add tm int

--No Tm gifts in FY 2015?
--Does This Even Work?
--Not Like AW? AWQ?
update gifthist set tm=1 where (substring([source],8,1)='T' and [source] not like 'AS%' and gift_date>='2008-07-01'
and [source] not like 'AMW%' and [source] not like 'ADW%' and [source] not like 'YMW%' and [source] not like 'YDW%' and
[source] not like 'AW%' and [source] not like 'YW%' and [source] not like 'AWA%' and [source] not like 'AWR%' and [source] not like 'AWQ%' 
and [source] not like 'AWS%'
and [source] not like 'ASW%' and [source] not like 'YSW%') and tm is null

update gifthist set tm=0 where tm is null

--ADDING RELEVANT MERLIN DATA (FY 2012 AND FORWARDS)
update gifthist set tm=1 WHERE TM = 0 AND FY_CASH >= 2012 AND SOURCE IN
(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
  and pkgdetailid in 
  (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] where effortid in
  (select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
  (select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
     and MEDIAID = 2 AND CPGTYPEID <> 10))))

--NEW SOURCE CODE LOGIC FOR TM APPLIED ON CAMPAIGNS FY15 AND FORWARD

UPDATE GIFTHIST SET TM = 1 WHERE SOURCE LIKE 'AM%' AND SUBSTRING(LTRIM(SOURCE),8,1)='T' AND SUBSTRING(LTRIM(SOURCE),3,1) IN ('Q','A','R','S')
--OR (SUBSTRING(LTRIM(SOURCE),1,3) IN ('AST','YST'))) --STATES GIFTS WILL NOT BE CALLED TM FOR OUR ANALYSES UNLESS WE WANT TO STUDY STATES TM SPECIFICALLY
AND GIFT_DATE >= '2014-07-01'

--select fy_cash, count(*) from gifthist where tm = 1
--and source like 'AW%'
--group by fy_cash
--order by fy_cash

--Use this?
--update gifthist set tm=0 where [source] like 'AW%'

--select fy_cash, count(*) from gifthist where TM = 1
--group by fy_cash
--order by fy_cash

--select * from gifthist where source like 'AW%'

--select fy_cash, count(*) from gifthist where (substring([source],8,1)='T' and [source] not like 'AS%' and gift_date>='2008-07-01'
--and [source] not like 'AMW%' and [source] not like 'ADW%' and [source] not like 'YMW%' and [source] not like 'YDW%' and
--[source] not like 'AW%' and [source] not like 'YW%' and [source] not like 'AWA%' and [source] not like 'AWR%' --and [source] like 'AWQ%' 
--and [source] not like 'AWS%'
--and [source] not like 'ASW%' and [source] not like 'YSW%')
--group by fy_cash
--order by fy_cash

--select fy_cash, count(*) from gifthist where tm = 1
--and source like 'AW%'
--group by fy_cash
--order by fy_cash

--select fy_cash, count(*) from gifthist where tm = 1
--and source like 'AWQ%'
--group by fy_cash
--order by fy_cash

--select substring(source,1,2), count(*) from gifthist where tm = 1 and fy_cash >= 2012
--group by substring(source,1,2)
--order by substring(source,1,2)

--select substring(source,1,3), count(*) from gifthist where tm = 1 and fy_cash >= 2012
--group by substring(source,1,3)
--order by substring(source,1,3)


--Web

--alter table gifthist add web int

--Does This Even Work?
update gifthist set web=1 where ([source] like 'AMW%' or [source] like 'ADW%' or [source] like 'YMW%' or [source] like 'YDW%' or
[source] like 'AW%' or [source] like 'YW%' or [source] like 'AWA%' or [source] like 'AWR%' or [source] like 'AWQ%' or [source] like 'AWS%'
or [source] like 'ASW%' or [source] like 'YSW%') and web is null
update gifthist set web=0 where web is null


--NEW SOURCE CODE LOGIC FOR WEB APPLIED ON CAMPAIGNS FY15 AND FORWARD

UPDATE GIFTHIST SET WEB = 1 WHERE SOURCE LIKE 'AMW%' AND GIFT_DATE >= '2014-07-01'

--select fy_cash, count(*) from gifthist where web = 1
--group by fy_cash
--order by fy_cash

--select * from gifthist where [source] like 'YW%' and web=1

--EMAIL

--NEW SOURCE CODE LOGIC FOR EMAIL APPLIED ON CAMPAIGNS FY15 AND FORWARD
ALTER TABLE GIFTHIST ADD EMAIL INT

UPDATE GIFTHIST SET EMAIL = 0 WHERE EMAIL IS NULL

UPDATE GIFTHIST SET EMAIL = 1, DM = 0 WHERE SOURCE LIKE 'AM%' AND SUBSTRING(LTRIM(SOURCE),8,1)='E' AND SUBSTRING(LTRIM(SOURCE),3,1) IN ('Q','A','R','S')
AND GIFT_DATE >= '2014-07-01'

--ASW AND YSW ARE CONSIDERED WEB CURRENTLY, COULD BE CALLED STATE EMAIL

--NEW SOURCE CODE LOGIC FOR WM APPLIED ON CAMPAIGNS FY15 AND FORWARD

--ALTER TABLE GIFTHIST ADD WM INT

UPDATE GIFTHIST SET WM = 0 WHERE WM IS NULL
UPDATE GIFTHIST SET WM = 1 WHERE SUBSTRING(LTRIM(SOURCE),8,5)= '01001'
UPDATE GIFTHIST SET WM = 0 WHERE DM+TM+WEB+EMAIL > 0 AND WM = 1

--SELECT DISTINCT DM,TM,WEB,EMAIL,WM FROM GIFTHIST WHERE WM = 1

UPDATE GIFTHIST SET DM = 1 WHERE
FY_CASH >= 2012 AND SOURCE IN
(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
  and pkgdetailid in 
  (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] where effortid in
  (select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
  (select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
     and MEDIAID = 1 AND CPGTYPEID <> 10)))) AND DM = 0 AND TM = 0 AND WEB = 0
     
--PROGRAM TYPES NEED TO BE AMMENEDED TO INCLUDE NEW FY15+ SOURCE LOGIC!!!!!!!!!!!!!

--Appeals

--alter table gifthist add appeal int

update gifthist set appeal=1 where ([source] like 'AMA%' or [source] like 
'ADA%' or [source] like 'AWA%' or [source] like 'ASA%') and appeal is null
GO
update gifthist set appeal=0 where appeal is null
GO

--Lapsed

--alter table gifthist add lapsed int
--select * from gifthist where lapsed is null

update gifthist set lapsed=1 where [source] like 'AML%' and lapsed is null and fy_cash = 2017
GO
update gifthist set lapsed=0 where lapsed is null and fy_cash = 2017
GO

--Renewals

--alter table gifthist add renewal int

update gifthist set renewal=1 where ([source] like 'AMR%' or [source] like 'ADR%' or [source] like 'AWR%') and renewal is null
go
update gifthist set renewal=0 where renewal is null
go

--Acquisition

--alter table gifthist add acq int

update gifthist set acq=1 where ([source] 
like 'AMQ%' or [source] like 'ADQ%' or [source] like 'AWQ%' or [source] like 'ASQ%') and acq is null
go
update gifthist set acq=0 where acq is null
go

--Sustainer

--alter table gifthist add sust int

--new method
update gifthist set sust=1 where gift_kind = 'SG' and sust is null --104658
go
update gifthist set sust=0 where sust is null
go

/* Old method prior to Aug 2015 update
select count(*) from gifthist where [source] like 'AMS%' or ([source] like 'AWS%' and gift_date>='2012-08-01') --
update gifthist set sust=1 where [source] like 'AMS%'  and sust is null
update gifthist set sust=1 where [source] like 'AWS%' and gift_date>='2012-08-01' and sust is null
update gifthist set sust=0 where sust is null
*/

--alter table gifthist add channel varchar(10)

--SELECT DM,WEB,EMAIL,TM,WM,SUM(DM+WEB+EMAIL+TM+WM),COUNT(*) FROM GIFTHIST
--GROUP BY DM,WEB,EMAIL,TM,WM
--ORDER BY DM,WEB,EMAIL,TM,WM

--SELECT * FROM GIFTHIST WHERE DM = 1 AND TM = 1
--ORDER BY GIFT_DATE

--SELECT * FROM GIFTHIST WHERE substring([source],8,1)<>'T' AND FY_CASH >= 2012 AND SOURCE IN
--(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
--  and pkgdetailid in 
--  (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] where effortid in
--  (select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
--  (select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
--     and MEDIAID = 2 AND CPGTYPEID <> 10))))
     
--SELECT * FROM GIFTHIST WHERE DM = 1 AND FY_CASH >= 2012 AND SOURCE IN
--(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
--  and pkgdetailid in 
--  (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] where effortid in
--  (select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
--  (select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
--     and MEDIAID = 2 AND CPGTYPEID <> 10))))    

UPDATE GIFTHIST SET DM = 0 WHERE  DM = 1 AND FY_CASH >= 2012 AND SOURCE IN
(select srccode from SQL02.Merlin06Prod.dbo.Sources where clientgrpid = 102
  and pkgdetailid in 
  (select pkgdetailid from SQL02.Merlin06Prod.dbo.[Package Details] where effortid in
  (select effortid from SQL02.Merlin06Prod.dbo.Efforts where cpgid in
  (select cpgid from SQL02.Merlin06Prod.dbo.Campaigns where clientgrpid = 102
     and MEDIAID = 2 AND CPGTYPEID <> 10))))    

update gifthist set channel='DM' where dm=1 and channel is null
--update gifthist set channel='Web' where web=1 and channel is null
--update gifthist set channel='Email' where email=1 and channel is null
update gifthist set channel='TM' where tm=1 and channel is null
update gifthist set channel='WM' where WM=1 and channel is null
update gifthist set channel='ONLINE' where (EMAIL=1 OR WEB = 1) and channel is null

--SELECT CHANNEL,COUNT(*) FROM GIFTHIST
--GROUP BY CHANNEL
--ORDER BY CHANNEL


--SELECT TRACK,CHANNEL,COUNT(*) FROM GIFTHIST
--GROUP BY TRACK,CHANNEL
--ORDER BY TRACK,CHANNEL

--use commoncause
----QC
--select sum(gift) from gifthist where dm=1 and states=1
----Fy2013
--select sum(gift) from gifthist where fy_cash=2013 and dm=1 and states=1 and track=1 --and gift<1000

--select sum(gift) from gifthist where fy_cash=2013 and web=1 and states=1 and track=1 --and gift<1000

--select sum(gift) from gifthist where fy_cash=2013 and tm=1 and states=1 and track=1 --and gift<1000

--select sum(gift) from gifthist where fy_cash=2013 and tm=0 and dm=0 and web=0 and states=1 and track=1 --and gift<1000



----Fy2012
--select sum(gift) from gifthist where fy_cash=2012 and dm=1 and states=1 and track=1 --and gift<1000

--select sum(gift) from gifthist where fy_cash=2012 and web=1 and states=1 and track=1 --and gift<1000

--select sum(gift) from gifthist where fy_cash=2012 and tm=1 and states=1 and track=1 --and gift<1000

--select sum(gift) from gifthist where fy_cash=2012 and states=1 and track=1 --and gift<1000


----Over 1000
--select source, sum(gift) from gifthist where gift>=1000 and track=1
--group by source
--order by source, sum(gift)
--select sum(gift) from gifthist where gift>=1000 and track=1

--select substring(source,1,3), sum(gift) from gifthist where track=1 and fy_cash=2013
--group by substring(source,1,3)
--order by substring(source,1,3)

--select sum(gift) from gifthist where track=1 and fy_cash=2013

--select * from gifthist where fy_cash=2013 and track=1 and states=1 and gift >=10000
--order by gift desc

--select * from gifthist

--alter table gifthist add gift_range varchar(12)

--select  distinct gift_range from gifthist

update gifthist set gift_range = '<$10' where gift between .01 and 9.99  and gift_range is null
update gifthist set gift_range = '$10-14' where gift between 10 and 14.99 and gift_range is null
update gifthist set gift_range = '$15-19' where gift between 15 and 19.99 and gift_range is null
update gifthist set gift_range = '$20-24' where gift between 20 and 24.99 and gift_range is null
update gifthist set gift_range = '$25-49' where gift between 25 and 49.99 and gift_range is null
update gifthist set gift_range = '$50-99' where gift between 50 and 99.99 and gift_range is null
update gifthist set gift_range = '$100-999' where gift between 100 and 999.99 and gift_range is null
update gifthist set gift_range = '$1000+' where gift >= 1000 and gift_range is null

--alter table gifthist add fg_range varchar(12)  
--select  distinct fg_range from gifthist --where fg_range='$100+'
update gifthist set fg_range = '' 

--NOT ALL RECORDS HAVE A FG_AMT (IF BASED ON FIRST TRACKED GIFT)

update gifthist set fg_range = '<$10' where fg_amt < 10 and (fg_range is null OR FG_RANGE = '')
update gifthist set fg_range = '$10-14' where fg_amt between 10 and 14.99 and (fg_range is null OR FG_RANGE = '')
update gifthist set fg_range = '$15-19' where fg_amt between 15 and 19.99 and (fg_range is null OR FG_RANGE = '')
update gifthist set fg_range = '$20-24' where fg_amt between 20 and 24.99 and (fg_range is null OR FG_RANGE = '')
update gifthist set fg_range = '$25-49' where fg_amt between 25 and 49.99 and (fg_range is null OR FG_RANGE = '')
update gifthist set fg_range = '$50-99' where fg_amt between 50 and 99.99 and (fg_range is null OR FG_RANGE = '')
update gifthist set fg_range = '$100-999' where fg_amt between 100 and 999.99 and (fg_range is null OR FG_RANGE = '')
update gifthist set fg_range = '$1000+' where fg_amt >= 1000 and (fg_range is null OR FG_RANGE = '')