-- Member with no current balace- can ignore
UPDATE S
	SET S.Potential_Issue='NO-ACTION REQUIRED MEMBER BALANCE ZERO CALCULATED NEGATIVE'
 --select * 
from [OPTUM_OTC_TransactionDB-Hotfix].[dbo].[Recon_Nice_Result_COMPLEX] S
where potential_issue='OTHER'
and currentBalance=0
and calculatedBalance <0

----------------------------------------------

-- Might have payment Peding- Spot check
UPDATE S
SET S.Potential_Issue='SPOT-CHECK PAYMENT PENDING NOT INCLUDED'
--select * 
from [OPTUM_OTC_TransactionDB-Hotfix].dbo.[Recon_Nice_Result_COMPLEX] S
where potential_issue='OTHER'
and currentBalance=0
and calculatedBalance > 0

---------------------------------------------

-- Require Research 
update S
SET S.Potential_Issue='RESEARCH REQUIRED-POTENTIAL NEGATIVE ADJUSTMENT NEEDED'
--select * 
from [OPTUM_OTC_TransactionDB-Hotfix].dbo.[Recon_Nice_Result_COMPLEX] S
where potential_issue='OTHER'
and currentBalance > 0
and calculatedBalance = 0

------------------------------------------------

--- No Action Required- Already Adjusted

--update s
--set s.Potential_Issue='NO-ACTION ALREADY ADJUSTED'
----select *
--from [OPTUM_OTC_TransactionDB-Hotfix].dbo.[Recon_Nice_Result_COMPLEX] S
--where potential_issue='OTHER'
--and Q2_adjustments < 0

--and currentBalance > 0
--and calculatedBalance > 0

------------------------------------------------

-- Member was present in Q1 with Q2 effective date, OTC system has given credits
UPDATE S
	SET Potential_Issue='CLIENT CONFIRMATION REQUIRED- Q1 Members with Q2 Effective date'
--select *
from [OPTUM_OTC_TransactionDB-Hotfix].dbo.Recon_Nice_Result_COMPLEX S
join [OPTUM_OTC_TransactionDB-Hotfix].[dbo].[Recon_Nice_Dirty_Records_Q1_to_Present] P
on P.Member_Number=S.subscriber_Id 
where potential_issue='OTHER'
and Q2_adjustments = 0
and currentBalance > 0
and calculatedBalance > 0
and Q1_rollover=1
and Q1_rollover_amt=0
and cast(last_effective as datetime) > '03/31/2018'

-------------------------------------------------------

update S 
	SET S.Potential_Issue='RESEARCH REQUIRED-POTENTIAL ROLLOVER'
--select *
from [OPTUM_OTC_TransactionDB-Hotfix].dbo.Recon_Nice_Result_COMPLEX S
join [OPTUM_OTC_TransactionDB-Hotfix].dbo.[Recon_Nice_Dirty_Records_Q1_to_Present] P
on P.Member_Number=S.subscriber_Id 
where potential_issue='OTHER'
and 
Q2_adjustments = 0
and currentBalance > 0
and calculatedBalance > 0
and not (Q1_rollover=1
and Q1_rollover_amt=0
and cast(last_effective as datetime) > '03/31/2018')