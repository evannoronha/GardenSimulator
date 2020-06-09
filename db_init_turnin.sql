CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    login text NOT NULL,
    password text NOT NULL,
    cash real NOT NULL CHECK (cash > 0::double precision),
    farm_age integer NOT NULL CHECK (farm_age >= 0),
    garden_size integer NOT NULL CHECK (garden_size >= 0),
    score integer NOT NULL DEFAULT 0 CHECK (score >= 0)
);

CREATE TABLE plant_species (
    species_id SERIAL PRIMARY KEY,
    name text NOT NULL,
    lifespan_type text NOT NULL,
    harvest_quantity integer,
    plant_image_url text,
    days_to_harvest integer NOT NULL DEFAULT 5,
    points_for_eating integer NOT NULL DEFAULT 1
);

CREATE TABLE crops_inventory (
    user_id integer NOT NULL REFERENCES users(user_id),
    crop_id integer NOT NULL REFERENCES plant_species(species_id),
    quantity integer NOT NULL CHECK (quantity > 0),
    crops_inventory_id SERIAL PRIMARY KEY
);

CREATE TABLE has_seeds (
    user_id integer NOT NULL REFERENCES users(user_id),
    seed_id integer NOT NULL REFERENCES plant_species(species_id),
    quantity integer NOT NULL CHECK (quantity > 0),
    seed_inventory_id SERIAL PRIMARY KEY
);

CREATE TABLE grow_boxes (
    box_uuid text DEFAULT uuid_in(md5(random()::text || clock_timestamp()::text)::cstring) PRIMARY KEY
    user_id integer NOT NULL REFERENCES users(user_id),
    plant_id integer REFERENCES plant_species(species_id),
    location integer,
    day_planted integer,
);

CREATE TABLE market_listings (
    listing_id SERIAL PRIMARY KEY,
    seller_id integer NOT NULL REFERENCES users(user_id),
    plant_id integer NOT NULL REFERENCES plant_species(species_id),
    price real CHECK (price > 0::double precision),
    quantity integer CHECK (quantity > 0),
    listing_type text NOT NULL DEFAULT 'crops'::text
);

CREATE TABLE watering_events (
    event_id SERIAL PRIMARY KEY,
    box_id text NOT NULL REFERENCES grow_boxes(box_uuid),
    user_day integer NOT NULL
);
