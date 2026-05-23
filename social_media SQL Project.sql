create database Social_Media_Usage;
use Social_Media_Usage;
show tables;
select * from social_media_user_behavior;

-- Rename Table 
rename table social_media_user_behavior to social_media_user;

-- Rename column name posts_per_week
alter table social_media_user
rename column posts_per_week to posts_per_day;

-- View Table Structure 
describe social_media_user; 

-- View all records
select * from social_media_user;

-- Q1.Count total users
select count(*) as total_users from social_media_user;

-- Q2.List all unique social media platforms.
select distinct primary_platform from social_media_user
group by primary_platform;

-- Q3. How many users are on each platform?
select primary_platform, count(*) as user_account
from social_media_user
group by primary_platform;

-- Q4.Find the top 10 users who spend the most time daily.
SELECT user_id, primary_platform, daily_usage_hours
FROM social_media_user
ORDER BY daily_usage_hours DESC
LIMIT 10;

-- Q5.What are the average engagement metrics per platform?
SELECT primary_platform,
    round(AVG(avg_session_duration_min)) as avg_daily_minutes,
    round(AVG(posts_per_day)) as avg_posts,
    round(AVG(likes_given_per_day)) as avg_likes,
    round(AVG(followers_count)) as avg_follows
from social_media_user
group by primary_platform
ORDER BY avg_daily_minutes DESC;
select * from social_media_user;

-- Q6.Most active platform by total posts
select primary_platform, sum(posts_per_day) as Total_Posts
from social_media_user
group by primary_platform
order by Total_Posts;

-- Q7: Which Platform have highest average followers
SELECT primary_platform, ROUND(AVG(followers_count), 2) AS avg_followers
FROM social_media_user
GROUP BY primary_platform
ORDER BY avg_followers DESC
LIMIT 1;

-- Q8: Categorize users by daily usage level
select user_id, primary_platform, avg_session_duration_min,
    case
        when avg_session_duration_min < 60  then 'Light User'
        when avg_session_duration_min < 180 then 'Moderate User'
        When avg_session_duration_min < 360 then 'Heavy User'
        else 'Addicted User'
    end as usage_category
from social_media_user
order by avg_session_duration_min desc;

-- Q9.Rank each platform by user count, avg time, avg likes
SELECT primary_platform,
    COUNT(*) AS users,
    RANK() OVER (ORDER BY AVG(avg_session_duration_min) DESC) AS time_rank,
    RANK() OVER (ORDER BY AVG(likes_given_per_day) DESC) AS likes_rank,
    RANK() OVER (ORDER BY AVG(posts_per_day) DESC) AS posts_rank
FROM social_media_user
GROUP BY primary_platform;

-- Q10.Country-Wise Average Followers Count
SELECT country,
       ROUND(AVG(followers_count),0) AS avg_followers
FROM social_media_user
GROUP BY country
ORDER BY avg_followers DESC;

-- Q11.Find countries having more than 100 users.
SELECT country, COUNT(*) AS total_users
FROM social_media_user
GROUP BY country
HAVING COUNT(*) > 100;

-- Q12.Find average screen time by country.
SELECT country,
       round(AVG(daily_usage_hours),2) AS avg_usage
FROM social_media_user
GROUP BY country;

-- Q13.Count users by gender.
SELECT gender, COUNT(*) AS total_users
FROM social_media_user
GROUP BY gender;

-- Q14.Find users whose followers count is above average.
SELECT user_id, followers_count
FROM social_media_user
WHERE followers_count >
(
    SELECT AVG(followers_count)
    FROM social_media_user
);

-- Q15.Find second highest followers count.
SELECT MAX(followers_count) AS second_highest
FROM social_media_user
WHERE followers_count <
(
    SELECT MAX(followers_count)
    FROM social_media_user
);