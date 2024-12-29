--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-12-27 14:01:19

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
-- TOC entry 5 (class 2615 OID 124126)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 885 (class 1247 OID 124137)
-- Name: difficulty_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.difficulty_level AS ENUM (
    'Easy',
    'Intermediate',
    'Hard'
);


ALTER TYPE public.difficulty_level OWNER TO postgres;

--
-- TOC entry 888 (class 1247 OID 124144)
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
-- TOC entry 891 (class 1247 OID 124154)
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'Male',
    'Female',
    'Other'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- TOC entry 894 (class 1247 OID 124162)
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
-- TOC entry 897 (class 1247 OID 124174)
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
-- TOC entry 900 (class 1247 OID 124184)
-- Name: membership_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.membership_status AS ENUM (
    'Active',
    'Expired',
    'Cancelled'
);


ALTER TYPE public.membership_status OWNER TO postgres;

--
-- TOC entry 903 (class 1247 OID 124192)
-- Name: payment_method; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method AS ENUM (
    'Khalti',
    'Cash'
);


ALTER TYPE public.payment_method OWNER TO postgres;

--
-- TOC entry 906 (class 1247 OID 124198)
-- Name: payment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status AS ENUM (
    'Paid',
    'Pending',
    'Failed'
);


ALTER TYPE public.payment_status OWNER TO postgres;

--
-- TOC entry 909 (class 1247 OID 124206)
-- Name: plan_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.plan_type AS ENUM (
    'Monthly',
    'Yearly',
    'Quaterly'
);


ALTER TYPE public.plan_type OWNER TO postgres;

--
-- TOC entry 915 (class 1247 OID 124222)
-- Name: role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role AS ENUM (
    'Member',
    'Trainer',
    'Admin'
);


ALTER TYPE public.role OWNER TO postgres;

--
-- TOC entry 912 (class 1247 OID 124214)
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
-- TOC entry 215 (class 1259 OID 124127)
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
-- TOC entry 217 (class 1259 OID 124230)
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
-- TOC entry 216 (class 1259 OID 124229)
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
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 216
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_attendance_id_seq OWNED BY public.attendance.attendance_id;


--
-- TOC entry 219 (class 1259 OID 124237)
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
-- TOC entry 218 (class 1259 OID 124236)
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
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 218
-- Name: chatconversations_chat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chatconversations_chat_id_seq OWNED BY public.chatconversations.chat_id;


--
-- TOC entry 221 (class 1259 OID 124245)
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
-- TOC entry 220 (class 1259 OID 124244)
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
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 220
-- Name: chatmessages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chatmessages_message_id_seq OWNED BY public.chatmessages.message_id;


--
-- TOC entry 223 (class 1259 OID 124256)
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
-- TOC entry 222 (class 1259 OID 124255)
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
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 222
-- Name: customworkoutexercises_custom_workout_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customworkoutexercises_custom_workout_exercise_id_seq OWNED BY public.customworkoutexercises.custom_workout_exercise_id;


--
-- TOC entry 225 (class 1259 OID 124263)
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
-- TOC entry 224 (class 1259 OID 124262)
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
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 224
-- Name: customworkouts_custom_workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customworkouts_custom_workout_id_seq OWNED BY public.customworkouts.custom_workout_id;


--
-- TOC entry 227 (class 1259 OID 124271)
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
-- TOC entry 226 (class 1259 OID 124270)
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
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 226
-- Name: dietlogs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dietlogs_log_id_seq OWNED BY public.dietlogs.log_id;


--
-- TOC entry 229 (class 1259 OID 124281)
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
-- TOC entry 228 (class 1259 OID 124280)
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
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 228
-- Name: dietplans_diet_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dietplans_diet_plan_id_seq OWNED BY public.dietplans.diet_plan_id;


--
-- TOC entry 231 (class 1259 OID 124292)
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
-- TOC entry 230 (class 1259 OID 124291)
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
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 230
-- Name: exercises_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exercises_exercise_id_seq OWNED BY public.exercises.exercise_id;


--
-- TOC entry 233 (class 1259 OID 124300)
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
-- TOC entry 232 (class 1259 OID 124299)
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
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 232
-- Name: gym_gym_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gym_gym_id_seq OWNED BY public.gym.gym_id;


--
-- TOC entry 235 (class 1259 OID 124309)
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
-- TOC entry 234 (class 1259 OID 124308)
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
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 234
-- Name: meals_meal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.meals_meal_id_seq OWNED BY public.meals.meal_id;


--
-- TOC entry 251 (class 1259 OID 124528)
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
-- TOC entry 250 (class 1259 OID 124527)
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
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 250
-- Name: membership_plan_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.membership_plan_plan_id_seq OWNED BY public.membership_plan.plan_id;


--
-- TOC entry 237 (class 1259 OID 124319)
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
-- TOC entry 236 (class 1259 OID 124318)
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
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 236
-- Name: memberships_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memberships_membership_id_seq OWNED BY public.memberships.membership_id;


