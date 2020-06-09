--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.19
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: listing_type; Type: TYPE; Schema: public; Owner: team1
--

CREATE TYPE public.listing_type AS ENUM (
    'seeds',
    'crops'
);


ALTER TYPE public.listing_type OWNER TO team1;

--
-- Name: crops_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.crops_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crops_inventory_id_seq OWNER TO team1;

SET default_tablespace = '';

--
-- Name: crops_inventory; Type: TABLE; Schema: public; Owner: team1
--

CREATE TABLE public.crops_inventory (
    user_id integer NOT NULL,
    crop_id integer NOT NULL,
    quantity integer NOT NULL,
    crops_inventory_id integer DEFAULT nextval('public.crops_inventory_id_seq'::regclass) NOT NULL
);


ALTER TABLE public.crops_inventory OWNER TO team1;

--
-- Name: crops_inventory_crops_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.crops_inventory_crops_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crops_inventory_crops_inventory_id_seq OWNER TO team1;

--
-- Name: crops_inventory_crops_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: team1
--

ALTER SEQUENCE public.crops_inventory_crops_inventory_id_seq OWNED BY public.crops_inventory.crops_inventory_id;


--
-- Name: grow_boxes; Type: TABLE; Schema: public; Owner: team1
--

CREATE TABLE public.grow_boxes (
    user_id integer NOT NULL,
    plant_id integer NOT NULL,
    location integer,
    day_planted integer,
    box_uuid text DEFAULT uuid_in((md5(((random())::text || (clock_timestamp())::text)))::cstring) NOT NULL
);


ALTER TABLE public.grow_boxes OWNER TO team1;

--
-- Name: grow_boxes_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.grow_boxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grow_boxes_id_seq OWNER TO team1;

--
-- Name: has_seeds_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.has_seeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.has_seeds_id_seq OWNER TO team1;

--
-- Name: has_seeds; Type: TABLE; Schema: public; Owner: team1
--

CREATE TABLE public.has_seeds (
    user_id integer NOT NULL,
    seed_id integer NOT NULL,
    quantity integer NOT NULL,
    seed_inventory_id integer DEFAULT nextval('public.has_seeds_id_seq'::regclass) NOT NULL
);


ALTER TABLE public.has_seeds OWNER TO team1;

--
-- Name: has_seeds_seed_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.has_seeds_seed_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.has_seeds_seed_inventory_id_seq OWNER TO team1;

--
-- Name: has_seeds_seed_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: team1
--

ALTER SEQUENCE public.has_seeds_seed_inventory_id_seq OWNED BY public.has_seeds.seed_inventory_id;


--
-- Name: market_listings_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.market_listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.market_listings_id_seq OWNER TO team1;

--
-- Name: market_listings; Type: TABLE; Schema: public; Owner: team1
--

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


ALTER TABLE public.market_listings OWNER TO team1;

--
-- Name: market_listings_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.market_listings_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.market_listings_listing_id_seq OWNER TO team1;

--
-- Name: market_listings_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: team1
--

ALTER SEQUENCE public.market_listings_listing_id_seq OWNED BY public.market_listings.listing_id;


--
-- Name: plant_species_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.plant_species_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plant_species_id_seq OWNER TO team1;

--
-- Name: plant_species; Type: TABLE; Schema: public; Owner: team1
--

