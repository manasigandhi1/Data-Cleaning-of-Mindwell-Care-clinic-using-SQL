# Creating Database
Create database mindwell_care;

# Using database
use mindwell_care;

# Viewing tables
select * from appointments;
select * from patients;

# Changing Incorrect column names
Alter table appointments 
Rename column ï»¿appointment_id to appointment_id;

Alter table patients 
Rename column ï»¿patient_id to patient_id;

Alter table payments 
Rename column ï»¿payment_id to payment_id;

Alter table sessions 
Rename column ï»¿session_id to session_id;

Alter table therapists 
Rename column ï»¿therapist_id to therapist_id;

# Checking if any duplicate entries for appointment_id in appointments table
select appointment_id, count_
From (select appointment_id, count(appointment_id) as count_ 
from appointments
group by appointment_id) as T
where count_ > 1;
-- No duplicate entry found

# Checking if any duplicate entries for patient_id in patients table
SELECT patient_id
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;
-- No duplicate entry found

# Checking if any duplicate entries for payment_id in payments table
select *
From (select payment_id, count(payment_id) as count_ 
from payments
group by payment_id) as T
where count_ > 1;
-- No duplicate entry found

# Checking if any duplicate entries for session_id in sessions table
select *
From (select session_id, count(session_id) as count_ 
from sessions
group by session_id) as T
where count_ > 1;
-- No duplicate entry found

# Checking if any duplicate entries for therapist_id in therapists table
select *
From (select therapist_id, count(therapist_id) as count_ 
from therapists
group by therapist_id) as T;
-- No duplicate entry found

# To check any errors for: Signupdate is later than DOB of patients
select patient_id
from patients
where datediff(signup_date,DOB) < 0;
-- No error found

# Adding age of patient column in patients table
alter table patients
add column age_of_patient int;

Update patients
set age_of_patient = timestampdiff(year,dob,curdate());

select * 
from patients;

# Altering Experience of therapist in therapists table
Alter table therapists 
Drop column experience_years;

Alter table therapists
Add column experience_years int;
-- Adding new column experience years because original entries were incorrect.alter

update therapists
set experience_years = timestampdiff(YEAR,joining_date,curdate());

select * from therapists;

# Check: Each patient is working with same therapist throughout. 
# keep the therapist id of first instance throughout for multiple therapists assigned to a same patient.
select * from appointments;

-- Checking patients with multiple therapists assigned
select patient_id, count_
From (select patient_id, count(distinct therapist_id) as count_
from appointments
group by patient_id) as T
where count_ > 1
order by count_ desc;
-- Total 1152 patients with multiple therapists assigned.

-- Getting an idea about patients with multiple therapists assigned.
select P.patient_id, P.therapist_id, T.count_
from appointments as P
join (select patient_id,  count(distinct therapist_id) as count_
from appointments
group by patient_id) as T
on P.patient_id = T.patient_id
where count_ > 1
order by patient_id, therapist_id;

-- keep the therapist id of first instance throughout for multiple therapists assigned to a same patient.

select patient_id, first_value(therapist_id) over (partition by patient_id order by appointment_date) as therapis_id_new
from appointments;

CREATE TEMPORARY TABLE first_therapist AS
SELECT patient_id,
       SUBSTRING_INDEX(GROUP_CONCAT(therapist_id ORDER BY appointment_date), ',', 1) AS therapist_id
FROM appointments
GROUP BY patient_id;

UPDATE appointments a
JOIN first_therapist t
ON a.patient_id = t.patient_id
SET a.therapist_id = t.therapist_id;


#therapist joining date and client signup date is later than Appointment date 

select appointment_id, A.appointment_date, P.signup_date, T.joining_date
from appointments as A
join therapists as T
on A.therapist_id = T.therapist_id
join patients as P
on A.Patient_id = P.Patient_id
where A.appointment_date < T.joining_date or A.appointment_date < P.signup_date;
-- There are total 2333 rows where dates are invalid.

# Delete the data where date validation error occurs.
Create temporary table Temp as select appointment_id, A.appointment_date, P.signup_date, T.joining_date
from appointments as A
join therapists as T
on A.therapist_id = T.therapist_id
join patients as P
on A.Patient_id = P.Patient_id
where A.appointment_date < T.joining_date or A.appointment_date < P.signup_date;

DELETE A
FROM appointments A
JOIN Temp T ON A.appointment_id = T.appointment_id;

Select * from appointments;
select * from sessions;
select * from payments;

# Therapist wise sessions per day. : Should be 7 max
SELECT therapist_id, appointment_date, COUNT(*) AS count_
FROM appointments
GROUP BY therapist_id, appointment_date
ORDER BY therapist_id, appointment_date, count_ DESC;

-- No record fount with more than one session per day per therapist

# Adding a column : Session Mode - If clients and therapists are not from same city, it is online session, else it was offline session.


alter table appointments
add column session_mode varchar (20);

