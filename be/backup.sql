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
4	1	\N	2025-04-13
5	20	\N	2025-04-13
\.


--
-- Data for Name: chatconversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatconversations (chat_id, user_id, trainer_id, last_message, last_message_timestamp) FROM stdin;
27	7	2	hello dai	2025-04-05 19:14:59.607
26	2	6	oie	2025-04-13 12:04:46.445
216	2	16	https://media.tenor.com/x18QA0Fg5tIAAAAM/happy-passover.gif	2025-04-13 13:10:56.545
117	1	17	\N	2025-04-15 07:24:27.057
221	21	2	okay check the leg workout in home screen	2025-04-15 08:06:57.256
222	22	2	Most welcome	2025-04-18 09:18:43.079
1618	16	18	sdfsdf	2025-04-20 03:27:09.202
1718	18	17	\N	2025-04-20 03:35:39.36
1621	21	16	\N	2025-04-20 03:36:28.016
1721	21	17	\N	2025-04-20 03:37:18.84
218	18	2	hajur	2025-04-20 04:04:55.099
1827	27	18	Aja k ko workout grne:	2025-04-20 13:01:56.036
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
9	218	2	{"text":"Heyy"}	2025-04-13 10:55:44.268	f
10	218	18	{"text":"hajur dai"}	2025-04-13 10:56:26.094	f
11	218	2	{"text":"Heyyy"}	2025-04-13 10:56:41.082	f
12	26	2	{"text":"oie"}	2025-04-13 12:04:46.44	f
13	218	18	{"text":"hi"}	2025-04-13 12:05:37.32	f
14	218	2	{"text":"hello"}	2025-04-13 12:05:43.06	f
15	218	2	{"text":"aba k garne gym"}	2025-04-13 12:05:56.37	f
16	216	2	{"text":"hii"}	2025-04-13 13:10:32.806	f
17	216	2	{"text":"😂😂"}	2025-04-13 13:10:37.973	f
18	216	2	{"text":"https://media.tenor.com/x18QA0Fg5tIAAAAM/happy-passover.gif"}	2025-04-13 13:10:56.545	f
19	221	2	{"text":"hi"}	2025-04-15 08:06:22.388	f
20	221	21	{"text":"Hello"}	2025-04-15 08:06:25.913	f
21	221	2	{"text":"k xa aj kun workout grxau"}	2025-04-15 08:06:36.425	f
22	221	21	{"text":"Leg"}	2025-04-15 08:06:43.969	f
23	221	2	{"text":"okay check the leg workout in home screen"}	2025-04-15 08:06:57.254	f
24	222	22	{"text":"Hello sir"}	2025-04-18 09:16:06.755	f
25	222	22	{"text":"Are you there"}	2025-04-18 09:17:42.012	f
26	222	2	{"text":"ye i am hjere'"}	2025-04-18 09:17:46.575	f
27	222	2	{"text":"how can i help you?"}	2025-04-18 09:17:52.12	f
28	222	22	{"text":"Ohh 😧"}	2025-04-18 09:17:53.315	f
29	222	2	{"text":"is it showing that i am typing?"}	2025-04-18 09:17:59.999	f
30	222	22	{"text":"Yep"}	2025-04-18 09:18:05.936	f
31	222	2	{"text":"wow thanks for testing my app"}	2025-04-18 09:18:18.923	f
32	222	22	{"text":"Most welcome"}	2025-04-18 09:18:43.079	f
33	218	2	{"text":"hi"}	2025-04-20 03:12:10.098	f
34	218	18	{"text":"hajur dai"}	2025-04-20 03:12:54.408	f
35	218	2	{"text":"ahh"}	2025-04-20 03:12:59.19	f
36	218	2	{"text":"heyy"}	2025-04-20 03:22:29.418	f
37	218	18	{"text":"yess"}	2025-04-20 03:22:42.756	f
38	218	18	{"text":"okk"}	2025-04-20 03:23:05.205	f
39	1618	16	{"text":"bro?"}	2025-04-20 03:25:30.614	f
40	1618	18	{"text":"hajur dai"}	2025-04-20 03:25:41.899	f
41	1618	16	{"text":"fdgdfg"}	2025-04-20 03:26:10.99	f
42	1618	18	{"text":"sdfsdf"}	2025-04-20 03:26:16.931	f
43	1618	16	{"text":"sdfsdf"}	2025-04-20 03:27:06.471	f
44	1618	18	{"text":"sdfsdf"}	2025-04-20 03:27:09.2	f
45	218	18	{"text":"gfhfgh"}	2025-04-20 03:51:19.057	f
46	218	2	{"text":"ghjghj"}	2025-04-20 03:51:26.12	f
47	218	2	{"text":"bnhhhhh"}	2025-04-20 03:51:44.034	f
48	218	2	{"text":"fdfg"}	2025-04-20 03:52:15.88	f
49	218	18	{"text":"dfdsfsd"}	2025-04-20 03:52:43.867	f
50	218	2	{"text":"hey"}	2025-04-20 04:03:48.491	f
51	218	2	{"text":"dai"}	2025-04-20 04:04:49.526	f
52	218	18	{"text":"hajur"}	2025-04-20 04:04:55.098	f
53	1827	27	{"text":"Aja k ko workout grne:"}	2025-04-20 13:01:56.023	f
\.