CREATE TABLE public.plant_species (
    species_id integer DEFAULT nextval('public.plant_species_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    lifespan_type text NOT NULL,
    harvest_quantity integer,
    plant_image_url text,
    days_to_harvest integer DEFAULT 5 NOT NULL,
    points_for_eating integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.plant_species OWNER TO team1;

--
-- Name: plant_species_species_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.plant_species_species_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plant_species_species_id_seq OWNER TO team1;

--
-- Name: plant_species_species_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: team1
--

ALTER SEQUENCE public.plant_species_species_id_seq OWNED BY public.plant_species.species_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: team1
--

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


ALTER TABLE public.users OWNER TO team1;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO team1;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: team1
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.user_id;


--
-- Name: watering_events; Type: TABLE; Schema: public; Owner: team1
--

CREATE TABLE public.watering_events (
    event_id integer NOT NULL,
    box_id text NOT NULL,
    user_day integer NOT NULL
);


ALTER TABLE public.watering_events OWNER TO team1;

--
-- Name: watering_events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: team1
--

CREATE SEQUENCE public.watering_events_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.watering_events_event_id_seq OWNER TO team1;

--
-- Name: watering_events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: team1
--

ALTER SEQUENCE public.watering_events_event_id_seq OWNED BY public.watering_events.event_id;


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: watering_events event_id; Type: DEFAULT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.watering_events ALTER COLUMN event_id SET DEFAULT nextval('public.watering_events_event_id_seq'::regclass);


--
-- Data for Name: crops_inventory; Type: TABLE DATA; Schema: public; Owner: team1
--

INSERT INTO public.crops_inventory (user_id, crop_id, quantity, crops_inventory_id) VALUES (35, 11, 6, 1);
INSERT INTO public.crops_inventory (user_id, crop_id, quantity, crops_inventory_id) VALUES (40, 11, 4, 4);
INSERT INTO public.crops_inventory (user_id, crop_id, quantity, crops_inventory_id) VALUES (36, 11, 3, 2);


--
-- Data for Name: grow_boxes; Type: TABLE DATA; Schema: public; Owner: team1
--

INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 1, NULL, '909263de-31c6-1652-3db9-1d0ff69dd3b5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 2, NULL, 'c99e5f23-d95f-75da-b5e0-3d94bf17101b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 3, NULL, '4d1711f0-deee-fdbd-4a0b-63748c6185a0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 4, NULL, 'a3405486-4cb5-4d36-f503-a6d6aec2a83d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 5, NULL, 'fac5fb56-0929-993a-7498-86c3ede35ca1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 6, NULL, '8635a05f-0c24-3976-4922-a9191ba0beef');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 7, NULL, '9ab2e491-7e48-7c0b-3892-d627a162dd86');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 8, NULL, '2565bd24-6044-f364-f3b0-0c56007d96dc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 9, NULL, 'a5fd879a-756b-274d-3d72-7bb9ebccf204');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 10, NULL, 'e0f1e171-c894-572c-e00e-cb2d256e5628');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 11, NULL, 'a3be7912-dc51-1491-ea44-fd198343da7a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 12, NULL, '7d734d6f-074f-915e-f4b0-0242b388f789');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 13, NULL, '603ab880-6597-e6ca-2322-4c0aaa32b01e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 14, NULL, '0b4ade09-d7c4-a300-56f7-37093d23ef58');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 15, NULL, '244bccc6-1794-4cd4-9cf8-641f6aa0cb52');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 16, NULL, 'a5c9cae5-04e1-884d-2aca-935db64ee37d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 17, NULL, 'fda62bbb-dcc9-b65e-88d1-8d6beb600c9c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 18, NULL, '208baaaf-4fb7-1a91-f5d5-d317e051b902');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 19, NULL, 'eeea25d6-2291-ba34-d92e-2182e1a53e99');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 20, NULL, 'f7632163-a436-8341-87a5-4c3c7cafa44d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 21, NULL, 'bb6ad7c0-fc26-0d2b-572b-80398d3b071e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 22, NULL, '082591ed-e1fb-fadc-1140-4a09de3e564d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 23, NULL, 'e4ad0c15-bf0b-3caf-b235-a78a52d2dacf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 24, NULL, 'd432411e-51f7-b50d-8755-a722edbd2a84');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (31, 0, 25, NULL, '9206cad6-7648-f6fc-84e5-864e4745fd70');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 1, NULL, '458ed65f-6afc-6d9d-6b26-a5b07120fe7e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 2, NULL, '2940074b-9298-0b4b-1692-33f8be4d5caf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 3, NULL, '2c54d78d-018c-eaac-5530-01b26618bfca');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 4, NULL, '49b0616c-ee91-ba6a-32c8-f93b675ce20b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 5, NULL, '1cc09eba-9ac5-249d-348c-42eb32c86205');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 6, NULL, '5dcc6561-b880-9321-7f08-e6fd061683de');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 7, NULL, '1f7c32bc-094a-7b09-6961-ffe9df569979');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 8, NULL, '9dfe4cf6-085f-1540-dee2-e125403db3ea');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 9, NULL, '11d7fce0-6f0a-9c02-2b8d-29c9af984e86');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 10, NULL, '854c1743-1473-af3f-4a78-e34035cd1a85');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 11, NULL, '3dd1d24c-1feb-9424-4f54-80f237103488');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 12, NULL, 'a2cab44f-a00f-d6b7-e864-83838e2cd65f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 13, NULL, '82ea84de-fb08-375c-4a96-eff873bc5bcc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 14, NULL, 'e8723505-ad9a-2bb6-d6f8-18fc3020511a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 15, NULL, 'ec395a6f-13bb-bb5b-67de-b58ab0991d72');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 16, NULL, 'ac6944ab-1d6d-43f3-4962-474daa306b2c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 17, NULL, '2268b0b7-ab3a-f918-c92b-c2f58ae12acb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 18, NULL, 'aabbdb13-ef65-0ea7-786a-e4641f2a5afb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 19, NULL, 'a097123b-8897-90ba-cd19-feb9f915481b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 20, NULL, '7da68a41-bd7b-1ee2-66ab-97cd266e03d5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 21, NULL, 'b7a06cc8-3e18-4130-28e6-eafe8b97514f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 22, NULL, 'e81585f0-04fa-9181-2e34-19a1bd40f258');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 23, NULL, '83e2b6a2-3e9e-4ed9-82f7-503bac30fa38');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 24, NULL, '50eae125-59a1-c150-4df6-146d2234309d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (32, 0, 25, NULL, 'e882ed55-204b-c88b-6c4e-37447190f1f6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 1, NULL, '69ae5e94-0449-132a-3e51-129b81fe5039');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 2, NULL, '46401f85-f1bf-8192-9d27-cc9445ba9029');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 3, NULL, '78de314f-643a-b022-d4b4-d8e417140f12');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 4, NULL, 'a16593f8-33e3-85a7-d6ef-3fd15f58525a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 5, NULL, '456077c2-81d8-198c-e9fb-77ffe66ccdc5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 6, NULL, '9292208e-9c16-274e-6571-3f290ac313d8');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 7, NULL, '2ac0c5a4-1706-be9a-4f6a-686cc1ce24a3');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 8, NULL, '48c229e1-e5da-ea14-d127-efcb1672bf74');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 9, NULL, 'cfcb3d31-9bf7-1d70-4561-35d0df582b39');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 10, NULL, 'ad5003ae-1f08-d008-9e40-082ee43a9c7e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 11, NULL, '5b85bb2b-7902-8936-9e02-758db14306db');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 12, NULL, '0ed1bc3d-3b45-0227-7b31-c2e29b594995');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 13, NULL, 'fed50fae-c296-8940-6a43-c4c15c76e66b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 14, NULL, 'a9c166ff-c869-e824-73c2-15cdaa06d678');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 15, NULL, 'faf2315a-e542-5ebc-be35-bc2bf02c9292');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 16, NULL, 'f57c5a95-50ba-e8ff-40d4-1f62aadf4b3c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 17, NULL, '4aa09222-c8c9-0ef2-75eb-9c6bd8919fca');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 18, NULL, 'b71d5737-0510-075e-5c98-5b570f208675');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 19, NULL, '5af5fbf0-32de-5968-7775-1544665d3871');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 20, NULL, 'cba22293-8879-3a64-f371-7cd733fa018a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 21, NULL, '8613a89f-3bdd-14c3-7fa1-4393f59bdcdc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 22, NULL, 'a2a2ca22-cc9a-ef97-68e0-5aed5a247519');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 23, NULL, 'e8686057-a8dc-f321-f771-1fab781628a6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 24, NULL, '8d15eca3-5d28-3c0f-18db-1df4f99f4462');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (33, 0, 25, NULL, '0b1b40fc-fa09-cd21-2615-86712ef01776');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 1, NULL, '771628de-3db6-7106-4ef9-fea0bcf2ca23');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 2, NULL, 'e25d5664-8246-c528-0372-8154061a6a8a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 3, NULL, 'f08dadbb-de22-d4e9-73e7-d2f8fb1122c1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 4, NULL, 'b792ad94-2446-9822-9e68-d0d3080a3db4');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 1, NULL, '290f3612-70dd-2ea1-e57f-b5c2ee24c170');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 2, NULL, '7d26d8fc-f38a-007b-11e9-8282f1e3a6c8');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 3, NULL, 'f62ee5df-4456-f927-bfd2-307aec74594f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 4, NULL, '510c4d0c-a163-99ea-d6b4-5dc4d300beaf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 5, NULL, '09b3b177-b936-1808-8d6d-868063485367');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 6, NULL, 'a5556b79-23f9-b379-5821-207bf4b8a2d2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 7, NULL, 'd03fac1f-9f91-c3bb-577e-16e8ce3e6f6e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 8, NULL, 'c3ca78d5-9c5d-8df5-3d9d-3b736396edcc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 9, NULL, '9fe00e17-d1a6-f73c-f476-5f526ed5521c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 10, NULL, '6b79df2a-c66f-c73d-51dc-f53395e98496');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 11, NULL, '76f33549-4ca0-1112-add2-1ca0a43ae76c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 12, NULL, '0c8ffbda-ec80-8956-e533-4075fcaa55fd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 13, NULL, 'f38fc047-f587-5475-7b69-c3da10ee21dc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 14, NULL, 'd3bf6936-a251-19b4-e85c-0a6fc33c507c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 15, NULL, 'c32e254d-eee8-0e5c-2d88-3fa2958b15af');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 16, NULL, 'c37af7e7-c6b1-93c6-2ac0-bc7f380798fd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 17, NULL, '80102afa-38f2-c389-8069-5239332d7c9f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 18, NULL, 'ab6f2a6e-ddf3-a82b-2526-e2241abdcdde');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 19, NULL, '9f6ba702-5a39-59a0-f09e-cdf8d416f61c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 20, NULL, '9d3e72be-6e1d-c4e0-5307-0d3030542140');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 21, NULL, '4e66ae88-deda-4299-2f24-7fb48c787cb6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 22, NULL, '01518854-72e4-60e0-d6de-e87641dfb6ca');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 23, NULL, 'ed277e27-9273-6ca4-e5da-232b7d3e3b1e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 24, NULL, '4ede52da-a531-3271-199a-65974e75580e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (30, 0, 25, NULL, '865cea01-83e3-f48e-7196-183edcf2e83c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 5, NULL, '6d87f38a-1d19-c70c-4b04-926f0ef34eb2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 6, NULL, 'bb90e141-d732-d80a-8c85-094e8a52d5df');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 7, NULL, '49d1cf43-ff2c-ecc9-54ca-8f96c3f4d949');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 8, NULL, 'e319c92b-0588-7473-983a-c489200be047');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 9, NULL, '6b6cb01c-ed79-b357-3787-5870b3146855');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 10, NULL, '9c302a75-f1d3-ccfe-ff27-5a9076e7fe19');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 11, NULL, '7655b714-50bd-22e9-a254-8d1b8770c701');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 12, NULL, '4851f22b-1805-6175-d4b3-b21e4bb19393');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 13, NULL, '8983bb2a-63aa-3765-80c0-30c313c4c70a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 14, NULL, '9343b951-3f49-3580-824e-e9013ce80fb2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 15, NULL, 'd2ea3c7c-02e2-0a8c-2068-7b0473560eb7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 16, NULL, '329eaf05-dd57-b9c1-491f-d82c03a8c3fb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 17, NULL, '966b7a2b-45e1-01c5-63a4-3a866367142c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 18, NULL, 'e2df6a10-775a-8a28-45c3-10a56b2e052c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 19, NULL, '0c610a25-71a4-58ab-8acb-9ef03aecbba5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 20, NULL, 'd4d0af82-ca34-4ec8-453f-32d9adb49a43');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 21, NULL, '29d907db-9623-a188-9674-70116b83641d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 22, NULL, 'e185370a-0004-9835-3eb6-21906f2b4eb7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 23, NULL, '606b7924-bcdd-c4b6-f1c3-ccdff9ef6b04');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 24, NULL, '47ed4e29-7a35-2526-b858-92a7370eb914');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (34, 0, 25, NULL, '68fcc2f4-541b-b5ca-96ec-f2624ac5d88e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 5, NULL, 'd2135b22-240e-d7a4-3c55-e9e06262ce00');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 6, NULL, 'c4db26cf-fa50-c4c0-5369-69d1edc8d709');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 7, NULL, '5b550d32-975c-0fc8-2b40-aff60b84ea7d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 8, NULL, 'be3f6496-7a32-18e7-266d-57fecc15d063');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 9, NULL, 'fdddc17c-6608-b4cf-d82a-61b5126d15ac');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 10, NULL, '95934de1-0d97-a775-a863-62469b2cc597');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 11, NULL, '039d00dc-ff14-881f-0efd-9c6bf44430c6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 12, NULL, 'b1399bd1-55f2-1d6b-d04d-704a756d9d50');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 13, NULL, '4e3ec5ee-8485-8704-f769-62ddd1bc8686');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 14, NULL, '340ffe51-e357-01ef-9dc1-c92b7b3c3d64');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 15, NULL, '157a90b8-a1f5-b9a3-4704-3fd0be94455f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 16, NULL, 'f01154ab-98d6-bd41-ef1c-9d397fcf20dc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 17, NULL, 'bf79b3d1-15db-0931-a332-bd7ecc40e422');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 18, NULL, '043efabe-5d12-2273-22de-2091a0279291');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 19, NULL, 'ca6b5258-b9d7-3bfd-66e4-4ec289282382');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 20, NULL, 'a39c69bd-9c60-24f2-00e9-1a3a397d7f1b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 21, NULL, '5fe9220d-d5f5-6a40-e979-35d87484a286');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 22, NULL, 'eef42b81-5481-8de5-d381-f389f9778218');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 23, NULL, 'e0dd8d88-b652-5b97-cd89-064f971c4c28');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 24, NULL, 'b5f014fc-1dbd-3ea5-0002-378e9e072a94');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 0, 25, NULL, '37b5f714-7446-28c6-27cf-58a6c47e8cfb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 5, 1, NULL, 'ed6e5722-45b6-643d-255e-926297db5416');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 6, 2, NULL, 'b34d4328-64f2-3447-6f92-1bac71b61c79');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 5, 3, NULL, '23bd2160-982a-8e88-2bfb-82ab86009ed2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (35, 6, 4, NULL, '1c9cf9f6-44d5-d021-b37f-ba2b4c480ed1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 1, NULL, '3a1b6e6d-2ae8-83c9-a519-1c4bc644e47c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 2, NULL, '1467cff1-b365-80e1-8d2a-35dc13a8ddfd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 3, NULL, 'fcc0f908-214b-a37c-0923-171c6aed859b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 4, NULL, 'fbc981e5-6953-8373-b48b-c8d499328cb2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 5, NULL, 'f93416f4-3c80-9db8-a758-ce3b1830f2fa');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 6, NULL, '604b6a69-308a-5857-5be9-c985fce4868b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 7, NULL, 'c0bf946f-2063-8670-4c56-5dd97aa4c504');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 8, NULL, 'eb1b1073-7034-309b-5370-5945944151a3');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 9, NULL, '35bbb6ba-380c-7cfc-859b-68ee3f1382b1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 10, NULL, '9b821fec-b3d6-fc9d-edd0-2a1651985d48');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 11, NULL, '49840138-0e8d-a3f9-15b0-88df4734a971');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 12, NULL, 'f6dd895c-4529-d726-0913-ffd36d81b2cd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 13, NULL, 'ef091663-30f6-7ac9-0b17-4d2e661bb391');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 14, NULL, 'a7160ee3-32c0-2da4-c8b3-e40163f16719');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 15, NULL, '4e567798-1294-67ef-1a33-e36ef01ec07e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 16, NULL, '24737cd9-0815-1a4f-53ff-c1887a94751d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 17, NULL, 'e0a16b87-bbd3-9647-006d-40f421dd7c29');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 18, NULL, '053d4f7b-5aa5-117b-760d-1a70a352084e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 19, NULL, '1ef31018-1db9-15d8-3a0b-d3fd875af68e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 20, NULL, '5a58d01b-dc43-b56b-9c5a-e00335dcce83');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 21, NULL, 'eb73d19c-5ea3-a6c0-b469-e50ce8f4aa37');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 22, NULL, '723b57f5-99d6-acdc-3bc5-187ee4e810fc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 23, NULL, 'c0a8780a-edb6-a932-071a-a6cd9460d9c5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 24, NULL, 'cd46cc30-5c16-40a6-e399-da472b5be81b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (36, 0, 25, NULL, '84790cf5-117c-9631-2851-ba35c06c9e29');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 1, NULL, '2e2ae6bf-c324-48ec-b743-bd4f5bfefcdf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 2, NULL, '0518fd0f-3e56-f4d4-b31c-44f5d0d1f398');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 3, NULL, '9226e429-e2bb-69a3-727f-69aedd57fa72');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 4, NULL, '6209f119-1dc5-add9-6760-17c374e80b35');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 5, NULL, 'e928e689-dbd3-841f-d7c3-095489b86830');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 6, NULL, '1842fe95-fd7d-2fba-d6d8-2b794471e936');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 7, NULL, '4ebbde83-1246-866a-2340-61e692c0f30b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 8, NULL, '7cdaf048-e2e3-239a-9e17-4678cf6db925');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 9, NULL, '1bec11c8-8ba5-67a7-3e78-cd659ba6083c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 10, NULL, 'd5434d91-61f6-10fe-de57-171c37890339');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 11, NULL, '68f78691-ec6e-6ba5-393c-99fdf74ff9d0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 12, NULL, 'fa971f43-e74a-ae2a-163f-7f81c4298794');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 13, NULL, 'a3dd5220-c03e-5d83-e082-e36f0e0e216f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 14, NULL, '37bf7761-4b79-bf1a-825c-8c489843a41a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 15, NULL, 'd80ba9ae-f077-2264-4231-bba61362557c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 16, NULL, 'aec7f88e-0dc6-7a7c-a7c9-c27ef169bc9e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 17, NULL, 'f9b43761-4600-6a4f-2e5f-fcd9de1edc1d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 18, NULL, 'f8d8c128-6634-6d21-477c-e72988c3dd07');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 19, NULL, '64fb7531-854f-e45e-0c93-b63ea11936c0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 20, NULL, '804915fc-c525-27b6-45ad-f55d0d9bb6f5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 21, NULL, '76baf468-5330-4fd3-9a3d-698399df834f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 22, NULL, 'ac453010-2178-47d8-ef2c-516cf04d7b66');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 23, NULL, 'f2bdd906-e620-7bc6-5ee5-ab6bcf6a0b47');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 24, NULL, '778147b4-6d1a-ea68-e92c-8ca2e49194d0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (37, 0, 25, NULL, '5ce960ac-dd82-a502-f802-22402d755115');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 1, 0, 'af2caf5c-7d54-9bcf-29f4-51e8fc11c2c9');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 2, 0, '907f9f64-daf3-dc8f-d711-e09295cf7253');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 3, 0, 'e85bb60d-948b-eb2c-32ff-be9948329d6c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 4, 0, '82a47488-dc4b-dabd-1163-f1673312c5a7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 5, 0, '6b1dcce4-bdb7-6478-93ee-dd7b1db99035');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 6, 0, '2f48e962-508a-33e8-f988-4ca52ef422b1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 7, 0, 'd26ebf6f-d535-e2d3-f2a0-c24521711c81');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 8, 0, 'feafa80d-f3dd-c4fa-d2e7-4f4b3dde7401');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 9, 0, 'e94eb33e-f861-6d4a-067e-90b6ec78e454');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 10, 0, '5d03474e-f688-1ea2-18f0-1234516e38c6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 11, 0, '8bf8c1cd-7239-bd35-56d0-9d4169e1ee6a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 12, 0, '30fe7b25-ad2b-d722-bbbe-ad8d8c383f5d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 13, 0, '4e5fcf63-9453-690e-b08a-23733019d915');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 14, 0, '5ee88438-d190-d18c-0cec-0515e886ec95');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 15, 0, 'efd7f083-d3c1-6577-b909-dee3112ee380');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 16, 0, '054e8617-9111-eabb-0a9c-b02187d43c20');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 17, 0, '7030e4ce-2df9-dcb1-051f-ff5691d2a365');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 18, 0, '763f4725-7121-d81a-4a13-29b76f7e4094');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 19, 0, '31eb1b8f-10bd-6410-6aea-30b79ddc04e6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 20, 0, '74b2fae1-c243-3805-feb1-6300f56433a1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 21, 0, '9b78a070-5a69-9f99-6462-5a1ecf2a7f37');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 22, 0, 'b4e145da-377d-a882-6156-297b276d86c9');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 23, 0, '3e9aab5b-65d2-5187-f761-ae59f5bf9e86');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 24, 0, 'c3ea4925-a26d-4488-c690-fb2f41f263c6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (39, 0, 25, 0, 'a3f4709d-eb24-acf2-4960-4908fd615e3d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 1, 0, '120a2e93-850f-74f1-f459-defdc4d2d6fe');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 2, 0, 'fd4792f2-5b74-7fa7-4278-8396b24b1d58');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 3, 0, '7846089e-fb70-581e-28dd-c8b15b0df504');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 4, 0, 'cd28be56-8074-0917-d029-0b42aeee5b27');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 5, 0, '7df8da3d-f643-6094-580e-adb43fb43758');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 6, 0, '507d808b-177b-cfad-9811-5070ef1b6539');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 7, 0, 'a76f7c7a-80a6-f039-c828-202c202c71c7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 8, 0, 'cbb3cd4c-8830-dc7a-fdb4-b4379ed89ddf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 9, 0, '9e7fea88-3e84-bddc-a0e0-755ae074f7bd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 10, 0, 'e9c60537-cedc-849d-bbe5-35afecb8056a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 11, 0, '99307b6c-ce48-3e70-2f2d-fbe970d99f4d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 12, 0, '4f137e49-fec1-979a-806a-d1964ed8d70f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 13, 0, 'fe0a5aab-9e42-1101-662b-02cf43b3c0fb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 14, 0, '3dd03852-18b3-adc0-6b06-e2dcf7000405');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 15, 0, 'b5481e3d-75fc-5f95-a2af-9e5727ea8a9c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 16, 0, '96064fbe-38a6-2bf0-0e1e-5051828abef9');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 17, 0, '954a012b-019d-008f-fb1a-78e03a70d35f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 18, 0, '6be81cdd-5c47-e0f9-7553-18cef5d43fb1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 19, 0, '36e03b1a-f4a8-1253-5327-f975ad0ff687');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 20, 0, '228b86bf-91d7-2f96-b235-f74ec40e6784');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 21, 0, 'ae7655ae-d919-402f-0bad-7529ba454765');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 22, 0, 'd89e643c-9164-cc66-95cb-ca307f867965');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 23, 0, '19f69354-3d9e-5608-617b-62a776e9c77f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 24, 0, '10e0df07-7912-c71a-0213-fce974b438f1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (40, 0, 25, 0, 'bf1834a7-5be2-debf-4e2a-93c9ee6feb78');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 1, 0, '182398b7-3d52-97ff-d35e-598b73a8a379');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 2, 0, 'ee98fb7f-a003-c314-dca2-1369a29af8c0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 3, 0, '152d7b75-f1c3-4c53-89c2-31f57bf13833');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 4, 0, '19441a8d-180a-e403-1a26-e4838df30c30');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 5, 0, '21a42c53-cfbe-f656-7d60-281a52f935b8');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 6, 0, '91079e09-ddbb-ec9e-a796-ffbec5a3b869');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 7, 0, 'c62accd1-4b5d-ed7f-4369-333ac6dedfa2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 8, 0, 'df52942b-7f64-b9de-52f4-f62fc071745e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 9, 0, '94a8663e-a39f-11fa-41a7-5113883ba6ee');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 10, 0, 'f4961f43-7c0f-6980-b50a-e75994d8ccf0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 11, 0, '145828c0-dc77-ce28-723c-dbc5b2266016');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 12, 0, 'c9f2a0db-7322-8cc6-84e9-87527fb626c0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 13, 0, 'f334f4b1-8035-3bf8-d012-6aff3f518278');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 14, 0, '684ea4f3-ab65-2f02-6b77-4945d8e734fb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 15, 0, 'a8b2a10d-57ba-3bc0-fc6f-b32708a4270c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 16, 0, '11af6a41-ec00-a6f6-3baf-d61ac3473bde');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 17, 0, '84293f3e-bbca-9a0f-85bc-b081e6f41781');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 18, 0, '48c0bf39-6b95-d149-7473-127ed210b51e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 19, 0, 'ebd6e415-ddd6-cd90-8ae4-ffc37d1b98fb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 20, 0, '5223a706-2369-75ac-b1c0-02874b7f45cc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 21, 0, '9af7b457-7af0-1443-c76c-c643a3021b13');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 22, 0, '5fa59cfd-4b25-a944-3fd9-00f8334642b6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 23, 0, '11ba48eb-1ac9-ea5a-35f2-7ed61855f2a1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 24, 0, '8a7d6efb-cd50-e92c-caa8-1f96719527c4');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (41, 0, 25, 0, 'fe36c4f8-5beb-d419-3d60-bf0b3a5c886d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 1, 0, '6fc087ef-3393-bff5-c5dd-8cae87cc0615');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 2, 0, 'f0d8e49c-4c2d-a66b-c28c-73f585975931');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 3, 0, '40d42fd1-cee7-bc1b-20d5-1246a31a8de5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 4, 0, '2a73a70a-efd9-b265-91d8-67d3e11aa8cd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 5, 0, '9c24d246-c131-59c0-e95a-b3ae814368bf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 6, 0, '4894dcb2-7a3c-f31d-3628-7010b15ba9d6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 7, 0, '050308a8-42a1-7d09-6b16-53af86f1ec9b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 8, 0, '1c011290-d27e-3fea-e57a-38a91fb758e0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 9, 0, '3c1f32d1-0df3-2692-c479-ffc7db5c91d0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 10, 0, '14d76908-8d81-8fb1-9b7b-696faa20c392');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 11, 0, 'edadecc2-4a5b-b487-8662-3cebd955af10');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 12, 0, '76621606-8189-1278-bb1d-d5e11da37ac0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 13, 0, '2fb0fc97-03a2-2b90-7bf7-eab5f9f4a8f2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 14, 0, '0a199cd7-235d-39e5-a4d9-c0b81915b7e7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 15, 0, 'fee68174-db7b-8323-4f41-8bb10c9d30e0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 16, 0, 'daa67e30-771c-7409-5fbb-bff6bb790a0f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 17, 0, 'cd78e331-d498-3b60-c4f6-05fb3415abc2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 18, 0, '5bbe14c1-b2e9-0806-0f81-1c8168bc3f9e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 19, 0, '998199e0-be58-862e-4d4e-6c6d0f45dcbc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 20, 0, '71d8869e-0f41-7d09-5cb3-cab480a5c0d5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 21, 0, '4b0f4031-9d62-7e12-f214-cd6804c816b1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 22, 0, 'da895ea1-4a92-f08c-3f27-3ae593f86063');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 23, 0, '40b804b7-949d-9506-ca61-ab96b5f547c6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 24, 0, 'c2069636-c9d3-0e4f-c99b-5076900f72a7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (42, 0, 25, 0, '231cd688-2c43-a6fa-b0ff-980d4d35641b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 1, 0, '3853834f-a999-c5c6-0e84-dcae56849b99');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 2, 0, 'a313d7d7-516a-244c-f181-43b0adb941e5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 3, 0, 'ca8e6bb7-2f3b-2276-323e-6a73ac0ec54a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 4, 0, 'caaabfcd-ca09-519d-7c6e-d791705b561d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 5, 0, '952be2cf-a5d7-2b13-9c4b-e5bd0dd5575c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 6, 0, 'c83fa875-ad5f-e952-4dc9-e3308dc71f60');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 7, 0, '4c56cbba-3591-1eb5-2416-56c419f60a5f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 8, 0, '3ffc0b84-8918-dcca-a18c-264c5730714b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 9, 0, '24919008-e616-c5f6-4086-11cca6540c7d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 10, 0, 'a427086a-bace-87e7-a4da-5f9ed1610770');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 11, 0, '1f666174-ff1a-b8ba-6ae8-53c6bf8af427');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 12, 0, '0f9c0455-8da2-cc1f-fb50-8ab7d50265e2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 13, 0, '2bc5c87c-b817-0a10-4a68-d41cd1a92252');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 14, 0, '12db80b6-db4c-2ee8-26d7-da8e46b486a0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 15, 0, '199e7c38-9ddf-2618-32ae-466aa875542d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 16, 0, '8a3e2d43-9c7b-5479-d758-e36f3192d864');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 17, 0, '45a12f03-f67e-841a-27ee-1d9cb143789a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 18, 0, '983ba6d3-bc14-91bb-c2e3-652bec799942');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 19, 0, '7d8c5d9b-8eeb-f128-231f-44bb944996da');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 20, 0, 'fe2e76f0-2c10-0d17-d126-67fc0dc4e544');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 21, 0, 'c7e803df-7c27-0a92-cf19-f173012af66d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 22, 0, '020f3ade-9fef-24d7-c100-377b1ce94751');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 23, 0, '029ed291-82e7-9eee-7996-63355ff68ef0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (44, 0, 24, 0, 'a9335db3-70c5-cbdb-2de4-c172ff02ff61');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 1, 0, '8e2708c0-e0f6-f392-be03-2d9527bbe449');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 2, 0, '9aaba60e-2a4d-0e76-9aef-cb319fcbe230');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 3, 0, '8960f531-5e8e-1a40-b65b-b73f093035f0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 4, 0, '3c6cc33c-eacf-7b05-25a7-05ec47410af0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 5, 0, '6261177e-cb66-3f66-9b62-59da0ae41ca0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 6, 0, '06d7c488-11b1-e729-e99f-2e504fb2f85b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 7, 0, '6efe5b97-9cbf-679f-6ff4-463a12e4f186');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 8, 0, 'd970b4e9-2b8d-6c08-1e8c-75e62394d7d9');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 9, 0, '49dc5ed8-32ee-b160-337b-4172ddd1ea28');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 10, 0, '6402e6c4-839c-819a-c843-95f68adda3dd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 11, 0, 'bcfa61ba-98e5-d0c6-904f-114a79b80558');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 12, 0, '0ce3dc78-90a4-d200-0647-cb2d411295f5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 13, 0, '1aaf83cc-1269-64cf-378b-57276da86087');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 14, 0, '888dd355-8d96-dcf3-6203-d40e3687c7c4');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 15, 0, '228e8f57-3399-19f7-6a47-5f13188e8bf8');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 16, 0, 'abb6bfc3-1ca2-c4d6-8e3e-0cdde06669c9');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 17, 0, '9cc9b704-ca9c-7700-1c8b-762c4b2c04cd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 18, 0, 'b04b0946-b837-8921-ddae-b2ae629f7f3c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 19, 0, '159c204c-29e1-7757-6a9a-189e4253cc0d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 20, 0, 'c9451d0e-30ea-21b0-fe53-83cdf5007c50');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 21, 0, 'd1dd00ba-832d-c14d-cda9-4cf1dd7197f9');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 22, 0, '12a113f8-6f07-3834-1876-66d5ccabf37f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 23, 0, 'eb20ce36-6000-5af9-5961-3a5949954131');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 24, 0, '5f2a61d1-3f10-d975-5357-b0c5eb012a23');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (45, 0, 25, 0, 'c9f91ac2-d083-ecea-b65f-8aec836074ad');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (46, 0, 1, 0, 'bef774ef-151b-f3ba-730e-960be0f52161');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (46, 0, 2, 0, '90771022-123f-b46a-855b-9ece90c50a38');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (46, 0, 3, 0, '8ecc9ef2-840e-efbe-e9cc-1cacb554c7e2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (46, 0, 4, 0, 'da56b0cb-c623-170a-ca6d-f415e51118b8');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (55, 0, 1, 0, '90759e4e-2c23-b816-2c9b-7e618284e3f3');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 1, 0, '025f949a-72a5-5702-a886-2c58b9b3c437');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 2, 0, '1ac70b4f-6fe3-00fd-0b0f-963759f67473');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 3, 0, '960d51dd-d9f3-6394-0362-c7ad3fda0a54');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 4, 0, 'c1f9ddf0-5e46-2463-7a04-9130461e2244');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 5, 0, '4141a130-1e75-5386-8094-aaea3c4856b0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 6, 0, '6308c76b-6ebc-e244-560c-e24e8e962484');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 7, 0, '15143402-d270-8877-cc87-5945d014d341');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 8, 0, '0af3591a-2ade-0b03-eff7-914bcec393c3');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 9, 0, '8ff4a7c4-f12e-a21a-e51d-aafdbfa9817a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 10, 0, 'be6d2cfb-f931-1a82-429f-c693efc3e8ba');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 11, 0, 'ff6dd411-8739-4171-2bd5-7cf4ff9fca7b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 12, 0, '83bec21b-e6be-86d0-a7d9-11348e14bd33');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 13, 0, '84a2a491-bc54-012f-b532-4c651ba10b50');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 14, 0, '7ab86bd9-a10e-5599-a444-7a949aa05fbf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 15, 0, 'add8efc8-97d0-b6e4-6110-42f854727749');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 16, 0, '1ae0c7da-88e9-b094-a21c-d364c27f3108');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 17, 0, 'ed6fcb2a-e679-4522-c9f4-8150da58a1a7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 18, 0, 'dcd40e5d-be6f-093f-be7b-3390f82c6068');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 19, 0, '4d3e6a78-a280-ceab-9349-fe99188a47d5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 20, 0, '3360e1d9-1e8c-bfe0-8705-ae15284577be');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 21, 0, '7714b43d-3365-6ec0-b643-d1ff9beb364a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 22, 0, '01a62703-3bad-e727-bd11-2f39b9c09325');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 23, 0, 'f13f2b2b-85e2-8413-bac8-5795d05290cb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 24, 0, '5fc57bed-64c1-ef90-68a8-0af60de2b9f4');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (84, 0, 25, 0, '70d35259-6e08-ff38-24f9-c34819f80d3a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 1, 0, '7adf6372-0cc8-a582-073a-3301a6006272');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 2, 0, '781247d9-4f88-b316-a367-ce989a2d7c49');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 3, 0, 'dc190a20-910c-f2f7-4a06-f393c33fe7b0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 4, 0, 'd51a00e7-22c5-71c5-a758-2877f26d4b74');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 5, 0, 'b606fc3c-42b6-5479-9df7-53aa8a0e9edd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 6, 0, '0a329430-1373-a689-b613-2370402fe671');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 7, 0, '41e767d2-6b8c-f159-bf21-62134905fabd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 8, 0, '1851d512-ad6c-8722-e02a-b8845891a69e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 9, 0, 'c45b617c-208c-5b50-28d3-d8a95c18d0b0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 10, 0, '8ca449e5-595b-cd01-4c8c-1e190e078806');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 11, 0, '09dd4b4d-3d45-47cf-8196-078cdc7ffb86');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 12, 0, '4e8e27a9-21bb-1d50-3528-8ec3cf593e2a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 13, 0, '76f1faf3-8041-d072-b6aa-1ed15f62e8a1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 14, 0, 'f7653ea7-16c0-baba-c318-75d9b828da82');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 15, 0, 'fa4cfecb-8b95-3eb6-ce98-1d56cb60df94');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 16, 0, 'f5192249-de74-ab47-291a-199bb3fdb5bd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 17, 0, '98d591d3-f1bc-268a-eb3e-bfef7414a2f7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 18, 0, '90c50be0-396d-6567-87bb-60d9071bc30a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 19, 0, 'fed310e8-98a3-a4a2-dbfe-a48dc1ab2e63');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 20, 0, 'e567b7d2-e44c-ce15-f5f8-a2824973debe');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 21, 0, '819add27-fd94-6932-a298-e6c9c5b5a14c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 22, 0, '4dd14f2d-b76b-1aa1-69a7-f1b360e2fa61');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 23, 0, 'c55e8315-8305-3e06-c4eb-8fbd8e62f467');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 24, 0, '6b4216fc-297d-620f-b8a7-694c219ac2d8');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (85, 0, 25, 0, '56b7abf2-1288-c234-8e2f-1963a4b46860');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 1, 0, '16b525ec-d416-ac09-dee7-568087d1f503');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 2, 0, '9bf6a282-4188-b064-5a86-03cb52f6f97b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 3, 0, '4f030b87-20ea-daa2-29d0-ccddaaed22b4');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 4, 0, '0884dd24-918f-5780-3912-0f09bc88b053');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 5, 0, '6cbd8d8d-e95b-41e1-b3ee-3ec3e5e501da');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 6, 0, 'c6a2c1fb-3915-868c-f364-95b4a7967cf1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 7, 0, '90615926-64d6-bf4a-a637-b1798b091a83');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 8, 0, 'e45be382-04a1-834f-c925-52f9eeaf62a0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 9, 0, 'ceaa1d5b-020a-132c-9958-06782ea9f8ad');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 10, 0, '4e9ec689-f4d4-0ab4-b834-347930047a11');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 11, 0, 'de10ca99-f9c4-2e8e-b1c1-9d64d9678ac4');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 12, 0, 'bf30e078-70c8-1288-59a2-fd008001ee73');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 13, 0, 'ac3da3f8-1d98-bfe2-6f51-790298ead46e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 14, 0, '5e2fad3d-87be-7401-24c8-9c3b63f1c4c7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 15, 0, 'd451db0a-bf47-ccd0-9bc7-74be6f6bdd64');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 16, 0, 'fa20854d-b186-404d-dc03-9aa6ec169200');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 17, 0, '6c91c0d5-184b-d831-12ff-6573845d4200');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 18, 0, 'ccf5467c-bfd0-81b6-3de8-aac03231f4ac');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 19, 0, '89406da7-e240-a15c-5ff8-48e27cfccb0c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 20, 0, '37e24b1d-5ec0-61e2-8a1a-11010520386a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 21, 0, 'a93ed894-aaf0-afe4-ff94-49e4782b5c56');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 22, 0, '6b2dfdfd-d56a-3ec1-89cd-03fb637ea1e1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 23, 0, '5c580de0-89cf-5dab-2db7-eb284bf0db7a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 24, 0, '65f2f51b-ffc0-9693-cdd6-03f97c0dd36c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (86, 0, 25, 0, '27d6787f-25f7-9006-8ca4-ae217024f69f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 1, 0, '5ef00541-8b6a-8e86-8e7d-87244a171fa5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 2, 0, '2d0d3d04-23d1-474c-a853-b6f272fe11eb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 3, 0, '0da858a8-06d4-a985-3d4d-0e7866fe1257');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 4, 0, '5bf7ffe4-1658-3945-fbb4-1778551028f7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 5, 0, 'd7cfd522-e451-966f-7b93-9a4a8323b75f');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 6, 0, '4375af5d-ec75-125f-f40c-a3570b6230fe');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 7, 0, 'abf0451c-f38e-31c5-0eb5-e7751d656202');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 8, 0, 'f65ec891-3af4-78ce-30c8-63490e852415');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 9, 0, 'a3b9da54-ab77-2f21-3c68-41d3f18764ab');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 10, 0, '7aa653e6-ba02-cdb7-2734-5a9bd4acdc51');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 11, 0, '061651c3-bbfa-6405-f60c-b349d5fc0fe7');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 12, 0, '27674d97-5409-c2b8-3ee7-d1cf3c456760');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 13, 0, '375ee890-93c5-a7b5-1e76-b3ded86df8bf');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 14, 0, '67612bf2-e1a8-f946-19a3-503fec2a76f9');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 15, 0, 'b0c87dfc-262a-2588-864b-eb7a729709ad');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 16, 0, '1c63cad7-a467-ca09-21b9-1d294ab7a337');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 17, 0, '52256bca-5298-c8a6-649c-c7e0aab2624c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 18, 0, '22488bbc-5036-846b-86e7-320627c88b8e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 19, 0, 'b1682e16-164b-2cf9-b82e-a20c6b92ffdd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 20, 0, 'eb2a8ab7-ce42-37ca-c14d-6fb023b61682');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 21, 0, '8c599a6f-a79b-35c8-2365-a4911fead925');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 22, 0, '048ae473-26f4-e1c4-8992-8e60b18f0b82');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 23, 0, 'b4a7c68a-939a-71bf-1293-d91072dce443');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 24, 0, 'cd949ed9-c77a-01b0-6545-88f736b44dce');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (87, 0, 25, 0, 'e4ebca4d-8246-d716-d775-6a18c4aef4aa');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 1, 0, 'a918e2d7-36bb-9ca1-36e7-d6422537645d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 2, 0, '971c9785-4668-c6ff-c068-fe1f842b8ca3');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 3, 0, 'ff5dacf7-9d7d-c921-86a3-83ca521e5a8d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 4, 0, '469a3f81-0644-50ce-3aa5-e2a7ec643b53');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 5, 0, 'e6aa5b83-7d05-f8eb-9827-d569e6dcc0fc');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 6, 0, '12721fe7-3336-3c83-85da-4fbd0b059b6b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 7, 0, '9f855ac1-b69c-7aff-7d08-ad76eb49896b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 8, 0, '73c2e0ea-c25e-3980-a6f9-63b74ab85764');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 9, 0, '4b69634c-f4e9-0eb2-1a87-a2855392e311');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 10, 0, '33b68b4c-b510-40e3-d823-7a57527a1bae');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 11, 0, '177b3a4a-b504-abd5-8937-15f7e41ae7e1');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 12, 0, 'e5feb921-3d68-e402-14e4-f9caa8849436');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 13, 0, '055869b7-7a8a-191c-3073-da813f427e69');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 14, 0, 'daf26adf-44bf-2415-7690-38c03720848a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 15, 0, '453fb304-bf29-333f-2c34-b942f3d24b60');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 16, 0, 'b91d23cc-5e54-7c38-19c2-e8b243113086');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 17, 0, '5e25e2dd-67b2-ae49-e42c-82b729574cd5');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 18, 0, '6a2d03a4-54c3-4ddb-da80-eed613f90b69');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 19, 0, 'c9e82ed7-40e9-abb7-364b-0e98c5319483');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 20, 0, '43af2754-78cd-14bc-1ff9-6f11d61099eb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 21, 0, '774bb150-d489-b875-8d65-48cdd69ca158');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 22, 0, '3b4ff03a-6c05-b6bd-2cb9-d6f0fbe16aeb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 23, 0, '249653f1-5378-5956-3e03-3954c2b6eafb');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 24, 0, '8f999b12-c053-1b09-40ee-b89f6ba82702');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (88, 0, 25, 0, '1ebfd749-ec3b-13ef-4913-8e7ac1fd2d16');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 1, 0, '5a87f1eb-ee9c-083d-cbfe-547e5be79181');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 2, 0, '3b026d1e-6d4b-77d6-095b-805008c1c10c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 3, 0, 'f20013cc-eb4b-6fa7-8cbb-3a6d92cb577d');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 4, 0, 'c1379f9c-9a9b-a628-a4f1-d1e4dba61566');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 5, 0, '6143eaef-e6b6-3830-1ecc-06a252c1d9ce');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 6, 0, '6bfebcad-65a2-8ae2-d875-2fb698b2244a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 7, 0, 'e4818fdb-09fc-4fa3-97a1-0c823a3642b8');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 8, 0, 'be8a011d-77dc-2c17-9b7a-14f2bf1226dd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 9, 0, 'b3734584-a937-c10f-4f8c-9c932ae0d40c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 10, 0, '31bdcb3d-bc37-d5e3-60de-ca7e9bb472b0');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 11, 0, 'aaf56d84-03cb-b0c6-314e-e3915549ec8c');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 12, 0, '655a883e-b321-423b-a5d1-d62574f4d4c4');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 13, 0, '9a2d66da-3b23-0ebe-1e65-2dfb906a12be');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 14, 0, 'b98199ce-34ee-036d-60d2-d142b4020b63');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 15, 0, '1d8153fd-55e0-b6af-8aff-baefe0fcd36a');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 16, 0, '4a6493ac-2f49-28d1-ed9b-3a95c37227f6');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 17, 0, '50d0aee4-4329-893a-d810-52c9604d3c35');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 18, 0, '85de549f-f6ec-b38a-056c-4f8bfec2cb1b');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 19, 0, '060ea207-995d-7071-2ff8-1b6fb2a5a3fd');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 20, 0, '66e408e2-8245-242c-5091-fd8fdf13e537');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 21, 0, 'c4c4b957-fc5b-9f63-19da-c0b2315d2e55');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 22, 0, 'e8819014-30c6-610e-5b69-d096b44433f2');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 23, 0, 'a4d858d8-2a62-3d0f-d251-47ec7b077509');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 24, 0, '1a61100e-97a8-231d-714f-abfd0aad800e');
INSERT INTO public.grow_boxes (user_id, plant_id, location, day_planted, box_uuid) VALUES (89, 0, 25, 0, '827f8637-b399-6482-6f7b-ea1bd919c1d8');


