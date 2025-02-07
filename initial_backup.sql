--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    attendance_id integer NOT NULL,
    student_id integer,
    class_id integer,
    attendance_date date NOT NULL,
    status character varying(10) NOT NULL,
    semester_id integer,
    staff_id integer
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendance_attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_attendance_id_seq OWNED BY public.attendance.attendance_id;


--
-- Name: balance_adjustment_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.balance_adjustment_log (
    log_id integer NOT NULL,
    student_id integer,
    amount_adjusted numeric(10,2),
    reason text,
    adjusted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.balance_adjustment_log OWNER TO postgres;

--
-- Name: balance_adjustment_log_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.balance_adjustment_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.balance_adjustment_log_log_id_seq OWNER TO postgres;

--
-- Name: balance_adjustment_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.balance_adjustment_log_log_id_seq OWNED BY public.balance_adjustment_log.log_id;


--
-- Name: class_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_items (
    class_item_id integer NOT NULL,
    class_id integer,
    item_id integer,
    semester_id integer,
    quantity_per_student integer DEFAULT 0,
    supplied_by integer,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE public.class_items OWNER TO postgres;

--
-- Name: class_items_class_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.class_items_class_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_items_class_item_id_seq OWNER TO postgres;

--
-- Name: class_items_class_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.class_items_class_item_id_seq OWNED BY public.class_items.class_item_id;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    class_id integer NOT NULL,
    class_name character varying(50) NOT NULL,
    class_level character varying(50) NOT NULL,
    capacity integer,
    room_name character varying(50),
    staff_id integer,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT classes_status_check CHECK (((status)::text = ANY (ARRAY[('active'::character varying)::text, ('inactive'::character varying)::text, ('archived'::character varying)::text, ('deleted'::character varying)::text])))
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- Name: classes_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classes_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classes_class_id_seq OWNER TO postgres;

--
-- Name: classes_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_class_id_seq OWNED BY public.classes.class_id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id integer NOT NULL,
    department_name character varying(50) NOT NULL,
    head_of_department integer,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_department_id_seq OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- Name: evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluations (
    evaluation_id integer NOT NULL,
    evaluatee_id integer,
    evaluation_date date NOT NULL,
    teaching_effectiveness numeric(2,1),
    classroom_management numeric(2,1),
    student_engagement numeric(2,1),
    professionalism numeric(2,1),
    overall_rating numeric(2,1) GENERATED ALWAYS AS (((((teaching_effectiveness + classroom_management) + student_engagement) + professionalism) / (4)::numeric)) STORED,
    comments text,
    years_of_experience integer,
    evaluator_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying,
    CONSTRAINT evaluations_classroom_management_check CHECK (((classroom_management >= (1)::numeric) AND (classroom_management <= (5)::numeric))),
    CONSTRAINT evaluations_professionalism_check CHECK (((professionalism >= (1)::numeric) AND (professionalism <= (5)::numeric))),
    CONSTRAINT evaluations_student_engagement_check CHECK (((student_engagement >= (1)::numeric) AND (student_engagement <= (5)::numeric))),
    CONSTRAINT evaluations_teaching_effectiveness_check CHECK (((teaching_effectiveness >= (1)::numeric) AND (teaching_effectiveness <= (5)::numeric)))
);


ALTER TABLE public.evaluations OWNER TO postgres;

--
-- Name: evaluations_evaluation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluations_evaluation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluations_evaluation_id_seq OWNER TO postgres;

--
-- Name: evaluations_evaluation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluations_evaluation_id_seq OWNED BY public.evaluations.evaluation_id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id integer NOT NULL,
    event_title character varying(100) NOT NULL,
    event_date date,
    start_time time without time zone,
    end_time time without time zone,
    location character varying(100),
    description text,
    event_type character varying(50),
    target_audience character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying,
    user_id integer,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: events_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_event_id_seq OWNER TO postgres;

--
-- Name: events_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_event_id_seq OWNED BY public.events.event_id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.expenses (
    expense_id integer NOT NULL,
    recipient_name character varying(100),
    expense_category character varying(50),
    description text,
    amount numeric(10,2),
    expense_date date,
    invoice_number character varying(50),
    supplier_id integer,
    staff_id integer,
    user_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.expenses OWNER TO postgres;

--
-- Name: expenses_expense_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.expenses_expense_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.expenses_expense_id_seq OWNER TO postgres;

--
-- Name: expenses_expense_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.expenses_expense_id_seq OWNED BY public.expenses.expense_id;


--
-- Name: fee_collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fee_collections (
    collection_id integer NOT NULL,
    student_id integer,
    payment_date date,
    amount_received numeric(10,2),
    old_balance numeric(10,2),
    new_balance numeric(10,2),
    fee_type character varying(50),
    payment_mode character varying(20),
    status character varying(50) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    received_by integer,
    comment text
);


ALTER TABLE public.fee_collections OWNER TO postgres;

--
-- Name: fee_collections_collection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fee_collections_collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fee_collections_collection_id_seq OWNER TO postgres;

--
-- Name: fee_collections_collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fee_collections_collection_id_seq OWNED BY public.fee_collections.collection_id;


--
-- Name: feeding_fee_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeding_fee_payments (
    id integer NOT NULL,
    student_id integer NOT NULL,
    class_id integer NOT NULL,
    collected_by integer NOT NULL,
    feeding_fee numeric(10,2) NOT NULL,
    valid_until_feeding date NOT NULL,
    transport_fee numeric(10,2) NOT NULL,
    valid_until_transport date NOT NULL,
    total_fee numeric(10,2) NOT NULL,
    semester_id integer NOT NULL,
    payment_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.feeding_fee_payments OWNER TO postgres;

--
-- Name: feeding_fee_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feeding_fee_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feeding_fee_payments_id_seq OWNER TO postgres;

--
-- Name: feeding_fee_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feeding_fee_payments_id_seq OWNED BY public.feeding_fee_payments.id;


--
-- Name: feeding_transport_fees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeding_transport_fees (
    student_id integer NOT NULL,
    transportation_method character varying(100),
    pick_up_point character varying(100),
    feeding_fee numeric(10,2) NOT NULL,
    transport_fee numeric(10,2) NOT NULL
);


ALTER TABLE public.feeding_transport_fees OWNER TO postgres;

--
-- Name: grading_scheme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grading_scheme (
    gradescheme_id integer NOT NULL,
    grade_name character varying(10) NOT NULL,
    minimum_mark numeric(5,2) NOT NULL,
    maximum_mark numeric(5,2) NOT NULL,
    grade_remark character varying(60),
    status character varying(10) DEFAULT 'active'::character varying
);


ALTER TABLE public.grading_scheme OWNER TO postgres;

--
-- Name: grading_scheme_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grading_scheme_grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grading_scheme_grade_id_seq OWNER TO postgres;

--
-- Name: grading_scheme_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grading_scheme_grade_id_seq OWNED BY public.grading_scheme.gradescheme_id;


--
-- Name: health_incident; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.health_incident (
    incident_id integer NOT NULL,
    incident_date date,
    incident_description text,
    treatmentprovided text,
    user_id integer
);


ALTER TABLE public.health_incident OWNER TO postgres;

--
-- Name: health_incident_incident_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.health_incident_incident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.health_incident_incident_id_seq OWNER TO postgres;

--
-- Name: health_incident_incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.health_incident_incident_id_seq OWNED BY public.health_incident.incident_id;


--
-- Name: inventory_class_semester; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_class_semester (
    inventory_id integer NOT NULL,
    class_id integer NOT NULL,
    semester_id integer NOT NULL
);


ALTER TABLE public.inventory_class_semester OWNER TO postgres;

--
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_items (
    inventory_id integer NOT NULL,
    inventory_name character varying(150) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    quantity_per_student integer,
    total_price numeric(12,2) NOT NULL,
    restock_level integer,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE public.inventory_items OWNER TO postgres;

--
-- Name: inventory_items_inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventory_items_inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_items_inventory_id_seq OWNER TO postgres;

--
-- Name: inventory_items_inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventory_items_inventory_id_seq OWNED BY public.inventory_items.inventory_id;


--
-- Name: invoice_class_semester; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_class_semester (
    invoice_id integer NOT NULL,
    class_id integer NOT NULL,
    semester_id integer NOT NULL
);


ALTER TABLE public.invoice_class_semester OWNER TO postgres;

--
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    invoice_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    description character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(30) DEFAULT 'active'::character varying
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- Name: invoices_invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoices_invoice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoices_invoice_id_seq OWNER TO postgres;

--
-- Name: invoices_invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoices_invoice_id_seq OWNED BY public.invoices.invoice_id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    item_id integer NOT NULL,
    item_name character varying(250) NOT NULL,
    category character varying(150),
    description text,
    unit_price numeric(10,2) NOT NULL,
    quantity_desired integer,
    quantity_available integer DEFAULT 0,
    restock_level integer,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: items_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_item_id_seq OWNER TO postgres;

--
-- Name: items_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_item_id_seq OWNED BY public.items.item_id;


--
-- Name: items_movement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_movement (
    supply_id integer NOT NULL,
    staff_id integer,
    recipient_name character varying(100),
    recipient_phone character varying(30),
    comments text,
    item_id integer,
    quantity integer NOT NULL,
    supplied_by integer,
    supplied_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'out'::character varying,
    movement_type character varying(20),
    returned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.items_movement OWNER TO postgres;

--
-- Name: items_movement_supply_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_movement_supply_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_movement_supply_id_seq OWNER TO postgres;

--
-- Name: items_movement_supply_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_movement_supply_id_seq OWNED BY public.items_movement.supply_id;


--
-- Name: items_supply; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_supply (
    supply_id integer NOT NULL,
    student_id integer,
    item_id integer,
    quantity integer NOT NULL,
    supplied_by integer,
    supplied_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    semester_id integer,
    class_id integer,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE public.items_supply OWNER TO postgres;

--
-- Name: items_supply_supply_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_supply_supply_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_supply_supply_id_seq OWNER TO postgres;

--
-- Name: items_supply_supply_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_supply_supply_id_seq OWNED BY public.items_supply.supply_id;


--
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_recipients (
    id integer NOT NULL,
    notification_id integer,
    recipient_id integer NOT NULL,
    recipient_type character varying(20) NOT NULL,
    is_read boolean DEFAULT false,
    read_at timestamp without time zone
);


ALTER TABLE public.notification_recipients OWNER TO postgres;

--
-- Name: notification_recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_recipients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_recipients_id_seq OWNER TO postgres;

--
-- Name: notification_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_recipients_id_seq OWNED BY public.notification_recipients.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    notification_title character varying(255) NOT NULL,
    notification_message text NOT NULL,
    notification_type character varying(50) DEFAULT 'general'::character varying,
    priority character varying(20) DEFAULT 'normal'::character varying,
    sender_id integer,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_read boolean DEFAULT false,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_notification_id_seq OWNER TO postgres;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: parents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parents (
    parent_id integer NOT NULL,
    other_names character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    phone character varying(20),
    email character varying(100),
    address text,
    status character varying DEFAULT 'active'::character varying,
    user_id integer
);


ALTER TABLE public.parents OWNER TO postgres;

--
-- Name: parents_parent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parents_parent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parents_parent_id_seq OWNER TO postgres;

--
-- Name: parents_parent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parents_parent_id_seq OWNED BY public.parents.parent_id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    permission_id integer NOT NULL,
    permission_name character varying(100) NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_permission_id_seq OWNER TO postgres;

--
-- Name: permissions_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_permission_id_seq OWNED BY public.permissions.permission_id;


--
-- Name: procurements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procurements (
    procurement_id integer NOT NULL,
    item_id integer,
    supplier_id integer,
    unit_cost numeric(10,2) NOT NULL,
    quantity integer NOT NULL,
    total_cost numeric(12,2) NOT NULL,
    procurement_date date DEFAULT CURRENT_DATE,
    brought_by character varying(100),
    received_by integer,
    received_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'active'::character varying
);


ALTER TABLE public.procurements OWNER TO postgres;

--
-- Name: procurements_procurement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.procurements_procurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.procurements_procurement_id_seq OWNER TO postgres;

--
-- Name: procurements_procurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.procurements_procurement_id_seq OWNED BY public.procurements.procurement_id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_id integer NOT NULL,
    room_name character varying(50) NOT NULL
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rooms_room_id_seq OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_room_id_seq OWNED BY public.rooms.room_id;


--
-- Name: semesters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semesters (
    semester_id integer NOT NULL,
    semester_name character varying(50) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status character varying(30) DEFAULT 'inactive'::character varying
);


ALTER TABLE public.semesters OWNER TO postgres;

--
-- Name: semesters_semester_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semesters_semester_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.semesters_semester_id_seq OWNER TO postgres;

--
-- Name: semesters_semester_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semesters_semester_id_seq OWNED BY public.semesters.semester_id;


--
-- Name: sms_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sms_logs (
    id integer NOT NULL,
    recipient_type character varying(50),
    message_type character varying(50),
    sender_id integer,
    recipients_id integer[],
    message_content text,
    total_attempeted integer,
    total_invalid_numbers integer,
    total_successful integer,
    total_failed integer,
    successful_recipients_ids integer[],
    failed_receipients_ids integer[],
    invalid_recipients_ids integer[],
    invalid_recippients_phone text[],
    api_response jsonb,
    send_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_sms_used integer
);


ALTER TABLE public.sms_logs OWNER TO postgres;

--
-- Name: sms_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sms_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_logs_id_seq OWNER TO postgres;

--
-- Name: sms_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sms_logs_id_seq OWNED BY public.sms_logs.id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    staff_id integer NOT NULL,
    user_id integer,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    middle_name character varying(50),
    date_of_birth date,
    gender character(1),
    marital_status character varying(20),
    address text,
    phone_number character varying(20),
    email character varying(100),
    emergency_contact character varying(100),
    date_of_joining date,
    designation character varying(50),
    department character varying(50),
    salary numeric(10,2),
    account_number character varying(30),
    contract_type character varying(50),
    employment_status character varying(50),
    qualification text,
    experience text,
    blood_group character varying(5),
    national_id character varying(50),
    passport_number character varying(20),
    photo text,
    teaching_subject character varying(50),
    class_teacher boolean,
    subject_in_charge boolean,
    house_in_charge boolean,
    bus_in_charge boolean,
    library_in_charge boolean,
    status character varying DEFAULT 'active'::character varying,
    role character varying(50) DEFAULT 'teaching staff'::character varying
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: staff_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.staff_staff_id_seq OWNER TO postgres;

--
-- Name: staff_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_staff_id_seq OWNED BY public.staff.staff_id;


--
-- Name: student_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_grades (
    grade_id integer NOT NULL,
    student_id integer,
    subject_id integer,
    class_id integer,
    user_id integer,
    gradescheme_id integer,
    semester_id integer,
    class_score numeric(5,2),
    exams_score numeric(5,2),
    total_score numeric(5,2),
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.student_grades OWNER TO postgres;

--
-- Name: student_grades_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_grades_grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_grades_grade_id_seq OWNER TO postgres;

--
-- Name: student_grades_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_grades_grade_id_seq OWNED BY public.student_grades.grade_id;


--
-- Name: student_parent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_parent (
    student_id integer NOT NULL,
    parent_id integer NOT NULL,
    relationship character varying(50),
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE public.student_parent OWNER TO postgres;

--
-- Name: student_remarks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_remarks (
    remark_id integer NOT NULL,
    student_id integer,
    class_id integer,
    semester_id integer,
    user_id integer,
    class_teachers_remark text,
    headteachers_remark text,
    remark_date date DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.student_remarks OWNER TO postgres;

--
-- Name: student_remarks_remark_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_remarks_remark_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_remarks_remark_id_seq OWNER TO postgres;

--
-- Name: student_remarks_remark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_remarks_remark_id_seq OWNED BY public.student_remarks.remark_id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    photo text,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    other_names character varying(50),
    date_of_birth date NOT NULL,
    gender character varying(10),
    class_id integer,
    amountowed numeric(10,2),
    residential_address text,
    phone character varying(20),
    email character varying(100),
    enrollment_date date NOT NULL,
    national_id character varying(15),
    birth_cert_id character varying(20),
    role character varying(20) DEFAULT 'student'::character varying,
    user_id integer,
    status character varying DEFAULT 'active'::character varying,
    class_promoted_to integer
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_student_id_seq OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    subject_id integer NOT NULL,
    subject_name character varying(100) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- Name: subjects_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subjects_subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subjects_subject_id_seq OWNER TO postgres;

--
-- Name: subjects_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subjects_subject_id_seq OWNED BY public.subjects.subject_id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplier_id integer NOT NULL,
    supplier_name character varying(100) NOT NULL,
    contact_name character varying(100),
    contact_phone character varying(30),
    contact_email character varying(100),
    address text,
    details text,
    status character varying DEFAULT 'active'::character varying
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_supplier_id_seq OWNER TO postgres;

--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_supplier_id_seq OWNED BY public.suppliers.supplier_id;


--
-- Name: timetable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.timetable (
    timetable_id integer NOT NULL,
    class_id integer,
    subject_id integer,
    teacher_id integer,
    room_id integer,
    day_of_week character varying(10),
    period_number integer,
    start_time time without time zone,
    end_time time without time zone,
    semester_id integer
);


ALTER TABLE public.timetable OWNER TO postgres;

--
-- Name: timetable_timetable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.timetable_timetable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.timetable_timetable_id_seq OWNER TO postgres;

--
-- Name: timetable_timetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.timetable_timetable_id_seq OWNED BY public.timetable.timetable_id;


--
-- Name: user_health_record; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_health_record (
    user_id integer NOT NULL,
    medical_conditions text,
    allergies text,
    blood_group character varying(8),
    vaccination_status text,
    last_physical_exam_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    health_insurance_id character varying(20),
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE public.user_health_record OWNER TO postgres;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    user_name character varying(100) NOT NULL,
    user_email character varying(50),
    role character varying(20) DEFAULT 'user'::character varying,
    status character varying(20) DEFAULT 'active'::character varying,
    password character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: attendance attendance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendance_attendance_id_seq'::regclass);


--
-- Name: balance_adjustment_log log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_adjustment_log ALTER COLUMN log_id SET DEFAULT nextval('public.balance_adjustment_log_log_id_seq'::regclass);


--
-- Name: class_items class_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_items ALTER COLUMN class_item_id SET DEFAULT nextval('public.class_items_class_item_id_seq'::regclass);


--
-- Name: classes class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN class_id SET DEFAULT nextval('public.classes_class_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- Name: evaluations evaluation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations ALTER COLUMN evaluation_id SET DEFAULT nextval('public.evaluations_evaluation_id_seq'::regclass);


--
-- Name: events event_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN event_id SET DEFAULT nextval('public.events_event_id_seq'::regclass);


--
-- Name: expenses expense_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses ALTER COLUMN expense_id SET DEFAULT nextval('public.expenses_expense_id_seq'::regclass);


--
-- Name: fee_collections collection_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_collections ALTER COLUMN collection_id SET DEFAULT nextval('public.fee_collections_collection_id_seq'::regclass);


--
-- Name: feeding_fee_payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_fee_payments ALTER COLUMN id SET DEFAULT nextval('public.feeding_fee_payments_id_seq'::regclass);


--
-- Name: grading_scheme gradescheme_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_scheme ALTER COLUMN gradescheme_id SET DEFAULT nextval('public.grading_scheme_grade_id_seq'::regclass);


--
-- Name: health_incident incident_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_incident ALTER COLUMN incident_id SET DEFAULT nextval('public.health_incident_incident_id_seq'::regclass);


--
-- Name: inventory_items inventory_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items ALTER COLUMN inventory_id SET DEFAULT nextval('public.inventory_items_inventory_id_seq'::regclass);


--
-- Name: invoices invoice_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices ALTER COLUMN invoice_id SET DEFAULT nextval('public.invoices_invoice_id_seq'::regclass);


--
-- Name: items item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items ALTER COLUMN item_id SET DEFAULT nextval('public.items_item_id_seq'::regclass);


--
-- Name: items_movement supply_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_movement ALTER COLUMN supply_id SET DEFAULT nextval('public.items_movement_supply_id_seq'::regclass);


--
-- Name: items_supply supply_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_supply ALTER COLUMN supply_id SET DEFAULT nextval('public.items_supply_supply_id_seq'::regclass);


--
-- Name: notification_recipients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_recipients ALTER COLUMN id SET DEFAULT nextval('public.notification_recipients_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: parents parent_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents ALTER COLUMN parent_id SET DEFAULT nextval('public.parents_parent_id_seq'::regclass);


--
-- Name: permissions permission_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN permission_id SET DEFAULT nextval('public.permissions_permission_id_seq'::regclass);


--
-- Name: procurements procurement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurements ALTER COLUMN procurement_id SET DEFAULT nextval('public.procurements_procurement_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: rooms room_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN room_id SET DEFAULT nextval('public.rooms_room_id_seq'::regclass);


--
-- Name: semesters semester_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters ALTER COLUMN semester_id SET DEFAULT nextval('public.semesters_semester_id_seq'::regclass);


--
-- Name: sms_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms_logs ALTER COLUMN id SET DEFAULT nextval('public.sms_logs_id_seq'::regclass);


--
-- Name: staff staff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN staff_id SET DEFAULT nextval('public.staff_staff_id_seq'::regclass);


--
-- Name: student_grades grade_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades ALTER COLUMN grade_id SET DEFAULT nextval('public.student_grades_grade_id_seq'::regclass);


--
-- Name: student_remarks remark_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_remarks ALTER COLUMN remark_id SET DEFAULT nextval('public.student_remarks_remark_id_seq'::regclass);


--
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- Name: subjects subject_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects ALTER COLUMN subject_id SET DEFAULT nextval('public.subjects_subject_id_seq'::regclass);


--
-- Name: suppliers supplier_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN supplier_id SET DEFAULT nextval('public.suppliers_supplier_id_seq'::regclass);


--
-- Name: timetable timetable_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable ALTER COLUMN timetable_id SET DEFAULT nextval('public.timetable_timetable_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (attendance_id, student_id, class_id, attendance_date, status, semester_id, staff_id) FROM stdin;
\.


--
-- Data for Name: balance_adjustment_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.balance_adjustment_log (log_id, student_id, amount_adjusted, reason, adjusted_at) FROM stdin;
\.


--
-- Data for Name: class_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class_items (class_item_id, class_id, item_id, semester_id, quantity_per_student, supplied_by, assigned_at, status) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (class_id, class_name, class_level, capacity, room_name, staff_id, status, created_at, updated_at) FROM stdin;
1	completed	completed	\N	\N	\N	active	2025-01-09 00:33:52.623152+00	2025-01-09 00:33:52.623152+00
13	Nursery 1A	Pre School	30		17	active	2025-01-11 11:12:52.695076+00	2025-01-11 11:12:52.695076+00
14	Nursery 1B 	Pre School	30		17	active	2025-01-11 11:13:26.879412+00	2025-01-11 11:13:26.879412+00
15	Nursery 2A	Pre School	30		17	active	2025-01-11 11:14:39.325905+00	2025-01-11 11:14:39.325905+00
16	Nursery 2B	Pre School	30		17	active	2025-01-11 11:15:01.808226+00	2025-01-11 11:15:01.808226+00
18	Nursery 2C	Pre School	30		17	active	2025-01-11 11:15:48.435129+00	2025-01-11 11:15:48.435129+00
17	Nursery 2C 	Pre School	30		17	deleted	2025-01-11 11:15:21.609646+00	2025-01-11 11:15:21.609646+00
19	KG 1A	Pre School	30		17	active	2025-01-11 11:17:28.50707+00	2025-01-11 11:17:28.50707+00
20	KG 1B	Pre School	30		17	active	2025-01-11 11:18:02.595046+00	2025-01-11 11:18:02.595046+00
21	KG 1C	Pre School	30		17	active	2025-01-11 11:18:48.254043+00	2025-01-11 11:18:48.254043+00
22	KG 2A	Pre School	30		17	active	2025-01-11 11:19:09.971665+00	2025-01-11 11:19:09.971665+00
23	KG 2B	Pre School	30		17	active	2025-01-11 11:24:24.951992+00	2025-01-11 11:24:24.951992+00
24	KG 2C 	Pre School	30		17	active	2025-01-11 11:24:58.931507+00	2025-01-11 11:24:58.931507+00
25	BS 1A	Primary	30		17	active	2025-01-11 11:25:46.230972+00	2025-01-11 11:25:46.230972+00
27	BS 1C 	Primary	30		17	active	2025-01-11 11:26:50.19139+00	2025-01-11 11:26:50.19139+00
28	BS 2A 	Primary	30		17	active	2025-01-11 11:27:14.048451+00	2025-01-11 11:27:14.048451+00
30	BS 2C 	Primary	30		17	active	2025-01-11 11:28:10.593273+00	2025-01-11 11:28:10.593273+00
31	BS 3A 	Primary	30		17	active	2025-01-11 11:28:39.102402+00	2025-01-11 11:28:39.102402+00
32	BS 3B 	Primary	30		17	active	2025-01-11 11:29:04.23869+00	2025-01-11 11:29:04.23869+00
33	BS 3C 	Primary	30		17	active	2025-01-11 11:29:26.154957+00	2025-01-11 11:29:26.154957+00
34	BS 4A 	Primary	30		17	active	2025-01-11 11:29:55.700601+00	2025-01-11 11:29:55.700601+00
35	BS 4B 	Primary	30		17	active	2025-01-11 11:31:12.416794+00	2025-01-11 11:31:12.416794+00
36	BS 4C 	Primary	30		17	active	2025-01-11 11:31:45.15778+00	2025-01-11 11:31:45.15778+00
37	BS 5A 	Primary	30		17	active	2025-01-11 11:32:19.728214+00	2025-01-11 11:32:19.728214+00
38	BS 5B 	Primary	30		17	active	2025-01-11 11:32:56.959971+00	2025-01-11 11:32:56.959971+00
39	BS 5C	Primary	30		17	active	2025-01-11 11:33:21.428382+00	2025-01-11 11:33:21.428382+00
40	BS 6A 	Primary	30		17	active	2025-01-11 11:33:41.230006+00	2025-01-11 11:33:41.230006+00
41	BS 6B 	Primary	30		17	active	2025-01-11 11:34:02.464148+00	2025-01-11 11:34:02.464148+00
42	BS 6C 	Primary	30		17	active	2025-01-11 11:34:20.12055+00	2025-01-11 11:34:20.12055+00
26	BS 1B	Primary	30		19	active	2025-01-11 11:26:02.322704+00	2025-01-11 11:26:02.322704+00
47	BS 9A	JHS	30		21	active	2025-01-11 11:36:56.158235+00	2025-01-11 11:36:56.158235+00
29	BS 2B 	Primary	30		36	active	2025-01-11 11:27:43.766222+00	2025-01-11 11:27:43.766222+00
44	BS 7B 	JHS	30		45	active	2025-01-11 11:36:01.01242+00	2025-01-11 11:36:01.01242+00
45	BS 8A 	JHS	30		43	active	2025-01-11 11:36:17.47492+00	2025-01-11 11:36:17.47492+00
46	BS 8B 	JHS	30		46	active	2025-01-11 11:36:34.498241+00	2025-01-11 11:36:34.498241+00
48	BS 9B 	JHS	30		20	active	2025-01-11 11:37:16.147981+00	2025-01-11 11:37:16.147981+00
43	BS 7A	JHS	30		44	active	2025-01-11 11:35:29.692474+00	2025-01-11 11:35:29.692474+00
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (department_id, department_name, head_of_department, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: evaluations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evaluations (evaluation_id, evaluatee_id, evaluation_date, teaching_effectiveness, classroom_management, student_engagement, professionalism, comments, years_of_experience, evaluator_id, created_at, status) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (event_id, event_title, event_date, start_time, end_time, location, description, event_type, target_audience, created_at, status, user_id, updated_at) FROM stdin;
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expenses (expense_id, recipient_name, expense_category, description, amount, expense_date, invoice_number, supplier_id, staff_id, user_id, created_at) FROM stdin;
\.


--
-- Data for Name: fee_collections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fee_collections (collection_id, student_id, payment_date, amount_received, old_balance, new_balance, fee_type, payment_mode, status, created_at, received_by, comment) FROM stdin;
\.


--
-- Data for Name: feeding_fee_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feeding_fee_payments (id, student_id, class_id, collected_by, feeding_fee, valid_until_feeding, transport_fee, valid_until_transport, total_fee, semester_id, payment_date) FROM stdin;
\.


--
-- Data for Name: feeding_transport_fees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feeding_transport_fees (student_id, transportation_method, pick_up_point, feeding_fee, transport_fee) FROM stdin;
7	School Bus	grater grace 	5.00	3.00
8	By self	ROUNDABOUT	5.00	4.00
9	By self		0.00	0.00
10	By self		0.00	0.00
11	By self		0.00	0.00
12	School Bus	roundabout	0.00	0.00
13	School Bus	Come Down, Apam 	0.00	0.00
14	School Bus	MUMFORD	0.00	0.00
15	By self		0.00	0.00
16	School Bus	MUMFORD	5.00	4.00
17	School Bus	Nsuekyir, Apam 	0.00	0.00
18	By self		5.00	0.00
19	By self		0.00	0.00
20	School Bus	Ankamu	0.00	0.00
21	By self		0.00	0.00
22			0.00	0.00
23	By self		0.00	0.00
24			0.00	0.00
25	School Bus	Salvation	0.00	0.00
26	By self		0.00	0.00
27	By self		0.00	0.00
28			0.00	0.00
29	By self		0.00	0.00
30	School Bus	Mumford 	0.00	0.00
31			0.00	0.00
32	By self		0.00	0.00
33	School Bus	Apam junction 	0.00	0.00
34	By self		0.00	0.00
35	School Bus	MUMFORD	0.00	0.00
36	School Bus	Apam junction 	0.00	0.00
37	By self		0.00	0.00
38	School Bus	Hospital	0.00	0.00
39	By self		0.00	0.00
40	School Bus	Mumford 	0.00	0.00
41	By self		0.00	0.00
42	By self		0.00	0.00
43	By self		0.00	0.00
44	By self		0.00	0.00
45	By self		0.00	0.00
46	By self		0.00	0.00
47	School Bus	Filling  Station	0.00	0.00
48	School Bus	Mumford 	0.00	0.00
49	School Bus	Mumford 	0.00	0.00
50	School Bus	Apam Junction 	0.00	0.00
51	By self		0.00	0.00
52	By self		0.00	0.00
53	By self		0.00	0.00
54	By self		0.00	0.00
55	School Bus	Roundabout	0.00	0.00
56	School Bus	Nsuekyir 	0.00	0.00
57	By self		0.00	0.00
58	School Bus	Apam junction 	0.00	0.00
59	By self		0.00	0.00
60	By self		0.00	0.00
61	By self		0.00	0.00
62	School Bus	Nsuekyir 	0.00	0.00
63	By self		0.00	0.00
64	By self		0.00	0.00
65	By self		0.00	0.00
66			0.00	0.00
67	School Bus	Apam junction 	0.00	0.00
68	By self		0.00	0.00
69	By self		0.00	0.00
70	By self		0.00	0.00
71	By self		0.00	0.00
72			0.00	0.00
73	By self		0.00	0.00
74	School Bus	Come Down, Apam 	0.00	0.00
75			0.00	0.00
76	By self		0.00	0.00
77	School Bus	Mumford	0.00	0.00
78	Parent Drop-off		0.00	0.00
79	School Bus	Apam round about	0.00	0.00
80			0.00	0.00
81	School Bus	Mumford 	0.00	0.00
82	By self		0.00	0.00
83	School Bus	Mumford	0.00	0.00
84			0.00	0.00
85	School Bus	Mumford	0.00	0.00
86	School Bus	Hospital	0.00	0.00
87	By self		0.00	0.00
88	School Bus	Mamfam 	0.00	0.00
89	School Bus	Mumford 	0.00	0.00
90	School Bus	Methodist School 	0.00	0.00
91	By self		0.00	0.00
92	School Bus	Salvation	0.00	0.00
93	School Bus	Abaakwa	0.00	0.00
94			0.00	0.00
95	School Bus	Apam-Hospital	0.00	0.00
96	School Bus	Mumford station	0.00	0.00
97	School Bus	Mumford station	0.00	0.00
98	School Bus	Akamu	0.00	0.00
99	School Bus	Methodist school	0.00	0.00
100	Parent Drop-off		0.00	0.00
101	School Bus	Mumford	0.00	0.00
102	By self		0.00	0.00
103	School Bus	Mumford station	0.00	0.00
104	By self		0.00	0.00
105	School Bus	Salvation	0.00	0.00
106	By self		0.00	0.00
107	By self		0.00	0.00
108	School Bus	Nsuekyire	0.00	0.00
109	School Bus	Akamu	0.00	0.00
110	School Bus	Apam junction	0.00	0.00
111	School Bus	Bomboa old police headquarters	0.00	0.00
112	Parent Drop-off		0.00	0.00
113	School Bus	Mumford	0.00	0.00
114	By self		0.00	0.00
115	School Bus	Abaakwa junction	0.00	0.00
116	School Bus	Hospital	0.00	0.00
117	By self		0.00	0.00
118	School Bus	Mumford rasta junction	0.00	0.00
119	School Bus	Hospital	0.00	0.00
120	By self		0.00	0.00
121	By self		0.00	0.00
122	By self		0.00	0.00
123	School Bus	Agya Appiah junction	0.00	0.00
124	School Bus	Mumford-Methodist school park	0.00	0.00
125	School Bus	Salvation	0.00	0.00
126	School Bus	Salvation	0.00	0.00
127	School Bus	Bomboa latex foam	0.00	0.00
128	School Bus	Mumford station	0.00	0.00
129	School Bus	Apam filling station	0.00	0.00
130	School Bus	Nsuekyire Obronyi kofi	0.00	0.00
131	School Bus	Apam filling station	0.00	0.00
132	School Bus	Apam filling station	0.00	0.00
133	School Bus	Apam junction	0.00	0.00
134	By self		0.00	0.00
135			0.00	0.00
136	School Bus	Bifirst junction	0.00	0.00
137	School Bus	Mumford station	0.00	0.00
138	School Bus	Apam junction	0.00	0.00
139	School Bus	Apam junction 	0.00	0.00
140	School Bus	Mumford station	0.00	0.00
141	School Bus	Apam filling station	0.00	0.00
142	Parent Drop-off		0.00	0.00
143	School Bus	Apam Nsuekyir 	0.00	0.00
144	School Bus	Apam round about	0.00	0.00
145	School Bus	Later foam	0.00	0.00
146	School Bus	Benyaedzi	0.00	0.00
147			0.00	0.00
148	School Bus	Apam junction 	0.00	0.00
149	By self		0.00	0.00
150	By self		0.00	0.00
151	By self		0.00	0.00
152	By self		0.00	0.00
153	By self		0.00	0.00
154			0.00	0.00
155	By self		0.00	0.00
156	School Bus	Apam filling station	0.00	0.00
157	School Bus	Mumford 	0.00	0.00
158	School Bus	Apam hospital 	0.00	0.00
159	School Bus	Nsuekyir	0.00	0.00
160	By self		0.00	0.00
161	School Bus	Mumford 	0.00	0.00
162	School Bus	Apam hospital 	0.00	0.00
163	School Bus	Nsuekyir	0.00	0.00
164	School Bus	Apam nsuekyir	0.00	0.00
165			0.00	0.00
166	By self		0.00	0.00
167			0.00	0.00
168	School Bus	Mumford 	0.00	0.00
169	School Bus	Abaakwa	0.00	0.00
170	School Bus	Mumford 	0.00	0.00
171	By self		0.00	0.00
172	By self		0.00	0.00
173	School Bus	Nsuekyir	0.00	0.00
174	Parent Drop-off		0.00	0.00
175	School Bus	Nsuekyir	0.00	0.00
176	Parent Drop-off		0.00	0.00
177	School Bus	Apam junction 	0.00	0.00
178	Parent Drop-off		0.00	0.00
179	By self		0.00	0.00
180	By self		0.00	0.00
181	By self		0.00	0.00
182	School Bus	Mumford 	0.00	0.00
183	By self		0.00	0.00
184	School Bus	Mumford 	0.00	0.00
185	Parent Drop-off		0.00	0.00
186	Parent Drop-off		0.00	0.00
187	School Bus	Abaakwa	0.00	0.00
188	School Bus	Nsuekyir	0.00	0.00
189	School Bus	Bomboa	0.00	0.00
190	School Bus	Mumford 	0.00	0.00
191	School Bus	Tema Yaa	0.00	0.00
192			0.00	0.00
193			0.00	0.00
194			0.00	0.00
195	By self		0.00	0.00
197	School Bus	Filling station 	0.00	0.00
198	School Bus	Mumford	0.00	0.00
199	School Bus	Asafo Dan ho	0.00	0.00
200	By self		0.00	0.00
201	School Bus	Mumford 	0.00	0.00
202	School Bus	Akamu	0.00	0.00
203	School Bus	Filling station 	0.00	0.00
204	By self		0.00	0.00
205	By self		0.00	0.00
206	School Bus	Egyapaado	0.00	0.00
207	School Bus	Filling station	0.00	0.00
208			0.00	0.00
209	By self		0.00	0.00
210	School Bus	Methodist 	0.00	0.00
211	School Bus	Mumford 	0.00	0.00
212	School Bus	Nsuekyir	0.00	0.00
213	By self		0.00	0.00
214	School Bus	Mumford	0.00	0.00
215	By self		0.00	0.00
216	School Bus	Round about	0.00	0.00
217	School Bus	Come down	0.00	0.00
218	By self		0.00	0.00
219	School Bus	Mumford	0.00	0.00
220	School Bus	Apam Junction 	0.00	0.00
221	By self		0.00	0.00
222	School Bus	Mumford 	0.00	0.00
223	School Bus	Abaakwaa	0.00	0.00
224	School Bus	Hospital 	0.00	0.00
225	School Bus	Round about	0.00	0.00
226	School Bus	Abaakwaa	0.00	0.00
227	School Bus	Filling station 	0.00	0.00
228	School Bus	Apam Junction 	0.00	0.00
229	School Bus	Asafo Dan ho	0.00	0.00
230	School Bus	Nsuekyire 	0.00	0.00
231	School Bus	Bomboa	0.00	0.00
232			0.00	0.00
233	School Bus	roundabout	0.00	0.00
234	School Bus	Ultimate	0.00	0.00
235	School Bus	Old police headquarters	0.00	0.00
236	By self		0.00	0.00
237	By self		0.00	0.00
238	By self		0.00	0.00
239	School Bus	Nsuekyir	0.00	0.00
240	School Bus	Akamu	0.00	0.00
241			0.00	0.00
242	By self		0.00	0.00
243	School Bus	Filling  Station	0.00	0.00
244	School Bus	Akamu	0.00	0.00
245	School Bus	Akamu	0.00	0.00
246	School Bus	roundabout	0.00	0.00
248	By self		0.00	0.00
249	School Bus	Nsuekyir	0.00	0.00
247	By self		0.00	0.00
196	School Bus	Ankamu	0.00	0.00
250	School Bus	Hospital	0.00	0.00
251	By self		0.00	0.00
252	School Bus	Abaakwaa	0.00	0.00
253	By self		0.00	0.00
254	By self		0.00	0.00
255	School Bus	Ankamu	0.00	0.00
256	School Bus	Nsuekyir	0.00	0.00
257	School Bus	Nsuekyir	0.00	0.00
258	By self		0.00	0.00
259	By self		0.00	0.00
260	School Bus	Ankamu	0.00	0.00
261	School Bus	roundabout	0.00	0.00
262	By self		0.00	0.00
263	School Bus	Mumford	0.00	0.00
264	By self		0.00	0.00
265	By self		0.00	0.00
266	By self		0.00	0.00
267	School Bus	Mamfam	0.00	0.00
268	School Bus	Mumford	5.00	6.00
269	By self		5.00	0.00
270	School Bus	Ankamu	5.00	5.00
271	School Bus	Ankamu	5.00	5.00
272	School Bus	Bomboa	5.00	5.00
273	School Bus	Hospital	5.00	5.00
\.


--
-- Data for Name: grading_scheme; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grading_scheme (gradescheme_id, grade_name, minimum_mark, maximum_mark, grade_remark, status) FROM stdin;
3	Grade 1	90.00	100.00	Highest	active
4	Grade 2 	80.00	89.00	Higher	active
5	Grade 3	70.00	79.00	High	active
6	Grade 4	60.00	69.00	High Average	active
7	Grade 5	55.00	59.00	Average	active
8	Grade 6	50.00	54.00	Low Average	active
9	Grade 7	40.00	49.00	Credit	active
10	Grade 8	35.00	39.00	Pass	active
11	Grade 9	0.00	34.00	Fail	active
\.


--
-- Data for Name: health_incident; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.health_incident (incident_id, incident_date, incident_description, treatmentprovided, user_id) FROM stdin;
\.


--
-- Data for Name: inventory_class_semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_class_semester (inventory_id, class_id, semester_id) FROM stdin;
\.


--
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_items (inventory_id, inventory_name, unit_price, quantity_per_student, total_price, restock_level, status) FROM stdin;
\.


--
-- Data for Name: invoice_class_semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_class_semester (invoice_id, class_id, semester_id) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (invoice_id, amount, description, created_at, status) FROM stdin;
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (item_id, item_name, category, description, unit_price, quantity_desired, quantity_available, restock_level, status) FROM stdin;
\.


--
-- Data for Name: items_movement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_movement (supply_id, staff_id, recipient_name, recipient_phone, comments, item_id, quantity, supplied_by, supplied_at, status, movement_type, returned_at) FROM stdin;
\.


--
-- Data for Name: items_supply; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_supply (supply_id, student_id, item_id, quantity, supplied_by, supplied_at, semester_id, class_id, status) FROM stdin;
\.


--
-- Data for Name: notification_recipients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_recipients (id, notification_id, recipient_id, recipient_type, is_read, read_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, notification_title, notification_message, notification_type, priority, sender_id, sent_at, is_read, status, created_at) FROM stdin;
89	New Staff Added	A new staff(Alex) has joined the school.	general	normal	1	2025-01-11 11:08:15.793127	f	active	2025-01-11 11:08:15.793127
90	New Class Added	A new class "Nursery 1A" has been added to the system.	general	normal	1	2025-01-11 11:12:52.695076	f	active	2025-01-11 11:12:52.695076
91	New Class Added	A new class "Nursery 1B " has been added to the system.	general	normal	1	2025-01-11 11:13:26.879412	f	active	2025-01-11 11:13:26.879412
92	New Class Added	A new class "Nursery 2A" has been added to the system.	general	normal	1	2025-01-11 11:14:39.325905	f	active	2025-01-11 11:14:39.325905
93	New Class Added	A new class "Nursery 2B" has been added to the system.	general	normal	1	2025-01-11 11:15:01.808226	f	active	2025-01-11 11:15:01.808226
94	New Class Added	A new class "Nursery 2C " has been added to the system.	general	normal	1	2025-01-11 11:15:21.609646	f	active	2025-01-11 11:15:21.609646
95	New Class Added	A new class "Nursery 2C" has been added to the system.	general	normal	1	2025-01-11 11:15:48.435129	f	active	2025-01-11 11:15:48.435129
96	Class Removed	Class Nursery 2C  has been removed from the system.	general	normal	1	2025-01-11 11:16:55.349618	f	active	2025-01-11 11:16:55.349618
97	New Class Added	A new class "KG 1A" has been added to the system.	general	normal	1	2025-01-11 11:17:28.50707	f	active	2025-01-11 11:17:28.50707
98	New Class Added	A new class "KG 1B" has been added to the system.	general	normal	1	2025-01-11 11:18:02.595046	f	active	2025-01-11 11:18:02.595046
99	New Class Added	A new class "KG 1C" has been added to the system.	general	normal	1	2025-01-11 11:18:48.254043	f	active	2025-01-11 11:18:48.254043
100	New Class Added	A new class "KG 2A" has been added to the system.	general	normal	1	2025-01-11 11:19:09.971665	f	active	2025-01-11 11:19:09.971665
101	New Class Added	A new class "KG 2B" has been added to the system.	general	normal	1	2025-01-11 11:24:24.951992	f	active	2025-01-11 11:24:24.951992
102	New Class Added	A new class "KG 2C " has been added to the system.	general	normal	1	2025-01-11 11:24:58.931507	f	active	2025-01-11 11:24:58.931507
103	New Class Added	A new class "BS 1A" has been added to the system.	general	normal	1	2025-01-11 11:25:46.230972	f	active	2025-01-11 11:25:46.230972
104	New Class Added	A new class "BS 1B" has been added to the system.	general	normal	1	2025-01-11 11:26:02.322704	f	active	2025-01-11 11:26:02.322704
105	New Class Added	A new class "BS 1C " has been added to the system.	general	normal	1	2025-01-11 11:26:50.19139	f	active	2025-01-11 11:26:50.19139
106	New Class Added	A new class "BS 2A " has been added to the system.	general	normal	1	2025-01-11 11:27:14.048451	f	active	2025-01-11 11:27:14.048451
107	New Class Added	A new class "BS 2B " has been added to the system.	general	normal	1	2025-01-11 11:27:43.766222	f	active	2025-01-11 11:27:43.766222
108	New Class Added	A new class "BS 2C " has been added to the system.	general	normal	1	2025-01-11 11:28:10.593273	f	active	2025-01-11 11:28:10.593273
109	New Class Added	A new class "BS 3A " has been added to the system.	general	normal	1	2025-01-11 11:28:39.102402	f	active	2025-01-11 11:28:39.102402
110	New Class Added	A new class "BS 3B " has been added to the system.	general	normal	1	2025-01-11 11:29:04.23869	f	active	2025-01-11 11:29:04.23869
111	New Class Added	A new class "BS 3C " has been added to the system.	general	normal	1	2025-01-11 11:29:26.154957	f	active	2025-01-11 11:29:26.154957
112	New Class Added	A new class "BS 4A " has been added to the system.	general	normal	1	2025-01-11 11:29:55.700601	f	active	2025-01-11 11:29:55.700601
113	New Class Added	A new class "BS 4B " has been added to the system.	general	normal	1	2025-01-11 11:31:12.416794	f	active	2025-01-11 11:31:12.416794
114	New Class Added	A new class "BS 4C " has been added to the system.	general	normal	1	2025-01-11 11:31:45.15778	f	active	2025-01-11 11:31:45.15778
115	New Class Added	A new class "BS 5A " has been added to the system.	general	normal	1	2025-01-11 11:32:19.728214	f	active	2025-01-11 11:32:19.728214
116	New Class Added	A new class "BS 5B " has been added to the system.	general	normal	1	2025-01-11 11:32:56.959971	f	active	2025-01-11 11:32:56.959971
117	New Class Added	A new class "BS 5C" has been added to the system.	general	normal	1	2025-01-11 11:33:21.428382	f	active	2025-01-11 11:33:21.428382
118	New Class Added	A new class "BS 6A " has been added to the system.	general	normal	1	2025-01-11 11:33:41.230006	f	active	2025-01-11 11:33:41.230006
119	New Class Added	A new class "BS 6B " has been added to the system.	general	normal	1	2025-01-11 11:34:02.464148	f	active	2025-01-11 11:34:02.464148
120	New Class Added	A new class "BS 6C " has been added to the system.	general	normal	1	2025-01-11 11:34:20.12055	f	active	2025-01-11 11:34:20.12055
121	New Class Added	A new class "BS 7A" has been added to the system.	general	normal	1	2025-01-11 11:35:29.692474	f	active	2025-01-11 11:35:29.692474
122	New Class Added	A new class "BS 7B " has been added to the system.	general	normal	1	2025-01-11 11:36:01.01242	f	active	2025-01-11 11:36:01.01242
123	New Class Added	A new class "BS 8A " has been added to the system.	general	normal	1	2025-01-11 11:36:17.47492	f	active	2025-01-11 11:36:17.47492
124	New Class Added	A new class "BS 8B " has been added to the system.	general	normal	1	2025-01-11 11:36:34.498241	f	active	2025-01-11 11:36:34.498241
125	New Class Added	A new class "BS 9A" has been added to the system.	general	normal	1	2025-01-11 11:36:56.158235	f	active	2025-01-11 11:36:56.158235
126	New Class Added	A new class "BS 9B " has been added to the system.	general	normal	1	2025-01-11 11:37:16.147981	f	active	2025-01-11 11:37:16.147981
127	New Student Registration	A new student Christiana  Acquah has been registered with ID: 7	student	normal	51	2025-01-11 12:12:25.451746	f	active	2025-01-11 12:12:25.451746
128	New Staff Added	A new staff(Obed) has joined the school.	general	normal	1	2025-01-13 15:37:06.315031	f	active	2025-01-13 15:37:06.315031
129	New Staff Added	A new staff(Veronica) has joined the school.	general	normal	54	2025-01-13 16:03:02.988544	f	active	2025-01-13 16:03:02.988544
130	New Staff Added	A new staff(Isaac) has joined the school.	general	normal	54	2025-01-13 16:16:54.040653	f	active	2025-01-13 16:16:54.040653
131	New Staff Added	A new staff(Isaac) has joined the school.	general	normal	54	2025-01-13 16:22:15.40596	f	active	2025-01-13 16:22:15.40596
132	New Staff Added	A new staff(Abubakar) has joined the school.	general	normal	1	2025-01-15 08:53:15.671995	f	active	2025-01-15 08:53:15.671995
133	New Staff Added	A new staff(Joseph) has joined the school.	general	normal	1	2025-01-15 08:58:52.027129	f	active	2025-01-15 08:58:52.027129
134	New Staff Added	A new staff(Joseph) has joined the school.	general	normal	1	2025-01-15 09:02:11.213263	f	active	2025-01-15 09:02:11.213263
135	New Staff Added	A new staff(Alexander) has joined the school.	general	normal	1	2025-01-15 12:44:38.20122	f	active	2025-01-15 12:44:38.20122
136	New Staff Added	A new staff(Miriam) has joined the school.	general	normal	1	2025-01-15 12:48:36.82362	f	active	2025-01-15 12:48:36.82362
137	New Staff Added	A new staff(Robert) has joined the school.	general	normal	1	2025-01-15 12:52:59.69166	f	active	2025-01-15 12:52:59.69166
138	New Staff Added	A new staff(Mercy) has joined the school.	general	normal	1	2025-01-15 13:03:54.791105	f	active	2025-01-15 13:03:54.791105
139	New Staff Added	A new staff(Kennedy ) has joined the school.	general	normal	1	2025-01-15 13:13:26.647286	f	active	2025-01-15 13:13:26.647286
140	New Staff Added	A new staff(Elizabeth) has joined the school.	general	normal	1	2025-01-15 13:25:55.719045	f	active	2025-01-15 13:25:55.719045
141	New Staff Added	A new staff(Eunice ) has joined the school.	general	normal	1	2025-01-15 13:31:58.426733	f	active	2025-01-15 13:31:58.426733
142	New Staff Added	A new staff(Janet) has joined the school.	general	normal	1	2025-01-15 13:49:42.053969	f	active	2025-01-15 13:49:42.053969
143	New Staff Added	A new staff(Ebenezer) has joined the school.	general	normal	1	2025-01-15 13:59:13.379257	f	active	2025-01-15 13:59:13.379257
144	New Staff Added	A new staff(Mary) has joined the school.	general	normal	1	2025-01-15 14:08:22.741912	f	active	2025-01-15 14:08:22.741912
145	New Staff Added	A new staff(Mary) has joined the school.	general	normal	1	2025-01-15 14:15:20.557321	f	active	2025-01-15 14:15:20.557321
146	New Staff Added	A new staff(Obed) has joined the school.	general	normal	1	2025-01-16 07:39:58.061362	f	active	2025-01-16 07:39:58.061362
147	New Staff Added	A new staff(Priscilla) has joined the school.	general	normal	1	2025-01-16 07:49:34.38105	f	active	2025-01-16 07:49:34.38105
148	New Staff Added	A new staff(Cecilia) has joined the school.	general	normal	1	2025-01-16 08:28:57.302988	f	active	2025-01-16 08:28:57.302988
149	New Staff Added	A new staff(Susana) has joined the school.	general	normal	1	2025-01-16 08:34:55.752231	f	active	2025-01-16 08:34:55.752231
150	New Staff Added	A new staff(Comfort) has joined the school.	general	normal	1	2025-01-16 08:37:27.954696	f	active	2025-01-16 08:37:27.954696
151	New Staff Added	A new staff(Ernestina) has joined the school.	general	normal	1	2025-01-16 08:40:48.674841	f	active	2025-01-16 08:40:48.674841
152	New Staff Added	A new staff(Ruth) has joined the school.	general	normal	1	2025-01-16 08:47:11.736915	f	active	2025-01-16 08:47:11.736915
153	New Staff Added	A new staff(George) has joined the school.	general	normal	1	2025-01-16 11:20:45.284641	f	active	2025-01-16 11:20:45.284641
154	New Staff Added	A new staff(Erica,) has joined the school.	general	normal	1	2025-01-16 11:21:21.003775	f	active	2025-01-16 11:21:21.003775
155	New Staff Added	A new staff(MICHAEL) has joined the school.	general	normal	1	2025-01-16 11:26:59.294	f	active	2025-01-16 11:26:59.294
156	New Staff Added	A new staff(Linda) has joined the school.	general	normal	1	2025-01-16 11:34:20.94074	f	active	2025-01-16 11:34:20.94074
157	New Student Registration	A new student Agbodogli Agbenyagah has been registered with ID: 8	student	normal	83	2025-01-16 13:25:23.438923	f	active	2025-01-16 13:25:23.438923
158	New Student Registration	A new student Andres Addison has been registered with ID: 9	student	normal	86	2025-01-16 13:30:56.712128	f	active	2025-01-16 13:30:56.712128
159	New Student Registration	A new student Gideon Owusu has been registered with ID: 10	student	normal	89	2025-01-16 13:32:27.661626	f	active	2025-01-16 13:32:27.661626
160	New Student Registration	A new student Godfred Abban has been registered with ID: 11	student	normal	92	2025-01-16 13:36:06.966401	f	active	2025-01-16 13:36:06.966401
161	New Student Registration	A new student John  Apostle has been registered with ID: 12	student	normal	95	2025-01-16 13:40:25.933153	f	active	2025-01-16 13:40:25.933153
162	New Student Registration	A new student Desmond  Afful has been registered with ID: 13	student	normal	98	2025-01-16 13:42:45.988234	f	active	2025-01-16 13:42:45.988234
163	New Student Registration	A new student Blessing Odoom has been registered with ID: 14	student	normal	101	2025-01-16 13:45:57.329343	f	active	2025-01-16 13:45:57.329343
164	New Student Registration	A new student Godwin Appoh has been registered with ID: 15	student	normal	104	2025-01-16 13:47:40.219982	f	active	2025-01-16 13:47:40.219982
165	New Student Registration	A new student Ewusi yankson has been registered with ID: 16	student	normal	107	2025-01-16 13:51:02.224531	f	active	2025-01-16 13:51:02.224531
166	New Student Registration	A new student Kingsford Arthur  has been registered with ID: 17	student	normal	110	2025-01-16 13:53:39.233404	f	active	2025-01-16 13:53:39.233404
167	New Student Registration	A new student Elisha  Quansah has been registered with ID: 18	student	normal	113	2025-01-16 13:56:50.986472	f	active	2025-01-16 13:56:50.986472
168	New Student Registration	A new student Jeremiah  Ayin has been registered with ID: 19	student	normal	116	2025-01-16 13:58:06.919572	f	active	2025-01-16 13:58:06.919572
169	New Student Registration	A new student Kelvin Abuakwa has been registered with ID: 20	student	normal	119	2025-01-16 13:59:01.027229	f	active	2025-01-16 13:59:01.027229
170	New Student Registration	A new student Kenneth  Bondzie has been registered with ID: 21	student	normal	122	2025-01-16 14:01:21.490716	f	active	2025-01-16 14:01:21.490716
171	New Student Registration	A new student John Arhin has been registered with ID: 22	student	normal	125	2025-01-16 14:05:40.32193	f	active	2025-01-16 14:05:40.32193
172	New Student Registration	A new student Carl Acquah has been registered with ID: 23	student	normal	128	2025-01-16 14:05:44.705545	f	active	2025-01-16 14:05:44.705545
173	New Student Registration	A new student Prince Ehun has been registered with ID: 24	student	normal	131	2025-01-16 14:05:46.310072	f	active	2025-01-16 14:05:46.310072
174	New Student Registration	A new student Fredrick Gyesi has been registered with ID: 25	student	normal	134	2025-01-16 14:10:21.773154	f	active	2025-01-16 14:10:21.773154
175	New Student Registration	A new student Gad Gyesi has been registered with ID: 26	student	normal	137	2025-01-16 14:10:43.553457	f	active	2025-01-16 14:10:43.553457
176	New Student Registration	A new student Godfred Appoh has been registered with ID: 27	student	normal	140	2025-01-16 14:16:10.303585	f	active	2025-01-16 14:16:10.303585
177	New Student Registration	A new student Kingsley  Johnson  has been registered with ID: 28	student	normal	143	2025-01-16 14:16:14.76931	f	active	2025-01-16 14:16:14.76931
178	New Student Registration	A new student Merlin Sey has been registered with ID: 29	student	normal	146	2025-01-16 14:16:22.182582	f	active	2025-01-16 14:16:22.182582
179	New Student Registration	A new student Shadrack Abbiw has been registered with ID: 30	student	normal	149	2025-01-16 14:17:06.05334	f	active	2025-01-16 14:17:06.05334
180	New Student Registration	A new student Christian  Okwan has been registered with ID: 31	student	normal	152	2025-01-16 14:20:48.437683	f	active	2025-01-16 14:20:48.437683
181	New Student Registration	A new student Joel Arkorful has been registered with ID: 32	student	normal	155	2025-01-16 14:21:31.752859	f	active	2025-01-16 14:21:31.752859
182	New Student Registration	A new student Latif Abdullah has been registered with ID: 33	student	normal	158	2025-01-16 14:23:32.951528	f	active	2025-01-16 14:23:32.951528
183	New Student Registration	A new student Kingsley  Quansah  has been registered with ID: 34	student	normal	161	2025-01-16 14:23:43.979966	f	active	2025-01-16 14:23:43.979966
184	New Student Registration	A new student Melvin  Mankoe has been registered with ID: 35	student	normal	164	2025-01-16 14:24:02.924514	f	active	2025-01-16 14:24:02.924514
185	New Student Registration	A new student Rahaman Ahengua has been registered with ID: 36	student	normal	167	2025-01-16 14:27:26.008205	f	active	2025-01-16 14:27:26.008205
186	New Student Registration	A new student Patrick  Sessah has been registered with ID: 37	student	normal	170	2025-01-16 14:28:10.256949	f	active	2025-01-16 14:28:10.256949
187	New Student Registration	A new student Caleb Arthur has been registered with ID: 38	student	normal	173	2025-01-16 14:28:57.802741	f	active	2025-01-16 14:28:57.802741
188	New Student Registration	A new student Jonathan Arkoful  has been registered with ID: 39	student	normal	176	2025-01-16 14:29:15.593746	f	active	2025-01-16 14:29:15.593746
189	New Student Registration	A new student Marisabel Abbiw has been registered with ID: 40	student	normal	179	2025-01-16 14:30:47.668938	f	active	2025-01-16 14:30:47.668938
190	New Student Registration	A new student Wisdom Akey has been registered with ID: 41	student	normal	182	2025-01-16 14:31:22.559292	f	active	2025-01-16 14:31:22.559292
191	New Student Registration	A new student Ayeyi Amoh has been registered with ID: 42	student	normal	185	2025-01-16 14:33:06.853269	f	active	2025-01-16 14:33:06.853269
192	New Student Registration	A new student Lesley Mensah has been registered with ID: 43	student	normal	188	2025-01-16 14:33:39.35356	f	active	2025-01-16 14:33:39.35356
193	New Student Registration	A new student Rosalinda Appiah has been registered with ID: 44	student	normal	191	2025-01-16 14:34:33.930359	f	active	2025-01-16 14:34:33.930359
194	New Student Registration	A new student Kelvin Asumaning has been registered with ID: 45	student	normal	194	2025-01-16 14:37:28.213691	f	active	2025-01-16 14:37:28.213691
195	New Student Registration	A new student Fredrick Annan has been registered with ID: 46	student	normal	197	2025-01-16 14:37:43.903862	f	active	2025-01-16 14:37:43.903862
196	New Student Registration	A new student Reuben   Mensah has been registered with ID: 47	student	normal	200	2025-01-16 14:38:42.226738	f	active	2025-01-16 14:38:42.226738
197	New Student Registration	A new student Dorothy  Bampeo has been registered with ID: 48	student	normal	203	2025-01-16 14:40:49.561892	f	active	2025-01-16 14:40:49.561892
198	New Student Registration	A new student Christopher Eturuw has been registered with ID: 49	student	normal	206	2025-01-16 14:43:13.588619	f	active	2025-01-16 14:43:13.588619
199	New Student Registration	A new student Desmond  Dotse has been registered with ID: 50	student	normal	209	2025-01-16 14:44:33.297836	f	active	2025-01-16 14:44:33.297836
200	New Student Registration	A new student Samuel  Opare has been registered with ID: 51	student	normal	212	2025-01-16 14:45:39.165634	f	active	2025-01-16 14:45:39.165634
201	New Student Registration	A new student Blessing  Bondzie  has been registered with ID: 52	student	normal	215	2025-01-16 14:50:20.224924	f	active	2025-01-16 14:50:20.224924
202	New Student Registration	A new student Donnavan Amakye has been registered with ID: 53	student	normal	218	2025-01-16 14:50:21.74793	f	active	2025-01-16 14:50:21.74793
203	New Student Registration	A new student Lucky  Oppong - Willington has been registered with ID: 54	student	normal	221	2025-01-16 14:51:11.226891	f	active	2025-01-16 14:51:11.226891
204	New Student Registration	A new student Shahadat Okai has been registered with ID: 55	student	normal	224	2025-01-16 14:51:54.119139	f	active	2025-01-16 14:51:54.119139
205	New Student Registration	A new student Blessing  Komedzie has been registered with ID: 56	student	normal	227	2025-01-16 14:55:29.968126	f	active	2025-01-16 14:55:29.968126
206	New Student Registration	A new student Otoo Sylvia has been registered with ID: 57	student	normal	230	2025-01-16 14:56:15.162331	f	active	2025-01-16 14:56:15.162331
207	New Student Registration	A new student Kwame Amissah has been registered with ID: 58	student	normal	233	2025-01-16 14:58:22.272334	f	active	2025-01-16 14:58:22.272334
208	New Student Registration	A new student Elvis Nyani has been registered with ID: 59	student	normal	236	2025-01-16 15:00:15.432783	f	active	2025-01-16 15:00:15.432783
209	New Student Registration	A new student Justina  Abekah has been registered with ID: 60	student	normal	239	2025-01-16 15:01:13.088906	f	active	2025-01-16 15:01:13.088906
210	New Student Registration	A new student Micheal Arkorful has been registered with ID: 61	student	normal	242	2025-01-16 15:01:58.421491	f	active	2025-01-16 15:01:58.421491
211	New Student Registration	A new student Mercy Etey has been registered with ID: 62	student	normal	245	2025-01-16 15:02:33.095362	f	active	2025-01-16 15:02:33.095362
212	New Student Registration	A new student Jude Andoj has been registered with ID: 63	student	normal	248	2025-01-16 15:02:52.439625	f	active	2025-01-16 15:02:52.439625
213	New Student Registration	A new student Esther  Asare has been registered with ID: 64	student	normal	251	2025-01-16 15:06:20.392154	f	active	2025-01-16 15:06:20.392154
214	New Student Registration	A new student Francis Baffoe Amoaning has been registered with ID: 65	student	normal	254	2025-01-16 15:07:12.491653	f	active	2025-01-16 15:07:12.491653
215	New Student Registration	A new student Emmanulla Opare has been registered with ID: 66	student	normal	257	2025-01-16 15:07:28.937886	f	active	2025-01-16 15:07:28.937886
216	New Student Registration	A new student Ezekiel Annor has been registered with ID: 67	student	normal	260	2025-01-16 15:07:40.560411	f	active	2025-01-16 15:07:40.560411
217	New Student Registration	A new student Ellis Dick has been registered with ID: 68	student	normal	263	2025-01-16 15:11:13.592434	f	active	2025-01-16 15:11:13.592434
218	New Student Registration	A new student Elysha Owusu Mends has been registered with ID: 69	student	normal	266	2025-01-16 15:17:15.33915	f	active	2025-01-16 15:17:15.33915
219	New Student Registration	A new student Regina Amenuvor has been registered with ID: 70	student	normal	269	2025-01-16 15:18:13.502655	f	active	2025-01-16 15:18:13.502655
220	New Student Registration	A new student Solomon Owoo has been registered with ID: 71	student	normal	272	2025-01-16 15:18:18.681532	f	active	2025-01-16 15:18:18.681532
221	New Student Registration	A new student Micheal Yamoah has been registered with ID: 72	student	normal	275	2025-01-16 15:22:24.016946	f	active	2025-01-16 15:22:24.016946
222	New Student Registration	A new student Godfred Arhin has been registered with ID: 73	student	normal	278	2025-01-16 15:31:00.873725	f	active	2025-01-16 15:31:00.873725
223	New Student Registration	A new student Joseph  Eyiah-Mensah has been registered with ID: 74	student	normal	281	2025-01-16 15:41:08.922881	f	active	2025-01-16 15:41:08.922881
224	New Student Registration	A new student Eric Arhin has been registered with ID: 75	student	normal	284	2025-01-16 15:43:58.591404	f	active	2025-01-16 15:43:58.591404
225	New Student Registration	A new student Euodia Forson has been registered with ID: 76	student	normal	287	2025-01-16 15:45:17.43456	f	active	2025-01-16 15:45:17.43456
226	New Student Registration	A new student Gloria Nyame has been registered with ID: 77	student	normal	290	2025-01-16 15:53:29.944733	f	active	2025-01-16 15:53:29.944733
227	New Student Registration	A new student Kayleb Otwey has been registered with ID: 78	student	normal	293	2025-01-16 15:55:03.423841	f	active	2025-01-16 15:55:03.423841
228	New Student Registration	A new student Doris Abaah has been registered with ID: 79	student	normal	296	2025-01-16 15:56:13.205217	f	active	2025-01-16 15:56:13.205217
229	New Student Registration	A new student Sylvia Sam has been registered with ID: 80	student	normal	299	2025-01-16 15:57:14.533799	f	active	2025-01-16 15:57:14.533799
230	New Student Registration	A new student Clement Arthur has been registered with ID: 81	student	normal	302	2025-01-16 15:59:48.388705	f	active	2025-01-16 15:59:48.388705
231	New Student Registration	A new student Emmanuel Tawiah has been registered with ID: 82	student	normal	305	2025-01-16 16:01:41.019583	f	active	2025-01-16 16:01:41.019583
232	New Student Registration	A new student Mena Aba Odoom has been registered with ID: 83	student	normal	308	2025-01-16 16:03:12.83079	f	active	2025-01-16 16:03:12.83079
233	New Student Registration	A new student Eva Quaye has been registered with ID: 84	student	normal	311	2025-01-16 16:03:49.9707	f	active	2025-01-16 16:03:49.9707
234	New Student Registration	A new student Reymolf Ayensu has been registered with ID: 85	student	normal	314	2025-01-16 16:03:59.466081	f	active	2025-01-16 16:03:59.466081
235	New Student Registration	A new student Dennis Yankson has been registered with ID: 86	student	normal	317	2025-01-16 16:08:24.128714	f	active	2025-01-16 16:08:24.128714
236	New Student Registration	A new student James Botwey has been registered with ID: 87	student	normal	320	2025-01-16 16:09:59.780686	f	active	2025-01-16 16:09:59.780686
237	New Student Registration	A new student Peter Mensah  has been registered with ID: 88	student	normal	323	2025-01-16 16:10:48.335595	f	active	2025-01-16 16:10:48.335595
238	New Student Registration	A new student Nana Gyesi has been registered with ID: 89	student	normal	326	2025-01-16 16:13:56.350609	f	active	2025-01-16 16:13:56.350609
239	New Student Registration	A new student Michelle  Pelmiitey has been registered with ID: 90	student	normal	329	2025-01-16 16:16:00.293582	f	active	2025-01-16 16:16:00.293582
240	New Student Registration	A new student Bright  Quansah has been registered with ID: 91	student	normal	332	2025-01-16 16:18:17.935668	f	active	2025-01-16 16:18:17.935668
241	New Student Registration	A new student Stephen Abekah has been registered with ID: 92	student	normal	335	2025-01-16 16:20:49.114191	f	active	2025-01-16 16:20:49.114191
242	New Student Registration	A new student Blessing Nyarkoh has been registered with ID: 93	student	normal	338	2025-01-16 16:26:13.967519	f	active	2025-01-16 16:26:13.967519
243	New Student Registration	A new student Nicholas  Afful has been registered with ID: 94	student	normal	341	2025-01-17 11:20:26.586073	f	active	2025-01-17 11:20:26.586073
244	New Student Registration	A new student Jason Appiah has been registered with ID: 95	student	normal	344	2025-01-17 11:21:09.141368	f	active	2025-01-17 11:21:09.141368
245	New Student Registration	A new student Christian Afful has been registered with ID: 96	student	normal	347	2025-01-17 11:27:11.622509	f	active	2025-01-17 11:27:11.622509
246	New Student Registration	A new student Raphael Asare has been registered with ID: 97	student	normal	350	2025-01-17 11:36:20.383512	f	active	2025-01-17 11:36:20.383512
247	New Student Registration	A new student Prince Nyavor has been registered with ID: 98	student	normal	353	2025-01-17 11:40:44.415414	f	active	2025-01-17 11:40:44.415414
248	New Student Registration	A new student Prince Awotwe has been registered with ID: 99	student	normal	356	2025-01-17 11:50:36.924961	f	active	2025-01-17 11:50:36.924961
249	New Student Registration	A new student Lucy Boateng has been registered with ID: 100	student	normal	359	2025-01-17 11:52:29.005327	f	active	2025-01-17 11:52:29.005327
250	New Student Registration	A new student Enock Akyere has been registered with ID: 101	student	normal	362	2025-01-17 11:58:10.023713	f	active	2025-01-17 11:58:10.023713
251	New Student Registration	A new student Prosper Amissah has been registered with ID: 102	student	normal	365	2025-01-17 12:03:32.346661	f	active	2025-01-17 12:03:32.346661
252	New Student Registration	A new student Shalom Bondzie has been registered with ID: 103	student	normal	368	2025-01-17 12:07:18.230573	f	active	2025-01-17 12:07:18.230573
253	New Student Registration	A new student Bright Coly has been registered with ID: 104	student	normal	371	2025-01-17 12:12:50.149495	f	active	2025-01-17 12:12:50.149495
254	New Student Registration	A new student Desmond Arhin has been registered with ID: 105	student	normal	374	2025-01-17 12:13:11.113103	f	active	2025-01-17 12:13:11.113103
255	New Student Registration	A new student Phyllis Aidoo has been registered with ID: 106	student	normal	377	2025-01-17 12:23:38.301685	f	active	2025-01-17 12:23:38.301685
256	New Student Registration	A new student Abigail Amenuvor has been registered with ID: 107	student	normal	380	2025-01-17 12:33:20.050047	f	active	2025-01-17 12:33:20.050047
257	New Student Registration	A new student Nana Owusu Dampson has been registered with ID: 108	student	normal	383	2025-01-17 12:47:52.256531	f	active	2025-01-17 12:47:52.256531
258	New Student Registration	A new student Belinda Boison has been registered with ID: 109	student	normal	386	2025-01-17 12:49:30.163561	f	active	2025-01-17 12:49:30.163561
259	New Student Registration	A new student Praise Egyir has been registered with ID: 110	student	normal	389	2025-01-17 12:53:42.325819	f	active	2025-01-17 12:53:42.325819
260	New Student Registration	A new student Cherubim Essandoh has been registered with ID: 111	student	normal	392	2025-01-17 12:59:08.880195	f	active	2025-01-17 12:59:08.880195
261	New Student Registration	A new student Isaac Obeng has been registered with ID: 112	student	normal	395	2025-01-17 13:07:47.102031	f	active	2025-01-17 13:07:47.102031
262	New Student Registration	A new student Eric Arthur has been registered with ID: 113	student	normal	398	2025-01-17 13:12:59.881972	f	active	2025-01-17 13:12:59.881972
263	New Student Registration	A new student John Quaye has been registered with ID: 114	student	normal	401	2025-01-17 13:13:55.39714	f	active	2025-01-17 13:13:55.39714
264	New Student Registration	A new student Clifford Tetteh has been registered with ID: 115	student	normal	404	2025-01-17 13:22:32.824587	f	active	2025-01-17 13:22:32.824587
265	New Student Registration	A new student Lordina Agbi has been registered with ID: 116	student	normal	407	2025-01-17 13:28:24.164622	f	active	2025-01-17 13:28:24.164622
266	New Student Registration	A new student Shadrack Essuman has been registered with ID: 117	student	normal	410	2025-01-17 13:33:26.928295	f	active	2025-01-17 13:33:26.928295
267	New Student Registration	A new student Joana Acquaye has been registered with ID: 118	student	normal	413	2025-01-17 13:39:20.391491	f	active	2025-01-17 13:39:20.391491
268	New Student Registration	A new student Natalie Brago has been registered with ID: 119	student	normal	416	2025-01-17 13:41:18.48042	f	active	2025-01-17 13:41:18.48042
269	New Student Registration	A new student David Essandoh has been registered with ID: 120	student	normal	419	2025-01-17 13:50:49.983032	f	active	2025-01-17 13:50:49.983032
270	New Student Registration	A new student Blessing  Adentwi has been registered with ID: 121	student	normal	422	2025-01-17 13:55:48.991383	f	active	2025-01-17 13:55:48.991383
271	New Student Registration	A new student Dorothy Mensah has been registered with ID: 122	student	normal	425	2025-01-17 13:59:52.993919	f	active	2025-01-17 13:59:52.993919
272	New Student Registration	A new student Akua Ampomah has been registered with ID: 123	student	normal	428	2025-01-17 14:02:06.830657	f	active	2025-01-17 14:02:06.830657
273	New Student Registration	A new student Faustina Andoh has been registered with ID: 124	student	normal	431	2025-01-17 14:09:47.965474	f	active	2025-01-17 14:09:47.965474
274	New Student Registration	A new student Precious Egyin has been registered with ID: 125	student	normal	434	2025-01-17 14:12:41.386088	f	active	2025-01-17 14:12:41.386088
275	New Student Registration	A new student Owena Eyiah-Mensah has been registered with ID: 126	student	normal	437	2025-01-17 14:22:49.442722	f	active	2025-01-17 14:22:49.442722
276	New Student Registration	A new student Comfort Arkorful has been registered with ID: 127	student	normal	440	2025-01-17 14:25:33.369871	f	active	2025-01-17 14:25:33.369871
277	New Student Registration	A new student Michelle Baidoo has been registered with ID: 128	student	normal	443	2025-01-17 14:30:51.219318	f	active	2025-01-17 14:30:51.219318
278	New Student Registration	A new student Josephine  Baidoo has been registered with ID: 129	student	normal	446	2025-01-17 14:37:48.174168	f	active	2025-01-17 14:37:48.174168
279	New Student Registration	A new student Lordina Botchwey has been registered with ID: 130	student	normal	449	2025-01-17 14:46:51.337056	f	active	2025-01-17 14:46:51.337056
280	New Student Registration	A new student Twenewuradze Buabeng has been registered with ID: 131	student	normal	452	2025-01-17 14:52:00.139223	f	active	2025-01-17 14:52:00.139223
281	New Student Registration	A new student Benita Ekwam has been registered with ID: 132	student	normal	455	2025-01-17 14:58:01.810329	f	active	2025-01-17 14:58:01.810329
282	New Student Registration	A new student Aba Kaitu has been registered with ID: 133	student	normal	458	2025-01-17 15:02:13.276455	f	active	2025-01-17 15:02:13.276455
283	New Student Registration	A new student Davida Abraham has been registered with ID: 134	student	normal	461	2025-01-17 15:05:33.379832	f	active	2025-01-17 15:05:33.379832
284	New Student Registration	A new student Francess Aidoo has been registered with ID: 135	student	normal	464	2025-01-17 15:10:12.305085	f	active	2025-01-17 15:10:12.305085
285	New Student Registration	A new student Vanessa Quaye has been registered with ID: 136	student	normal	467	2025-01-17 15:11:41.521337	f	active	2025-01-17 15:11:41.521337
286	New Student Registration	A new student Isabella  Amakye has been registered with ID: 137	student	normal	470	2025-01-17 15:15:28.989026	f	active	2025-01-17 15:15:28.989026
287	New Student Registration	A new student Gity Ofori-Atta has been registered with ID: 138	student	normal	473	2025-01-17 15:18:28.39795	f	active	2025-01-17 15:18:28.39795
288	New Student Registration	A new student Francisca Amankwah has been registered with ID: 139	student	normal	476	2025-01-17 15:19:58.487464	f	active	2025-01-17 15:19:58.487464
289	New Student Registration	A new student Stella Owusu has been registered with ID: 140	student	normal	479	2025-01-17 15:23:36.725747	f	active	2025-01-17 15:23:36.725747
290	New Student Registration	A new student Augustina Appretse has been registered with ID: 141	student	normal	482	2025-01-17 15:26:59.894777	f	active	2025-01-17 15:26:59.894777
291	New Student Registration	A new student Hannah Otoo has been registered with ID: 142	student	normal	485	2025-01-17 15:27:30.268782	f	active	2025-01-17 15:27:30.268782
292	New Student Registration	A new student Nancy Arkorful has been registered with ID: 143	student	normal	488	2025-01-17 15:31:54.000811	f	active	2025-01-17 15:31:54.000811
293	New Student Registration	A new student Yvette Martey has been registered with ID: 144	student	normal	491	2025-01-17 15:33:57.890531	f	active	2025-01-17 15:33:57.890531
294	New Student Registration	A new student Alexandra Blankson has been registered with ID: 145	student	normal	494	2025-01-17 15:37:44.664574	f	active	2025-01-17 15:37:44.664574
295	New Staff Added	A new staff(Prince) has joined the school.	general	normal	1	2025-01-17 15:38:53.146441	f	active	2025-01-17 15:38:53.146441
296	New Student Registration	A new student Naomi Botchwey has been registered with ID: 146	student	normal	498	2025-01-17 15:41:09.873134	f	active	2025-01-17 15:41:09.873134
297	New Student Registration	A new student Jehoaida Ababio has been registered with ID: 147	student	normal	501	2025-01-17 15:41:11.847615	f	active	2025-01-17 15:41:11.847615
298	New Student Registration	A new student Nannies Dadzie has been registered with ID: 148	student	normal	504	2025-01-17 15:46:53.717998	f	active	2025-01-17 15:46:53.717998
299	New Student Registration	A new student Damien Arkoh has been registered with ID: 149	student	normal	507	2025-01-17 15:48:21.347562	f	active	2025-01-17 15:48:21.347562
300	New Student Registration	A new student Maame Walden has been registered with ID: 150	student	normal	510	2025-01-17 15:48:31.96919	f	active	2025-01-17 15:48:31.96919
301	New Student Registration	A new student Latif Abdul has been registered with ID: 151	student	normal	513	2025-01-17 15:49:01.868714	f	active	2025-01-17 15:49:01.868714
302	New Student Registration	A new student Tina  Essuman has been registered with ID: 152	student	normal	516	2025-01-17 15:50:14.007902	f	active	2025-01-17 15:50:14.007902
303	New Student Registration	A new student Jennifer Attisey has been registered with ID: 153	student	normal	519	2025-01-17 15:51:26.699972	f	active	2025-01-17 15:51:26.699972
304	New Student Registration	A new student Philippa Amissah  has been registered with ID: 154	student	normal	522	2025-01-17 15:51:37.225472	f	active	2025-01-17 15:51:37.225472
305	New Student Registration	A new student Maame Pratt has been registered with ID: 155	student	normal	525	2025-01-17 15:52:44.108075	f	active	2025-01-17 15:52:44.108075
306	New Student Registration	A new student Goodness Mensah has been registered with ID: 156	student	normal	528	2025-01-17 15:56:10.158913	f	active	2025-01-17 15:56:10.158913
307	New Student Registration	A new student Grace Arthur has been registered with ID: 157	student	normal	531	2025-01-17 15:56:41.490177	f	active	2025-01-17 15:56:41.490177
308	New Student Registration	A new student Nana Otoo has been registered with ID: 158	student	normal	534	2025-01-17 15:59:38.045232	f	active	2025-01-17 15:59:38.045232
309	New Student Registration	A new student Jayce Ansah has been registered with ID: 159	student	normal	537	2025-01-17 16:00:06.728997	f	active	2025-01-17 16:00:06.728997
310	New Student Registration	A new student Anthoinette Aryee has been registered with ID: 160	student	normal	540	2025-01-17 16:02:59.349213	f	active	2025-01-17 16:02:59.349213
311	New Student Registration	A new student Theophilus  Odoom has been registered with ID: 161	student	normal	543	2025-01-17 16:04:26.65736	f	active	2025-01-17 16:04:26.65736
312	New Student Registration	A new student Christabel Sewornu  has been registered with ID: 162	student	normal	546	2025-01-17 16:05:04.427187	f	active	2025-01-17 16:05:04.427187
313	New Student Registration	A new student Kingsley  Arthur  has been registered with ID: 163	student	normal	549	2025-01-17 16:07:28.85577	f	active	2025-01-17 16:07:28.85577
314	New Student Registration	A new student Vasty Kukua has been registered with ID: 164	student	normal	552	2025-01-17 16:08:09.275736	f	active	2025-01-17 16:08:09.275736
315	New Student Registration	A new student Jeffery  Obeng has been registered with ID: 165	student	normal	555	2025-01-17 16:08:26.593012	f	active	2025-01-17 16:08:26.593012
316	New Student Registration	A new student Quinester Simpson has been registered with ID: 166	student	normal	558	2025-01-17 16:08:46.325289	f	active	2025-01-17 16:08:46.325289
317	New Student Registration	A new student Clementina  Coffie has been registered with ID: 167	student	normal	561	2025-01-17 16:14:28.099783	f	active	2025-01-17 16:14:28.099783
318	New Student Registration	A new student Oscar Atsu  has been registered with ID: 168	student	normal	564	2025-01-17 16:18:30.384299	f	active	2025-01-17 16:18:30.384299
319	New Student Registration	A new student Damien Donson has been registered with ID: 169	student	normal	567	2025-01-17 16:26:30.555167	f	active	2025-01-17 16:26:30.555167
320	New Student Registration	A new student Vincent Edzie has been registered with ID: 170	student	normal	570	2025-01-17 16:32:34.685104	f	active	2025-01-17 16:32:34.685104
321	New Student Registration	A new student Kingsford  Tawiah has been registered with ID: 171	student	normal	573	2025-01-17 16:41:50.711235	f	active	2025-01-17 16:41:50.711235
322	New Student Registration	A new student Joel Essandoh has been registered with ID: 172	student	normal	576	2025-01-17 16:47:25.556928	f	active	2025-01-17 16:47:25.556928
323	New Student Registration	A new student Lucas Essandoh has been registered with ID: 173	student	normal	579	2025-01-17 16:51:48.315814	f	active	2025-01-17 16:51:48.315814
324	New Student Registration	A new student Nana Nsarkoh has been registered with ID: 174	student	normal	582	2025-01-17 16:57:12.308429	f	active	2025-01-17 16:57:12.308429
325	New Student Registration	A new student Vincent  Owusu has been registered with ID: 175	student	normal	585	2025-01-17 17:00:57.048815	f	active	2025-01-17 17:00:57.048815
326	New Student Registration	A new student Ezekiel  Quansah has been registered with ID: 176	student	normal	588	2025-01-17 17:07:52.510323	f	active	2025-01-17 17:07:52.510323
327	New Student Registration	A new student Nancy Acquah has been registered with ID: 177	student	normal	591	2025-01-20 14:02:16.988053	f	active	2025-01-20 14:02:16.988053
328	New Student Registration	A new student Hannah Andoh has been registered with ID: 178	student	normal	594	2025-01-20 14:10:12.097763	f	active	2025-01-20 14:10:12.097763
329	New Student Registration	A new student Celestina  Obaapa has been registered with ID: 179	student	normal	597	2025-01-20 14:18:44.645796	f	active	2025-01-20 14:18:44.645796
330	New Student Registration	A new student Jackline Arhin has been registered with ID: 180	student	normal	600	2025-01-20 14:25:54.591834	f	active	2025-01-20 14:25:54.591834
331	New Student Registration	A new student Mabel Baidoo has been registered with ID: 181	student	normal	603	2025-01-20 14:31:44.698019	f	active	2025-01-20 14:31:44.698019
332	New Student Registration	A new student Michelle Boamah has been registered with ID: 182	student	normal	606	2025-01-20 14:37:44.024409	f	active	2025-01-20 14:37:44.024409
333	New Student Registration	A new student Keziah Sackey has been registered with ID: 183	student	normal	609	2025-01-20 14:41:42.675995	f	active	2025-01-20 14:41:42.675995
334	New Student Registration	A new student Florence  Ewusi  has been registered with ID: 184	student	normal	612	2025-01-20 14:48:46.745623	f	active	2025-01-20 14:48:46.745623
335	New Student Registration	A new student Dominica Ofosu has been registered with ID: 185	student	normal	615	2025-01-20 14:54:50.836881	f	active	2025-01-20 14:54:50.836881
336	New Student Registration	A new student Blessing  Koffie has been registered with ID: 186	student	normal	618	2025-01-20 15:04:19.748674	f	active	2025-01-20 15:04:19.748674
337	New Student Registration	A new student Emmanuella Quarshie has been registered with ID: 187	student	normal	621	2025-01-20 15:12:40.015484	f	active	2025-01-20 15:12:40.015484
338	New Student Registration	A new student Christabel  Quaye has been registered with ID: 188	student	normal	624	2025-01-20 15:17:22.884353	f	active	2025-01-20 15:17:22.884353
339	New Student Registration	A new student Victoria Tetteh has been registered with ID: 189	student	normal	627	2025-01-20 15:24:06.121157	f	active	2025-01-20 15:24:06.121157
340	New Student Registration	A new student Gloria Abbiw has been registered with ID: 190	student	normal	630	2025-01-20 15:33:24.879699	f	active	2025-01-20 15:33:24.879699
341	New Student Registration	A new student Linda Botchwey  has been registered with ID: 191	student	normal	633	2025-01-20 15:42:10.698806	f	active	2025-01-20 15:42:10.698806
342	New Student Registration	A new student Emmanuel  Aidoo has been registered with ID: 192	student	normal	636	2025-01-20 15:46:39.583081	f	active	2025-01-20 15:46:39.583081
343	New Student Registration	A new student Joel  Abekah  has been registered with ID: 193	student	normal	639	2025-01-20 15:52:32.418037	f	active	2025-01-20 15:52:32.418037
344	New Student Registration	A new student Christabel  Ankrah  has been registered with ID: 194	student	normal	642	2025-01-20 15:58:08.455234	f	active	2025-01-20 15:58:08.455234
345	New Student Registration	A new student Nhyira  Gyesi has been registered with ID: 195	student	normal	645	2025-01-22 13:22:58.05897	f	active	2025-01-22 13:22:58.05897
346	New Student Registration	A new student Micah Abaidoo has been registered with ID: 196	student	normal	648	2025-01-22 13:23:48.624842	f	active	2025-01-22 13:23:48.624842
347	New Student Registration	A new student Michelle  Dampson has been registered with ID: 197	student	normal	651	2025-01-22 13:28:36.365395	f	active	2025-01-22 13:28:36.365395
348	New Student Registration	A new student Kennedy Acquaye has been registered with ID: 198	student	normal	654	2025-01-22 13:29:11.027744	f	active	2025-01-22 13:29:11.027744
349	New Student Registration	A new student Favour Affoh has been registered with ID: 199	student	normal	657	2025-01-22 13:34:31.88057	f	active	2025-01-22 13:34:31.88057
350	New Student Registration	A new student Moses Eyiah has been registered with ID: 200	student	normal	660	2025-01-22 13:34:55.597241	f	active	2025-01-22 13:34:55.597241
351	New Student Registration	A new student Pertrina  Gyesi has been registered with ID: 201	student	normal	663	2025-01-22 13:38:15.074648	f	active	2025-01-22 13:38:15.074648
352	New Student Registration	A new student Jonathan Amankwah has been registered with ID: 202	student	normal	666	2025-01-22 13:39:48.71103	f	active	2025-01-22 13:39:48.71103
353	New Student Registration	A new student Eunice  Arhin has been registered with ID: 203	student	normal	668	2025-01-22 13:42:35.378413	f	active	2025-01-22 13:42:35.378413
354	New Student Registration	A new student Abraham Andoh has been registered with ID: 204	student	normal	671	2025-01-22 13:45:53.412023	f	active	2025-01-22 13:45:53.412023
355	New Student Registration	A new student Marvin  Arkoh has been registered with ID: 205	student	normal	673	2025-01-22 13:46:47.318695	f	active	2025-01-22 13:46:47.318695
356	New Student Registration	A new student Precious  Ayin  has been registered with ID: 206	student	normal	676	2025-01-22 13:51:59.383404	f	active	2025-01-22 13:51:59.383404
357	New Student Registration	A new student Charles Anderson has been registered with ID: 207	student	normal	679	2025-01-22 13:52:25.064189	f	active	2025-01-22 13:52:25.064189
358	New Student Registration	A new student Emerald  Owusu has been registered with ID: 208	student	normal	682	2025-01-22 13:55:22.798699	f	active	2025-01-22 13:55:22.798699
359	New Student Registration	A new student Daniel Annan has been registered with ID: 209	student	normal	685	2025-01-22 13:56:55.357526	f	active	2025-01-22 13:56:55.357526
360	New Student Registration	A new student Festus  Otoo has been registered with ID: 210	student	normal	688	2025-01-22 13:58:17.814601	f	active	2025-01-22 13:58:17.814601
361	New Student Registration	A new student Desmond  Nyarkoh  has been registered with ID: 211	student	normal	691	2025-01-22 14:02:12.986319	f	active	2025-01-22 14:02:12.986319
362	New Student Registration	A new student Favour Annan has been registered with ID: 212	student	normal	694	2025-01-22 14:03:25.808574	f	active	2025-01-22 14:03:25.808574
363	New Student Registration	A new student Glibert  Essel has been registered with ID: 213	student	normal	697	2025-01-22 14:05:44.732786	f	active	2025-01-22 14:05:44.732786
364	New Student Registration	A new student Miracle Appiah has been registered with ID: 214	student	normal	700	2025-01-22 14:08:35.890904	f	active	2025-01-22 14:08:35.890904
365	New Student Registration	A new student Prince Lamptey  has been registered with ID: 215	student	normal	703	2025-01-22 14:09:26.725846	f	active	2025-01-22 14:09:26.725846
366	New Student Registration	A new student Festus  Okyere  has been registered with ID: 216	student	normal	706	2025-01-22 14:14:08.749198	f	active	2025-01-22 14:14:08.749198
367	New Student Registration	A new student Greg Appiah has been registered with ID: 217	student	normal	709	2025-01-22 14:14:54.226053	f	active	2025-01-22 14:14:54.226053
368	New Student Registration	A new student Joshua  Arthur  has been registered with ID: 218	student	normal	712	2025-01-22 14:17:13.644373	f	active	2025-01-22 14:17:13.644373
369	New Student Registration	A new student Philip Atomaku has been registered with ID: 219	student	normal	715	2025-01-22 14:19:36.619575	f	active	2025-01-22 14:19:36.619575
370	New Student Registration	A new student Prince  Dotse  has been registered with ID: 220	student	normal	718	2025-01-22 14:20:16.953589	f	active	2025-01-22 14:20:16.953589
371	New Student Registration	A new student Samuel  Dadzie has been registered with ID: 221	student	normal	721	2025-01-22 14:24:22.933102	f	active	2025-01-22 14:24:22.933102
372	New Student Registration	A new student Nathaniel  Odoom  has been registered with ID: 222	student	normal	724	2025-01-22 14:25:08.792425	f	active	2025-01-22 14:25:08.792425
373	New Student Registration	A new student Peter Darkoh has been registered with ID: 223	student	normal	727	2025-01-22 14:29:20.12141	f	active	2025-01-22 14:29:20.12141
374	New Student Registration	A new student Bright  Essel  has been registered with ID: 224	student	normal	730	2025-01-22 14:29:21.940007	f	active	2025-01-22 14:29:21.940007
375	New Student Registration	A new student Eric Blankson  has been registered with ID: 225	student	normal	733	2025-01-22 14:32:41.790804	f	active	2025-01-22 14:32:41.790804
376	New Student Registration	A new student Gorden Hinson has been registered with ID: 226	student	normal	736	2025-01-22 14:35:59.323742	f	active	2025-01-22 14:35:59.323742
377	New Student Registration	A new student Eugenia  Martey has been registered with ID: 227	student	normal	739	2025-01-22 14:37:02.067773	f	active	2025-01-22 14:37:02.067773
378	New Student Registration	A new student Justice  Ibrahim  has been registered with ID: 228	student	normal	742	2025-01-22 14:40:02.397739	f	active	2025-01-22 14:40:02.397739
379	New Student Registration	A new student Emmanuel Koomson has been registered with ID: 229	student	normal	745	2025-01-22 14:40:42.574636	f	active	2025-01-22 14:40:42.574636
380	New Student Registration	A new student Benedicta  Wallace has been registered with ID: 230	student	normal	748	2025-01-22 14:44:22.367725	f	active	2025-01-22 14:44:22.367725
381	New Student Registration	A new student Richard  Mensah has been registered with ID: 231	student	normal	751	2025-01-22 14:46:43.473997	f	active	2025-01-22 14:46:43.473997
382	New Student Registration	A new student Edward Mensah has been registered with ID: 232	student	normal	754	2025-01-22 14:52:27.867219	f	active	2025-01-22 14:52:27.867219
383	New Student Registration	A new student Chris Mensah has been registered with ID: 233	student	normal	757	2025-01-22 14:56:33.418489	f	active	2025-01-22 14:56:33.418489
384	New Student Registration	A new student Robert Mensah has been registered with ID: 234	student	normal	760	2025-01-22 15:00:48.480566	f	active	2025-01-22 15:00:48.480566
385	New Student Registration	A new student Zebulun Quansah has been registered with ID: 235	student	normal	763	2025-01-22 15:05:29.543459	f	active	2025-01-22 15:05:29.543459
386	New Student Registration	A new student Stephanie Addo has been registered with ID: 236	student	normal	766	2025-01-22 15:09:36.356168	f	active	2025-01-22 15:09:36.356168
387	New Student Registration	A new student Yvonne Arhin has been registered with ID: 237	student	normal	769	2025-01-22 15:13:51.31593	f	active	2025-01-22 15:13:51.31593
388	New Student Registration	A new student Blessing Baidoo has been registered with ID: 238	student	normal	772	2025-01-22 15:18:30.727323	f	active	2025-01-22 15:18:30.727323
389	New Student Registration	A new student Mabel Bassaw has been registered with ID: 239	student	normal	775	2025-01-22 15:21:41.792236	f	active	2025-01-22 15:21:41.792236
390	New Student Registration	A new student Josephine Incoom has been registered with ID: 240	student	normal	778	2025-01-22 15:24:29.321993	f	active	2025-01-22 15:24:29.321993
391	New Student Registration	A new student Blessing Koffie has been registered with ID: 241	student	normal	781	2025-01-22 15:27:58.599863	f	active	2025-01-22 15:27:58.599863
392	New Student Registration	A new student Victoria Lamptey has been registered with ID: 242	student	normal	784	2025-01-22 15:31:24.517685	f	active	2025-01-22 15:31:24.517685
393	New Student Registration	A new student Nana Mensah has been registered with ID: 243	student	normal	787	2025-01-22 15:36:52.332445	f	active	2025-01-22 15:36:52.332445
394	New Student Registration	A new student Yayara  Nyavor has been registered with ID: 244	student	normal	790	2025-01-22 15:40:18.961479	f	active	2025-01-22 15:40:18.961479
395	New Student Registration	A new student Naana Onumah has been registered with ID: 245	student	normal	792	2025-01-22 15:46:11.638494	f	active	2025-01-22 15:46:11.638494
396	New Student Registration	A new student Marcelina Sekum has been registered with ID: 246	student	normal	795	2025-01-22 15:52:14.776778	f	active	2025-01-22 15:52:14.776778
397	New Student Registration	A new student Avery Wilson has been registered with ID: 247	student	normal	798	2025-01-22 15:56:48.394019	f	active	2025-01-22 15:56:48.394019
398	New Student Registration	A new student Loveel Otwey has been registered with ID: 248	student	normal	801	2025-01-22 16:01:34.667296	f	active	2025-01-22 16:01:34.667296
399	New Student Registration	A new student Desmond Arkorful has been registered with ID: 249	student	normal	804	2025-01-22 16:10:54.596478	f	active	2025-01-22 16:10:54.596478
400	Student Information Updated	Student Avery Wilson's information has been updated.	student	normal	798	2025-01-22 16:11:59.126239	f	active	2025-01-22 16:11:59.126239
401	Student Information Updated	Student Micah Abaidoo's information has been updated.	student	normal	648	2025-01-22 16:13:38.998288	f	active	2025-01-22 16:13:38.998288
402	New Student Registration	A new student Judah Andorful has been registered with ID: 250	student	normal	807	2025-01-24 14:03:08.871544	f	active	2025-01-24 14:03:08.871544
403	New Student Registration	A new student Ernestina Agyei has been registered with ID: 251	student	normal	810	2025-01-24 14:05:12.772825	f	active	2025-01-24 14:05:12.772825
404	New Student Registration	A new student Eric Bentum has been registered with ID: 252	student	normal	813	2025-01-24 14:08:18.584215	f	active	2025-01-24 14:08:18.584215
405	New Student Registration	A new student Mabel Nyame has been registered with ID: 253	student	normal	816	2025-01-24 14:09:14.149622	f	active	2025-01-24 14:09:14.149622
406	New Student Registration	A new student Francis Esson has been registered with ID: 254	student	normal	819	2025-01-24 14:12:04.817243	f	active	2025-01-24 14:12:04.817243
407	New Student Registration	A new student Richard  Essandoh has been registered with ID: 255	student	normal	822	2025-01-24 14:16:19.533433	f	active	2025-01-24 14:16:19.533433
408	New Student Registration	A new student Farouk Fuseini has been registered with ID: 256	student	normal	825	2025-01-24 14:20:38.749445	f	active	2025-01-24 14:20:38.749445
409	New Student Registration	A new student Philip Impraim has been registered with ID: 257	student	normal	828	2025-01-24 14:24:44.782167	f	active	2025-01-24 14:24:44.782167
410	New Student Registration	A new student Andrews Konduah has been registered with ID: 258	student	normal	831	2025-01-24 14:28:34.942966	f	active	2025-01-24 14:28:34.942966
411	New Student Registration	A new student Zadock Nkansah has been registered with ID: 259	student	normal	834	2025-01-24 14:33:18.265427	f	active	2025-01-24 14:33:18.265427
412	New Student Registration	A new student Rashvi Nyame has been registered with ID: 260	student	normal	837	2025-01-24 14:36:38.167673	f	active	2025-01-24 14:36:38.167673
413	New Student Registration	A new student Sheriff Okai has been registered with ID: 261	student	normal	840	2025-01-24 14:41:56.986697	f	active	2025-01-24 14:41:56.986697
414	New Student Registration	A new student Kingsford Opare has been registered with ID: 262	student	normal	843	2025-01-24 14:48:10.905178	f	active	2025-01-24 14:48:10.905178
415	New Student Registration	A new student Evans Owusu has been registered with ID: 263	student	normal	846	2025-01-24 15:02:45.719648	f	active	2025-01-24 15:02:45.719648
416	New Student Registration	A new student Ekow Quansah has been registered with ID: 264	student	normal	849	2025-01-24 15:17:08.848505	f	active	2025-01-24 15:17:08.848505
417	New Student Registration	A new student Nhyiraba Quansah has been registered with ID: 265	student	normal	852	2025-01-24 15:21:33.391809	f	active	2025-01-24 15:21:33.391809
418	New Student Registration	A new student Nhyiraba Sessah has been registered with ID: 266	student	normal	855	2025-01-24 15:25:10.640938	f	active	2025-01-24 15:25:10.640938
419	New Student Registration	A new student Maxwell Sey has been registered with ID: 267	student	normal	858	2025-01-24 15:28:10.029282	f	active	2025-01-24 15:28:10.029282
420	New Student Registration	A new student Lawrencia Akese has been registered with ID: 268	student	normal	861	2025-01-24 15:59:12.485981	f	active	2025-01-24 15:59:12.485981
421	New Student Registration	A new student Priscilla  Amenuvor has been registered with ID: 269	student	normal	864	2025-01-24 16:10:26.881727	f	active	2025-01-24 16:10:26.881727
422	New Student Registration	A new student Alisha Amissah has been registered with ID: 270	student	normal	867	2025-01-24 16:26:43.968933	f	active	2025-01-24 16:26:43.968933
423	New Student Registration	A new student Alisha Amissah has been registered with ID: 271	student	normal	870	2025-01-24 16:32:36.596503	f	active	2025-01-24 16:32:36.596503
424	New Student Registration	A new student Pamela Amissah has been registered with ID: 272	student	normal	873	2025-01-24 16:48:27.902282	f	active	2025-01-24 16:48:27.902282
425	New Student Registration	A new student Comfort  Anaafi has been registered with ID: 273	student	normal	876	2025-01-24 16:55:33.890004	f	active	2025-01-24 16:55:33.890004
\.


--
-- Data for Name: parents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parents (parent_id, other_names, last_name, phone, email, address, status, user_id) FROM stdin;
10	Innocentia 	Fordjour 	0244997473			active	52
11	Alfred 	Acquah 	0244044846			active	53
12	Rebecca 	Arthur 	0545383737		apam	active	84
13	Emmanuel 	Agbodogli	0242228967		volta	active	85
14	Agnes 	Acquah	0540253137		Sweet mother, Tema	active	87
15						active	88
16	Eric	Appiah	0244031704		Lighthouse	active	90
17	Esther 	Owusu    Appiah	0246984220		Lighthouse	active	91
18	Agartha	Quansah	0241584883		Bomboa, Apam 	active	93
19						active	94
20	Castone 	Eshun	0559292975		Paado	active	96
21	Grace	Abaa	0559292975		Roundabout	active	97
22	Richard	Afful	0244792863		Come Down, Apam 	active	99
23						active	100
24	Richard 	Odoom	0249729500		Mumford	active	102
25	Augustina 	Ochere			Mumford	active	103
26	Samuel 	Appoh 	0546487093		Bomboa, Apam 	active	105
27	Elizabeth 	Appoh 	0595544632		Bomboa, Apam 	active	106
28	Joseph	Yankson	043073131		Mumford	active	108
29	Ruth	Yankson	0555072322		Mumford	active	109
30	Elizabeth 	Essel	0243102752		Nsuekyir, Apam 	active	111
31						active	112
32	Elijah	Quansah	0244795971		White house	active	114
33	Mavis 	Quansah			white House ,CAC	active	115
34	Rebecca 	Sagoe	0554618503		Old Bank, Apam 	active	117
35						active	118
36	Grace 	Abban	0558544021		Ankamu	active	120
37	Samuel	Baah	0243510164		Ankamu	active	121
38	Ruth	Arthur 	0555484662		Nsuekyir, Apam 	active	123
39						active	124
40	Isaac 	Kum Arhin	0594516062		Apam	active	126
41	Joana	Sackey	0541473850		Methodist ,Apam	active	127
42	Akosua Tiwaa 	Acquah	0541641132		Apam	active	129
43	Samuel 	Acquah	0249825957		Apam	active	130
44	Francis	Ehun	0247999113		Blankson Park, Apam 	active	132
45						active	133
46	Diana	Nketiah	0533002891		Salvation	active	135
47	John 	Mensah			Salvation	active	136
48	Kobina	Gyesi 	0242956655		Hackman junction, Apam 	active	138
49						active	139
50	Elizabeth 	Appoh	0595544632		Bomboa	active	141
51	Samuel 	Appoh	0546487093		Bomboa	active	142
52	Laura	Bediako	0546303101		Genesis Junction, Apam 	active	144
53						active	145
54	Mercy 	Koranteng	0244911774		Nsuakyire	active	147
55	John 	Sey	0249550502		ROMAN SCHOOL	active	148
56	Roselove	Essilfie	0597610215		Mumford	active	150
57						active	151
58	Sarah 	Ahor	0245682218		Apam Junction 	active	153
59						active	154
60	Mercy	Ackom	0241511673		Apam,zongo	active	156
61	Daniel	Akorful			Apam zongo	active	157
62	Hajara	Abdullah	0544105949		Apam Junction 	active	159
63					. 	active	160
64	Vida	Dadzie	0541185861		Bomboa, Apam 	active	162
65						active	163
66	Philip 	Mankoe			Mumford	active	165
67	Veronica 	Mensah	0246979341		mumford	active	166
68	Charity	Nyarko	0546674485		Apam junction 	active	168
69						active	169
70	Esther	Arthur 	0553751684		Nsawam, Apam 	active	171
71						active	172
72	Mary	Arthur	0249481159		Abaakwa	active	174
73	Benjamin	Obeng Arthur			Abaakwa	active	175
74	Sophia	Mensah 	055091558		Genesis school 	active	177
75	Samuel 	Mensah 	0548245540		Genesis school	active	178
76	Ceclia	Abbiw 	0243823002		Mumford 	active	180
77						active	181
78	Susana	Wilson	058533446		Mumfarm	active	183
79						active	184
80	Elizabeth 	Amoh	0249117021		Apam Nsawam	active	186
81						active	187
82	Eric 	Mensah 			Spain	active	189
83	Elizabeth	Rockson	0244624823		Hello hello	active	190
84	Christopher 	Appiah 	0244242642		Nsuekyir, Apam 	active	192
85						active	193
86	Hannah	Asumaning	0555155675		Apam, Lake Lane	active	195
87	Samuel	Asumaning 				active	196
88	Sandra	Caiquio	0541563685		Apam lake lane	active	198
89						active	199
90	Reuben  	Mensah 	0208732299		Ultimate School 	active	201
91	Sarah 	Adentwi	0548495108		Ultimate School	active	202
92	Gifty	Essieku	0540756347		Mumford	active	204
93						active	205
94	Elizabeth	Pantsil	0248718372		Mumford	active	207
95	Gilbert	Eturuw	0246910851		Mumford	active	208
96	Francisa	Nukunor	0246435776		Apam Junction 	active	210
97						active	211
98	Mary 	Opare	0550899847		Botsio	active	213
99	Emmanuel 	Opare	0248275779		Botsio	active	214
100	Comfort 	Dadzie 	0245040468		Nsawam, Apam 	active	216
101						active	217
102	Linda	Ackon	0243634499		Apam nsawam	active	219
103						active	220
104	Joseph 	Oppong	0536286799		Behind GREATER GRACE	active	222
105	Rita 	Oppong				active	223
106	Hawa	Nayal	0566789994		Kaneshie	active	225
107	Nayal	Okai	0543507348		Apam 	active	226
108	Justice	Komedzie 	0540616305		Nsuekyir, Apam 	active	228
109						active	229
110	Francis 	Otoo	0244020290			active	231
111	Janet	Awotwe	0557533699		Blankson park	active	232
112	Veronica 	Amissah	0244053514		Apam junction 	active	234
113			0			active	235
114	Alice	Acquah	0542159078		Apam	active	237
115	Alice	Acquah	0542959078		Apam	active	238
116	Ekow 	Abekah			Nyamekye school 	active	240
117	Philomina 	Asare 	0241674291		Nyamekye	active	241
118	Mercy 	Arkom	0241511673		Apam zongo	active	243
119						active	244
120	Mary	Aidoo	0248565113		Nsuekyir, Apam 	active	246
121						active	247
122	Rita	Appiah			Botsio	active	249
123						active	250
124	Eugene 	Asare	0246512181		presbyterian school	active	252
125	Sarah 	Asare	0241247390		presbyterian school 	active	253
126	Jude	Baffoe	0553483288		Apass	active	255
127						active	256
128	Mary Ansah	Opare	0550899847			active	258
129						active	259
130	Harriet	Obossu	0246106414		Apam junction 	active	261
131	0					active	262
132	Sarah	Quartey	0240809706		Apam mamfam	active	264
133						active	265
134	Benjamin	Owusu Mends 	0243867662		Hackman junction, Apam 	active	267
135						active	268
136	Millicent	Amenuvor	0240281579		Botsio	active	270
137	0					active	271
138	Gladys	Owoo	0553955716		Apam bomboa	active	273
139						active	274
140	Anna	Plange	0555155675		Apam lake lane	active	276
141						active	277
142	John	Afedzi	0555306835		Apam nsawam	active	279
143						active	280
144	Elizabeth 	Essandoh 	0247056218		Come Down, Apam 	active	282
145						active	283
146	Joana	Sarkey	0541473850		Apam hospital 	active	285
147						active	286
148	Ruth	Mensah 	0557791097		Lighthouse	active	288
149	Dennis	Forson	0557791097		Lighthouse	active	289
150	Edward	Nyame	0243141075		Mumford	active	291
151	Justina	Nyame	0249995900		Mumford	active	292
152	Deborah	Otwey	0244294562		Mumford	active	294
153	Isaac	Otwey	0244178293		Mumford	active	295
154	Sandra	Abekah	0540140321		Apam round about 	active	297
155						active	298
156	Agnes 	Sam	055339768		Nsawam, Apam 	active	300
157						active	301
158	John	Arthur	0591028585		Mumford 	active	303
159						active	304
160	Funny	Tawiah 	0554799399		Botsio	active	306
161	Eric 	Tawiah	0244482333		Botsio	active	307
162	Theresah	Donkoh	0241178691		Mumford	active	309
163	Kwame	Odoom	0244968364		Mumford	active	310
164	Sarah 	Bentum	0543975886		Nsuekyir 	active	312
165						active	313
166	Albeta	Otsiwah	0547158767		Mumford 	active	315
167						active	316
168	Abigail	Afful	024071003		Hospital 	active	318
169	Samuel 	Yankson	0246465465		Hospital 	active	319
170	John	Botwey	0243080589		Apam round about 	active	321
171						active	322
172	Joseph 	Koomson	0547827723		Mamfam, Apam 	active	324
173	Miriam 	Bondzie	0551007123		Mamfam, Apam 	active	325
174	Robert	Gyesi	0240106396		Mumford 	active	327
175						active	328
176	Mathias 	Pelmiitey 	0541086752		Methodist School, Apam 	active	330
177	Vida 	Pelmiitey 	0541176281		Methodist School, Apam 	active	331
178	Gifty 	Sarsah	0543749894		Apam bomboa	active	333
179						active	334
180	Christiana	Abekah	0		Takoradi	active	336
181	James	Abekah	0241757131		Apam Ultimate	active	337
182	Diana	Otabil	0559485843		Mamfam	active	339
183	Paul	Nyarkoh	0		Mamfam	active	340
184	Priscilla 	Tetteh	0559605015		Apam	active	342
185						active	343
186	Esther Dufie	Owusu	0249998323		Apam-Hospital	active	345
187	David	Appiah	0245115114		Cape Coast	active	346
188	Grace	Annan	0242239721		Mumford	active	348
189	Joseph	Afful	0550480559		Mumford	active	349
190	Theresah	Akua Asare	0557044645		Mumford-fordcity	active	351
191	Frank	Asare	0249509484		Mumford-fordcity	active	352
192	Jade	Nyavor	0592895255		Akamu	active	354
193	James	Nyavor	0592895255		Akamu	active	355
194	Patricia	Quaicoe	0559397781		Apam-Methodist school	active	357
195	Paul	Awotwe	0246813602		Apam-Methodist school	active	358
196	Pastor Daniel Kwabena	Adu	0241478942		Kyerikwanta	active	360
197	Lydia	Marfo	0241478942		Kyerikwanta	active	361
198	Selina	Mensah 	0247929669		Mumford	active	363
199	Joesph	Arthur	0247929669		Mumford	active	364
200	Ernerst	Amissah	0243058202		Apam	active	366
201	Ruth	Baiden	0547928895		Apam	active	367
202	Lezebeth	Anaman	0554743199		Mumford-Odukum	active	369
203	Emmanuel	Ewusi-Bondzie	0554743199		Mumford-Dankor	active	370
204	Mabel	Mensah	0551413228		Apam senior High school	active	372
205	Mathias 	Coly	0543337313		Apam-Mamfam	active	373
206	Flex	Arhin	0249284680		Apam	active	375
207	Cythia	Bonya	0249284680		Apam	active	376
208	Grace	Mensah 	0532880810		Quaquah House-Apam	active	378
209	Justice	Aidoo	0244256022		Quaquah House-Apam	active	379
210	Emmanuel	Amenuvor	0247062218		Apam-Botsio	active	381
211	Millicent	Amenuvor	0240281579		Apam-Botsio	active	382
212	Evelyn Aba Mensima	Dampson	0244524079		Apam-Nsuekyire	active	384
213	Ralaph	Essilifie	0242302733		Apam-Nsuekyire	active	385
214	Linda	Boison	0598048430		Akamu	active	387
215	Emmanuel 	Boison	0553092632		Akamu	active	388
216	Bernice 	Ewura Esi Donkor	0547159410		Apam junction	active	390
217	Emmanuel	Egyir	0246933156		Mumford	active	391
218	Linda	Efua Quansah	0599135161		Bomboa	active	393
219	Elder Isaac Rhema	Fiifi Essandoh	0241350041		Bomboa	active	394
220	Sandra	Obeng	0547888156		Apam junction	active	396
221	Isaac	Obeng	0543397281		Apam junction	active	397
222	Gladys	Sam	0591429342		Mumford	active	399
223	Egya Kow	Ninsin	0591429342		Mumford	active	400
224	Mary	Oboh Quaye	0241585488		Apam-Nsuekyire	active	402
225	Samuel	Quaye	0246284984		Apam-Nsuekyire	active	403
226	Elizabeth	Quaye	0536456852		Apam-Abaakwa	active	405
227	Isaac	Tetteh	0543493527		Apam-Abaakwa	active	406
228	Ishmeal	Agbi	0548665514		Sunyani	active	408
229	Ernestina	Quansah	0249649486		Apam	active	409
230	Selina	Acquah	0249799739		Apam-Botsio junction	active	411
231	Nana kweku	Andam	0249799739		Agona Bobikuma	active	412
232	Rebecca Esi	Odoom	0538536602		Mumford	active	414
233	Francis Kobina	Acquaye	0545562021		Mumford	active	415
234	Lovia	Cudjoe	0244775371		Apam	active	417
235	Justice	Yorke	0244775371		Apam	active	418
236	David	Essandoh	0545334364		Apam	active	420
237	Winnfred	Tetteh	0248659625		Apam	active	421
238	Grace 	Baidoo	0530055086		Ajumako Bisease	active	423
239	Robert	Amoh	0241744740		Apam-Nsawam	active	424
240	Grace	Mensah 	0544848488		Apam-Nsawam	active	426
241	Bismark	Mensah	0531368909		Apam-Nsawam	active	427
242	Susuana	Adjeibea	0540494678		Apam junction-Agya Appiah 	active	429
243	Amos	Ampomah	0246858502		Mankessim	active	430
244	Abigail	Yawson	0246785201		Mumford-Methodist park	active	432
245	Francis Kobina	Andoh	0246785201		Mumford-Methodist park	active	433
246	Stella	Eduful	0549574786		Apam-Zongo	active	435
247	Kojo	Egyin	0549574786		Apam-Zongo	active	436
248	Elizabath	Essandoh	0247056218		Apam-Calm Down	active	438
249	Joesph	Eyiah-Mensah	0247056218		Apam-Calm Down	active	439
250	Emelia 	Arkorful	0597803958		Bomboa	active	441
251	Kojo	Arkorful	0530274366		Bomboa	active	442
252	Vida	Baidoo	0242913897		Mumford	active	444
253	Joseph	Baidoo	0242913897		Mumford	active	445
254	Rebecca	tetteh	0242707555		Apam Nsuekyire	active	447
255	Joseph	Baidoo	0241046900		Apam Tema Yaa	active	448
256	Rebecca	aidoo	0558765274		Apam-Nsuekyire	active	450
257	Pious	Botchwey	0556872086		Apam-Nsuekyire	active	451
258	Georgina	Quansah	0247531426		Apam-Mamfam	active	453
259	Georgina	Quansah	0247531426		Apam-Mamfam	active	454
260	Mabel	Ekwam	0547786463		Apam Round About	active	456
261	Benjamin	Ekwam	0243977093		LIghthouse school	active	457
262	Mary	Kaitu	0553090265		Apam junction	active	459
263	Stephen Kofi	Kaitu	0541927334		Apam junction	active	460
264	Aunty Naa	Abraham	0244578802		Apam council	active	462
265						active	463
266	Francis	Aidoo	0244592893		Apam Nsuekyir	active	465
267						active	466
268	Gifty Esi	Luomor	0249613523		Bifirst	active	468
269	Ernest Kofi	Quaye	0249613523		Bifirst	active	469
270	Esther	Essuon	0545369476		Mumford mangoase	active	471
271						active	472
272	Mavis	Clayman	0557039161		Apam junction	active	474
273	Daniel Kwesi	Ofori-Atta	0555838781		Apam junction	active	475
274	Mathias	Amankwah	0557437358		Apam junction 	active	477
275						active	478
276	Esther	Essoun	0595968384		Mumford,Mangoase	active	480
277	Emmanuel	Owusu	0247033304		Mumford, New site	active	481
278	Georgina	Adams	0545369061		Apam calm down	active	483
279						active	484
280	Dorothy 	Appiah	0241929725		Apam junction	active	486
281	Emmanuel	Otoo	0544634588		Apam junction	active	487
282	Elizabeth 	Armah	0599870182		Apam Nsuekyir 	active	489
283						active	490
284	Margaret	Siripi	0546160652		Apam round about	active	492
285	Ernest	Okoe Martey	0245529801		Apam round about	active	493
286	Mary	Dadzie	0548363040		Apam park avenue	active	495
287						active	496
288	Agnes	Mensah	0541632071		Mumford park	active	499
289						active	500
290	Olivia		0242166216			active	502
291						active	503
292	Florence	Amoah	0245436194		Apam junction 	active	505
293						active	506
294	Doris Ama	Aidoo	0549282954		Lake Lane, Apam 	active	508
295						active	509
296	Benetta	Brown	0247567719		Apam near apass	active	511
297						active	512
298	Ali	Abdul	0542288449		Bomboa	active	514
299						active	515
300	Charity	Korsah	0541199220		Apam Botsio	active	517
301						active	518
302	Beatrice	Attisey	0245787635		Apam Botsio junction	active	520
303	Richard Attisey	Attisey	0245787635		Apam Botsio junction	active	521
304	Comfort 	Arthur 	0559293457		RoundAbout, Apam 	active	523
305						active	524
306	Rebecca	Pratt	0240709697		Apam	active	526
307						active	527
308	Sarah	Mensah	0548495108		Apam ultimate junction 	active	529
309						active	530
310	Bridget	Arthur	0247566656		Mumford 	active	532
311		0				active	533
312	Agnes	Otoo	0242929220		Apam hospital 	active	535
313						active	536
314	Dufie		0540564903		Nsuekyir	active	538
315						active	539
316	Benedict	Crenstil	0555309450		Apam round about 	active	541
317						active	542
318	Richard 	Odoom	0249729500		Mumford 	active	544
319						active	545
320	Cynthia	Avormey	0249690895		Apam hospital 	active	547
321						active	548
322	Elizabeth 		0243102752		Nsuekyir	active	550
323						active	551
324	Sett	Mensah	0554488133		Apam nsuekyir	active	553
325						active	554
326	Isaac 	Appiah	0242658952		Lighthouse School, Apam	active	556
327						active	557
328	Abigail 	Nyarkoh	056712940		Apam Nsawam 	active	559
329						active	560
330	Clement	Coffie 	0241843002		Mumford 	active	562
331						active	563
332	Emmanuel 	Atsu	0543507781		Mumford 	active	565
333						active	566
334	Christiana	Arman				active	568
335						active	569
336	Cecilia		0595227560		Mumford 	active	571
337						active	572
338	Evelyn	Anim 	0545059957		Nsawam	active	574
339	Isaac	Tawiah	0246114941		Nsawam	active	575
340	Getrude 	Kwakye 	0549281967		Nsawam	active	577
341	Philip	Budu	0244623997		Nsawam	active	578
342	Victoria	Boison	0544478484		Nsuekyir	active	580
343	Vincent 	Esssndoh	0547326067		Nsuekyir	active	581
344	Gifty	Afadzie	0556699610		Apam Junction 	active	583
345	E.K	Nsarkoh	0278621593		Apam Junction 	active	584
346	Godwin	Owusu				active	586
347	Gifty	Owusu				active	587
348	Elijah	Quansah	0244795971			active	589
349						active	590
350	Rebecca 	Acquah	0542893936		Apam junction 	active	592
351						active	593
352	Rita	Appiah	0246391983		Botsio	active	595
353						active	596
354	Isaac 	Appiah	0242658952		Lake lane	active	598
355						active	599
356	Esi 	Amba	0551540830		Bomboa	active	601
357						active	602
358	Anita		0553752598			active	604
359						active	605
360	Theresah		0555242214		Mumford 	active	607
361						active	608
362	Gifty		0546303123		Botsio	active	610
363						active	611
364	Helena	Hayford	0545292995			active	613
365						active	614
366	Ernestina	Aggrey	0547534482		Nsawam	active	616
367						active	617
368	Gloria	Baiden	0245089261		Charity	active	619
369						active	620
370	Joyce		0599276197		Abaakwa 	active	622
371						active	623
372	Agnes	Eyiah	0548484444		Nsuekyir	active	625
373						active	626
374	Abigail	Ansah	0541208605		Bomboa	active	628
375						active	629
376	James 	Abbiw 	0242943224		Mumford 	active	631
377						active	632
378	Mary	Botchwey 	0557608774		Tema Yaa	active	634
379						active	635
380	Hannah 	Asuman	0550338333		Methodist 	active	637
381						active	638
382	Dina	Annan	0246770863		Nsuekyire 	active	640
383						active	641
384	Comfort 	Mensah 	0248661457		Blankson park	active	643
385						active	644
386	Cythia	Hazjor	0249804075		Blankson park 	active	646
387						active	647
390	Mavis	Dampson 	0541210905		Agankabow	active	652
391						active	653
392	Francis	Acquaye	0538536602		Mumford	active	655
393						active	656
394	Bro	Kweku	0241583232		Asafo Dan ho	active	658
395						active	659
396	Dorcas	Amoasi	0535849622		Kings table 	active	661
397						active	662
398	Joyce 	Tawiah	0249497951		Mumford 	active	664
399						active	665
400						active	667
401	Patience 	Koomson	0248514939		Amumudo	active	669
402						active	670
403						active	672
404	Doris 	Aidoo	0549282954		Lake lane	active	674
405						active	675
406	Rebecca 	Sagoe	0554618503		Egyapaado	active	677
407						active	678
408	Agnes	Anderson	0598734560		Filling station	active	680
409						active	681
410	Patience 	Anderson 	0553035306		Methodist 	active	683
411						active	684
412	Ruth	Annan	0240504848		Botsio	active	686
413						active	687
414	Mary	Otoo			Methodist 	active	689
415	0					active	690
416	Janet	Nyarkoh 	0244843533		Mumford 	active	692
417						active	693
418	Rita	Annan	0245701508		Nsuekyir	active	695
419						active	696
420	Mary 	Obeng 	0554676704		Mankoadzie	active	698
421						active	699
422	Sis	Gladys	0546303027		Mumford	active	701
423						active	702
424	Ayiden		0530413816		Blankson park 	active	704
425						active	705
426	Millicent	Arhin	0242365522		Round about 	active	707
427						active	708
428	Justina	Aidoo	0553473511		Come down	active	710
429						active	711
430	Elizabeth 	Egyir	0546425432		Nsawam 	active	713
431						active	714
432	Sis	Efua	0241917353		Mumford	active	716
433						active	717
434	Francisca 	Dotse	0246435776		Apam Junction 	active	719
435						active	720
436	Georgina	Mensah 	0544362097		Nsawam	active	722
437						active	723
438	Esi	Donkor	0241178691		Mumford 	active	725
439						active	726
440	Emmanuel	Darkoh	0258721154		Abaakwaa	active	728
441						active	729
442	Papa	Amo	0249209813		Hospital 	active	731
443						active	732
388	Hannah	Appiah	0241568827		Ankamu	active	649
444	Emelia	Tetteh	0556734079		Round about 	active	734
445						active	735
446	Catherine	Essel	0592428479		Abaakwaa	active	737
447						active	738
448	Joana	Addo	0249901861E		Egyankabow	active	740
449						active	741
450	Abass	Ibrahim 	0555041756		Apam Junction 	active	743
451						active	744
452	Miriam	Bondzie	0242218484		Asafo Dan ho	active	746
453						active	747
454	Patience 	Adjei	0248877673		Nsuekyire 	active	749
455						active	750
456	Zalai	Moses	0551455551		Bomboa	active	752
457						active	753
458	Grace	Quaicoe	0546425423		Nsuekyir	active	755
459						active	756
460	Mena	Aba	0594141906		roundabout	active	758
461						active	759
462	Sackey		0543645532		Ultimate	active	761
463						active	762
464	Theresah	Ansong	0241584883		Old police headquarters	active	764
465						active	765
466	Patience 	Ayitey	0548304068		Bomboa	active	767
467						active	768
468	Comfort	Mensah 	0543192679		Bomboa	active	770
469						active	771
470	Augustina	Baidoo	0540964425		Nsuekyir	active	773
471						active	774
472	Gina		0593793311		Nsuekyir	active	776
473						active	777
474	Benjamin 	Incoom	0557228887		Ankamu	active	779
475						active	780
476	Esther	Oppong	0553951091		Rabbi junction	active	782
477						active	783
478	Ayiden		0530413816		Lake lane	active	785
479						active	786
480	Reuben  	Mensah 	0208732299		Apam	active	788
481						active	789
482						active	791
483	Ruby	Onumah	0257156105		Ankamu	active	793
484						active	794
485	Mavis	Dadzie	0546999497		roundabout	active	796
486						active	797
489	Deborah	Abedu Kennedy	0244294562		Mumford	active	802
490						active	803
491	Wonder	Ayivor	0544204838		Apam	active	805
492						active	806
487	Precious	Adom	0241965228		Lake lane	active	799
488						active	800
389						active	650
493	Ernerstina		0249649486		Abaakwaa	active	808
494						active	809
495	Lydia	Edu	0240256996		Gomoa kyeren nkwanta	active	811
496						active	812
497	Agnes		0592766287		Abaakwaa	active	814
498						active	815
499	Abigail	Asiedu	0548021670		Apam junction 	active	817
500						active	818
501	Sarah		0247083728		Bomboa	active	820
502						active	821
503	Sophia		0548469986		Ankamu	active	823
504						active	824
505	Araba		0241172043		Nsuekyir	active	826
506						active	827
507	Faustina		0249416309		Nsuekyir	active	829
508						active	830
509	Mildred		0534585652		Ankamu	active	832
510						active	833
511	Grace		0552204934		Lake lane	active	835
512						active	836
513	Vivian		0536854482		Ankamu	active	838
514						active	839
515	Okai		0543507348		Roundabout	active	841
516						active	842
517	Mary	Opare	0550899847		Botsio	active	844
518						active	845
519	Naana		0531834943		Mumford	active	847
520						active	848
521	Comfort		0539478272		Behind Greater Grace	active	850
522						active	851
523	Ruth		0535368891		Botsio	active	853
524						active	854
525	Esther		0553751684		Nsawam	active	856
526						active	857
527	Priscilla	Sam	0242174938		Mamfam	active	859
528						active	860
529	Augustina	Ewusi	0242562834			active	862
530	Robert	Akese				active	863
531	Millicent 	Kumah	0240281579		Botsio-Apam	active	865
532	Emmanuel 	Komla Amenuvor	0247062218		Botsio-Apam	active	866
533	Emelia 	Nkrumah	0247840634		Ankamu	active	868
534	Joseph	Amissah Bempong	0541168369		Ankamu	active	869
535	Emelia 	Nkrumah	0247840634		Ankamu	active	871
536	Josep	Amissah Bempong	0541168369		Ankamu	active	872
537	Ellen	Amissah	0550029519		Apam	active	874
538						active	875
539	Chiana	Talata	0249650965		Apam	active	877
540	Isaac 	Anaafi	0549925210		Apam	active	878
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (permission_id, permission_name) FROM stdin;
70	view attendance
71	take attendance
72	view attendance report
73	view attendance analytics
74	view classes
75	add class
76	delete class
77	view events
78	add event
79	add expense
80	view feeding fee and tnt
81	take feeding and tnt
82	take fees
83	view finances
84	add bills
85	view examinations
86	record assessment
87	promote students
88	view masters sheet
89	view report cards
90	add remarks
91	add grading scheme
92	add health incident
93	view health record
94	send sms
95	view sms
97	send notification
98	view parents
99	delete parents
100	view semesters
101	close semester
102	add semester
103	delete semester
104	view staff
105	add staff
106	evaluate staff
107	delete staff
108	view students
109	add student
110	delete student
111	view subjects
112	add subjects
113	add subject
114	delete subject
115	add timetable
116	add role
117	delete user
118	assign roles
119	assign permissions
120	delete event
121	view fees
122	view student's payment history
123	view financial report
124	delete grading scheme
125	view users
126	view items
127	delete item
128	manage supply
129	view stock items
130	delete supply items
96	view notifications
131	edit expense
132	edit collected fees
\.


--
-- Data for Name: procurements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procurements (procurement_id, item_id, supplier_id, unit_cost, quantity, total_cost, procurement_date, brought_by, received_by, received_at, status) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
2	75
2	78
2	79
2	91
2	90
2	102
2	105
2	113
2	112
2	115
2	101
2	76
2	109
2	120
2	124
2	99
2	103
2	107
2	110
2	114
2	106
2	128
2	87
2	97
2	94
2	71
2	81
2	82
2	70
2	73
2	72
2	74
2	77
2	85
2	80
2	121
2	83
2	123
2	126
2	88
2	96
2	98
2	89
2	100
2	95
2	104
2	129
2	122
2	108
2	111
2	125
3	70
3	71
3	72
3	73
3	74
3	77
3	85
3	88
3	89
3	90
3	92
3	98
3	100
3	104
3	108
3	111
3	126
3	129
3	96
3	109
1	84
1	75
1	78
1	79
1	91
1	92
1	90
1	116
1	102
1	105
1	109
1	113
1	112
1	115
1	119
1	118
1	101
1	76
1	120
1	124
1	127
1	99
1	103
1	107
1	110
1	114
1	130
1	117
1	106
1	128
1	87
1	86
1	97
1	94
1	71
1	81
1	82
1	70
1	73
1	72
1	74
1	77
1	85
1	80
1	121
1	83
1	123
1	93
1	126
1	88
1	96
1	98
1	89
1	100
1	95
1	104
1	129
1	122
1	108
1	111
1	125
1	132
1	131
5	75
5	78
5	91
5	90
5	113
5	112
5	94
5	108
5	111
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
1	Admin
2	Head Teacher
3	Teaching Staff
4	feeding fee collector
5	ICT OFFICER
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (room_id, room_name) FROM stdin;
\.


--
-- Data for Name: semesters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semesters (semester_id, semester_name, start_date, end_date, status) FROM stdin;
9	First Term	2025-01-08	2025-03-28	active
\.


--
-- Data for Name: sms_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sms_logs (id, recipient_type, message_type, sender_id, recipients_id, message_content, total_attempeted, total_invalid_numbers, total_successful, total_failed, successful_recipients_ids, failed_receipients_ids, invalid_recipients_ids, invalid_recippients_phone, api_response, send_timestamp, total_sms_used) FROM stdin;
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (staff_id, user_id, first_name, last_name, middle_name, date_of_birth, gender, marital_status, address, phone_number, email, emergency_contact, date_of_joining, designation, department, salary, account_number, contract_type, employment_status, qualification, experience, blood_group, national_id, passport_number, photo, teaching_subject, class_teacher, subject_in_charge, house_in_charge, bus_in_charge, library_in_charge, status, role) FROM stdin;
19	55	Veronica	Aggrey		2002-07-07	F	Single	NSAWAM	0533213998		0540383063	2022-01-01		PRIMARY	0.00		Full-time	Active	WASSCE	3 YEARS		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
20	56	Isaac	Mankoe		2004-07-06	M	Single	MUMFORD	0242445132		0556866312	2025-01-08		JHS	0.00		Full-time	Active	WASSCE	0		1234567		\N	INTEGRATED SCIENCE	\N	\N	\N	\N	\N	active	teaching staff
17	47	Alex	Ankah 	Junior	1992-06-03	M	Single	P.O.Box 74\nApam	0249248800		0249248800	2017-01-01		JHS	0.00		Full-time	Active	Diploma	8 years experience	B+	1234567		\N	Fante	\N	\N	\N	\N	\N	active	teaching staff
21	57	Isaac	Danquah		1997-01-11	M	Single	BOTSIO	0559276180		0559276180	2024-01-08		JHS	0.00		Full-time	Active	DEGREE	7 YEARS		1234567		\N	MATHEMATICS	\N	\N	\N	\N	\N	active	teaching staff
18	54	Obed	Takyi	Godsmal	1999-03-11	M	Single	BOTSIO	0559616009		0243761990	2022-01-11		JHS	0.00		Full-time	Active	HND IN COMPUTERS AND BUSINESS MANAGEMENT	6 YEARS		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
22	58	Abubakar	Osman		1989-06-11	M	Married	Apam - Akyerema	0598770210		0545237004	2017-01-15		PRIMARY	0.00		Full-time	Active	Diploma	7 YEARS	O+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
23	59	Joseph	Panyin	Smith	1994-08-19	M	Single	Nsawam, Apam	0543372395		0242283910	2021-02-11		PRIMARY	0.00		Full-time	Active	DEGREE	5 years	O+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
24	60	Joseph	Essel		2002-10-20	M	Single	Nsawam, Apam	0546425423		0546813779	2022-05-12		PRIMARY	0.00		Full-time	Active	WASSCE	3 years	B+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
25	61	Alexander	Appiah		2003-04-22	M	Single	Nsawam, Apam	0553955077		0240645813	2023-07-31		PRIMARY	0.00		Full-time	Active	WASSCE	2 years	A-	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
26	62	Miriam	Ledlum	Sika	2006-03-10	F	Single	Bomboa, Apam	0535455874		0244161256	2024-01-01		PRIMARY	0.00		Full-time	Active	WASSCE	1 year		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
27	63	Robert	Eyiah-Mensah		1993-04-06	M	Single	Nsawam, Apam	0535206375		0247286139	2014-09-11		PRIMARY	0.00		Full-time	Active	DEGREE	10 years	A+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
28	64	Mercy	Yorke	Aba	1995-06-22	F	Married	Nsuekyir, Apam	0539478272		0246552669	2024-09-03		PRIMARY	0.00		Full-time	Active	WASSCE	5 years	A-	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
29	65	Kennedy 	Adu-Mensah	Junior	1992-01-05	M	Single	Bomboa, Apam	0595031180		0545453152	2013-06-18		PRIMARY	0.00		Full-time	Active	Diploma	12 Years		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
30	66	Elizabeth	Wilson		1988-05-07	F	Single	Nsawam, Apam	0546813779		0244946071	2010-01-25		ADMINISTRATION	0.00		Full-time	Active	JSS	15 YEARS		1234567		\N		\N	\N	\N	\N	\N	active	non teaching
31	67	Eunice 	Appiah		1986-08-08	F	Married	Egyaa Paado, Apam	0545428850		0244719668	2021-01-12		ADMINISTRATION	0.00		Full-time	Active	DEGREE	12 years	O+	1234567		\N		\N	\N	\N	\N	\N	active	head staff
33	69	Ebenezer	Andoh		1993-11-07	M	Single	Botsio Jnc, Apam	0241893989		0247813326	2021-01-12		PRESCHOOL	0.00		Full-time	Active	DEGREE	8 years experience	A+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
34	70	Mary	Mensah		1993-08-24	F	Married	AKyerema, Apam	0533423594		0541572522	2021-01-02		PRESCHOOL	0.00		Full-time	Active	WASSCE	5 years	AB+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
32	68	Janet	Hammond	Sey	1994-08-15	F	Married	Akyerema, Apam	0545237004		0598770210	2021-01-12		PRESCHOOL	0.00		Full-time	Active	WASSCE	5 years		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
35	71	Mary	Simpson		2000-06-26	F	Single	Bomboa, Apam	0242185756		0545587585	2021-01-01		PRESCHOOL	0.00		Full-time	Active	WASSCE	4 Years	O+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
36	72	Obed	Gyasi		2002-12-20	M	Single	Akyerema, Apam	0256742008		0538158128	2023-07-21		PRIMARY	0.00		Full-time	Active	WASSCE	2 years	O+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
37	73	Priscilla	Quaye		2003-09-18	F	Single	Nsawam, Apam	0546769734		0543324422	2023-01-07		PRIMARY	0.00		Full-time	Active	WASSCE	2 years		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
38	74	Cecilia	Abban		2002-09-29	F	Single	Akyerema, Apam	0593876687		0541572522	2024-09-02		PRESCHOOL	0.00		Full-time	Active	WASSCE	1 year	O+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
39	75	Susana	Essel		1998-04-02	F	Single	Mamfam, Apam	0532614330		0241069300	2021-01-21		PRESCHOOL	0.00		Full-time	Active	WASSCE	4 Years		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
40	76	Comfort	Bondzie		2002-04-09	F	Single	Bomboa, Apam	0549156976		0532635542	2022-10-10		PRESCHOOL	0.00		Full-time	Active	WASSCE	3 YEARS		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
41	77	Ernestina	Aggrey		1989-05-18	F	Married	Nsawam, Apam	0547534482		0248852949	2010-01-02		PRESCHOOL	0.00		Full-time	Active	SSCE	10 years		1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
42	78	Ruth	Aidoo		1999-04-13	F	Married	Akyerema, Apam	0559984736		0240150648	2021-06-13		PRESCHOOL	0.00		Full-time	Active	WASSCE	4 Years	O+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
43	79	George	Enninful		1998-04-19	M	Single	ZONGO,APAM	0551577509		0243267818	2023-01-10		JHS	0.00		Full-time	Active	WASSCE	8years		123		\N	RME	\N	\N	\N	\N	\N	active	teaching staff
44	80	Erica,	Appuah	Adams	1998-08-27	F	Single	ROMAN SCHOOL, APAM	0553230024	adamserica46@gmail.com	0201813287	2024-04-09		JHS	0.00		Full-time	Active	DEGREE 	5	O+	00000000		\N	ENGLISH	\N	\N	\N	\N	\N	active	teaching staff
45	81	MICHAEL	EYIAH-MENSAH		1995-06-26	M	Single	ZONGO, APAM	0545592090	eyiahmensahmichael@gmail.com	0249050524	2023-01-10		JHS	0.00		Full-time	Active	WASSCE	10years	A+	GHA-005231104-4		\N	SOCIAL STUDIES	\N	\N	\N	\N	\N	active	teaching staff
46	82	Linda	Otabil	Egyir	2002-01-25	F	Single	Nsawam, Apam	0591640341		0249180098	2025-01-09		JHS	0.00		Full-time	Active	Diploma	1yr	O+	0		\N	Career Technology	\N	\N	\N	\N	\N	active	teaching staff
47	497	Prince	Donkor		2002-01-29	M	Single	Apam, Opp.m Roman Church	0551299763		0241657532	2022-01-10		PRIMARY	0.00		Full-time	Active	WASSCE	2 years	O+	1234567		\N		\N	\N	\N	\N	\N	active	teaching staff
\.


--
-- Data for Name: student_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_grades (grade_id, student_id, subject_id, class_id, user_id, gradescheme_id, semester_id, class_score, exams_score, total_score, status, created_at) FROM stdin;
\.


--
-- Data for Name: student_parent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_parent (student_id, parent_id, relationship, status) FROM stdin;
7	10	Mother 	active
7	11	Father 	active
8	12	Mother	active
8	13	Father	active
9	14	Mother	active
9	15	0	active
10	16	father	active
10	17	Mother	active
11	18	Mother	active
11	19	0	active
12	20	father	active
12	21	Mother	active
13	22	Father 	active
13	23	0	active
14	24	father	active
14	25	Mother	active
15	26	Father 	active
15	27	Mother 	active
16	28	father	active
16	29	Mother	active
17	30	Mother 	active
17	31	0	active
18	32	father	active
18	33	Mother	active
19	34	Mother	active
19	35	0	active
20	36	Mother	active
20	37	Father	active
21	38	Mother 	active
21	39	0	active
22	40	father	active
22	41	Mother	active
23	42	Mother	active
23	43	Father	active
24	44	Father	active
24	45	0	active
25	46	Mother 	active
25	47	Father 	active
26	48	Father	active
26	49	0	active
27	50	Mother	active
27	51	Father	active
28	52	Mother	active
28	53	0	active
29	54	Mother 	active
29	55	Father 	active
30	56	Mother	active
30	57	. 	active
31	58	Mother 	active
31	59	0	active
32	60	Mother	active
32	61	Father	active
33	62	Mother	active
33	63	.	active
34	64	Mother 	active
34	65	0	active
35	66	father	active
35	67	Mother	active
36	68	Mother	active
36	69	0	active
37	70	Mother 	active
37	71	0	active
38	72	Mother	active
38	73	Father	active
39	74	Mother 	active
39	75	Father 	active
40	76	Mother	active
40	77	0	active
41	78	Mother	active
41	79	0	active
42	80	Mother	active
42	81	0	active
43	82	father	active
43	83	Mother	active
44	84	Father	active
44	85	0	active
45	86	Mother	active
45	87	Father	active
46	88	Mother	active
46	89	0	active
47	90	father	active
47	91	Mother	active
48	92	Mother	active
48	93	.	active
49	94	Mother	active
49	95	Father	active
50	96	Mother 	active
50	97	0	active
51	98	Mother 	active
51	99	Father 	active
52	100	Grandmother 	active
52	101	.	active
53	102	Mother	active
53	103	0	active
54	104	father	active
54	105	Mother	active
55	106	Mother	active
55	107	Father	active
56	108	Father	active
56	109	.	active
57	110	father	active
57	111	Mother	active
58	112	Mother	active
58	113	0	active
59	114	Mother	active
59	115	Mother	active
60	116	father	active
60	117	Mother	active
61	118	Mother	active
61	119	0	active
62	120	Mother 	active
62	121	.	active
63	122	Mother	active
63	123	0	active
64	124	father	active
64	125	Mother	active
65	126	Father	active
65	127	0	active
66	128	Mother	active
66	129	.	active
67	130	Mother	active
67	131	0	active
68	132	Mother	active
68	133	0	active
69	134	Father	active
69	135	.	active
70	136	Mither	active
70	137	0	active
71	138	Mother	active
71	139	0	active
72	140	Mother	active
72	141	0	active
73	142	Father	active
73	143	0	active
74	144	Mother 	active
74	145	.	active
75	146	Mother	active
75	147	0	active
76	148	Mother 	active
76	149	Father 	active
77	150	father	active
77	151	Mother	active
78	152	Mother	active
78	153	Father	active
79	154	Mother	active
79	155	0	active
80	156	Mother 	active
80	157	.	active
81	158	Father	active
81	159	0	active
82	160	Mother	active
82	161	Father	active
83	162	Mother 	active
83	163	Father 	active
84	164	Mother 	active
84	165	.	active
85	166	Mother	active
85	167	0	active
86	168	Mother 	active
86	169	Father	active
87	170	Father	active
87	171	0	active
88	172	Father	active
88	173	Mother	active
89	174	Faather	active
89	175	0	active
90	176	Father	active
90	177	Mother	active
91	178	0	active
91	179	0	active
92	180	Mother	active
92	181	Father	active
93	182	Mother	active
93	183	Father	active
94	184	Mother 	active
94	185	0	active
95	186	Mother	active
95	187	Father	active
96	188	Mother	active
96	189	Father	active
97	190	Mother	active
97	191	Father	active
98	192	Mother 	active
98	193	Father 	active
99	194	Mother	active
99	195	Father	active
100	196	father	active
100	197	Mother	active
101	198	Mother 	active
101	199	Father 	active
102	200	father	active
102	201	Mother	active
103	202	Mother	active
103	203	Father	active
104	204	Mother	active
104	205	Father	active
105	206	father	active
105	207	Mother	active
106	208	Mother 	active
106	209	Father 	active
107	210	father	active
107	211	Mother	active
108	212	Mother	active
108	213	Father	active
109	214	Mother	active
109	215	Father	active
110	216	Mother	active
110	217	Father	active
111	218	Mother	active
111	219	Father	active
112	220	Mother	active
112	221	Father	active
113	222	Mother 	active
113	223	Father 	active
114	224	Mother	active
114	225	Father	active
115	226	Mother	active
115	227	Father	active
116	228	father	active
116	229	Mother	active
117	230	Mother	active
117	231	Father	active
118	232	Mother	active
118	233	Father	active
119	234	Mother 	active
119	235	Father 	active
120	236	father	active
120	237	Mother	active
121	238	Mother	active
121	239	Father	active
122	240	Mother	active
122	241	Father 	active
123	242	Mother	active
123	243	Father	active
124	244	Mother	active
124	245	Father	active
125	246	Mother	active
125	247	Father 	active
126	248	Mother	active
126	249	Father 	active
127	250	Mother	active
127	251	Father	active
128	252	Mother	active
128	253	Father	active
129	254	Mother	active
129	255	Father	active
130	256	Mother	active
130	257	Father	active
131	258	Mother	active
131	259	Mother	active
132	260	Mother	active
132	261	Father	active
133	262	Mother	active
133	263	Father	active
134	264	Mother	active
134	265	0	active
135	266	Father	active
135	267	0	active
136	268	Mother	active
136	269	Father	active
137	270	Mother	active
137	271	0	active
138	272	Mother	active
138	273	Mother	active
139	274	Father	active
139	275	0	active
140	276	Mother	active
140	277	Father	active
141	278	Mother	active
141	279	0	active
142	280	Mother	active
142	281	Father	active
143	282	Mother	active
143	283	0	active
144	284	Mother	active
144	285	Father	active
145	286	Mother	active
145	287	0	active
146	288	Mother	active
146	289	0	active
147	290	Mother 	active
147	291	N	active
148	292	Mother	active
148	293	0	active
149	294	Mother	active
149	295	.	active
150	296	Mother	active
150	297	0	active
151	298	Father 	active
151	299	Father 	active
152	300	Mother	active
152	301	0	active
153	302	Mother	active
153	303	Father	active
154	304	Mother	active
154	305	.	active
155	306	Mother	active
155	307	0	active
156	308	Mother	active
156	309	0	active
157	310	Mother	active
157	311	Mother	active
158	312	Mother	active
158	313	0	active
159	314	Mother 	active
159	315	Mother 	active
160	316	Mother	active
160	317	0	active
161	318	Father	active
161	319	0	active
162	320	Mother	active
162	321	0	active
163	322	Mother 	active
163	323	Mother 	active
164	324	Father	active
164	325	0	active
165	326	Father	active
165	327	.	active
166	328	Mother	active
166	329	0	active
167	330	Father	active
167	331	.	active
168	332	Father 	active
168	333	Father 	active
169	334	Mother 	active
169	335	Mother 	active
170	336	Mother 	active
170	337	Mother 	active
171	338	Mother 	active
171	339	Father 	active
172	340	Mother 	active
172	341	Father 	active
173	342	Mother 	active
173	343	Father 	active
174	344	Mother 	active
174	345	Father 	active
175	346	Father 	active
175	347	Mother 	active
176	348	Father 	active
176	349	Father 	active
177	350	Mother 	active
177	351	Mother 	active
178	352	Mother 	active
178	353	Mother 	active
179	354	Father 	active
179	355	Father 	active
180	356	Mother 	active
180	357	Mother 	active
181	358	Mother 	active
181	359	Mother 	active
182	360	Mother 	active
182	361	Mother 	active
183	362	Mother 	active
183	363	Mother 	active
184	364	Mother 	active
184	365	Mother 	active
185	366	Mother 	active
185	367	Mother 	active
186	368	Mother 	active
186	369	Mother 	active
187	370	Mother 	active
187	371	Mother 	active
188	372	Mother 	active
188	373	Mother 	active
189	374	Mother 	active
189	375	Mother 	active
190	376	Father 	active
190	377	Father 	active
191	378	Mother	active
191	379	0	active
192	380	Mother	active
192	381	0	active
193	382	Mother	active
193	383	0	active
194	384	Mother	active
194	385	0	active
195	386	Mother	active
195	387	0	active
197	390	Mother	active
197	391	0	active
198	392	father	active
198	393	0	active
199	394	Mother	active
199	395	0	active
200	396	Mother	active
200	397	0	active
201	398	Mother	active
201	399	0	active
202	274	father	active
202	400	0	active
203	401	Mother	active
203	402	0	active
204	352	Mother	active
204	403	0	active
205	404	Mother	active
205	405	0	active
206	406	Mother	active
206	407	0	active
207	408	Mother	active
207	409	0	active
208	410	Mother	active
208	411	0	active
209	412	Mother	active
209	413	0	active
210	414	Mother	active
210	415	0	active
211	416	Mother	active
211	417	0	active
212	418	Mother	active
212	419	0	active
213	420	Mother	active
213	421	0	active
214	422	Mother	active
214	423	0	active
215	424	Mother	active
215	425	0	active
216	426	Mother	active
216	427	0	active
217	428	Mother	active
217	429	0	active
218	430	Mother	active
218	431	0	active
219	432	Mother	active
219	433	0	active
220	434	Mother	active
220	435	0	active
221	436	Mother	active
221	437	0	active
222	438	Mother	active
222	439	0	active
223	440	father	active
223	441	0	active
224	442	Father 	active
224	443	0	active
225	444	Mother	active
225	445	0	active
226	446	Mother	active
226	447	0	active
227	448	Mother	active
227	449	0	active
228	450	Father 	active
228	451	0	active
229	452	Mother	active
229	453	0	active
230	454	Mother	active
230	455	0	active
231	456	Mother	active
231	457	0	active
232	458	Mother	active
232	459	0	active
233	460	Mother	active
233	461	0	active
234	462	father	active
234	463	0	active
235	464	Mother	active
235	465	0	active
236	466	Mother	active
236	467	0	active
237	468	Mother	active
237	469	0	active
238	470	Mother	active
238	471	0	active
239	472	Mother	active
239	473	0	active
240	474	father	active
240	475	0	active
241	476	Mother	active
241	477	0	active
242	478	Mother	active
242	479	0	active
243	480	father	active
243	481	0	active
244	193	father	active
244	482	0	active
245	483	Mother	active
245	484	0	active
246	485	Mother	active
246	486	0	active
248	489	Mother	active
248	490	0	active
249	491	Mother	active
249	492	0	active
247	487	Mother	active
247	488	0	active
196	388	Mother	active
196	389	0	active
250	493	Mother	active
250	494	0	active
251	495	Mother	active
251	496	0	active
252	497	Mother	active
252	498	0	active
253	499	Mother	active
253	500	0	active
254	501	Mother	active
254	502	0	active
255	503	Mother	active
255	504	0	active
256	505	Mother	active
256	506	0	active
257	507	Mother	active
257	508	0	active
258	509	Mother	active
258	510	0	active
259	511	Mother	active
259	512	0	active
260	513	Mother	active
260	514	0	active
261	515	father	active
261	516	0	active
262	517	Mother	active
262	518	0	active
263	519	Mother	active
263	520	0	active
264	521	Mother	active
264	522	0	active
265	523	Mother	active
265	524	0	active
266	525	Mother	active
266	526	0	active
267	527	Mother	active
267	528	0	active
268	529	Mother	active
268	530	Father	active
269	531	Mother	active
269	532	Father	active
270	533	Mother	active
270	534	Father	active
271	535	Mother	active
271	536	Father	active
272	537	Auntie	active
272	538	O	active
273	539	Mother	active
273	540	Father	active
\.


--
-- Data for Name: student_remarks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_remarks (remark_id, student_id, class_id, semester_id, user_id, class_teachers_remark, headteachers_remark, remark_date) FROM stdin;
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, photo, first_name, last_name, other_names, date_of_birth, gender, class_id, amountowed, residential_address, phone, email, enrollment_date, national_id, birth_cert_id, role, user_id, status, class_promoted_to) FROM stdin;
7	\N	Christiana 	Acquah	Nhyira 	2017-06-22	Female	31	0.00	GREATER GRACE CAMPUS	0244997473		2019-01-01	0	1234567	student	51	active	31
8	\N	Agbodogli	Agbenyagah		2009-12-14	Male	47	0.00	Greater Grace ,Apam 	0545383737		2013-05-23	0	0	student	83	active	47
9	\N	Andres	Addison	Iniesta	2012-07-25	Male	44	0.00	Kofikrom, Mankwadze	0540253137		2023-01-10	0	0	student	86	active	44
10	\N	Gideon	Owusu	stephen 	2011-04-27	Male	47	0.00	Lighthouse , Apam	0244031704		2015-01-21	0	0	student	89	active	47
11	\N	Godfred	Abban	Kojo	2009-09-20	Male	44	0.00	Bomboa, Apam	0241584883		2021-09-27	0	0	student	92	active	44
12	\N	John 	Apostle	Sam	2009-07-25	Male	47	0.00	Roundabout , Apam	0559292975		2016-09-09	0	0	student	95	active	47
13	\N	Desmond 	Afful	Don	2012-03-19	Male	44	0.00	Come Down, Apam	0244792863		2021-01-15	0	0	student	98	active	44
14	\N	Blessing	Odoom		2009-11-26	Female	47	0.00	Mumford	0591707129		2021-01-18	0	0	student	101	active	47
15	\N	Godwin	Appoh		2012-03-24	Male	44	0.00	Bomboa, Apam 	059554632		2014-01-20	0	0	student	104	active	44
16	\N	Ewusi	yankson	nana	2010-08-23	Male	47	0.00	Mumford	0243073131		0021-01-25	0	0	student	107	active	47
17	\N	Kingsford	Arthur 		2012-10-03	Male	44	0.00	Nsuekyir, Apam	0243102752		2016-01-18	0	0	student	110	active	44
18	\N	Elisha 	Quansah		2010-06-12	Male	47	0.00	White House	0244795971		2022-01-10	0	0	student	113	active	47
19	\N	Jeremiah 	Ayin	Nii Lartey	2012-03-04	Male	44	0.00	Old Bank, Apam 	0554618503		2016-09-19	0	0	student	116	active	44
20	\N	Kelvin	Abuakwa		2012-03-27	Male	43	0.00	Ankamu, Waterworks	0543510164		2016-09-02	0	0	student	119	active	43
21	\N	Kenneth 	Bondzie		2012-12-02	Male	44	0.00	Nsuekyir, Apam 	0555484662		2018-09-05	0	0	student	122	active	44
22	\N	John	Arhin	Paapa     Kum	2010-06-17	Male	47	0.00	Methodist school ,Apam	0541473850		0016-06-29	0	0	student	125	active	47
23	\N	Carl	Acquah	Ato Kwamena	2012-11-10	Male	43	0.00	Apam, King's table	0539693181		2021-01-15	0	0	student	128	active	43
24	\N	Prince	Ehun		2012-09-22	Male	44	0.00	Blankson Park, Apam	0247999113		2016-09-06	0	0	student	131	active	44
25	\N	Fredrick	Gyesi	John	2009-12-31	Male	47	0.00	Salvation	0533002891		2018-05-17	0	0	student	134	active	47
26	\N	Gad	Gyesi		2012-09-11	Male	44	0.00	Akyerema, Apam	0242956655		2014-06-09	0	0	student	137	active	44
27	\N	Godfred	Appoh		2012-03-12	Male	43	0.00	Bomboa	0595544632		2014-01-19	0	0	student	140	active	43
28	\N	Kingsley 	Johnson 	Fiifi Donkor	2012-11-09	Male	44	0.00	Genesis Junction, Apam 	0546303101		2018-08-21	0	0	student	143	active	44
29	\N	Merlin	Sey		2010-04-17	Male	47	0.00	Roman School 	0535993115		2014-09-08	0	0	student	146	active	47
30	\N	Shadrack	Abbiw		2010-05-24	Male	46	0.00	Mumford 	0597610215		2021-04-02	0	0	student	149	active	46
31	\N	Christian 	Okwan		2012-03-14	Male	44	0.00	Apam Junction 	0245682218		2017-09-13	0	0	student	152	active	44
32	\N	Joel	Arkorful		2013-05-16	Male	43	0.00	Apam,  Zongo	0241511673		2023-10-16	0	0	student	155	active	43
33	\N	Latif	Abdullah		2010-07-03	Male	46	0.00	Apam Jun 	0544105949		2021-06-06	0	0	student	158	active	46
34	\N	Kingsley 	Quansah 		2011-12-31	Male	44	0.00	Bomboa, Apam 	0541185861		2016-09-15	0	0	student	161	active	44
35	\N	Melvin 	Mankoe		2009-04-15	Male	47	0.00	Mumford	0246979341		2011-05-18	0	0	student	164	active	47
36	\N	Rahaman	Ahengua		2012-12-12	Male	45	0.00	Apam Junction 	0546674485		2024-05-13	0	0	student	167	active	45
37	\N	Patrick 	Sessah		2012-05-27	Male	44	0.00	Nsawam, Apam 	0553751684		2022-01-11	0	0	student	170	active	44
38	\N	Caleb	Arthur	Obeng	2012-10-17	Male	43	0.00	Abaakwa	0249481159		2014-01-28	0	0	student	173	active	43
39	\N	Jonathan	Arkoful 	Mensah	2010-04-04	Male	47	0.00	Genesis school ,Apam	0548245540		2014-01-13	0	0	student	176	active	47
40	\N	Marisabel	Abbiw		2012-04-04	Female	44	0.00	Mumford 	0243823002		2020-01-13	0	0	student	179	active	44
41	\N	Wisdom	Akey	Angel	2010-02-07	Male	46	0.00	Mumfarm	0548533446		2021-08-01	0	0	student	182	active	46
42	\N	Ayeyi	Amoh	Koomson	2010-11-01	Male	45	0.00	Apam Nsawam	0249117021		2012-10-02	0	0	student	185	active	45
43	\N	Lesley	Mensah		2009-06-05	Male	47	0.00	Hello hello	0244624823		2018-02-11	0	0	student	188	active	47
44	\N	Rosalinda	Appiah	Nhyira	2012-05-20	Female	44	0.00	Nsuekyir, Apam 	0244242642		2019-09-03	0	0	student	191	active	44
45	\N	Kelvin	Asumaning		2010-06-10	Male	43	0.00	Apam, Lake Lane	0257705845		2023-01-23	0	0	student	194	active	43
46	\N	Fredrick	Annan		2009-12-19	Male	45	0.00	Apam lake lane	0540204377		2013-02-04	0	0	student	197	active	45
47	\N	Reuben  	Mensah		2010-02-02	Male	47	0.00	Ultimate school 	0208732299		2019-08-05	0	0	student	200	active	47
48	\N	Dorothy 	Bampeo	Ohenewa Nkoly	2012-03-11	Female	44	0.00	Mumford 	0540756347		2018-09-06	0	0	student	203	active	44
49	\N	Christopher	Eturuw		2012-02-27	Male	43	0.00	Mumford	0248718372		2021-01-18	0	0	student	206	active	43
50	\N	Desmond 	Dotse	Sena	2012-04-17	Male	44	0.00	Apam Junction 	0246435776		2024-09-06	0	0	student	209	active	44
51	\N	Samuel 	Opare		2011-09-09	Male	47	0.00	Botsio	0550899847		2019-01-30	0	0	student	212	active	47
52	\N	Blessing 	Bondzie 	Badu	2011-11-30	Female	44	0.00	Nsawam, Apam 	0245040468		2022-06-16	0	0	student	215	active	44
53	\N	Donnavan	Amakye	Nhyira	2010-04-18	Male	46	0.00	Apam nsawam	0243634499		2025-01-16	0	0	student	218	active	46
54	\N	Lucky 	Oppong - Willington		2010-06-23	Male	47	0.00	Behind Greater Grace 	0536286799		2014-11-20	0	0	student	221	active	47
55	\N	Shahadat	Okai		2012-05-06	Male	43	0.00	Apam, Kaneshie	0543507348		2014-01-13	0	0	student	224	active	43
56	\N	Blessing 	Komedzie		2010-07-12	Female	44	0.00	Nsuekyir, Apam 	0540616305		2023-10-03	0	0	student	227	active	44
57	\N	Otoo	Sylvia		2009-12-13	Female	47	0.00	Blankson Park 	0244020290		2015-02-09	0	0	student	230	active	47
58	\N	Kwame	Amissah		2011-05-21	Male	45	0.00	Apam junction 	0244053514		2017-05-14	0	0	student	233	active	45
59	\N	Elvis	Nyani		2011-07-04	Male	43	0.00	Apam roundabout 	0542159078		2017-09-19	0	0	student	236	active	43
60	\N	Justina 	Abekah		2009-12-24	Female	47	0.00	Opposite Nyamekye	0241674291		2012-08-30	0	0	student	239	active	47
61	\N	Micheal	Arkorful		2010-08-22	Male	45	0.00	Apam zongo	0241511673		2017-01-16	0	0	student	242	active	45
62	\N	Mercy	Etey		2011-06-27	Female	44	0.00	Nsuekyir, Apam 	0248565113		2019-01-08	0	0	student	245	active	44
63	\N	Jude	Andoj	Oboh	2010-10-06	Male	46	0.00	Botsio	0244348833		2012-11-10	0	0	student	248	active	46
64	\N	Esther 	Asare	Duffie	2011-02-21	Female	47	0.00	Presbyterian  school 	0246512181		2018-02-11	0	0	student	251	active	47
65	\N	Francis	Baffoe Amoaning	Kojo twum	2011-04-11	Male	45	0.00	Apass	0553483288		2013-05-17	0	0	student	254	active	45
66	\N	Emmanulla	Opare		2013-08-22	Female	44	0.00	Botsio, Apam 	0550899847		2019-08-30	0	0	student	257	active	44
67	\N	Ezekiel	Annor	Adjie	2010-10-16	Male	46	0.00	Apam junction 	0246106414		2015-06-09	0	0	student	260	active	46
68	\N	Ellis	Dick	Mozu	2010-10-26	Male	45	0.00	Apam mamfam	0554723280		2018-08-05	0	0	student	263	active	45
69	\N	Elysha	Owusu Mends		2013-07-26	Female	44	0.00	Hackman junction, Apam 	0243867662		2015-02-03	0	0	student	266	active	44
70	\N	Regina	Amenuvor		2012-07-17	Female	46	0.00	Botsio	0240281579		2019-08-30	0	0	student	269	active	46
71	\N	Solomon	Owoo		2008-10-20	Male	45	0.00	Apam bomboa	0532703866		2019-09-10	0	0	student	272	active	45
72	\N	Micheal	Yamoah	Adom	2010-10-02	Male	45	0.00	Apam lake lane	0555155675		2017-05-15	0	0	student	275	active	45
73	\N	Godfred	Arhin		2009-12-25	Male	46	0.00	Apam nsawam	0555306885		2023-04-19	0	0	student	278	active	46
74	\N	Joseph 	Eyiah-Mensah		2012-06-08	Male	44	0.00	Come Down, Apam 	0247056218		2014-09-05	0	0	student	281	active	44
75	\N	Eric	Arhin	Sackey	2011-11-26	Male	46	0.00	Apam hospital 	0541473850		2017-08-08	0	0	student	284	active	46
76	\N	Euodia	Forson	Abena	2010-04-27	Female	48	0.00	Lighthouse school	0557791097		2012-05-08	0	0	student	287	active	48
77	\N	Gloria	Nyame		2009-06-02	Female	48	0.00	Mumford	0554738302		2023-01-17	0	0	student	290	active	48
78	\N	Kayleb	Otwey	Clyde	2013-01-16	Male	43	0.00	Mumford	0241868544		2016-02-03	0	0	student	293	active	43
79	\N	Doris	Abaah		2010-05-05	Female	46	0.00	Apam round about 	0540140321		2015-01-14	0	0	student	296	active	46
80	\N	Sylvia	Sam		2013-03-08	Female	44	0.00	Nsawam, Apam 	055339768		2016-01-12	0	0	student	299	active	44
81	\N	Clement	Arthur		2010-05-22	Male	46	0.00	Mumford	0597803649		2021-01-15	0	0	student	302	active	46
82	\N	Emmanuel	Tawiah	Paa	2012-09-28	Male	43	0.00	Botsio	0554799399		2019-09-17	0	0	student	305	active	43
83	\N	Mena Aba	Odoom	Dede	2008-06-26	Female	48	0.00	Mumford	0536895358		2019-06-03	0	0	student	308	active	48
84	\N	Eva	Quaye		2008-03-28	Female	44	0.00	Nsuekyir, Apam 	0543975886		2025-01-08	0	0	student	311	active	44
85	\N	Reymolf	Ayensu	Obiri	2010-05-11	Male	46	0.00	Mumford 	0547158767		2017-08-09	0	0	student	314	active	46
86	\N	Dennis	Yankson	Paa kojo	2012-07-16	Male	43	0.00	Apam Apostolic 2	0205316592		2014-09-05	0	0	student	317	active	43
87	\N	James	Botwey	Esaako	2011-10-25	Male	46	0.00	Apam round about 	0243080589		2017-11-09	0	0	student	320	active	46
88	\N	Peter	Mensah 		2011-10-21	Male	44	0.00	Mamfam, Apam 	0551007123		2015-09-07	0	0	student	323	active	44
89	\N	Nana	Gyesi	Obeng	2011-06-24	Male	46	0.00	Mumford 	0240106396		2013-09-09	0	0	student	326	active	46
90	\N	Michelle 	Pelmiitey	Akosua	2013-04-07	Female	44	0.00	Methodist School, Apam	0541176281		2023-11-10	0	0	student	329	active	44
91	\N	Bright 	Quansah		2010-07-21	Male	46	0.00	Apam bomboa	0543749894		2013-05-28	0	0	student	332	active	46
92	\N	Stephen	Abekah	Yeboah	2014-09-03	Male	43	0.00	Apam ,Ultimate	0555552515		2025-01-16	0	0	student	335	active	43
93	\N	Blessing	Nyarkoh		2012-05-12	Female	43	0.00	Mamfam	05559485843		2018-09-17	0	0	student	338	active	43
94	\N	Nicholas 	Afful	Fiifi	2019-03-29	Male	23	0.00	Apam	0559605015		2025-01-17	0	0	student	341	active	23
95	\N	Jason	Appiah	Baafi	2015-10-02	Male	36	0.00	Apam-Hospital	0249998323		2019-09-06	0	0	student	344	active	36
96	\N	Christian	Afful		2014-11-01	Male	36	0.00	Mumford	0242239721		2024-09-19	0	0	student	347	active	36
97	\N	Raphael	Asare	Lartey Quaye Argee	2015-05-12	Male	36	0.00	Mumford-fordcity	0557044645		2023-10-18	0	0	student	350	active	36
98	\N	Prince	Nyavor		2008-10-02	Male	48	0.00	Akamu	0592895255		2024-03-06	0	0	student	353	active	48
99	\N	Prince	Awotwe	Kobina	2015-02-03	Male	36	0.00	Apam-Methodist school	0559397781		2022-05-13	0	0	student	356	active	36
100	\N	Lucy	Boateng	Pokuaa	2010-07-11	Female	48	0.00	Kyerikwanta	0241478942		2024-03-09	0	0	student	359	active	48
101	\N	Enock	Akyere		2008-03-05	Male	48	0.00	Mumford	0247929669		2017-09-11	0	0	student	362	active	48
102	\N	Prosper	Amissah		2010-11-02	Male	48	0.00	Apam	0547928895		2018-11-02	0	0	student	365	active	48
103	\N	Shalom	Bondzie	Ewusi	2014-10-25	Male	36	0.00	Mumford-Odukum	0554743199		2019-01-15	0	0	student	368	active	36
104	\N	Bright	Coly		2013-03-07	Male	36	0.00	Apam Senior High school	0551413228		2024-09-02	0	0	student	371	active	36
105	\N	Desmond	Arhin		2011-04-14	Male	48	0.00	Apam	0249284680		2015-09-04	0	0	student	374	active	48
106	\N	Phyllis	Aidoo		2009-04-28	Female	48	0.00	Quaquah House-Apam	0543989978		2022-02-22	0	0	student	377	active	48
107	\N	Abigail	Amenuvor	Peace Yayra	2010-03-18	Female	48	0.00	Apam-Botsio	0247062218		2019-08-30	0	0	student	380	active	48
108	\N	Nana Owusu	Dampson	Afriyie	2015-06-24	Male	36	0.00	Apam-Nsuekyire	0244524079		0001-01-01	0	0	student	383	active	36
109	\N	Belinda	Boison		2009-10-11	Female	48	0.00	Akamu	0537417528		2015-01-13	0	0	student	386	active	48
110	\N	Praise	Egyir	Fiifi	2015-11-06	Male	36	0.00	Apam junction	0547159410		2021-05-06	0	0	student	389	active	36
111	\N	Cherubim	Essandoh	Miracle	2015-10-19	Male	36	0.00	Bomboa	0599135161		2017-05-12	0	0	student	392	active	36
112	\N	Isaac	Obeng		2016-01-27	Male	36	0.00	Apam junction	0543397281		2022-11-18	0	0	student	395	active	36
113	\N	Eric	Arthur	Kofi	2009-07-15	Male	48	0.00	Mumford	0534929285		2022-05-17	0	0	student	398	active	48
114	\N	John	Quaye		2014-01-19	Male	36	0.00	Apam-Nsuekyire	0241585488		2010-08-25	0	0	student	401	active	36
115	\N	Clifford	Tetteh		2015-03-12	Male	36	0.00	Apam-Abaakwa	0536456852		2022-01-11	0	0	student	404	active	36
116	\N	Lordina	Agbi	Esinam	2011-04-09	Female	48	0.00	Apam -Mamfam	0249649486		2023-01-17	0	0	student	407	active	48
117	\N	Shadrack	Essuman	Andam	2014-05-02	Male	36	0.00	Apam-Botsio junction	0249799739		2024-09-10	0	0	student	410	active	36
118	\N	Joana	Acquaye		2014-09-24	Female	36	0.00	Mumford	0538536602		2021-01-18	0	0	student	413	active	36
119	\N	Natalie	Brago	Abena	2009-02-24	Female	48	0.00	Apam	0552318133		2023-10-24	0	0	student	416	active	48
120	\N	David	Essandoh	Dominic Junior	2010-04-04	Male	48	0.00	Apam-Nsukyir	0245338910		2015-09-08	0	0	student	419	active	48
121	\N	Blessing 	Adentwi	Amoh	2014-11-29	Female	36	0.00	Apam-Nsawam	0241744740		2022-05-10	0	0	student	422	active	36
122	\N	Dorothy	Mensah		2009-10-13	Female	48	0.00	Apam-Nsawam	0544848488		2012-08-31	0	0	student	425	active	48
123	\N	Akua	Ampomah		2015-08-05	Female	36	0.00	Apam junction-Agya Appiah	0540494678		2018-09-11	0	0	student	428	active	36
124	\N	Faustina	Andoh		2014-03-17	Female	36	0.00	Mumford-Methodist park	0246785201		2018-01-14	0	0	student	431	active	36
125	\N	Precious	Egyin		2010-09-18	Female	48	0.00	Apam-Zongo	0549574786		2016-09-05	0	0	student	434	active	48
126	\N	Owena	Eyiah-Mensah		2010-04-23	Female	48	0.00	Apam-Calm Down	0247056218		2014-09-06	0	0	student	437	active	48
127	\N	Comfort	Arkorful		2011-03-04	Female	36	0.00	Bomboa 	0597803958		2023-10-06	0	0	student	440	active	36
128	\N	Michelle	Baidoo		2015-03-12	Female	36	0.00	Mumford	0242913897		2019-09-13	0	0	student	443	active	36
129	\N	Josephine 	Baidoo		2015-10-09	Female	36	0.00	Apam Tema Yaa	0241046900		2022-01-24	0	0	student	446	active	36
130	\N	Lordina	Botchwey		2015-09-13	Female	36	0.00	Apam-Nsuekyire	0558765274		2018-01-15	0	0	student	449	active	36
131	\N	Twenewuradze	Buabeng		2015-07-02	Female	36	0.00	Apam-Mamfam	0247531426		2017-09-07	0	0	student	452	active	36
132	\N	Benita	Ekwam		2015-11-27	Female	36	0.00	Apam-Round About	0547786463		2023-10-09	0	0	student	455	active	36
133	\N	Aba	Kaitu	Gyawa	2014-12-31	Female	36	0.00	Apam junction	0553090265		2018-09-14	0	0	student	458	active	36
134	\N	Davida	Abraham		2012-12-27	Female	45	0.00	Apam council	0244578802		2023-07-04	0	0	student	461	active	45
135	\N	Francess	Aidoo	Ohenewaa	2011-06-07	Female	45	0.00	Apam Nsuekyir	0244592893		2019-01-10	0	0	student	464	active	45
136	\N	Vanessa	Quaye	Nyira	2014-06-25	Female	36	0.00	Bifirst	0249613523		2023-01-12	0	0	student	467	active	36
137	\N	Isabella 	Amakye	Enyidah	2009-09-17	Female	45	0.00	Mumford mangoase	0545369476		2019-01-10	0	0	student	470	active	45
138	\N	Gity	Ofori-Atta		2015-03-20	Female	36	0.00	Apam junction	0555838781		2019-08-20	0	0	student	473	active	36
139	\N	Francisca	Amankwah	Edem	2011-05-24	Female	45	0.00	Apam junction 	0557437358		2019-09-18	0	0	student	476	active	45
140	\N	Stella	Owusu	adwoa Quayeba	2014-01-06	Female	36	0.00	Mumford,Mangoase	0545369476		2019-09-09	0	0	student	479	active	36
141	\N	Augustina	Appretse		2010-12-12	Female	45	0.00	Apam calm down	0545369061		2018-09-10	0	0	student	482	active	45
142	\N	Hannah	Otoo		2014-03-25	Female	36	0.00	Apam junction	0241929725		2024-12-02	0	0	student	485	active	36
143	\N	Nancy	Arkorful		2011-07-27	Female	45	0.00	Apam Nsuekyir 	0599870182		2015-09-15	0	0	student	488	active	45
144	\N	Yvette	Martey	Okoe	2015-05-10	Female	36	0.00	Apam round about	0546160652		2017-09-08	0	0	student	491	active	36
145	\N	Alexandra	Blankson	Wurodwah	2012-02-19	Female	45	0.00	Apam park avenue	0532114240		2022-01-11	0	0	student	494	active	45
146	\N	Naomi	Botchwey		2012-07-24	Female	45	0.00	Mumford park 	0541632071		2018-05-08	0	0	student	498	active	45
147	\N	Jehoaida	Ababio	Essilfie	2016-09-11	Male	32	0.00	Hospital 	0242166216		2016-03-03	0	0	student	501	active	32
148	\N	Nannies	Dadzie	Abena amanfuah	2010-11-16	Female	45	0.00	Apam junction 	0599304482		2019-04-08	0	0	student	504	active	45
149	\N	Damien	Arkoh	Ebo	2012-04-03	Male	44	0.00	Lake Lane, Apam	0549282954		2018-10-09	0	0	student	507	active	44
150	\N	Maame	Walden	Abba	2011-06-05	Female	46	0.00	Apam near apass	0247567719		2016-04-11	0	0	student	510	active	46
151	\N	Latif	Abdul	Amoasi Sharzman	2016-04-24	Male	32	0.00	Bomboa	0542288449		2021-09-06	0	0	student	513	active	32
152	\N	Tina 	Essuman	Nana Esabaa	2011-04-07	Female	45	0.00	Apam Botsio	0599996735		2013-12-09	0	0	student	516	active	45
153	\N	Jennifer	Attisey		2015-09-15	Female	36	0.00	Apam Botsio junction	0245787635		2024-09-27	0	0	student	519	active	36
154	\N	Philippa	Amissah 		2008-02-13	Female	44	0.00	RoundAbout, Apam 	0559293457		2024-06-06	0	0	student	522	active	44
155	\N	Maame	Pratt	Esi	2010-11-21	Female	46	0.00	Apam	0240709696		2023-10-11	0	0	student	525	active	46
156	\N	Goodness	Mensah	Adom	2011-10-28	Female	45	0.00	Apam ultimate junction 	0548495108		2014-10-14	0	0	student	528	active	45
157	\N	Grace	Arthur		2011-04-11	Female	46	0.00	Mumford 	0247566654		2017-09-12	0	0	student	531	active	46
158	\N	Nana	Otoo	Adjoa	2011-10-03	Female	45	0.00	Apam hospital 	0242929220		2013-10-03	0	0	student	534	active	45
159	\N	Jayce	Ansah	Nana Kwabena 	2016-11-15	Male	32	0.00	Nsuekyir	0540564903		2023-09-06	0	0	student	537	active	32
160	\N	Anthoinette	Aryee	Naa ody	2010-06-03	Female	46	0.00	Apam round about 	0555309450		2016-02-02	0	0	student	540	active	46
161	\N	Theophilus 	Odoom		2012-10-03	Male	44	0.00	Mumford 	0249729500		2024-09-10	0	0	student	543	active	44
162	\N	Christabel	Sewornu 	Yayra	2011-10-15	Female	45	0.00	Apam hospital 	0591293229		2022-10-01	0	0	student	546	active	45
163	\N	Kingsley 	Arthur 	Ato Kwamena	2016-08-20	Male	32	0.00	Nsuekyir	0243102752		2018-05-21	0	0	student	549	active	32
164	\N	Vasty	Kukua		2011-04-27	Female	46	0.00	Apam nsuekyir	0554488133		2024-09-02	0	0	student	552	active	46
165	\N	Jeffery 	Obeng		2013-06-03	Male	44	0.00	Lighthouse School, Apam	0242658952		2023-10-09	0	0	student	555	active	44
166	\N	Quinester	Simpson	Nana Araba	2010-07-13	Female	45	0.00	Apam Nsawam	056712940		2018-05-09	0	0	student	558	active	45
167	\N	Clementina 	Coffie	Adwoa	2012-07-26	Female	44	0.00	Mumford 	0241843002		2023-04-17	0	0	student	561	active	44
168	\N	Oscar	Atsu 		2016-04-14	Male	32	0.00	Mumford 	0543507751		2019-11-01	0	0	student	564	active	32
169	\N	Damien	Donson	Siripi	2015-09-11	Male	32	0.00	Abaakwa	0547910614		2018-09-11	0	0	student	567	active	32
170	\N	Vincent	Edzie		2016-08-11	Male	32	0.00	Mumford 	0595227568		2021-02-12	0	0	student	570	active	32
171	\N	Kingsford 	Tawiah	Tawiah	2014-04-14	Male	32	0.00	Nsawam	0545059957		2019-09-03	0	0	student	573	active	32
172	\N	Joel	Essandoh	Papa Kow Budu 	2016-07-11	Male	32	0.00	Nsawam	0549281967		2019-08-09	0	0	student	576	active	32
173	\N	Lucas	Essandoh	Podolski	2016-05-14	Male	32	0.00	Nsuekyir	0544478404		2019-09-09	0	0	student	579	active	32
174	\N	Nana	Nsarkoh	Kow Aggrey	2016-07-07	Male	32	0.00	Apam Junction 	0556699618		2018-09-10	0	0	student	582	active	32
175	\N	Vincent 	Owusu		2016-11-23	Male	32	0.00	Nsuekyir	0244758655		2021-01-01	0	0	student	585	active	32
176	\N	Ezekiel 	Quansah		2017-02-02	Male	32	0.00	Apam	0244795971		2022-01-10	0	0	student	588	active	32
177	\N	Nancy	Acquah	Jesusline	2016-03-06	Female	32	0.00	Apam junction 	0542893936		2023-05-15	0	0	student	591	active	32
178	\N	Hannah	Andoh	Oboh	2016-03-19	Female	32	0.00	Botsio	0246391983		2018-01-05	0	0	student	594	active	32
179	\N	Celestina 	Obaapa	Appiah	2016-05-23	Female	32	0.00	Lake lane	0242658952		2023-10-09	0	0	student	597	active	32
180	\N	Jackline	Arhin		2016-05-11	Female	32	0.00	Bomboa	0551540838		2018-09-11	0	0	student	600	active	32
181	\N	Mabel	Baidoo	Ama A	2016-04-04	Female	32	0.00	Mankoadze	0553752592		2021-03-03	0	0	student	603	active	32
182	\N	Michelle	Boamah	Owusuaah	2017-01-24	Female	32	0.00	Mumford	0555242214		2019-08-02	0	0	student	606	active	32
183	\N	Keziah	Sackey	Dadzie	2016-07-31	Female	32	0.00	Botsio	0546303123		2018-09-19	0	0	student	609	active	32
184	\N	Florence 	Ewusi 	Ama	2015-02-25	Female	32	0.00	Mumford 	0545292995		2023-01-16	0	0	student	612	active	32
185	\N	Dominica	Ofosu	Ekua	2016-08-21	Female	32	0.00	Nsawam	0547534482		2020-01-08	0	0	student	615	active	32
186	\N	Blessing 	Koffie	Rebecca 	2019-03-28	Female	32	0.00	Charity	0245089261		2021-09-07	0	0	student	618	active	32
187	\N	Emmanuella	Quarshie	Blessing 	2016-01-30	Female	32	0.00	Abaakwa	0599276197		2018-09-04	0	0	student	621	active	32
188	\N	Christabel 	Quaye	Amo	2015-11-29	Female	32	0.00	Nsuekyir	0548484444		2022-01-08	0	0	student	624	active	32
189	\N	Victoria	Tetteh		2016-06-25	Female	32	0.00	Bomboa	0541208605		2018-01-10	0	0	student	627	active	32
190	\N	Gloria	Abbiw		2014-02-26	Female	32	0.00	Mumford 	0242943224		2021-02-04	0	0	student	630	active	32
191	\N	Linda	Botchwey 		2013-09-25	Female	38	0.00	Tema yaa	0557608774		2019-06-19	0	0	student	633	active	38
192	\N	Emmanuel 	Aidoo		2013-12-16	Male	38	0.00	Methodist 	0550338333		2017-01-11	0	0	student	636	active	38
193	\N	Joel 	Abekah 		2014-08-20	Male	38	0.00	Nsuekyire	0246770863		2017-01-11	0	0	student	639	active	38
194	\N	Christabel 	Ankrah 		2014-06-16	Female	38	0.00	Blankson park	0248661457		2023-04-17	0	0	student	642	active	38
195	\N	Nhyira 	Gyesi		2014-11-14	Female	38	0.00	Blankson park 	0249804075		2017-01-16	0	0	student	645	active	38
197	\N	Michelle 	Dampson		2012-07-10	Female	38	0.00	Agankabow 	0541210905		2019-01-16	0	0	student	651	active	38
198	\N	Kennedy	Acquaye		2017-02-25	Male	29	0.00	Mumford	0538536602		2021-01-18	0	0	student	654	active	29
199	\N	Favour	Affoh	Collins	2017-03-22	Male	29	0.00	Asafo Danho	0241583232		2021-02-01	0	0	student	657	active	29
200	\N	Moses	Eyiah		2014-05-05	Male	38	0.00	Kings table 	0535849622		2017-01-10	0	0	student	660	active	38
201	\N	Pertrina 	Gyesi		2014-05-16	Female	38	0.00	Mumford 	0249497951		2018-02-13	0	0	student	663	active	38
202	\N	Jonathan	Amankwah	M	2017-09-12	Male	29	0.00	Ankamu	0557437358		2019-10-08	0	0	student	666	active	29
203	\N	Eunice 	Arhin		2014-04-19	Female	38	0.00	Amumudo	0248514939		2018-02-13	0	0	student	668	active	38
204	\N	Abraham	Andoh	Oboh	2019-04-03	Male	29	0.00	Nsawam	0246391983		2021-05-14	0	0	student	671	active	29
205	\N	Marvin 	Arkoh	Kojo	2014-07-28	Male	38	0.00	Lake lane	0549282954		2017-09-18	0	0	student	673	active	38
206	\N	Precious 	Ayin 	Naadu	2014-08-08	Female	38	0.00	Egyapaao	0554618503		2019-03-09	0	0	student	676	active	38
207	\N	Charles	Anderson	Kobina	2018-11-15	Male	29	0.00	Filling station	0598734560		2023-10-06	0	0	student	679	active	29
208	\N	Emerald 	Owusu	Fosuwaa 	2014-08-24	Female	38	0.00	Methodist 	0553035306		2024-03-09	0	0	student	682	active	38
209	\N	Daniel	Annan		2017-03-29	Male	29	0.00	Botsio	0240504484		2019-05-21	0	0	student	685	active	29
210	\N	Festus 	Otoo		2014-05-19	Male	38	0.00	Methodist 	0240958023		2018-10-09	0	0	student	688	active	38
211	\N	Desmond 	Nyarkoh 		2013-08-02	Male	38	0.00	Mumford 	0244843533		2023-11-14	0	0	student	691	active	38
212	\N	Favour	Annan	Kwabena	2017-04-25	Male	29	0.00	Nsuekyir	0245701508		2021-05-11	0	0	student	694	active	29
213	\N	Glibert 	Essel		2012-04-18	Male	38	0.00	Mankoadzie	0554676704		2023-01-20	0	0	student	697	active	38
214	\N	Miracle	Appiah	Fiifi	2017-03-17	Male	29	0.00	Mumford	0546303027		2021-03-03	0	0	student	700	active	29
215	\N	Prince	Lamptey 		2013-04-13	Male	38	0.00	Blankson park 	0530413816		2023-01-10	0	0	student	703	active	38
216	\N	Festus 	Okyere 		2014-02-18	Male	38	0.00	Round about 	0242365522		2017-01-20	0	0	student	706	active	38
217	\N	Greg	Appiah	Kwame	2017-01-28	Male	29	0.00	Apam	0553473511		2019-10-02	0	0	student	709	active	29
218	\N	Joshua 	Arthur 		2014-06-14	Male	38	0.00	Nsawam 	0546425432		2019-11-11	0	0	student	712	active	38
219	\N	Philip	Atomaku		2017-02-19	Male	29	0.00	Mumford	0241917353		2019-10-18	0	0	student	715	active	29
220	\N	Prince 	Dotse 	Eyram	2014-05-05	Male	38	0.00	Apam Junction 	0246435776		2024-09-09	0	0	student	718	active	38
221	\N	Samuel 	Dadzie	K N	2017-01-31	Male	29	0.00	Nsawam	0544362097		2021-01-18	0	0	student	721	active	29
222	\N	Nathaniel 	Odoom 		2013-04-13	Male	38	0.00	Mumford 	0241178691		2019-09-12	0	0	student	724	active	38
223	\N	Peter	Darkoh		2017-07-15	Male	29	0.00	Apam	0258721154		2023-04-11	0	0	student	727	active	29
224	\N	Bright 	Essel 	Amo	2013-03-08	Male	38	0.00	Hospital 	0556734079		2023-09-12	0	0	student	730	active	38
225	\N	Eric	Blankson 		2014-04-16	Male	38	0.00	Round about 	0556734079		2017-11-01	0	0	student	733	active	38
226	\N	Gorden	Hinson	K O	2017-02-10	Male	29	0.00	Apam	0592428479		2023-04-17	0	0	student	736	active	29
227	\N	Eugenia 	Martey	B.Addo	2015-01-11	Female	38	0.00	Eyankabow	0249901861		2018-05-21	0	0	student	739	active	38
228	\N	Justice 	Ibrahim 	K.E.M	2014-09-26	Male	38	0.00	Apam Junction 	0555041756		2019-05-09	0	0	student	742	active	38
229	\N	Emmanuel	Koomson		2017-09-23	Male	29	0.00	Apam	0242218484		2020-01-20	0	0	student	745	active	29
230	\N	Benedicta 	Wallace	Amo	2013-08-16	Female	38	0.00	Nsuekyire 	0248877673		2018-01-22	0	0	student	748	active	38
231	\N	Richard 	Mensah	Appiah	2017-05-30	Male	29	0.00	Apam	0551455551		2022-01-12	0	0	student	751	active	29
232	\N	Edward	Mensah	Amo	2017-06-20	Male	29	0.00	Apam	0546425423		2019-05-20	0	0	student	754	active	29
233	\N	Chris	Mensah		2018-03-26	Male	29	0.00	Apam	0594141906		2023-10-17	0	0	student	757	active	29
234	\N	Robert	Mensah	Obeng	2017-04-16	Male	29	0.00	Apam	0543645532		2019-06-05	0	0	student	760	active	29
235	\N	Zebulun	Quansah		2017-04-22	Male	29	0.00	Apam	0241584883		2022-11-04	0	0	student	763	active	29
236	\N	Stephanie	Addo		2016-06-05	Female	29	0.00	Bomboa	0548304068		2023-01-25	0	0	student	766	active	29
237	\N	Yvonne	Arhin	Mensah	2018-04-24	Female	29	0.00	Apam	0543192679		2019-05-13	0	0	student	769	active	29
238	\N	Blessing	Baidoo		2017-03-19	Female	29	0.00	Nsuekyir	0540964425		2021-02-01	0	0	student	772	active	29
239	\N	Mabel	Bassaw		2017-07-17	Female	29	0.00	Nsuekyir	0593793311		2023-10-23	0	0	student	775	active	29
240	\N	Josephine	Incoom		2017-07-08	Female	29	0.00	Ankamu	0557228887		2019-06-06	0	0	student	778	active	29
241	\N	Blessing	Koffie		2018-06-18	Female	29	0.00	Ankamu	05539551091		2021-09-07	0	0	student	781	active	29
242	\N	Victoria	Lamptey		2017-06-23	Female	29	0.00	Lake lane	0530413816		2023-01-10	0	0	student	784	active	29
243	\N	Nana	Mensah	Esi Arkorfoa	2017-06-25	Female	29	0.00	Apam	0208732299		2023-04-17	0	0	student	787	active	29
244	\N	Yayara 	Nyavor		2016-01-25	Female	29	0.00	Ankamu	0592895255		2024-06-03	0	0	student	790	active	29
245	\N	Naana	Onumah	Pillaba	2018-07-06	Female	29	0.00	Ankamu	0257156105		2022-01-05	0	0	student	792	active	29
246	\N	Marcelina	Sekum	Nana Ekua	2016-02-24	Female	29	0.00	Apam	0546999497		2022-05-16	0	0	student	795	active	29
248	\N	Loveel	Otwey	Egyirba	2017-02-27	Female	29	0.00	Mumford	0244294562		2018-09-17	0	0	student	801	active	29
249	\N	Desmond	Arkorful	Nana Kofi	2017-05-05	Male	29	0.00	Apam	0544204838		2025-01-17	0	0	student	804	active	29
247	\N	Avery	Wilson	Oheneba	2018-02-11	Male	29	0.00	Lake lane	0241965228		2023-02-13	0	0	student	798	active	29
196	\N	Micah	Abaidoo	Abbiw	2017-03-16	Male	29	0.00	Ankamu	0241568827		2023-01-05	0	0	student	648	active	29
250	\N	Judah	Andorful	E	2016-08-28	Male	31	0.00	Abaakwaa	0249649486		2023-01-23	0	0	student	807	active	31
251	\N	Ernestina	Agyei	Yaboah	2010-03-18	Female	45	0.00	Gomoa kyeren nkwanta	0240256996		2024-01-09	0	0	student	810	active	45
252	\N	Eric	Bentum	Jerry	2016-08-26	Male	31	0.00	Abaakwaa	0592766287		2019-02-01	0	0	student	813	active	31
253	\N	Mabel	Nyame	Sekyiwaa	2009-12-14	Female	45	0.00	Apam junction	0548021670		2025-01-13	0	0	student	816	active	45
254	\N	Francis	Esson		2017-03-13	Male	31	0.00	Bomboa	0247083728		2020-01-22	0	0	student	819	active	31
255	\N	Richard 	Essandoh		2015-10-12	Male	31	0.00	Ankamu	0548469986		2019-09-10	0	0	student	822	active	31
256	\N	Farouk	Fuseini	R	2016-06-14	Male	31	0.00	Nsuekyir	0241172043		2023-01-16	0	0	student	825	active	31
257	\N	Philip	Impraim	Ayeyi	2016-03-03	Male	31	0.00	Nsuekyir	0249416309		2018-09-10	0	0	student	828	active	31
258	\N	Andrews	Konduah	N	2015-12-24	Male	31	0.00	Ankamu	0534585652		2023-10-02	0	0	student	831	active	31
259	\N	Zadock	Nkansah	O D	2016-09-30	Male	31	0.00	Lake lane	0552204934		2021-05-10	0	0	student	834	active	31
260	\N	Rashvi	Nyame	Junior	2017-02-07	Male	31	0.00	Ankamu	0536854482		2021-05-21	0	0	student	837	active	31
261	\N	Sheriff	Okai	Nayar	2016-11-26	Male	31	0.00	Roundabout	0543507348		2018-09-04	0	0	student	840	active	31
262	\N	Kingsford	Opare	Edwin	2017-02-05	Male	31	0.00	Botsio	0550899847		2019-08-30	0	0	student	843	active	31
263	\N	Evans	Owusu		2016-04-05	Male	31	0.00	Mumford	0531834943		2023-01-18	0	0	student	846	active	31
264	\N	Ekow	Quansah	Ayeyi	2017-08-24	Male	31	0.00	Behind Greater Grace	0539478272		2019-10-07	0	0	student	849	active	31
265	\N	Nhyiraba	Quansah	Kojo	2016-04-01	Male	31	0.00	Botsio	0535368891		2018-09-07	0	0	student	852	active	31
266	\N	Nhyiraba	Sessah	Kojo	2016-04-18	Male	31	0.00	Nsawam	0553751684		2022-01-11	0	0	student	855	active	31
267	\N	Maxwell	Sey	Adu	2016-04-28	Male	31	0.00	Mamfam	0242174938		2018-09-17	0	0	student	858	active	31
268	\N	Lawrencia	Akese	Nana	2015-05-30	Female	34	0.00	Mumford	0247255802		2018-09-14	0	0	student	861	active	34
269	\N	Priscilla 	Amenuvor	Aku Dela	2016-01-27	Female	34	0.00	Botsio-Apam 	0247062218		2019-08-30	0	0	student	864	active	34
270	\N	Alisha	Amissah	Bempong	2016-09-16	Female	34	0.00	Ankamu	0247840634		2024-09-09	0	0	student	867	active	34
271	\N	Alisha	Amissah	Bempong	2016-09-16	Female	34	0.00	Ankamu	0247840634		2024-09-09	0	0	student	870	active	34
272	\N	Pamela	Amissah	Joy Efua	2014-05-14	Female	34	0.00	Bomboa-Apam	0550029519		2024-09-02	0	0	student	873	active	34
273	\N	Comfort 	Anaafi	Adom	2016-01-25	Female	34	0.00	Apam-Hospital	0249650969		2021-01-25	0	0	student	876	active	34
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects (subject_id, subject_name, status) FROM stdin;
11	English Language	active
12	Mathematics	active
13	Integrated Science	active
14	History	active
15	Numeracy	active
16	Social Studies	active
17	Creative Arts	active
18	Career Technology	active
19	Computing	active
20	Fante	active
21	Our World Our People	active
22	Religious & Moral Education	active
23	Bible Knowledge	active
24	Music	active
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (supplier_id, supplier_name, contact_name, contact_phone, contact_email, address, details, status) FROM stdin;
\.


--
-- Data for Name: timetable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timetable (timetable_id, class_id, subject_id, teacher_id, room_id, day_of_week, period_number, start_time, end_time, semester_id) FROM stdin;
\.


--
-- Data for Name: user_health_record; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_health_record (user_id, medical_conditions, allergies, blood_group, vaccination_status, last_physical_exam_date, created_at, updated_at, health_insurance_id, status) FROM stdin;
51	NONE 	NONE 	B+	POLIO	\N	2025-01-11 12:12:25.451746	2025-01-11 12:12:25.451746	1234567	active
55	NONE	NONE		NONE	\N	2025-01-13 16:03:02.988544	2025-01-13 16:03:02.988544	\N	active
56	NONE	NONE		NONE	\N	2025-01-13 16:16:54.040653	2025-01-13 16:16:54.040653	\N	active
47	None 	None 	B+	Yellow fever \nPolio\nHep. B	\N	2025-01-11 11:08:15.793127	2025-01-11 11:08:15.793127	\N	active
57	NONE	NONE		NONE	\N	2025-01-13 16:22:15.40596	2025-01-13 16:22:15.40596	\N	active
54	NONE	NONE		NONE	\N	2025-01-13 15:37:06.315031	2025-01-13 15:37:06.315031	\N	active
58	none	none	O+	None	\N	2025-01-15 08:53:15.671995	2025-01-15 08:53:15.671995	\N	active
59	None	Banku	O+	None	\N	2025-01-15 08:58:52.027129	2025-01-15 08:58:52.027129	\N	active
60	None	Banku	B+	None	\N	2025-01-15 09:02:11.213263	2025-01-15 09:02:11.213263	\N	active
61	None	None	A-	None	\N	2025-01-15 12:44:38.20122	2025-01-15 12:44:38.20122	\N	active
62	None	None		None	\N	2025-01-15 12:48:36.82362	2025-01-15 12:48:36.82362	\N	active
63	None	None	A+	None	\N	2025-01-15 12:52:59.69166	2025-01-15 12:52:59.69166	\N	active
64	None	Honey, Yam, Crab	A-	None	\N	2025-01-15 13:03:54.791105	2025-01-15 13:03:54.791105	\N	active
65	None	None		None	\N	2025-01-15 13:13:26.647286	2025-01-15 13:13:26.647286	\N	active
66	None	None		None	\N	2025-01-15 13:25:55.719045	2025-01-15 13:25:55.719045	\N	active
67	None	None	O+	None	\N	2025-01-15 13:31:58.426733	2025-01-15 13:31:58.426733	\N	active
69	None	None	A+	None	\N	2025-01-15 13:59:13.379257	2025-01-15 13:59:13.379257	\N	active
70	None	None	AB+	None	\N	2025-01-15 14:08:22.741912	2025-01-15 14:08:22.741912	\N	active
68	None	None		None	\N	2025-01-15 13:49:42.053969	2025-01-15 13:49:42.053969	\N	active
71	None	None	O+	None	\N	2025-01-15 14:15:20.557321	2025-01-15 14:15:20.557321	\N	active
72	None	None	O+	None	\N	2025-01-16 07:39:58.061362	2025-01-16 07:39:58.061362	\N	active
73	None	None		None	\N	2025-01-16 07:49:34.38105	2025-01-16 07:49:34.38105	\N	active
74	None	None	O+	Null	\N	2025-01-16 08:28:57.302988	2025-01-16 08:28:57.302988	\N	active
75	Null	Null		Null	\N	2025-01-16 08:34:55.752231	2025-01-16 08:34:55.752231	\N	active
76	Null	Null		Null	\N	2025-01-16 08:37:27.954696	2025-01-16 08:37:27.954696	\N	active
77	Null	Null		Null	\N	2025-01-16 08:40:48.674841	2025-01-16 08:40:48.674841	\N	active
78	Null	Null	O+	Null	\N	2025-01-16 08:47:11.736915	2025-01-16 08:47:11.736915	\N	active
79	0	0		0	\N	2025-01-16 11:20:45.284641	2025-01-16 11:20:45.284641	\N	active
80	NONE 	NONE	O+	NONE	\N	2025-01-16 11:21:21.003775	2025-01-16 11:21:21.003775	\N	active
81	0	0	A+	0	\N	2025-01-16 11:26:59.294	2025-01-16 11:26:59.294	\N	active
82	0	0	O+	0	\N	2025-01-16 11:34:20.94074	2025-01-16 11:34:20.94074	\N	active
83	NONE	NONE		NONE	\N	2025-01-16 13:25:23.438923	2025-01-16 13:25:23.438923		active
86	0	0		0	\N	2025-01-16 13:30:56.712128	2025-01-16 13:30:56.712128	0	active
89	none 	none		none	\N	2025-01-16 13:32:27.661626	2025-01-16 13:32:27.661626	000000	active
92	0\n	0		0	\N	2025-01-16 13:36:06.966401	2025-01-16 13:36:06.966401		active
95	None	None		None	\N	2025-01-16 13:40:25.933153	2025-01-16 13:40:25.933153	0000000	active
98	0	0		0	\N	2025-01-16 13:42:45.988234	2025-01-16 13:42:45.988234		active
101	None	None		None	\N	2025-01-16 13:45:57.329343	2025-01-16 13:45:57.329343	0000000	active
104	0	0		0	\N	2025-01-16 13:47:40.219982	2025-01-16 13:47:40.219982		active
107	none	none		none	\N	2025-01-16 13:51:02.224531	2025-01-16 13:51:02.224531	0000000	active
110	0	0		0	\N	2025-01-16 13:53:39.233404	2025-01-16 13:53:39.233404		active
113	None	None		None	\N	2025-01-16 13:56:50.986472	2025-01-16 13:56:50.986472	0000000	active
116	0	0		0	\N	2025-01-16 13:58:06.919572	2025-01-16 13:58:06.919572		active
119	0	0		0	\N	2025-01-16 13:59:01.027229	2025-01-16 13:59:01.027229		active
122	0	0		0	\N	2025-01-16 14:01:21.490716	2025-01-16 14:01:21.490716		active
125	None	None		None	\N	2025-01-16 14:05:40.32193	2025-01-16 14:05:40.32193		active
128	0	0		0	\N	2025-01-16 14:05:44.705545	2025-01-16 14:05:44.705545		active
131	0	0		0	\N	2025-01-16 14:05:46.310072	2025-01-16 14:05:46.310072		active
134	None	None		None	\N	2025-01-16 14:10:21.773154	2025-01-16 14:10:21.773154	0000000	active
137	0	0		0	\N	2025-01-16 14:10:43.553457	2025-01-16 14:10:43.553457		active
140	0	0		0	\N	2025-01-16 14:16:10.303585	2025-01-16 14:16:10.303585	0	active
143	0	0		0	\N	2025-01-16 14:16:14.76931	2025-01-16 14:16:14.76931		active
146	None	None		None	\N	2025-01-16 14:16:22.182582	2025-01-16 14:16:22.182582		active
149	0	0		0	\N	2025-01-16 14:17:06.05334	2025-01-16 14:17:06.05334	0	active
152	0	0		0	\N	2025-01-16 14:20:48.437683	2025-01-16 14:20:48.437683		active
155	0	0		0	\N	2025-01-16 14:21:31.752859	2025-01-16 14:21:31.752859	0	active
158	0	0		O	\N	2025-01-16 14:23:32.951528	2025-01-16 14:23:32.951528	0	active
161	0	0		0	\N	2025-01-16 14:23:43.979966	2025-01-16 14:23:43.979966		active
164	none	none		none	\N	2025-01-16 14:24:02.924514	2025-01-16 14:24:02.924514		active
167	0	0		0	\N	2025-01-16 14:27:26.008205	2025-01-16 14:27:26.008205	0	active
170	0	0		0	\N	2025-01-16 14:28:10.256949	2025-01-16 14:28:10.256949		active
173	0	0		0	\N	2025-01-16 14:28:57.802741	2025-01-16 14:28:57.802741	0	active
176	None	None		None	\N	2025-01-16 14:29:15.593746	2025-01-16 14:29:15.593746	0000000	active
179	0	0		0	\N	2025-01-16 14:30:47.668938	2025-01-16 14:30:47.668938		active
182	0	00		0	\N	2025-01-16 14:31:22.559292	2025-01-16 14:31:22.559292	0	active
185	0	0		0	\N	2025-01-16 14:33:06.853269	2025-01-16 14:33:06.853269	0	active
188	None	None		None	\N	2025-01-16 14:33:39.35356	2025-01-16 14:33:39.35356		active
191	0	0		0	\N	2025-01-16 14:34:33.930359	2025-01-16 14:34:33.930359		active
194	0	0		0	\N	2025-01-16 14:37:28.213691	2025-01-16 14:37:28.213691	0	active
197	0	0		0	\N	2025-01-16 14:37:43.903862	2025-01-16 14:37:43.903862	0	active
200	None	None		None	\N	2025-01-16 14:38:42.226738	2025-01-16 14:38:42.226738	0000000	active
203	0	0		0	\N	2025-01-16 14:40:49.561892	2025-01-16 14:40:49.561892		active
206	0	0		0	\N	2025-01-16 14:43:13.588619	2025-01-16 14:43:13.588619	0	active
209	0	0		0	\N	2025-01-16 14:44:33.297836	2025-01-16 14:44:33.297836		active
212	none	none		none	\N	2025-01-16 14:45:39.165634	2025-01-16 14:45:39.165634		active
215	0	0		0	\N	2025-01-16 14:50:20.224924	2025-01-16 14:50:20.224924		active
218	0	0		0	\N	2025-01-16 14:50:21.74793	2025-01-16 14:50:21.74793	0	active
221	none	none		none	\N	2025-01-16 14:51:11.226891	2025-01-16 14:51:11.226891		active
224	0	0		0	\N	2025-01-16 14:51:54.119139	2025-01-16 14:51:54.119139	0	active
227	0\n	0		0	\N	2025-01-16 14:55:29.968126	2025-01-16 14:55:29.968126		active
230	none	none		none	\N	2025-01-16 14:56:15.162331	2025-01-16 14:56:15.162331		active
233	0	0		0	\N	2025-01-16 14:58:22.272334	2025-01-16 14:58:22.272334	0	active
236	0	0		0	\N	2025-01-16 15:00:15.432783	2025-01-16 15:00:15.432783	0	active
239	none	none		none	\N	2025-01-16 15:01:13.088906	2025-01-16 15:01:13.088906		active
242	0	0		0	\N	2025-01-16 15:01:58.421491	2025-01-16 15:01:58.421491	0	active
245	0	0		0	\N	2025-01-16 15:02:33.095362	2025-01-16 15:02:33.095362		active
248	0	0		0	\N	2025-01-16 15:02:52.439625	2025-01-16 15:02:52.439625	0	active
251	none	none		none	\N	2025-01-16 15:06:20.392154	2025-01-16 15:06:20.392154		active
254	0	0		0	\N	2025-01-16 15:07:12.491653	2025-01-16 15:07:12.491653	0	active
257	0	0		0	\N	2025-01-16 15:07:28.937886	2025-01-16 15:07:28.937886		active
260	0	0		0	\N	2025-01-16 15:07:40.560411	2025-01-16 15:07:40.560411	0	active
263	0	0		0	\N	2025-01-16 15:11:13.592434	2025-01-16 15:11:13.592434	0	active
266	0	0		0	\N	2025-01-16 15:17:15.33915	2025-01-16 15:17:15.33915		active
269	0	0		0	\N	2025-01-16 15:18:13.502655	2025-01-16 15:18:13.502655	0	active
272	0	0		0	\N	2025-01-16 15:18:18.681532	2025-01-16 15:18:18.681532	0	active
275	0	0		0	\N	2025-01-16 15:22:24.016946	2025-01-16 15:22:24.016946	0	active
278	0	0		0	\N	2025-01-16 15:31:00.873725	2025-01-16 15:31:00.873725	0	active
281	0	0		0	\N	2025-01-16 15:41:08.922881	2025-01-16 15:41:08.922881		active
284	0	0		0	\N	2025-01-16 15:43:58.591404	2025-01-16 15:43:58.591404	0	active
287	0	0		0	\N	2025-01-16 15:45:17.43456	2025-01-16 15:45:17.43456		active
290	0	0		0	\N	2025-01-16 15:53:29.944733	2025-01-16 15:53:29.944733		active
293	0	0		0	\N	2025-01-16 15:55:03.423841	2025-01-16 15:55:03.423841	0	active
296	0	0		0	\N	2025-01-16 15:56:13.205217	2025-01-16 15:56:13.205217	0	active
299	0	0		0	\N	2025-01-16 15:57:14.533799	2025-01-16 15:57:14.533799		active
302	0	0		0	\N	2025-01-16 15:59:48.388705	2025-01-16 15:59:48.388705	0	active
305	0	0		0	\N	2025-01-16 16:01:41.019583	2025-01-16 16:01:41.019583	0	active
308	0	0		0	\N	2025-01-16 16:03:12.83079	2025-01-16 16:03:12.83079		active
311	0	0		0	\N	2025-01-16 16:03:49.9707	2025-01-16 16:03:49.9707		active
314	0	0		0	\N	2025-01-16 16:03:59.466081	2025-01-16 16:03:59.466081	0	active
317	0	0		0	\N	2025-01-16 16:08:24.128714	2025-01-16 16:08:24.128714	0	active
320	0	0		0	\N	2025-01-16 16:09:59.780686	2025-01-16 16:09:59.780686	0	active
323	0	0		0	\N	2025-01-16 16:10:48.335595	2025-01-16 16:10:48.335595		active
326	0	0		0	\N	2025-01-16 16:13:56.350609	2025-01-16 16:13:56.350609	0	active
329	0	0		0	\N	2025-01-16 16:16:00.293582	2025-01-16 16:16:00.293582		active
332	0	0		0	\N	2025-01-16 16:18:17.935668	2025-01-16 16:18:17.935668	0	active
335	0	0		0	\N	2025-01-16 16:20:49.114191	2025-01-16 16:20:49.114191	0	active
338	0	0		0	\N	2025-01-16 16:26:13.967519	2025-01-16 16:26:13.967519	0	active
341	0	0		0	\N	2025-01-17 11:20:26.586073	2025-01-17 11:20:26.586073	0	active
344	0	0		0	\N	2025-01-17 11:21:09.141368	2025-01-17 11:21:09.141368	0	active
347	0	0		0	\N	2025-01-17 11:27:11.622509	2025-01-17 11:27:11.622509	0	active
350	0	0		0	\N	2025-01-17 11:36:20.383512	2025-01-17 11:36:20.383512	0	active
353	0	0		0	\N	2025-01-17 11:40:44.415414	2025-01-17 11:40:44.415414		active
356	0	0		0	\N	2025-01-17 11:50:36.924961	2025-01-17 11:50:36.924961	0	active
359	0	0		0	\N	2025-01-17 11:52:29.005327	2025-01-17 11:52:29.005327		active
362	0	0		0	\N	2025-01-17 11:58:10.023713	2025-01-17 11:58:10.023713		active
365	0	0		0	\N	2025-01-17 12:03:32.346661	2025-01-17 12:03:32.346661		active
368	0	0		0	\N	2025-01-17 12:07:18.230573	2025-01-17 12:07:18.230573	0	active
371	0	0		0	\N	2025-01-17 12:12:50.149495	2025-01-17 12:12:50.149495	0	active
374	0	0		0	\N	2025-01-17 12:13:11.113103	2025-01-17 12:13:11.113103		active
377	0	0		0	\N	2025-01-17 12:23:38.301685	2025-01-17 12:23:38.301685		active
380	0	0		0	\N	2025-01-17 12:33:20.050047	2025-01-17 12:33:20.050047		active
383	0	0		0	\N	2025-01-17 12:47:52.256531	2025-01-17 12:47:52.256531	0	active
386	0	0		0	\N	2025-01-17 12:49:30.163561	2025-01-17 12:49:30.163561		active
389	0	0		0	\N	2025-01-17 12:53:42.325819	2025-01-17 12:53:42.325819	0	active
392	0	0		0	\N	2025-01-17 12:59:08.880195	2025-01-17 12:59:08.880195	0	active
395	0	0		0	\N	2025-01-17 13:07:47.102031	2025-01-17 13:07:47.102031	0	active
398	0	0		0	\N	2025-01-17 13:12:59.881972	2025-01-17 13:12:59.881972		active
401	0	0		0	\N	2025-01-17 13:13:55.39714	2025-01-17 13:13:55.39714	0	active
404	0	0		0	\N	2025-01-17 13:22:32.824587	2025-01-17 13:22:32.824587	0	active
407	0	0		0	\N	2025-01-17 13:28:24.164622	2025-01-17 13:28:24.164622		active
410	0	0		0	\N	2025-01-17 13:33:26.928295	2025-01-17 13:33:26.928295	0	active
413	0	0		0	\N	2025-01-17 13:39:20.391491	2025-01-17 13:39:20.391491	0	active
416	0	0		0	\N	2025-01-17 13:41:18.48042	2025-01-17 13:41:18.48042		active
419	0	0	A+	0	\N	2025-01-17 13:50:49.983032	2025-01-17 13:50:49.983032		active
422	0	0		0	\N	2025-01-17 13:55:48.991383	2025-01-17 13:55:48.991383	0	active
425	0	0		0	\N	2025-01-17 13:59:52.993919	2025-01-17 13:59:52.993919		active
428	0	0		0	\N	2025-01-17 14:02:06.830657	2025-01-17 14:02:06.830657	0	active
431	0	0		0	\N	2025-01-17 14:09:47.965474	2025-01-17 14:09:47.965474	0	active
434	0	0		0	\N	2025-01-17 14:12:41.386088	2025-01-17 14:12:41.386088		active
437	0	0		0	\N	2025-01-17 14:22:49.442722	2025-01-17 14:22:49.442722		active
440	0	0		0	\N	2025-01-17 14:25:33.369871	2025-01-17 14:25:33.369871	0	active
443	0	0		0	\N	2025-01-17 14:30:51.219318	2025-01-17 14:30:51.219318	0	active
446	0	0		0	\N	2025-01-17 14:37:48.174168	2025-01-17 14:37:48.174168	0	active
449	0	0		0	\N	2025-01-17 14:46:51.337056	2025-01-17 14:46:51.337056	0	active
452	0	0		0	\N	2025-01-17 14:52:00.139223	2025-01-17 14:52:00.139223	0	active
455	0	0		0	\N	2025-01-17 14:58:01.810329	2025-01-17 14:58:01.810329	0	active
458	0	0		0	\N	2025-01-17 15:02:13.276455	2025-01-17 15:02:13.276455	0	active
461	0	0		0	\N	2025-01-17 15:05:33.379832	2025-01-17 15:05:33.379832	0	active
464	0	0		0	\N	2025-01-17 15:10:12.305085	2025-01-17 15:10:12.305085	0	active
467	0	0		0	\N	2025-01-17 15:11:41.521337	2025-01-17 15:11:41.521337	0	active
470	0	0		0	\N	2025-01-17 15:15:28.989026	2025-01-17 15:15:28.989026	0	active
473	0	0		0	\N	2025-01-17 15:18:28.39795	2025-01-17 15:18:28.39795	0	active
476	0	0		0	\N	2025-01-17 15:19:58.487464	2025-01-17 15:19:58.487464	0	active
479	0	0		0	\N	2025-01-17 15:23:36.725747	2025-01-17 15:23:36.725747	0	active
482	0	0		0	\N	2025-01-17 15:26:59.894777	2025-01-17 15:26:59.894777	0	active
485	0	0		0	\N	2025-01-17 15:27:30.268782	2025-01-17 15:27:30.268782	0	active
488	0	0		0	\N	2025-01-17 15:31:54.000811	2025-01-17 15:31:54.000811	0	active
491	0	0		0	\N	2025-01-17 15:33:57.890531	2025-01-17 15:33:57.890531	0	active
494	0	0		0	\N	2025-01-17 15:37:44.664574	2025-01-17 15:37:44.664574	0	active
497	0	0	O+	0	\N	2025-01-17 15:38:53.146441	2025-01-17 15:38:53.146441	\N	active
498	0	0		0	\N	2025-01-17 15:41:09.873134	2025-01-17 15:41:09.873134	0	active
501	0\n	0		0	\N	2025-01-17 15:41:11.847615	2025-01-17 15:41:11.847615		active
504	0	0		0	\N	2025-01-17 15:46:53.717998	2025-01-17 15:46:53.717998	0	active
507	0	0		0	\N	2025-01-17 15:48:21.347562	2025-01-17 15:48:21.347562		active
510	0	0		0	\N	2025-01-17 15:48:31.96919	2025-01-17 15:48:31.96919	0	active
513	0	0		0	\N	2025-01-17 15:49:01.868714	2025-01-17 15:49:01.868714		active
516	0	0		0	\N	2025-01-17 15:50:14.007902	2025-01-17 15:50:14.007902	0	active
519	0	0		0	\N	2025-01-17 15:51:26.699972	2025-01-17 15:51:26.699972		active
522	0	0		0	\N	2025-01-17 15:51:37.225472	2025-01-17 15:51:37.225472		active
525	0	0		0	\N	2025-01-17 15:52:44.108075	2025-01-17 15:52:44.108075	0	active
528	0	0		0	\N	2025-01-17 15:56:10.158913	2025-01-17 15:56:10.158913	0	active
531	0	0		0	\N	2025-01-17 15:56:41.490177	2025-01-17 15:56:41.490177	0	active
534	0	0		0	\N	2025-01-17 15:59:38.045232	2025-01-17 15:59:38.045232	0	active
537	0	0		0	\N	2025-01-17 16:00:06.728997	2025-01-17 16:00:06.728997		active
540	0	0		0	\N	2025-01-17 16:02:59.349213	2025-01-17 16:02:59.349213	0	active
543	0	0		0	\N	2025-01-17 16:04:26.65736	2025-01-17 16:04:26.65736		active
546	0	0		0	\N	2025-01-17 16:05:04.427187	2025-01-17 16:05:04.427187	0	active
549	0	0		0	\N	2025-01-17 16:07:28.85577	2025-01-17 16:07:28.85577		active
552	0	0		0	\N	2025-01-17 16:08:09.275736	2025-01-17 16:08:09.275736	0	active
555	0	0		0	\N	2025-01-17 16:08:26.593012	2025-01-17 16:08:26.593012		active
558	0	0		0	\N	2025-01-17 16:08:46.325289	2025-01-17 16:08:46.325289	0	active
561	0	0		0	\N	2025-01-17 16:14:28.099783	2025-01-17 16:14:28.099783		active
564	0	0		0	\N	2025-01-17 16:18:30.384299	2025-01-17 16:18:30.384299		active
567	0	0		0	\N	2025-01-17 16:26:30.555167	2025-01-17 16:26:30.555167		active
570	0	0		0	\N	2025-01-17 16:32:34.685104	2025-01-17 16:32:34.685104		active
573	0	0		0	\N	2025-01-17 16:41:50.711235	2025-01-17 16:41:50.711235		active
576	0	0		0	\N	2025-01-17 16:47:25.556928	2025-01-17 16:47:25.556928		active
579	0	0		0	\N	2025-01-17 16:51:48.315814	2025-01-17 16:51:48.315814		active
582	0	0		0	\N	2025-01-17 16:57:12.308429	2025-01-17 16:57:12.308429		active
585	0	0		0	\N	2025-01-17 17:00:57.048815	2025-01-17 17:00:57.048815		active
588	0	0		0	\N	2025-01-17 17:07:52.510323	2025-01-17 17:07:52.510323		active
591	0	0		0	\N	2025-01-20 14:02:16.988053	2025-01-20 14:02:16.988053		active
594	0	0		0	\N	2025-01-20 14:10:12.097763	2025-01-20 14:10:12.097763		active
597	0	0		0	\N	2025-01-20 14:18:44.645796	2025-01-20 14:18:44.645796		active
600	0	0		0	\N	2025-01-20 14:25:54.591834	2025-01-20 14:25:54.591834		active
603	0	0		0	\N	2025-01-20 14:31:44.698019	2025-01-20 14:31:44.698019		active
606	0	0		0	\N	2025-01-20 14:37:44.024409	2025-01-20 14:37:44.024409		active
609	0	0		0	\N	2025-01-20 14:41:42.675995	2025-01-20 14:41:42.675995		active
612	0	0		0	\N	2025-01-20 14:48:46.745623	2025-01-20 14:48:46.745623		active
615	0	0		0	\N	2025-01-20 14:54:50.836881	2025-01-20 14:54:50.836881		active
618	0	0		0	\N	2025-01-20 15:04:19.748674	2025-01-20 15:04:19.748674		active
621	0	0		0	\N	2025-01-20 15:12:40.015484	2025-01-20 15:12:40.015484		active
624	0	0		0	\N	2025-01-20 15:17:22.884353	2025-01-20 15:17:22.884353		active
627	0	0		0	\N	2025-01-20 15:24:06.121157	2025-01-20 15:24:06.121157		active
630	0	0		0	\N	2025-01-20 15:33:24.879699	2025-01-20 15:33:24.879699		active
633	0	0		0	\N	2025-01-20 15:42:10.698806	2025-01-20 15:42:10.698806		active
636	0	0		0	\N	2025-01-20 15:46:39.583081	2025-01-20 15:46:39.583081	0	active
639	0	0		0	\N	2025-01-20 15:52:32.418037	2025-01-20 15:52:32.418037	0	active
642	0	0		0	\N	2025-01-20 15:58:08.455234	2025-01-20 15:58:08.455234		active
645	0	0		0	\N	2025-01-22 13:22:58.05897	2025-01-22 13:22:58.05897		active
651	0	0		0	\N	2025-01-22 13:28:36.365395	2025-01-22 13:28:36.365395		active
654	0	0		0	\N	2025-01-22 13:29:11.027744	2025-01-22 13:29:11.027744		active
657	0	0		0	\N	2025-01-22 13:34:31.88057	2025-01-22 13:34:31.88057		active
660	0	0		0	\N	2025-01-22 13:34:55.597241	2025-01-22 13:34:55.597241		active
663	0	0		0	\N	2025-01-22 13:38:15.074648	2025-01-22 13:38:15.074648	0	active
666	0	0		0	\N	2025-01-22 13:39:48.71103	2025-01-22 13:39:48.71103		active
668	0	0		0	\N	2025-01-22 13:42:35.378413	2025-01-22 13:42:35.378413	0	active
671	0	0		0	\N	2025-01-22 13:45:53.412023	2025-01-22 13:45:53.412023		active
673	0	0		0	\N	2025-01-22 13:46:47.318695	2025-01-22 13:46:47.318695	0	active
676	0	0		0	\N	2025-01-22 13:51:59.383404	2025-01-22 13:51:59.383404	0	active
679	0	0		0	\N	2025-01-22 13:52:25.064189	2025-01-22 13:52:25.064189		active
682	0	0		0	\N	2025-01-22 13:55:22.798699	2025-01-22 13:55:22.798699	0	active
685	0	0		0	\N	2025-01-22 13:56:55.357526	2025-01-22 13:56:55.357526		active
688	0	0		0	\N	2025-01-22 13:58:17.814601	2025-01-22 13:58:17.814601	0	active
691	0	0		0	\N	2025-01-22 14:02:12.986319	2025-01-22 14:02:12.986319	0	active
694	0	0		0	\N	2025-01-22 14:03:25.808574	2025-01-22 14:03:25.808574		active
697	0	0		0	\N	2025-01-22 14:05:44.732786	2025-01-22 14:05:44.732786	0	active
700	0	0		0	\N	2025-01-22 14:08:35.890904	2025-01-22 14:08:35.890904		active
703	0	0		0	\N	2025-01-22 14:09:26.725846	2025-01-22 14:09:26.725846	0	active
706	0	0		0	\N	2025-01-22 14:14:08.749198	2025-01-22 14:14:08.749198	0	active
709	0	0		0	\N	2025-01-22 14:14:54.226053	2025-01-22 14:14:54.226053		active
712	0	0		0	\N	2025-01-22 14:17:13.644373	2025-01-22 14:17:13.644373	0	active
715	0	0		0	\N	2025-01-22 14:19:36.619575	2025-01-22 14:19:36.619575		active
718	0	0		0	\N	2025-01-22 14:20:16.953589	2025-01-22 14:20:16.953589	0	active
721	0	0		0	\N	2025-01-22 14:24:22.933102	2025-01-22 14:24:22.933102		active
724	0	0		0	\N	2025-01-22 14:25:08.792425	2025-01-22 14:25:08.792425	0	active
727	0	0		0	\N	2025-01-22 14:29:20.12141	2025-01-22 14:29:20.12141		active
730	0	0		0	\N	2025-01-22 14:29:21.940007	2025-01-22 14:29:21.940007	0	active
733	0	0		0	\N	2025-01-22 14:32:41.790804	2025-01-22 14:32:41.790804	0	active
736	0	0		0	\N	2025-01-22 14:35:59.323742	2025-01-22 14:35:59.323742		active
739	0	0		0	\N	2025-01-22 14:37:02.067773	2025-01-22 14:37:02.067773	0	active
742	0	0		0	\N	2025-01-22 14:40:02.397739	2025-01-22 14:40:02.397739	0	active
745	0	0		0	\N	2025-01-22 14:40:42.574636	2025-01-22 14:40:42.574636		active
748	0	0		0	\N	2025-01-22 14:44:22.367725	2025-01-22 14:44:22.367725	0	active
751	0	0		0	\N	2025-01-22 14:46:43.473997	2025-01-22 14:46:43.473997		active
754	0	0		0	\N	2025-01-22 14:52:27.867219	2025-01-22 14:52:27.867219		active
757	0	0		0	\N	2025-01-22 14:56:33.418489	2025-01-22 14:56:33.418489		active
760	0	0		0	\N	2025-01-22 15:00:48.480566	2025-01-22 15:00:48.480566		active
763	0	0		0	\N	2025-01-22 15:05:29.543459	2025-01-22 15:05:29.543459		active
766	0	0		0	\N	2025-01-22 15:09:36.356168	2025-01-22 15:09:36.356168		active
769	0	0		0	\N	2025-01-22 15:13:51.31593	2025-01-22 15:13:51.31593		active
772	0	0		0	\N	2025-01-22 15:18:30.727323	2025-01-22 15:18:30.727323		active
775	0	0		0	\N	2025-01-22 15:21:41.792236	2025-01-22 15:21:41.792236		active
778	0	0		0	\N	2025-01-22 15:24:29.321993	2025-01-22 15:24:29.321993		active
781	0	0		0	\N	2025-01-22 15:27:58.599863	2025-01-22 15:27:58.599863		active
784	0	0		0	\N	2025-01-22 15:31:24.517685	2025-01-22 15:31:24.517685		active
787	0	0		0	\N	2025-01-22 15:36:52.332445	2025-01-22 15:36:52.332445		active
790	0	0		0	\N	2025-01-22 15:40:18.961479	2025-01-22 15:40:18.961479		active
792	0	0		0	\N	2025-01-22 15:46:11.638494	2025-01-22 15:46:11.638494		active
795	0	0		0	\N	2025-01-22 15:52:14.776778	2025-01-22 15:52:14.776778		active
801	0	0		0	\N	2025-01-22 16:01:34.667296	2025-01-22 16:01:34.667296		active
804	0	0		0	\N	2025-01-22 16:10:54.596478	2025-01-22 16:10:54.596478		active
798	0	0		0	\N	2025-01-22 15:56:48.394019	2025-01-22 15:56:48.394019		active
648	0	0		0	\N	2025-01-22 13:23:48.624842	2025-01-22 13:23:48.624842		active
807	0	0		0	\N	2025-01-24 14:03:08.871544	2025-01-24 14:03:08.871544		active
810	0	0		0	\N	2025-01-24 14:05:12.772825	2025-01-24 14:05:12.772825	0	active
813	0	0		0	\N	2025-01-24 14:08:18.584215	2025-01-24 14:08:18.584215		active
816	0	0		0	\N	2025-01-24 14:09:14.149622	2025-01-24 14:09:14.149622		active
819	0	0		0	\N	2025-01-24 14:12:04.817243	2025-01-24 14:12:04.817243		active
822	0	0		0	\N	2025-01-24 14:16:19.533433	2025-01-24 14:16:19.533433		active
825	0	0		0	\N	2025-01-24 14:20:38.749445	2025-01-24 14:20:38.749445		active
828	0	0		0	\N	2025-01-24 14:24:44.782167	2025-01-24 14:24:44.782167		active
831	0	0		0	\N	2025-01-24 14:28:34.942966	2025-01-24 14:28:34.942966		active
834	0	0		0	\N	2025-01-24 14:33:18.265427	2025-01-24 14:33:18.265427		active
837	0	0		0	\N	2025-01-24 14:36:38.167673	2025-01-24 14:36:38.167673		active
840	0	0		0	\N	2025-01-24 14:41:56.986697	2025-01-24 14:41:56.986697		active
843	0	0		0	\N	2025-01-24 14:48:10.905178	2025-01-24 14:48:10.905178		active
846	0	0		0	\N	2025-01-24 15:02:45.719648	2025-01-24 15:02:45.719648		active
849	0	0		0	\N	2025-01-24 15:17:08.848505	2025-01-24 15:17:08.848505		active
852	0	0		0	\N	2025-01-24 15:21:33.391809	2025-01-24 15:21:33.391809		active
855	0	0		0	\N	2025-01-24 15:25:10.640938	2025-01-24 15:25:10.640938		active
858	0	0		0	\N	2025-01-24 15:28:10.029282	2025-01-24 15:28:10.029282		active
861	O	0		0	\N	2025-01-24 15:59:12.485981	2025-01-24 15:59:12.485981	123	active
864	0\n	0		0	\N	2025-01-24 16:10:26.881727	2025-01-24 16:10:26.881727		active
867	0	0		0	\N	2025-01-24 16:26:43.968933	2025-01-24 16:26:43.968933	123	active
870	0	0		0	\N	2025-01-24 16:32:36.596503	2025-01-24 16:32:36.596503		active
873	0	0		0	\N	2025-01-24 16:48:27.902282	2025-01-24 16:48:27.902282		active
876	0	0		0	\N	2025-01-24 16:55:33.890004	2025-01-24 16:55:33.890004		active
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id) FROM stdin;
1	1
47	3
57	3
55	3
56	3
58	3
61	3
74	3
76	3
69	3
77	3
67	2
68	3
60	3
59	3
65	3
70	3
71	3
64	3
62	3
72	3
54	5
54	2
54	3
73	3
63	3
78	3
75	3
79	3
80	3
81	3
82	3
497	3
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, user_name, user_email, role, status, password) FROM stdin;
51	christiana  acquah nhyira 		student	active	$2a$10$rA6oK1454fP4czac5gU/fek2ur1j.9eTXgaal0DuDEXf9bztagQKC
52	innocentia  fordjour 		parent	active	$2a$10$ixkilcCne9aXppReBlDfLu6Fd7r/N1Hnz5bQWxS7nKZjEMkzhelT6
53	alfred  acquah 		parent	active	$2a$10$rxW24lrCNuyG5yrC8xwBd.vXV1GlwVAzcRFkXhzRclXhEWS2R9THS
55	veronica aggrey 		teaching staff	active	$2a$10$HThc1jaAuMUBr0MoI8mXIuBdvYfKyIG3n.BhzUYzFT/XKpMY0NRjG
56	isaac mankoe 		teaching staff	active	$2a$10$BflrsAo8m2K3/n4FDXsFK.p2z30pMn7q0jdXbu0n1dwGv67We3zkm
47	alex ankah  junior		teaching staff	active	$2a$10$H8/8JXGtHSdrHosXD6vsCObxj4a/SlXY29yLD7dfLWvC5hFmujh3K
57	isaac danquah 		teaching staff	active	$2a$10$A1gCNklruma4PKLIssI0yOt4mLEDd0DnfDhkxmYA3TRCmftsXeiPK
1	adminadmin	admin@admin	admin	active	$2a$10$gXhRGHZLK9M3UOuQ8HI5tuuMQ2XBuZjm.N/0CAEOM0u6mIm6b.LAS
54	obed takyi godsmal		head teacher	active	$2a$10$k8mh5q3q9uWCunSE5hYlQu.K0eF8PgnFjjY65n9kl9.DvzPdt5WCm
58	abubakar osman 		teaching staff	active	$2a$10$zkmeag0CyHbBFnbpf5F1/ObplzFTLSE9.QZp5igXOomYQ2NgD1pVq
59	joseph panyin smith		teaching staff	active	$2a$10$B2/mev9xuJ6Cgsd09ioJH.GGeOZxup2YxXQFaWOtM4jUQMJlUcZfS
60	joseph essel 		teaching staff	active	$2a$10$Y1nwNSr07nZIaIQdfpq0XOU.DCcialh9oDXP0eM/9ihZHw46lj7li
61	alexander appiah 		teaching staff	active	$2a$10$.qLt7QPrEj9o81JaMIgHNu.NDpcU1Qit3jtoypCqdtDhB25VrEexq
62	miriam ledlum sika		teaching staff	active	$2a$10$EB1D79Z46SIfBTAHENZCOeieIvbz7puNzTroOPa4vYuJvQtclWnIa
63	robert eyiah-mensah 		teaching staff	active	$2a$10$i2mmKk6TOgXWG49TP.vxGenFTOQdBMf7E0ualBkosornmMoSuwuWa
64	mercy yorke aba		teaching staff	active	$2a$10$0DQHUDdA/OtbxHKX/0YVXupYy1OH88YZ4SGEExrixYB77hby2Wgzi
65	kennedy adu-mensah junior		teaching staff	active	$2a$10$/PJFwr8/mjHeKrFVzQXBNOtFKHcI.wRBc2vJZA1ZKtNm86htw7/2G
66	elizabeth wilson 		non teaching	active	$2a$10$zyZT8rFSs5twVlKBNdLsE.0yMKcc7yaxmEpb6rhbrtvM1eNHDrMEq
67	eunice appiah 		head staff	active	$2a$10$MF7yHGtm.RUMygYv7/fS.eJnzJzNde5ooXjfsDJFBM0PLTrcut6am
69	ebenezer andoh 		teaching staff	active	$2a$10$oGMAftMiTuVDQQv9z/vK8uPA07DruGTLLkGJkbVLVpYj9cHW9LMYy
70	mary mensah 		teaching staff	active	$2a$10$PlV4FsLrAveBLJNkTpDalOyPV7bNTuIUHoTo8xZKLPRFVuRATP3Z.
68	janet hammond aba sey		teaching staff	active	$2a$10$kutgURkj2NcMFIBPFwwV2.zgXq/KwlKi6KUG/YiGLSDhSXh22QPKy
71	mary simpson 		teaching staff	active	$2a$10$ZNMvHD27pCRer8OQmjRs0.SWc086UZUR5mKClKQEsjtnqIF.FUkx6
73	priscilla quaye 		teaching staff	active	$2a$10$lJgQJAZHyJsoNV3eoAQLQ.a5.e3C7iV6teyA5njg/aTpu7r.7vVZ2
74	cecilia abban 		teaching staff	active	$2a$10$eQNiIARvYRfjrVnoyPuCzOwYSplQoAZfhv6L.SS8zyj/OgzllQvpu
75	susana essel 		teaching staff	active	$2a$10$2MS5fPqAPg8Dvgq43Hk7puQDxjf4gx12S0qI6XhZxCU7i3GWuS5vW
76	comfort bondzie 		teaching staff	active	$2a$10$U3X1fU8FeaRI9Qq9PlkWsOvwMXvxXc1.3KSxJM5shZm2mHzgVVdQO
77	ernestina aggrey 		teaching staff	active	$2a$10$tlqXvgfmho1BHO98./9qPOfZU4CyKVdH66zM5WvVHWi8Vg27ANpMe
78	ruth aidoo 		teaching staff	active	$2a$10$GrOddkpt2.jOzf/PzZ9qg.lyJBQOsVCePA/NYCyLLJarke7h2W3Vy
79	george enninful 		teaching staff	active	$2a$10$8nxbj99JFDMTNnVAK116Leb0cNXCLVwSHZ4kOAMyqL2WZdoueP8BK
80	erica, appuah adams	adamserica46@gmail.com	teaching staff	active	$2a$10$GZQuf9/.wzBPjl.f0ZUBO.K1Z8A8p5JD9Ku74YoW4TscfWEEwvA8i
81	michael eyiah-mensah 	eyiahmensahmichael@gmail.com	teaching staff	active	$2a$10$unWHcnSwLO9nrpm2xIWXiOrxQQY1c..o16KuJWPnA5LKdgyXSiPkK
82	linda otabil egyir		teaching staff	active	$2a$10$wPPGwfV431w8SdFijs/jIODEranZ.jLm/cVxFfOeXMi643AOMu2XW
83	agbenyagah agbodogli 		student	active	$2a$10$fX7bgNfoFwwXLbz35.nkwe14pbzcNZ3KKNf9.TPMA/qcg6exvHcsO
84	 arthur rebecca		parent	active	$2a$10$lYRToyL19dOZbVoRRbnIn.4PyX6m.Om0Kt2v1vkXF58hfK4PjQo4O
85	 agbodogli emmanuel		parent	active	$2a$10$erfnPK0kI0uUK9ZkURaARewbOhX7G/IdMoMx7ZYSpx/N.Th63U3P6
86	addison andres iniesta		student	active	$2a$10$cc7YVOlhQ9qwjj9XglSjTOfkvYLzCs8MqApgzeuYxYDmmmazF0eo6
87	 acquah agnes		parent	active	$2a$10$vTzMSKiiWpHMRQXKImxlFumfDu7jviKTxj9v2HVMBjxWYiXidlUhS
88	  		parent	active	$2a$10$eUGUCn4gnzX54GTd/3RmnOyCShqN4Xe48wTb5ubpH0pVPZ0x.sMpS
89	owusu gideon stephen		student	active	$2a$10$HMfMTCEg0j1haT3X9v/gLeIYzLL9TVHkjsvAZDIrYfGIt74GKnlS2
90	 appiah eric		parent	active	$2a$10$6snlnKzOc4wbe.54ISZZxOxCZcX4jinP42qvOLYunbn2cJXBQUxKm
91	 owusu    appiah esther		parent	active	$2a$10$jo07FjUww/5j.NYdystal.CED91Xm.Tl7LlpHYGiZgYTqlxrLpPHW
92	abban godfred kojo		student	active	$2a$10$OmpRMeEhH./2KyruoBOc6Oe7WTdtDq.TLUvqnH.zGObwEBUA6MKjG
93	 quansah agartha		parent	active	$2a$10$QI.AOvJ3HS7Brh0TwtGlm.6FhrWL2Ss8qXXM5yFjCf2jYVknlZ1Aa
94	  		parent	active	$2a$10$TXTHb4o4RecXdhQvWb2p/.BnKPtU7xKY.KsyO6rv4pguUM3hduNie
95	apostle john sam		student	active	$2a$10$du/.0L9KR7rEMmtb2y2hx.6N0r5kfTiaaJpOP6J39zXV7dnUzKhS.
96	 eshun castone		parent	active	$2a$10$6j5VbTO21WJG5TgpJdZ93e88Kgc62Ru2KyLC5.KeG9rwbDXEg5HAq
97	 abaa grace		parent	active	$2a$10$vZzizb5jbv6/JlXsDdgiw.xPMbNLum4abo2usOFH7rGLpdmvsxhSe
98	afful desmond don		student	active	$2a$10$I0DMJl/WNcckseBnomnGj.yvkXlywLjY089MAootnNQckWv4rzBJa
99	 afful richard		parent	active	$2a$10$Ps77TXdZuYVQYuDQ.5IZfelHhOBKDn6bwL1i5Bua793RGamTEEuvS
100	  		parent	active	$2a$10$gr3IBi2s2yB9pYGZoauBIebQPHqd3Td7vir3mKt58tLgYiP.Qt/K.
101	odoom blessing 		student	active	$2a$10$9PovY/vx7UfC.SK1Wh/.I.iukrTEjGCwkrq7hLUfCBsIeX.LdDu5u
102	 odoom richard		parent	active	$2a$10$IApT9i8dd91t/ljTKERpJ.j1XcPv5b4jbE9uZoIaVwOAX.TnnR13C
103	 ochere augustina		parent	active	$2a$10$lanp4cAG5yyn1uHVD/IfGeUa5yE1YN96bONfjyB2R8F8JGIOFsaea
104	appoh godwin 		student	active	$2a$10$ANt4yHYxT/hSIf/rmOi6xutfXARDU41KZTwxAtoKmN7R1Enixa6GW
105	 appoh samuel		parent	active	$2a$10$/HSw0lbrs14Dx04JDH54D.XmGa/BrjZhxHqz56zzfE0vqqXQPCAtS
106	 appoh elizabeth		parent	active	$2a$10$Qs1MwFw5mAcqdok64UfJyuElI8E2MqtSiy3H6v20sAN0Iku0LIM3.
107	yankson ewusi nana		student	active	$2a$10$k82PscyFJZCR.XXFZAh0jOx7b0sZ27yJAGfnCWCNx9WBoKAbNIhn6
108	 yankson joseph		parent	active	$2a$10$38puWmQJKp0TKFXZTVC9d.OAFvROZr9XhBPXiMOijw9Ov4Hoky0oC
109	 yankson ruth		parent	active	$2a$10$SGjJ82S.AXmo0ssbJcGoRe/GwdtAO1y7BYUkLdtjC9zhnXjsvxHmK
110	arthur kingsford 		student	active	$2a$10$SMIuvrXEMyqaknZPM/DUweXgok0HNxG45PhzFWn7gt7I6QujaiYT.
111	 essel elizabeth		parent	active	$2a$10$KXGIVNSUv./uPv31Ok0YEuMuHlqUq7ZNqpbDqZ8KGCpUMbDBtDy1i
112	  		parent	active	$2a$10$xDoQKrsIOb6Tu2wGQIdo9.JUCfOOA8dJK.GL0YhB4Jax8bwFOn19i
113	quansah elisha 		student	active	$2a$10$WqFFJzXrZNsbpvENCR3//OiIC4UD7vSvEyGkqFwk8WjsBwigvH.xm
114	 quansah elijah		parent	active	$2a$10$kV6jnjkPc9lFlBjsjL70iOwGZ41.SIxI7xwArH1lPWaw5WBKhoODm
115	 quansah mavis		parent	active	$2a$10$SkfpiKPXF2bUQDaiCo8nx.cnIdbZMkyRP9/CQX1YxrLUg.ufZqrbG
116	ayin jeremiah nii lartey		student	active	$2a$10$Cpcg1JVXqY5o4sxLN6EVH.x62wHS71YVL2FLLpIOanqOKCmjCo4EK
117	 sagoe rebecca		parent	active	$2a$10$EjLtOBJtPsmG2Et31ljbh.x8fdUkbeOhMjnbgl9va/V4MgrGiE23S
118	  		parent	active	$2a$10$acGkt6JLPJsrciiqEGoZROw9En6fMe6wZB2a1bdgggdbRxMZShsdK
119	abuakwa kelvin 		student	active	$2a$10$vfagAZlHewRcm4t/Hgpgp.oWFAOFRUUbCuMuQ8w5WtD1G7gUsDDuS
120	 abban grace		parent	active	$2a$10$Hoh4j7Kk0XtxL.AwzvKFu.BL9T.ix0s/TBqA9PW.1LRsyflscDH0K
121	 baah samuel		parent	active	$2a$10$E.n7JgM7eS8qcZ5LuJJw6uKtIgaTrOYVJriyyM096GIp7qmHEdGe6
122	bondzie kenneth 		student	active	$2a$10$RXb1Mnuh7W2DUQCH7see5uau6qdWvsQ9hkrfbIyYaiSTtyNxK75n6
123	 arthur ruth		parent	active	$2a$10$1YWUd82/cA4EGy3YR4CpYugaCupBblSmbFEabJvxxE0rBNo1ne1fW
124	  		parent	active	$2a$10$rw3cOtmSLGw20DheOEuqcuRQy3vdYH2nXEB5RgUnE8CUZeAjS5WJK
125	arhin john paapa     kum		student	active	$2a$10$sWYX2WTxxuBfFI6h/UCVd.h9ilgpeJdVmyocJr/qzKEX1WtkFx.me
126	 kum arhin isaac		parent	active	$2a$10$Xo0sWm/TpXy1Of3X6q504uXL3dCDjc42qFmlx/kBtamlo/gEOO5NO
127	 sackey joana		parent	active	$2a$10$x3uH8Nb8yrXy9DMz4KD9cedfY/pJOSLJF3IjrNH579/UnHOJ2gzQG
128	acquah carl ato kwamena		student	active	$2a$10$DY5mD0RDYsFDo4ku12ed1u8xba6JTTrAmBcZZ5lO1pkQiyfWvEy/e
129	 acquah akosua tiwaa		parent	active	$2a$10$tnoiAwQ4c7ugmK5XSDlWx.i0aCHblfeCnEIDxyNjDSmbmFSRta25y
130	 acquah samuel		parent	active	$2a$10$z0lyljKQZKOIx7FNB9pVGONmoVtfCPsvRvI/H6/fFCtPcI0p.ZTBW
131	ehun prince 		student	active	$2a$10$t8cHzxQRiuMjKNQDqF1Gl.Iwk/KZ.JxpZ9xKGAH9Bei6OV8P3Hzjy
132	 ehun francis		parent	active	$2a$10$2D9jj8qNGdv0EIxQnzJ2Eu8USRMDV7BFW4UL1VaSQCVz4sO/TdJ26
133	  		parent	active	$2a$10$0Cz.jmv0DTLF/dmjbaFiY.yi.xuspD94x3wv9Jovop2S0pjTv/tue
134	gyesi fredrick john		student	active	$2a$10$kw3O4BgcYm8j12lfqh6UlOkjSuj9LmrutuWkAmytHdWryhPOEWoES
135	 nketiah diana		parent	active	$2a$10$nFW9/NSQjlVuY6w/l5XL.u5ExFapu8I3gEpzLZii5hwXKqU/J599.
136	 mensah john		parent	active	$2a$10$jlWPc4zerpHHvvYMtoUud.nK8bOPfRH/A0cBPSvDC5.2vWFc0496.
137	gyesi gad 		student	active	$2a$10$oy3JiMbQpRho3Hx9dtSbkulPUN8y/9z/0vBv1RVFPiGoDoepIs566
138	 gyesi kobina		parent	active	$2a$10$UyeaunKMAdzXOdEZkVs7beuNkk1NbGLUgr3.FnZkijxk9ULLuX6Du
139	  		parent	active	$2a$10$iIbWItwIDqT4Yr.u.sAEP.z.aX0PjZyeT/jnk/j8Myiu7Gg7J2iC.
140	appoh godfred 		student	active	$2a$10$FavyZWbqyhsIx8RwMw2HAOm9oCdnuoK7h8/e2kpv6RpKeoaTYc3ii
141	 appoh elizabeth		parent	active	$2a$10$sWJu48SEJMD7TCuD09C5AuMHaY.mG8Dxq9Y.BQtg6DaX9FOHVX1oC
142	 appoh samuel		parent	active	$2a$10$AMi9DPi9hnjCJlMBbRhdWeDh6RavrrfNkQqcxoi1EvOfOXjDJHfNa
143	johnson kingsley fiifi donkor		student	active	$2a$10$lBPw35TtEL.8wbn9QROmhu6lj..yk4lWcfc2FPGcsNNNCRXgSnstK
144	 bediako laura		parent	active	$2a$10$ez/YFYaZv0jSIH6AoOLl..GukT93wTVQxrEKIeV7d311HPU3vbjrG
145	  		parent	active	$2a$10$HExPMUYQE2oFtcQUq.PBbeG3S5nybnRxHHWrw/CoxkQnn8ssHAvZK
146	sey merlin 		student	active	$2a$10$akaJ4KnOPhy9ZByz387eq.3AhtrirFKHqpKLQVAyzCYg66vqTtzCq
147	 koranteng mercy		parent	active	$2a$10$eQfJ63fF0QOLmzBH3Z9zM.SdXlLBhAh2r3bbyDAyvp1tGFd0m5U.6
148	 sey john		parent	active	$2a$10$04s9xZl42sahy2ISq8WxEewxqPzuU8PHMOPTR9G0T2DEvHtrBGbuu
149	abbiw shadrack 		student	active	$2a$10$07zmsRQfoLmzNDcCjzpO8OgFB/.5cHYXpmhVfyrGbKjxbPRVVbJuS
150	 essilfie roselove		parent	active	$2a$10$/ADwzdo8cKcNG7q/D2BZWOysbopPslaqAkBelJBm0Q5YWruwRYKOK
151	  		parent	active	$2a$10$UdPud0NAD7Fdzm.ESBlEJ.udPBGTOuhzRf3EnzMzRtL7mfGoW1JHm
152	okwan christian 		student	active	$2a$10$Vw/ZeXQdWwxXSb9SBvHlu.ih8BY4FYIZAI9Ywx8cu.QSHGkWUnCH6
153	 ahor sarah		parent	active	$2a$10$glVJGRJYQiW9V/pGGw4x7.FR9GnoqgNg9oFFPG5fBvSTKD49FSMVa
154	  		parent	active	$2a$10$otp9yxvLydIUH5MVaRl22e5OeZUkVSINHB7oP90IuO4E7yqsUT7Vy
155	arkorful joel 		student	active	$2a$10$9Hk1zwC2KmL5IaU1a8uTqedumYw2vfgp1or3c.2DwdmH9C6J5wWXy
156	 ackom mercy		parent	active	$2a$10$uIGZk3hYNfoDbPfEr.y0p.8yO0hX621QA2GKmJhixPOWUwnQZKRKO
157	 akorful daniel		parent	active	$2a$10$mZmhFR7.oYNTpnr/97t3ouxoDrt7JeNXZG2IMJ1VZRoeyf9Js5JJ.
158	abdullah latif 		student	active	$2a$10$JcMPTgab8G6Y/gXDCPYQVeqqXZ3GDzO3xVyv9FyT5LFDkmWwk591e
159	 abdullah hajara		parent	active	$2a$10$zho5PQJfiOgBtBRqJkcRyeh/H7hz2LkoFI73ta4XziRNdxpSpPQjq
160	  		parent	active	$2a$10$kPRsvhgNhWQZOTXkqcgX9uxQReCioZVIQ4MZi1vYlEIJod05Y4Oxa
161	quansah kingsley 		student	active	$2a$10$qDPl40uHvBNo8lub.b06FuLX71e4uedoKK54NGIFjl27B33RIGtoq
162	 dadzie vida		parent	active	$2a$10$USTlCawVURw2FW7ZNgK/puHPi8Nm35/iWbU2NtkXL8Hot5lhPP3fi
163	  		parent	active	$2a$10$oOHQroytYNiNCZHxMHAw6uS/AcmpTDOsqoeEmNAUpB2SiIUaOZPCO
164	mankoe melvin 		student	active	$2a$10$NPQo0GoyXuh.2lntKxZk5.pvmQqWXWBrNeNIifDEY0D0aPBY7KFBC
165	 mankoe philip		parent	active	$2a$10$SORAoiOd3lIxLAJsq1sT7OL3KhQoynDvyagngVEbO96mgjypteRRq
166	 mensah veronica		parent	active	$2a$10$OLxuEnTYuhuVfSC1IeVbzereapfnfDxyaNzsVSOxC8FBKvVQNj/MC
167	ahengua rahaman 		student	active	$2a$10$ClnJkXu80Qo5HO5d26kwN.BY9VzybPxof0ZvyeSWNg3vp2YKIG3km
168	 nyarko charity		parent	active	$2a$10$A4oGXpWbUVcELoeercgJL.RqzxVuFwPvW8ISSyarouOlvcy6u1TuS
169	  		parent	active	$2a$10$6pjU9UbkCo85uBF3K1/vuOWDCuw8C8PYktJ4De8KmYy0GRnQKPxrG
170	sessah patrick 		student	active	$2a$10$7JJknaOLXbtLGsjPq6IN..EkrIHHfzXEkT5tUOBNiB3pfXQ6QQOR2
171	 arthur esther		parent	active	$2a$10$j3qErf6PvQwTEMW4ChUnFOSFTRFH4.geCdgiVWrVsVCmaFnAT98qK
172	  		parent	active	$2a$10$s9SOl.YpYMxQS.P2bMtAgeH2Nfu8Kq6xg0hBA/S7YY2E0zqqJdh7C
173	arthur caleb obeng		student	active	$2a$10$kb22L5LhDDGoLDJfLyjgl.DBnQSvX25SZJmeSRAUQSdoJuxuD2ibC
174	 arthur mary		parent	active	$2a$10$L7E.JDNu4W3Yjn1LkESqqOm4YZYCzSA5LgVo/Rb9oMZtaS5JkebhC
175	 obeng arthur benjamin		parent	active	$2a$10$8GQvixlgqXIsnLGRcGskEOgTOJR.yUvY9M6Ss5oCJDUgrglth948K
176	arkoful jonathan mensah		student	active	$2a$10$Yt/oDvpoxlKi/19EynuHL.C30GP.Ye0np2wo6fE21jhPx6fm2g13m
177	 mensah sophia		parent	active	$2a$10$DbueBIIaHTdWSGioSxLIPuxXdtDFP5oZXYESZoQI7tjnxuO8BlMRW
178	 mensah samuel		parent	active	$2a$10$1lWzw7cFl1T9Pq5dcmvb/e1z/7g50lPgfFzkgGC8W71TUTzkAiAcy
179	abbiw marisabel 		student	active	$2a$10$CZQ.Vua4M8Or.8LCIyhR9e25r7GtWBjfvGPhhTk26dqFmJsRWdiNS
180	 abbiw ceclia		parent	active	$2a$10$/v1meI0ZB.L.yz9jmX4.kOOa6umoK1NwLKUpoO.DepykQ5oqXXUWi
181	  		parent	active	$2a$10$1bcDuVBUdHQ3bTuetilN1eSLQ3eYpmHU1Z/GX6kQYARsCBKclippi
182	akey wisdom angel		student	active	$2a$10$x.8RzLNZaTFXdHpgs8FKpO0Xk72mRjk91HSmAl3a34sFe1FPJd0V2
183	 wilson susana		parent	active	$2a$10$CdHDwA2kb6R8TjlJM5kQbuAx04AT3M.gqLCKJox7RKad7ShJjF09W
184	  		parent	active	$2a$10$d5oQ9cTH9aYPt1Fh.oamw.EUhfkHL4sJLpxHY/s3cOcQW96oTd1mq
185	amoh ayeyi koomson		student	active	$2a$10$oNuG5IDU39gE3nzRa.40Seezmt.ubeA0mMOPqNOseKLx1BDQNAcCe
186	 amoh elizabeth		parent	active	$2a$10$I52pEbnpR62RQWW8sFJtQujfl3pZIp8nepUzB8t85UpXf8qnw4Noi
187	  		parent	active	$2a$10$VvNpSNM7vHy9k8Sxz6htI.u4nXCxysmZovu7iAfuZ9i1eAZA1chae
188	mensah lesley 		student	active	$2a$10$poUFxgY72P1IGXQRc2BW7eDT0YZo3sTRcqPp1y2zvx98DrAQiH7Dm
189	 mensah eric		parent	active	$2a$10$42OkwsFZyU8kGRgESRMOfewnhZ8hN5XC4OoWiww.wUm.fyZN2BA0C
190	 rockson elizabeth		parent	active	$2a$10$M86lTcXxPGyzXb5xDA3Ao.Y3uH2gOXVWFZ0QSFnh2w0kaZoG91X66
191	appiah rosalinda nhyira		student	active	$2a$10$DisBZkReTpHPbQWITr0UNOxChFpHM0u/VaOV3SCj2DVYwQUh3nIly
192	 appiah christopher		parent	active	$2a$10$xf33QWPgKai09Ch7lY1Sj.gK4gOQ3Z9tJcVqiGZwUwKK3qKaTNem2
193	  		parent	active	$2a$10$evHwaZ0XweGVSL1XMbTt1eoHsWjVtqi4x6qn0xnwUOdJtd71UcTpi
194	asumaning kelvin 		student	active	$2a$10$C0wpbRtBSXNIiGUFyfLAaeOrApi3teyqtvEXf3FAE8Fy0lb1.E7Lq
195	 asumaning hannah		parent	active	$2a$10$ADDo6wbMVGn7s6M2AaNJguPfhG4YRwI3N7EAnNCc227iFj8lI04Nu
196	 asumaning samuel		parent	active	$2a$10$4sJKhguFt9kOqgJaN1KJoeS/w2r22DlRUEdhw0gHubUbGwakq.mvq
197	annan fredrick 		student	active	$2a$10$VuUM.f0KSi5SaWZqlMcv7uBljsf.s5QaDLFTF.n5lnHUwDVrYDOGe
198	 caiquio sandra		parent	active	$2a$10$ScrUVR9MYbX/ooCCAMAxHuXrrwFeaSaE7qshDj6CEKHEylqMC1aYC
199	  		parent	active	$2a$10$pBkD0NMSfKZsDt.UZ.OvyOBMAF9m/KgBvAe8o.2F6XA61mjtdO.1m
200	mensah reuben 		student	active	$2a$10$xG2OZCAJYJT2e9aoTamuZe.5luIoEBAXUqqy7dHuJ3yV3rApl1FM2
201	 mensah reuben		parent	active	$2a$10$pVgaS92GHvF0FoCJu3kXV.GSbJUYxM72iCX7RX.nJ.jo0BalG2fzi
202	 adentwi sarah		parent	active	$2a$10$A0kGOxYzL1H2YoBW8l26SO8wnFpHC/BanWtKwOvqKMEqITRG5VWRa
203	bampeo dorothy ohenewa nkoly		student	active	$2a$10$nDf36f7qS10N9iYbM7Z9Pe4GYf2C40gsbcjGK2lqg2nEzkz6t6gUm
204	 essieku gifty		parent	active	$2a$10$Xu3F5IGytlqvBPAfYcSQjuPP33B92g/9frgVOC58oVi3t8SZ7ABQG
205	  		parent	active	$2a$10$7AIyVxGWYKqWgsv0CzAnseSTIoztRhznnAq2THJa8lhV1b/WOwUv6
206	eturuw christopher 		student	active	$2a$10$Pj/ppnuXYQOHBvotSsosfugDqVL.MnDso/xFkbv.7t2B1y6tEP4.m
207	 pantsil elizabeth		parent	active	$2a$10$eusBivaoyAPWVjrMgcNWA..pnlU89yEvnnq.11W9OdieKmtzaS0Yi
208	 eturuw gilbert		parent	active	$2a$10$aLH2b3T2QdeErDrEo69mz.ObslHWfFLe5Is7ts9XJutZn8POkSNAO
209	dotse desmond sena		student	active	$2a$10$UPKPvi/qY1Mm3jSUBuXKTOWgTox.Ibi3UcVhiaY1/CXNjIHKxCTza
210	 nukunor francisa		parent	active	$2a$10$hqCJnrqRgW8f4EdVbPNiY.eTy420s4qZMH.DpVSL3f6nwR6sEUU3a
211	  		parent	active	$2a$10$DgBP8z7GWUEdLtECgYWbV.FM4Jb2rklK35xUY9o.ZQItkpTd7wmNm
212	opare samuel 		student	active	$2a$10$rdc98cuMOy90JcxE2JY0Ke16OfLotnUVL6LkZO4ICofhw41XDryja
213	 opare mary		parent	active	$2a$10$Qpxk7rz6yQAvr//Ytvi0yeC4AMg2Xj2EkUnPnmwFCoDsUtJnu8SIS
214	 opare emmanuel		parent	active	$2a$10$LIjO6KFiY80xbw3Jgs9QduteTYffUwHbVDRJgrR/3YgST/ck/1NmW
215	bondzie blessing badu		student	active	$2a$10$llk.EWL/htaeU624pH8ZpePPDAppiEzhDTq8reCdUdwDixTPiCyI.
216	 dadzie comfort		parent	active	$2a$10$.kZnhSunJweQs.jgQsenZOVHV8c8RqBz4tcsk2cvIj/7b4sRH9Wbe
217	  		parent	active	$2a$10$Z7rIYB2iS8Zc/vvI3QTh1.dSd8Pq3Bz1ZvZ/NNyKkaqEMIcvKZjh.
218	amakye donnavan nhyira		student	active	$2a$10$j0fpH0z6dYMgNzHPpVHuM.hrVqEIF1wY6F/JvblkiCf6X4N3j08kO
219	 ackon linda		parent	active	$2a$10$gZwvOjXRJmqUk1JntgUvLeqKHkR.20FqGhjfS36tCo3lm1omPMqEu
220	  		parent	active	$2a$10$40fJS.Tlr6hQK/ku6P2LOuFcTvujg0V9G6y1YBwWe1W1F7MtGMexO
221	oppong - willington lucky 		student	active	$2a$10$HGSP985J/cvtWqqWS.0W9u9rUNWGD.I4CLkMYZKfJicsDeIgTeYZm
222	 oppong joseph		parent	active	$2a$10$4eH8DH8Mo68iq8OW3sBZVejXs/ZqmY/6G3gG.aUBbV4D4wdnJxWHa
223	 oppong rita		parent	active	$2a$10$MpWQZEip07p38nNx30Xrm.G/7z5DFhoNLU6OZE1ipKi0V7c69gbJi
224	okai shahadat 		student	active	$2a$10$CvkxLqsRq6.Qa.DSsoiKU.j7sXvMaMQ/S9PScjuS36jzdyVvHFITu
225	 nayal hawa		parent	active	$2a$10$Ovn3bAGUF/eIPwlIEyD6K.TF/EQf/X8i1pm28UgMWz9P23VPoYDui
226	 okai nayal		parent	active	$2a$10$QZHD130/ai9/mc9n3b5qGuiiN8RE4qsuw8n5XUVstt/COWbGDgi3G
227	komedzie blessing 		student	active	$2a$10$risEdGL/jNvA9uYqqWqw4uSHI1tx/Cq97tOudtv8x2VifRFX65dOu
228	 komedzie justice		parent	active	$2a$10$hkv2zBfbqFngrAozA7GlcetwaN.aZ/YVjzI6Dxk2la/KCjn3FrAme
229	  		parent	active	$2a$10$iy.Hic4eO4NmSeuk6Dmg1.RepCBZNyGbPWuW82B/8lbZnPp1L2Pq6
230	sylvia otoo 		student	active	$2a$10$l/6vYDrtDWh4k9qDDcp6P.54apbDxazddXhxJJ5QJWLA0XmkoSFQ.
231	 otoo francis		parent	active	$2a$10$iZpExQIEW/ng6Sc1TLKA6uBkYY1iABPVSTatLWwR5pGKZKb6.axSe
232	 awotwe janet		parent	active	$2a$10$.i1QmcZ0AD2y4V5iVnc25.MFoESXUVKHX6p15DehDkRw2FA2H7Ux.
233	amissah kwame 		student	active	$2a$10$BdVF.NKmClXohpWWt8szV.VsfCmLGylYFMhpQ.em3XXsb7Nq7Qjc6
234	 amissah veronica		parent	active	$2a$10$trx5xqpo.64.OhBgGRo6IOFFn/hnwGXTMYdLf1szIpP2r9iOxQ7kG
235	  		parent	active	$2a$10$N8CJKfaqBGI9w8RMwFAkXefOjWvh2lLVcMJ7PMMCvDV5/snVU9aa.
236	nyani elvis 		student	active	$2a$10$u99plbnbNgj..rb2ldSIbOEohIz.sTzUCTCfG1nY1lzLjvQ888.fa
237	 acquah alice		parent	active	$2a$10$KXLOvx7shVZxFEJUJ1nyxeH6/Ou2tpjcp2csoW4x.mf.uyB9alurG
238	 acquah alice		parent	active	$2a$10$pWB1IUXMlEgB1XNKHBt9NeBc4Z9cPFTMYRS1umHNclY8op/dD6q2m
239	abekah justina 		student	active	$2a$10$fWarvAzSKzAtH3fNrQ08Iu2Z6JrMLKdShixvVScRsWWUMQFCbRNGy
240	 abekah ekow		parent	active	$2a$10$dJJG0a.wj8NiecieBi0ZiObDUYkKiO0zhpEkUj3cqGlX22D2sujz6
241	 asare philomina		parent	active	$2a$10$Q4oJZcrvMq9hRCp1Pzby4OjEZSZeWP3C86M8sKXUm9zKTxAuNivMC
242	arkorful micheal 		student	active	$2a$10$eJuwLKoiOPIFudwj9dGrdOzojfyonEL82l/EefbFx.JGB1ctf8sTC
243	 arkom mercy		parent	active	$2a$10$XsqAQyxy5mWlnr/8/7Abi.4zsOmXEsKq2IN4M/AD1MxEWIDup6dLi
244	  		parent	active	$2a$10$tCuox20.xo5ZcmbEabntF.SVuamiJ4imXOhm3VBwhn9sWz.vHGQva
245	etey mercy 		student	active	$2a$10$IceE4M5YnSSPQa4H7rjFF.TDMJDB1Cy.7DwQvfveUfnMacFjaPd.W
246	 aidoo mary		parent	active	$2a$10$8N.KxE/Upa8J461NsfxcqOWlRMsqPEgxRH3VpOAUuEM3eddKV4EnW
247	  		parent	active	$2a$10$DGfXXwvryAzYZc/g0zm1fuYeoKgDO/NJBoKEMMrI8Xs0K5InsM1Dm
248	andoj jude oboh		student	active	$2a$10$fBSfIMt.3e8jAqFVumU3eeLOCOjt9nUjaPX4BQ.MW5j0H0bnTb7sm
249	 appiah rita		parent	active	$2a$10$zgqyC6Aazp0Bq7at1Cj5Eesm9L.NED2CVET9gbUfb57aZEm6XF1SW
250	  		parent	active	$2a$10$eoNyReGqVxHdB1WxiGRKCuXCSYU6MFIt2vLVV90t2A2REi1kTg40u
251	asare esther duffie		student	active	$2a$10$mAhNCrfmP4WSGfSM5dx2zeJ4s9sEveyoWBYrJmRg2nJtCV9UnAtgS
252	 asare eugene		parent	active	$2a$10$JCdRma/bLzKInWrfUcCiJuVg9xXZMk2Zn5Ni0ihZwefW4Fv2EXfp2
253	 asare sarah		parent	active	$2a$10$XfFdaiGNACet8gkGErPtBuf14/pua8TXO5KvDTHdqVpEyKu3DB4ti
254	baffoe amoaning francis kojo twum		student	active	$2a$10$Lr.NdjbvE/MzdWb4aeV10umdnCxc5PbnGgTR0PhXKOELQtUwTGjm6
255	 baffoe jude		parent	active	$2a$10$sEAAozn8SjtnLrfUdJgyNuv1F2AtqBRl.55/IMjK.lTb1PRC7vJ7e
256	  		parent	active	$2a$10$Smo2iq8.hYlsZZDvx/haFuwN3vnAJtlt6..K.o1mpJpnAAntgl.DC
257	opare emmanulla 		student	active	$2a$10$6ftoU.3ykUFsMU4REGLaSeL.LuDP/mNwfMNYwTVCREle3Bv9LqR3C
258	 opare mary ansah		parent	active	$2a$10$U/kay/N4/PVfcB2dcI2nGeQDzhe9jUI7NibRc29X2IqXH5hWkhvpu
259	  		parent	active	$2a$10$.ZQ3hgN7AItWluVLD049yetsl0jozrZBpSY/fzgkaH.B0PtBgrAv.
260	annor ezekiel adjie		student	active	$2a$10$zcHyiPL0QKSpSamlx2yzDuqKDmlf6d6Di98kF6gflnN7EqHvtClni
261	 obossu harriet		parent	active	$2a$10$RLmW3dCWU5DMN2/hIBiTauwa/OagOiJPNdvFvF29RagvSHbTlFSau
262	  0		parent	active	$2a$10$HEWgBghyWSbL1yhKA0z9uunFVpAvldX/THLGB9TJFXSO9CR8ScgWG
263	dick ellis mozu		student	active	$2a$10$C6TF3Ooy77/pUlM8o6J4fu49AFUBc/qxK1O8EFuJh1/27MHg0.qrm
264	 quartey sarah		parent	active	$2a$10$2d0reTVZV8TbcFkpnKIoweS8oKxxaBiOrunmioahanmCldPXj/3Fq
265	  		parent	active	$2a$10$eLOuNrvL.jZEn4c2QG1Lxu53PTm43vz2rDE7D7dBwotROeQypGZuG
266	owusu mends elysha 		student	active	$2a$10$6vakk31g4w6HVWNgHZS02.GESiTwO1/pQoSbIR.rMauZejJ6REWqW
267	 owusu mends benjamin		parent	active	$2a$10$gYgt9EZPMg/7GNzW/RsKz.WbMByd/nlWlA3jxe7N5brTDOeQQh0Hu
268	  		parent	active	$2a$10$KyIbIindnuM/6p0svhe/WOmo27vzFoB94IbOQ.PghwSwBDlv857Cy
269	amenuvor regina 		student	active	$2a$10$zGqxCvFLkdi7SjNhWeHanOEfv6MAG4A0fWsp5sNZ.JlBMRsIjfk1y
270	 amenuvor millicent		parent	active	$2a$10$NiYyRg1vuoImIOx4rLteLO2xjCGBGip9H./55VZuVzmmGfSUcHMbC
271	  0		parent	active	$2a$10$JzWHDHp9.XXBLT93b1xnN.3gywbqA8SucLWYKwTURFlcYU2DEyVv6
272	owoo solomon 		student	active	$2a$10$oqFSITY3jqWoanIPvKfn2uevOVIOpQTRFSadBIYkvV7R.ks2qSpgC
273	 owoo gladys		parent	active	$2a$10$2BdNbnV9uZftUwsSYlDI9OSk1Dk8rf/KDjqVcqK5jMvQDZIJhrKlW
274	  		parent	active	$2a$10$.AFDQjCIkN5T6pn0mgiau.mRvYEZ2fYJzWzhhbZukMeQBKkBSCpT2
275	yamoah micheal adom		student	active	$2a$10$hUNEtLb8.mE.i0Je6Lmq5Oi6fUBww7sQ.s6NJCfnX5jP2qJ6HD9ja
276	 plange anna		parent	active	$2a$10$lQqunIf0jkyvdEzunBIAkeMyZTYhQP8sH7Wwxet8LjMOF5iS4bFnG
277	  		parent	active	$2a$10$SVXMS/P/pru4Yur/iN.6WOcfROS15xUUUtxn0APxAM1p07elszCE.
278	arhin godfred 		student	active	$2a$10$xZ5VgOqvSqCjFnvYGZHhzuaJoWmytvEHZu1h1PoWvokFaYXFfpqSa
279	 afedzi john		parent	active	$2a$10$FJCsBvtbWxL868SdUc5qv.ECqmHAiYfUqtfZGLXxPotp7G3Huxr2K
280	  		parent	active	$2a$10$zWkfjc2fx.vD0RcWj9gJi.sahLEahupbbLKFCBh6UBlJhiWPx8LGm
281	eyiah-mensah joseph 		student	active	$2a$10$.dpBLF5SQjjdNu6woetdvOPE/pG693cPRKs781bU1fh7h5I54IPd.
282	 essandoh elizabeth		parent	active	$2a$10$eK21SCPKi2FEFUznftp0n.7RquCvr2FmKyOcflZhLN8wlXtbaTTeO
283	  		parent	active	$2a$10$HLQoJjiF9ofrDJgKy013gezbX3jAjm.Nlvds6BGqaCH.QS4kpI4oa
284	arhin eric sackey		student	active	$2a$10$l0BUJjc0fb84.DfsBUV2E.WLundH8yn49tPPaLLYdkXAe681FmjOe
285	 sarkey joana		parent	active	$2a$10$AEHU2KRcheZi7UrgyPypL.YA1x1v9ecxOu0Vwn3H9oLzgM5EbB9ki
286	  		parent	active	$2a$10$4zp7.xrjOyyDVsc6W7TigeIqblrmT6QXjxjHBlasznlLOSne2BAiC
287	forson euodia abena		student	active	$2a$10$cXbEg.CeVMUt5ma0mOUa.O5B6l8p4wLEsGz5zn0iBYpfVTSTHe2bi
288	 mensah ruth		parent	active	$2a$10$91n6z3AsOPDd24tDhzpoueIX1BKljZH4rftP8yVen/U24hVGYifIW
289	 forson dennis		parent	active	$2a$10$ajlq2cW4HNd0bVeiWiWZ6.TzfSiqUmCkrutdP0kJDCagujHPN.uEW
290	nyame gloria 		student	active	$2a$10$9wC1R5hmGveEpLpi95D.UuWM1CEFEWxcTPn9QmbNXQ9wGdu9hPt1i
291	 nyame edward		parent	active	$2a$10$omuFr/3VuGNC7GylVYG4Ae/kFhja/tYIBV72mDoTXFIMrlY3gL6Ye
292	 nyame justina		parent	active	$2a$10$FU0u.fMgS4zaxDPlMNJHH.NrtKGirfzNOtZILNHvGB3bakddb2MlC
293	otwey kayleb clyde		student	active	$2a$10$/a08hLAqEZNTMGpgUq/cwOmU1jeWppad17h6LZS6ggKPv/sxjKDom
294	 otwey deborah		parent	active	$2a$10$7/akzG0Vs8TlrfI6fPoIX.91pWBFbv1/FdfJuC9FTID/.p53PR1hq
295	 otwey isaac		parent	active	$2a$10$dYdQLj.bu5NV2Sb3KzW9BO7Q/I9o4ZTrpgJaHniC5CSECgeoLLc/.
296	abaah doris 		student	active	$2a$10$E0VKCFQ78ukb8wEKsdZAxOf/ovGFq7N7bbJvxwH5/d.qdRHSYmpn6
297	 abekah sandra		parent	active	$2a$10$VaX9l2b9sD5wYyOESM4lHu1i3XGyHmOgc3ynJX/mBLhc5xQ1Shysa
298	  		parent	active	$2a$10$vbWF5Myx3OnBXdUfR5aewexNyNTDWHYO6czfKb1nlYV/O0Wkw7Gcu
299	sam sylvia 		student	active	$2a$10$V14rmbt7WmZfK1HyWg6I8.7QhWruXm.sYJqvCDtr78Y6CafV9KDJS
300	 sam agnes		parent	active	$2a$10$orNQOOBGYpIC9keJ4pxJgOpWBwkyNgmC.yNTjxRmUD5zfMGBaTW.S
301	  		parent	active	$2a$10$kR0Sda8WLkvkVLdYnk.DCOG7I1mQ1itZhKbIt3Szb7HZsESKy01q6
302	arthur clement 		student	active	$2a$10$mmoLaMm6E1c1/hEFkAMNH.8h7xVQVquVBZondUA8J0YZsB11BK4xi
303	 arthur john		parent	active	$2a$10$w5sXkNfuG3G1Tekn9xnrS.j5nqXyHfClFJOmrCYrcrNDyZ2uKeTEe
304	  		parent	active	$2a$10$LO.basOahOF3Ce.wf/DeUuGaCHjqQWEAn9aXykfy/bw1LVQQKrn.C
305	tawiah emmanuel paa		student	active	$2a$10$ukHPpBpcXVFpaZWNw6AyROmPhCAVLuGsWCDNPa5wbJx4OXBhgCzii
306	 tawiah funny		parent	active	$2a$10$7ZeNRd7X/xG96KOOMCg28OfrJmhrtiFexVq9xLWXNPqIubGyHA3SC
307	 tawiah eric		parent	active	$2a$10$8lPZFu7FYldAry8ZTlyk9.c/j12KwBxa.v8kgBV.4/iQaWeI7YjkS
308	odoom mena aba dede		student	active	$2a$10$yajCXZTh/0eU.JgvCGRMsONY9Ddd8FVLzhSZHCNF6jrBca0ZniTTC
309	 donkoh theresah		parent	active	$2a$10$P8pXKVKqj4ERJ6VE9qxQCOnRUAn5RBSVH/G6.FUMqGV9I64ryngsS
310	 odoom kwame		parent	active	$2a$10$CqnPiXegdl2Nlf0hJ3Q2BOHHwVKPj5ugqTSKUsIEJgSg.SdsBwbkS
311	quaye eva 		student	active	$2a$10$AdY5IuwibFpIXs7oyCCuCuIoIe8uvF18Dgvg9GttzVay9EjprbRy6
312	 bentum sarah		parent	active	$2a$10$9VIvotqy0WSVkMI5KRuLAej8y8ibdX4pCRkZoc/jb1axpNpsxuOq6
313	  		parent	active	$2a$10$QKIKsj6KOdsRd1Ugkwtw5.sdNwr41YZCtt5YB3ZyKxNolSMwlFkWe
314	ayensu reymolf obiri		student	active	$2a$10$hZAoDAvilz4hOzNK5UfN2uQAi17eIfHsNO6MVi/t8IfFGEomhVtvG
315	 otsiwah albeta		parent	active	$2a$10$Mx7rGuNe0cLAp4aTo4bKa.r/CQEnTXg5QZuW/Mld4kcW5nsyvPtJu
316	  		parent	active	$2a$10$kkfamVb3MVgQhvrU0jlLguOhILZiNV6VBOIG7JDPb7cD.XEkB7aVC
317	yankson dennis paa kojo		student	active	$2a$10$4044dDTCQsXivqlUTJ1YHejX.5.sE9YjqdfyPc2SQTCP6MC/wfubu
318	 afful abigail		parent	active	$2a$10$O0Jhe4tbfe4FyYD.ChvaEu7JMmv5KraTGAkxnHIzRdvEmBFU9L7Tm
319	 yankson samuel		parent	active	$2a$10$PjFE.0qrdWKLJSqGu/0ZHO9SSft1FxJGSEgV0X.fStJtbx5hT/tO6
320	botwey james esaako		student	active	$2a$10$JYXttR6WGJHns.8d6.5fOOOUy8SrsImXgQS6RJisTzjO3iqVLMAoa
321	 botwey john		parent	active	$2a$10$DSDL0HuzOOrlS0X2c47NzuC2A3qXd2WfOgA4fSVWE51HSJ3C.zJ6m
322	  		parent	active	$2a$10$Gi5YYITy.9DISKLpH.knFePs2KFPxRgNkPsm.p/wH2s6C3FtGABxi
323	mensah peter 		student	active	$2a$10$PuWFCs62pul3Yv0WmphdEeL5FfehpBvQwqnEIAXUIxkOa4m76crTi
324	 koomson joseph		parent	active	$2a$10$DdlQgO2fffjXg9iKTdawUOuhA/r6jFSldZ7p7g6nNen7QwWMXlN8.
325	 bondzie miriam		parent	active	$2a$10$DKv8zN6bvE7/goeVBbtce.YkhC6Hnhnx5v3tCBtnghw6uamCvo.We
326	gyesi nana obeng		student	active	$2a$10$YcfvJ6HQxA/XK1Mz.xzH7ey8SeGW/EcU6mGUqy/3wBQTf/mA6vNwu
327	 gyesi robert		parent	active	$2a$10$hKnvWjr4fQQ/fAPddQ9ZLuJNQEI9EbueSbWdUDlCSlHcGIfrLY3R6
328	  		parent	active	$2a$10$EgSePXW/qH6UtsqiAK.hfe3N5ynejOUq83shhkM.1Fzx32CXON1Ym
329	pelmiitey michelle akosua		student	active	$2a$10$cC8fbCc65v2OkVLjAvNmv.4vWxiM8.yup9q2e1riqTWM1ptiAolhu
330	 pelmiitey mathias		parent	active	$2a$10$7gn.MjZbs8giVJhYqXusIeoZk46AClGFerQzN7IjviCJWuotNVuby
331	 pelmiitey vida		parent	active	$2a$10$EoCsfEpTevhKOXWbH.35Q.batxPA9gTazwKXIFUsayMpzIdSQ6J46
332	quansah bright 		student	active	$2a$10$E3J8CxLf0AFeb/hDvdu8puR4NG8sE9L00aO1gF/U0bO5QzsZ8a1va
333	 sarsah gifty		parent	active	$2a$10$8fvTNMMVppAumksYDzoTde675PWs86fd7Ha4kCG36D3o1HrQFzPzO
334	  		parent	active	$2a$10$.LP1xbtK8uRb1Ni0zdI5.elp8g2f/fqeSryY/L5yJWY/DGhFbj4K.
335	abekah stephen yeboah		student	active	$2a$10$9GwGR2w33aLVOzV6OHPEVuALMGDphjoRrVx0snc9GD58mM43hDWDq
336	 abekah christiana		parent	active	$2a$10$Xiqvx8B4tU3duL3wcAGyp.OczCL.0Azp6Ho3BgRzAp8PVzE6Gfj02
337	 abekah james		parent	active	$2a$10$FZIKz7PPdyV6vP3JHGXh7ez/XNiD3CriZIKcaUgaSH2q4T02MbOxW
338	nyarkoh blessing 		student	active	$2a$10$AX8PJ/7B3YhPExyh7VnBuO4.n95RHc3tB.gcyEVY4zfG7u2ro6qQu
339	 otabil diana		parent	active	$2a$10$B0ntF2iTq8fimRHB0ffdM.RxErFarVYlk7nyqBrVo2xYrW2KOo7NW
340	 nyarkoh paul		parent	active	$2a$10$vKWHjta.evCfBR0verbQLujKqQCxunzxrHwdOD5.7pz0HsFF/Ggya
341	afful nicholas fiifi		student	active	$2a$10$7kC0wxi/sls41OzIIJJhKuyCun1MUvAFhsNKsJ36gHR.IUNTAuWgq
342	 tetteh priscilla		parent	active	$2a$10$xvxdfBct7wVO59gFcD5BWup0VzNZLHc97MNsXGAS0yh.oNStruYFi
343	  		parent	active	$2a$10$CbJZA0V7FsKk7t2eV6Aak.AuqnrHjXg3rZzjKMeh5bNaxqhetLJgG
344	appiah jason baafi		student	active	$2a$10$PGoww9JO1VsacqEoI1v/..DNmgLE9ebzBx5/8tH1C07aXkqhp5LsG
345	 owusu esther dufie		parent	active	$2a$10$Xvrnu1TiMBqY0dnT1uEahONOVr4S7xZbh8Bl799DPXbApe7.LX//y
346	 appiah david		parent	active	$2a$10$trv0mdU3tUBbLgKFaVdpE.1O/JhzJEWw.YGdAgxBzpGItVZ9Qr9aq
347	afful christian 		student	active	$2a$10$zjFAZehU8/h3lWU6X1NHzu0CPa.VoBaHkNlQQA4mxECRSqeaSrR6q
348	 annan grace		parent	active	$2a$10$4Rr6VIwh8mr3HOowB7w2/u5xmYL6eV5OVuvt.8J4Uc7ag/0JLsHbG
349	 afful joseph		parent	active	$2a$10$aVgAdKXM30jZgo7BjDaMy.NL.Kf0SHCOCY11I1g9PP9FXY8pNf//C
350	asare raphael lartey quaye argee		student	active	$2a$10$6EJcWjnXC4sxNip2UIUlEOShV5UoDGh2teGBayST9cPnmGIYk0fJC
351	 akua asare theresah		parent	active	$2a$10$ZO7uKCsgOBSe9pqAcgiCeOhes6wuHMxNTmpgOM.kL6HyW1cCmkgo.
352	 asare frank		parent	active	$2a$10$e96Aoc192nm.rm2gIva4Y../oCAW5vPkeRg66q6lvKxVzjhQHwtJy
353	nyavor prince 		student	active	$2a$10$m9riNaeKozzs.8ybXKFyueWwiH9Sd/mKCaKJTZMjxsUwV3I5Wgk3a
354	 nyavor jade		parent	active	$2a$10$bEzXr76w7Q/kfAa/fJVsgOK1hnnX9VQ8wM1xFqq7S.ptg4bFmzwG6
355	 nyavor james		parent	active	$2a$10$z7x8QqiVGvFjJ/klWKYOj.tDqJ/dvZv.k4UYYkXmeB1gFBmEgK/TO
356	awotwe prince kobina		student	active	$2a$10$oSippkwLMQe9F6P9nCgmQ.LfUCwP06Uv7AW2sfz8Hcn4r5KMsZPfa
357	 quaicoe patricia		parent	active	$2a$10$UhvLyO2h3fPuNfV3W14FCeuffsjsFxyQOwOMugSl1K7P.0B/d5OtO
358	 awotwe paul		parent	active	$2a$10$FsYF4yxlyALz74TggsF/bu1XhQjWqEwiJQWb6ItRXcbhspqhnqJha
359	boateng lucy pokuaa		student	active	$2a$10$n5h.qee66tihP/rDtzkCE.1CHEGFNb9uTRowygd2WbHVrV2aE0YEq
360	 adu pastor daniel kwabena		parent	active	$2a$10$DtQ.Mxh5hTCunjHa7huvKeZZZ3.ZTwqyOJrLLhVVQthvPm2x2laQ6
361	 marfo lydia		parent	active	$2a$10$ZkSjQ8jAY4UBiBOdfkqDLuv1i58KCqcyv2I3bpt2Ax0to4oxxXZfS
362	akyere enock 		student	active	$2a$10$oGA6S0.ftx9kdtykIIb8meO5a3R1jkx47N0OJ3yZU.aNxNa6N/RzC
363	 mensah selina		parent	active	$2a$10$NTeSBAN2.T1hLuXCVNNs3um8PtmXcSfYQrCkUZfEo/hRaloiShMZW
364	 arthur joesph		parent	active	$2a$10$lypzqrfoaInzg550.rPaSe/mMExkVFC6reTAT2duBxz4BKxk5Broi
365	amissah prosper 		student	active	$2a$10$y/bL7wAFpntJ84GmnsomFeu3cjmjGI0p9USpRjH1Huv1R4fVrLRrC
366	 amissah ernerst		parent	active	$2a$10$8lFHozuQPg8xFWMx8uiLHeOabw4aNgq.HcPoD2P7V2nCc/aGRN9CG
367	 baiden ruth		parent	active	$2a$10$akyfMecIDVKWMKR7PYaY3Osv1mrAOdvrztqjOGT2hTkWsN6q7f0fu
368	bondzie shalom ewusi		student	active	$2a$10$C76dUux6pNkUXDSn2NCdHOm0nV2Z2HpsbF5yVF3nsd5u5Wvvw1bHq
369	 anaman lezebeth		parent	active	$2a$10$EiraKSqVL8D5IqwesmiMiebCxg9w3gFdl3p3HImg7nvv05qaxff0q
370	 ewusi-bondzie emmanuel		parent	active	$2a$10$RMMPFQHE6PfUBVQlNKQB9.eT1l/YES35QI0G8iLZ56Ef6eF4RERjy
371	coly bright 		student	active	$2a$10$kxpjgA6Hvf..dr2mS.KIguwZ09/LtINWF098jONKehwTco0QkGQJm
372	 mensah mabel		parent	active	$2a$10$oeWW5kMTWmpcjvmS6QtLJeR7PbZRVYJcjrx.mv6nAJYl4mfl4BeXi
373	 coly mathias		parent	active	$2a$10$yMdF7cSRnh8N64YY7eJtie/odJ7W7p8PC/.tJGiDVhgOOi2salRH6
374	arhin desmond 		student	active	$2a$10$T34IMF/B5Muy.52uoPa0L.Nbrne6ClGHZlQ2XjrlFVgUrAn6wE7ry
375	 arhin flex		parent	active	$2a$10$ib.6enr9jQ3xImvKMfhnaOHmJySzn8r6P8X0oNqF4LVg.EfeazkvG
376	 bonya cythia		parent	active	$2a$10$7I2B79z8rlTl7mDeh4bo6e1aoWlTK7MKURA2pLPiUjB6ARdMnPNO6
377	aidoo phyllis 		student	active	$2a$10$GftV2nuQ.lSCPMyM0Y6t8esC35Vhqv.4nO3JL1tGrE4JKNZSO97LS
378	 mensah grace		parent	active	$2a$10$w6nh9/xzQE95crAocqsH4u.L9BuilapXDRCci1iLnj/bMAViIhy5y
379	 aidoo justice		parent	active	$2a$10$Z/JWSgpR1B5HVv2Iwe5eZurs0nw71bj1isE/PLAd6Cc3jWxzzjit2
380	amenuvor abigail peace yayra		student	active	$2a$10$9czY9o6A4WgHT7UvObv2.ecEOdTEK8yXPA9VBvmXntP6i33cIabrm
381	 amenuvor emmanuel		parent	active	$2a$10$UnLWJXFVF19j7wb7dUJC9u/1e60O4wL3BnsnnCIlRwHT4oEsPIqCa
382	 amenuvor millicent		parent	active	$2a$10$fWcu/hLWr9QTDsvp.8ZOAOtwul.J0LQksgXzjJWhxDHwV/CVcmOuu
383	dampson nana owusu afriyie		student	active	$2a$10$kfTjDhxrUhyh.1R/EKWP4.osCxSTfq3hY2G5Khf6E0FKlYaeuYx1m
384	 dampson evelyn aba mensima		parent	active	$2a$10$YvpRZq3AXn38wiDynmw7seFGGFjzqg82fGW2bEDC3mLRH/rCdAKpe
385	 essilifie ralaph		parent	active	$2a$10$0zCWbkazGko04CjPgajc4eN8PsdcscwcEgnTAt1KpiY6e8M6dj2Vu
386	boison belinda 		student	active	$2a$10$UmWaJfnDZI03Uj2QHZb0quwOMqHSpieT8fLqCn5RgzOXKg196V.uu
387	 boison linda		parent	active	$2a$10$h6cOOUbTYqQp6Vblx8htxe5L/lGag/SpvMLC/Tk2Zx6Be8Y6SC/86
388	 boison emmanuel		parent	active	$2a$10$mYxtTC8xwkGDCUiot5vcPuoyXWO1X/pRiRdkKRY3HtnvQDiFICcoO
389	egyir praise fiifi		student	active	$2a$10$Yr1/i/NeMP4wqK7.VI52puWC9djUAlkydS0xBSFdXbGD2VNFHrZJa
390	 ewura esi donkor bernice		parent	active	$2a$10$2cLMEpryabnyn0hR6FYXuugM0CtfmC9gLg0A3qn8d0ReI8II.hiUO
391	 egyir emmanuel		parent	active	$2a$10$POFCtFSxNBDsHqMl6rO7NOclsvGwbQub4xSvRJskAazcRapVPFofu
392	essandoh cherubim miracle		student	active	$2a$10$uYMnW7QzPPRKU0PZb2LDduWxQuO7DvEKj1OGvhwK1s2FMP3yVTaS.
393	 efua quansah linda		parent	active	$2a$10$Dsgr6GsMY6eyza1iyCYYUem2eyDxTMs47PILZomeY09j60sCim0jS
394	 fiifi essandoh elder isaac rhema		parent	active	$2a$10$jcUPFiOm/HBYmSnm2IOyouJvJusrh29nh/A.Vg0OhJzU/W5jm.G4m
395	obeng isaac 		student	active	$2a$10$HLdera2czaK/V3rIzC9sLO1mJY5SJ1c.xfiPkJLQhUkthmc.7sNGi
396	 obeng sandra		parent	active	$2a$10$oR7bs0ctchpLtS6R8fMEFOZRSRwFLffBFvZNu6GoWKa5b5XgBSTQO
397	 obeng isaac		parent	active	$2a$10$5P34LgGG8ct221F2ZcHcUe.yjrWq6UfMmDLk.htVCiP3uaYctKBMa
398	arthur eric kofi		student	active	$2a$10$/ZwXv6oV9MiF.vY5ZsxKqO6P4LFlr3RTE2o9EiwdQek67p4Zc2YOu
399	 sam gladys		parent	active	$2a$10$PoN41LOs.yDmlKAuCZm37exZbG/Xhh4oa.XEextQhQkGfvsq6m4kK
400	 ninsin egya kow		parent	active	$2a$10$L7dzb2ZfnZouFUNyQxPkzuQPF8a.nt0UTxxxSps6KKhjqHTt8V09S
401	quaye john 		student	active	$2a$10$t/QB1gQSx6Td1D646LSNvuvBkPeWKFZq015xhBqS3yubBFXcThXnq
402	 oboh quaye mary		parent	active	$2a$10$yLsyo1mLxy/qFbpYNwHK6.iSMLJJGxeNNzdU73wgO.PKXmMOY6XNu
403	 quaye samuel		parent	active	$2a$10$Pl6kBrjc4YNIE5oABS82RetPgIAEXBcyqeEvEHml46TlbHHtdjIEC
404	tetteh clifford 		student	active	$2a$10$XWiDTDCXjujmz9CeTlmyse1WDNu2LPPfektwkOAvBntWN6mMW70si
405	 quaye elizabeth		parent	active	$2a$10$0jbLGyw1W1zb2TCgecf8IetP1jZN.QLbqz28ORyGmdh64/jB1nBvi
406	 tetteh isaac		parent	active	$2a$10$s35JY3GU8RGnCoaOaIrvieg62qL8aFpP1zW86flqr/nOCJohhERJK
407	agbi lordina esinam		student	active	$2a$10$hSHt5tQSSTR70gKrpWPpZOLWQO.fNuF.onRnaZDYqE8CHJgW5psu.
408	 agbi ishmeal		parent	active	$2a$10$X6jfgzL7.OZvBsCZ2yBy3uiLWThP4lRpWCtb6SCeez6LLKE./Ux8.
409	 quansah ernestina		parent	active	$2a$10$.WrSm2pgroNce.rbP1T7LeFHmlyEfZwI8wxnP4aJXhHROYfYlzzFa
410	essuman shadrack andam		student	active	$2a$10$nMXuYH8PUWD55y6db96TvefVaPDLRO4mkDdN5mEJVIy3iI9DVNNWO
411	 acquah selina		parent	active	$2a$10$LODYeUEjOTX/EmFEpLKeauTogRrMHivmeI3PU.iJxd3iU8IO3uJCm
412	 andam nana kweku		parent	active	$2a$10$iXlu6.YGeT98Jt0U3ryhr.W8Gag0uAbsldSVamjq1NdwEa5INL5WO
413	acquaye joana 		student	active	$2a$10$ATt5ckAx.XDnC/.fBuNQsOAOAlkbBdrO3sToQlZdg9xqday63FXbe
414	 odoom rebecca esi		parent	active	$2a$10$L0.dwsceX/6bLPvCMjIiQeeEvYS5Ep9wclEyAW3C6EuAAV2hP0GlK
415	 acquaye francis kobina		parent	active	$2a$10$aqzp04R4g2QqCAgBKkdlYeAYsd0QyogGr79OJsEd0vkfr.34sMrvy
416	brago natalie abena		student	active	$2a$10$TsGZ43PZe5DA.jgZxAVYkuGk8CdSZhaIwEYywNzNCTYpKx4py1XoW
417	 cudjoe lovia		parent	active	$2a$10$Qpk5gHLdakRfThmfa1PhaeSeQ8BAhEhQd/U9V8V0tPnRXjRYbojbi
418	 yorke justice		parent	active	$2a$10$ZMzDuWioeo1DO3BfJGzTqucr1FcLfhOx2cTuXoz6ACFZNsQ7C0UiG
419	essandoh david dominic junior		student	active	$2a$10$OjHcruNrAhdr4gZqlXuBXu/bqauA7PHGZ/opug/8uHxfPCPWoLYYW
420	 essandoh david		parent	active	$2a$10$7yP./RF07mgqcdsm0j7sD.TGVj6LebZbRrx/u8/Lo5kCKbmWzTqGK
421	 tetteh winnfred		parent	active	$2a$10$alobZGBaLJH4NEVS/9wvou8bVRi7jaW8SpzqT6Z25qrFApbsU46uW
422	adentwi blessing amoh		student	active	$2a$10$6dyh0w6C15awJBIWkW2o5.a.1vE1l/dZGAbV.mbggzAI6K9C1Z1PG
423	 baidoo grace		parent	active	$2a$10$YMz0bc4y9bzwz7DfhGZqNeh6CHegA683/CH1G/rcxx6Q/0D6Z7BVu
424	 amoh robert		parent	active	$2a$10$C4ieYtz8BJfrZfvMeuA3Te6Zcwr9KpIVs9yN3otJ7.nr/T.botoJy
425	mensah dorothy 		student	active	$2a$10$PkR9SxfubrP3.MzSwXy/gulq/.QYxhbfL8r1rBRVe3AaWfWQ7JZEu
426	 mensah grace		parent	active	$2a$10$EUK9/wNZBasK.PtLZyQlHuhlwK0DptQLw9Zj6KApCHBcPEcxnUWHW
427	 mensah bismark		parent	active	$2a$10$FCES9k5dM8rmiDQj5PLOROSt2iQg38vhm7ZcsCdpK1Ta1vYvV2iFm
428	ampomah akua 		student	active	$2a$10$O9dALAzKn9OWcU1Q6/jYhOpVhSaByOdRxwWHJt1t/jieCIflb7a1S
429	 adjeibea susuana		parent	active	$2a$10$rO/qatiyUHNoPdHM6dPbUe2O8g3kKEEsGQ4R0z/LJdIIQmBGpjGs.
430	 ampomah amos		parent	active	$2a$10$NcRy0Lw4axJ4OI86akUxa.1XgMVIMqsMlZFEyrnCa6i3OmmXbkJJm
431	andoh faustina 		student	active	$2a$10$cU/t4p7xkM9g7agFFFf3p.08lMDHOC9X2Dps2FSr68FCjaBq/ckT.
432	 yawson abigail		parent	active	$2a$10$.Jj/vY2YTZ4fafnOYfAba.Bw6ybrq5dyn0hwIOK/KtO7NNj9Jy8g6
433	 andoh francis kobina		parent	active	$2a$10$JA6ahBPxkGSFmrmNyUuIZ.A2jvItbH9qQSox41pPeWeAusX0sln/i
434	egyin precious 		student	active	$2a$10$kogSL4HX5dKPQL/eMvP2ROmbQHibGTVqsIVRogAKiCCBDB97CJT0q
435	 eduful stella		parent	active	$2a$10$KR4bqUwyzoSmdMAZnUOsUuABs9KyNX6VvAThhIbcnSjeLqBjTtl1O
436	 egyin kojo		parent	active	$2a$10$wus2fdNURXwFZFKfxQW5pOmGdNiCY4PD6CLXaye/oz.JmP6ciAr/e
437	eyiah-mensah owena 		student	active	$2a$10$Szqy9TB084uXXNzIuJcRruaVA11DfVhFwFt0cPm20ZpsB9ErYEyiy
438	 essandoh elizabath		parent	active	$2a$10$cBOpv/I5mkuRjjMN4ugN8OSWn5K4KxrbKwR86jxCqBaGaoq14lO7i
439	 eyiah-mensah joesph		parent	active	$2a$10$6dCs9hRLHf.nBWPfAWGp8uHZS75T/Y6kvg9ITcx1S296YuLKkRuVy
440	arkorful comfort 		student	active	$2a$10$tENPBInt5ziF8KhGJGmrXelo0ujjnrK5qvjUTYsTnhGfBRrgMNYu.
441	 arkorful emelia		parent	active	$2a$10$Rv8cGNhA9YLfFMmctj3nC.rra1bxfzHCWjv9yn5RPwLJWihfy/SVa
442	 arkorful kojo		parent	active	$2a$10$e46BIui4Bn8Nd2J109tKCO2pS1awqnOO0EODyZcgXC4WwTW9uG9H6
443	baidoo michelle 		student	active	$2a$10$niUzkdqwEykNepjJxPyjwubJHagUT2ojnrqY6ODf3xk5wQky/xyI.
444	 baidoo vida		parent	active	$2a$10$0gy6kOapEp7Cq/1Robb7K.Cfm1DvvQDbY6.dlrwwhCwrvMzfPEKvK
445	 baidoo joseph		parent	active	$2a$10$d0egmsMcCOENVDyDNmi6Y.tQxeYth7CDB5kYH0hIXo82n9tfZY6bK
446	baidoo josephine 		student	active	$2a$10$zQpijFkybkbBUW31rgfKcO2Cgy9lfNm38X8yoM0ZHmnZQQ8htSjpi
447	 tetteh rebecca		parent	active	$2a$10$oke7OEGG2dUSys4yaPPb5.JLekZ.LZbScZP6hidsXb6wAJlbjXzny
448	 baidoo joseph		parent	active	$2a$10$gu1OnHy8SNvOZJp0SSVv8uNqRz7c40I1XJ7Mx7iIAunOkkRui4W16
449	botchwey lordina 		student	active	$2a$10$G10iCfMvlratw8kFa3sUNuxrUNQhp1/DLXs9oCjGBNzP7UWCp5SnC
450	 aidoo rebecca		parent	active	$2a$10$TtSm3LPq1u0f4uar6UoHceqV8F3LeGWHMcURLP1T4Ez/gMYQpvIRC
451	 botchwey pious		parent	active	$2a$10$HVsoO3hGAaqjizX0PUW/8eU6zQ9dTIEdMKtzbwE5x40G5yvt7Evbu
452	buabeng twenewuradze 		student	active	$2a$10$98OiuJFBItYBIwF7Oc.kee7hJp37r8wVCc85UP/s1.DUZKHROXLEK
453	 quansah georgina		parent	active	$2a$10$k19aXAf4KUtvlRJ.bGf5duzQJtGy7u8x4mHcUhXVdcK1rkQFoV/vm
454	 quansah georgina		parent	active	$2a$10$raFJQB3pvpeFLsGv6gbG4uxQttStnwrKYqfNzLScfVbeFCYs9X4qm
455	ekwam benita 		student	active	$2a$10$lYbltt.i9tvd.QT5SuYpT.CFGaUCIccZ/zK5sQfHc/EOJEFXg2RBu
456	 ekwam mabel		parent	active	$2a$10$9m8Vp.LGyK3CyOC9eIxaG.E5AmjyVl5RmSrFsU5Qy.Wr8c8iEy8RO
457	 ekwam benjamin		parent	active	$2a$10$krSGXMDwJwLBUXUcxfJShe1ZksNaMaA9zuR3CX7oh0p71eqB0sjmy
458	kaitu aba gyawa		student	active	$2a$10$HLFltqhyP30xUmdNlWjIUep3HhgkE29ZvTdFb7MmoXESgVZ4Mm5Le
459	 kaitu mary		parent	active	$2a$10$VqKzVVZtoe1COji0ro/UvebuCvAhvc0AGHk0Kpv1GP3.pxZpM.Nh2
460	 kaitu stephen kofi		parent	active	$2a$10$agdFzTSIfCS6egWjOUJTSOQRr7PHshyk6cjKllHypDEKhYxTVzAUC
461	abraham davida 		student	active	$2a$10$kYMeQPPmqn.iRMWvCwsq4OaBjcRDSLBSlrlKQLEwx6PMGzu4pqFgm
462	 abraham aunty naa		parent	active	$2a$10$kLqdtlafkWUehi3c5yniSe/7E7rKANQyMpsQqrWMbncrAC8EskMfW
463	  		parent	active	$2a$10$W8LttYmrDlaAE2XTg.kTA.xUyUO.LFa7kckZx4KDHFRjMIF1jw7vW
464	aidoo francess ohenewaa		student	active	$2a$10$.apiGJM0gwxUxvma/JPRbOORmymgy7mMp.l1DmlTSeNeb7iGorO82
465	 aidoo francis		parent	active	$2a$10$BqByK9JcXWtklOz/7IW14.2iGx4IKMiHN9Xckk5/fUMhp2k0HJJo.
466	  		parent	active	$2a$10$ILkoqe83rcA1aNddZJSP3e76BqeibSgiePJlOzJSoG6dYVEBDbPXO
467	quaye vanessa nyira		student	active	$2a$10$sFl4PrKrWF3BmeYR/FHn2ePIkeFef0oUvbH1cMwfjj1qJdEIVkr1C
468	 luomor gifty esi		parent	active	$2a$10$gGaLWHzEHmcREG.VU2iaE.eyXH9B7gJB8RM79Nza31fy5qxR0WJx2
469	 quaye ernest kofi		parent	active	$2a$10$LH5NA0d5OpGytNALLPR/oOD0CvgGTHJFcIsjoXmoOLoPOBqln6jzy
470	amakye isabella enyidah		student	active	$2a$10$i2rC8saM0A.l/0NkAHLdFOn8FhMowQ9f5LfAzdu477B/h1tn1bWA.
471	 essuon esther		parent	active	$2a$10$18IiHMdJKO1imRRaW1k3E.v10q3JvH2/dqvXMOi76.UaFI78KhQay
472	  		parent	active	$2a$10$eqiLEUD783MLlwq493myE.q.Fo37l5UY5zBljv5vj0nyYmZ2VvWGC
473	ofori-atta gity 		student	active	$2a$10$kO2NNrtgeFe7INElv6PYQ.IIwS3QvPc2KEAUp94U1RgknTnQz6DVe
474	 clayman mavis		parent	active	$2a$10$4HVIf1SRaPeVefNf/Ni/5ezgKea2zuCby2OsBpA6d1NXGjy7l/8yW
475	 ofori-atta daniel kwesi		parent	active	$2a$10$RUqUdNwmZM8GlLaSr02RDu/S57Vji9Iwz6rXE2T9R/6IQqOm2AAWC
476	amankwah francisca edem		student	active	$2a$10$7k6fiJOya2S8prRBej4qy.CZFMnK.nDkyYxW1iNGz9vqiYpPGs5Zi
477	 amankwah mathias		parent	active	$2a$10$9YcDyfIeGLfSkw86qT5uJ.yCYPa8KRLFROMjN8oweB4iJJUeBX7Km
478	  		parent	active	$2a$10$THyegVags2jSdonCbkVKz.vTw9hnPt0XEQrUCLoziJKtle3ViEcqu
479	owusu stella adwoa quayeba		student	active	$2a$10$XuosTpnHrOTjanVpAhrTFuhGKHdN/SbDxyVlHSYt3MBvhRC9KArla
480	 essoun esther		parent	active	$2a$10$WjByigca7ipokuQqHw5ygO7Wq9Cnoy0bP1HxE.WDa8mBzmUQokdcq
481	 owusu emmanuel		parent	active	$2a$10$qVxQzNJlg8dZTfyHV38Z2efU.nam.dThsUcn/UNZbrOHSSB5WWPs.
482	appretse augustina 		student	active	$2a$10$u/fv9t0P7ZDCIsyKXJmy2uNZ5Q.vTOOE/Urw2smBIsgIcQMAiQirC
483	 adams georgina		parent	active	$2a$10$.UOTwn29.pnst8zTDRkeXuQv5udD2lUfxrMFaYk1j3azwlWdSZ726
484	  		parent	active	$2a$10$dotQ3dhRmsv3PN3XeebGBuNpcB1TnFx4BlwjALOhxv6OomoC6wu1.
485	otoo hannah 		student	active	$2a$10$tKqlAeZcLxxIYbPrdHU.peQ1OSBIVMMeu01JrpYu6FGe6UIsLrXOy
486	 appiah dorothy		parent	active	$2a$10$iPy2SQNYO5CI8MWvHhwWT.cNIe1ebIlQWJ3dInCMW2JhgwKxw/Q16
487	 otoo emmanuel		parent	active	$2a$10$JugyNEGMMbw0hg507iNzCe87WWksODBYd.RdCntP3IVf2P/NNWbcW
488	arkorful nancy 		student	active	$2a$10$cPVW4skE3e9OUsfieiJPI.6UtCX.TkmbSbZajwDlB/t7PRTmPELBO
489	 armah elizabeth		parent	active	$2a$10$YSZmUSwrGwFCusnxDQYNeeoUKyzXtR5fucYiv72dB/szdnE0o/z/q
490	  		parent	active	$2a$10$zBvu8qDqNSeoOcGFn3OMReeOZihUkqXdIxdUw0oyA4MAdkhFqABHi
491	martey yvette okoe		student	active	$2a$10$a6/mFbn5AP3kdnuXz5OAeembcOkY1dd9KbceuZK70agv3DfbXX6Be
492	 siripi margaret		parent	active	$2a$10$xMWyolZRC0fcy25TI8CCGeUpOWCS.EkS6DbdQEMafGSenmQYjxH4m
493	 okoe martey ernest		parent	active	$2a$10$U236GP2OUaWk32WX9byj6.2hzX4mbc4ZK2B8pE0yx90cjaohGDqKK
494	blankson alexandra wurodwah		student	active	$2a$10$xVd1qQoSVbn5gjNuZ3SKo.PkdWeL4rI.7OYw1AjiZHtikBfV80S32
495	 dadzie mary		parent	active	$2a$10$LrFQmph.PzCJtvgCs7ZazuRp5J7xiKoob8GPq/HrLoN4p.mkgp2wW
496	  		parent	active	$2a$10$oC0wRw/UeaNHAHpDgn95AO5YwfnAzKVsereEIFhlGNBYNMeuLXYD6
497	prince donkor 		teaching staff	active	$2a$10$GKsoV/wt2DwEjfuu7FJPa.nGb8gWDF6QsE5Uv2sWCS2nxDJ2rxv1C
498	botchwey naomi 		student	active	$2a$10$4NFpEUbA51Nf4PXEWtLWvOGOsRHzZn/Gke8sSKJUNMl2AsBqsGNYe
499	 mensah agnes		parent	active	$2a$10$UR0CgOhRUenwuDKY/GwpDeLP3GZfmlVKSpqjlGYyHX47mxntBvtXi
500	  		parent	active	$2a$10$EdBrWhmlL47mCudEgJ0sveIbAuKS1rvHqHtRjGM/xZxqad1lMBD6u
501	ababio jehoaida essilfie		student	active	$2a$10$diZjUYC3.9r8AIHQ6m3y4unJNxfiKlOZOajjk1arZJ5CSMY3IOmgW
502	  olivia		parent	active	$2a$10$uA9vxuwTvzbC0kyot3RAauZZIQFjnhEdAYNRVkvY8bGiJfE2ET09S
503	  		parent	active	$2a$10$x1n5WEQ0LmnAxH1sG/e5F.mbU00TajPO0HjTvmM/juR87OK.jo5Da
504	dadzie nannies abena amanfuah		student	active	$2a$10$bnVBFsSGtCtgohsTfN6vTOJPMgjZeRJT6H9sC70VuqqfRZIdQhGga
505	 amoah florence		parent	active	$2a$10$yUVWsMwGRfZNYqQpxSQcS.S11.pQjCU91CBPYnubqub46Ff6ul.cC
506	  		parent	active	$2a$10$L03MNqpiwxaKikqi.5xObe6OQO.Lbjn8lMepz5jNFWBUq2p45/mPO
507	arkoh damien ebo		student	active	$2a$10$eN7VuPr2NXmKenKTEMOuy.KJS/SynHBdRMCptXyb.ZoprVgdjMqLO
508	 aidoo doris ama		parent	active	$2a$10$vZbUOj9OrodQ./oMfnTr7.Wsjykggn/TyUFrPWCo.UUL49JE60XUW
509	  		parent	active	$2a$10$jdnzbuQNGqHScq4B895UlO5bjtT1EinfI6AgB9R3YPsousy5ENjnS
510	walden maame abba		student	active	$2a$10$m2z0o.Quy6OVgEUfVI0pF.wD4V6IDQ4MBo2g1a/Zgz5KjtCMSHLR6
511	 brown benetta		parent	active	$2a$10$mUcPZkZPvzC4RhGToqBN5.Fz1LsNlFHJWoXoYO/.DOOnXwtsJQPFW
512	  		parent	active	$2a$10$PkykHk7dKjWZS6p3APUi5Oiwf8G2sMggVrQK4qEimlFQvctMqywRS
513	abdul latif amoasi sharzman		student	active	$2a$10$CWOHqYm3fE4LOkxGNg756OCYyV.t0brbtCU/jhqiw.fCHhRY3G1qC
514	 abdul ali		parent	active	$2a$10$5a8.I4EGiLvmcJvDn8DDuOXGjQ8AaIZv/ATnmWFdu.Js9xhBVkLMu
515	  		parent	active	$2a$10$4g0sn0ibPBEW8G5Kcj04e.wPR4hbJb2LZKcyT2oyv1GjEnxOnX60S
516	essuman tina nana esabaa		student	active	$2a$10$3YLR1M/VwItIJ5YVBt06EuK7kxFWGC558VixlIuIvpuQ78gG4X2vG
517	 korsah charity		parent	active	$2a$10$gD.uLGSClInCzESou2FKjuYcPpsTEsAnh86/iiPnh0qouJ8ar13JG
518	  		parent	active	$2a$10$rEtIvqXSWozisDQcN0PdouZM3CytZUhkdzfmMHJVrVwwO6vzutSxu
519	attisey jennifer 		student	active	$2a$10$92UP.nGljX8OX603mKX/feBv6WENQ.3HLK55REnjY6uWyK3/pbeMq
520	 attisey beatrice		parent	active	$2a$10$XvLYKg3ZcLVP89RTY8/07OypAFzf5QWspHssjFAIsI8I2L.tX9OtK
521	 attisey richard attisey		parent	active	$2a$10$QXrs0lTNlLR8oHdmaj4Zguzptyk4lXFL1LMnIUy1DKCBB9/3Jgn3W
522	amissah philippa 		student	active	$2a$10$1zQ3y4sTfH07j.GnBN4Zheo9NC/5LDw5ZtUbANOrnl5dycYAtIOva
523	 arthur comfort		parent	active	$2a$10$IsAgZ4VMcvKsHuwuy6LWveUf1vpXkjO9e/2n2nihR4ohtHGTUhiQe
524	  		parent	active	$2a$10$9qYq6yvBmg5kVkKvufNdLeo/T.CawIsM7/GD6OPhgWG2swgOeV.DG
525	pratt maame esi		student	active	$2a$10$wwRKVWTOUsNSJd7t3Gu74O2EQcf2C89Y1YTr8L0SNQyJDOT9.bDgi
526	 pratt rebecca		parent	active	$2a$10$zcB8gZIKoEsHTSMhKli/0..K/9CFsp9tIDsLIG5o9I9rI4LLgznYq
527	  		parent	active	$2a$10$gBILDF7IGwxhvFpZhLx73.nrOKIU3iBqUIzG8iPEIz02ywEgLayFy
528	mensah goodness adom		student	active	$2a$10$a3rkBE98VHVPyWmbq.tzj.xG9x0bf2WjvdYc3KpRyCVa8gpXcbOtq
529	 mensah sarah		parent	active	$2a$10$CZD6JaJOzDSNYNLgbneaYOuVETVe1cY6IetXpz2/DxOhwJqlhu2oC
530	  		parent	active	$2a$10$c0tqdBvyaHru/Dl0e/P65O5CHDzPMJTTba7.HM9efj8eOJjZ..KDi
531	arthur grace 		student	active	$2a$10$YE6zaiqBdBbOzhA/WXX4CeLXU0qDbei5DDgo2gCCgkVngq6bqpJNu
532	 arthur bridget		parent	active	$2a$10$uLwNERNf92aPApKRe4RGZ.ZcVvcBUO8GjBI9B1b1akw/ljGTCUMjK
533	 0 		parent	active	$2a$10$w4goRxj6cJb6K24bfvob2e6Qhic9PT6p3sPy95ghaKm1L/bOSyeia
534	otoo nana adjoa		student	active	$2a$10$dxwQ42elcSFM532m8.xTl.svPgOQOnuEfSe3LflcVck/Rq3UXbm7u
535	 otoo agnes		parent	active	$2a$10$/FdfJR5H4B0mgCb.6.I.IeeTkiIlO/hEh0XqlNnylPOJdyqeqBjgm
536	  		parent	active	$2a$10$1euqH/ab4h4unuI/HH6.8.WkwNOHtlys1uJBd73TRK8y9sWn4xUNi
537	ansah jayce nana kwabena		student	active	$2a$10$tRxIled8jQPOHQaj0phLDeJyyVVpGH8aycP5//GsA.OAvXJ/Ch3Ba
538	  dufie		parent	active	$2a$10$kjyfzvVZf5Xcyk2.bYvnneY5PmB7bImYMYfLDUqHpTgPLV3dZdxrq
539	  		parent	active	$2a$10$1roaAgH1uVipoJ81ZIGmauUAsW.RpWz4Uy50UL7/.5Hp35Za0TlK6
540	aryee anthoinette naa ody		student	active	$2a$10$nV0MoUwzNWIAFuFalLFcS.GFUpFhy0ggd7V3YCFAz9qkd36DO4qH6
541	 crenstil benedict		parent	active	$2a$10$fEvuh2KmruOx6Cmu4tzlVegp5hqEYNH93Akr.6PvJ4wHPYYwLOpca
542	  		parent	active	$2a$10$TRByigB272/.yBvLICNs3OumEPJpZGF.OzPpIvYuZlS2D50ynxy7u
543	odoom theophilus 		student	active	$2a$10$7E9IeuooqaHcKN8AJW7w2e6n8EMawVK2FJ9MDPm2xvbLyWsosvmR6
544	 odoom richard		parent	active	$2a$10$JsBVQhuxrFIpqqfjX5e8Me3itM/wWiv4D9Vzc1nQd9Qh5idr3.7Se
545	  		parent	active	$2a$10$U03/NWCLDqLT.t0m0rAMhuuKaNkAjAyM2FNfsZwFKAUHBvY3MKLIO
546	sewornu christabel yayra		student	active	$2a$10$80osuIi.aJcEgZ42ew6vGOYrrSIcqxyKMm0gQBZ7J7jJO27USr3NO
547	 avormey cynthia		parent	active	$2a$10$7.NGx7BAJWxUZV5061g10uMwd0Ii09p2jhhdjleq1lQTWglMKfore
548	  		parent	active	$2a$10$sNvr.NpAqfIzl1B11i.We.eWrbrRq9cPNung2j3YdbD0tfCY3yt.i
549	arthur kingsley ato kwamena		student	active	$2a$10$JKYcsxMT3Lme6BKvjeIJ3OwoOjAMdcWs9x4y43V.g6sD6zCQoqSQu
550	  elizabeth		parent	active	$2a$10$xRbmemyFWjSfOWbEoPw3f.BsVl5g3kmvck0aeb4v2bHgS1Cc9P8ly
551	  		parent	active	$2a$10$CWbuOEgCuQjsSovTOu91I.QcZYgj55ey0C1ZaTg0m65QSChgxX28e
552	kukua vasty 		student	active	$2a$10$CNkGLDmu.hP0NUHCwtFbQuvR6Czz6pv6nX7gK7kCTsZUfRpf5ps8q
553	 mensah sett		parent	active	$2a$10$2HdT6uALnlFkIar7Kci.LeeZrU3BoRhtznLIKUe4wTbVGumdqs/lW
554	  		parent	active	$2a$10$bhePvAFK68Jn9f.aL8e9LeAGaXpZXiPN5uqiQov.h8TJ7huCdmC22
555	obeng jeffery 		student	active	$2a$10$bQzbpkm6SCXVVYltKskd5.gEUglFyWMMB0s7LQEeQ3fWvDp7lkujO
556	 appiah isaac		parent	active	$2a$10$JC4.TqQutrOvY96iQxMBAOobx0b3LJeoFIfwqA9R.10oFog0CeHVK
557	  		parent	active	$2a$10$pgUQ/Dn6R6otZOv63z8A/ukqpH662TFONmcptvUmKyilvXcCanTXG
558	simpson quinester nana araba		student	active	$2a$10$Z9Ydv2JpXKrXQOjSh6pMR.AnjYY35r1/0/bOQ7bwN9lflM5J24Pf2
559	 nyarkoh abigail		parent	active	$2a$10$ZGRii6j7No.CaHOQRQFvyOqJhYWcdoXSbseObhKZug.LPPnBeV.bW
560	  		parent	active	$2a$10$Lu8LA1umKTvowh1T0.Xdheiuky5nTdbWvINr36zR8uIXoRQK2Lbau
561	coffie clementina adwoa		student	active	$2a$10$oRk3t7PWBiTeZzm2v4mUE.xe6832S6sHdxADcUVmardgs1fSOQQ.e
562	 coffie clement		parent	active	$2a$10$hGR7Rtnc6zXe8lH50gMtqeRP/3AgPiJID.hslpQLYNVjUkWo/w.3O
563	  		parent	active	$2a$10$HyEW8Ir1412cwiHy3JEEhu/yy7heVN.S0mc4XJnDXWjyryvs0pzVy
564	atsu oscar 		student	active	$2a$10$ZSllRv8AXeouaS3j9fUGJuetAzMORLaS3mlEv4YvYQzheQ6PRpYfS
565	 atsu emmanuel		parent	active	$2a$10$Y0D.Z9v6mbpGHEtwvN0ToedJYivilg8i2sLWYUzzFJ6EQVExeYc5O
566	  		parent	active	$2a$10$dPXmiZapbaEJG6W2BRAXyuKpvHQ6uBBcM4xVhLAWghlPZ/x94S79y
567	donson damien siripi		student	active	$2a$10$mFFb6aOmtbe.3prCc88Ya.jzUNV.jD5I36QYR7dFYCdBvrXsoslDG
568	 arman christiana		parent	active	$2a$10$1lmGGlNDDGxHTL2udAkLG.NVE6cVYlmoz/hqBZ0xAQMbg1qHytSYi
569	  		parent	active	$2a$10$o/lpSmXpMXQhYRJPIFuoYurt6aZ3Pn00PU40hiqzXxs.6v4nn1dvm
570	edzie vincent 		student	active	$2a$10$HnhMiqmiE5tPOGpcCDQ3puTQyDRMJMhmmAYw1MZGhJz6Qqj3syPgi
571	  cecilia		parent	active	$2a$10$zbew045cLaLtm40VaGFFW.tCVWcY5asDKb9n7QZ3wDfMh4JFOvGxe
572	  		parent	active	$2a$10$3PcxXv74Q3/WkF7aaHN9neymiRCFGs5BUKzhd1oKiOxbgR4oEnuB2
573	tawiah kingsford tawiah		student	active	$2a$10$yJLFD3NkA0j6qKAOe5QUhOf0tSH9xqWh95hqQ3ilyH3LjdnfyI8nS
574	 anim evelyn		parent	active	$2a$10$pakjxwTVq0h0rM7vY41sAO4T1cgLlLPPhm4OqqyzXHd3e5E0da7Ni
575	 tawiah isaac		parent	active	$2a$10$XkFCC9A8eTw6mFd/pNwQmuvnUYV3kqmgiYHUDHwfm1jvRJOw/mL8q
576	essandoh joel papa kow budu		student	active	$2a$10$kGqUgmr5eOFWAZsUd0FYUenWPyEMYTdDLZsxz3Vehn.F1mXfkziAC
577	 kwakye getrude		parent	active	$2a$10$W3NEfsrCOF8ciiexPfWJs.Epb1yxDow/f/K9BURmEYsVJ3gleakUW
578	 budu philip		parent	active	$2a$10$wXGH38DHV6SUKRaJtvCb7enUTadXx.Jg0YcaW2qxyEzVGQ59Nad7e
579	essandoh lucas podolski		student	active	$2a$10$t1hEh1YVep.gW6PC6ZFnguja.q6Ky2VFrt7ENF6GXedjcgzR4LsAO
580	 boison victoria		parent	active	$2a$10$JSdrQd6NflVeiulzQn2/pevfOhGDxp955yqa1BtXb4fVrVohPnax2
581	 esssndoh vincent		parent	active	$2a$10$zzCwAvSsrcJeE6Ot.CS/euX9NTpgn9fA54pe7DWhTYZd93A0i/tQ.
582	nsarkoh nana kow aggrey		student	active	$2a$10$OGRF40kkFscRzBG1zhQWquM6okEFq0IPMj2yLm.LPQbyR0KEda4/.
583	 afadzie gifty		parent	active	$2a$10$8lQkQh96AJZoV5ed0jCBauxSTmzpLtvmRwKdbP0EhkK9QjZY6Wf4W
584	 nsarkoh e.k		parent	active	$2a$10$Y/IrBY8fcDcuOADCuRWkwe3CPHiJZ5eR4bmC0LKEk9RrpqHJiCT.y
585	owusu vincent 		student	active	$2a$10$g4gInSuY3HBrblQlt/lZ2.D/EEb4VUKi4m3gU3pFfp6/VSKvZSuxO
586	 owusu godwin		parent	active	$2a$10$K6ntl6ZVtJ8CBkvK8riYl.6SGHjNowGtHEOHg.0Tuc3zlV7jK/.Ca
587	 owusu gifty		parent	active	$2a$10$XCAygewjCywnKHS4fNHDhOdgyzbN4s.piSFt5UBJYIUT/RYsO4thq
588	quansah ezekiel 		student	active	$2a$10$nemNtCNyOYOLybbMwc6mT.Yn5Pg3clSPed1xUOZbWQLC0zGU65x8i
589	 quansah elijah		parent	active	$2a$10$DhO3Tc0F2Kq3m.YhNBezb.ipIessLimB8/lb8je2PFJEPuP5JaAWG
590	  		parent	active	$2a$10$tMt/I0j0VFJR7X8kct3eEeEP0nfgyQOwtUTvD3fH.PL5yG7dU4Kiq
591	acquah nancy jesusline		student	active	$2a$10$MpTGcUw65EfkYpRpSJz/WecAT8yA6FVgSzdrxYr6u4acvpdhBk97G
592	 acquah rebecca		parent	active	$2a$10$40jGrpdGpsa0ajodNwgfB.5ULo70H03g6Nrw6ZZhiPjHoAKz.o.zC
593	  		parent	active	$2a$10$0oXlGDo28M4Xa4sMrYuSkuYHX7SL1nomFJz00Ily9gZRsw7hDkHom
594	andoh hannah oboh		student	active	$2a$10$BoojsaR1e5Jdlo0Ht2e77.jZM779VBdFJYReQNdoPSL/z9OmY/fKW
595	 appiah rita		parent	active	$2a$10$7le9zLLZ9cbOG/Jp7S4iaexwX7uBOi2.1p5TEjdOehmsQGhgjry1G
596	  		parent	active	$2a$10$b1PFkbT3fsAEIkuDaXnE..YqXbboGKuSjaLZjyZAZ6h/dSZ2eQjTm
597	obaapa celestina appiah		student	active	$2a$10$8ry6tQ2TrrnBmvIexu4FUe4WckZZWkJXn0/VYJP3.4tyd90ph3UW.
598	 appiah isaac		parent	active	$2a$10$0/F1V6OCDpn1ORL0KxJaBOyz2OjiGrHULvMO.Qd/D1F5kBdKUkx4e
599	  		parent	active	$2a$10$U27hvSVyWs.JzSqR6rXQ1e6Tcan97CyXpOpUEixlNTyyR66JNJhGm
600	arhin jackline 		student	active	$2a$10$6hfcrHtyLZDeZjK8AEX/P.Drt.y01461J24R6vB3CXqmtQ.yJTswa
601	 amba esi		parent	active	$2a$10$l8Msto8iaR9Vb6xzPpkDXe9sn.jKCJeLUVqdWlhbym7grLABEtNTS
602	  		parent	active	$2a$10$uqrO2jA8SigJBcGEZyJYR.32mmBqABC2H2lAwHaaeZxFt2gw1dsZq
603	baidoo mabel ama a		student	active	$2a$10$wdsUTr/DVyiRjvY.YeYauum8y9NXDEylgNf7Gg6OpN9gUbJKLATXi
604	  anita		parent	active	$2a$10$A5zaA8QrVxxslr1HdNFJFO3uBOgmDKtK5NASXEW.U0jHIqPPsPC7i
605	  		parent	active	$2a$10$VeQV8/iXsyCWBomPMIAjn.A8lBSoMdrg9xJg0meKSg9vGYTBzcQNW
606	boamah michelle owusuaah		student	active	$2a$10$zerMZ/UevyuKG4sjSPOwFema3UIZW0ZAnfgF0Bay7tdCMKEWGPIO.
607	  theresah		parent	active	$2a$10$8V7XTDG4PJfKJXOLkd4VFueNfxhlV5vTaTOP1lOFXu7xlP4LR8C8K
608	  		parent	active	$2a$10$ZXOw/lFRQD8Ld96TklbNCe/adcm/J4HpzOVF7T9DXHcp9p8.Er4la
609	sackey keziah dadzie		student	active	$2a$10$D65w5VU.j/Yknew0UmgjoeBuqqhFHvPJ3/NfpM8iQfPcC.OxJd00S
610	  gifty		parent	active	$2a$10$qrVcv1UYKHE1OsfTEDr/QuxMgQ/i3lsqLH6WYOsNLAE6RGFS819Y6
611	  		parent	active	$2a$10$AJEHO65xiy/hZmSg.jNrpeOQ/XQNxlYH3ZU4nP/ZeACRj5aY1vWRu
612	ewusi florence ama		student	active	$2a$10$AvSDDLBu7WeaSx5bbfnjBeSbWC7zE1ca5L6N9v4E7t8NDthYMsvL.
613	 hayford helena		parent	active	$2a$10$c4MqGr.1/M2h9frWHa.8/e2WaZktxU7AGM7aUWPgUPgTGcUrwsfuK
614	  		parent	active	$2a$10$Sk9xPlc7HcALSd8eulBzTeaaC6omhCxTC4Cw1EG0pl6r46DSKIHqS
615	ofosu dominica ekua		student	active	$2a$10$GWgv5qHkzxUyeK.ArpuZSOMyLov1b32ylK7wU.FuLMb63sZn2L9hS
616	 aggrey ernestina		parent	active	$2a$10$EmZQbrq7A8b10S3SQ/GEbOvoChPDacoS/nEmGBvW5BG10i6rpib/u
617	  		parent	active	$2a$10$Vd3rvZGmJ8vw/rhRSDhyJ.BSRzXUgV82Pac8trAkyMt/0HYWMBm3O
618	koffie blessing rebecca		student	active	$2a$10$tdiTeKdKKzoHhyts0/nKYOuFzqP3VYEgobNIhmBrwX1pVV09UfL2m
619	 baiden gloria		parent	active	$2a$10$8ijKVn2tN6kK2Gnh77sm2OoVJ3aMtl348b00zpuZJ11byanX.LwFG
620	  		parent	active	$2a$10$qXlo9etknshwnG.7aJsHLePpX3Tt0mC37UOz0dM7nmsJo8GldmmVa
621	quarshie emmanuella blessing		student	active	$2a$10$5SNKEawevLYj10gChZ2hrOMu1pgjrn791tbDy77gIvS72gjPcTTTe
622	  joyce		parent	active	$2a$10$0HEPrCeeeJM5mZPHQBoh4OKSW8pqkxTXAxT7le48lXMilcKAz17Va
623	  		parent	active	$2a$10$jonylxE6OBy8k2.Cg.zE1.rRukXhzMhiBdQY5xO6QLHrKMfdOGuQO
624	quaye christabel amo		student	active	$2a$10$qQ0Zr/gj1ufupw4NOCRk0eHNeUobtEFDNer77vFPbXYL7GrYcTOpm
625	 eyiah agnes		parent	active	$2a$10$bSG2p5rfzdjqyu81YRDoe.5xDo2jqylN4YLQsZj6y0nrqYj8FXtgC
626	  		parent	active	$2a$10$3yfpT4fFcmvCpJ93W6VZnOXbV4ll/7vRwJuOtdScM1iSMVFsTJZ7q
627	tetteh victoria 		student	active	$2a$10$4YC4zUANn1PRRuVu4Vo75O4.hE/y8ljUQtbgI5.SUdDims5opLPgu
628	 ansah abigail		parent	active	$2a$10$qH2xNHZO7mE4W3LayAzVt.2qCWS43GXRNDBaryMkkIdoT3RzMEGr6
629	  		parent	active	$2a$10$PZ4ug.o0YrvjiitFtvQLl.fjEOuROxBB8gfOlVhD8DNKb2dSzBUei
630	abbiw gloria 		student	active	$2a$10$EzRhpFLT9K7FJckGtPi7ueVOo8c67bql0gfp7Ut5yR.lBykdI4KKy
631	 abbiw james		parent	active	$2a$10$CKhdRqN0oF/O.asgBGcegu99ALXXTIOreK0hsyDj9QVKZJeSaXoRK
632	  		parent	active	$2a$10$M2m9xhvgHnME9u89S2eX.uSHS/t.Kqr4sR/IkWjeZFeBGFbkd0Gd.
633	botchwey linda 		student	active	$2a$10$nwL2NInqiTX9Clg4usAB2OtlhZEBwC4qGRfFDJRcvTAIeoLwS5Vl.
634	 botchwey mary		parent	active	$2a$10$TS1p4RsluyjbAro4yDlfpOBKTY8MwGjwKUQFzeUyC67aeHIt0GNcG
635	  		parent	active	$2a$10$HqWyIWZdSbnwbBOBRHaB9.7Wqb9jhPQgS/lGgnQepxq75tPTM5xLK
636	aidoo emmanuel 		student	active	$2a$10$6cSO24h.VmRDW/4zczI6p.MD843HEtsMJCNBnUWEUu8XRYR328Aha
637	 asuman hannah		parent	active	$2a$10$i5.7iCCQelqviVOXmMuctuJCpV9SFE0fJ7nMTpD8svIeOtt7pP0tq
638	  		parent	active	$2a$10$7PutPfd8WdFMDC1qceblBexPXUbKADxdPiRAb5luKYYp/OV28Lj12
639	abekah joel 		student	active	$2a$10$E1H3zq.oUIAqRlycgqAVA.YJnk4zeAMjMEuLZwqhZxbK0ZIZxlIje
640	 annan dina		parent	active	$2a$10$Yxrw/FuZ2fWQEvolIf3.fecuzYiN3wllmA45aMQPv.xeXIk1u1r8C
641	  		parent	active	$2a$10$BACKtXEpDG9BdGwyRKmSf.dgbtwT0RNzihSh6TjZ6zuLc5/FD8Iy.
642	ankrah christabel 		student	active	$2a$10$9H7tyZYjaZ5kVBmkNqUDZuDtr7/4V8B24kXr0EIOevhPlKufBSQIq
643	 mensah comfort		parent	active	$2a$10$mLesd5wXJ0EjwiIRSh9J5eSLzC8C5sBvmzyG8uAmHXC..JO5nQ5vi
644	  		parent	active	$2a$10$mDyBD9fLZQlq6Lntu7wkzeSpnIzhZYDSnhssfLcE1yqp25fi4aLDa
72	obed gyasi 		teaching staff	active	$2a$10$hH8Ex68XTxVvPpbrzjDOXuSPfqWdZvUjSK39kj6tnjE.FqGsuevy2
645	gyesi nhyira 		student	active	$2a$10$gCZrma1GK6S7zDF.duu9T.6ouSV4YBlj7FS1nI5TgSuAvyxs6sPR6
646	 hazjor cythia		parent	active	$2a$10$1/zFPd71JccIcaYvLVL/Oe2moOkZN3e88nZVZ3u4tBHUjhTxgGYQS
647	  		parent	active	$2a$10$s46XI/hjP7V.cVj53QNSy./ZLX584Cmy8zh9dL686yfMQBEULOa3u
648	abaidoo micah abbiw		student	active	$2a$10$WOA.iJ9Tc2l/YJHtWpo5kuIiSh2z3LcBf/5E1GiQBqwiBSAbMWTrS
649	 appiah hannah		parent	active	$2a$10$102Rl6SOhMR1HJICrXwGB.ojbFp/Uoa4h1HsrKZI4WL9Sd2T.Y9gy
650	  		parent	active	$2a$10$2nnVKKtkp/qZudgCTZgG..VXJ8fyAbJUl5xCmDd4jDhZ.9GhiFRmW
651	dampson michelle 		student	active	$2a$10$XO/mcXji5xIM1NB/VmFOvuRGCuSL39B3dGtvlFWzjmZ4xokGQT10C
652	 dampson mavis		parent	active	$2a$10$bXpSPpVFGcCnqGFoDms.4uBe0/G2HhgUR3ZIFS8y7FiE.dlyLO/2S
653	  		parent	active	$2a$10$h6OJVRK9LzhtDTvVNbgFl.xorAfXP5cSoU3I4oqQriKLWbg3v6h4W
654	acquaye kennedy 		student	active	$2a$10$oTqbRiujW4/ZslotrKs.6eyHsAt4zg92tvzsqJCqwtT0nbxGcBd0.
655	 acquaye francis		parent	active	$2a$10$alGYxQQDYxteKLdB254f.uGmH6J1xr.rd7vkxcLbanoHOXdD/HMqO
656	  		parent	active	$2a$10$iksxUzvEicIBc05poFNj1exs8l4KHNR3307rJegmHRdLHjfqztxte
657	affoh favour collins		student	active	$2a$10$jipXKC/J0lWwLsWKdpQdU.kXbah1/YYKr4rfUBwmOqO5f.t2duBpe
658	 kweku bro		parent	active	$2a$10$77EW/S5Fr4AkC/OQMQebBurcHuA7SwS1.gne206rIPA7Szn6F63pW
659	  		parent	active	$2a$10$Ksn0pf9HdlMxhE3iXIXbTuK.J3V3LeD/T64otd5NwxUC/h6wedfYi
660	eyiah moses 		student	active	$2a$10$p8.wTjZy5JWkAnH9iADXa.TqnZuG0uhjhW1bVsPVdxciHV9iPe99C
661	 amoasi dorcas		parent	active	$2a$10$5z6Sm6SJOhgPYS4giyQbiOiUCFVcVwgkOXi3etcL0mcnYfF6y59IO
662	  		parent	active	$2a$10$Kw5P0kOK6W7he8fwGFdtiO/7vy0D5En83DJqj8sf5bVj62AomNa.C
663	gyesi pertrina 		student	active	$2a$10$wdxq5OJal2zeqcvpNvibqe7Sak/14x32R8ovFwl0a9fhcTm83qC76
664	 tawiah joyce		parent	active	$2a$10$JpR432or3Ghems9RAMdPaOeHV0/oGmwdbwkOoLXo7VzgqGJX3t1Pi
665	  		parent	active	$2a$10$9mljrzUz.MWaHbGgWnGW9OFz7DS84FKXHvm0Jylu4S/bu7mwLaMqW
666	amankwah jonathan m		student	active	$2a$10$IvajXDnubAtl3kQJc7F1eOL.ovG6amBqYr2n1VyKLq6FYn6DMUM4u
667	  		parent	active	$2a$10$M3iTHIZwSfvy.dPNl.uCVuzkXcFsozlEhO8n4ENZUIwOA2ZBnRB4m
668	arhin eunice 		student	active	$2a$10$GmmlJBhpviQc7oeHHnX3meWag4EZwkHsNtjShjZF/grBB//iA.Hr.
669	 koomson patience		parent	active	$2a$10$mxkzuTyB2On5UHQb.D81N.V9QMpaxO.KQjLjG8WAjX6xSsu7gY4Zi
670	  		parent	active	$2a$10$ZlRQhtDYl25j9ObnSI.l3.k6m/RfIW1Z6TcKF.DyNR0D7Amxu7Wk2
671	andoh abraham oboh		student	active	$2a$10$QFcbuIfiWlLi3qe7HX2tKe.g90c0LWiDmb4poQqlkoo5FmhYUI3rO
672	  		parent	active	$2a$10$NBlRy97s15HUpes1VaAVPO3AftXcUFRKgEuMFWqMpNsQ.hQFLuOR6
673	arkoh marvin kojo		student	active	$2a$10$OgQZVWjwijI34S6w91zTg.GGzeQi4kUBT5ICPJvzYcvlUNqEjpN6K
674	 aidoo doris		parent	active	$2a$10$I2zNxQqJRa14NI98j/SRxOg.0M0yNpo7BZCylYfeBpKzwqEI03U4C
675	  		parent	active	$2a$10$WbLNbph1HAYasYGo9q7GkeGwOw1gWCMDuydpyjG8WJ3/4BZ.U5fr2
676	ayin precious naadu		student	active	$2a$10$O9EekQUubUUHvX.yz5/5ouV5UyAmvvuTb.zboTZj2SLnTargJlD0a
677	 sagoe rebecca		parent	active	$2a$10$cdYHyPrKYz74R.3bWQ7wb.iG07/K77cv1U.q0RK7Yjud1LBOlvqPK
678	  		parent	active	$2a$10$sgidiKAgEGTQMRv6oFjJme3gOHlD4roAJi0jBbiWXB6qvCM3Yxpoa
679	anderson charles kobina		student	active	$2a$10$Nf9vt8lGx.xyjflrYy9b4eVhH3wYr//0YBjmCkUDk1bM5zmllS.Kq
680	 anderson agnes		parent	active	$2a$10$NhjCzefiibN8ATjpl4tKcu73C9s5TfSQoONv/usImh2xjXVE1KFjC
681	  		parent	active	$2a$10$RbkzhOP7A0XjxNfx2Wj3FeDESRYbNjUk06hSLMBAwzckAVIb3Ym4O
682	owusu emerald fosuwaa		student	active	$2a$10$pzhHVUiOG7jR0XUSsccqMOhgYuFpuPxz4hfBRthUvIIvLGcN11Kfq
683	 anderson patience		parent	active	$2a$10$RRkYIOEQChStqFg8MYThQOmdv7F6uequD73BurbK9otwlHVcsmuG.
684	  		parent	active	$2a$10$pIgtPmyzhZlUsUb9PKIaweQ/EPY6NAo2H4.G7FOH7ptEVhw9Dd7Xe
685	annan daniel 		student	active	$2a$10$qGSvfHR.IVe091nfIJj6VOXpa9EpdeCaEJ1/z0/2CC4TG6.flWG36
686	 annan ruth		parent	active	$2a$10$oFu2QwgO1re3sRWsr8h5ruvu7yeiZu1MM2W9ZHjlBo8NClEAz6fP.
687	  		parent	active	$2a$10$rNtl1aXAcTX6JQVgHFq0eerk1jToKWT7I60flZmvTwsX9ytg4zLh.
688	otoo festus 		student	active	$2a$10$Rrg.r4Y/cQVOWhNzXKEfqOI/h0Ml.jGpdvxTNledkE5qgoA.3nGru
689	 otoo mary		parent	active	$2a$10$O8GCYxm9CzDSJcTOoad3M.vLZ2fOr8FlkNNuMjWNsbBd.QcAdwtz.
690	  0		parent	active	$2a$10$Z/xuP8tUEhDY2hTRqYwMvOHSpD6Jh6p1Bz3vtt9abF3k.R/hD6wOK
691	nyarkoh desmond 		student	active	$2a$10$o8yI/3zAWSq0bcUAJaQd6.bk1LxiiST4ksZGTeBqgl9CDWrB87lMy
692	 nyarkoh janet		parent	active	$2a$10$djU1vrNSg.1ZCha7jPUoeuplBAcXKTBV.RxJcl0aNLo4ANnLeaCLq
693	  		parent	active	$2a$10$cuXrmd1hjDz88Eq90nfUGuE/JYLLeyffEvu0gL2qRZ.ZkMfR8n/iC
694	annan favour kwabena		student	active	$2a$10$Tnov6uwjUyepySYkvwEfeufNpfHJBdQvnc.5SrI6Y93y4yby./mRe
695	 annan rita		parent	active	$2a$10$XscTWUtZ5Ql15gpXZqQO/uoj302kUz98iM3aArxGcKSJGGcQMV7pO
696	  		parent	active	$2a$10$K0Rm8OR5mTUj3M9bnABMeuiAsbSQV1R.UVypJw8zA20WhcdQcRbpK
697	essel glibert 		student	active	$2a$10$4pqsuvRzvAc7zTwiiWaCBOWW572fgfQsmWH/V4FE/.rPsqgbNTNCa
698	 obeng mary		parent	active	$2a$10$exBQngxbiT6eXjcYTlgYhOXVUFnPePYoEfZ8qRt7.JMziycTKTQ6W
699	  		parent	active	$2a$10$r2SNv7ggvLQzqLNo4vnD2OC73NDl3Qn2HVy7uPStXSBzHxXAylGcm
700	appiah miracle fiifi		student	active	$2a$10$2Yx79r84u7lHG9jByciOiuvSVVNS015t8snqMnUs4pHwQZ4tbryLy
701	 gladys sis		parent	active	$2a$10$CKIfDw7UASx2XSNobdsLzucz/7JqWY5KNZ9rPVjQ8V3SnjIU6i6QS
702	  		parent	active	$2a$10$UQrs1rd4A5j2/P7SStAs8.E4McrmfSY7DtmekkWu475HV4Rwrh1Mm
703	lamptey prince 		student	active	$2a$10$66yZidMzEaF8a8/D3ZMbJeWJ/FCnH/bMFhuiGz.4e.74VTuWzDOMK
704	  ayiden		parent	active	$2a$10$MDptrZ/FGmL/IuZ5UgUrPO2ioo.2F5GKGpIwSxnADrQbYVVEQ3hLe
705	  		parent	active	$2a$10$vQWgrsDZDFrGaieJy4Aw6uj7XPSjFKy2xqnhNqOdCXXrvG1E1fStG
706	okyere festus 		student	active	$2a$10$2EQaEmrD1.TOhu6.w5MuL.rNUe5UBKlUEF9cqdOvfhCvTbGZJT9ra
707	 arhin millicent		parent	active	$2a$10$hGOfVC448FWK0TUT9YcNv.LKlKxdGjT8w2./fo8qx5qpBpAaJhDY.
708	  		parent	active	$2a$10$9wzLSRkakUC9VGFPd4botu4pABdvWKIauBHMGr5CkKkkyKqPjgj..
709	appiah greg kwame		student	active	$2a$10$4EOaOVU6V0VShpc0uiIQg.IJskdp5NuR6Qrou0L/WBl8sxkYHEVJq
710	 aidoo justina		parent	active	$2a$10$Lr47Gziz4wdD.McuxW5/1OWccY5k0tI0JMM7vyu3BFDuTZXZR888S
711	  		parent	active	$2a$10$bBQuxfttGdxbkIeUtB192eyjuA8h4tYkRecptjqcKPuXxah0YXAFy
712	arthur joshua 		student	active	$2a$10$J0LdbGDuoUHIkSNjTvExTuuNiztFcLjpf5qUgbmP2/d.o8XGXU2SK
713	 egyir elizabeth		parent	active	$2a$10$fyCHIyYjRInUdYxzt.tKvuJeMjBFSp16i7zhvMVMXiU8efy34y2qm
714	  		parent	active	$2a$10$Fd/srqMgjBTyQs5wG5KN8eKb7OT9MbEv2eSPEcfdBXVmAlrQt6Ijm
715	atomaku philip 		student	active	$2a$10$YonYNyDyoC40PDQUwGTbyeGSgckRMkebW.8e1L6sEChhgJjaXYIha
716	 efua sis		parent	active	$2a$10$IcE8i7J/BUqNK63rWM4.OufKlIOT6lBOHEgcrje6KWjkBPRmtLnli
717	  		parent	active	$2a$10$fx3pyo0pjW90xmlAq/DGcuhkZBaHGTjHvxERmANqvRKa7Gk6B0fvm
718	dotse prince eyram		student	active	$2a$10$4/2vIggDoFuDy2holcjig.Kp9sC7j1aK1BTMZ6kXIKMS5uZDN4oPu
719	 dotse francisca		parent	active	$2a$10$ldRKz5UstSmRELi2HjItZubBP90NmR8MnN8/DX1YvsZmL6UFgZ9Fy
720	  		parent	active	$2a$10$nvboxSgaVXPBw7n/M3tzp.BCuUv4ppvfxMN8GNTW1XyK1GZFoquKG
721	dadzie samuel k n		student	active	$2a$10$C6FtIiprm6XouhwLCv3RL.eY7YZC2T8z/FAErVkMVdtysfkAS55b6
722	 mensah georgina		parent	active	$2a$10$ZzzB2zTQMaba32m26CaScemEvwpDe.v8GlM9fkHkVnrk.RmFPI0vW
723	  		parent	active	$2a$10$Qiw2NoXQhmNERDMT71ucm.HPuNsausdB.TooiWmxT0oBHfNnSh8Dm
724	odoom nathaniel 		student	active	$2a$10$68nMeB5dB/edL4jboktxXeF6xAtMhoS7aZAf7miG7xisMJMVXL2Bq
725	 donkor esi		parent	active	$2a$10$UHytsIt8jeQgSKlIq84eL.ZEGbN.0FJxoPeMWkIB9TbJfaPBzr5fS
726	  		parent	active	$2a$10$3vGdURTKnL4.EJ/uET3faekqilRnZ/yO21/i2/l05/9B5xT9Z0EUu
727	darkoh peter 		student	active	$2a$10$mKGxku6t7ZQGkf7xV4wWzePRgifskRiJb.xeMoXK6c.IE2N17SaZi
728	 darkoh emmanuel		parent	active	$2a$10$xYO3oMuAdxhehiU.vC9ZpOi9YyRPA0aulzBWrrv6RmqyEdDfJBw2m
729	  		parent	active	$2a$10$foVcwLB/qzjkilay9aBWTuP4PJN4o39kHSmc2zHkjxW3XgGMpxJWC
730	essel bright amo		student	active	$2a$10$WIvdGSK1tEvctYgC5WtHJe9f.1NTnRwLqcn8VPpOhE42pV/yoxLnG
731	 amo papa		parent	active	$2a$10$85B0LEET5FFdq5Frg1u7peEhokPI0/apXl7YWk7PpDD0.lraaAzaK
732	  		parent	active	$2a$10$IOK9fJOMgn0/4RX417S8QuezJlgFfajiphnQeU/3BbVYo.B7u0Cr2
733	blankson eric 		student	active	$2a$10$nf/ra2/WO/xwe19gTi9UneaPXZ6ArIHkMPwaT5h37v/ENlJSdqp6O
734	 tetteh emelia		parent	active	$2a$10$1w9Fbow6GByV4hjtIPjnIuqm.eqB7wYN1/NAjsjMdvBBGidT.Sg56
735	  		parent	active	$2a$10$Qu56C/9mJMC8n3Sg0zkGQOe2Eg1L85LlfcypsAw3q3jpYd8u/.qxO
736	hinson gorden k o		student	active	$2a$10$xiwOvF.499tvK/CR5wOp9OpYvG.J4FRCw30yI9N8jcjSkxtJYk2Sm
737	 essel catherine		parent	active	$2a$10$xU/XQUZc5qPEBjc/067vSe2/ZRDxZheHdA3Ed/DvZ4jE19755t/Ke
738	  		parent	active	$2a$10$CnVa4O9vwi.viLNH27763OcWkOssA0FdYJqGaX8X2GuNYLOVjoDRG
739	martey eugenia b.addo		student	active	$2a$10$LmZds8PIReMpY/B0s71zTu/Vy9n1jMtDvfHyItaekEqUBxT0VuFz2
740	 addo joana		parent	active	$2a$10$AUoWt7EnsSYwxrs.sTk8ueHJiMzOPET8qMwf/gFegt3yYieb8Lbne
741	  		parent	active	$2a$10$jVQAgry4vmt1Oywqseoa/eb3D8FP7yOT3UAGwGk7rO3QO9vsTEOb6
742	ibrahim justice k.e.m		student	active	$2a$10$spp8sU7sH6ySVVgg6mYPbelv9i6I2sAuOVOxqW0UI8o/SJ5GYmmSi
743	 ibrahim abass		parent	active	$2a$10$VX8qWDm8kdVy.yt22CUSmOnx/ghh.quxZ7ikS.Hyp4yIyV/3Tn5jC
744	  		parent	active	$2a$10$p8KfGSiq7mRADKPD.0rtmOGG2bMYN5G19sn6o01XeRKqSFik./KoO
745	koomson emmanuel 		student	active	$2a$10$h3oiJH4BfSuiX5PD8NSZOuAq7Af3t89Z1n.RGZIhs40nJZxQU0nU2
746	 bondzie miriam		parent	active	$2a$10$.KNvgBMh6HzWzBvQfT7ADOnT35tw1q91k3PHlI/3zBexnwuNfS8VC
747	  		parent	active	$2a$10$7056D6laLtur0gxy9DzRL.P2JCFHAU6egRfaVg4RdODr.clC17hCW
748	wallace benedicta amo		student	active	$2a$10$zC80BeSzeNIdOoA1PA7ZzOqE4ag0/j0ux01vxs71d4rGNEeRUxg5C
749	 adjei patience		parent	active	$2a$10$G6Q/4ywq9ccHM880kxRU6uvyUIOx1ipgYTh5ci1Oyh8zd9XBVHSVC
750	  		parent	active	$2a$10$4oFnJUzs9i1BWa.NKpoSguj.rYqT.5Nb85ZU6lgzPbE2cDRO28.4O
751	mensah richard appiah		student	active	$2a$10$ZOmQsP52OcO.dI.0Z1M0GennK2ymLgSU0nxIHyrzTB/D.ync7Nwyy
752	 moses zalai		parent	active	$2a$10$9vsOQbTqDFrVX3epcHDQhOBGec7vrwGfu9F8DwtDLasTxKAyD58my
753	  		parent	active	$2a$10$fWWNAUXD9tccoosuoaa/FepWOrJiYzRDp7PWnnA9VQLXmYlFC9wS2
754	mensah edward amo		student	active	$2a$10$EpbpNPmfwQChiIMkV3VOyOgzTojAH8w2A7DQuEMHL6.y62H1IC6hm
755	 quaicoe grace		parent	active	$2a$10$DN.PNYfNdLWqe768BiC.6OOyRMOfWGgn23ALOS4JrtkJUEpT8jUTG
756	  		parent	active	$2a$10$GPdm9f.eJLLOhN46STUngum0bYi0ZAjKqngdXaK/C1S3QH/FLcL8m
757	mensah chris 		student	active	$2a$10$jPHFO6Em/JYomuA3TxI7neUYZdMg7Ljqn60Yahdas2KzUfP3XGFC6
758	 aba mena		parent	active	$2a$10$EpaDdZ71.cjW9zE/DAV9n..0IMsvyz8A6.OyP5ZNNnrXBEsdw3l9.
759	  		parent	active	$2a$10$c.7cb8grrCKhmz5T6gudAOUqkICtMogXfb7ah8tavxue1QEv9MBBy
760	mensah robert obeng		student	active	$2a$10$/WnQOmvNXogy.g2SsbDL6epgLvjtqV0NsX1WvgODp/mCETs/BBat2
761	  sackey		parent	active	$2a$10$gmuSgxIwGQ5MmH3kkllIDORgyqrtHcPk.WIXidc.rDa0y83FO1wBG
762	  		parent	active	$2a$10$pL01kwTfopZHU8sXFs7fkeFFdCrUz1Zater/LZDPuPNx/jVB.R11G
763	quansah zebulun 		student	active	$2a$10$l/Qr4XmZ.puF2sLL4aF7d.3JpI9NcXxrvpyzocpp2jG.DQtIxVRga
764	 ansong theresah		parent	active	$2a$10$/XVTEO4xFm9mPdONKZwcSuSrW0Mi2KX21TxQ0pCp13wWKd6S3c74q
765	  		parent	active	$2a$10$ha1gRuTHxK9mMu13aSeu/O6TcFy7qDvkl.tHS7wOBdRE1rYv5SW8S
766	addo stephanie 		student	active	$2a$10$SlopCLNjd5LZ37CI9EcdmulWgk7OVavl0zVde22MxnXaSZpqFqd82
767	 ayitey patience		parent	active	$2a$10$.U1VINPjXlM6PTUx5oq5GeMUm9tglYjmA01PJPH8YTB6BRAUmES6q
768	  		parent	active	$2a$10$d3P/W/mT8J6e2Eq6VIe.EOB0zSwF9KIRDcGZ8BmGyK/En3nOcGZuO
769	arhin yvonne mensah		student	active	$2a$10$Sat1wL51v2AeB0CB2Ah0e.UM4FwWNO42eAmJnLICArlO/nvmFHL26
770	 mensah comfort		parent	active	$2a$10$1o5T5WbfJ3g2wFUxo/C2E.frTHAYW2yqNETVfW2GVJVE1qTOeN9Ea
771	  		parent	active	$2a$10$JkX3AgedfbLoO7BR6TBqdeHyfet/sObcH4f833RS2MqjKnQylnhnO
772	baidoo blessing 		student	active	$2a$10$N.3TTyxCLk2O2Gczqn8W7uNDbmgMsTFnIk0vHK4uPPQMR2XVLoWUC
773	 baidoo augustina		parent	active	$2a$10$uQ.BaX3ZXeI5V6R2woSlVOxKZcL8.0D1OeAsc.TmtkEv4I3kzYTBW
774	  		parent	active	$2a$10$E.HWqx1VSYblUt1OB7XIcOdWkTjecaQqBAoj2UaVaeLHvwSVQr9..
775	bassaw mabel 		student	active	$2a$10$4fMcFfsx2pju1t6mn9iyiO2hDe8522xxbrY.Jra42nE36MDGD0Xam
776	  gina		parent	active	$2a$10$5cDCDTu9ZI4aJhJXKvetYOm3LnPpbMF8XBYsTx/BFCRxWj5NSHTPe
777	  		parent	active	$2a$10$v9kKB2p.nhj2MAZsP/Hmve0RQaZBnUuf8qgv8rdAux2dO9B/uHKVy
778	incoom josephine 		student	active	$2a$10$e3mnrbwLokBN2DGSIAulQOZjREN.ebhTyq8kCkKfL3KLG1Y.DoDV2
779	 incoom benjamin		parent	active	$2a$10$7X3PtrnBvdTLvf59m.cwqeasYcGM1tGSNNIJvPF2EygIf8Duedzay
780	  		parent	active	$2a$10$vFLHDwsbZnmsgGu8cETpr.lQ2FlMwN7YIHUcp5qpCrMKhJwvOSTPq
781	koffie blessing 		student	active	$2a$10$NtjPnscwIYS2ghqs10agMuugXWaOeEnsGPCYWN676LWXQeyzr9Zta
782	 oppong esther		parent	active	$2a$10$eV4CSanhri6CelQ5XUE3AObxSIdXp/Xzh5En0mvsGz1RA2H02LKlW
783	  		parent	active	$2a$10$4GMgcQQ/0SK.Jl/lFZy6LeEJtZnKc/tBjQTlEd6SzTRnYpPXSp14O
784	lamptey victoria 		student	active	$2a$10$JZohB5HkM8ZNYdVXPRKKJODjhQlm/LaUJAzF3MB55L0GnsNGkJ6pa
785	  ayiden		parent	active	$2a$10$22WstMpdpxd/pZxmEHsaGerydktoKVrkoZDyvxkEwG8R7Jxq5PT7C
786	  		parent	active	$2a$10$bvFc3cA.fm3.Rt/O3zMdVOxk0WFUvqFTepIOKhCaHPaaIzwsmL6yq
787	mensah nana esi arkorfoa		student	active	$2a$10$zZ6ttx8XVezsMIbaycclT.pK6dJ3c7BVpo2fs11luU4SjirriihxS
788	 mensah reuben		parent	active	$2a$10$IUNxoqrC816VX.W6CElP1OC7deNs.qswpvvqlkznWgtir59Pnm1vW
789	  		parent	active	$2a$10$3cbbFkCKH69sQgb1Rr48U.xwGfJP7D6SA6l1DM9SFxDyZQBUn4WFi
790	nyavor yayara 		student	active	$2a$10$iIg8uwVX.0LwdgDTrqUz/OhcwWO3Q8tL9DC7JhMOY.fdXn32zesTK
791	  		parent	active	$2a$10$atHTbt9qWF4LZlurp4aQ.Ox0QzNGy4R6ZJN35ouYMvuafe7vCtHGO
792	onumah naana pillaba		student	active	$2a$10$AFzhhehJFtdrsDjOopjb.OBmyD.Oaj6WtrdfESOZPvTztKIk.tvzG
793	 onumah ruby		parent	active	$2a$10$v/K22veVbljIsL5VNTU20OyWgnF2G9GWiCId0WyBB8PMq/eYr.INC
794	  		parent	active	$2a$10$gUlT3E.dkjfOVl6bXlaIr./Z0A2Z4iVYCr6C2JeZ8TXOOKCklGNsi
795	sekum marcelina nana ekua		student	active	$2a$10$ZlVLU6Jmgpb7sxjjqPzrdO2fSBm5zKNUxmOOelRWMj.kSgDNKzQYy
796	 dadzie mavis		parent	active	$2a$10$w2HrXA.ur4D13kw.AXxGVOAzFs6XqVJLMfWBW0/X29FTXSt19TeDW
797	  		parent	active	$2a$10$ZTznl5LQCzVXa76XlMnyw.Fb/h/7xveiWlxhui1suwyWU0e003wFu
798	wilson avery oheneba		student	active	$2a$10$lEEcnv3J3PG0IiXjyrmQ5u1P4z39h3hAu3.bUUdTbtq49me10FDjW
799	 adom precious		parent	active	$2a$10$tS0X63hqT0l/BTy9M/HrDOQP79ugVz4RS/atYlCCRXw0yzWJ2Pr4y
800	  		parent	active	$2a$10$qufwpxG/ib2G5rGAawlQaOsDRGRFAcBwSi9NA4MH.8F1VCxoYd0Da
801	otwey loveel egyirba		student	active	$2a$10$5lUG1cbYh2mQ7KwSGEwPkulAozSUI8FGHTfH1bKae935m0B3DGZ.K
802	 abedu kennedy deborah		parent	active	$2a$10$GZsgkO2xOhjofNM1uIdYCe.Z47B.JfklqZ/tO.KllHx1L/nybBYRq
803	  		parent	active	$2a$10$Adu3aNR3lwEQHURFqw9x9emqbiUG/p5Mc4PD6AKNSXfB5ZG/gUFUi
804	arkorful desmond nana kofi		student	active	$2a$10$1e66tSVQPEQ.sGqEeTldyOSwHV5AKCIVuXy1aEqfRedm8UvcuMVfG
805	 ayivor wonder		parent	active	$2a$10$/WBv/gO4rkx09dzLl9B/LuU9H0gLuBJ.MBOW/HE63j9Xx/fyKM87O
806	  		parent	active	$2a$10$jyCR1D3InoJMZPUGKXnxu.l/I4wNiksXLLq5ufaXbpPym.uMTYDhG
807	andorful judah e		student	active	$2a$10$P1znRlshxF5Qoq6CXF/x4uDv10c7PjZ0dsqLxaf5BnU7pSfL.JUhG
808	  ernerstina		parent	active	$2a$10$D82FP3Dsf9v7u546.7iNM.5PBN4Yp8iskU8C7LTCYO5w9P5oQwntm
809	  		parent	active	$2a$10$9xLh42v/GG1AX17sfF0MS.dA/VTQFTO4a7X0AN2sckhism3oSEANq
810	agyei ernestina yaboah		student	active	$2a$10$7I2HxhxYkfm8mkMfXDlzHuoYccIv7pmTbf19xHsEaQPOwqARK0Hlm
811	 edu lydia		parent	active	$2a$10$otDuY7uM1s60ndi38Via2.hju64bdsORYktmEx7fdeLVC5ZbTCDuK
812	  		parent	active	$2a$10$LR/uPqKNYdj1yjP.WK9uPu2YUmobkLgtSjIRjGzqoglRK7NecUo3q
813	bentum eric jerry		student	active	$2a$10$zn78vScHByH18h/WCPuzDO0w0OuJpJBtWreyF5qjSjo7G1u5DDHPC
814	  agnes		parent	active	$2a$10$ebGc0atxCDDeU3/d6guC/OH8.dbjhonFtunToX2Ljmw722asBnTZq
815	  		parent	active	$2a$10$UAE64Z7MFmBuazqWl8apZOK4VdJvwMWEUbfzJ0S8oGtP1.Lj/Hp0q
816	nyame mabel sekyiwaa		student	active	$2a$10$6b4zdZXxuglZtSPjEXfcquS3AGZOER/xu2sTpS89gDRuov7o.HzHu
817	 asiedu abigail		parent	active	$2a$10$BFxQNqMeFLNM98AQyUt2j.f0LF7FeK0l8tsDjmYxCB9pfZGSbHjJG
818	  		parent	active	$2a$10$1QFpRSqpWvy7PkB72ypl.e3eoSOGj7UojL7jN/K55d.aMywOVf94e
819	esson francis 		student	active	$2a$10$9IUI1y80PUqxr6NnfBJlz.nRt67KzphGaBLmqP5P9OVjdIwaHRmVS
820	  sarah		parent	active	$2a$10$HaRf/HDaGCFEeDNzA.hZKejlN.7dN6ytLsc6Q5X9KpAYLja/DopK6
821	  		parent	active	$2a$10$c08EekXFIvZJlGlVf8Unkes93lwxbuxtJfZEHXA3XZvwo2K0JkHQu
822	essandoh richard 		student	active	$2a$10$3zL2OIu87WlG9i2DdhqpSet1EXmiJ3hlJbGrJksb7YZbAICN/ELKS
823	  sophia		parent	active	$2a$10$GhvV6b5.6OUd31qOGChNnONcx5Pke6mFk0KYQcPINsNc7BJvr5oaC
824	  		parent	active	$2a$10$OSrrigPJMpyko1qs5sy.4u4oJyywBWBiHZ9XGMhocxs60MgNM6UHu
825	fuseini farouk r		student	active	$2a$10$Z2QYFeAIYaXs1rfeI37lQOoCvJm7neeCqBathsHhfuHT1GuvwuuPm
826	  araba		parent	active	$2a$10$UQ0AmrVE.oQFgcH70nohm.sol/ErxiP0TPj9v1yyS.4a/o.rXW3UC
827	  		parent	active	$2a$10$/hufGzZ7UOgbSsgj1mJqzubRXCFv4CKuSVegq14.yxVuE7DeNO51G
828	impraim philip ayeyi		student	active	$2a$10$AQm9/YpgubjyYAgdqLOAe.IBpY/RIqstLvHmkRKvKFJNqk92vB7Qe
829	  faustina		parent	active	$2a$10$wt0tvTx4TzgrCn1vvx2tnOqycdL38SmDGoY6JJF2UpYxrLL9xBUl6
830	  		parent	active	$2a$10$cdWxkCQeVgDQoOuJCWllKuXfS7IzF3bii6H38Ed7ztLZ.TU4g7y4q
831	konduah andrews n		student	active	$2a$10$lPcjpkjbpDJUxUSUQEOtdObooIGSEhAl4onwG.tZfSVvCUKmqB68y
832	  mildred		parent	active	$2a$10$pcy6cGimzhVwgyGZav4xkOS7nE1aLuiF.8IDx4TYh9WdJbPRGcQ8y
833	  		parent	active	$2a$10$EIf0300HL49dj66wZWtzkeahuSQ95JVDgnZTic3ldQ.nfRoQrbQVe
834	nkansah zadock o d		student	active	$2a$10$0N1XSLU0XBePj3d09hQLPu/UO18PJA/0BFtIj9/CSDAxZ6sVtA9kW
835	  grace		parent	active	$2a$10$BQghvQq5uiOcZPDyjiHgO.GK71DcOnAZ5ygqLni179mypzYnOZYia
836	  		parent	active	$2a$10$FQDNFktaUhIrAi.o8NXWbOMQSiGonTSl5tccjE.ru.lk2FqQQFa1.
837	nyame rashvi junior		student	active	$2a$10$Q.D9yGm5VE7kDQs5pZ9SK.EeNWJUWFWpcQDLhn650JtqRbZS8Vjya
838	  vivian		parent	active	$2a$10$evo3HvF4stB.W3Fw8Z0oluE6rKVay9MCQh7Yn9Ay7Apnuz7d/BfhW
839	  		parent	active	$2a$10$48NSgr5XRf2c/Y6130tqZOvGuY2DtwQAZSibFvQw/eyQ9p9e6OqZG
840	okai sheriff nayar		student	active	$2a$10$FImV.Vw0S5eQeFF6IzDtxeSl5jL5aSuNMFbsmk1c/TplbGkfIfwSy
841	  okai		parent	active	$2a$10$eVPZYBZRml7GDMu4vzUZDeeZ1caTCtGK4kDq9YqjP8HhekZBC.0rG
842	  		parent	active	$2a$10$A4ElemwOM43DG4TskrFx6uIaBFKtMo5pTEtt/9Ac81kIeRcrmmQfW
843	opare kingsford edwin		student	active	$2a$10$nzjGZuaxCthVTITb6ch3PO8zQJ8Syuj5OpBd.RWKcwSYcc3BfTNtO
844	 opare mary		parent	active	$2a$10$XZeFwQFZN3To6Ai/SDWbX.USpfCht0OE4jEM/WOhSluhpaF3LsbCK
845	  		parent	active	$2a$10$pa1cMAZjXUbtQVZZJ2D/OOfnXeMPgpXp3V2iaEDU1d4Rq6hYCJqay
846	owusu evans 		student	active	$2a$10$PmmzyW1gWmFHsziU6E/niuK2mLClQLu1ynsr.2I5/bKz5CKdao0hW
847	  naana		parent	active	$2a$10$BKMfmoOMF0Nzwsc7lNe.Jedh1RwxMAieTwPvRDEF07swTZu05blYu
848	  		parent	active	$2a$10$Oq5LIUJW9cVU4kPnfmd3..qMkQL1beDhtNmbZOH70QRCjb.YbE00W
849	quansah ekow ayeyi		student	active	$2a$10$AGRD56VvLbfeSaM2uR/YqengDnQztC/9YVsBlUD7wgfRRgNnNDtui
850	  comfort		parent	active	$2a$10$vJiaAMkXlJwDe/tMVgviKezT0cFnEqwraIs6HEZFgcGZG5nnzyace
851	  		parent	active	$2a$10$jxlgSaAFxP3iz2wVh2IwF.w9RHErP4BT/jpLVptHQT573EAXGI18C
852	quansah nhyiraba kojo		student	active	$2a$10$jGmrJNbAqAUM6fRu/X6pU.Qthw28pfHM7ouLB5oMGF6Pf5la8/5B6
853	  ruth		parent	active	$2a$10$y4q0JGlCyyoy9s9W5hMJLexldR1ke.DX4c5kTlVfkQ5FsOBjTxvPK
854	  		parent	active	$2a$10$IAqrUAkOP.ubtFeDqBUo9Ou8yDUr7b43T0IpYhJdOMPAFVgTIfTli
855	sessah nhyiraba kojo		student	active	$2a$10$l27.onMGumVzpYPbrsnEFeHG3oLwKSrqnQXumAbJPrSDQl7KwP8ZC
856	  esther		parent	active	$2a$10$RkrPYrKPIJgv8DTxWYMajOcGRWG7fGpfIJ1POu4/z9sRzcAsi/GBW
857	  		parent	active	$2a$10$k9LEtxCVyXjCyKCFyIdn7OerJ9rt.2H1cYAVQzAQhBrf1So2x/2Oa
858	sey maxwell adu		student	active	$2a$10$dNJtUK5e1VmiXpuC6ezLE.kiRfDV5dgsKBbc22rqTtigxl039mAKy
859	 sam priscilla		parent	active	$2a$10$e9pADbtYnZMK3J6H1lkh9eSgtgm.gDy0RFVDBSe6B22FYo3ntXCuO
860	  		parent	active	$2a$10$g.GAgjib0N5WWrGeyk2rr.grperRWEmBqhKaQBl.rSs4DGB3/5TNi
861	akese lawrencia nana		student	active	$2a$10$QHQXKbdTSCOiUUi8lSIRE.oxTjgy1C0QZRYR9cu9oz.XHdEbw4TT.
862	 ewusi augustina		parent	active	$2a$10$YNUrCRiUWxN2A92/rtDea.3E2CUzb0q5rzscq.qXAyJBBGikt7nGu
863	 akese robert		parent	active	$2a$10$urj7yDJ/pOB1v3vkupnBmOVYDVerXkZxcQsfSAkRSY319.FAerbHC
864	amenuvor priscilla aku dela		student	active	$2a$10$pvCToavDbUH4EJlyJND8hefUxjvWIIEX7DO1Vt7AjrdV26ij0vkFq
865	 kumah millicent		parent	active	$2a$10$mHtDsi990bPogFd6/kOO9OkxfL6ZmR9PgYHyKycHW6rhD08FSqQC.
866	 komla amenuvor emmanuel		parent	active	$2a$10$Vo8OgZDt83NK855.j6U4t.074zkW/mQY0XV5DysSDl08N/1aZpuFu
867	amissah alisha bempong		student	active	$2a$10$aT3S0/c.xcNiRnkGKqDdi.eK5PuUg.yhxZwFi6LcjHLjWLwzw9GE2
868	 nkrumah emelia		parent	active	$2a$10$zFIm.yCdTcT0VUrsLGRPjuqWKoq99RbQezt.Kc/41/LDZeEdrUavq
869	 amissah bempong joseph		parent	active	$2a$10$fN9Qq70o7PPwdNbAynO2heAwxgKif85Obp1sC7eisFSARP.crD7vq
870	amissah alisha bempong		student	active	$2a$10$t/iXFibAx.Urwos50zMl4.9eutWF78znuFN.XZE7k6S3VfqPnVtPG
871	 nkrumah emelia		parent	active	$2a$10$z6Fo/aBinfILwp3yW9iTVevi3M1sqAQEM7ybsV2R9PVhu6mL52KcG
872	 amissah bempong josep		parent	active	$2a$10$r0e0SKEyLaO4V649okp8ZeRNAK/MWHM4OYIHlEm6ZGG.oNPAyqlaG
873	amissah pamela joy efua		student	active	$2a$10$lxEMLCr5ruhlWElB.4mSROkLWqATb.1LkLQ0qb3Nx34UBNbHe8/Le
874	 amissah ellen		parent	active	$2a$10$h6elv8K/UiZ8Ij2OLzFmnefyqeevEKtwwaxySypcJNww4ylZpRGU2
875	  		parent	active	$2a$10$tcVojKaN8bRbVc2whgtFGOTv/CPWEcOQgE1.BZvZZPxPkaYa/7nGa
876	anaafi comfort adom		student	active	$2a$10$UPq4q/ACMHILwcLgMhNvF.RsRJBzKXpmJM4I.CnYGRoWg3HAOpzH6
877	 talata chiana		parent	active	$2a$10$oSjTcWsU/ybTqVdY91XFo.5KshGh.DS7p.h74to2xVLiWNHvjUWJG
878	 anaafi isaac		parent	active	$2a$10$4cbEiHE30ZS7HSaH4M4Fj.kDs2/eFepeVD/FvCIG4NEr45FATqfYi
\.


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 30, true);


--
-- Name: balance_adjustment_log_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.balance_adjustment_log_log_id_seq', 2, true);


--
-- Name: class_items_class_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.class_items_class_item_id_seq', 15, true);


--
-- Name: classes_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_class_id_seq', 48, true);


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 1, true);


--
-- Name: evaluations_evaluation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluations_evaluation_id_seq', 5, true);


--
-- Name: events_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_event_id_seq', 5, true);


--
-- Name: expenses_expense_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expenses_expense_id_seq', 10, true);


--
-- Name: fee_collections_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fee_collections_collection_id_seq', 33, true);


--
-- Name: feeding_fee_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feeding_fee_payments_id_seq', 4, true);


--
-- Name: grading_scheme_grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grading_scheme_grade_id_seq', 11, true);


--
-- Name: health_incident_incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.health_incident_incident_id_seq', 12, true);


--
-- Name: inventory_items_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_items_inventory_id_seq', 3, true);


--
-- Name: invoices_invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoices_invoice_id_seq', 24, true);


--
-- Name: items_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_item_id_seq', 5, true);


--
-- Name: items_movement_supply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_movement_supply_id_seq', 3, true);


--
-- Name: items_supply_supply_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_supply_supply_id_seq', 20, true);


--
-- Name: notification_recipients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_recipients_id_seq', 26, true);


--
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 425, true);


--
-- Name: parents_parent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parents_parent_id_seq', 540, true);


--
-- Name: permissions_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_permission_id_seq', 70, true);


--
-- Name: procurements_procurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.procurements_procurement_id_seq', 8, true);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 5, true);


--
-- Name: rooms_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_room_id_seq', 1, false);


--
-- Name: semesters_semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semesters_semester_id_seq', 9, true);


--
-- Name: sms_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sms_logs_id_seq', 76, true);


--
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_staff_id_seq', 47, true);


--
-- Name: student_grades_grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_grades_grade_id_seq', 29, true);


--
-- Name: student_remarks_remark_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_remarks_remark_id_seq', 3, true);


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 273, true);


--
-- Name: subjects_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subjects_subject_id_seq', 24, true);


--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplier_id_seq', 3, true);


--
-- Name: timetable_timetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.timetable_timetable_id_seq', 31, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 878, true);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: balance_adjustment_log balance_adjustment_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_adjustment_log
    ADD CONSTRAINT balance_adjustment_log_pkey PRIMARY KEY (log_id);


--
-- Name: class_items class_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_items
    ADD CONSTRAINT class_items_pkey PRIMARY KEY (class_item_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: evaluations evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_pkey PRIMARY KEY (evaluation_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (expense_id);


--
-- Name: fee_collections fee_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_collections
    ADD CONSTRAINT fee_collections_pkey PRIMARY KEY (collection_id);


--
-- Name: feeding_fee_payments feeding_fee_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_fee_payments
    ADD CONSTRAINT feeding_fee_payments_pkey PRIMARY KEY (id);


--
-- Name: feeding_transport_fees feeding_transport_fees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_transport_fees
    ADD CONSTRAINT feeding_transport_fees_pkey PRIMARY KEY (student_id);


--
-- Name: grading_scheme grading_scheme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading_scheme
    ADD CONSTRAINT grading_scheme_pkey PRIMARY KEY (gradescheme_id);


--
-- Name: health_incident health_incident_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_incident
    ADD CONSTRAINT health_incident_pkey PRIMARY KEY (incident_id);


--
-- Name: inventory_class_semester inventory_class_semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_class_semester
    ADD CONSTRAINT inventory_class_semester_pkey PRIMARY KEY (inventory_id, class_id, semester_id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (inventory_id);


--
-- Name: invoice_class_semester invoice_class_semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_class_semester
    ADD CONSTRAINT invoice_class_semester_pkey PRIMARY KEY (invoice_id, class_id, semester_id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (invoice_id);


--
-- Name: items_movement items_movement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_movement
    ADD CONSTRAINT items_movement_pkey PRIMARY KEY (supply_id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- Name: items_supply items_supply_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_supply
    ADD CONSTRAINT items_supply_pkey PRIMARY KEY (supply_id);


--
-- Name: notification_recipients notification_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: parents parents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_pkey PRIMARY KEY (parent_id);


--
-- Name: permissions permissions_permission_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_permission_name_key UNIQUE (permission_name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- Name: procurements procurements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_pkey PRIMARY KEY (procurement_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_id);


--
-- Name: rooms rooms_room_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_name_key UNIQUE (room_name);


--
-- Name: semesters semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters
    ADD CONSTRAINT semesters_pkey PRIMARY KEY (semester_id);


--
-- Name: sms_logs sms_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms_logs
    ADD CONSTRAINT sms_logs_pkey PRIMARY KEY (id);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- Name: student_grades student_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT student_grades_pkey PRIMARY KEY (grade_id);


--
-- Name: student_parent student_parent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_parent
    ADD CONSTRAINT student_parent_pkey PRIMARY KEY (student_id, parent_id);


--
-- Name: student_remarks student_remarks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_remarks
    ADD CONSTRAINT student_remarks_pkey PRIMARY KEY (remark_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (subject_id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_id);


--
-- Name: timetable timetable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_pkey PRIMARY KEY (timetable_id);


--
-- Name: attendance unique_attendance_record; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT unique_attendance_record UNIQUE (student_id, class_id, attendance_date);


--
-- Name: class_items unique_class_item_semester; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_items
    ADD CONSTRAINT unique_class_item_semester UNIQUE (class_id, item_id, semester_id);


--
-- Name: classes unique_class_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT unique_class_name UNIQUE (class_name);


--
-- Name: staff unique_staff_user_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT unique_staff_user_id UNIQUE (user_id);


--
-- Name: student_grades unique_student_grade; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT unique_student_grade UNIQUE (student_id, subject_id, class_id, semester_id);


--
-- Name: subjects unique_subject_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT unique_subject_name UNIQUE (subject_name);


--
-- Name: user_health_record user_health_record_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_health_record
    ADD CONSTRAINT user_health_record_pkey PRIMARY KEY (user_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: departments update_departments_modtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_departments_modtime BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: attendance attendance_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: attendance attendance_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: attendance attendance_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(user_id);


--
-- Name: attendance attendance_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: balance_adjustment_log balance_adjustment_log_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_adjustment_log
    ADD CONSTRAINT balance_adjustment_log_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: class_items class_items_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_items
    ADD CONSTRAINT class_items_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: class_items class_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_items
    ADD CONSTRAINT class_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(item_id);


--
-- Name: class_items class_items_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_items
    ADD CONSTRAINT class_items_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: class_items class_items_supplied_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_items
    ADD CONSTRAINT class_items_supplied_by_fkey FOREIGN KEY (supplied_by) REFERENCES public.staff(user_id);


--
-- Name: classes classes_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: evaluations evaluations_evaluatee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_evaluatee_id_fkey FOREIGN KEY (evaluatee_id) REFERENCES public.staff(staff_id) ON DELETE CASCADE;


--
-- Name: evaluations evaluations_evaluator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluations
    ADD CONSTRAINT evaluations_evaluator_id_fkey FOREIGN KEY (evaluator_id) REFERENCES public.staff(user_id) ON DELETE CASCADE;


--
-- Name: events events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: expenses expenses_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: expenses expenses_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id);


--
-- Name: expenses expenses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: fee_collections fee_collections_received_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_collections
    ADD CONSTRAINT fee_collections_received_by_fkey FOREIGN KEY (received_by) REFERENCES public.users(user_id);


--
-- Name: fee_collections fee_collections_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_collections
    ADD CONSTRAINT fee_collections_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: feeding_fee_payments feeding_fee_payments_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_fee_payments
    ADD CONSTRAINT feeding_fee_payments_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: feeding_fee_payments feeding_fee_payments_collected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_fee_payments
    ADD CONSTRAINT feeding_fee_payments_collected_by_fkey FOREIGN KEY (collected_by) REFERENCES public.staff(user_id);


--
-- Name: feeding_fee_payments feeding_fee_payments_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_fee_payments
    ADD CONSTRAINT feeding_fee_payments_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: feeding_fee_payments feeding_fee_payments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_fee_payments
    ADD CONSTRAINT feeding_fee_payments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: feeding_transport_fees feeding_transport_fees_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_transport_fees
    ADD CONSTRAINT feeding_transport_fees_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: departments fk_head_of_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT fk_head_of_department FOREIGN KEY (head_of_department) REFERENCES public.staff(staff_id);


--
-- Name: health_incident health_incident_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.health_incident
    ADD CONSTRAINT health_incident_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: inventory_class_semester inventory_class_semester_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_class_semester
    ADD CONSTRAINT inventory_class_semester_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: inventory_class_semester inventory_class_semester_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_class_semester
    ADD CONSTRAINT inventory_class_semester_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.inventory_items(inventory_id);


--
-- Name: inventory_class_semester inventory_class_semester_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_class_semester
    ADD CONSTRAINT inventory_class_semester_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: invoice_class_semester invoice_class_semester_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_class_semester
    ADD CONSTRAINT invoice_class_semester_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: invoice_class_semester invoice_class_semester_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_class_semester
    ADD CONSTRAINT invoice_class_semester_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(invoice_id);


--
-- Name: invoice_class_semester invoice_class_semester_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_class_semester
    ADD CONSTRAINT invoice_class_semester_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: items_movement items_movement_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_movement
    ADD CONSTRAINT items_movement_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(item_id);


--
-- Name: items_movement items_movement_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_movement
    ADD CONSTRAINT items_movement_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: items_movement items_movement_supplied_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_movement
    ADD CONSTRAINT items_movement_supplied_by_fkey FOREIGN KEY (supplied_by) REFERENCES public.staff(user_id);


--
-- Name: items_supply items_supply_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_supply
    ADD CONSTRAINT items_supply_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: items_supply items_supply_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_supply
    ADD CONSTRAINT items_supply_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(item_id);


--
-- Name: items_supply items_supply_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_supply
    ADD CONSTRAINT items_supply_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: items_supply items_supply_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_supply
    ADD CONSTRAINT items_supply_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: items_supply items_supply_supplied_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_supply
    ADD CONSTRAINT items_supply_supplied_by_fkey FOREIGN KEY (supplied_by) REFERENCES public.staff(staff_id);


--
-- Name: notification_recipients notification_recipients_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(notification_id);


--
-- Name: notifications notifications_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(user_id);


--
-- Name: parents parents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: procurements procurements_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(item_id);


--
-- Name: procurements procurements_received_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_received_by_fkey FOREIGN KEY (received_by) REFERENCES public.staff(staff_id);


--
-- Name: procurements procurements_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurements
    ADD CONSTRAINT procurements_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id);


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(permission_id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: sms_logs sms_logs_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms_logs
    ADD CONSTRAINT sms_logs_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(user_id);


--
-- Name: staff staff_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: student_grades student_grades_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT student_grades_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: student_grades student_grades_gradescheme_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT student_grades_gradescheme_id_fkey FOREIGN KEY (gradescheme_id) REFERENCES public.grading_scheme(gradescheme_id);


--
-- Name: student_grades student_grades_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT student_grades_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: student_grades student_grades_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT student_grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: student_grades student_grades_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT student_grades_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id);


--
-- Name: student_grades student_grades_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_grades
    ADD CONSTRAINT student_grades_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.staff(user_id);


--
-- Name: student_parent student_parent_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_parent
    ADD CONSTRAINT student_parent_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.parents(parent_id);


--
-- Name: student_parent student_parent_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_parent
    ADD CONSTRAINT student_parent_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: student_remarks student_remarks_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_remarks
    ADD CONSTRAINT student_remarks_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: student_remarks student_remarks_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_remarks
    ADD CONSTRAINT student_remarks_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: student_remarks student_remarks_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_remarks
    ADD CONSTRAINT student_remarks_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- Name: student_remarks student_remarks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_remarks
    ADD CONSTRAINT student_remarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: students students_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: students students_class_promoted_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_class_promoted_to_fkey FOREIGN KEY (class_promoted_to) REFERENCES public.classes(class_id);


--
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: timetable timetable_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(class_id);


--
-- Name: timetable timetable_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(room_id);


--
-- Name: timetable timetable_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id);


--
-- Name: timetable timetable_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id);


--
-- Name: timetable timetable_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.staff(staff_id);


--
-- Name: user_health_record user_health_record_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_health_record
    ADD CONSTRAINT user_health_record_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

