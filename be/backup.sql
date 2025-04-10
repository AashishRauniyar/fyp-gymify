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
    'Cancelled',
    'Pending'
);


ALTER TYPE public.membership_status OWNER TO postgres;

--
-- Name: payment_method; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method AS ENUM (
    'Khalti',
    'Cash',
    'Online'
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
-- Name: dietplans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dietplans (
    diet_plan_id integer NOT NULL,
    user_id integer NOT NULL,
    trainer_id integer,
    calorie_goal numeric(6,2),
    goal_type public.goal_type NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL,
    name character varying(100) NOT NULL,
    image character varying(255)
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
-- Name: meallogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meallogs (
    meal_log_id integer NOT NULL,
    user_id integer NOT NULL,
    meal_id integer NOT NULL,
    quantity numeric(5,2) NOT NULL,
    log_time timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.meallogs OWNER TO postgres;

--
-- Name: meallogs_meal_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.meallogs_meal_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.meallogs_meal_log_id_seq OWNER TO postgres;

--
-- Name: meallogs_meal_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meallogs_meal_log_id_seq OWNED BY public.meallogs.meal_log_id;


--
-- Name: meals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meals (
    meal_id integer NOT NULL,
    diet_plan_id integer NOT NULL,
    meal_name character varying(100) NOT NULL,
    meal_time public.meal_time NOT NULL,
    calories numeric(5,2) NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    macronutrients jsonb,
    image character varying(255)
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
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    description character varying(255) NOT NULL,
    duration integer NOT NULL
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
    start_date date,
    end_date date,
    status public.membership_status DEFAULT 'Pending'::public.membership_status NOT NULL,
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
    transaction_id character varying(100) NOT NULL,
    pidx character varying(100)
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
    weight numeric(6,2) NOT NULL,
    reps integer NOT NULL,
    achieved_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    supported_exercise_id integer NOT NULL
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
-- Name: supported_exercises; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supported_exercises (
    supported_exercise_id integer NOT NULL,
    exercise_name character varying(100) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.supported_exercises OWNER TO postgres;

--
-- Name: supported_exercises_supported_exercise_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supported_exercises_supported_exercise_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supported_exercises_supported_exercise_id_seq OWNER TO postgres;

--
-- Name: supported_exercises_supported_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supported_exercises_supported_exercise_id_seq OWNED BY public.supported_exercises.supported_exercise_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    user_name character varying(100),
    full_name character varying(100),
    address character varying(255),
    height numeric,
    current_weight numeric,
    gender public.gender,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone_number character varying(20),
    role public.role NOT NULL,
    fitness_level public.fitness_level,
    goal_type public.goal_type,
    card_number character varying(50),
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    allergies character varying(255),
    calorie_goals numeric(6,2),
    profile_image character varying(255),
    reset_token text,
    reset_token_expiry timestamp(3) without time zone,
    birthdate timestamp(3) without time zone,
    otp character varying(6),
    otp_expiry timestamp(3) without time zone,
    verified boolean DEFAULT false,
    fcm_token character varying(500)
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
-- Name: weight_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weight_logs (
    id integer NOT NULL,
    user_id integer NOT NULL,
    weight numeric(6,2) NOT NULL,
    logged_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.weight_logs OWNER TO postgres;

--
-- Name: weight_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.weight_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weight_logs_id_seq OWNER TO postgres;

--
-- Name: weight_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.weight_logs_id_seq OWNED BY public.weight_logs.id;


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
-- Name: meallogs meal_log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meallogs ALTER COLUMN meal_log_id SET DEFAULT nextval('public.meallogs_meal_log_id_seq'::regclass);


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
-- Name: supported_exercises supported_exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supported_exercises ALTER COLUMN supported_exercise_id SET DEFAULT nextval('public.supported_exercises_supported_exercise_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: weight_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_logs ALTER COLUMN id SET DEFAULT nextval('public.weight_logs_id_seq'::regclass);


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
4919479e-5d26-4473-9cb9-209311f7a25d	e04d48af3ed6fc733d37f48f76340385cafc7c1c19459a3be62bf75fd8ad60c3	2025-04-04 14:10:51.616068+05:45	20241203181959_changed_age_to_birthdate_in_users_table	\N	\N	2025-04-04 14:10:51.614173+05:45	1
fa8b614d-2b7f-498d-9da7-6fb7d90751a1	ee7805838826e6489fe3f466a958dc7c6882d852fe70dd69703c5e6022b6506d	2025-04-04 14:10:51.552417+05:45	20241111073636_init	\N	\N	2025-04-04 14:10:51.441622+05:45	1
caaae809-2be3-419d-96f3-79433dce7b42	ec673348243204fef1472b1ca6992bf0b6f304232cced783a8c81e50d6ae33c3	2025-04-04 14:10:51.556589+05:45	20241111174807_exercise_table_changes	\N	\N	2025-04-04 14:10:51.552988+05:45	1
5972f170-3a2d-48ee-9d1d-3d1f4665c7f7	4845140527831edc4398347251569fbd97144ff2afe26db82cafe2ed4e2ae458	2025-04-04 14:10:51.691092+05:45	20250303052952_diet_schema_changes	\N	\N	2025-04-04 14:10:51.673674+05:45	1
f0704f4b-0489-412d-89ed-640ec8106883	c97a24f916b1022c774255d5d7cc93604c24c620fdb19fbb26a4ac768becac78	2025-04-04 14:10:51.558709+05:45	20241111183505_add_updated_at_column	\N	\N	2025-04-04 14:10:51.556947+05:45	1
9b11f89c-8714-41ed-a073-38cf439d9481	b1385f7e08aab6f7446a75a967fa5518c7fa97d7dcf49b87ac100b9a99b6cd84	2025-04-04 14:10:51.618345+05:45	20241208065803_added_workout_image_in_schema	\N	\N	2025-04-04 14:10:51.616439+05:45	1
49d3747d-d245-4ef9-9bce-33c00e15e4e1	0f611f446830924da8c387f80b995d058902d7747ca944a34fc83745040ae4c2	2025-04-04 14:10:51.569966+05:45	20241111183607_added_updated_to_exercise	\N	\N	2025-04-04 14:10:51.559493+05:45	1
132598ee-438f-4f05-9347-32207a7c7b3c	2d55d7fd879de2af00771cf26792ced6dd0ed0b5d0407acca38debc934f0f987	2025-04-04 14:10:51.58358+05:45	20241112154203_added_workout_logs	\N	\N	2025-04-04 14:10:51.570369+05:45	1
678f00ff-b2df-45e2-8d56-5c781971afce	92a55d6232ca120aafe08feb6c02cef9c19c72a6159790242821603bfabec355	2025-04-04 14:10:51.655734+05:45	20250205063114_removed_unique_from_username	\N	\N	2025-04-04 14:10:51.653179+05:45	1
e595a8ec-d55c-45fc-b2ef-b90bcafe5f87	96dba3eeaad45b800df3ea6f5af7cae813eda03835c74cd35daa3a35efcd1a7e	2025-04-04 14:10:51.586334+05:45	20241113044909_added_alleries_and_calorie_goals	\N	\N	2025-04-04 14:10:51.584217+05:45	1
1aca3595-6a29-47ad-9cd3-53eee968df3b	15f25aba0566f3597d72a733afc4463eb80bc96a0b51f1e186b8bdd77131f2ce	2025-04-04 14:10:51.624993+05:45	20241212064937_add_personal_best_table	\N	\N	2025-04-04 14:10:51.618937+05:45	1
47103e75-2a7c-4ad7-b707-84a31b5f789c	09396e70247b798995949aeeb2c16503065571341c69a114ba290c12fa13e74d	2025-04-04 14:10:51.588883+05:45	20241118043614_added_missing_profile_image	\N	\N	2025-04-04 14:10:51.586869+05:45	1
22786cbc-815b-4e4d-82d2-9e4afeb877d2	ae839bb5007ee480a00b939517546a620e6cc586f1368c84593a0b689c4589ac	2025-04-04 14:10:51.591022+05:45	20241119062737_added_reset_password_fields	\N	\N	2025-04-04 14:10:51.589329+05:45	1
48987ee9-ce41-421f-aec2-d3c90f172b5d	a80c7945e92ea50db9b6652400684d3329f4a7ce8c2cb3e5c7f3929dd90d8c89	2025-04-04 14:10:51.599487+05:45	20241120181422_added	\N	\N	2025-04-04 14:10:51.591522+05:45	1
6ffda96b-6ea3-49f4-8544-fbb9500f3be9	0669ef38692d3612a22e52418641337e0ad42d93c58fb8dea0237afdc8d9ef1f	2025-04-04 14:10:51.627252+05:45	20241215035254_changes_in_logs	\N	\N	2025-04-04 14:10:51.625396+05:45	1
957326f6-fbbf-462e-8a78-dc9ca3db0613	b726ea43a1c7ee21e6d6df8c1affa71af084914f0ce78a4a4a5675bf0672d4d8	2025-04-04 14:10:51.609358+05:45	20241120182434_added_subscription_changes_and_fixed_membership	\N	\N	2025-04-04 14:10:51.600581+05:45	1
08450adf-e299-4e09-9f1c-3fab3992ada1	e255e35a37948add5022fc54c878a0bfac478d6b1790e8abdf50e9f58be823fa	2025-04-04 14:10:51.611551+05:45	20241125183339_update_workoutexerciseslogs	\N	\N	2025-04-04 14:10:51.609958+05:45	1
644d89d9-51eb-423d-a5f1-d62c888fef56	6fbc7f9dd381fb919552e3346e34395c75ec2f72950055053873213825fa6065	2025-04-04 14:10:51.668126+05:45	20250210093811_changes_in_membership	\N	\N	2025-04-04 14:10:51.666257+05:45	1
364b83ab-3b0f-42b4-be53-d2122a6f1a47	77854bb9cdc9c4ed7e04bf7b329b7788e34ca5050fc80a416fd999ab951c7663	2025-04-04 14:10:51.613564+05:45	20241203180715_add_goal_type_and_fitness_level_to_workouts	\N	\N	2025-04-04 14:10:51.611924+05:45	1
c33e5c12-9d90-4404-a227-442b7fe0c551	74b27f4831a8cf2c04adb66ba9f08e20b11a385709910622ddf7c05eb03170c0	2025-04-04 14:10:51.657564+05:45	20250205072409_user_name_optional	\N	\N	2025-04-04 14:10:51.656134+05:45	1
396cedac-34fc-474b-97f7-7f416bf40cd2	34a192eb492e51ce9595d8edf68ef416d7c4ce07938514de90147765631f6d7c	2025-04-04 14:10:51.637816+05:45	20241222040609_fix_personal_best	\N	\N	2025-04-04 14:10:51.628133+05:45	1
13add5d9-341e-41e0-a38d-2e25ce91108b	6739dc03c7e55d9e8ace3b5a809b510f65fec68da3ef7e51411a68957f3a48d4	2025-04-04 14:10:51.643294+05:45	20250104053049_added_weight_logs	\N	\N	2025-04-04 14:10:51.638209+05:45	1
a39cfb67-6189-4827-a5a3-86f5ce3c1796	3e9e57e3b6c601b8b7fe5a273b4bc8057b5dda68f6ae16d15feab28bd7d0a7c4	2025-04-04 14:10:51.6454+05:45	20250119030827_added_otp_otpexpiry	\N	\N	2025-04-04 14:10:51.643907+05:45	1
98eae970-6f82-458a-9bd8-c72fcd8dc210	2dd245b8199ac4a79ad1562b58fe948b8037fcc4170155b777644a0f1929e624	2025-04-04 14:10:51.659439+05:45	20250205073108_user_schema_optional_fields	\N	\N	2025-04-04 14:10:51.657918+05:45	1
c2cdffc9-ff94-4370-84d6-caab45a4c18e	148bc7147309f6b20de379ea91edc7881b9ce36a16bcfcec619e6a30b1af0354	2025-04-04 14:10:51.649989+05:45	20250202090025_added_name_in_diet_plan	\N	\N	2025-04-04 14:10:51.646238+05:45	1
c35faf48-5991-4ed6-b84e-3752e5be5db3	39dcd0d0a891ef84aa616e43d8f0ee872de3cf1b5dd6088f1875f6fae02b4a62	2025-04-04 14:10:51.652635+05:45	20250202144605_added_image_in_meal	\N	\N	2025-04-04 14:10:51.650715+05:45	1
cee9283c-4215-4ada-9a99-eaf44cb1cd77	9bb0db3cdff65f1c7f67f5046f94da0447b6d3f90f539717b63a711e6d4b389e	2025-04-04 14:10:51.663388+05:45	20250205073431_user_schema_unique_user_name	\N	\N	2025-04-04 14:10:51.660082+05:45	1
597137cc-2acc-4725-87ac-5c3dcc9ea403	9948b7d3b00b570228f7e98edba0cf07ca972f6dbfca231f1227a147a347ebe6	2025-04-04 14:10:51.670715+05:45	20250210095336_default_pending_in_membership_status	\N	\N	2025-04-04 14:10:51.668616+05:45	1
40118155-189d-4df3-89a3-d58a06828a0b	75bd1422c114c29412c4e7d0963bd35c0bdb0bbe6125a6e29fda287819effa58	2025-04-04 14:10:51.665886+05:45	20250205083557_user_schema_verification_status	\N	\N	2025-04-04 14:10:51.664166+05:45	1
b19e28f6-7afa-4b68-8ff6-6ad82d0b9da9	1d652b1b790ef5f7745028f82adebce9a1738103f9f4800eb93ad2bb0a111ae6	2025-04-04 14:10:51.700626+05:45	20250403055041_added_online_option_in_payment_method	\N	\N	2025-04-04 14:10:51.699223+05:45	1
ae1cd8a5-3950-46b8-acdc-4023de3a2796	77e71f5715c551ffe63652eb95fe4b9b50d2ef9de93dcd6245560e1fa59c098b	2025-04-04 14:10:51.673123+05:45	20250225184631_add_pidx_to_payments	\N	\N	2025-04-04 14:10:51.671413+05:45	1
888b57c2-5fdb-4ef6-8f09-7cea1f45e7b3	df460b31aad044b9e053f2b486e4562ffb10ed9dc0f610a9c014a7e0923213b6	2025-04-04 14:10:51.698609+05:45	20250315123012_added_image_in_diet	\N	\N	2025-04-04 14:10:51.696349+05:45	1
cf6177dc-ed0a-48b6-95f4-36da7eeb4c61	39dcd0d0a891ef84aa616e43d8f0ee872de3cf1b5dd6088f1875f6fae02b4a62	2025-04-04 14:10:51.693311+05:45	20250303053453_added_image_in_meal	\N	\N	2025-04-04 14:10:51.691475+05:45	1
3d748ae5-bb77-4c70-bd89-168330a2ace4	3f9a5e697f20132ae278768c06a5043f6ab939e3e698b544064d9de1d95f8bf6	2025-04-04 14:10:51.69599+05:45	20250311115149_added_duration_and_description_in_plans	\N	\N	2025-04-04 14:10:51.69403+05:45	1
bc632711-d1ae-4289-8f96-1ac90d913336	17f5c55ad407839bfb40a1d1a92fbbed613494ba7fe8f51f59fe1b18836169fd	2025-04-04 14:10:53.343496+05:45	20250404082553_added_fcm_token	\N	\N	2025-04-04 14:10:53.341164+05:45	1
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (attendance_id, user_id, gym_id, attendance_date) FROM stdin;
1	2	\N	2025-04-10
\.


--
-- Data for Name: chatconversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatconversations (chat_id, user_id, trainer_id, last_message, last_message_timestamp) FROM stdin;
23	2	3	\N	2025-04-04 08:53:16.355
26	2	6	\N	2025-04-04 09:10:01.861
27	7	2	hello dai	2025-04-05 19:14:59.607
216	2	16	hello	2025-04-10 05:25:21.075
\.


--
-- Data for Name: chatmessages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatmessages (message_id, chat_id, sender_id, message_content, sent_at, is_read) FROM stdin;
1	27	7	{"text":"hello dai"}	2025-04-05 19:14:59.6	f
2	216	2	{"text":"Hiii"}	2025-04-08 12:05:32.429	f
3	216	2	{"text":"bro message hera k"}	2025-04-08 20:03:41.43	f
4	216	2	{"text":"k ho message na herdine"}	2025-04-10 02:05:39.796	f
5	216	16	{"text":"hahaha"}	2025-04-10 02:06:24.355	f
6	216	16	{"text":"aja kun workout garam dai?"}	2025-04-10 02:06:47.913	f
7	216	2	{"text":"aja kun worloiut"}	2025-04-10 02:47:43.679	f
8	216	2	{"text":"hello"}	2025-04-10 05:25:20.318	f
\.


--
-- Data for Name: customworkoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkoutexercises (custom_workout_exercise_id, custom_workout_id, exercise_id, sets, reps, duration) FROM stdin;
1	1	1	3	12	12.00
\.


--
-- Data for Name: customworkouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkouts (custom_workout_id, user_id, custom_workout_name, created_at) FROM stdin;
1	2	My Sunday Routine	2025-04-09 09:25:36.532
\.


--
-- Data for Name: dietplans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dietplans (diet_plan_id, user_id, trainer_id, calorie_goal, goal_type, description, created_at, updated_at, name, image) FROM stdin;
1	2	2	1200.00	Muscle Gain	Junk food to gain weight in the worst way possible	2025-04-05 19:27:40.903	2025-04-05 19:27:40.903	Weight Gain Plan	https://res.cloudinary.com/dqcdosfch/image/upload/v1743881260/diet_images/vn1zulpozeqsqiysjg3y.jpg
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercises (exercise_id, exercise_name, calories_burned_per_minute, created_at, description, image_url, target_muscle_group, video_url, updated_at) FROM stdin;
1	Pushups	12.00	2025-04-08 12:10:45.465	Best exercise for ches	https://res.cloudinary.com/dqcdosfch/image/upload/v1744114233/exercise_images/uspukdqiudvas0my06h9.jpg	Chest	https://res.cloudinary.com/dqcdosfch/video/upload/v1744114243/exercise_videos/sxrxcdauihd3a3kkw4f4.mp4	2025-04-08 12:10:45.466
\.


--
-- Data for Name: gym; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gym (gym_id, gym_name, location, contact_number, admin_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: meallogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meallogs (meal_log_id, user_id, meal_id, quantity, log_time) FROM stdin;
2	2	1	10.00	2025-04-05 19:28:45.004
3	2	1	1.00	2025-04-08 19:34:04.564
4	18	1	1.00	2025-04-10 02:01:14.008
6	2	1	2.00	2025-04-10 02:47:21.603
\.


--
-- Data for Name: meals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meals (meal_id, diet_plan_id, meal_name, meal_time, calories, description, created_at, macronutrients, image) FROM stdin;
1	1	Apple Pie	Breakfast	120.00	very tastu	2025-04-05 19:28:22.193	"{\\"protein\\":12.0,\\"carbs\\":12.0,\\"fat\\":6.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1743881302/meal_images/c2e8fywzbuoqnqjuwwvr.jpg
\.


--
-- Data for Name: membership_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membership_plan (plan_id, plan_type, price, created_at, updated_at, description, duration) FROM stdin;
1	Monthly	1500.00	2025-04-04 08:38:10.915	2025-04-04 08:38:10.915	Access to all the features of gymify app and access to gym	1
2	Quaterly	4500.00	2025-04-04 08:39:54.251	2025-04-09 05:39:08.857	Access to every gym feature + online trainer guidance, more features	3
\.


--
-- Data for Name: memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memberships (membership_id, user_id, start_date, end_date, status, created_at, updated_at, plan_id) FROM stdin;
1	2	2025-04-04	2025-05-04	Active	2025-04-04 08:38:58.525	2025-04-04 08:38:58.525	1
2	1	2025-04-04	2025-05-04	Active	2025-04-04 08:40:19.32	2025-04-04 08:40:19.32	1
3	3	2025-04-04	2025-05-04	Active	2025-04-04 08:47:52.549	2025-04-04 08:47:52.549	1
4	6	2025-04-04	2025-07-04	Active	2025-04-04 09:09:58.107	2025-04-04 09:09:58.107	2
5	7	2025-04-06	2025-05-06	Active	2025-04-05 19:11:31.219	2025-04-05 19:11:31.219	1
7	16	2025-04-07	2025-05-07	Active	2025-04-07 10:38:36.02	2025-04-07 10:38:36.02	1
8	17	2025-04-09	2025-05-09	Active	2025-04-09 05:37:47.326	2025-04-09 05:37:47.326	1
9	18	\N	\N	Pending	2025-04-10 02:01:49.588	2025-04-10 02:01:49.588	2
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, membership_id, user_id, price, payment_method, payment_date, payment_status, created_at, transaction_id, pidx) FROM stdin;
1	1	2	1500.00	Cash	2025-04-04	Paid	2025-04-04 08:38:58.525	TXN-1743755938524-2	\N
2	2	1	1500.00	Cash	2025-04-04	Paid	2025-04-04 08:40:19.614	MANUAL-1743756019612-746	\N
3	3	3	1500.00	Online	2025-04-04	Paid	2025-04-04 08:47:52.559	MANUAL-1743756472557-187	\N
4	4	6	4500.00	Cash	2025-04-04	Paid	2025-04-04 09:09:58.151	MANUAL-1743757798150-432	\N
5	5	7	1500.00	Cash	2025-04-05	Paid	2025-04-05 19:11:31.265	MANUAL-1743880291261-142	\N
7	7	16	1500.00	Cash	2025-04-07	Paid	2025-04-07 10:38:36.047	MANUAL-1744022316045-782	\N
8	8	17	1500.00	Online	2025-04-09	Paid	2025-04-09 05:37:47.352	MANUAL-1744177067351-293	\N
\.


--
-- Data for Name: personal_bests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_bests (personal_best_id, user_id, weight, reps, achieved_at, supported_exercise_id) FROM stdin;
1	2	120.00	3	2025-04-09 06:58:12.639	1
2	2	130.00	3	2025-04-10 02:38:50.561	1
3	2	120.00	1	2025-04-10 05:21:02.281	3
4	2	130.00	2	2025-04-10 05:21:10.888	3
\.


--
-- Data for Name: subscription_changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_changes (change_id, membership_id, previous_plan, new_plan, change_date, action) FROM stdin;
\.


--
-- Data for Name: supported_exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supported_exercises (supported_exercise_id, exercise_name, created_at, updated_at) FROM stdin;
1	Bench Press	2025-04-09 06:57:58.37	2025-04-09 06:57:58.37
3	Deadlift	2025-04-09 06:58:47.73	2025-04-09 06:58:47.73
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, user_name, full_name, address, height, current_weight, gender, email, password, phone_number, role, fitness_level, goal_type, card_number, created_at, updated_at, allergies, calorie_goals, profile_image, reset_token, reset_token_expiry, birthdate, otp, otp_expiry, verified, fcm_token) FROM stdin;
3	Acis	Acis Raw	Kathmandu	165	76	Male	ak.aashish19@gmail.com	$2a$12$sBj7mA8eKmo9voK/QDP4Ze5gC4a0c1ZTAUB.3uhY1R/S8o26N2OCW	1212121212	Member	Beginner	Muscle Gain		2025-04-04 08:47:31.685	2025-04-04 08:47:31.685	Peanuts	2500.00	https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.instagram.com%2Fvladimirshmondenko%2F&psig=AOvVaw0pLDDFDvKpUqylnI82CW-j&ust=1743843173575000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCNCp05mAvowDFQAAAAAdAAAAABAE	\N	\N	2002-12-12 00:00:00	\N	\N	t	\N
5	Sita	Sita	Pokhara	154	55	Male	sita@gmail.com	$2a$12$NFuegjzHS7hhyZ59kmGLb.AIZmiN32T0FNUdfQwFLdRX1xz5B35e2	121212121212	Member	Beginner	Weight Loss		2025-04-04 09:07:32.781	2025-04-04 09:07:32.781		1200.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743757651/profile_images/wwp2kkuwohoh7ejkmq7s.png	\N	\N	1997-12-12 00:00:00	\N	\N	t	\N
6	Sailesh	Sailesh Gurung	Birauta	170	73	Male	saileshgurung@gmail.com	$2a$12$2nXBceObMuMYyLNsVr.Eze/SHsV.s2aKkGjayL5UyGj31XnX4VW7m	98767545643	Member	Advanced	Muscle Gain		2025-04-04 09:09:20.799	2025-04-04 09:09:20.799	nothing	2400.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743757759/profile_images/p1r8ywzcspwrtbdvvbrn.png	\N	\N	2002-11-11 00:00:00	\N	\N	t	\N
7	Rahul	Rahul Rauniyar	Nayabazar, Pokhara	175	90	Male	rahulrauniyar@gmail.com	$2a$12$BEQ6vh7HK2j7W5secocZ4edWBNKzHw9dJvF/N3y31wV2slvvcddrG	9806767888	Member	Beginner	Weight Loss		2025-04-05 19:10:05.858	2025-04-05 19:12:47.214	nothing	600.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743880205/profile_images/qbfqylac7jsy53oai2xh.png	\N	\N	1998-12-12 00:00:00	\N	\N	t	\N
4	ram	Ram	Bagale Tol	187	90	Male	ram@gmail.com	$2a$12$BrIjGA/akJtW3VBHL7bHguukDaA/RtLrBS2X15Kjg4TAfwrWQ99vq	9812121212	Member	Beginner	Weight Loss		2025-04-04 08:59:48.044	2025-04-04 08:59:48.044	milk	1800.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743880205/profile_images/qbfqylac7jsy53oai2xh.png	\N	\N	1999-12-04 00:00:00	\N	\N	t	\N
1	Aashish	Aashish Rauniyar	123 Main St, City	175.5	70.2	Male	rauniyaaraashish@gmail.com	$2a$12$juVZxo6Hh3LDonhDwus5FO9guL3I24LSI8Y2CzX./aQLkuwrcZ6e.	1234567890	Admin	Intermediate	Muscle Gain	1234-5678-9012-3456	2025-04-04 08:31:35.382	2025-04-04 08:31:35.382	None	2500.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743880205/profile_images/qbfqylac7jsy53oai2xh.png	\N	\N	2002-03-12 00:00:00	\N	\N	t	\N
18	Rahul Rauniyar	Rahul Rauniyar	Pokhara	170.0	73	Female	me.splashrahul@gmail.com	$2a$12$URXQY8Ey1O7ISe1lpOV44.gTLTf6NRF6FMJC1b660d2/oQzZv2hni	9878675467	Member	Beginner	Weight Loss	\N	2025-04-09 10:08:03.313	2025-04-10 01:54:46.701	nothing	1450.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744193857/profile_images/kldupg5pxjrngu57omba.jpg	\N	\N	1991-05-25 00:00:00	\N	\N	t	\N
9	Rahul Don	Rahul Gupta	Pokhara	172.0	70.0	Male	rahultech730@gmail.com	$2a$12$v0FkkelN/zWSRCqvg2x8OOa6grGL8j/m5u/vm1LOfPs79/TCrytxC	9806767880	Member	Beginner	Flexibility	\N	2025-04-07 09:19:52.003	2025-04-07 09:19:52.003	nothing	1600.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744018380/profile_images/z5hkorhzm3afka9hzrn7.jpg	\N	\N	2001-04-12 00:00:00	\N	\N	t	\N
16	Abishek	Abishek Khadka	Pokhara	170.0	78	Male	abishekkhadka70@gmail.com	$2a$12$5s.5AWrtAjb8mwzSsph9Ee6tZma3Ag0ObiUmkgkKTDylOkF4R5sjC	9806754600	Member	Beginner	Weight Loss	\N	2025-04-07 10:22:41.066	2025-04-10 02:20:07.57	diya thapa	2000.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744021580/profile_images/wqcxdb2evswypxkykxp7.jpg	\N	\N	2005-04-12 00:00:00	\N	\N	t	\N
17	test	test user	Pokhara	160	64	Female	test@gmail.com	$2a$12$fsk/Hwn99TpOXYDvUGQdi.4ocWmrPbWlBYrv6/fWm7eYtPEU.0BmW	1212121213	Trainer	Intermediate	Endurance		2025-04-09 05:36:52.184	2025-04-09 05:37:14.649	nothing	1200.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744177009/profile_images/dgwncefbwjifeamnagxq.png	\N	\N	2002-12-02 00:00:00	\N	\N	t	\N
19	\N	\N	\N	\N	\N	\N	abinashchhetri.work@gmail.com	$2a$12$tFcOEhCbsYQ8QARpDdL89uzUOQh5WG/itcvE/5D4YczHUfkIp9ORq	\N	Member	\N	\N	\N	2025-04-10 05:16:31.928	2025-04-10 05:16:31.928	\N	\N	\N	\N	\N	\N	850845	2025-04-10 05:26:31.925	f	\N
2	trainer	Trainer	Pokhara	175	78	Male	trainer@gmail.com	$2a$12$nxjAPaQCCsuLgElbTpEHS.zbr2nS.NMy0KQzD4GYWAjDqIAb1/7Ly	9811212123	Trainer	Beginner	Weight Loss	GE2323	2025-04-04 08:34:26.53	2025-04-10 05:20:44.172		1500.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743880205/profile_images/qbfqylac7jsy53oai2xh.png	\N	\N	2002-12-12 00:00:00	\N	\N	t	\N
\.


--
-- Data for Name: weight_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weight_logs (id, user_id, weight, logged_at) FROM stdin;
1	7	93.00	2025-04-05 19:12:40.691
2	7	90.00	2025-04-05 19:12:47.216
3	2	70.00	2025-04-08 12:05:01.613
4	2	72.00	2025-04-08 12:05:07.491
5	18	72.00	2025-04-10 01:49:03.693
6	18	73.00	2025-04-10 01:49:11.007
7	18	74.00	2025-04-10 01:50:48.379
8	18	73.00	2025-04-10 01:54:46.712
9	16	72.00	2025-04-10 02:19:42.54
10	16	76.00	2025-04-10 02:19:53.87
11	16	78.00	2025-04-10 02:20:07.574
12	2	75.00	2025-04-10 02:36:54.448
13	2	78.00	2025-04-10 05:20:44.187
\.


--
-- Data for Name: workoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexercises (workout_exercise_id, workout_id, exercise_id, sets, reps, duration) FROM stdin;
1	3	1	3	12	10.00
\.


--
-- Data for Name: workoutexerciseslogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexerciseslogs (log_id, workout_log_id, exercise_id, skipped, exercise_duration, rest_duration) FROM stdin;
1	1	1	f	0.55	0.03
3	2	1	f	0.33	0.10
5	3	1	f	0.13	0.05
6	4	1	f	0.13	0.50
7	5	1	f	0.08	0.08
8	6	1	f	0.27	0.50
\.


--
-- Data for Name: workoutlogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutlogs (log_id, user_id, workout_id, workout_date, calories_burned, performance_notes, total_duration) FROM stdin;
1	2	3	2025-04-08 12:19:20.749	0.00	Should increase weights next time	0.63
2	2	3	2025-04-08 17:20:08.013	0.00	Should increase weights next time.	0.58
3	18	3	2025-04-10 02:00:06.411	0.00	Felt great during this workout  by pradeep!	0.18
4	2	3	2025-04-10 02:40:15.132	0.00	Struggled with proper form, need to focus on technique. by hem	0.63
5	2	3	2025-04-10 02:46:59.612	0.00	aashish	0.17
6	2	3	2025-04-10 05:23:02.775	0.00	WOKROUT WITH ABINASH Should increase weights next time.	0.77
\.


--
-- Data for Name: workouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workouts (workout_id, user_id, workout_name, description, target_muscle_group, difficulty, trainer_id, created_at, updated_at, fitness_level, goal_type, workout_image) FROM stdin;
2	\N	Aashish Workout	A comprehensive workout for overall strength. Very nice and effective for weight loss.  	Full Body	Intermediate	2	2025-04-04 09:18:21.581	2025-04-04 09:18:21.582	Beginner	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1743758300/workout_images/uanxnbxenucfd12yxkke.jpg
3	\N	chest workout 	overall chest workout	Chest	Easy	2	2025-04-08 12:17:32.916	2025-04-08 12:17:32.918	Athlete	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1744114650/workout_images/kgkwzeduyoknwvxsmoga.jpg
\.


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 1, true);


--
-- Name: chatconversations_chat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatconversations_chat_id_seq', 1, false);


--
-- Name: chatmessages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatmessages_message_id_seq', 8, true);


--
-- Name: customworkoutexercises_custom_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkoutexercises_custom_workout_exercise_id_seq', 3, true);


--
-- Name: customworkouts_custom_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkouts_custom_workout_id_seq', 3, true);


--
-- Name: dietplans_diet_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dietplans_diet_plan_id_seq', 1, true);


--
-- Name: exercises_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercises_exercise_id_seq', 4, true);


--
-- Name: gym_gym_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gym_gym_id_seq', 1, false);


--
-- Name: meallogs_meal_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meallogs_meal_log_id_seq', 6, true);


--
-- Name: meals_meal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meals_meal_id_seq', 1, true);


--
-- Name: membership_plan_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membership_plan_plan_id_seq', 2, true);


--
-- Name: memberships_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memberships_membership_id_seq', 9, true);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 8, true);


--
-- Name: personal_bests_personal_best_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_bests_personal_best_id_seq', 4, true);


--
-- Name: subscription_changes_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscription_changes_change_id_seq', 1, false);


--
-- Name: supported_exercises_supported_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supported_exercises_supported_exercise_id_seq', 3, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 19, true);


--
-- Name: weight_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weight_logs_id_seq', 13, true);


--
-- Name: workoutexercises_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexercises_workout_exercise_id_seq', 2, true);


--
-- Name: workoutexerciseslogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexerciseslogs_log_id_seq', 8, true);


--
-- Name: workoutlogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutlogs_log_id_seq', 6, true);


--
-- Name: workouts_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workouts_workout_id_seq', 3, true);


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
-- Name: meallogs meallogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meallogs
    ADD CONSTRAINT meallogs_pkey PRIMARY KEY (meal_log_id);


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
-- Name: supported_exercises supported_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supported_exercises
    ADD CONSTRAINT supported_exercises_pkey PRIMARY KEY (supported_exercise_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: weight_logs weight_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_logs
    ADD CONSTRAINT weight_logs_pkey PRIMARY KEY (id);


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
-- Name: dietplans_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX dietplans_name_key ON public.dietplans USING btree (name);


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
-- Name: payments_transaction_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payments_transaction_id_key ON public.payments USING btree (transaction_id);


--
-- Name: supported_exercises_exercise_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX supported_exercises_exercise_name_key ON public.supported_exercises USING btree (exercise_name);


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
-- Name: dietplans dietplans_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: dietplans dietplans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gym gym_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gym
    ADD CONSTRAINT gym_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: meallogs meallogs_meal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meallogs
    ADD CONSTRAINT meallogs_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals(meal_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: meallogs meallogs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meallogs
    ADD CONSTRAINT meallogs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: meals meals_diet_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_diet_plan_id_fkey FOREIGN KEY (diet_plan_id) REFERENCES public.dietplans(diet_plan_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: personal_bests personal_bests_supported_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests
    ADD CONSTRAINT personal_bests_supported_exercise_id_fkey FOREIGN KEY (supported_exercise_id) REFERENCES public.supported_exercises(supported_exercise_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: weight_logs weight_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weight_logs
    ADD CONSTRAINT weight_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


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

