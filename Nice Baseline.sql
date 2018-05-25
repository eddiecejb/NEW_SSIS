---- Processing Nice files
 
declare @Process_code varchar(50) ='PROCESS_4'  
declare @year int ='2018'   
    
IF OBJECT_ID('tempdb..#tmp_Member_Batch_Record') IS NOT NULL         
	DROP TABLE #tmp_Member_Batch_Record;     
IF OBJECT_ID('tempdb..#tmp_Record_First_Last') IS NOT NULL         
	DROP TABLE #tmp_Record_First_Last;     
IF OBJECT_ID('tempdb..#tmp_Member_Batch_Record_Final') IS NOT NULL         
	DROP TABLE #tmp_Member_Batch_Record_Final;     
IF OBJECT_ID('tempdb..#tmp_Member_Record_Status') IS NOT NULL         
	DROP TABLE #tmp_Member_Record_Status;     
IF OBJECT_ID('tempdb..#tmp_Member_Batch_Record_Q2') IS NOT NULL         
	DROP TABLE #tmp_Member_Batch_Record_Q2;     
IF OBJECT_ID('tempdb..#tmp_Record_First_Last_Q2') IS NOT NULL         
	DROP TABLE #tmp_Record_First_Last_Q2;    
IF OBJECT_ID('tempdb..#tmp_Member_Record_Status_Q2') IS NOT NULL         
	DROP TABLE #tmp_Member_Record_Status_Q2;     
IF OBJECT_ID('tempdb..#tmp_Member_Batch_Record_Final_Q2') IS NOT NULL         
	DROP TABLE #tmp_Member_Batch_Record_Final_Q2;     
    
CREATE TABLE [#tmp_Member_Batch_Record](    
  [Member_Number] [varchar](100) NULL,    
  [Q1_first_batch] [int] NULL,    
  [Q1_last_batch] [int] NULL,    
  [Q1_first_record] [int] NOT NULL,    
  [Q1_last_record] [int] NOT NULL    
) ON [PRIMARY]    
    
CREATE TABLE [#tmp_Member_Batch_Record_Q2](    
  [Member_Number] [varchar](100) NULL,    
  [Q2_first_batch] [int] NULL,    
  [Q2_last_batch] [int] NULL,    
  [Q2_first_record] [int] NOT NULL,    
  [Q2_last_record] [int] NOT NULL    
) ON [PRIMARY]    
    
CREATE TABLE [#tmp_Record_First_Last](    
  [member_number] [varchar](100) NULL,    
  [batch_id] [int] NULL,    
  [first_record] [int] NULL,    
  [last_record] [int] NULL    
) ON [PRIMARY]    
    
CREATE TABLE [#tmp_Record_First_Last_Q2](    
  [member_number] [varchar](100) NULL,    
  [batch_id] [int] NULL,    
  [first_record] [int] NULL,    
  [last_record] [int] NULL    
) ON [PRIMARY]    
    
CREATE TABLE [dbo].[#tmp_Member_Batch_Record_Final](    
  [Member_Number] [varchar](100) NULL,    
  [Q1_first_batch] [int] NULL,    
  [Q1_last_batch] [int] NULL,    
  [Q1_first_record] [int] NOT NULL,    
  [Q1_last_record] [int] NOT NULL,    
  [First_Batch_Date] [datetime] NULL,    
  [First_Group] [varchar](100) NULL,    
  [First_Effective] [varchar](100) NULL,    
  [First_Term] [varchar](100) NULL,    
  [Last_Batch_Date] [datetime] NULL,    
  [Last_Group] [varchar](100) NULL,    
  [Last_Effective] [varchar](100) NULL,    
  [Last_Term] [varchar](100) NULL    
) ON [PRIMARY]    
    