--
-- Data for Name: has_seeds; Type: TABLE DATA; Schema: public; Owner: team1
--

INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (35, 11, 20, 2);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 7, 100, 1);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 11, 123, 4);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (40, 11, 5, 3);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 119, 10, 5);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 120, 10, 6);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 121, 10, 7);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 122, 10, 8);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 123, 10, 9);
INSERT INTO public.has_seeds (user_id, seed_id, quantity, seed_inventory_id) VALUES (36, 124, 10, 10);


--
-- Data for Name: market_listings; Type: TABLE DATA; Schema: public; Owner: team1
--

INSERT INTO public.market_listings (listing_id, seller_id, plant_id, price, quantity, listing_type) VALUES (4, 36, 11, 10, 1, 'crops');
INSERT INTO public.market_listings (listing_id, seller_id, plant_id, price, quantity, listing_type) VALUES (3, 36, 11, 11, 10, 'crops');
INSERT INTO public.market_listings (listing_id, seller_id, plant_id, price, quantity, listing_type) VALUES (5, 36, 11, 10, 5, 'crops');
INSERT INTO public.market_listings (listing_id, seller_id, plant_id, price, quantity, listing_type) VALUES (13, 35, 11, 10, 4, 'crops');
INSERT INTO public.market_listings (listing_id, seller_id, plant_id, price, quantity, listing_type) VALUES (14, 35, 11, 40, 4, 'crops');
INSERT INTO public.market_listings (listing_id, seller_id, plant_id, price, quantity, listing_type) VALUES (16, 35, 11, 30, 3, 'seeds');