--
-- Data for Name: customworkoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkoutexercises (custom_workout_exercise_id, custom_workout_id, exercise_id, sets, reps, duration) FROM stdin;
8	11	5	3	12	12.00
9	11	10	3	12	12.00
10	11	13	3	12	12.00
11	12	5	3	12	18.00
12	12	23	3	12	10.00
\.


--
-- Data for Name: customworkouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkouts (custom_workout_id, user_id, custom_workout_name, created_at) FROM stdin;
11	2	My Sunday Routine	2025-04-19 16:17:49.46
12	27	My Sunday Routine Exercise 	2025-04-20 13:02:50.045
13	2	Rahul check	2025-04-21 05:22:03.491
\.


--
-- Data for Name: dietplans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dietplans (diet_plan_id, user_id, trainer_id, calorie_goal, goal_type, description, created_at, updated_at, name, image) FROM stdin;
3	2	2	1800.00	Weight Loss	The ultimate diet plan to lose weight instantly within a month	2025-04-19 18:20:50.988	2025-04-19 18:20:50.988	Weight Loss Plan 	https://res.cloudinary.com/dqcdosfch/image/upload/v1745086841/diet_images/hzt4kvz9vsxqz6bstfjx.jpg
4	2	2	1800.00	Muscle Gain	Gain muscles in few weeks with this certified muscle Gain plan	2025-04-19 18:32:23.144	2025-04-19 18:32:23.144	High Protein Muscle Gain Plan	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087534/diet_images/jtygtv9mtcqe5jvmqvjj.jpg
5	2	2	1800.00	Maintenance	Best for daily diet plan 	2025-04-19 18:38:22.883	2025-04-19 18:38:22.883	Fit body Maintenance Diet	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087893/diet_images/yffkxpj3dhho4j3jg3oa.jpg
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercises (exercise_id, exercise_name, calories_burned_per_minute, created_at, description, image_url, target_muscle_group, video_url, updated_at) FROM stdin;
5	Barbell Curls	7.20	2025-04-18 07:46:52.832	A strength training exercise that targets the biceps and forearms.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744962297/exercise_images/ypfhke1ouekcwzitpjlr.jpg	Arms	https://res.cloudinary.com/dqcdosfch/video/upload/v1744962405/exercise_videos/y02ceg9wqassohniwfz2.mp4	2025-04-18 07:46:52.836
6	Squats	8.00	2025-04-18 07:49:59.801	A lower body workout that targets the quads, hamstrings, and glutes.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744962590/exercise_images/ehitquptxqv4hnopxcpj.jpg	Legs	https://res.cloudinary.com/dqcdosfch/video/upload/v1744962593/exercise_videos/yqy85cckgwfglubal5tc.mp4	2025-04-18 07:49:59.803
7	Deadlift	9.00	2025-04-18 07:51:22.863	A compound movement that targets the back, glutes, and hamstrings.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744962669/exercise_images/yddmdzgfrir0adlh4nik.jpg	Back	https://res.cloudinary.com/dqcdosfch/video/upload/v1744962674/exercise_videos/fp8dd2sdleq2o2sn09da.mp4	2025-04-18 07:51:22.864
8	Push-Ups	6.00	2025-04-18 07:52:10.342	A bodyweight exercise that primarily targets the chest, shoulders, and triceps.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744962718/exercise_images/cb0h4iflojmjszk0bsdv.jpg	Chest	https://res.cloudinary.com/dqcdosfch/video/upload/v1744962723/exercise_videos/wqgcpxhzjc2ostfj3zkx.mp4	2025-04-18 07:52:10.343
9	Lunges	7.00	2025-04-18 07:53:52.807	A lower-body exercise that strengthens the quads, hamstrings, and glutes.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744962776/exercise_images/y1m7zh7uvcwk7ztdpwac.jpg	Legs	https://res.cloudinary.com/dqcdosfch/video/upload/v1744962826/exercise_videos/nsgp8lhpmvdj6bsdkqpi.mp4	2025-04-18 07:53:52.808
10	Plank	4.50	2025-04-18 07:54:05.444	An isometric core exercise that targets the abs and back.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744962836/exercise_images/akrc34kglgcn8hzacwqk.jpg	Legs	https://res.cloudinary.com/dqcdosfch/video/upload/v1744962838/exercise_videos/fdulf9w533dxnjiv6xq3.mp4	2025-04-18 07:54:05.445
12	Burpees	5.50	2025-04-18 08:01:19.728	Burpees are a high-intensity full-body exercise that combines squats, jumps, and push-ups. It increases heart rate while targeting various muscle groups, including the chest, legs, arms, and core. Burpees are effective for burning calories and improving cardiovascular health\n	https://res.cloudinary.com/dqcdosfch/image/upload/v1744963255/exercise_images/osxstgbln7r9gj2lfsrb.jpg	Full Body	https://res.cloudinary.com/dqcdosfch/video/upload/v1744963273/exercise_videos/x1vwcd0mm28jdkwvqk64.mp4	2025-04-18 08:01:19.73
13	Cable Rows	6.00	2025-04-18 08:03:45.283	Cable rows are a back exercise performed using a cable machine. The movement involves pulling a handle towards your torso while keeping the back straight. This exercise primarily targets the upper back, including the lats, rhomboids, and traps, and also engages the biceps and forearms.\n	https://res.cloudinary.com/dqcdosfch/image/upload/v1744963413/exercise_images/pjfq90unpsc2lmqflnjd.jpg	Back	https://res.cloudinary.com/dqcdosfch/video/upload/v1744963418/exercise_videos/hpfthxzvsvbh4ttflkta.mp4	2025-04-18 08:03:45.285
14	Crunches	6.00	2025-04-18 08:04:25.391	Crunches are a popular abdominal exercise that specifically targets the rectus abdominis. By lying on your back and lifting your upper body towards your knees, crunches help tone the abdominal muscles, improve core strength, and support better posture.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744963457/exercise_images/z6catchd6pvyhyj55ebr.jpg	Core	https://res.cloudinary.com/dqcdosfch/video/upload/v1744963459/exercise_videos/lj9bobzidvenupi0w0wm.mp4	2025-04-18 08:04:25.392
16	Dumbbell Rows	6.50	2025-04-18 08:12:21.705	Dumbbell rows are a simple yet effective exercise to target the back muscles. Performed with one dumbbell at a time, this exercise focuses on the lats, rhomboids, and traps while also engaging the biceps. It helps improve posture and upper body strength.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744963815/exercise_images/onc9w3ccgqcqf7zvnvyt.jpg	Back	https://res.cloudinary.com/dqcdosfch/video/upload/v1744963934/exercise_videos/mg1rfwd40hkwrbfvpocl.mp4	2025-04-18 08:12:21.707
17	Dumbbell Side Delts	6.50	2025-04-18 08:16:24.338	Dumbbell side lateral raises are an effective isolation exercise targeting the lateral deltoids (side of the shoulders). This exercise helps to develop shoulder width, enhancing the overall look of the upper body. It’s performed by raising dumbbells out to the sides while keeping the elbows slightly bent.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744964108/exercise_images/rqyr7ejvsvw9xyz5m8qj.jpg	Shoulders	https://res.cloudinary.com/dqcdosfch/video/upload/v1744964176/exercise_videos/uqu2uxet9jq2xpzwp9j4.mp4	2025-04-18 08:16:24.341
18	Hammer Curls	6.00	2025-04-18 08:17:30.203	Hammer curls are a variation of bicep curls that target both the biceps and forearms. The exercise involves holding the dumbbells with a neutral grip (palms facing each other) and curling them towards your shoulders. This helps build both the biceps and the brachialis muscle.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744964191/exercise_images/zk9ur4fyuoodfttvhahl.jpg	Arms	https://res.cloudinary.com/dqcdosfch/video/upload/v1744964243/exercise_videos/ifpnuqviblxhjbluu6ml.mp4	2025-04-18 08:17:30.205
19	Headstand	6.00	2025-04-18 08:18:14.951	The headstand is a challenging yoga pose that involves balancing your body upside down on your head. It primarily works the shoulders, core, and arms while improving balance and stability. It's a great exercise for building strength and confidence in your upper body.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744964286/exercise_images/ktvqhrske9wrky0pnfqe.jpg	Core	https://res.cloudinary.com/dqcdosfch/video/upload/v1744964288/exercise_videos/vc5xng8b1pyv5bwjtc5x.mp4	2025-04-18 08:18:14.952
20	Jumping Jack	7.00	2025-04-18 08:19:01.747	Jumping jacks are a classic cardiovascular exercise that engages the whole body. This full-body movement increases heart rate and targets the legs, core, and arms. It's an effective warm-up exercise and helps improve cardiovascular endurance.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744964332/exercise_images/zibiegxvi6olhncnpj7o.jpg	Full Body	https://res.cloudinary.com/dqcdosfch/video/upload/v1744964335/exercise_videos/nvhkhmpriqtvoiihhjop.mp4	2025-04-18 08:19:01.749
21	Leg Press	7.00	2025-04-18 08:20:18.1	The leg press is a machine-based exercise that targets the quadriceps, hamstrings, and glutes. By pressing a weighted platform with the legs, this exercise helps to build lower body strength and muscle mass, particularly in the thighs and buttocks.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744964408/exercise_images/pcouf2a4bbjcfdhz1bb2.jpg	Legs	https://res.cloudinary.com/dqcdosfch/video/upload/v1744964411/exercise_videos/dbkzdpzp2haivzkoiivr.mp4	2025-04-18 08:20:18.102
22	Pull-Ups	7.00	2025-04-18 08:21:50.699	Pull-ups are a bodyweight exercise that targets the back, biceps, and shoulders. This exercise involves hanging from a bar and pulling the body upward, which helps to build upper body strength and muscle mass.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744964502/exercise_images/ge0ty0qidrxxr1w1jyby.jpg	Back	https://res.cloudinary.com/dqcdosfch/video/upload/v1744964504/exercise_videos/a2ehrrsgbkgc7omrd2mj.mp4	2025-04-18 08:21:50.701
23	Rope Cardio	7.00	2025-04-18 08:26:08.241	Rope cardio, often performed with a jump rope, is an excellent cardiovascular workout that targets the legs, arms, and core. This exercise improves endurance and helps with fat burning while engaging multiple muscle groups simultaneously.	https://res.cloudinary.com/dqcdosfch/image/upload/v1744964752/exercise_images/iydzjdrnk2s7fp5gu85f.jpg	Full Body	https://res.cloudinary.com/dqcdosfch/video/upload/v1744964759/exercise_videos/ooflbxiqnamjwemssghq.mp4	2025-04-18 08:26:08.242
24	Inclined Pushups	12.00	2025-04-20 12:58:13.842	Best for chest	https://res.cloudinary.com/dqcdosfch/image/upload/v1745153879/exercise_images/pnt5uttctnug2h7hssp0.png	Chest	https://res.cloudinary.com/dqcdosfch/video/upload/v1745153882/exercise_videos/qnrxtdxjnydgk5hrbctt.mp4	2025-04-20 12:58:13.844
25	Leg Raises	5.50	2025-04-21 05:21:51.64	A core exercise that targets the lower abdominals and hip flexors.	\N	Core, Hip Flexors	\N	2025-04-21 05:21:51.681
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
19	2	4	1.00	2025-04-19 19:59:21.143
20	27	7	1.00	2025-04-20 13:00:52.398
\.


