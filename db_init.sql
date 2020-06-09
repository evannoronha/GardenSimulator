drop sequence if exists crops_inventory_id_seq;
CREATE SEQUENCE public.crops_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop table if exists crops_inventory;
CREATE TABLE public.crops_inventory (
    user_id integer NOT NULL,
    crop_id integer NOT NULL,
    quantity integer NOT NULL,
    crops_inventory_id integer DEFAULT nextval('public.crops_inventory_id_seq'::regclass) NOT NULL
);

drop sequence if exists crops_inventory_crops_inventory_id_seq;
CREATE SEQUENCE public.crops_inventory_crops_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop table if exists grow_boxes;
CREATE TABLE public.grow_boxes (
    user_id integer NOT NULL,
    plant_id integer,
    location integer,
    day_planted integer,
    box_uuid text DEFAULT uuid_in((md5(((random())::text || (clock_timestamp())::text)))::cstring) NOT NULL
);

drop sequence if exists grow_boxes_id_seq;
CREATE SEQUENCE public.grow_boxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop sequence if exists has_seeds_id_seq;
CREATE SEQUENCE public.has_seeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop table if exists has_seeds;
CREATE TABLE public.has_seeds (
    user_id integer NOT NULL,
    seed_id integer NOT NULL,
    quantity integer NOT NULL,
    seed_inventory_id integer DEFAULT nextval('public.has_seeds_id_seq'::regclass) NOT NULL
);

drop sequence if exists has_seeds_seed_inventory_id_seq;
CREATE SEQUENCE public.has_seeds_seed_inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop sequence if exists market_listings_id_seq;
CREATE SEQUENCE public.market_listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop table if exists market_listings;
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

drop sequence if exists market_listings_listing_id_seq;
CREATE SEQUENCE public.market_listings_listing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop sequence if exists plant_species_id_seq;
CREATE SEQUENCE public.plant_species_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop table if exists plant_species;
CREATE TABLE public.plant_species (
    species_id integer DEFAULT nextval('public.plant_species_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    lifespan_type text NOT NULL,
    harvest_quantity integer,
    plant_image_url text,
    days_to_harvest integer DEFAULT 5 NOT NULL,
    points_for_eating integer DEFAULT 1 NOT NULL
);

drop sequence if exists plant_species_species_id_seq;
CREATE SEQUENCE public.plant_species_species_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop table if exists users;
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

drop sequence if exists users_id_seq;
CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

drop table if exists watering_events;
CREATE TABLE public.watering_events (
    event_id integer NOT NULL,
    box_id text NOT NULL,
    user_day integer NOT NULL
);

drop sequence if exists watering_events_event_id_seq;
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
    ADD CONSTRAINT has_seeds_pkey PRIMARY KEY (seed_inventory_id)

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
        
INSERT INTO "public"."plant_species"("species_id","name","lifespan_type","harvest_quantity","plant_image_url","days_to_harvest","points_for_eating")
VALUES
(1,E'potato',E'pernnial',1,E'https://i.imgur.com/fJORZNV.png',5,1),
(2,E'taro',E'pernnial',1,E'https://thumbs.dreamstime.com/b/taro-plant-10766205.jpg',100,1),
(3,E'blueberry',E'perennial',5,E'https://imgur.com/yJBOPf7.png',2,1),
(4,E'ganja',E'annual',5,E'https://i.imgur.com/tKUK4gU.gif',25,1),
(5,E'strawberry',E'perennial',13,E'https://imgur.com/6f40dJJ.png',5,5),
(6,E'avocado',E'perennial',2,E'https://imgur.com/dsNTIZm.png',20,9),
(7,E'mushroom',E'annual',18,E'https://imgur.com/Q7PTqKw.png',10,18),
(8,E'eggplant',E'annual',3,E'https://imgur.com/SzyMRUW.png',11,20),
(9,E'onion',E'perennial',1,E'https://imgur.com/Wgjxeq8.png',8,4),
(10,E'broccoli',E'annual',6,E'https://imgur.com/OYJ3m79.png',13,11),
(11,E'orange',E'perennial',14,E'https://imgur.com/L2rhWPT.png',6,4);

INSERT INTO "public"."users"("user_id","login","password","cash","farm_age","garden_size","score")
VALUES
(1,E'JohnnyAppleseed',E'hello',1000,2,5,3);