CREATE TABLE [dbo].[#tmp_Member_Batch_Record_Final_Q2](    
  [Member_Number] [varchar](100) NULL,    
  [Q2_first_batch] [int] NULL,    
  [Q2_last_batch] [int] NULL,    
  [Q2_first_record] [int] NOT NULL,    
  [Q2_last_record] [int] NOT NULL,    
  [First_Batch_Date] [datetime] NULL,    
  [First_Group] [varchar](100) NULL,    
  [First_Effective] [varchar](100) NULL,    
  [First_Term] [varchar](100) NULL,    
  [Last_Batch_Date] [datetime] NULL,    
  [Last_Group] [varchar](100) NULL,    
  [Last_Effective] [varchar](100) NULL,    
  [Last_Term] [varchar](100) NULL    
) ON [PRIMARY]    
    
CREATE TABLE [dbo].[#tmp_Member_Record_Status](    
  [Member_Number] [varchar](100) NULL,    
  [Q1_first_batch] [int] NULL,    
  [Q1_last_batch] [int] NULL,    
  [Q1_first_record] [int] NOT NULL,    
  [Q1_last_record] [int] NOT NULL,    
  [First_Batch_Date] [datetime] NULL,    
  [First_Group] [varchar](100) NULL,    
  [First_Effective] [varchar](100) NULL,    
  [First_Term] [varchar](100) NULL,    
  [Last_Batch_Date] [datetime] NULL,    
  [Last_Group] [varchar](100) NULL,    
  [Last_Effective] [varchar](100) NULL,    
  [Last_Term] [varchar](100) NULL,    
  [Status] [varchar](24) NOT NULL,    
  [Status_1] [varchar](256) NULL    
) ON [PRIMARY]    
      
CREATE TABLE [dbo].[#tmp_Member_Record_Status_Q2](    
  [Member_Number] [varchar](100) NULL,    
  [Q2_first_batch] [int] NULL,    
  [Q2_last_batch] [int] NULL,    
  [Q2_first_record] [int] NOT NULL,    
  [Q2_last_record] [int] NOT NULL,    
  [First_Batch_Date] [datetime] NULL,    
  [First_Group] [varchar](100) NULL,    
  [First_Effective] [varchar](100) NULL,    
  [First_Term] [varchar](100) NULL,    
  [Last_Batch_Date] [datetime] NULL,    
  [Last_Group] [varchar](100) NULL,    
  [Last_Effective] [varchar](100) NULL,    
  [Last_Term] [varchar](100) NULL,    
  [Status] [varchar](24) NOT NULL,    
  [Status_1] [varchar](256) NULL    
) ON [PRIMARY]    
    
create index ix_member_number on #tmp_Member_Batch_Record (member_number)    
create index ix_first_batch on #tmp_Member_Batch_Record (Q1_first_batch)    
create index ix_last_batch on #tmp_Member_Batch_Record (Q1_last_batch)    
create index ix_first_record on #tmp_Member_Batch_Record (Q1_first_record)    
create index ix_last_record on #tmp_Member_Batch_Record (Q1_last_record)    
create index ix_member_number on #tmp_Record_First_Last(member_number)    
create index ix_batch on #tmp_Record_First_Last(batch_id)    
    
create index ix_member_number on #tmp_Member_Batch_Record_Q2 (member_number)    
create index ix_first_batch on #tmp_Member_Batch_Record_Q2 (Q2_first_batch)    
create index ix_last_batch on #tmp_Member_Batch_Record_Q2 (Q2_last_batch)    
create index ix_first_record on #tmp_Member_Batch_Record_Q2 (Q2_first_record)    
create index ix_last_record on #tmp_Member_Batch_Record_Q2 (Q2_last_record)    
create index ix_member_number on #tmp_Record_First_Last_Q2(member_number)    
create index ix_batch on #tmp_Record_First_Last_Q2(batch_id)    
    
declare @Q1firstBatchID int=6582, 
		@Q1lastBatchID int=6597, 
		@Q2FirstBatch int=6598
  
Insert into #tmp_Member_Batch_Record    
select 
	[Member_ID],  
	Q1_first_batch = min(elg.[Download_ID]), 
	Q1_last_batch= max(elg.[Download_ID]), 
	Q1_first_record = 0, 
	Q1_last_record = 0    
from dbo.Download_Members_Temp_Nice elg    
where elg.[Download_ID] between @Q1firstBatchID and @Q1lastBatchID
group by [Member_ID]    
    
