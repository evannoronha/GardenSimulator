
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE TYPE public.listing_type AS ENUM (
    'seeds',
    'crops'
);


CREATE SEQUENCE public.crops_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';


CREATE TABLE public.crops_inventory (
    user_id integer NOT NULL,
    crop_id integer NOT NULL,
    quantity integer NOT NULL,
    crops_inventory_id integer DEFAULT nextval('public.crops_inventory_id_seq'::regclass) NOT NULL
);



CREATE SEQUENCE public.crops_inventory_crops_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.grow_boxes (
    user_id integer NOT NULL,
    plant_id integer,
    location integer,
    day_planted integer,
    box_uuid text DEFAULT uuid_in((md5(((random())::text || (clock_timestamp())::text)))::cstring) NOT NULL
);


CREATE SEQUENCE public.grow_boxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE public.has_seeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.has_seeds (
    user_id integer NOT NULL,
    seed_id integer NOT NULL,
    quantity integer NOT NULL,
    seed_inventory_id integer DEFAULT nextval('public.has_seeds_id_seq'::regclass) NOT NULL
);


CREATE SEQUENCE public.has_seeds_seed_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE public.market_listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE public.market_listings (
    listing_id integer DEFAULT nextval('public.market_listings_id_seq'::regclass) NOT NULL,
    seller_id integer NOT NULL,
    plant_id integer NOT NULL,
    price real,
    quantity integer,
    listing_type text DEFAULT 'crops'::text NOT NULL,
    CONSTRAINT market_listings_price_check CHECK ((price > (0)::double precision)),
    CONSTRAINT market_listings_quantity_check CHECK ((quantity > 0))
);


CREATE SEQUENCE public.market_listings_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE public.plant_species_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.plant_species (
    species_id integer DEFAULT nextval('public.plant_species_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    lifespan_type text NOT NULL,
    harvest_quantity integer,
    plant_image_url text,
    days_to_harvest integer DEFAULT 5 NOT NULL,
    points_for_eating integer DEFAULT 1 NOT NULL
);


CREATE SEQUENCE public.plant_species_species_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.users (
    user_id integer NOT NULL,
    login text NOT NULL,
    password text NOT NULL,
    cash real NOT NULL,
    farm_age integer NOT NULL,
    garden_size integer NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    CONSTRAINT users_cash_check CHECK ((cash > (0)::double precision)),
    CONSTRAINT users_farm_age_check CHECK ((farm_age >= 0)),
    CONSTRAINT users_garden_size_check CHECK ((garden_size >= 0)),
    CONSTRAINT users_score_check CHECK ((score >= 0))
);


CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.watering_events (
    event_id integer NOT NULL,
    box_id text NOT NULL,
    user_day integer NOT NULL
);


CREATE SEQUENCE public.watering_events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_id_seq'::regclass);


ALTER TABLE ONLY public.watering_events ALTER COLUMN event_id SET DEFAULT nextval('public.watering_events_event_id_seq'::regclass);


ALTER TABLE ONLY public.crops_inventory
    ADD CONSTRAINT crops_inventory_pkey PRIMARY KEY (crops_inventory_id);


ALTER TABLE ONLY public.grow_boxes
    ADD CONSTRAINT grow_boxes_pkey PRIMARY KEY (box_uuid);


ALTER TABLE ONLY public.has_seeds
    ADD CONSTRAINT has_seeds_pkey PRIMARY KEY (seed_inventory_id);


ALTER TABLE ONLY public.market_listings
    ADD CONSTRAINT market_listings_pkey PRIMARY KEY (listing_id);


ALTER TABLE ONLY public.plant_species
    ADD CONSTRAINT plant_species_pkey PRIMARY KEY (species_id);


ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


ALTER TABLE ONLY public.watering_events
    ADD CONSTRAINT watering_events_pkey PRIMARY KEY (event_id);


ALTER TABLE ONLY public.crops_inventory
    ADD CONSTRAINT crops_inventory_crop_id_fkey FOREIGN KEY (crop_id) REFERENCES public.plant_species(species_id);


ALTER TABLE ONLY public.crops_inventory
    ADD CONSTRAINT crops_inventory_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


ALTER TABLE ONLY public.grow_boxes
    ADD CONSTRAINT grow_boxes_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant_species(species_id);


ALTER TABLE ONLY public.grow_boxes
    ADD CONSTRAINT grow_boxes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


ALTER TABLE ONLY public.has_seeds
    ADD CONSTRAINT has_seeds_seed_id_fkey FOREIGN KEY (seed_id) REFERENCES public.plant_species(species_id);


ALTER TABLE ONLY public.has_seeds
    ADD CONSTRAINT has_seeds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


ALTER TABLE ONLY public.market_listings
    ADD CONSTRAINT market_listings_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant_species(species_id);


ALTER TABLE ONLY public.market_listings
    ADD CONSTRAINT market_listings_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(user_id);


ALTER TABLE ONLY public.watering_events
    ADD CONSTRAINT watering_events_box_id_fkey FOREIGN KEY (box_id) REFERENCES public.grow_boxes(box_uuid);

