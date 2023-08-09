SELECT *
FROM analytics.adyen_payment_log
WHERE event_datetime BETWEEN CURDATE() - INTERVAL 3 MONTH AND CURDATE();


SET @ref_date = DATE(CURDATE()) - INTERVAL 3 MONTH;



SELECT @ref_date;

SELECT MAX(adyen_id)
FROM analytics.adyen_payment_log
WHERE event_datetime BETWEEN @ref_date - INTERVAL 3 MONTH AND @ref_date;

SELECT *
FROM analytics.adyen_payment_log
WHERE event_datetime BETWEEN @ref_date - INTERVAL 3 MONTH AND @ref_date;

SELECT MIN(adyen_id)
FROM analytics.adyen_payment_log
WHERE event_datetime BETWEEN @ref_date - INTERVAL 3 MONTH AND @ref_date;

SET @ref_date = DATE(@ref_date) - INTERVAL 3 MONTH;


--  Australia Insufficient funds on 29th -31st of every month

DROP TEMPORARY TABLE IF EXISTS aus;

CREATE TEMPORARY TABLE aus
SELECT *
FROM analytics.adyen_payment_log
WHERE country_id = 12
	AND DAY(event_datetime) BETWEEN 29 AND 31
	AND success = 'False'
	AND reason_raw = '51 : Insufficient funds/over credit limit';


SELECT COUNT(*)
FROM aus AS a
	JOIN twinkl.twinkl_sub_roller_log AS tsrl
		ON a.sub_id_at_check_out = tsrl.sub_id
		AND DATE(a.event_datetime) = tsrl.old_end_date;

SELECT COUNT(*)
FROM aus;

SELECT COUNT(*)
FROM aus AS a
	JOIN sub_ux_ind_flow AS s
		ON a.sub_id_at_check_out = s.sub_id
		AND DATE(a.event_datetime) = s.end_date;

SELECT COUNT(*)
FROM analytics.adyen_payment_log AS apl
WHERE DATE(event_datetime) = '2022-07-26'
	AND success = 'False';

ALTER TABLE pradnya4
	RENAME conversion_users;