Insert into #tmp_Record_First_Last    
select 
	[Member_ID], 
	elg.[Download_ID], 
	first_record = min(record_id), 
	last_record = max(record_id)    
from dbo.Download_Members_Temp_Nice elg
where elg.[Download_ID] between @Q1firstBatchID and @Q1lastBatchID 
group by [Member_ID], elg.[Download_ID]    
    
update t     
	set Q1_first_record = first_record    
from #tmp_Member_Batch_Record t join #tmp_Record_First_Last e1    
on t.Member_Number = e1.Member_Number and t.Q1_first_batch = e1.Batch_ID    
    
update t     
	set Q1_last_record = last_record    
from #tmp_Member_Batch_Record t join #tmp_Record_First_Last e1    
on t.Member_Number = e1.Member_Number and t.Q1_last_batch = e1.Batch_ID    
    
insert into #tmp_Member_Batch_Record_Final    
select     
	t.Member_Number,    
    t.Q1_first_batch,    
    t.Q1_last_batch,    
    t.Q1_first_record,    
    t.Q1_last_record,    
	First_Batch_Date = i1.DT_Start, 
	First_Group = elg_first.[Group_Code], 
	First_Effective = elg_first.[dt_effective], 
	First_Term = elg_first.[dt_term],    
	Last_Batch_Date = i2.DT_Start, 
	Last_Group = elg_last.[Group_Code], 
	Last_Effective = elg_last.[dt_effective], 
	Last_Term = elg_last.[dt_term]    
from #tmp_Member_Batch_Record t     
join [dbo].[Download_Members_Temp_Nice] (nolock) elg_first on t.Q1_first_batch = elg_first.[Download_ID] 
and t.Q1_first_record = elg_first.Record_ID and t.Member_Number <> ''      
join dbo.Import_Batches i1 on elg_first.[Download_ID] = i1.Batch_ID     
left outer join dbo.[Download_Members_Temp_Nice] (nolock) elg_last on     
t.Q1_first_batch<> t.Q1_last_batch     
and t.Q1_last_batch = elg_last.[Download_ID]    
and t.Q1_last_record = elg_last.Record_ID  and t.Member_Number <> ''    
left outer join dbo.Import_Batches i2 on elg_last.[Download_ID] = i2.Batch_ID    
order by t.Member_Number    
    
 insert into #tmp_Member_Record_Status        
 select     
  *,    
  Status = CASE WHEN cast(First_Term as datetime) < '1/1/2018' and 
					 (cast(isnull(Last_Term,'12/31/2017') as datetime) < '1/1/2018' )    
				THEN 'RECORD NOT COVERING 2018'    
				WHEN DATEPART (Month, ISNULL(Last_Batch_Date, First_Batch_Date)) < 3 THEN 'NO RECORD IN MARCH'    
				WHEN Last_Group IS NULL THEN 'ONE RECORD RECEIVED'    
				WHEN First_Group = Last_Group AND First_Effective = Last_Effective and First_Term = Last_Term THEN 'NO CHANGE'    
				WHEN First_Group <> Last_Group THEN 'PLAN CHANGE'    
				WHEN First_Effective <> Last_Effective THEN 'EFFECTIVE DATE CHANGE'    
				WHEN First_Term <> Last_Term THEN 'TERM DATE CHANGE'    
				ELSE 'OTHER' END,    
    Status_1 = CAST('SINGLE RECORD PER MEMBER' AS VARCHAR(256))    
 from #tmp_Member_Batch_Record_Final  
 
 --select * from #tmp_Member_Batch_Record_Final   
 /* *****************************************************************************************************************    
 Start Q2 Processing    
 ***************************************************************************************************************** */    
Insert into #tmp_Member_Batch_Record_Q2    
select 
	[Member_ID],  
	Q2_first_batch = min(elg.[Download_ID]), 
	Q2_last_batch= max(elg.[Download_ID]), 
	Q2_first_record = 0, 
	Q2_last_record = 0    