--
-- Data for Name: meals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meals (meal_id, diet_plan_id, meal_name, meal_time, calories, description, created_at, macronutrients, image) FROM stdin;
9	5	Turkey Sandwich on Whole Grain Bread	Lunch	550.00	A lean turkey sandwich with whole-grain bread and veggies. Recipe:  Layer 2 slices of turkey breast on whole grain bread with lettuce, tomatoes, and mustard. 	2025-04-19 18:46:39.994	"{\\"protein\\":35.0,\\"carbs\\":50.0,\\"fat\\":15.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745088390/meal_images/supzwm5vylhunlezimjm.jpg
8	5	Oatmeal with Peanut Butter	Breakfast	450.00	A high-energy breakfast of oatmeal with peanut butter and banana. Recipe: Cook 1/2 cup oats with almond milk. Stir in 1 tablespoon peanut butter and top with banana slices.	2025-04-19 18:46:10.216	"{\\"protein\\":15.0,\\"carbs\\":60.0,\\"fat\\":18.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745088361/meal_images/wpztgvmzan6beil5moes.jpg
10	5	Grilled Fish with Sweet Potatoes	Dinner	500.00	Grilled fish fillets served with roasted sweet potatoes. Recipe:  Grill fish fillets with lemon and herbs. Roast sweet potatoes with olive oil and rosemary.	2025-04-19 18:47:13.152	"{\\"protein\\":35.0,\\"carbs\\":50.0,\\"fat\\":15.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745088424/meal_images/bvbeeiw5kemnkeoknecn.jpg
7	4	Chicken Stir Fry with Brown Rice	Dinner	600.00	A hearty chicken stir-fry served with brown rice and vegetables. Recipe: Sauté sliced chicken with onions and bell peppers in olive oil.  Serve with cooked brown rice and soy sauce.	2025-04-19 18:36:47.673	"{\\"protein\\":40.0,\\"carbs\\":50.0,\\"fat\\":25.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087798/meal_images/a1hlfxj9byuoddbx7vhs.jpg
2	3	Spinach Banana Smoothie	Breakfast	350.00	A refreshing smoothie made with spinach, banana, and almond milk. Recipe: Blend 1 banana, a handful of spinach, and 1/2 cup of almond milk. Add 1 tablespoon of chia seeds and blend until smooth.	2025-04-19 18:25:07.382	"{\\"protein\\":8.0,\\"carbs\\":50.0,\\"fat\\":10.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087098/meal_images/dbxug0f41a4pvhcbaksl.jpg
3	3	Grilled Chicken Salad	Lunch	550.00	A light and healthy grilled chicken salad with fresh veggies. Recipe: Grill chicken breast with olive oil, lemon juice, and herbs. Toss with mixed greens, tomatoes, cucumbers, and a light vinaigrette. 	2025-04-19 18:26:06.35	"{\\"protein\\":40.0,\\"carbs\\":30.0,\\"fat\\":25.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087157/meal_images/dstu4a6vsqxc38hatdsj.jpg
4	3	Baked Salmon with Roasted Veggies	Dinner	400.00	Oven-baked salmon served with roasted vegetables like carrots, zucchini, and bell peppers. Recipe: Season salmon with lemon and herbs, bake at 400°F for 15 minutes. Roast carrots, zucchini, and bell peppers in olive oil.	2025-04-19 18:27:33.78	"{\\"protein\\":35.0,\\"carbs\\":20.0,\\"fat\\":20.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087244/meal_images/ql7sskx5lyuoiez0abyz.jpg
5	4	Scrambled Eggs with Avocado Toast	Breakfast	500.00	Protein-packed scrambled eggs paired with creamy avocado toast. Recipe: Scramble 3 eggs with spinach in a non-stick pan. Toast 2 slices of whole-wheat bread, top with mashed avocado. 	2025-04-19 18:33:45.753	"{\\"protein\\":25.0,\\"carbs\\":40.0,\\"fat\\":25.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087616/meal_images/mddhf2dasjinlmch2ojv.jpg
6	4	Grilled Chicken and Quinoa	Lunch	700.00	A healthy, high-protein meal with quinoa and grilled chicken. Recipe: Grill chicken breast and serve with cooked quinoa and steamed broccoli. Drizzle with olive oil and lemon juice. 	2025-04-19 18:35:09.825	"{\\"protein\\":45.0,\\"carbs\\":60.0,\\"fat\\":30.0}"	https://res.cloudinary.com/dqcdosfch/image/upload/v1745087700/meal_images/i4k1ximwyjtxrme4fhfz.jpg
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
4	6	2025-04-04	2025-07-04	Active	2025-04-04 09:09:58.107	2025-04-04 09:09:58.107	2
5	7	2025-04-06	2025-05-06	Active	2025-04-05 19:11:31.219	2025-04-05 19:11:31.219	1
7	16	2025-04-07	2025-05-07	Active	2025-04-07 10:38:36.02	2025-04-07 10:38:36.02	1
8	17	2025-04-09	2025-05-09	Active	2025-04-09 05:37:47.326	2025-04-09 05:37:47.326	1
13	18	2025-04-12	2025-05-12	Active	2025-04-12 19:36:52.652	2025-04-12 19:36:52.652	1
22	21	2025-04-15	2025-05-15	Active	2025-04-15 08:01:24.644	2025-04-15 08:01:24.644	2
23	1	2025-04-15	2025-04-15	Pending	2025-04-15 10:58:41.065	2025-04-15 10:58:41.065	1
14	20	2025-04-13	2025-05-13	Cancelled	2025-04-13 11:30:59.885	2025-04-13 11:30:59.885	1
24	22	2025-04-18	2025-05-18	Active	2025-04-18 09:09:31.676	2025-04-18 09:09:31.676	2
26	27	2025-04-20	2025-05-20	Active	2025-04-20 12:52:32.23	2025-04-20 12:52:32.23	1
28	2	2025-04-21	2025-05-21	Active	2025-04-21 04:55:01.246	2025-04-21 04:55:01.246	1
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, membership_id, user_id, price, payment_method, payment_date, payment_status, created_at, transaction_id, pidx) FROM stdin;
4	4	6	4500.00	Cash	2025-04-04	Paid	2025-04-04 09:09:58.151	MANUAL-1743757798150-432	\N
5	5	7	1500.00	Cash	2025-04-05	Paid	2025-04-05 19:11:31.265	MANUAL-1743880291261-142	\N
7	7	16	1500.00	Cash	2025-04-07	Paid	2025-04-07 10:38:36.047	MANUAL-1744022316045-782	\N
8	8	17	1500.00	Online	2025-04-09	Paid	2025-04-09 05:37:47.352	MANUAL-1744177067351-293	\N
11	13	18	1500.00	Khalti	2025-04-12	Paid	2025-04-12 19:36:53.209	TXN-1744486612688-18	n6a5wwqTkLwa9rqYRHVRNU
12	14	20	1500.00	Cash	2025-04-13	Paid	2025-04-13 11:30:59.885	TXN-1744543859884-20	\N
20	22	21	4500.00	Khalti	2025-04-15	Paid	2025-04-15 08:01:25.113	TXN-1744704084684-21	Qr9envycKsk3drEaEUHYUT
21	23	1	1500.00	Cash	2025-04-15	Pending	2025-04-15 10:58:41.065	TXN-1744714721063-1	\N
22	24	22	4500.00	Khalti	2025-04-18	Paid	2025-04-18 09:09:32.28	TXN-1744967371680-22	ZJ2k3DocS9ZRLmFVejzoiT
24	26	27	1500.00	Khalti	2025-04-20	Paid	2025-04-20 12:52:32.614	TXN-1745153552233-27	iJgPAAFV5vtPztaXWFMN96
26	28	2	1500.00	Khalti	2025-04-21	Paid	2025-04-21 04:55:01.712	TXN-1745211301248-2	9Ty7qD5gTkEqA4rJ8mXQAW
\.


