IF OBJECT_ID('tempdb..#temp_recon') IS NOT NULL         
	DROP TABLE #temp_recon; 
	
IF OBJECT_ID('tempdb..#temp_recon_full') IS NOT NULL         
	DROP TABLE #temp_recon_full;    

IF OBJECT_ID('tempdb..#temp_Active') IS NOT NULL         
	DROP TABLE #temp_Active;	

IF OBJECT_ID('tempdb..#temp_members_elg') IS NOT NULL         
	DROP TABLE #temp_members_elg;		  

CREATE TABLE [dbo].[#temp_recon](
	[Member_ID] [int] NULL,
	[Subscriber_ID] [varchar](15) NULL,
	[Q1_Benefit] [varchar](10) NULL,
	[Q2_Benefit] [varchar](10) NULL,
	[Q1_Benefit_Cap] [money] NOT NULL,
	[Q1_Rollover] [decimal](3, 2) NOT NULL,
	[Q2_Benefit_Cap] [money] NOT NULL,
	[Q1_Order_Total] [money] NOT NULL,
	[Q1_Member_Payments] [decimal](38, 2) NOT NULL,
	[Q1_Adjustments] [money] NOT NULL,
	[Q1_Order_Shipped_In_Q2] [money] NOT NULL,
	[Attribute_Order_To] [int] NOT NULL,
	[Q1_Effective_Total] [money] NOT NULL,
	[Q1_Rollover_Amt] [decimal](38, 2) NULL,
	[Q2_Order_Total] [money] NOT NULL,
	[Q2_Member_Payments] [decimal](38, 2) NOT NULL,
	[Q2_Adjustments] [money] NOT NULL,
	[Q2_Effective_Total] [money] NULL,
	[Pending_Orders] [money] NOT NULL,
	[Hold_orders] [money] NOT NULL,
	[CurrentBalance] [numeric](10, 2) NULL,
	[PlanChange] [int] NOT NULL,
	[Q1_Benefit_Cap_Calc] [money] NOT NULL,
	[Q2_Benefit_Cap_Calc] [money] NOT NULL
) ON [PRIMARY]
;

CREATE TABLE [dbo].[#temp_recon_full](
	[Member_ID] [int] NULL,
	[Subscriber_ID] [varchar](15) NULL,
	[Q1_Benefit] [varchar](10) NULL,
	[Q2_Benefit] [varchar](10) NULL,
	[Q1_Benefit_Cap] [money] NOT NULL,
	[Q1_Rollover] [decimal](3, 2) NOT NULL,
	[Q2_Benefit_Cap] [money] NOT NULL,
	[Q1_Order_Total] [money] NOT NULL,
	[Q1_Member_Payments] [decimal](38, 2) NOT NULL,
	[Q1_Adjustments] [money] NOT NULL,
	[Q1_Order_Shipped_In_Q2] [money] NOT NULL,
	[Attribute_Order_To] [int] NOT NULL,
	[Q1_Effective_Total] [money] NOT NULL,
	[Q1_Rollover_Amt] [decimal](38, 2) NULL,
	[Q2_Order_Total] [money] NOT NULL,
	[Q2_Member_Payments] [decimal](38, 2) NOT NULL,
	[Q2_Adjustments] [money] NOT NULL,
	[Q2_Effective_Total] [money] NULL,
	[Pending_Orders] [money] NOT NULL,
	[Hold_orders] [money] NOT NULL,
	[CurrentBalance] [numeric](10, 2) NULL,
	[PlanChange] [int] NOT NULL,
	[Q1_Benefit_Cap_Calc] [money] NOT NULL,
	[Q2_Benefit_Cap_Calc] [money] NOT NULL,
	[CalculatedBalance] [decimal](38, 2) NULL,
	[Exposure] [numeric](38, 2) NULL,
	[Potential_Issue] [varchar](26) NOT NULL
) ON [PRIMARY]
;

--This Table will be used later to remove any other inactive members
	
select 
	m.member_Id, 
	benop_value into #temp_Active
from OPTUM_OTC_TransactionDB.dbo.members m (nolock) join OPTUM_OTC_TransactionDB.dbo.Member_Benefit_Events mbe (nolock) 
on m.member_id = mbe.member_id and GETDATE() between mbe.DT_Effective and mbe.DT_End   
and mbe.DT_Updated = (select MAX(dt_updated) from OPTUM_OTC_TransactionDB.dbo.Member_Benefit_Events mbe2 
					  where mbe2.Member_ID = m.Member_ID and   
					  GETDATE() between DT_Effective and DT_End+1)   
