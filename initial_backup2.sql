
CREATE TABLE bus_pick_up_points (
    pick_up_id SERIAL PRIMARY KEY,
    pick_up_point_name VARCHAR(100) NOT null unique,
    pick_up_price int,
    status VARCHAR(10) DEFAULT 'active'
);