with Temp_CTE as
(
Select 
	A.Appointment_id, 
    P.City as patient_City,
    T.City as Therapist_City
From Appointments as A
join Patients as P
on A.patient_id = P.Patient_id
join Therapists as T 
on A.therapist_id = T.therapist_id
)
update Appointments as A
join Temp_CTE
on A.appointment_id = Temp_CTE.appointment_id
set session_mode = 
	case
		When patient_City = Therapist_City then "Offline"
	else "Online"
    end;
-- Added a session_mode as online or offline based on cities

# Session timings to be corrected. For any errors: 60 min session to be allocated.

select * from sessions;

update sessions
set duration_min = 60
where Duration_min not in (45, 60, 75);
-- Session timings was corrected.

# For completed and no show sessions, session id should be created. For cancellation, session id should not be there.
-- Completed or no show Appointment ids for which session id is not created.

select distinct Status
From Appointments;

Select A.Appointment_id 
From Appointments as A
left join Sessions as S
on A.Appointment_id = S.Appointment_id
where (A.Status = "Completed" and S.Appointment_id is null) OR (A.Status = "No Show" and S.Appointment_id is null);
-- 473 such rows exists

-- Cancellation appointment ids for which session id is created.
Select A.Appointment_id 
From Appointments as A
left join Sessions as S
on A.Appointment_id = S.Appointment_id
where A.Status = "Cancelled" and S.Appointment_id is not null;
-- 498 such rows exists.alter

-- Deleting session ids where status was cancelled
-- Alter table Sessions
DELETE S
FROM sessions AS S
JOIN appointments AS A
ON S.appointment_id = A.appointment_id
WHERE A.status = 'Cancelled';
-- 498 rows or entries deleted where status was cancelled.

#  Session date is same or later than appointment date. (Not longer than 7 days)

-- Session date is same or later than appointment date.
select Session_id
From Sessions as S
join Appointments as A
on S.Appointment_id = A.Appointment_id
where S.Session_date < A.Appointment_date;
-- There is no discrepancy in dates

select Session_id
From Sessions as S
join Appointments as A
on S.Appointment_id = A.Appointment_id
where datediff(session_date,appointment_date) > 7;
-- All Sessions are conducted within 7 days of appointments.

# Payment id is created for all session ids.
Select S.Session_id
From Sessions as S
left join Payments as P
on S.session_id = P.Session_id
where P.Payment_id is null;
-- There are total 347 sessions where payment id is not created.

# Payment date is equal to or later than session date.
select P.Payment_id
From Payments as P
join sessions as S
on P.session_id = S.session_id
where payment_date < session_date;
-- 723 entries with date validation error.

# For no show, Only 1000 rs session fee is taken.
-- There are no show sessions where session id is not created. we are ignoring those instances.

-- Number of sessions with incorrect amount for no show sessions
select P.payment_id
From payments as P
join Sessions as S
on P.session_id = s.session_id
join appointments as A
on S.appointment_id = A.appointment_id
where A.Status = "No show" and P.Amount <> 1000;
-- 495 entires with incorrect amount entered for no show sessions.

create temporary table temp_ as
select Payment_id 
from Payments as P
join Sessions as S
on P.session_id = s.session_id
join appointments as A
on S.appointment_id = A.appointment_id
where A.Status = "No show" and P.Amount <> 1000;


update payments as P
join temp_ as T
on P.Payment_id = T.payment_id
set P.Amount = 1000;
-- 495 entries updated.

# Sum of all amount for a single completed session id should be 1500.2000 or 2500 only for completed status AND 1000 for Now Show Status.
-- For this we are ignoring the date discrepancy.

Select distinct P.session_id
From (
select session_id, sum(amount) as total_amount
from Payments
group by session_id
) as P
join 
(
select 
	S.session_id,
	case 
	when S.duration_min = 45 and A.Status = "completed" then 1500
	when S.duration_min = 60 and A.Status = "completed" then 2000
	when S.duration_min = 75 and A.Status = "completed" then 2500
    when A.Status = "No show" then 1000
	end as session_fee
From Sessions as S
join Appointments as A
on S.appointment_id = A.appointment_id
) as S
on P.session_id = S.session_id
where P.total_amount <> S.session_fee;
-- 302 entries with wrong fee amount.


# Above Code using CHatGPT
SELECT S.session_id
FROM Sessions S
JOIN Appointments A 
ON S.appointment_id = A.appointment_id
JOIN Payments P 
ON S.session_id = P.session_id
GROUP BY S.session_id, S.duration_min, A.status
HAVING SUM(P.amount) <> 
    CASE 
        WHEN S.duration_min = 45 AND A.status = 'completed' THEN 1500
        WHEN S.duration_min = 60 AND A.status = 'completed' THEN 2000
        WHEN S.duration_min = 75 AND A.status = 'completed' THEN 2500
        WHEN A.status = 'No show' THEN 1000
    END;
    
    
-- Both queries giving same answer.