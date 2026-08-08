--
-- PostgreSQL database dump
--

\restrict VCodlSkN2ZEj1GQE4pfk6oJwe4Tz334HXqkHhxUof8uKdSJSctXS516YjVsjgh4

-- Dumped from database version 18.4 (Ubuntu 18.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 18.4 (Ubuntu 18.4-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ai_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_usage (
    id integer NOT NULL,
    user_id integer NOT NULL,
    usage_date date DEFAULT CURRENT_DATE NOT NULL,
    consumption integer DEFAULT 0 NOT NULL,
    CONSTRAINT ck_ai_usage_consumption_non_negative CHECK ((consumption >= 0))
);


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: answer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answer (
    id integer NOT NULL,
    answer_name character varying(445) NOT NULL,
    answer_correct boolean NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    quiz_id integer NOT NULL,
    question_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: answer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.answer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.answer_id_seq OWNED BY public.answer.id;


--
-- Name: attempt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attempt (
    id integer NOT NULL,
    attempt_score integer NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    quiz_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: attempt_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attempt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attempt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attempt_id_seq OWNED BY public.attempt.id;


--
-- Name: followup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.followup (
    id integer NOT NULL,
    followup_due_date timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    quiz_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: followup_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.followup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.followup_id_seq OWNED BY public.followup.id;


--
-- Name: module; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module (
    id integer NOT NULL,
    module_name character varying(245) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: module_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_id_seq OWNED BY public.module.id;


--
-- Name: plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plan (
    id integer NOT NULL,
    plan_code character varying(30) NOT NULL,
    display_name character varying(40) NOT NULL,
    ai_monthly_allowance integer DEFAULT 0 NOT NULL,
    ai_daily_allowance integer DEFAULT 0 NOT NULL,
    price_monthly_pence integer DEFAULT 0 NOT NULL,
    CONSTRAINT ck_plan_ai_daily_allowance_non_negative CHECK ((ai_daily_allowance >= 0)),
    CONSTRAINT ck_plan_ai_monthly_allowance_non_negative CHECK ((ai_monthly_allowance >= 0)),
    CONSTRAINT ck_plan_price_non_negative CHECK ((price_monthly_pence >= 0))
);


--
-- Name: question; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.question (
    id integer NOT NULL,
    question_name character varying(445) NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    quiz_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: question_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.question_id_seq OWNED BY public.question.id;


--
-- Name: quiz; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quiz (
    id integer NOT NULL,
    quiz_name character varying(245) NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    repetitions integer DEFAULT 0,
    "interval" integer DEFAULT 0,
    ease_factor double precision DEFAULT 2.5,
    next_due timestamp without time zone,
    last_score integer DEFAULT 0
);


--
-- Name: quiz_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quiz_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quiz_id_seq OWNED BY public.quiz.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    user_name character varying(45),
    email character varying(245) NOT NULL,
    password character varying(245) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role character varying(4) DEFAULT 'user'::character varying NOT NULL,
    verified boolean,
    organization character varying(20),
    city character varying(20),
    plan_id integer NOT NULL
);


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: verification_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verification_token (
    id integer NOT NULL,
    user_id integer NOT NULL,
    token_hash character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL
);


--
-- Name: verification_token_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.verification_token ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.verification_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: waiting_list; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.waiting_list (
    id integer NOT NULL,
    email character varying(245) NOT NULL,
    plan_id integer NOT NULL,
    subject character varying(245),
    usage character varying(1000),
    created_at timestamp without time zone,
    invited_at timestamp without time zone,
    registered_at timestamp without time zone
);


--
-- Name: waiting_list_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.waiting_list ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.waiting_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: answer id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer ALTER COLUMN id SET DEFAULT nextval('public.answer_id_seq'::regclass);


--
-- Name: attempt id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt ALTER COLUMN id SET DEFAULT nextval('public.attempt_id_seq'::regclass);


--
-- Name: followup id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followup ALTER COLUMN id SET DEFAULT nextval('public.followup_id_seq'::regclass);


--
-- Name: module id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module ALTER COLUMN id SET DEFAULT nextval('public.module_id_seq'::regclass);


--
-- Name: question id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question ALTER COLUMN id SET DEFAULT nextval('public.question_id_seq'::regclass);


--
-- Name: quiz id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz ALTER COLUMN id SET DEFAULT nextval('public.quiz_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: ai_usage ai_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage
    ADD CONSTRAINT ai_usage_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: answer answer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (id);


--
-- Name: attempt attempt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_pkey PRIMARY KEY (id);


--
-- Name: followup followup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_pkey PRIMARY KEY (id);


--
-- Name: module module_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_pkey PRIMARY KEY (id);


--
-- Name: plan plan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan
    ADD CONSTRAINT plan_pkey PRIMARY KEY (id);


--
-- Name: plan plan_plan_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan
    ADD CONSTRAINT plan_plan_code_key UNIQUE (plan_code);


--
-- Name: question question_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);


--
-- Name: quiz quiz_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_pkey PRIMARY KEY (id);


--
-- Name: module unique_module_per_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT unique_module_per_user UNIQUE (user_id, module_name);


--
-- Name: quiz unique_quiz_name_per_module; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT unique_quiz_name_per_module UNIQUE (user_id, quiz_name);


--
-- Name: ai_usage uq_ai_usage_user_date; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage
    ADD CONSTRAINT uq_ai_usage_user_date UNIQUE (user_id, usage_date);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_user_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_user_name_key UNIQUE (user_name);


--
-- Name: verification_token verification_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_token
    ADD CONSTRAINT verification_token_pkey PRIMARY KEY (id);


--
-- Name: verification_token verification_token_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_token
    ADD CONSTRAINT verification_token_token_hash_key UNIQUE (token_hash);


--
-- Name: waiting_list waiting_list_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT waiting_list_email_key UNIQUE (email);


--
-- Name: waiting_list waiting_list_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waiting_list
    ADD CONSTRAINT waiting_list_pkey PRIMARY KEY (id);


--
-- Name: ix_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_answer_id ON public.answer USING btree (id);


--
-- Name: ix_answer_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_answer_module_id ON public.answer USING btree (module_id);


--
-- Name: ix_answer_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_answer_question_id ON public.answer USING btree (question_id);


--
-- Name: ix_answer_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_answer_quiz_id ON public.answer USING btree (quiz_id);


--
-- Name: ix_answer_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_answer_user_id ON public.answer USING btree (user_id);


--
-- Name: ix_attempt_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_attempt_id ON public.attempt USING btree (id);


--
-- Name: ix_attempt_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_attempt_module_id ON public.attempt USING btree (module_id);


--
-- Name: ix_attempt_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_attempt_user_id ON public.attempt USING btree (user_id);


--
-- Name: ix_followup_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_followup_id ON public.followup USING btree (id);


--
-- Name: ix_followup_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_followup_module_id ON public.followup USING btree (module_id);


--
-- Name: ix_followup_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_followup_quiz_id ON public.followup USING btree (quiz_id);


--
-- Name: ix_followup_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_followup_user_id ON public.followup USING btree (user_id);


--
-- Name: ix_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_module_id ON public.module USING btree (id);


--
-- Name: ix_module_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_module_user_id ON public.module USING btree (user_id);


--
-- Name: ix_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_question_id ON public.question USING btree (id);


--
-- Name: ix_question_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_question_module_id ON public.question USING btree (module_id);


--
-- Name: ix_question_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_question_quiz_id ON public.question USING btree (quiz_id);


--
-- Name: ix_question_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_question_user_id ON public.question USING btree (user_id);


--
-- Name: ix_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_quiz_id ON public.quiz USING btree (id);


--
-- Name: ix_quiz_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_quiz_module_id ON public.quiz USING btree (module_id);


--
-- Name: ix_quiz_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_quiz_user_id ON public.quiz USING btree (user_id);


--
-- Name: ix_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_id ON public."user" USING btree (id);


--
-- Name: answer answer_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id) ON DELETE CASCADE;


--
-- Name: answer answer_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.question(id);


--
-- Name: answer answer_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: answer answer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: attempt attempt_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: attempt attempt_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: attempt attempt_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: ai_usage fk_ai_usage_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_usage
    ADD CONSTRAINT fk_ai_usage_user FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user fk_user_plan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT fk_user_plan FOREIGN KEY (plan_id) REFERENCES public.plan(id) ON DELETE RESTRICT;


--
-- Name: verification_token fk_verification_token_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_token
    ADD CONSTRAINT fk_verification_token_user FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: followup followup_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: followup followup_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: followup followup_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: module module_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: question question_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id) ON DELETE CASCADE;


--
-- Name: question question_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: question question_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: quiz quiz_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: quiz quiz_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict VCodlSkN2ZEj1GQE4pfk6oJwe4Tz334HXqkHhxUof8uKdSJSctXS516YjVsjgh4

