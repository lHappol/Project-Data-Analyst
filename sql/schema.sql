-- Table: public.yellow_taxi

-- DROP TABLE IF EXISTS public.yellow_taxi;

CREATE TABLE IF NOT EXISTS public.yellow_taxi
(
    index bigint,
    "VendorID" double precision,
    tpep_pickup_datetime timestamp without time zone,
    tpep_dropoff_datetime timestamp without time zone,
    passenger_count double precision,
    trip_distance double precision,
    "RatecodeID" double precision,
    store_and_fwd_flag text COLLATE pg_catalog."default",
    "PULocationID" double precision,
    "DOLocationID" double precision,
    payment_type double precision,
    fare_amount double precision,
    extra double precision,
    mta_tax double precision,
    tip_amount double precision,
    tolls_amount double precision,
    improvement_surcharge double precision,
    total_amount double precision,
    congestion_surcharge double precision,
    airport_fee double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.yellow_taxi
    OWNER to postgres;
-- Index: idx_yellow_do

-- DROP INDEX IF EXISTS public.idx_yellow_do;

CREATE INDEX IF NOT EXISTS idx_yellow_do
    ON public.yellow_taxi USING btree
    ("DOLocationID" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_yellow_pickup

-- DROP INDEX IF EXISTS public.idx_yellow_pickup;

CREATE INDEX IF NOT EXISTS idx_yellow_pickup
    ON public.yellow_taxi USING btree
    (tpep_pickup_datetime ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_yellow_pu

-- DROP INDEX IF EXISTS public.idx_yellow_pu;

CREATE INDEX IF NOT EXISTS idx_yellow_pu
    ON public.yellow_taxi USING btree
    ("PULocationID" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: ix_yellow_taxi_index

-- DROP INDEX IF EXISTS public.ix_yellow_taxi_index;

CREATE INDEX IF NOT EXISTS ix_yellow_taxi_index
    ON public.yellow_taxi USING btree
    (index ASC NULLS LAST)
    TABLESPACE pg_default;