--
-- Data for Name: personal_bests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_bests (personal_best_id, user_id, weight, reps, achieved_at, supported_exercise_id) FROM stdin;
1	2	120.00	3	2025-04-09 06:58:12.639	1
2	2	130.00	3	2025-04-10 02:38:50.561	1
3	2	120.00	1	2025-04-10 05:21:02.281	3
4	2	130.00	2	2025-04-10 05:21:10.888	3
6	20	120.00	3	2025-04-13 11:39:19.829	1
7	20	121.00	2	2025-04-13 11:39:26.647	1
8	21	65.00	3	2025-04-15 08:04:17.969	1
9	21	150.00	2	2025-04-15 08:04:28.987	3
10	2	200.00	3	2025-04-15 08:13:36.215	1
11	2	210.00	2	2025-04-20 04:53:44.626	1
12	2	120.00	1	2025-04-20 04:54:51.616	3
13	27	120.00	1	2025-04-20 12:54:34.947	1
14	27	125.00	1	2025-04-20 12:54:41.199	1
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
5	Sita	Sita	Pokhara	154	55	Male	sita@gmail.com	$2a$12$NFuegjzHS7hhyZ59kmGLb.AIZmiN32T0FNUdfQwFLdRX1xz5B35e2	121212121212	Member	Beginner	Weight Loss		2025-04-04 09:07:32.781	2025-04-04 09:07:32.781		1200.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743757651/profile_images/wwp2kkuwohoh7ejkmq7s.png	\N	\N	1997-12-12 00:00:00	\N	\N	t	\N
6	Sailesh	Sailesh Gurung	Birauta	170	73	Male	saileshgurung@gmail.com	$2a$12$2nXBceObMuMYyLNsVr.Eze/SHsV.s2aKkGjayL5UyGj31XnX4VW7m	98767545643	Member	Advanced	Muscle Gain		2025-04-04 09:09:20.799	2025-04-04 09:09:20.799	nothing	2400.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743757759/profile_images/p1r8ywzcspwrtbdvvbrn.png	\N	\N	2002-11-11 00:00:00	\N	\N	t	\N
7	Rahul	Rahul Rauniyar	Nayabazar, Pokhara	175	90	Male	rahulrauniyar@gmail.com	$2a$12$BEQ6vh7HK2j7W5secocZ4edWBNKzHw9dJvF/N3y31wV2slvvcddrG	9806767888	Member	Beginner	Weight Loss		2025-04-05 19:10:05.858	2025-04-05 19:12:47.214	nothing	600.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743880205/profile_images/qbfqylac7jsy53oai2xh.png	\N	\N	1998-12-12 00:00:00	\N	\N	t	\N
4	ram	Ram	Bagale Tol	187	90	Male	ram@gmail.com	$2a$12$BrIjGA/akJtW3VBHL7bHguukDaA/RtLrBS2X15Kjg4TAfwrWQ99vq	9812121212	Member	Beginner	Weight Loss		2025-04-04 08:59:48.044	2025-04-04 08:59:48.044	milk	1800.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1743880205/profile_images/qbfqylac7jsy53oai2xh.png	\N	\N	1999-12-04 00:00:00	\N	\N	t	\N
21	krish	krish shrestya	fulbari	179.0	89	Male	matricyt7@gmail.com	$2a$12$FC8HVEfXY6fDF1VLpV3X1ew5QxdOpmbofFlHWKpLqI.CWfhbKPhN6	9806678476	Member	Advanced	Weight Loss	\N	2025-04-15 07:58:31.918	2025-04-15 08:03:37.078	flower	1300.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744704049/profile_images/js9xvbqoyeohly71v3u6.jpg	\N	\N	2006-03-22 00:00:00	\N	\N	t	\N
27	sujon	Sujon Thapa	Pokhara 8 	170.0	70	Male	sujonthapa88@gmail.com	$2a$12$U.8DgQjUmcCvbUPcYz4Ab.jxU7a8YdqS7CyIaqfQqNnJwvJQiOnQG	9819177029	Trainer	Beginner	Muscle Gain	\N	2025-04-20 12:48:14.256	2025-04-20 12:54:04.634	beans	2000.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1745153427/profile_images/h2aez5h0noxloadieh7f.jpg	\N	\N	1994-04-25 00:00:00	\N	\N	t	\N
9	Rahul Don	Rahul Gupta	Pokhara	172.0	70.0	Male	rahultech730@gmail.com	$2a$12$v0FkkelN/zWSRCqvg2x8OOa6grGL8j/m5u/vm1LOfPs79/TCrytxC	9806767880	Member	Beginner	Flexibility	\N	2025-04-07 09:19:52.003	2025-04-07 09:19:52.003	nothing	1600.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744018380/profile_images/z5hkorhzm3afka9hzrn7.jpg	\N	\N	2001-04-12 00:00:00	\N	\N	t	\N
1	Aashish	Aashish Rauniyar	Nepal	175.5	70.2	Male	rauniyaaraashish@gmail.com	$2a$12$juVZxo6Hh3LDonhDwus5FO9guL3I24LSI8Y2CzX./aQLkuwrcZ6e.	1234567890	Admin	Athlete	Weight Loss	23C14111	2025-04-04 08:31:35.382	2025-04-15 11:06:47.739	None	2500.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744715207/profile_images/fhy76zwrwtq8eax8icew.jpg	\N	\N	2002-03-12 00:00:00	264453	2025-04-21 05:31:44.272	t	\N
22	ananvolk	rabin Ranabhat 	LEKHNATH 	182.0	96	Male	ananvolk0000@gmail.com	$2a$12$NS19W3n9LBWUtDt2x7Xyn.ZhC6AVRAcymGPstHmcKxriGE2bepI5e	9826195292	Member	Beginner	Weight Loss	\N	2025-04-18 08:58:52.108	2025-04-18 09:15:28.655		2000.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744966953/profile_images/ezrqooktqfq2jnylbiwg.jpg	\N	\N	2003-11-26 00:00:00	\N	\N	t	\N
17	test	test user	Pokhara	160	64	Female	test@gmail.com	$2a$12$fsk/Hwn99TpOXYDvUGQdi.4ocWmrPbWlBYrv6/fWm7eYtPEU.0BmW	1212121213	Trainer	Intermediate	Endurance		2025-04-09 05:36:52.184	2025-04-09 05:37:14.649	nothing	1200.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744177009/profile_images/dgwncefbwjifeamnagxq.png	\N	\N	2002-12-02 00:00:00	\N	\N	t	\N
20	aacis	Hashish Rauniyar	Pokhara	170.0	70.0	Male	ak.aashish19@gmail.com	$2a$12$tL77oQxstVxqhr2VeABKteT0vOQdENo.yimKMSKermXKTm0vDE6Ly	9806754601	Member	Beginner	Weight Loss	\N	2025-04-13 11:28:37.268	2025-04-13 11:28:37.268	nop	1600.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744543822/profile_images/mxgu1wwkdmlkdjbx4p46.jpg	\N	\N	2005-04-18 00:00:00	\N	\N	t	\N
16	Abishek	Abishek Khadka	Pokhara	170.0	78	Male	abishekkhadka70@gmail.com	$2a$12$5s.5AWrtAjb8mwzSsph9Ee6tZma3Ag0ObiUmkgkKTDylOkF4R5sjC	9806754600	Trainer	Beginner	Weight Loss	\N	2025-04-07 10:22:41.066	2025-04-10 02:20:07.57	diya thapa	2000.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744021580/profile_images/wqcxdb2evswypxkykxp7.jpg	\N	\N	2005-04-12 00:00:00	\N	\N	t	\N
23	Gamer	Gamer Dude	Pokhara	164.0	60.0	Male	gamera.ashish@universityedu.top	$2a$12$JmMnBVfKwArhRK00PPYXs.ZFQxx45CIKgs/kM2AOmSSEUKJ9hbbTG	9878675676	Member	Beginner	Weight Loss	\N	2025-04-18 09:40:36.277	2025-04-18 09:40:36.277		2000.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744969413/profile_images/vy6gbrwmsfvjeb3dczbb.jpg	\N	\N	2002-04-23 00:00:00	\N	\N	t	\N
18	Rahul Rauniyar	Rahul Rauniyar	Pokhara	170.0	75	Female	me.splashrahul@gmail.com	$2a$12$URXQY8Ey1O7ISe1lpOV44.gTLTf6NRF6FMJC1b660d2/oQzZv2hni	9878675467	Member	Beginner	Weight Loss	wwww	2025-04-09 10:08:03.313	2025-04-20 04:24:39.408	nothing	1450.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744193857/profile_images/kldupg5pxjrngu57omba.jpg	\N	\N	1991-05-25 00:00:00	\N	\N	t	\N
25	Ram	Ram	Kathmandu	170.0	62.5	Female	rauniyaarkrisha@gmail.com	$2a$12$GOaM9VsuYDT7Ip/yAO7ZS.4i2Q4hmRlCIsq.tZjRS3SppHjMIU1F6	9823456516	Member	Beginner	Weight Loss	\N	2025-04-19 17:51:44.235	2025-04-19 17:51:44.235	nothing	1800.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1745085253/profile_images/rwqjf0tuaor57xyfqjf4.jpg	\N	\N	2005-04-24 00:00:00	\N	\N	t	\N
2	trainer	Aashish Gupta	Kathmandu	175	75	Male	trainer@gmail.com	$2a$12$nxjAPaQCCsuLgElbTpEHS.zbr2nS.NMy0KQzD4GYWAjDqIAb1/7Ly	9801234567	Trainer	Intermediate	Endurance	KOKO	2025-04-04 08:34:26.53	2025-04-21 05:21:51.453	Peanuts	1500.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1744714427/profile_images/jwrtj47wueievnem8g4d.jpg	\N	\N	2002-12-12 00:00:00	\N	\N	t	\N
29	Secret	Secret	Pokhara	170.0	70.0	Male	secretsofaashish@gmail.com	$2a$12$4./GBYmZHrQ1A.1YKwakRuwxsRWVjbOGotT3Sx5wrQnvUtbWSMh/S	9807878900	Member	Beginner	Weight Loss	\N	2025-04-21 08:53:52.315	2025-04-21 08:53:52.315		2000.00	\N	\N	\N	2005-04-26 00:00:00	\N	\N	t	\N
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
14	2	80.00	2025-04-13 02:32:45.695
15	2	82.00	2025-04-13 03:04:11.224
16	2	83.00	2025-04-13 03:06:02.858
17	2	84.00	2025-04-13 03:06:13.579
18	2	85.00	2025-04-13 03:08:51.126
19	2	86.00	2025-04-13 03:09:17.489
20	21	90.00	2025-04-15 08:03:29.007
21	21	89.00	2025-04-15 08:03:37.079
22	22	90.00	2025-04-18 09:13:29.383
23	22	88.00	2025-04-18 09:13:34.597
24	22	96.00	2025-04-18 09:15:28.657
25	18	75.00	2025-04-20 04:24:39.45
26	27	70.00	2025-04-20 12:53:54.204
27	27	72.00	2025-04-20 12:53:58.213
28	27	70.00	2025-04-20 12:54:04.635
29	2	75.00	2025-04-21 05:21:51.459
\.


