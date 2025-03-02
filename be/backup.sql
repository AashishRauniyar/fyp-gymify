--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

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
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: difficulty_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.difficulty_level AS ENUM (
    'Easy',
    'Intermediate',
    'Hard'
);


ALTER TYPE public.difficulty_level OWNER TO postgres;

--
-- Name: fitness_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.fitness_level AS ENUM (
    'Beginner',
    'Intermediate',
    'Advanced',
    'Athlete'
);


ALTER TYPE public.fitness_level OWNER TO postgres;

--
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'Male',
    'Female',
    'Other'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- Name: goal_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.goal_type AS ENUM (
    'Weight Loss',
    'Muscle Gain',
    'Endurance',
    'Maintenance',
    'Flexibility'
);


ALTER TYPE public.goal_type OWNER TO postgres;

--
-- Name: meal_time; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.meal_time AS ENUM (
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack'
);


ALTER TYPE public.meal_time OWNER TO postgres;

--
-- Name: membership_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.membership_status AS ENUM (
    'Active',
    'Expired',
    'Cancelled'
);


ALTER TYPE public.membership_status OWNER TO postgres;

--
-- Name: payment_method; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method AS ENUM (
    'Khalti',
    'Cash'
);


ALTER TYPE public.payment_method OWNER TO postgres;

--
-- Name: payment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status AS ENUM (
    'Paid',
    'Pending',
    'Failed'
);


ALTER TYPE public.payment_status OWNER TO postgres;

--
-- Name: plan_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.plan_type AS ENUM (
    'Monthly',
    'Yearly',
    'Quaterly'
);


ALTER TYPE public.plan_type OWNER TO postgres;

--
-- Name: role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role AS ENUM (
    'Member',
    'Trainer',
    'Admin'
);


ALTER TYPE public.role OWNER TO postgres;

--
-- Name: supported_exercises; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.supported_exercises AS ENUM (
    'Squat',
    'Bench Press',
    'Deadlift'
);


ALTER TYPE public.supported_exercises OWNER TO postgres;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'Member',
    'Trainer',
    'Admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    attendance_id integer NOT NULL,
    user_id integer,
    gym_id integer,
    attendance_date date NOT NULL
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


ALTER SEQUENCE public.attendance_attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_attendance_id_seq OWNED BY public.attendance.attendance_id;


