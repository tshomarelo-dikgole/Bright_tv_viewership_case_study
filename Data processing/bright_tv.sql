-- Checking if data is loaded correctly and we can read it properly
SELECT* 
FROM bright_tv_project.default.bright_tv_user_profile
LIMIT 100;

SELECT* 
FROM bright_tv_project.default.bright_tv_viewership
LIMIT 100;

--Joining tables user and viewer table--
SELECT A.UserID AS UserID_Profile,
       A.Gender,
       A.Race,
       A.Age,
       A.Province,
       B.RecordDate2,
       B.`Duration 2`,
       B.Channel2
FROM bright_tv_project.default.bright_tv_user_profile AS A
RIGHT JOIN bright_tv_project.default.bright_tv_viewership AS B
ON A.UserID = B.UserID;


-----Counting total users--- 10 000
SELECT COUNT (*) AS total_users
FROM bright_tv_project.default.bright_tv_viewership AS B;


SELECT COUNT (*)
FROM bright_tv_project.default.bright_tv_user_profile AS A
RIGHT JOIN bright_tv_project.default.bright_tv_viewership AS B
ON A.UserID = B.UserID;

---Counting total usrs ---5 375
SELECT COUNT (*) AS total_users
FROM bright_tv_project.default.bright_tv_user_profile AS A;

---Checking for Nulls---
SELECT 
   IFNULL(A.UserID, '0') AS UserID,
   IFNULL(A.Gender,'No_Gender') AS Gender,
   IFNULL(A.RACE, 'No_Race') AS Race,
   IFNULL(A.Age, 0) AS Age,
   IFNULL(A.Province, 'No_Province') AS Province,
   IFNULL(B.Channel2, 'No_Channel') AS Channel2,
   IFNULL(B.RecordDate2, 'No_Date') AS RecordDate2
FROM bright_tv_project.default.bright_tv_user_profile AS A
RIGHT JOIN bright_tv_project.default.bright_tv_viewership AS B
ON A.UserID = B.UserID;

---Converting time on joined table--- 
SELECT A.UserID AS UserID_Profile,
       A.Gender,
       A.Race,
       A.Age,
       A.Province,
       B.RecordDate2,
       B.`Duration 2` AS Duration_2,
       B.Channel2,
       FROM_UTC_TIMESTAMP(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS RecordDate_SAST
FROM bright_tv_project.default.bright_tv_user_profile AS A
RIGHT JOIN bright_tv_project.default.bright_tv_viewership AS B
ON A.UserID = B.UserID;


---Checking for toal users per gender---
SELECT Gender, COUNT(*) AS Total_Users
FROM bright_tv_project.default.bright_tv_user_profile 
GROUP BY Gender
ORDER BY Total_Users DESC;

---Checking for total users per race---
SELECT Race, COUNT(*) AS Total_Race
FROM bright_tv_project.default.bright_tv_user_profile 
GROUP BY Race
ORDER BY Total_Race DESC;

---Total users per province---
SELECT Province, COUNT (*) AS Total_province
FROM bright_tv_project.default.bright_tv_user_profile 
GROUP BY Province
ORDER BY Total_province DESC;

--Users joining over time--
SELECT
     year(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS YearJoined,
     month(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS MonthJoined,
     dayofmonth(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS DayJoined,
     hour(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS HourJoined
     FROM bright_tv_project.default.bright_tv_viewership
     GROUP BY year(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')), month(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')), dayofmonth(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')), hour(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'))
     ORDER BY YearJoined, MonthJoined, DayJoined, HourJoined DESC;

---Views by channel--- 
     SELECT Channel2,
          count (*) AS Views,
          round(sum(`Duration 2`)/60,2) AS Total_duration
          FROM bright_tv_project.default.bright_tv_viewership
          GROUP BY Channel2
          ORDER BY Views DESC;

--Views by hours---
  SELECT
      hour(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS HourOfDay,
      count (*) AS Views
      FROM bright_tv_project.default.bright_tv_viewership
      GROUP BY HourOfDay
      ORDER BY HourOfDay DESC;

---Views by gender---
      SELECT A.Gender,
           round(sum(B.`Duration 2`)/60,2) AS Genderwatch_hours
          FROM bright_tv_project.default.bright_tv_user_profile AS A
          JOIN bright_tv_project.default.bright_tv_viewership AS B
          ON A.UserID = B.UserID
          GROUP BY A.Gender
          ORDER BY Genderwatch_hours DESC;

---Getting the days of the week---
SELECT *, 
   dayname(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS DayOfWeek
   FROM bright_tv_project.default.bright_tv_viewership;   

---Getting Months of the year---
SELECT *, 
   monthname(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS MonthofYear
   FROM bright_tv_project.default.bright_tv_viewership;

---Number of view per day---
SELECT dayname(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS DayOfWeek,
      count(*) AS DaysOfWeekViews
      FROM bright_tv_project.default.bright_tv_viewership
      GROUP BY dayname(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'))
      ORDER BY DaysOfWeekViews DESC;

--- duration of Views per day ----
SELECT dayname(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm')) AS DayOfWeek,
      round(sum(`Duration 2`)/60,2) AS DaysOfWeekDuration
      FROM bright_tv_project.default.bright_tv_viewership 
      GROUP BY dayname(TO_TIMESTAMP(RecordDate2, 'yyyy/MM/dd HH:mm'))
      ORDER BY DaysOfWeekDuration DESC;


---Combine functions to get a clean and enhanced sheet ---
SELECT A.UserID AS UserID_Profile,
       A.Gender,
       A.Race,
       A.Age,
       A.Province,
       B.RecordDate2,
       B.`Duration 2` AS Duration_2,
       B.Channel2,
       FROM_UTC_TIMESTAMP(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS RecordDate_SAST,
       hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) AS HourOfDay,
       dayname(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) AS DayOfWeek,
       monthname(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) AS MonthofYear,
       CASE 
           WHEN Dayname(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) IN ('Sun', 'Sat') THEN 'Weekend'
           ELSE 'Weekday'
       END AS Day_classification,
       CASE 
           WHEN A.Age < 18 THEN 'Under_18'
           WHEN A.Age BETWEEN 18 AND 28 THEN 'Youth'
           WHEN A.Age BETWEEN 29 AND 38 THEN 'Young_adult'
           WHEN A.Age BETWEEN 39 AND 48 THEN 'Adults'
           WHEN A.Age BETWEEN 49 AND 58 THEN 'Senior_citizens'
           ELSE 'Pensioners' 
       END AS Age_Group,
       CASE 
           WHEN hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) BETWEEN 0 AND 4 THEN 'Night_Owl'
           WHEN hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) BETWEEN 5 AND 10 THEN 'Morning_views'
           WHEN hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) BETWEEN 11 AND 16 THEN 'Daytime_viewing'
           WHEN hour(TO_TIMESTAMP(B.RecordDate2, 'yyyy/MM/dd HH:mm')) BETWEEN 17 AND 21 THEN 'Family_time'
           ELSE 'Latenight_viewing'
       END AS Time_bucket
FROM bright_tv_project.default.bright_tv_user_profile AS A
JOIN bright_tv_project.default.bright_tv_viewership AS B
ON A.UserID = B.UserID;