and Benop_Value <> '000'
join OPTUM_OTC_TransactionDB.dbo.benefit_plans bp on bp.Plan_Code= mbe.Benop_Value and getdate() between bp.DT_Effective and bp.DT_End
and isnull(bp.card_config,0)=0
;

--Q1 6582	6597	
--Q2 6598	6612

select 
	Member_Number as Subscriber_ID, 
	m.Member_ID,  
	bp1.Plan_Code as Q1_plan,
	bp1.Benefit_Cap as Q1_Cap, 
	Last_Effective as Q1_effective, 
	Last_Term as Q1_term,
	Q2_First_Effective, 
	Q2_First_Term,
	bp2.Plan_Code Q2_Plan, 
	bp2.Benefit_Cap Q2_cap,
	DBO.fn_GetMemberCreditBalance(m.Member_ID, bp2.Benefit_Cap, '04/01/2018', '06/30/2018') CurrentBalance 
	into #temp_members_elg
from [OPTUM_OTC_TransactionDB-Hotfix].dbo.Recon_Nice_Dirty_Records_Q1_to_Present (nolock) p
join [OPTUM_OTC_TransactionDB].dbo.Benefit_Plan_Mapping bpm_q1 on bpm_q1.Eligibility_Benefit_Code=Last_Group and 
getdate() between bpm_q1.DT_Effective and bpm_q1.DT_End
join OPTUM_OTC_TransactionDB.dbo.benefit_plans bp1 on bp1.Plan_Code=bpm_q1.Plan_Code 
and getdate() between bp1.DT_Effective and bp1.DT_End
join OPTUM_OTC_TransactionDB.dbo.members(NOLOCK) m on CASE WHEN bp1.Plan_Code='H2226-001' THEN p.Member_Number+'M' 
ELSE p.Member_Number END = m.external_member_id 
join #temp_Active A on A.member_Id = M.Member_ID
join OPTUM_OTC_TransactionDB.dbo.Benefit_Plan_Mapping bpm_q2Last on bpm_q2Last.Eligibility_Benefit_Code=Q2_First_Group and 
getdate() between bpm_q2Last.DT_Effective and bpm_q2Last.DT_End
join OPTUM_OTC_TransactionDB.dbo.benefit_plans bp2 on bp2.Plan_Code=bpm_q2Last.Plan_Code 
and getdate() between bp2.DT_Effective and bp2.DT_End
	
insert into #temp_recon
select 
	t.Member_ID, 
	t.Subscriber_ID,
	t.Q1_plan,
	t.Q2_Plan,
	Q1_Benefit_Cap = bp1.Benefit_Cap, 
	Q1_Rollover = bp1.rollover_percent, 
	Q2_Benefit_Cap = bp2.Benefit_Cap,
	Q1_Order_Total = ISNULL(Q1_Order_Total,0), 
	Q1_Member_Payments = ISNULL(Q1_Member_Payments,0),
	Q1_Adjustments = ISNULL(Q1_Adjustments, 0), 
	Q1_Order_Shipped_In_Q2 = ISNULL(Q1_Order_Shipped_In_Q2,0),
	Attribute_Order_To = CASE WHEN ISNULL(Q1_Order_Total,0) >0 THEN 2 ELSE 1 END,
	Q1_Effective_Total = CASE WHEN ISNULL(Q1_Order_Total,0) >0 
								   THEN ISNULL(Q1_Order_Total,0) 
								   ELSE ISNULL(Q1_Order_Shipped_In_Q2,0) 
						 END,

	Q1_Rollover_Amt	=CASE WHEN bp1.rollover_percent = 0 THEN 0 
						  WHEN ISNULL(Q2_First_Effective,'') ='' THEN 0
						  WHEN cast(Q1_effective as datetime) > '03/31/2018' THEN 0
						  WHEN cast(Q2_First_Effective as datetime) > '04/01/2018' THEN 0
						  ELSE
								CASE WHEN ISNULL(Q1_Benefit_Cap_Calc,0) >0 ANd ISNULL(Q1_Benefit_Cap_Calc,0) > bp1.Benefit_Cap
										  THEN Q1_Benefit_Cap_Calc 
									 ELSE  bp1.Benefit_Cap END 
								+ ISNULL(Q1_Member_Payments, 0 ) + ISNULL(Q1_Adjustments, 0 ) - CASE WHEN ISNULL(Q1_Order_Total,0) >0 THEN ISNULL(Q1_Order_Total,0) ELSE ISNULL(Q1_Order_Shipped_In_Q2,0) END 
					 END,

	Q2_Order_Total = ISNULL(Q2_Order_Total , 0),
	Q2_Member_Payments = ISNULL(Q2_Member_Payments, 0),
	Q2_Adjustments = ISNULL(Q2_Adjustments, 0),
	Q2_Effective_Total = CASE WHEN ISNULL(Q1_Order_Total,0) = 0 AND ISNULL(Q1_Order_Shipped_In_Q2,0) > 0 
								THEN ISNULL(Q2_Order_Total,0) - ISNULL(Q1_Order_Shipped_In_Q2,0)  
							  ELSE ISNULL(Q2_Order_Total,0) END,
	Pending_Orders = ISNULL(Pending_Orders,0),
	Hold_orders = ISNULL(Hold_orders,0),
	t.CurrentBalance as CurrentBalance,
	PlanChange = CASE WHEN Q1_plan = Q2_Plan THEN 0 ELSE 1 END,
	Q1_Benefit_Cap_Calc = ISNULL(Q1_Benefit_Cap_Calc,0),
	Q2_Benefit_Cap_Calc = ISNULL(Q2_Benefit_Cap_Calc,0)