--
-- Data for Name: workoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexercises (workout_exercise_id, workout_id, exercise_id, sets, reps, duration) FROM stdin;
5	7	8	3	12	12.00
6	7	12	3	12	12.00
7	8	7	3	12	1.00
8	8	13	3	12	10.00
9	8	16	2	13	10.00
10	8	22	4	15	10.00
11	9	6	3	12	12.00
12	9	9	3	12	12.00
13	9	10	3	12	8.00
15	9	21	4	13	10.00
16	10	5	3	12	10.00
17	10	18	3	15	12.00
\.


--
-- Data for Name: workoutexerciseslogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexerciseslogs (log_id, workout_log_id, exercise_id, skipped, exercise_duration, rest_duration) FROM stdin;
12	10	8	f	0.20	0.33
13	10	12	f	0.17	0.02
14	11	8	f	0.68	0.50
15	11	12	f	0.02	0.00
16	12	7	f	0.83	0.05
17	12	13	f	0.02	0.02
18	12	16	f	0.00	0.02
19	12	22	f	0.00	0.00
20	13	8	f	0.18	0.18
21	13	12	f	0.12	0.02
\.


--
-- Data for Name: workoutlogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutlogs (log_id, user_id, workout_id, workout_date, calories_burned, performance_notes, total_duration) FROM stdin;
10	22	7	2025-04-18 09:04:56.313	0.00	its didn't go well	0.72
11	2	7	2025-04-18 09:55:13.642	0.00		1.20
12	2	8	2025-04-19 16:53:18.636	0.00	Should increase weights next time.	0.93
13	27	7	2025-04-20 13:00:03.878	0.00	ramro workout vayo	0.50
\.