--
-- Data for Name: plant_species; Type: TABLE DATA; Schema: public; Owner: team1
--

INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (0, 'null-plant', 'pernnial', 0, 'https://i.ytimg.com/vi/1fUJp7jwaoY/maxresdefault.jpg', 10, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (6, 'taro', 'pernnial', 1, 'https://thumbs.dreamstime.com/b/taro-plant-10766205.jpg', 100, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (5, 'potato', 'pernnial', 1, 'https://i.imgur.com/fJORZNV.png', 5, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (8, 'ganja', 'annual', 0, 'qwerty', 25, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (9, 'onion', 'annual', 10, NULL, 1, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (10, 'tomato', 'annual', 3, NULL, 1, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (1, 'null-plant', 'pernnial', 0, 'https://i.ytimg.com/vi/1fUJp7jwaoY/maxresdefault.jpg', 10, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (2, 'null-plant', 'pernnial', 0, 'https://i.ytimg.com/vi/1fUJp7jwaoY/maxresdefault.jpg', 10, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (3, 'null-plant', 'pernnial', 0, 'https://i.ytimg.com/vi/1fUJp7jwaoY/maxresdefault.jpg', 10, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (4, 'null-plant', 'pernnial', 0, 'https://i.ytimg.com/vi/1fUJp7jwaoY/maxresdefault.jpg', 10, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (11, 'strawberry', 'perennial', 13, 'https://imgur.com/6f40dJJ.png', 5, 5);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (7, 'blueberry', 'perennial', 5, 'https://imgur.com/yJBOPf7.png', 2, 1);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (119, 'avocado', 'perennial', 2, 'https://imgur.com/dsNTIZm.png', 20, 9);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (120, 'mushroom', 'annual', 18, 'https://imgur.com/Q7PTqKw.png', 10, 18);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (121, 'eggplant', 'annual', 3, 'https://imgur.com/SzyMRUW.png', 11, 20);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (122, 'onion', 'perennial', 1, 'https://imgur.com/Wgjxeq8.png', 8, 4);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (123, 'broccoli', 'annual', 6, 'https://imgur.com/OYJ3m79.png', 13, 11);
INSERT INTO public.plant_species (species_id, name, lifespan_type, harvest_quantity, plant_image_url, days_to_harvest, points_for_eating) VALUES (124, 'orange', 'perennial', 14, 'https://imgur.com/L2rhWPT.png', 6, 4);



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: team1
--

INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (30, 'a', 'a', 1000, 0, 5, 0);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (31, 'b', 'b', 1000, 0, 5, 0);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (32, 'c', 'c', 1000, 0, 5, 0);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (33, 'e', 'e', 1000, 0, 5, 0);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (34, 'f', 'f', 1000, 0, 5, 0);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (37, 'evannoronha', 'helloworld', 1000, 0, 5, 0);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (38, 'lubolubo', 'lubo', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (39, 'qwerty', 'asdf', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (41, 'mark', 'mark', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (42, 'evane', 'dsfgkjdsnfg', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (43, 'ryan', 'demo', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (44, 'demo', 'ryan', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (45, 'sam', 'skala', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (46, 'jay', 'wooky', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (47, 'jay2', 'wooky', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (48, 'wew', 'werwr', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (49, 'wewsfd', 'sdfsdfs', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (50, 'werwerwre', 'werw', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (51, 'ervereger', 'dvfdfddfvvd', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (52, 'ererterterte', 'erterteterttt', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (53, 'rtyuikjnb ', 'ghjkiuygtyu', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (54, '2fsdlknsdfgln', 'df;goklndg', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (55, '2342342', '24234242', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (56, '12312313', '123123', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (57, 'sdfsdfsd', 'sdfsfsdfdf', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (58, 'sdafsadfasd', 'sadfasdfasfdsafa', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (59, 'tyuionb ', 'dsfgjkdf', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (60, 'werwer', 'werwerw', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (61, '234234', '234234234', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (0, 'lubo', 'lubo', 1000, 1, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (62, '23423423', '23423424432', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (63, '23423423rr', '23423424432', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (64, 'wewewrwrwfsdv', 'sdvsdv', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (65, 'dsfgdsg', 'erwt34', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (66, '3dsfgdsg', 'erwt34', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (67, 'asdfadfasdfsa', 'asdfsafdsdfad', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (68, 'poiuyt', 'kjhgf', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (69, 'hello', 'hello', 1000, 2, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (70, 'wefwecwcw', 'wecwcewe', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (71, 'sfsdfsf', 'sdfwcec', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (72, 'sfsdfsfb', 'sdfwcecb', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (73, 'eargrgdfg', 'dfdfv', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (74, 'rrr', 'rrrrr', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (75, 'rrre', 'rrrrrw', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (76, 'wefwefew', 'wefwecwc', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (77, 'wwrewrwerw', 'werwrewerw', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (78, 'ebxr', 'rrsfdf', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (79, 'baxter', 'baxter', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (80, 'robby', 'robby', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (81, 'wefsdafdfa', 'fsfdsfdf', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (82, 'regegerg', 'ergergegre', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (83, 'ef', 'ef', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (84, 'wer', 'wer', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (85, 'were', 'were', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (86, 'sdfsdfsde', 'sdfsdfsdf', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (87, 'dfbdbsfb', '234234', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (88, 'evannoronha2', 'hello', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (89, 'evannoronha23', 'evannoronha23', 1000, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (35, 'dontdel', 'del', 1039, 11, 6, 0);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (36, 'lhibbs', 'password', 981, 0, 5, 5);
INSERT INTO public.users (user_id, login, password, cash, farm_age, garden_size, score) VALUES (40, 'evan', 'evan', 980, 9, 5, 0);


--
-- Data for Name: watering_events; Type: TABLE DATA; Schema: public; Owner: team1
--



--
-- Name: crops_inventory_crops_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.crops_inventory_crops_inventory_id_seq', 1, true);


--
-- Name: crops_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.crops_inventory_id_seq', 4, true);


--
-- Name: grow_boxes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.grow_boxes_id_seq', 95, true);


--
-- Name: has_seeds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.has_seeds_id_seq', 3, true);


--
-- Name: has_seeds_seed_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.has_seeds_seed_inventory_id_seq', 2, true);


--
-- Name: market_listings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.market_listings_id_seq', 18, true);


--
-- Name: market_listings_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.market_listings_listing_id_seq', 5, true);


--
-- Name: plant_species_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.plant_species_id_seq', 120, true);


--
-- Name: plant_species_species_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.plant_species_species_id_seq', 8, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.users_id_seq', 89, true);


--
-- Name: watering_events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: team1
--

SELECT pg_catalog.setval('public.watering_events_event_id_seq', 1, false);


--
-- Name: crops_inventory crops_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.crops_inventory
    ADD CONSTRAINT crops_inventory_pkey PRIMARY KEY (crops_inventory_id);


--
-- Name: grow_boxes grow_boxes_pkey; Type: CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.grow_boxes
    ADD CONSTRAINT grow_boxes_pkey PRIMARY KEY (box_uuid);


--
-- Name: has_seeds has_seeds_pkey; Type: CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.has_seeds
    ADD CONSTRAINT has_seeds_pkey PRIMARY KEY (seed_inventory_id);


--
-- Name: market_listings market_listings_pkey; Type: CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.market_listings
    ADD CONSTRAINT market_listings_pkey PRIMARY KEY (listing_id);


--
-- Name: plant_species plant_species_pkey; Type: CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.plant_species
    ADD CONSTRAINT plant_species_pkey PRIMARY KEY (species_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: watering_events watering_events_pkey; Type: CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.watering_events
    ADD CONSTRAINT watering_events_pkey PRIMARY KEY (event_id);


--
-- Name: crops_inventory crops_inventory_crop_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.crops_inventory
    ADD CONSTRAINT crops_inventory_crop_id_fkey FOREIGN KEY (crop_id) REFERENCES public.plant_species(species_id);


--
-- Name: crops_inventory crops_inventory_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.crops_inventory
    ADD CONSTRAINT crops_inventory_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: grow_boxes grow_boxes_plant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.grow_boxes
    ADD CONSTRAINT grow_boxes_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant_species(species_id);


--
-- Name: grow_boxes grow_boxes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.grow_boxes
    ADD CONSTRAINT grow_boxes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: has_seeds has_seeds_seed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.has_seeds
    ADD CONSTRAINT has_seeds_seed_id_fkey FOREIGN KEY (seed_id) REFERENCES public.plant_species(species_id);


--
-- Name: has_seeds has_seeds_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.has_seeds
    ADD CONSTRAINT has_seeds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: market_listings market_listings_plant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.market_listings
    ADD CONSTRAINT market_listings_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant_species(species_id);


--
-- Name: market_listings market_listings_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.market_listings
    ADD CONSTRAINT market_listings_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(user_id);


--
-- Name: watering_events watering_events_box_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: team1
--

ALTER TABLE ONLY public.watering_events
    ADD CONSTRAINT watering_events_box_id_fkey FOREIGN KEY (box_id) REFERENCES public.grow_boxes(box_uuid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