from #temp_members_elg t
join [OPTUM_OTC_TransactionDB].dbo.Benefit_Plans bp1 (nolock) on  t.Q1_plan  = bp1.Plan_Code and getdate() between bp1.dt_effective and bp1.dt_end
join [OPTUM_OTC_TransactionDB].dbo.Benefit_Plans bp2 (nolock) on  t.Q2_Plan  = bp2.Plan_Code and getdate() between bp2.dt_effective and bp2.dt_end

outer apply ( select sum(Total_Item_Cost) Q1_Order_Total 
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				where o.Member_ID=t.Member_ID and datepart(q, o.DT_Print)=1  and dt_order >= '1/1/2018'
			) Q1_Orders

outer apply ( select sum(Total_Item_Cost) Q1_Order_Shipped_In_Q2 
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				where o.Member_ID=t.Member_ID and datepart(q, o.DT_order)=1 and datepart(q, o.DT_Print)=2  and dt_order >= '1/1/2018'
			) Q1_Orders_In_Q2

outer apply ( select sum(Amount_Due) Q1_Member_Payments  
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				where o.Member_ID=t.Member_ID and datepart(q, o.DT_Print)=1 and dt_order >= '1/1/2018'
				and Payment_Method is not null 
			) Q1_PBM

outer apply ( select sum(Total_Item_Cost) Q2_Order_Total 
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				where o.Member_ID=t.Member_ID and datepart(q, o.DT_Print)=2 and dt_order >= '1/1/2018'
			) Q2_Orders
outer apply ( select sum(Amount_Due) Q2_Member_Payments 
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				where o.Member_ID=t.Member_ID and datepart(q, o.DT_Print)=2 and dt_order >= '1/1/2018'
				and Payment_Method is not null 
			) Q2_PBM

outer apply ( select sum(extra_amount) Q1_Adjustments 
				from [OPTUM_OTC_TransactionDB].dbo.Order_Extra_Benefit oe (nolock) 
				where oe.Member_ID= t.Member_ID and oe.DT_Effective between '1/1/2018' and '03/31/2018 23:59:59'
				and oe.Credit_Type <> 'Rollover'
			) Q1_Extra

outer apply ( select sum(extra_amount) Q2_Adjustments 
				from [OPTUM_OTC_TransactionDB].dbo.Order_Extra_Benefit oe (nolock) 
				where oe.Member_ID= t.Member_ID and oe.DT_Effective between '4/1/2018' and '06/30/2018 23:59:59'
				and oe.Credit_Type <> 'Rollover'
			) Q2_Extra

outer apply ( select sum(Total_Item_Cost) Pending_Orders 
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				where o.Member_ID=t.Member_ID and order_Status in('PENDING_EXPORT')
					and datepart(Q,o.dt_order) = datepart(Q,getdate())
			) Pending_Orders

outer apply ( select sum(Total_Item_Cost) Hold_orders 
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				where o.Member_ID=t.Member_ID and order_Status in('HOLD','PAYMENT_EXPORT','EDITING')
				and datepart(Q,o.dt_order) = datepart(Q,getdate())
			) Hold_orders

