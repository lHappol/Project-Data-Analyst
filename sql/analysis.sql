-- analysis.sql
-- Aggregate tables created during analysis

-- ===========================
-- agg_data_quality
-- ===========================
-- Table: public.agg_data_quality

-- DROP TABLE IF EXISTS public.agg_data_quality;

CREATE TABLE IF NOT EXISTS public.agg_data_quality
(
    issue text COLLATE pg_catalog."default",
    rows_affected bigint
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_data_quality
    OWNER to postgres;

-- ===========================
-- agg_distance_bins
-- ===========================
-- Table: public.agg_distance_bins

-- DROP TABLE IF EXISTS public.agg_distance_bins;

CREATE TABLE IF NOT EXISTS public.agg_distance_bins
(
    distance_bin text COLLATE pg_catalog."default",
    trips bigint,
    avg_fare double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_distance_bins
    OWNER to postgres;

-- ===========================
-- agg_hour_day
-- ===========================
-- Table: public.agg_hour_day

-- DROP TABLE IF EXISTS public.agg_hour_day;

CREATE TABLE IF NOT EXISTS public.agg_hour_day
(
    hour integer,
    day_of_week integer,
    day_name text COLLATE pg_catalog."default",
    trips bigint,
    day_order integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_hour_day
    OWNER to postgres;

-- ===========================
-- agg_hourly
-- ===========================
-- Table: public.agg_hourly

-- DROP TABLE IF EXISTS public.agg_hourly;

CREATE TABLE IF NOT EXISTS public.agg_hourly
(
    hour integer,
    trips bigint,
    avg_fare double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_hourly
    OWNER to postgres;

-- ===========================
-- agg_monthly
-- ===========================
-- Table: public.agg_monthly

-- DROP TABLE IF EXISTS public.agg_monthly;

CREATE TABLE IF NOT EXISTS public.agg_monthly
(
    month timestamp without time zone,
    trips bigint,
    revenue double precision,
    avg_fare double precision,
    avg_distance double precision,
    avg_duration_min numeric
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_monthly
    OWNER to postgres;

-- ===========================
-- agg_passenger_bin
-- ===========================
-- Table: public.agg_passenger_bin

-- DROP TABLE IF EXISTS public.agg_passenger_bin;

CREATE TABLE IF NOT EXISTS public.agg_passenger_bin
(
    passenger_count double precision,
    trips bigint,
    avg_fare double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_passenger_bin
    OWNER to postgres;

-- ===========================
-- agg_payment
-- ===========================
-- Table: public.agg_payment

-- DROP TABLE IF EXISTS public.agg_payment;

CREATE TABLE IF NOT EXISTS public.agg_payment
(
    payment_type double precision,
    trips bigint,
    revenue double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_payment
    OWNER to postgres;

-- ===========================
-- agg_top_zones
-- ===========================
-- Table: public.agg_top_zones

-- DROP TABLE IF EXISTS public.agg_top_zones;

CREATE TABLE IF NOT EXISTS public.agg_top_zones
(
    location_id double precision,
    pickups bigint
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_top_zones
    OWNER to postgres;

-- ===========================
-- agg_weekday
-- ===========================
-- Table: public.agg_weekday

-- DROP TABLE IF EXISTS public.agg_weekday;

CREATE TABLE IF NOT EXISTS public.agg_weekday
(
    day_of_week integer,
    trips bigint
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agg_weekday
    OWNER to postgres;

-- ==========================================
-- DATA CLEANING VIEW & AGGREGATION QUERIES
-- ==========================================

-- Clean Layer View (Filter invalid records)
CREATE OR REPLACE VIEW public.yellow_taxi_clean AS
SELECT *
FROM public.yellow_taxi
WHERE trip_distance > 0 AND trip_distance <= 100
  AND passenger_count BETWEEN 1 AND 6
  AND fare_amount > 0 AND total_amount > 0
  AND tpep_dropoff_datetime > tpep_pickup_datetime;

-- 1. Populate agg_data_quality
INSERT INTO public.agg_data_quality (issue, rows_affected)
SELECT 'Zero or Negative Distance', COUNT(*) FROM public.yellow_taxi WHERE trip_distance <= 0
UNION ALL
SELECT 'Invalid Passenger Count (<=0 or >6)', COUNT(*) FROM public.yellow_taxi WHERE passenger_count <= 0 OR passenger_count > 6
UNION ALL
SELECT 'Zero or Negative Fare Amount', COUNT(*) FROM public.yellow_taxi WHERE fare_amount <= 0;

-- 2. Populate agg_distance_bins
INSERT INTO public.agg_distance_bins (distance_bin, trips, avg_fare)
SELECT 
    CASE 
        WHEN trip_distance <= 1 THEN '0-1 mi'
        WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1-3 mi'
        WHEN trip_distance > 3 AND trip_distance <= 5 THEN '3-5 mi'
        WHEN trip_distance > 5 AND trip_distance <= 10 THEN '5-10 mi'
        ELSE '10+ mi'
    END AS distance_bin,
    COUNT(*) AS trips,
    AVG(fare_amount) AS avg_fare
FROM public.yellow_taxi_clean
GROUP BY 1;

-- 3. Populate agg_hour_day (For Heatmap)
INSERT INTO public.agg_hour_day (hour, day_of_week, day_name, trips, day_order)
SELECT 
    EXTRACT(HOUR FROM tpep_pickup_datetime)::INT AS hour,
    EXTRACT(DOW FROM tpep_pickup_datetime)::INT AS day_of_week,
    TO_CHAR(tpep_pickup_datetime, 'Dy') AS day_name,
    COUNT(*) AS trips,
    EXTRACT(ISODOW FROM tpep_pickup_datetime)::INT AS day_order
FROM public.yellow_taxi_clean
GROUP BY 1, 2, 3, 5;

-- 4. Populate agg_hourly
INSERT INTO public.agg_hourly (hour, trips, avg_fare)
SELECT 
    EXTRACT(HOUR FROM tpep_pickup_datetime)::INT AS hour,
    COUNT(*) AS trips,
    AVG(fare_amount) AS avg_fare
FROM public.yellow_taxi_clean
GROUP BY 1;

-- 5. Populate agg_monthly
INSERT INTO public.agg_monthly (month, trips, revenue, avg_fare, avg_distance, avg_duration_min)
SELECT 
    DATE_TRUNC('month', tpep_pickup_datetime) AS month,
    COUNT(*) AS trips,
    SUM(total_amount) AS revenue,
    AVG(fare_amount) AS avg_fare,
    AVG(trip_distance) AS avg_distance,
    AVG(EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 60)::NUMERIC AS avg_duration_min
FROM public.yellow_taxi_clean
GROUP BY 1;

-- 6. Populate agg_passenger_bin
INSERT INTO public.agg_passenger_bin (passenger_count, trips, avg_fare)
SELECT 
    passenger_count,
    COUNT(*) AS trips,
    AVG(fare_amount) AS avg_fare
FROM public.yellow_taxi_clean
GROUP BY 1;

-- 7. Populate agg_payment
INSERT INTO public.agg_payment (payment_type, trips, revenue)
SELECT 
    payment_type,
    COUNT(*) AS trips,
    SUM(total_amount) AS revenue
FROM public.yellow_taxi_clean
GROUP BY 1;

-- 8. Populate agg_top_zones
INSERT INTO public.agg_top_zones (location_id, pickups)
SELECT 
    "PULocationID" AS location_id,
    COUNT(*) AS pickups
FROM public.yellow_taxi_clean
GROUP BY 1;

-- 9. Populate agg_weekday
INSERT INTO public.agg_weekday (day_of_week, trips)
SELECT 
    EXTRACT(DOW FROM tpep_pickup_datetime)::INT AS day_of_week,
    COUNT(*) AS trips
FROM public.yellow_taxi_clean
GROUP BY 1;