--
-- Name: chatconversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chatconversations (
    chat_id integer NOT NULL,
    user_id integer,
    trainer_id integer,
    last_message character varying(255),
    last_message_timestamp timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.chatconversations OWNER TO postgres;

--
-- Name: chatconversations_chat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chatconversations_chat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chatconversations_chat_id_seq OWNER TO postgres;

--
-- Name: chatconversations_chat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chatconversations_chat_id_seq OWNED BY public.chatconversations.chat_id;


--
-- Name: chatmessages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chatmessages (
    message_id integer NOT NULL,
    chat_id integer,
    sender_id integer,
    message_content json,
    sent_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    is_read boolean DEFAULT false
);


ALTER TABLE public.chatmessages OWNER TO postgres;

--
-- Name: chatmessages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chatmessages_message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chatmessages_message_id_seq OWNER TO postgres;

--
-- Name: chatmessages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chatmessages_message_id_seq OWNED BY public.chatmessages.message_id;


--
-- Name: customworkoutexercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customworkoutexercises (
    custom_workout_exercise_id integer NOT NULL,
    custom_workout_id integer,
    exercise_id integer,
    sets integer NOT NULL,
    reps integer NOT NULL,
    duration numeric(5,2) NOT NULL
);


ALTER TABLE public.customworkoutexercises OWNER TO postgres;

--
-- Name: customworkoutexercises_custom_workout_exercise_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customworkoutexercises_custom_workout_exercise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customworkoutexercises_custom_workout_exercise_id_seq OWNER TO postgres;

--
-- Name: customworkoutexercises_custom_workout_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customworkoutexercises_custom_workout_exercise_id_seq OWNED BY public.customworkoutexercises.custom_workout_exercise_id;


--
-- Name: customworkouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customworkouts (
    custom_workout_id integer NOT NULL,
    user_id integer,
    custom_workout_name character varying(100) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customworkouts OWNER TO postgres;

--
-- Name: customworkouts_custom_workout_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customworkouts_custom_workout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customworkouts_custom_workout_id_seq OWNER TO postgres;

--
-- Name: customworkouts_custom_workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customworkouts_custom_workout_id_seq OWNED BY public.customworkouts.custom_workout_id;


--
-- Name: dietlogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dietlogs (
    log_id integer NOT NULL,
    user_id integer,
    diet_plan_id integer,
    meal_id integer,
    consumed_calories numeric(5,2),
    custom_meal character varying(100),
    notes text,
    log_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dietlogs OWNER TO postgres;

--
-- Name: dietlogs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dietlogs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dietlogs_log_id_seq OWNER TO postgres;

--
-- Name: dietlogs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dietlogs_log_id_seq OWNED BY public.dietlogs.log_id;


--
-- Name: dietplans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dietplans (
    diet_plan_id integer NOT NULL,
    user_id integer,
    trainer_id integer,
    calorie_goal numeric(6,2),
    goal_type public.goal_type NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dietplans OWNER TO postgres;

--
-- Name: dietplans_diet_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dietplans_diet_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dietplans_diet_plan_id_seq OWNER TO postgres;

--
-- Name: dietplans_diet_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dietplans_diet_plan_id_seq OWNED BY public.dietplans.diet_plan_id;


--
-- Name: exercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exercises (
    exercise_id integer NOT NULL,
    exercise_name character varying(100) NOT NULL,
    calories_burned_per_minute numeric(5,2) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    description text NOT NULL,
    image_url character varying(255),
    target_muscle_group text NOT NULL,
    video_url character varying(255),
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.exercises OWNER TO postgres;

--
-- Name: exercises_exercise_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exercises_exercise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exercises_exercise_id_seq OWNER TO postgres;

--
-- Name: exercises_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exercises_exercise_id_seq OWNED BY public.exercises.exercise_id;


--
-- Name: gym; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gym (
    gym_id integer NOT NULL,
    gym_name character varying(100) NOT NULL,
    location character varying(255) NOT NULL,
    contact_number character varying(20) NOT NULL,
    admin_id integer,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.gym OWNER TO postgres;

--
-- Name: gym_gym_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gym_gym_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gym_gym_id_seq OWNER TO postgres;

--
-- Name: gym_gym_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gym_gym_id_seq OWNED BY public.gym.gym_id;


--
-- Name: meals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meals (
    meal_id integer NOT NULL,
    diet_plan_id integer,
    meal_name character varying(100) NOT NULL,
    meal_time public.meal_time NOT NULL,
    calories numeric(5,2) NOT NULL,
    description text,
    macronutrients character varying(100),
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.meals OWNER TO postgres;

--
-- Name: meals_meal_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meals_meal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meals_meal_id_seq OWNER TO postgres;

--
-- Name: meals_meal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meals_meal_id_seq OWNED BY public.meals.meal_id;


--
-- Name: membership_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membership_plan (
    plan_id integer NOT NULL,
    plan_type public.plan_type NOT NULL,
    price numeric(10,2) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.membership_plan OWNER TO postgres;

--
-- Name: membership_plan_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.membership_plan_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membership_plan_plan_id_seq OWNER TO postgres;

--
-- Name: membership_plan_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membership_plan_plan_id_seq OWNED BY public.membership_plan.plan_id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memberships (
    membership_id integer NOT NULL,
    user_id integer,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status public.membership_status NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    plan_id integer NOT NULL
);


ALTER TABLE public.memberships OWNER TO postgres;

--
-- Name: memberships_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.memberships_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.memberships_membership_id_seq OWNER TO postgres;

--
-- Name: memberships_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memberships_membership_id_seq OWNED BY public.memberships.membership_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    membership_id integer,
    user_id integer,
    price numeric(10,2) NOT NULL,
    payment_method public.payment_method NOT NULL,
    payment_date date NOT NULL,
    payment_status public.payment_status NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    transaction_id character varying(100) NOT NULL
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: personal_bests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_bests (
    personal_best_id integer NOT NULL,
    user_id integer NOT NULL,
    exercise public.supported_exercises NOT NULL,
    weight numeric(6,2) NOT NULL,
    reps integer NOT NULL,
    achieved_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.personal_bests OWNER TO postgres;

--
-- Name: personal_bests_personal_best_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_bests_personal_best_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_bests_personal_best_id_seq OWNER TO postgres;

--
-- Name: personal_bests_personal_best_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_bests_personal_best_id_seq OWNED BY public.personal_bests.personal_best_id;


--
-- Name: subscription_changes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription_changes (
    change_id integer NOT NULL,
    membership_id integer NOT NULL,
    previous_plan integer NOT NULL,
    new_plan integer NOT NULL,
    change_date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    action text NOT NULL
);


ALTER TABLE public.subscription_changes OWNER TO postgres;

--
-- Name: subscription_changes_change_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscription_changes_change_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscription_changes_change_id_seq OWNER TO postgres;

--
-- Name: subscription_changes_change_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscription_changes_change_id_seq OWNED BY public.subscription_changes.change_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    user_name character varying(100) NOT NULL,
    full_name character varying(100) NOT NULL,
    address character varying(255),
    height numeric NOT NULL,
    current_weight numeric NOT NULL,
    gender public.gender NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone_number character varying(20) NOT NULL,
    role public.role NOT NULL,
    fitness_level public.fitness_level NOT NULL,
    goal_type public.goal_type NOT NULL,
    card_number character varying(50),
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    allergies character varying(255),
    calorie_goals numeric(6,2),
    profile_image character varying(255),
    reset_token text,
    reset_token_expiry timestamp(3) without time zone,
    birthdate timestamp(3) without time zone
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


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: workoutexercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workoutexercises (
    workout_exercise_id integer NOT NULL,
    workout_id integer,
    exercise_id integer,
    sets integer NOT NULL,
    reps integer NOT NULL,
    duration numeric(5,2) NOT NULL
);


ALTER TABLE public.workoutexercises OWNER TO postgres;

--
-- Name: workoutexercises_workout_exercise_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workoutexercises_workout_exercise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workoutexercises_workout_exercise_id_seq OWNER TO postgres;

--
-- Name: workoutexercises_workout_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workoutexercises_workout_exercise_id_seq OWNED BY public.workoutexercises.workout_exercise_id;


--
-- Name: workoutexerciseslogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workoutexerciseslogs (
    log_id integer NOT NULL,
    workout_log_id integer,
    exercise_id integer,
    skipped boolean DEFAULT false,
    exercise_duration numeric(5,2),
    rest_duration numeric(5,2)
);


ALTER TABLE public.workoutexerciseslogs OWNER TO postgres;

--
-- Name: workoutexerciseslogs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workoutexerciseslogs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workoutexerciseslogs_log_id_seq OWNER TO postgres;

--
-- Name: workoutexerciseslogs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workoutexerciseslogs_log_id_seq OWNED BY public.workoutexerciseslogs.log_id;


--
-- Name: workoutlogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workoutlogs (
    log_id integer NOT NULL,
    user_id integer,
    workout_id integer,
    workout_date timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    calories_burned numeric(10,2),
    performance_notes text,
    total_duration numeric(5,2)
);


ALTER TABLE public.workoutlogs OWNER TO postgres;

--
-- Name: workoutlogs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workoutlogs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workoutlogs_log_id_seq OWNER TO postgres;

--
-- Name: workoutlogs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workoutlogs_log_id_seq OWNED BY public.workoutlogs.log_id;


--
-- Name: workouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workouts (
    workout_id integer NOT NULL,
    user_id integer,
    workout_name character varying(100) NOT NULL,
    description text NOT NULL,
    target_muscle_group character varying(50) NOT NULL,
    difficulty public.difficulty_level NOT NULL,
    trainer_id integer,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    fitness_level public.fitness_level DEFAULT 'Beginner'::public.fitness_level NOT NULL,
    goal_type public.goal_type DEFAULT 'Weight Loss'::public.goal_type NOT NULL,
    workout_image character varying(255)
);


ALTER TABLE public.workouts OWNER TO postgres;

--
-- Name: workouts_workout_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workouts_workout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workouts_workout_id_seq OWNER TO postgres;

--
-- Name: workouts_workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workouts_workout_id_seq OWNED BY public.workouts.workout_id;


--
-- Name: attendance attendance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendance_attendance_id_seq'::regclass);


--
-- Name: chatconversations chat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations ALTER COLUMN chat_id SET DEFAULT nextval('public.chatconversations_chat_id_seq'::regclass);


--
-- Name: chatmessages message_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessages ALTER COLUMN message_id SET DEFAULT nextval('public.chatmessages_message_id_seq'::regclass);


--
-- Name: customworkoutexercises custom_workout_exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises ALTER COLUMN custom_workout_exercise_id SET DEFAULT nextval('public.customworkoutexercises_custom_workout_exercise_id_seq'::regclass);


--
-- Name: customworkouts custom_workout_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkouts ALTER COLUMN custom_workout_id SET DEFAULT nextval('public.customworkouts_custom_workout_id_seq'::regclass);


--
-- Name: dietlogs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs ALTER COLUMN log_id SET DEFAULT nextval('public.dietlogs_log_id_seq'::regclass);


--
-- Name: dietplans diet_plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans ALTER COLUMN diet_plan_id SET DEFAULT nextval('public.dietplans_diet_plan_id_seq'::regclass);


--
-- Name: exercises exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises ALTER COLUMN exercise_id SET DEFAULT nextval('public.exercises_exercise_id_seq'::regclass);


--
-- Name: gym gym_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gym ALTER COLUMN gym_id SET DEFAULT nextval('public.gym_gym_id_seq'::regclass);


--
-- Name: meals meal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals ALTER COLUMN meal_id SET DEFAULT nextval('public.meals_meal_id_seq'::regclass);


--
-- Name: membership_plan plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membership_plan ALTER COLUMN plan_id SET DEFAULT nextval('public.membership_plan_plan_id_seq'::regclass);


--
-- Name: memberships membership_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships ALTER COLUMN membership_id SET DEFAULT nextval('public.memberships_membership_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: personal_bests personal_best_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests ALTER COLUMN personal_best_id SET DEFAULT nextval('public.personal_bests_personal_best_id_seq'::regclass);


--
-- Name: subscription_changes change_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_changes ALTER COLUMN change_id SET DEFAULT nextval('public.subscription_changes_change_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: workoutexercises workout_exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises ALTER COLUMN workout_exercise_id SET DEFAULT nextval('public.workoutexercises_workout_exercise_id_seq'::regclass);


--
-- Name: workoutexerciseslogs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs ALTER COLUMN log_id SET DEFAULT nextval('public.workoutexerciseslogs_log_id_seq'::regclass);


--
-- Name: workoutlogs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs ALTER COLUMN log_id SET DEFAULT nextval('public.workoutlogs_log_id_seq'::regclass);


--
-- Name: workouts workout_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts ALTER COLUMN workout_id SET DEFAULT nextval('public.workouts_workout_id_seq'::regclass);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
ff7062f0-adc0-420d-9711-43adf2696eae	e04d48af3ed6fc733d37f48f76340385cafc7c1c19459a3be62bf75fd8ad60c3	2024-12-04 00:04:59.54391+05:45	20241203181959_changed_age_to_birthdate_in_users_table	\N	\N	2024-12-04 00:04:59.531527+05:45	1
2a06cfb8-fb8c-42d9-94cc-7a840109dfa5	ee7805838826e6489fe3f466a958dc7c6882d852fe70dd69703c5e6022b6506d	2024-11-26 00:21:20.295625+05:45	20241111073636_init	\N	\N	2024-11-26 00:21:20.074797+05:45	1
8f780078-16a4-4428-9f1e-9f3f53fa7e1a	ec673348243204fef1472b1ca6992bf0b6f304232cced783a8c81e50d6ae33c3	2024-11-26 00:21:20.303586+05:45	20241111174807_exercise_table_changes	\N	\N	2024-11-26 00:21:20.296351+05:45	1
3c564a04-31ba-4f32-9417-c4c271ecfb54	c97a24f916b1022c774255d5d7cc93604c24c620fdb19fbb26a4ac768becac78	2024-11-26 00:21:20.307778+05:45	20241111183505_add_updated_at_column	\N	\N	2024-11-26 00:21:20.304414+05:45	1
a302e130-4fd7-4c69-8bcc-89e803ddc3f5	b1385f7e08aab6f7446a75a967fa5518c7fa97d7dcf49b87ac100b9a99b6cd84	2024-12-08 12:43:03.539267+05:45	20241208065803_added_workout_image_in_schema	\N	\N	2024-12-08 12:43:03.533263+05:45	1
150f5b34-233e-411d-83c3-2552f48c5085	0f611f446830924da8c387f80b995d058902d7747ca944a34fc83745040ae4c2	2024-11-26 00:21:20.32666+05:45	20241111183607_added_updated_to_exercise	\N	\N	2024-11-26 00:21:20.30855+05:45	1
8440c6c7-0774-40ea-aec1-956c158c35b9	2d55d7fd879de2af00771cf26792ced6dd0ed0b5d0407acca38debc934f0f987	2024-11-26 00:21:20.354189+05:45	20241112154203_added_workout_logs	\N	\N	2024-11-26 00:21:20.32754+05:45	1
8c34238b-8af4-4984-be73-7b5dd674969d	96dba3eeaad45b800df3ea6f5af7cae813eda03835c74cd35daa3a35efcd1a7e	2024-11-26 00:21:20.357829+05:45	20241113044909_added_alleries_and_calorie_goals	\N	\N	2024-11-26 00:21:20.355108+05:45	1
fffa068c-2602-42d9-a293-cd6af980cc03	15f25aba0566f3597d72a733afc4463eb80bc96a0b51f1e186b8bdd77131f2ce	2024-12-12 12:34:37.126631+05:45	20241212064937_add_personal_best_table	\N	\N	2024-12-12 12:34:37.091687+05:45	1
45e7e9aa-bcf6-43aa-aceb-5815fccf21fa	09396e70247b798995949aeeb2c16503065571341c69a114ba290c12fa13e74d	2024-11-26 00:21:20.36126+05:45	20241118043614_added_missing_profile_image	\N	\N	2024-11-26 00:21:20.358526+05:45	1
4a40340a-fb20-404a-a344-89e8d1c1c4a2	ae839bb5007ee480a00b939517546a620e6cc586f1368c84593a0b689c4589ac	2024-11-26 00:21:20.365552+05:45	20241119062737_added_reset_password_fields	\N	\N	2024-11-26 00:21:20.362299+05:45	1
206477b5-1e7e-4885-ab11-4b6fb5c0c983	a80c7945e92ea50db9b6652400684d3329f4a7ce8c2cb3e5c7f3929dd90d8c89	2024-11-26 00:21:20.38549+05:45	20241120181422_added	\N	\N	2024-11-26 00:21:20.366563+05:45	1
5537cf72-d886-4584-bd6c-41f9597e6137	0669ef38692d3612a22e52418641337e0ad42d93c58fb8dea0237afdc8d9ef1f	2024-12-15 09:37:54.191762+05:45	20241215035254_changes_in_logs	\N	\N	2024-12-15 09:37:54.184183+05:45	1
b537cfcd-b3f5-44a1-9149-705d048f5bd0	b726ea43a1c7ee21e6d6df8c1affa71af084914f0ce78a4a4a5675bf0672d4d8	2024-11-26 00:21:20.402428+05:45	20241120182434_added_subscription_changes_and_fixed_membership	\N	\N	2024-11-26 00:21:20.386456+05:45	1
165e823a-d072-4236-b0ab-b64eff2ccf0f	e255e35a37948add5022fc54c878a0bfac478d6b1790e8abdf50e9f58be823fa	2024-11-26 00:21:20.407152+05:45	20241125183339_update_workoutexerciseslogs	\N	\N	2024-11-26 00:21:20.403669+05:45	1
74aa2fd7-e495-4fcf-a53f-24892f99c400	34a192eb492e51ce9595d8edf68ef416d7c4ce07938514de90147765631f6d7c	\N	20241222034846_add_supported_exercise_id	A migration failed to apply. New migrations cannot be applied before the error is recovered from. Read more about how to resolve migration issues in a production database: https://pris.ly/d/migrate-resolve\n\nMigration name: 20241222034846_add_supported_exercise_id\n\nDatabase error code: 23502\n\nDatabase error:\nERROR: column "supported_exercise_id" of relation "personal_bests" contains null values\n\nDbError { severity: "ERROR", parsed_severity: Some(Error), code: SqlState(E23502), message: "column \\"supported_exercise_id\\" of relation \\"personal_bests\\" contains null values", detail: None, hint: None, position: None, where_: None, schema: Some("public"), table: Some("personal_bests"), column: Some("supported_exercise_id"), datatype: None, constraint: None, file: Some("tablecmds.c"), line: Some(6093), routine: Some("ATRewriteTable") }\n\n   0: sql_schema_connector::apply_migration::apply_script\n           with migration_name="20241222034846_add_supported_exercise_id"\n             at schema-engine\\connectors\\sql-schema-connector\\src\\apply_migration.rs:106\n   1: schema_core::commands::apply_migrations::Applying migration\n           with migration_name="20241222034846_add_supported_exercise_id"\n             at schema-engine\\core\\src\\commands\\apply_migrations.rs:91\n   2: schema_core::state::ApplyMigrations\n             at schema-engine\\core\\src\\state.rs:226	\N	2024-12-22 09:34:42.456975+05:45	0
a0870415-74ca-4ab7-9f87-bab93f757930	77854bb9cdc9c4ed7e04bf7b329b7788e34ca5050fc80a416fd999ab951c7663	2024-12-03 23:52:15.432964+05:45	20241203180715_add_goal_type_and_fitness_level_to_workouts	\N	\N	2024-12-03 23:52:15.407567+05:45	1
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (attendance_id, user_id, gym_id, attendance_date) FROM stdin;
\.


--
-- Data for Name: chatconversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatconversations (chat_id, user_id, trainer_id, last_message, last_message_timestamp) FROM stdin;
\.


--
-- Data for Name: chatmessages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatmessages (message_id, chat_id, sender_id, message_content, sent_at, is_read) FROM stdin;
\.


--
-- Data for Name: customworkoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkoutexercises (custom_workout_exercise_id, custom_workout_id, exercise_id, sets, reps, duration) FROM stdin;
\.


--
-- Data for Name: customworkouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkouts (custom_workout_id, user_id, custom_workout_name, created_at) FROM stdin;
1	5	Sunday Routine	2024-11-27 08:57:33.244
2	5	Anil special abs workout	2024-11-27 09:07:10.349
\.


--
-- Data for Name: dietlogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dietlogs (log_id, user_id, diet_plan_id, meal_id, consumed_calories, custom_meal, notes, log_date) FROM stdin;
\.


--
-- Data for Name: dietplans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dietplans (diet_plan_id, user_id, trainer_id, calorie_goal, goal_type, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercises (exercise_id, exercise_name, calories_burned_per_minute, created_at, description, image_url, target_muscle_group, video_url, updated_at) FROM stdin;
32	pull ups	20.00	2024-12-13 08:16:42.646	great for full body specially back	https://res.cloudinary.com/dqcdosfch/image/upload/v1734077793/exercise_images/hkgqrnlofc07lnhhjhvt.jpg	Back	https://res.cloudinary.com/dqcdosfch/video/upload/v1734077800/exercise_videos/ipozcknrseuhu2xwxmn0.mp4	2024-12-13 08:16:42.659
31	Situps	5.50	2024-12-12 13:32:41.303	A core exercise that targets the lower abdominals and hip flexors.	https://res.cloudinary.com/dqcdosfch/image/upload/v1734010352/exercise_images/tjayp6rafksfrydndbs9.webp	Core, Hip Flexors	https://res.cloudinary.com/dqcdosfch/video/upload/v1734010360/exercise_videos/rsbjzb29z5hxa4gmeq1h.mp4	2024-12-15 20:24:43.41
33	Diamond Pushups	100.00	2024-12-17 02:22:39.948	very nice for wide back and stronger body	https://res.cloudinary.com/dqcdosfch/image/upload/v1734402123/exercise_images/gqgzqwwzxazvqveyc8b6.jpg	Chest	https://res.cloudinary.com/dqcdosfch/video/upload/v1734402156/exercise_videos/hfvj1sfzqxtj5jc2horn.mp4	2024-12-17 02:22:39.965
\.


--
-- Data for Name: gym; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gym (gym_id, gym_name, location, contact_number, admin_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: meals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meals (meal_id, diet_plan_id, meal_name, meal_time, calories, description, macronutrients, created_at) FROM stdin;
\.


--
-- Data for Name: membership_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membership_plan (plan_id, plan_type, price, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memberships (membership_id, user_id, start_date, end_date, status, created_at, updated_at, plan_id) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, membership_id, user_id, price, payment_method, payment_date, payment_status, created_at, transaction_id) FROM stdin;
\.


--
-- Data for Name: personal_bests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_bests (personal_best_id, user_id, exercise, weight, reps, achieved_at) FROM stdin;
\.


--
-- Data for Name: subscription_changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_changes (change_id, membership_id, previous_plan, new_plan, change_date, action) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, user_name, full_name, address, height, current_weight, gender, email, password, phone_number, role, fitness_level, goal_type, card_number, created_at, updated_at, allergies, calorie_goals, profile_image, reset_token, reset_token_expiry, birthdate) FROM stdin;
1	aashish	aashish rauniyar	pkr	163	62	Male	aashish@gmail.com	$2a$10$ckHoKRvn.xqPeskvkJroAuXTS/hVS39/0a9Q5EZP2FrG.A6Bg8YK2	9802145987	Trainer	Beginner	Weight Loss	1	2024-11-25 18:37:44.103	2024-11-25 18:37:44.103	nothing	2500.00	\N	\N	\N	\N
2	acis	acis	sdf	163	64	Male	acis@gmail.com	$2a$10$FaH5JUWnNzQ8M5NNjdtmYO3Ek3Z5.n9MPjJ019cqtg1qTc6Tbd9Ky	7896541236	Trainer	Beginner	Weight Loss	2	2024-11-25 18:39:10.258	2024-11-25 18:39:10.258	nothjing	20.00	\N	\N	\N	\N
3	abishek	abishek	Bake	165	50	Male	abishek@gmail.com	$2a$10$c9lijIp7UA1MyInB8uxCJOlIgnvqqaSEQGMwA3WuVQzxHOiZVl16i	9874563215	Member	Beginner	Weight Loss	3	2024-11-26 16:10:33.065	2024-11-26 16:10:33.065	nothing	3000.00	\N	\N	\N	\N
4	rahul	rahul	Bake	165	50	Male	rahul@gmail.com	$2a$10$mQpdo5c62bZMvWvy340tqOHi5M.ZzNOsJ/oFcFyCBfs0SFj2psPWe	9874563225	Member	Beginner	Weight Loss	3	2024-11-26 16:13:38.81	2024-11-26 16:13:38.81	nothing	3000.00	\N	\N	\N	\N
6	admin	admin	Pokhara	150	60	Male	admin@gmail.com	$2a$10$9hSAzyaypzCPL6.xY2vZluaPR8o5rl0M1OIVxeorXlttu17bYbcJq	4444555526	Admin	Beginner	Weight Loss	5	2024-11-26 16:20:47.736	2024-11-26 16:20:47.736	nop	200.00	\N	\N	\N	\N
5	trainer	Testser	1234 Test Street	180	75	Male	trainer@gmail.com	$2a$10$IN1PpXz2XiBCXTb/YhgG2eVLPHxHLpjMzregoWjeMmd8SBTQh7b3i	11345987890	Trainer	Intermediate	Weight Loss	4	2024-11-26 16:20:20.751	2024-12-01 02:19:13.965	nothing1	200.00	\N	\N	\N	\N
7	krisha	krisha Rauniyar	1234 Test Street	180	75	Male	krisha@gmail.com	$2a$10$r3.MfV2j8iZXrgFVtnpxi.a2QuxPkZNPcLpPAjUFiyHdUKGh8epeO	1122554477	Member	Intermediate	Weight Loss	\N	2024-12-01 15:50:59.621	2024-12-01 15:53:01.805	nothing1	5300.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1733068257/profile_images/edfaslxfezlvxfbgfcvb.jpg	\N	\N	\N
8	ram	ranm	ram@gmail.com	12	12	Male	ram@gmail.com	$2a$10$gIKJDTz13/KKuFvsodRLM.FNs.fFIcj7g7AH6e25Ccdk0r1Xv31A2	9806754607	Member	Beginner	Weight Loss	167	2024-12-02 11:53:39.512	2024-12-02 11:53:39.512	NO	1200.00	\N	\N	\N	\N
9	johndoe	John Doe	123 Main St, City, Country	180.5	75.3	Male	johndoe@example.com	$2a$10$yMAlrA2UjU9YD9v.V.7CWO7vrsL.uAEV9uJA7c4G/WhJCZHO4xgxi	1234567890	Member	Intermediate	Weight Loss	1234567812345678	2024-12-03 01:48:49.45	2024-12-03 01:48:49.45	Peanuts	2500.00	\N	\N	\N	\N
10	harry	harry	ktm	120.0	60.0	Male	`harry@gmail.com	$2a$10$Vt0CgC.SK/eX8sEdzeFJ8eSmqf86RCt12.K/IGb7CcIzEVwmx8IVy	9856748512	Member	Beginner	Endurance	696	2024-12-04 06:13:37.73	2024-12-04 06:13:37.73	peanut	1200.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1733292816/profile_images/by8lt9rgmhwjp9auhoql.jpg	\N	\N	2001-12-14 00:00:00
11	rahul123	Rahul gupta	Mahendrapool	160.0	70.0	Male	rahultech730@gmail.com	$2a$10$jXDLI3mDx3SIhRhdqeW6TeA39JzryphuAZ3NyCuT4yCjxV5.IwSMC	9806598669	Member	Beginner	Endurance	56789	2024-12-16 04:10:34.52	2024-12-16 04:10:34.52	nothing	10.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1734322233/profile_images/pfujlfkrs2dmsf6ocnsb.jpg	\N	\N	2000-12-16 00:00:00
\.


--
-- Data for Name: workoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexercises (workout_exercise_id, workout_id, exercise_id, sets, reps, duration) FROM stdin;
14	73	31	3	12	10.00
15	74	31	10	2	10.00
16	75	32	3	10	20.00
17	75	31	10	20	20.00
18	76	32	3	30	10.00
19	76	31	3	20	10.00
20	77	33	3	12	20.00
21	77	32	4	12	300.00
\.


--
-- Data for Name: workoutexerciseslogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexerciseslogs (log_id, workout_log_id, exercise_id, skipped, exercise_duration, rest_duration) FROM stdin;
103	122	32	f	0.00	0.00
104	122	31	f	0.00	0.00
105	123	31	f	0.02	0.00
106	124	32	f	0.10	0.00
107	124	31	f	0.05	0.00
108	125	32	f	0.05	0.00
109	125	31	f	0.02	0.00
110	126	33	f	0.23	0.00
111	126	32	f	0.03	0.00
112	127	33	f	0.05	0.00
113	127	32	f	0.00	0.00
114	128	32	f	0.07	0.00
115	128	31	f	0.40	0.00
116	129	32	f	0.23	0.00
117	129	31	f	0.05	0.00
118	130	33	f	0.22	0.00
119	130	32	f	0.02	0.00
\.


--
-- Data for Name: workoutlogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutlogs (log_id, user_id, workout_id, workout_date, calories_burned, performance_notes, total_duration) FROM stdin;
122	5	75	2024-12-15 20:08:05.759	0.00	sdf	0.00
123	5	74	2024-12-15 20:57:25.601	0.00	dsf	0.02
124	11	75	2024-12-16 04:17:33.573	0.00	Average day in gym	0.15
125	11	76	2024-12-16 05:40:26.057	0.00	anil	0.07
126	5	77	2024-12-17 02:25:08.859	0.00	feeling great	0.27
127	5	77	2024-12-17 02:40:15.591	0.00	ok	0.05
128	5	75	2024-12-18 06:16:52.279	0.00	okkkk	0.47
129	5	75	2024-12-18 06:55:54.991	0.00	feeling great, had a wonderful workout	0.28
130	5	77	2024-12-18 08:09:23.332	0.00	feeling not nice today	0.23
\.


--
-- Data for Name: workouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workouts (workout_id, user_id, workout_name, description, target_muscle_group, difficulty, trainer_id, created_at, updated_at, fitness_level, goal_type, workout_image) FROM stdin;
73	1	Chest	A comprehensive workout for overall strength. Very nice and effective for weight loss.  	Full Body	Intermediate	5	2024-12-12 13:33:02.77	2024-12-12 13:33:02.773	Beginner	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1734010382/workout_images/k2eulro7kh3a2dcnpobh.png
74	\N	Legs	Best workout for legs	Shoulders	Easy	5	2024-12-13 05:46:51.389	2024-12-13 05:46:51.399	Beginner	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1734068809/workout_images/rz2m0cwttkqqsc1bx8bw.jpg
75	\N	Back Exercise	V taper build and stronger back	Shoulders	Easy	5	2024-12-13 08:17:55.703	2024-12-13 08:17:55.705	Beginner	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1734077873/workout_images/f32wokdrnv4nq1gqeg6f.jpg
76	\N	Cardio	For weight loss, flexibility	Core	Intermediate	5	2024-12-15 20:44:01.942	2024-12-15 20:44:01.947	Advanced	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1734295440/workout_images/bh227ocf4l9kdrdttbuc.jpg
77	\N	Sunday	sunday upprr body	Chest	Intermediate	5	2024-12-17 02:24:09.206	2024-12-17 02:24:09.209	Intermediate	Muscle Gain	https://res.cloudinary.com/dqcdosfch/image/upload/v1734402246/workout_images/zec4yhtojzme2epd65h1.png
\.


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 1, false);


--
-- Name: chatconversations_chat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatconversations_chat_id_seq', 1, false);


--
-- Name: chatmessages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatmessages_message_id_seq', 1, false);


--
-- Name: customworkoutexercises_custom_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkoutexercises_custom_workout_exercise_id_seq', 1, false);


--
-- Name: customworkouts_custom_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkouts_custom_workout_id_seq', 2, true);


--
-- Name: dietlogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dietlogs_log_id_seq', 1, false);


--
-- Name: dietplans_diet_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dietplans_diet_plan_id_seq', 1, false);


--
-- Name: exercises_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercises_exercise_id_seq', 33, true);


--
-- Name: gym_gym_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gym_gym_id_seq', 1, false);


--
-- Name: meals_meal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meals_meal_id_seq', 1, false);


--
-- Name: membership_plan_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membership_plan_plan_id_seq', 1, false);


--
-- Name: memberships_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memberships_membership_id_seq', 1, false);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- Name: personal_bests_personal_best_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_bests_personal_best_id_seq', 3, true);


--
-- Name: subscription_changes_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscription_changes_change_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 11, true);


--
-- Name: workoutexercises_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexercises_workout_exercise_id_seq', 21, true);


--
-- Name: workoutexerciseslogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexerciseslogs_log_id_seq', 119, true);


--
-- Name: workoutlogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutlogs_log_id_seq', 130, true);


--
-- Name: workouts_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workouts_workout_id_seq', 77, true);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: chatconversations chatconversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations
    ADD CONSTRAINT chatconversations_pkey PRIMARY KEY (chat_id);


--
-- Name: chatmessages chatmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessages
    ADD CONSTRAINT chatmessages_pkey PRIMARY KEY (message_id);


--
-- Name: customworkoutexercises customworkoutexercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises
    ADD CONSTRAINT customworkoutexercises_pkey PRIMARY KEY (custom_workout_exercise_id);


--
-- Name: customworkouts customworkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkouts
    ADD CONSTRAINT customworkouts_pkey PRIMARY KEY (custom_workout_id);


--
-- Name: dietlogs dietlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_pkey PRIMARY KEY (log_id);


--
-- Name: dietplans dietplans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_pkey PRIMARY KEY (diet_plan_id);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (exercise_id);


--
-- Name: gym gym_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gym
    ADD CONSTRAINT gym_pkey PRIMARY KEY (gym_id);


--
-- Name: meals meals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_pkey PRIMARY KEY (meal_id);


--
-- Name: membership_plan membership_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membership_plan
    ADD CONSTRAINT membership_plan_pkey PRIMARY KEY (plan_id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (membership_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: personal_bests personal_bests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests
    ADD CONSTRAINT personal_bests_pkey PRIMARY KEY (personal_best_id);


--
-- Name: subscription_changes subscription_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_changes
    ADD CONSTRAINT subscription_changes_pkey PRIMARY KEY (change_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: workoutexercises workoutexercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises
    ADD CONSTRAINT workoutexercises_pkey PRIMARY KEY (workout_exercise_id);


--
-- Name: workoutexerciseslogs workoutexerciseslogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs
    ADD CONSTRAINT workoutexerciseslogs_pkey PRIMARY KEY (log_id);


--
-- Name: workoutlogs workoutlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs
    ADD CONSTRAINT workoutlogs_pkey PRIMARY KEY (log_id);


--
-- Name: workouts workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (workout_id);


--
-- Name: customworkouts_custom_workout_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customworkouts_custom_workout_name_key ON public.customworkouts USING btree (custom_workout_name);


--
-- Name: exercises_exercise_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX exercises_exercise_name_key ON public.exercises USING btree (exercise_name);


--
-- Name: gym_contact_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX gym_contact_number_key ON public.gym USING btree (contact_number);


--
-- Name: gym_gym_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX gym_gym_name_key ON public.gym USING btree (gym_name);


--
-- Name: meals_meal_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX meals_meal_name_key ON public.meals USING btree (meal_name);


--
-- Name: payments_transaction_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payments_transaction_id_key ON public.payments USING btree (transaction_id);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: users_phone_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_phone_number_key ON public.users USING btree (phone_number);


--
-- Name: users_user_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_user_name_key ON public.users USING btree (user_name);


--
-- Name: workouts_workout_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX workouts_workout_name_key ON public.workouts USING btree (workout_name);


--
-- Name: attendance attendance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: chatconversations chatconversations_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations
    ADD CONSTRAINT chatconversations_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: chatconversations chatconversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations
    ADD CONSTRAINT chatconversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: chatmessages chatmessages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessages
    ADD CONSTRAINT chatmessages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chatconversations(chat_id) ON DELETE CASCADE;


--
-- Name: customworkoutexercises customworkoutexercises_custom_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises
    ADD CONSTRAINT customworkoutexercises_custom_workout_id_fkey FOREIGN KEY (custom_workout_id) REFERENCES public.customworkouts(custom_workout_id) ON DELETE CASCADE;


--
-- Name: customworkoutexercises customworkoutexercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises
    ADD CONSTRAINT customworkoutexercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: customworkouts customworkouts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkouts
    ADD CONSTRAINT customworkouts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: dietlogs dietlogs_diet_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_diet_plan_id_fkey FOREIGN KEY (diet_plan_id) REFERENCES public.dietplans(diet_plan_id);


--
-- Name: dietlogs dietlogs_meal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals(meal_id);


--
-- Name: dietlogs dietlogs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: dietplans dietplans_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: dietplans dietplans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: gym gym_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gym
    ADD CONSTRAINT gym_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: meals meals_diet_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_diet_plan_id_fkey FOREIGN KEY (diet_plan_id) REFERENCES public.dietplans(diet_plan_id) ON DELETE CASCADE;


--
-- Name: memberships memberships_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.membership_plan(plan_id) ON DELETE CASCADE;


--
-- Name: memberships memberships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: payments payments_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.memberships(membership_id) ON DELETE CASCADE;


--
-- Name: payments payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: personal_bests personal_bests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests
    ADD CONSTRAINT personal_bests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subscription_changes subscription_changes_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_changes
    ADD CONSTRAINT subscription_changes_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.memberships(membership_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: workoutexercises workoutexercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises
    ADD CONSTRAINT workoutexercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: workoutexercises workoutexercises_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises
    ADD CONSTRAINT workoutexercises_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workouts(workout_id) ON DELETE CASCADE;


--
-- Name: workoutexerciseslogs workoutexerciseslogs_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs
    ADD CONSTRAINT workoutexerciseslogs_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- Name: workoutexerciseslogs workoutexerciseslogs_workout_log_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs
    ADD CONSTRAINT workoutexerciseslogs_workout_log_id_fkey FOREIGN KEY (workout_log_id) REFERENCES public.workoutlogs(log_id) ON DELETE CASCADE;


--
-- Name: workoutlogs workoutlogs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs
    ADD CONSTRAINT workoutlogs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: workoutlogs workoutlogs_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs
    ADD CONSTRAINT workoutlogs_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workouts(workout_id);


--
-- Name: workouts workouts_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: workouts workouts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