/* ******************************************************************************
Adding In The Benefit Cap first Qu
****************************************************************************** */
outer apply (select Max(c.Benefit_Cap) Q1_Benefit_Cap_Calc
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				Join [OPTUM_OTC_TransactionDB].dbo.member_benefit_events b (nolock) on o.Benefit_Event_Id = b.Benefit_Event_Id
				join [OPTUM_OTC_TransactionDB].dbo.benefit_plans c (nolock) on c.Plan_Code = b.Benop_Value and getdate() between c.dt_effective and c.dt_end    --and getdate() between c.dt_effective and c.dt_end  
				Where o.Member_ID=t.Member_ID and datepart(q, o.DT_order)=1 and dt_order >= '1/1/2018' and getdate() between c.dt_effective and c.dt_end  
				Group by c.Benefit_Cap
			) Q1_Benefit_Cap_Calc
/* ******************************************************************************
Adding In The Benefit Cap Second Qu
****************************************************************************** */
outer apply (select Max(c.Benefit_Cap) Q2_Benefit_Cap_Calc
				from [OPTUM_OTC_TransactionDB].dbo.orders o (nolock) 
				Join [OPTUM_OTC_TransactionDB].dbo.member_benefit_events b (nolock) on o.Benefit_Event_Id = b.Benefit_Event_Id
				join [OPTUM_OTC_TransactionDB].dbo.benefit_plans c (nolock) on c.Plan_Code = b.Benop_Value and getdate() between c.dt_effective and c.dt_end
				Where o.Member_ID=t.Member_ID and datepart(q, o.DT_order)=2 and dt_order >= '1/1/2018' and getdate() between c.dt_effective and c.dt_end  
				Group by c.Benefit_Cap
			) Q2_Benefit_Cap_Calc


insert into #temp_recon_full
select 
	*,
	CalculatedBalance = (Q2_Benefit_Cap + CASE WHEN Q1_Rollover = 1 THEN Q1_Rollover_Amt ELSE 0 END + Q2_Member_Payments + Q2_Adjustments - Q2_Effective_Total - Pending_Orders-Hold_orders),
	Exposure = CurrentBalance - (Q2_Benefit_Cap + CASE WHEN Q1_Rollover = 1 THEN Q1_Rollover_Amt ELSE 0 END + Q2_Member_Payments + Q2_Adjustments - Q2_Effective_Total - Pending_Orders),
	Potential_Issue = CASE WHEN CurrentBalance - (Q2_Benefit_Cap + CASE WHEN  Q1_Rollover = 1 THEN Q1_Rollover_Amt ELSE 0 END + Q2_Member_Payments + Q2_Adjustments - Q2_Effective_Total - Pending_Orders - Hold_orders) = 0 THEN 'NO ISSUES'
						   ELSE CASE WHEN (Q2_Benefit_Cap + CASE WHEN Q1_Rollover = 1 THEN Q1_Rollover_Amt ELSE 0 END + Q2_Member_Payments + Q2_Adjustments - Q2_Effective_Total - Pending_Orders - Hold_orders) = 0  OR CAST(CurrentBalance AS NUMERIC(10,2)) = 0 THEN 'OTHER' 
									 ELSE CASE WHEN Q1_Benefit <> '000' AND Q2_Benefit <> '000' 
													AND  CAST((Q2_Benefit_Cap + CASE WHEN Q1_Rollover = 1 THEN Q1_Rollover_Amt ELSE 0 END + Q2_Member_Payments + Q2_Adjustments - Q2_Effective_Total - Pending_Orders - Hold_orders) AS NUMERIC(10,2)) / CAST(CurrentBalance AS NUMERIC(10,2)) = 2.00 THEN 'POTENTIAL AUTO TERMINATION'											
											   WHEN Q1_Benefit = '000' AND Q2_Benefit <> '000' THEN 'POTENTIAL Q1 BENEFIT ISSUE'				
											   ELSE 'OTHER' 
										  END
								END
					  END 
from #temp_Recon;


Delete From [OPTUM_OTC_TransactionDB-Hotfix].dbo.Recon_Nice_Result_COMPLEX
--Down Here Put the Select into your final Table.
--example
INSERT INTO [OPTUM_OTC_TransactionDB-Hotfix].dbo.Recon_Nice_Result_COMPLEX
SELECT * From #temp_recon_full

drop table #temp_Active
drop table #temp_members_elg
drop table #temp_recon
drop table #temp_recon_full
Select 'Script Complete!'