--
-- TOC entry 239 (class 1259 OID 124328)
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
-- TOC entry 238 (class 1259 OID 124327)
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
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 238
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- TOC entry 255 (class 1259 OID 124568)
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
-- TOC entry 254 (class 1259 OID 124567)
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
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 254
-- Name: personal_bests_personal_best_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_bests_personal_best_id_seq OWNED BY public.personal_bests.personal_best_id;


--
-- TOC entry 253 (class 1259 OID 124543)
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
-- TOC entry 252 (class 1259 OID 124542)
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
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 252
-- Name: subscription_changes_change_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscription_changes_change_id_seq OWNED BY public.subscription_changes.change_id;


--
-- TOC entry 257 (class 1259 OID 125473)
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
-- TOC entry 256 (class 1259 OID 125472)
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
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 256
-- Name: supported_exercises_supported_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supported_exercises_supported_exercise_id_seq OWNED BY public.supported_exercises.supported_exercise_id;


--
-- TOC entry 241 (class 1259 OID 124336)
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
-- TOC entry 240 (class 1259 OID 124335)
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
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 240
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 243 (class 1259 OID 124347)
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
-- TOC entry 242 (class 1259 OID 124346)
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
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 242
-- Name: workoutexercises_workout_exercise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workoutexercises_workout_exercise_id_seq OWNED BY public.workoutexercises.workout_exercise_id;


--
-- TOC entry 247 (class 1259 OID 124490)
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
-- TOC entry 246 (class 1259 OID 124489)
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
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 246
-- Name: workoutexerciseslogs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workoutexerciseslogs_log_id_seq OWNED BY public.workoutexerciseslogs.log_id;


--
-- TOC entry 249 (class 1259 OID 124498)
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
-- TOC entry 248 (class 1259 OID 124497)
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
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 248
-- Name: workoutlogs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workoutlogs_log_id_seq OWNED BY public.workoutlogs.log_id;


--
-- TOC entry 245 (class 1259 OID 124354)
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
-- TOC entry 244 (class 1259 OID 124353)
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
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 244
-- Name: workouts_workout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workouts_workout_id_seq OWNED BY public.workouts.workout_id;


--
-- TOC entry 4827 (class 2604 OID 124233)
-- Name: attendance attendance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendance_attendance_id_seq'::regclass);


--
-- TOC entry 4828 (class 2604 OID 124240)
-- Name: chatconversations chat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations ALTER COLUMN chat_id SET DEFAULT nextval('public.chatconversations_chat_id_seq'::regclass);


--
-- TOC entry 4830 (class 2604 OID 124248)
-- Name: chatmessages message_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessages ALTER COLUMN message_id SET DEFAULT nextval('public.chatmessages_message_id_seq'::regclass);


--
-- TOC entry 4833 (class 2604 OID 124259)
-- Name: customworkoutexercises custom_workout_exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises ALTER COLUMN custom_workout_exercise_id SET DEFAULT nextval('public.customworkoutexercises_custom_workout_exercise_id_seq'::regclass);