--
-- Data for Name: workouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workouts (workout_id, user_id, workout_name, description, target_muscle_group, difficulty, trainer_id, created_at, updated_at, fitness_level, goal_type, workout_image) FROM stdin;
7	\N	Chest Workout	Best workout plan for proper development of chest.	Chest	Easy	2	2025-04-18 08:35:35.244	2025-04-18 08:35:35.246	Beginner	Muscle Gain	https://res.cloudinary.com/dqcdosfch/image/upload/v1744965330/workout_images/zbcez7hdlvpadjjt2j1j.jpg
8	\N	Ultimate Back Workout	The best back workout routine for a properly toned and strong back	Back	Intermediate	2	2025-04-18 08:51:24.898	2025-04-18 08:51:24.903	Beginner	Muscle Gain	https://res.cloudinary.com/dqcdosfch/image/upload/v1744966279/workout_images/yio7u2oqvj3ufosdlv98.jpg
9	\N	Leg Routine	Best workout for strong legs. Do it twice a week for better result	Legs	Hard	2	2025-04-18 08:53:19.065	2025-04-18 08:53:19.067	Intermediate	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1744966393/workout_images/uofuzjvdrjnt4wxcrptk.jpg
10	\N	Arms Routine	Best biceps and arms workout for gorilla like arms	Arms	Easy	2	2025-04-18 08:55:39.876	2025-04-18 08:55:39.877	Intermediate	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1744966534/workout_images/m5mbszrghs7z9nzp8odm.jpg
11	\N	Aashish Workout	A comprehensive workout for overall strength. Very nice and effective for weight loss.  	Full Body	Intermediate	2	2025-04-21 05:22:03	2025-04-21 05:22:03.001	Beginner	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1745212922/workout_images/mhtmlsb3jaq1jdbhkg7g.jpg
\.


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 5, true);


