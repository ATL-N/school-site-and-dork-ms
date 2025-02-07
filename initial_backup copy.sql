-- Step 1: Create a trigger function
CREATE OR REPLACE FUNCTION set_empty_pickup_point_to_null()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.pick_up_point = '' THEN
    NEW.pick_up_point := NULL;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create a trigger that fires before insert/update
CREATE TRIGGER before_insert_update_feeding_transport_fees
BEFORE INSERT OR UPDATE ON feeding_transport_fees
FOR EACH ROW
EXECUTE FUNCTION set_empty_pickup_point_to_null();