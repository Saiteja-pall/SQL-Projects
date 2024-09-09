
select * from [dbo].[Bank_loan_data]

--total no.of applicatins
select count(id) as total_applicatins from [dbo].[Bank_loan_data]  

--total no.of applications for recent month
select count(id) as mtd_total_appilactions from [dbo].[Bank_loan_data]
where MONTH(issue_date) = 12 and YEAR(issue_date)=2021

--total no.of applications for before month
select count(id) as pmtd_total_applcations from [dbo].[Bank_loan_data]
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021

--total loan amount released
select SUM(loan_amount) as total_amout from [dbo].[Bank_loan_data]

--total loan amount released for recent month
select SUM(loan_amount) as mtd_total_amount from [dbo].[Bank_loan_data]
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021

--total loan amount released before month
select SUM(loan_amount) as pmtd_total_amount from [dbo].[Bank_loan_data]
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021

--total amont payed to bank
select SUM(total_payment) as total_amount_payed from [dbo].[Bank_loan_data]

--total amount payed in recent month
select SUM(total_payment) as mtd_total_amount_payed from [dbo].[Bank_loan_data]
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021

--total amount payed for before months
select SUM(total_payment) as pmtd_total_amount_payed from [dbo].[Bank_loan_data]
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021

--average interest rate
select cast(AVG(int_rate)*100 as decimal(18,2)) as avg_interest_rate from [dbo].[Bank_loan_data]

--average interest rate for recent month
select cast(AVG(int_rate)*100 as decimal(18,2)) as mtd_avg_interest_rate from [dbo].[Bank_loan_data]
where MONTH(issue_date)=12 and YEAR(issue_date)=2021

--average interest rate for before month
select cast(AVG(int_rate)*100 as decimal(18,2)) as pmtd_avg_interest_rate from [dbo].[Bank_loan_data]
where MONTH(issue_date)=11 and YEAR(issue_date)=2021

--average percentage of financial status i.e., dti( debit_to_income)
select cast(AVG(dti)*100 as decimal(18,2)) as avg_dti from [dbo].[Bank_loan_data]

--average percentage of financial status i.e., dti( debit_to_income) for recent month
select cast(AVG(dti)*100 as decimal(18,2)) as mtd_avg_dti from [dbo].[Bank_loan_data]
where MONTH(issue_date)=12 and YEAR(issue_date)=2021


--average percentage of financial status i.e., dti( debit_to_income) for before month
select CAST(avg(dti)*100 as decimal(18,2)) as pmtd_avg_dti from [dbo].[Bank_loan_data]
where MONTH(issue_date)=11 and YEAR(issue_date)=2021

--good loan percentage
select 
    CAST( count(case when loan_status='Fully Paid' or loan_status='current' then id
	 end)*100.0/count(id) as decimal(18,2)) as good_loan_percentage from [dbo].[Bank_loan_data]

--good loan applications
select COUNT(id) as good_loan_applications from [dbo].[Bank_loan_data]
where loan_status='Fully Paid' or loan_status='current'

--good loan released amount
select SUM(loan_amount) as good_loan_amount_released from [dbo].[Bank_loan_data]
where loan_status='Fully Paid' or loan_status='current'

--good loan amount recieved
select SUM(total_payment) as good_loan_amount_payed from [dbo].[Bank_loan_data]
where loan_status='Fully Paid' or loan_status='current'

--bad loan percentages
select
      cast(count(case when loan_status= 'charged off' then id
	 end)*100.0/count(id) as decimal(18,2)) as bad_loan_percentage from [dbo].[Bank_loan_data]

--bad laon applications
select count(id) as bad_loan_applications from [dbo].[Bank_loan_data]
where loan_status='charged off'

--bad loan released amount
select SUM(loan_amount) as bad_loan_amount_released from [dbo].[Bank_loan_data]
where  loan_status='charged off'

--bad loan amount payed
select SUM(total_payment) as bad_loan_amount_payed from [dbo].[Bank_loan_data]
where  loan_status='charged off'

--loan status
select 
       loan_status,
       COUNT(id)as total_applications,
	   SUM(loan_amount) as loan_amouunt_released,
	   SUM(total_payment) as loan_amount_payed,
	   cast(AVG(int_rate)*100 as decimal(18,2)) as per_interest_rate,
	   cast(avg(dti)*100 as decimal(18,2)) as per_dti
from [dbo].[Bank_loan_data]
group by loan_status

--loan stats for recent month
select
      loan_status,
	  SUM(loan_amount) as mtd_loan_amount_released,
	  sum(total_payment) as mtd_laon_amount_payed
from [dbo].[Bank_loan_data]
where MONTH(issue_date)=12 and YEAR(issue_date)=2021
group by loan_status

--bank loan oerview
select
      MONTH(issue_date) as month_num,
	  datename(month ,issue_date) as month_name,
	  count(id) as total_applications,
	  sum(loan_amount) as loan_amount_released,
	  sum(total_payment) as loan_amount_payed
from [dbo].[Bank_loan_data]
group by MONTH(issue_date),datename(month ,issue_date)
order by 1

--state wise loan overview
select address_state as sate,
       count(id) as total_applications,
	   sum(loan_amount) as laon_amount_released,
	   sum(total_payment) as loan_amount_payed
from [dbo].[Bank_loan_data]
group by address_state
order by address_state

--term wise overview
select 
      term as term,
	  count(id) as total_applications,
	  sum(loan_amount) as loan_amount_released,
	  sum(total_payment) as loan_amount_payed
from [dbo].[Bank_loan_data]
group by term
order by term

--emp length wise overview
select 
      emp_length as employee_length,
	  count(id) as total_applications,
	  sum(loan_amount) as loan_amount_released,
	  sum(total_payment) as loan_amount_payed
from [dbo].[Bank_loan_data]
group by emp_length
order by emp_length

--purpose wise overview
select 
      purpose as reason,
	  count(id) as total_applications,
	  sum(loan_amount) as loan_amount_released,
	  sum(total_payment) as loan_amount_payed
from [dbo].[Bank_loan_data]
group by purpose
order by purpose

--home ownership wise overview
select 
      home_ownership as home_owner,
	  count(id) as total_applications,
	  sum(loan_amount) as loan_amount_released,
	  sum(total_payment) as loan_amount_payed
from [dbo].[Bank_loan_data]
group by home_ownership
order by home_ownership