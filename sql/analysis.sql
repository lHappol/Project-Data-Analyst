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