--
-- TOC entry 4834 (class 2604 OID 124266)
-- Name: customworkouts custom_workout_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkouts ALTER COLUMN custom_workout_id SET DEFAULT nextval('public.customworkouts_custom_workout_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 124274)
-- Name: dietlogs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs ALTER COLUMN log_id SET DEFAULT nextval('public.dietlogs_log_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 124284)
-- Name: dietplans diet_plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans ALTER COLUMN diet_plan_id SET DEFAULT nextval('public.dietplans_diet_plan_id_seq'::regclass);


--
-- TOC entry 4841 (class 2604 OID 124295)
-- Name: exercises exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises ALTER COLUMN exercise_id SET DEFAULT nextval('public.exercises_exercise_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 124303)
-- Name: gym gym_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gym ALTER COLUMN gym_id SET DEFAULT nextval('public.gym_gym_id_seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 124312)
-- Name: meals meal_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals ALTER COLUMN meal_id SET DEFAULT nextval('public.meals_meal_id_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 124531)
-- Name: membership_plan plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membership_plan ALTER COLUMN plan_id SET DEFAULT nextval('public.membership_plan_plan_id_seq'::regclass);


--
-- TOC entry 4848 (class 2604 OID 124322)
-- Name: memberships membership_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships ALTER COLUMN membership_id SET DEFAULT nextval('public.memberships_membership_id_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 124331)
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 124571)
-- Name: personal_bests personal_best_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests ALTER COLUMN personal_best_id SET DEFAULT nextval('public.personal_bests_personal_best_id_seq'::regclass);


--
-- TOC entry 4869 (class 2604 OID 124546)
-- Name: subscription_changes change_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_changes ALTER COLUMN change_id SET DEFAULT nextval('public.subscription_changes_change_id_seq'::regclass);


--
-- TOC entry 4873 (class 2604 OID 125476)
-- Name: supported_exercises supported_exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supported_exercises ALTER COLUMN supported_exercise_id SET DEFAULT nextval('public.supported_exercises_supported_exercise_id_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 124339)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 4856 (class 2604 OID 124350)
-- Name: workoutexercises workout_exercise_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises ALTER COLUMN workout_exercise_id SET DEFAULT nextval('public.workoutexercises_workout_exercise_id_seq'::regclass);


--
-- TOC entry 4862 (class 2604 OID 124493)
-- Name: workoutexerciseslogs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs ALTER COLUMN log_id SET DEFAULT nextval('public.workoutexerciseslogs_log_id_seq'::regclass);


--
-- TOC entry 4864 (class 2604 OID 124501)
-- Name: workoutlogs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs ALTER COLUMN log_id SET DEFAULT nextval('public.workoutlogs_log_id_seq'::regclass);


--
-- TOC entry 4857 (class 2604 OID 124357)
-- Name: workouts workout_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts ALTER COLUMN workout_id SET DEFAULT nextval('public.workouts_workout_id_seq'::regclass);


--
-- TOC entry 5102 (class 0 OID 124127)
-- Dependencies: 215
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
6b54cd10-34b9-4fed-a57c-5b830532a95d	e04d48af3ed6fc733d37f48f76340385cafc7c1c19459a3be62bf75fd8ad60c3	2024-12-22 09:51:07.824468+05:45	20241203181959_changed_age_to_birthdate_in_users_table	\N	\N	2024-12-22 09:51:07.818574+05:45	1
6a1aeb67-26d5-4bf3-9f0b-47e3b9e1f2b9	ee7805838826e6489fe3f466a958dc7c6882d852fe70dd69703c5e6022b6506d	2024-12-22 09:51:07.679906+05:45	20241111073636_init	\N	\N	2024-12-22 09:51:07.563965+05:45	1
f0b385dd-6c7e-4112-a6e6-e95122b8dec1	ec673348243204fef1472b1ca6992bf0b6f304232cced783a8c81e50d6ae33c3	2024-12-22 09:51:07.687389+05:45	20241111174807_exercise_table_changes	\N	\N	2024-12-22 09:51:07.680811+05:45	1
104b5736-4f1b-4498-9fd8-547ce4e45846	c97a24f916b1022c774255d5d7cc93604c24c620fdb19fbb26a4ac768becac78	2024-12-22 09:51:07.692742+05:45	20241111183505_add_updated_at_column	\N	\N	2024-12-22 09:51:07.688643+05:45	1
046b5ed9-c46f-4f53-b598-fbb4258d148f	b1385f7e08aab6f7446a75a967fa5518c7fa97d7dcf49b87ac100b9a99b6cd84	2024-12-22 09:51:07.832275+05:45	20241208065803_added_workout_image_in_schema	\N	\N	2024-12-22 09:51:07.826595+05:45	1
408d5881-6383-4c6c-b976-e63c7088a96d	0f611f446830924da8c387f80b995d058902d7747ca944a34fc83745040ae4c2	2024-12-22 09:51:07.713994+05:45	20241111183607_added_updated_to_exercise	\N	\N	2024-12-22 09:51:07.694312+05:45	1
a8b3984c-d596-4eae-9dc6-ccf262bc88d2	2d55d7fd879de2af00771cf26792ced6dd0ed0b5d0407acca38debc934f0f987	2024-12-22 09:51:07.747944+05:45	20241112154203_added_workout_logs	\N	\N	2024-12-22 09:51:07.716084+05:45	1
1f8fa4ea-17e0-409b-821f-e6ed374872c4	96dba3eeaad45b800df3ea6f5af7cae813eda03835c74cd35daa3a35efcd1a7e	2024-12-22 09:51:07.754938+05:45	20241113044909_added_alleries_and_calorie_goals	\N	\N	2024-12-22 09:51:07.749021+05:45	1
1f3cc493-3e95-44ac-9f0e-dbae90898fe1	15f25aba0566f3597d72a733afc4463eb80bc96a0b51f1e186b8bdd77131f2ce	2024-12-22 09:51:07.845724+05:45	20241212064937_add_personal_best_table	\N	\N	2024-12-22 09:51:07.833884+05:45	1
3255fd7c-aca3-4b8c-94b2-86b910fdf386	09396e70247b798995949aeeb2c16503065571341c69a114ba290c12fa13e74d	2024-12-22 09:51:07.762159+05:45	20241118043614_added_missing_profile_image	\N	\N	2024-12-22 09:51:07.756631+05:45	1
f7306c40-27bf-4937-80b6-4cb019214613	ae839bb5007ee480a00b939517546a620e6cc586f1368c84593a0b689c4589ac	2024-12-22 09:51:07.768659+05:45	20241119062737_added_reset_password_fields	\N	\N	2024-12-22 09:51:07.763253+05:45	1
64e0561a-1cad-48a0-b7ee-f804b5f4f2c2	a80c7945e92ea50db9b6652400684d3329f4a7ce8c2cb3e5c7f3929dd90d8c89	2024-12-22 09:51:07.791488+05:45	20241120181422_added	\N	\N	2024-12-22 09:51:07.769635+05:45	1
dd042500-b4b2-45d1-af1a-1c8b08ffe319	0669ef38692d3612a22e52418641337e0ad42d93c58fb8dea0237afdc8d9ef1f	2024-12-22 09:51:07.85137+05:45	20241215035254_changes_in_logs	\N	\N	2024-12-22 09:51:07.846931+05:45	1
8da7dc8e-5770-49b7-97e1-8b7994a67a0b	b726ea43a1c7ee21e6d6df8c1affa71af084914f0ce78a4a4a5675bf0672d4d8	2024-12-22 09:51:07.804244+05:45	20241120182434_added_subscription_changes_and_fixed_membership	\N	\N	2024-12-22 09:51:07.792358+05:45	1
922e3aa9-b7a2-4083-8694-e94153d2bf44	e255e35a37948add5022fc54c878a0bfac478d6b1790e8abdf50e9f58be823fa	2024-12-22 09:51:07.81026+05:45	20241125183339_update_workoutexerciseslogs	\N	\N	2024-12-22 09:51:07.805404+05:45	1
bd4e268b-0eed-4519-85d1-8913776f3487	77854bb9cdc9c4ed7e04bf7b329b7788e34ca5050fc80a416fd999ab951c7663	2024-12-22 09:51:07.81741+05:45	20241203180715_add_goal_type_and_fitness_level_to_workouts	\N	\N	2024-12-22 09:51:07.811838+05:45	1
39f93da8-5ace-4ae9-b0f4-01796582b0a0	34a192eb492e51ce9595d8edf68ef416d7c4ce07938514de90147765631f6d7c	2024-12-22 09:51:09.673621+05:45	20241222040609_fix_personal_best	\N	\N	2024-12-22 09:51:09.655857+05:45	1
\.


--
-- TOC entry 5104 (class 0 OID 124230)
-- Dependencies: 217
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (attendance_id, user_id, gym_id, attendance_date) FROM stdin;
\.


--
-- TOC entry 5106 (class 0 OID 124237)
-- Dependencies: 219
-- Data for Name: chatconversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatconversations (chat_id, user_id, trainer_id, last_message, last_message_timestamp) FROM stdin;
\.


--
-- TOC entry 5108 (class 0 OID 124245)
-- Dependencies: 221
-- Data for Name: chatmessages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatmessages (message_id, chat_id, sender_id, message_content, sent_at, is_read) FROM stdin;
\.


--
-- TOC entry 5110 (class 0 OID 124256)
-- Dependencies: 223
-- Data for Name: customworkoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkoutexercises (custom_workout_exercise_id, custom_workout_id, exercise_id, sets, reps, duration) FROM stdin;
\.


--
-- TOC entry 5112 (class 0 OID 124263)
-- Dependencies: 225
-- Data for Name: customworkouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customworkouts (custom_workout_id, user_id, custom_workout_name, created_at) FROM stdin;
\.


--
-- TOC entry 5114 (class 0 OID 124271)
-- Dependencies: 227
-- Data for Name: dietlogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dietlogs (log_id, user_id, diet_plan_id, meal_id, consumed_calories, custom_meal, notes, log_date) FROM stdin;
\.


--
-- TOC entry 5116 (class 0 OID 124281)
-- Dependencies: 229
-- Data for Name: dietplans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dietplans (diet_plan_id, user_id, trainer_id, calorie_goal, goal_type, description, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5118 (class 0 OID 124292)
-- Dependencies: 231
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exercises (exercise_id, exercise_name, calories_burned_per_minute, created_at, description, image_url, target_muscle_group, video_url, updated_at) FROM stdin;
1	Leg Press	20.00	2024-12-22 04:25:08.83	Best exercise for legs	https://res.cloudinary.com/dqcdosfch/image/upload/v1734841479/exercise_images/wtzgqt97479t4bpabw5q.jpg	Legs	https://res.cloudinary.com/dqcdosfch/video/upload/v1734841507/exercise_videos/r7f3pwvgn6fym9zgzi2g.mp4	2024-12-22 04:25:08.832
2	Lat Pull Down	30.00	2024-12-22 04:30:12.828	For V taper back, pull the bar in machine to get proper back	https://res.cloudinary.com/dqcdosfch/image/upload/v1734841774/exercise_images/gmgvluzr74dhx7pvx5fs.jpg	Back	https://res.cloudinary.com/dqcdosfch/video/upload/v1734841811/exercise_videos/rgk6fwar8ck2z6jt6m4e.mp4	2024-12-22 04:30:12.831
3	Pushups	14.00	2024-12-22 04:32:32.383	Doing pushups for strong chest	https://res.cloudinary.com/dqcdosfch/image/upload/v1734841937/exercise_images/sn6bepba1jfxgeb4ugzk.jpg	Chest	https://res.cloudinary.com/dqcdosfch/video/upload/v1734841951/exercise_videos/tnnpb7hvqad6stbx8bnp.mp4	2024-12-22 04:32:32.387
4	Lunges	120.00	2024-12-25 08:02:24.717	for legs 	https://res.cloudinary.com/dqcdosfch/image/upload/v1735113740/exercise_images/f4dscvpqzyrxxecne423.jpg	Legs	https://res.cloudinary.com/dqcdosfch/video/upload/v1735113742/exercise_videos/npmnxrqp0n8ve2qe9pho.mp4	2024-12-25 08:02:24.728
5	Cable Pull Down	130.00	2024-12-25 08:26:03.951	Best of building V taper Back	https://res.cloudinary.com/dqcdosfch/image/upload/v1735115158/exercise_images/zd3eodf236tnw3rkykb1.jpg	Back	https://res.cloudinary.com/dqcdosfch/video/upload/v1735115161/exercise_videos/c41dejbdaul3d8wxk6ou.mp4	2024-12-25 08:26:03.952
\.


--
-- TOC entry 5120 (class 0 OID 124300)
-- Dependencies: 233
-- Data for Name: gym; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gym (gym_id, gym_name, location, contact_number, admin_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5122 (class 0 OID 124309)
-- Dependencies: 235
-- Data for Name: meals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meals (meal_id, diet_plan_id, meal_name, meal_time, calories, description, macronutrients, created_at) FROM stdin;
\.


--
-- TOC entry 5138 (class 0 OID 124528)
-- Dependencies: 251
-- Data for Name: membership_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membership_plan (plan_id, plan_type, price, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5124 (class 0 OID 124319)
-- Dependencies: 237
-- Data for Name: memberships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memberships (membership_id, user_id, start_date, end_date, status, created_at, updated_at, plan_id) FROM stdin;
\.


--
-- TOC entry 5126 (class 0 OID 124328)
-- Dependencies: 239
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, membership_id, user_id, price, payment_method, payment_date, payment_status, created_at, transaction_id) FROM stdin;
\.


--
-- TOC entry 5142 (class 0 OID 124568)
-- Dependencies: 255
-- Data for Name: personal_bests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_bests (personal_best_id, user_id, weight, reps, achieved_at, supported_exercise_id) FROM stdin;
\.


--
-- TOC entry 5140 (class 0 OID 124543)
-- Dependencies: 253
-- Data for Name: subscription_changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_changes (change_id, membership_id, previous_plan, new_plan, change_date, action) FROM stdin;
\.


--
-- TOC entry 5144 (class 0 OID 125473)
-- Dependencies: 257
-- Data for Name: supported_exercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supported_exercises (supported_exercise_id, exercise_name, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5128 (class 0 OID 124336)
-- Dependencies: 241
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, user_name, full_name, address, height, current_weight, gender, email, password, phone_number, role, fitness_level, goal_type, card_number, created_at, updated_at, allergies, calorie_goals, profile_image, reset_token, reset_token_expiry, birthdate) FROM stdin;
1	sandip	Rahul Gupta	Pokhara	173	65	Male	sandip@gmail.com	$2a$10$aFvbBbV5vfzyjvDoHW7SLOedycqWByNL6ZU1xEWckgKAqmc/ne.ey	1900357767	Member	Beginner	Endurance	\N	2024-12-22 04:12:46.35	2024-12-22 04:12:46.35	nothing	5300.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1734840765/profile_images/oniuwtpeeiay36xzpizy.jpg	\N	\N	2003-08-20 00:00:00
2	trainer	Rahul Gupta	Pokhara	173	65	Male	trainer@gmail.com	$2a$10$Du/NTzSwW0Tu3iEwl9g63ebRj3zCkYzBEODdflkgXChi5P/EyrJoe	9874563214	Trainer	Beginner	Endurance	\N	2024-12-22 04:13:44.762	2024-12-22 04:13:44.762	nothing	5300.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1734840824/profile_images/dqe6ilm6l5fndbq0fqok.jpg	\N	\N	2001-08-20 00:00:00
3	aashish	Aashish Gupta	Pokhara	173	65	Male	aashish@gmail.com	$2a$10$1pmZuv8JekpPvJMO1MnzeOuZ/80XGXW7ObRjFkbMicXkW83ddYtMS	9874563215	Trainer	Beginner	Endurance	\N	2024-12-22 04:15:22.196	2024-12-22 04:15:22.196	nothing	5300.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1734840921/profile_images/fyaipwm7y2uhyhdq1b2k.webp	\N	\N	2001-08-20 00:00:00
5	abishek	abishek khadka	Butwal	163.0	65.0	Male	abisekhkhadka90@gmail.com	$2a$10$174pnnswiD2xMN9aj..GMenNkw3.XR51CCkyAniuR.cjKXZw9QvcO	6547789315	Member	Intermediate	Muscle Gain	1	2024-12-24 06:36:58.451	2024-12-24 06:36:58.451	xain ayar	1200.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1735022217/profile_images/cxn1qtirfwue1nakf92s.jpg	8898976d3b76ec4c5c1b7767f58bfbc8295bca5a	2024-12-24 07:40:54.05	2001-12-24 00:00:00
6	kripa	kripa	lakeside	180.0	70.0	Male	kripa@gmail.com	$2a$10$yZZOVtpElsTCcDEpM8v9keBjAcicnyibm7D..DaQcr4zGls/O.4t.	7896541256	Member	Advanced	Muscle Gain	1	2024-12-24 06:45:32.744	2024-12-24 06:45:32.744	peanut	1470.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1735022732/profile_images/fc9hyjjrnxev89c5qn5a.jpg	\N	\N	2001-12-24 00:00:00
7	sushil	sushil	pokhara	142.0	50.2	Male	sushil@gmail.com	$2a$10$Z.zYJamwTPxdesDhWPyBiOK05PeX80RlKcqRZB2x1n3A3R9KnV8pu	9806754600	Member	Intermediate	Muscle Gain	1	2024-12-25 04:01:12.772	2024-12-25 04:01:12.772	kei xaina	4000.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1735099271/profile_images/zahmuu2bte1ihzrxhjk3.jpg	\N	\N	2001-06-07 00:00:00
8	khadka27	Abishek Khadka	pokhara	121.3	41.0	Male	abishekkhadka90@gmail.com	$2a$10$egaBG9IyXWAa2IRLH74QWO5eGa74HP./x7ztLd5DQJ/WkPGMKFhZS	9824474475	Member	Beginner	Muscle Gain	1	2024-12-25 04:07:57.13	2024-12-25 04:07:57.13	air	3000.00	https://res.cloudinary.com/dqcdosfch/image/upload/v1735099675/profile_images/kydgnbbue2k0ymzeannh.jpg	\N	\N	2002-08-31 00:00:00
\.


--
-- TOC entry 5130 (class 0 OID 124347)
-- Dependencies: 243
-- Data for Name: workoutexercises; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexercises (workout_exercise_id, workout_id, exercise_id, sets, reps, duration) FROM stdin;
1	1	1	3	10	20.00
2	1	3	3	12	30.00
3	2	1	3	12	200.00
\.


--
-- TOC entry 5134 (class 0 OID 124490)
-- Dependencies: 247
-- Data for Name: workoutexerciseslogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutexerciseslogs (log_id, workout_log_id, exercise_id, skipped, exercise_duration, rest_duration) FROM stdin;
1	1	1	f	0.07	0.00
2	1	3	f	0.05	0.00
3	2	1	f	0.08	0.00
4	2	3	f	0.02	0.00
5	3	1	f	0.12	0.00
6	3	3	f	0.12	0.00
7	4	1	f	0.00	0.00
\.


--
-- TOC entry 5136 (class 0 OID 124498)
-- Dependencies: 249
-- Data for Name: workoutlogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workoutlogs (log_id, user_id, workout_id, workout_date, calories_burned, performance_notes, total_duration) FROM stdin;
1	2	1	2024-12-22 10:36:37.356	0.00	great	0.12
2	2	1	2024-12-24 17:39:27.766	0.00	ghjgv	0.10
3	2	1	2024-12-25 08:15:18.279	0.00	feeling great with upendra	0.23
4	2	2	2024-12-25 08:28:58.971	0.00		0.00
\.


--
-- TOC entry 5132 (class 0 OID 124354)
-- Dependencies: 245
-- Data for Name: workouts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workouts (workout_id, user_id, workout_name, description, target_muscle_group, difficulty, trainer_id, created_at, updated_at, fitness_level, goal_type, workout_image) FROM stdin;
1	\N	Full Body Workout	Overall body training	Chest	Intermediate	2	2024-12-22 05:15:39.601	2024-12-22 05:15:39.603	Intermediate	Endurance	https://res.cloudinary.com/dqcdosfch/image/upload/v1734844539/workout_images/lbiw50shn4qmvp8o80qy.jpg
2	\N	Legs	Best for Legs	Legs	Easy	2	2024-12-25 05:28:56.42	2024-12-25 05:28:56.429	Beginner	Weight Loss	https://res.cloudinary.com/dqcdosfch/image/upload/v1735104534/workout_images/i8ujts3imficnb5ln7n5.jpg
\.


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 216
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 1, false);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 218
-- Name: chatconversations_chat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatconversations_chat_id_seq', 1, false);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 220
-- Name: chatmessages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatmessages_message_id_seq', 1, false);


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 222
-- Name: customworkoutexercises_custom_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkoutexercises_custom_workout_exercise_id_seq', 1, false);


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 224
-- Name: customworkouts_custom_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customworkouts_custom_workout_id_seq', 1, false);


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 226
-- Name: dietlogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dietlogs_log_id_seq', 1, false);


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 228
-- Name: dietplans_diet_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dietplans_diet_plan_id_seq', 1, false);


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 230
-- Name: exercises_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exercises_exercise_id_seq', 5, true);


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 232
-- Name: gym_gym_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gym_gym_id_seq', 1, false);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 234
-- Name: meals_meal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.meals_meal_id_seq', 1, false);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 250
-- Name: membership_plan_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.membership_plan_plan_id_seq', 1, false);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 236
-- Name: memberships_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memberships_membership_id_seq', 1, false);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 238
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 254
-- Name: personal_bests_personal_best_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_bests_personal_best_id_seq', 1, false);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 252
-- Name: subscription_changes_change_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscription_changes_change_id_seq', 1, false);


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 256
-- Name: supported_exercises_supported_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supported_exercises_supported_exercise_id_seq', 1, false);


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 240
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 8, true);


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 242
-- Name: workoutexercises_workout_exercise_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexercises_workout_exercise_id_seq', 3, true);


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 246
-- Name: workoutexerciseslogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutexerciseslogs_log_id_seq', 7, true);


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 248
-- Name: workoutlogs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workoutlogs_log_id_seq', 4, true);


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 244
-- Name: workouts_workout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workouts_workout_id_seq', 3, true);


--
-- TOC entry 4876 (class 2606 OID 124135)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4878 (class 2606 OID 124235)
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- TOC entry 4880 (class 2606 OID 124243)
-- Name: chatconversations chatconversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations
    ADD CONSTRAINT chatconversations_pkey PRIMARY KEY (chat_id);


--
-- TOC entry 4882 (class 2606 OID 124254)
-- Name: chatmessages chatmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessages
    ADD CONSTRAINT chatmessages_pkey PRIMARY KEY (message_id);


--
-- TOC entry 4884 (class 2606 OID 124261)
-- Name: customworkoutexercises customworkoutexercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises
    ADD CONSTRAINT customworkoutexercises_pkey PRIMARY KEY (custom_workout_exercise_id);


--
-- TOC entry 4887 (class 2606 OID 124269)
-- Name: customworkouts customworkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkouts
    ADD CONSTRAINT customworkouts_pkey PRIMARY KEY (custom_workout_id);


--
-- TOC entry 4889 (class 2606 OID 124279)
-- Name: dietlogs dietlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4891 (class 2606 OID 124290)
-- Name: dietplans dietplans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_pkey PRIMARY KEY (diet_plan_id);


--
-- TOC entry 4894 (class 2606 OID 124298)
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (exercise_id);


--
-- TOC entry 4898 (class 2606 OID 124307)
-- Name: gym gym_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gym
    ADD CONSTRAINT gym_pkey PRIMARY KEY (gym_id);


--
-- TOC entry 4901 (class 2606 OID 124317)
-- Name: meals meals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_pkey PRIMARY KEY (meal_id);


--
-- TOC entry 4922 (class 2606 OID 124535)
-- Name: membership_plan membership_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membership_plan
    ADD CONSTRAINT membership_plan_pkey PRIMARY KEY (plan_id);


--
-- TOC entry 4903 (class 2606 OID 124326)
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (membership_id);


--
-- TOC entry 4905 (class 2606 OID 124334)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 4926 (class 2606 OID 124574)
-- Name: personal_bests personal_bests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests
    ADD CONSTRAINT personal_bests_pkey PRIMARY KEY (personal_best_id);


--
-- TOC entry 4924 (class 2606 OID 124551)
-- Name: subscription_changes subscription_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_changes
    ADD CONSTRAINT subscription_changes_pkey PRIMARY KEY (change_id);


--
-- TOC entry 4929 (class 2606 OID 125479)
-- Name: supported_exercises supported_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supported_exercises
    ADD CONSTRAINT supported_exercises_pkey PRIMARY KEY (supported_exercise_id);


--
-- TOC entry 4910 (class 2606 OID 124345)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4913 (class 2606 OID 124352)
-- Name: workoutexercises workoutexercises_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises
    ADD CONSTRAINT workoutexercises_pkey PRIMARY KEY (workout_exercise_id);


--
-- TOC entry 4918 (class 2606 OID 124496)
-- Name: workoutexerciseslogs workoutexerciseslogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs
    ADD CONSTRAINT workoutexerciseslogs_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4920 (class 2606 OID 124506)
-- Name: workoutlogs workoutlogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs
    ADD CONSTRAINT workoutlogs_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4915 (class 2606 OID 124363)
-- Name: workouts workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (workout_id);


--
-- TOC entry 4885 (class 1259 OID 124364)
-- Name: customworkouts_custom_workout_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX customworkouts_custom_workout_name_key ON public.customworkouts USING btree (custom_workout_name);


--
-- TOC entry 4892 (class 1259 OID 124365)
-- Name: exercises_exercise_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX exercises_exercise_name_key ON public.exercises USING btree (exercise_name);


--
-- TOC entry 4895 (class 1259 OID 124367)
-- Name: gym_contact_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX gym_contact_number_key ON public.gym USING btree (contact_number);


--
-- TOC entry 4896 (class 1259 OID 124366)
-- Name: gym_gym_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX gym_gym_name_key ON public.gym USING btree (gym_name);


--
-- TOC entry 4899 (class 1259 OID 124368)
-- Name: meals_meal_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX meals_meal_name_key ON public.meals USING btree (meal_name);


--
-- TOC entry 4906 (class 1259 OID 124536)
-- Name: payments_transaction_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payments_transaction_id_key ON public.payments USING btree (transaction_id);


--
-- TOC entry 4927 (class 1259 OID 125480)
-- Name: supported_exercises_exercise_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX supported_exercises_exercise_name_key ON public.supported_exercises USING btree (exercise_name);


--
-- TOC entry 4907 (class 1259 OID 124371)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 4908 (class 1259 OID 124372)
-- Name: users_phone_number_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_phone_number_key ON public.users USING btree (phone_number);


--
-- TOC entry 4911 (class 1259 OID 124370)
-- Name: users_user_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_user_name_key ON public.users USING btree (user_name);


--
-- TOC entry 4916 (class 1259 OID 124373)
-- Name: workouts_workout_name_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX workouts_workout_name_key ON public.workouts USING btree (workout_name);


--
-- TOC entry 4930 (class 2606 OID 124374)
-- Name: attendance attendance_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4931 (class 2606 OID 124379)
-- Name: chatconversations chatconversations_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations
    ADD CONSTRAINT chatconversations_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4932 (class 2606 OID 124384)
-- Name: chatconversations chatconversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatconversations
    ADD CONSTRAINT chatconversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4933 (class 2606 OID 124389)
-- Name: chatmessages chatmessages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessages
    ADD CONSTRAINT chatmessages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chatconversations(chat_id) ON DELETE CASCADE;


--
-- TOC entry 4934 (class 2606 OID 124394)
-- Name: customworkoutexercises customworkoutexercises_custom_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises
    ADD CONSTRAINT customworkoutexercises_custom_workout_id_fkey FOREIGN KEY (custom_workout_id) REFERENCES public.customworkouts(custom_workout_id) ON DELETE CASCADE;


--
-- TOC entry 4935 (class 2606 OID 124399)
-- Name: customworkoutexercises customworkoutexercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkoutexercises
    ADD CONSTRAINT customworkoutexercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- TOC entry 4936 (class 2606 OID 124404)
-- Name: customworkouts customworkouts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customworkouts
    ADD CONSTRAINT customworkouts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4937 (class 2606 OID 124409)
-- Name: dietlogs dietlogs_diet_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_diet_plan_id_fkey FOREIGN KEY (diet_plan_id) REFERENCES public.dietplans(diet_plan_id);


--
-- TOC entry 4938 (class 2606 OID 124414)
-- Name: dietlogs dietlogs_meal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meals(meal_id);


--
-- TOC entry 4939 (class 2606 OID 124419)
-- Name: dietlogs dietlogs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietlogs
    ADD CONSTRAINT dietlogs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4940 (class 2606 OID 124424)
-- Name: dietplans dietplans_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 4941 (class 2606 OID 124429)
-- Name: dietplans dietplans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dietplans
    ADD CONSTRAINT dietplans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4942 (class 2606 OID 124434)
-- Name: gym gym_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gym
    ADD CONSTRAINT gym_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 4943 (class 2606 OID 124439)
-- Name: meals meals_diet_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meals
    ADD CONSTRAINT meals_diet_plan_id_fkey FOREIGN KEY (diet_plan_id) REFERENCES public.dietplans(diet_plan_id) ON DELETE CASCADE;


--
-- TOC entry 4944 (class 2606 OID 124537)
-- Name: memberships memberships_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.membership_plan(plan_id) ON DELETE CASCADE;


--
-- TOC entry 4945 (class 2606 OID 124444)
-- Name: memberships memberships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4946 (class 2606 OID 124449)
-- Name: payments payments_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.memberships(membership_id) ON DELETE CASCADE;


--
-- TOC entry 4947 (class 2606 OID 124454)
-- Name: payments payments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4957 (class 2606 OID 125481)
-- Name: personal_bests personal_bests_supported_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests
    ADD CONSTRAINT personal_bests_supported_exercise_id_fkey FOREIGN KEY (supported_exercise_id) REFERENCES public.supported_exercises(supported_exercise_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4958 (class 2606 OID 124575)
-- Name: personal_bests personal_bests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_bests
    ADD CONSTRAINT personal_bests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4956 (class 2606 OID 124552)
-- Name: subscription_changes subscription_changes_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_changes
    ADD CONSTRAINT subscription_changes_membership_id_fkey FOREIGN KEY (membership_id) REFERENCES public.memberships(membership_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4948 (class 2606 OID 124459)
-- Name: workoutexercises workoutexercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises
    ADD CONSTRAINT workoutexercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- TOC entry 4949 (class 2606 OID 124464)
-- Name: workoutexercises workoutexercises_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexercises
    ADD CONSTRAINT workoutexercises_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workouts(workout_id) ON DELETE CASCADE;


--
-- TOC entry 4952 (class 2606 OID 124507)
-- Name: workoutexerciseslogs workoutexerciseslogs_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs
    ADD CONSTRAINT workoutexerciseslogs_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(exercise_id) ON DELETE CASCADE;


--
-- TOC entry 4953 (class 2606 OID 124512)
-- Name: workoutexerciseslogs workoutexerciseslogs_workout_log_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutexerciseslogs
    ADD CONSTRAINT workoutexerciseslogs_workout_log_id_fkey FOREIGN KEY (workout_log_id) REFERENCES public.workoutlogs(log_id) ON DELETE CASCADE;


--
-- TOC entry 4954 (class 2606 OID 124517)
-- Name: workoutlogs workoutlogs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs
    ADD CONSTRAINT workoutlogs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4955 (class 2606 OID 124522)
-- Name: workoutlogs workoutlogs_workout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workoutlogs
    ADD CONSTRAINT workoutlogs_workout_id_fkey FOREIGN KEY (workout_id) REFERENCES public.workouts(workout_id);


--
-- TOC entry 4950 (class 2606 OID 124469)
-- Name: workouts workouts_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 4951 (class 2606 OID 124474)
-- Name: workouts workouts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2024-12-27 14:01:20

--
-- PostgreSQL database dump complete
--