from [dbo].[Download_Members_Temp_Nice] elg join dbo.Import_Batches ib on elg.[Download_ID] = ib.Batch_ID    
join dbo.Import_Config config on config.Process_ID=ib.Process_ID
where elg.[Download_ID] >= @Q2FirstBatch and config.Process_Code=@Process_code
group by [Member_ID]    
    
Insert into #tmp_Record_First_Last_Q2     
select 
	[Member_ID], 
	elg.[Download_ID], 
	first_record = min(record_id), 
	last_record = max(record_id)    
from dbo.[Download_Members_Temp_Nice] elg
join dbo.Import_Batches ib on ib.Batch_ID=elg.[Download_ID]
join dbo.Import_Config config on config.Process_ID=ib.Process_ID
where elg.[Download_ID] >= @Q2FirstBatch and config.Process_Code=@Process_code
group by [Member_ID], elg.[Download_ID]    
    
update t     
	set Q2_first_record = first_record    
from #tmp_Member_Batch_Record_Q2 t join #tmp_Record_First_Last_Q2 e1    
on t.Member_Number = e1.Member_Number and t.Q2_first_batch = e1.Batch_ID    
    
update t     
	set Q2_last_record = last_record    
from #tmp_Member_Batch_Record_Q2 t join #tmp_Record_First_Last_Q2 e1    
on t.Member_Number = e1.Member_Number and t.Q2_last_batch = e1.Batch_ID    
    
insert into  #tmp_Member_Batch_Record_Final_Q2    
select     
  t.*,    
  First_Batch_Date = i1.DT_Start, 
  First_Group = elg_first.[Group_Code], 
  First_Effective = elg_first.[dt_effective], 
  First_Term = elg_first.[dt_term],    
  Last_Batch_Date = i2.DT_Start, 
  Last_Group = elg_last.[Group_Code], 
  Last_Effective = elg_last.[dt_effective], 
  Last_Term = elg_last.[dt_term]    
from #tmp_Member_Batch_Record_Q2 t     
join dbo.[Download_Members_Temp_Nice] (nolock) elg_first on     
t.Q2_first_batch = elg_first.[Download_ID] and t.Q2_first_record = elg_first.Record_ID and t.Member_Number <> ''      
join dbo.Import_Batches i1 on elg_first.[Download_ID] = i1.Batch_ID     
left outer join dbo.[Download_Members_Temp_Nice] (nolock) elg_last on     
t.Q2_first_batch<> t.Q2_last_batch     
and t.Q2_last_batch = elg_last.[Download_ID]    
and t.Q2_last_record = elg_last.Record_ID  and t.Member_Number <> ''    
left outer join dbo.Import_Batches i2 on elg_last.[Download_ID] = i2.Batch_ID    
    
insert into #tmp_Member_Record_Status_Q2    
select     
	*,    
	Status = CASE WHEN cast(First_Term as datetime) < '1/1/2018' and (cast(isnull(Last_Term,'12/31/2017') as datetime) < '1/1/2018' )    
				  THEN 'RECORD NOT COVERING 2018'    
				  WHEN DATEPART (Month, ISNULL(Last_Batch_Date, First_Batch_Date)) < 3 THEN 'NO RECORD IN MARCH'    
				  WHEN Last_Group IS NULL THEN 'ONE RECORD RECEIVED'    
				  WHEN First_Group = Last_Group AND First_Effective = Last_Effective and First_Term = Last_Term THEN 'NO CHANGE'    
				  WHEN First_Group <> Last_Group THEN 'PLAN CHANGE'    
				  WHEN First_Effective <> Last_Effective THEN 'EFFECTIVE DATE CHANGE'    
				  WHEN First_Term <> Last_Term THEN 'TERM DATE CHANGE'    
				ELSE 'OTHER' END,    
    Status_1 = CAST('SINGLE RECORD PER MEMBER' AS VARCHAR(256))    
from #tmp_Member_Batch_Record_Final_Q2  
      
/* ******************************************************************************************************************************    
	Extracting the results for review    
******************************************************************************************************************************* */    
    