--
-- Name: chatconversations_chat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatconversations_chat_id_seq', 1, false);


--
-- Name: chatmessages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatmessages_message_id_seq', 53, true);


--
-- Name: customworkoutexercises_custom_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkoutexercises_custom_workout_exercise_id_seq', 12, true);


--
-- Name: customworkouts_custom_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkouts_custom_workout_id_seq', 13, true);


--
-- Name: dietplans_diet_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dietplans_diet_plan_id_seq', 5, true);


--
-- Name: exercises_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercises_exercise_id_seq', 25, true);


--
-- Name: gym_gym_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gym_gym_id_seq', 1, false);


--
-- Name: meallogs_meal_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meallogs_meal_log_id_seq', 20, true);


--
-- Name: meals_meal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meals_meal_id_seq', 10, true);


--
-- Name: membership_plan_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membership_plan_plan_id_seq', 2, true);


--
-- Name: memberships_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memberships_membership_id_seq', 28, true);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 26, true);


--
-- Name: personal_bests_personal_best_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_bests_personal_best_id_seq', 14, true);


--
-- Name: subscription_changes_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscription_changes_change_id_seq', 1, false);


--
-- Name: supported_exercises_supported_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supported_exercises_supported_exercise_id_seq', 4, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 29, true);


--
-- Name: weight_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weight_logs_id_seq', 29, true);


--
-- Name: workoutexercises_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexercises_workout_exercise_id_seq', 17, true);


--
-- Name: workoutexerciseslogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexerciseslogs_log_id_seq', 21, true);


--
-- Name: workoutlogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutlogs_log_id_seq', 13, true);


--
-- Name: workouts_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workouts_workout_id_seq', 11, true);


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