truncate table dbo.Recon_Nice_Clean_Records_Q1_to_Present;    
truncate table dbo.Recon_Nice_Dirty_Records_Q1_to_Present;    
    
	
Insert into dbo.Recon_Nice_Clean_Records_Q1_to_Present
select  
	bpm.plan_code,  
	q1.[Member_Number],    
	q1.[Q1_first_batch],    
	q1.[Q1_last_batch],    
	q1.[Q1_first_record],    
	q1.[Q1_last_record],    
	q1.[First_Batch_Date],    
	q1.[First_Group],    
	convert(datetime,q1.[First_Effective]) as [First_Effective],    
	convert(datetime,q1.[First_Term]) as [First_Term],    
	q1.[Last_Batch_Date],    
	q1.[Last_Group],    
	convert(datetime,q1.[Last_Effective]) as [Last_Effective],    
	convert(datetime,q1.[Last_Term]) as [Last_Term],    
	q1.[Status],    
	q1.[Status_1],
	Q2_First_Batch = q2.Q2_first_batch, 
	Q2_Last_Batch = q2.Q2_last_batch,   
    q2.Q2_first_record, 
	q2.Q2_last_record, 
	q2.First_Batch_Date,
	q2.Last_Batch_Date, 
	q2.First_Group, 
	q2.Last_Group,
	convert(datetime,q2.First_Effective) as First_Effective, 
	convert(datetime,q2.Last_Effective) as Last_Effective,
	convert(datetime,q2.First_Term) as First_Term,   
	convert(datetime,q2.Last_Term) as Last_Term
from #tmp_Member_Record_Status q1     
join OPTUM_OTC_TransactionDB.dbo.Benefit_Plan_Mapping bpm on q1.First_Group = bpm.Eligibility_Benefit_Code     
and getdate() between convert(date,bpm.DT_Effective) and convert(date,bpm.DT_End )   
left outer join #tmp_Member_Record_Status_Q2 q2 on q1.Member_Number = q2.Member_Number    
where q1.Status = 'NO CHANGE' and q2.status= 'NO CHANGE'    
and q1.First_Group = q2.Last_Group    
and q1.First_Effective = q2.Last_Effective    
;    
  
Insert into dbo.Recon_Nice_Dirty_Records_Q1_to_Present    
select  
	bpm.plan_code,  
	q1.[Member_Number],    
	q1.[Q1_first_batch],    
	q1.[Q1_last_batch],    
	q1.[Q1_first_record],    
	q1.[Q1_last_record],    
	q1.[First_Batch_Date],    
	q1.[First_Group],    
	convert(datetime,q1.[First_Effective]) as [First_Effective],    
	convert(datetime,q1.[First_Term]) as [First_Term],    
	q1.[Last_Batch_Date],    
	q1.[Last_Group],    
	convert(datetime,q1.[Last_Effective]) as [Last_Effective],    
	convert(datetime,q1.[Last_Term]) as [Last_Term],  
    q1.[Status],    
	q1.[Status_1],
	Q2_First_Batch = q2.Q2_first_batch, 
	Q2_Last_Batch = q2.Q2_last_batch ,  
	q2.Q2_first_record, 
	q2.Q2_last_record, 
	q2.First_Batch_Date,  
	q2.Last_Batch_Date,
	q2.First_Group, 
    q2.Last_Group,
	q2.First_Effective, 
	q2.Last_Effective,
	q2.First_Term,    
	q2.Last_Term   
from #tmp_Member_Record_Status q1     
join OPTUM_OTC_TransactionDB.dbo.Benefit_Plan_Mapping bpm on q1.First_Group = bpm.Eligibility_Benefit_Code     
and getdate() between bpm.DT_Effective and bpm.DT_End    
join #tmp_Member_Record_Status_Q2 q2 on q1.Member_Number = q2.Member_Number    
Left join dbo.Recon_Nice_Clean_Records_Q1_to_Present ccr (nolock) on q1.member_number = ccr.member_number    
where ccr.member_number is null   
;  

 select count(*) from dbo.Recon_Nice_Clean_Records_Q1_to_Present 
 select count(*) from dbo.Recon_Nice_Dirty_Records_Q1_to_Present 