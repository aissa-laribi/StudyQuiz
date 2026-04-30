--
-- PostgreSQL database dump
--

\restrict gm3rkTgOlfyzvY0YBLG1pfFtvdVquNEmuRLPwtrRL0L05v72cS0y7zkEhljBrMc

-- Dumped from database version 18.3 (Ubuntu 18.3-1.pgdg22.04+1)
-- Dumped by pg_dump version 18.3 (Ubuntu 18.3-1.pgdg22.04+1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: answer; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.answer OWNER TO postgres;

--
-- Name: answer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.answer_id_seq OWNER TO postgres;

--
-- Name: answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answer_id_seq OWNED BY public.answer.id;


--
-- Name: attempt; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.attempt OWNER TO postgres;

--
-- Name: attempt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attempt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attempt_id_seq OWNER TO postgres;

--
-- Name: attempt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attempt_id_seq OWNED BY public.attempt.id;


--
-- Name: followup; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.followup OWNER TO postgres;

--
-- Name: followup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.followup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.followup_id_seq OWNER TO postgres;

--
-- Name: followup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.followup_id_seq OWNED BY public.followup.id;


--
-- Name: module; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.module (
    id integer NOT NULL,
    module_name character varying(245) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.module OWNER TO postgres;

--
-- Name: module_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.module_id_seq OWNER TO postgres;

--
-- Name: module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.module_id_seq OWNED BY public.module.id;


--
-- Name: question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question (
    id integer NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    quiz_id integer NOT NULL,
    question_name character varying(445) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.question OWNER TO postgres;

--
-- Name: question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.question_id_seq OWNER TO postgres;

--
-- Name: question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_id_seq OWNED BY public.question.id;


--
-- Name: quiz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz (
    id integer NOT NULL,
    quiz_name character varying(245) NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    repetitions integer NOT NULL,
    "interval" integer NOT NULL,
    ease_factor double precision NOT NULL,
    next_due timestamp without time zone,
    last_score integer NOT NULL
);


ALTER TABLE public.quiz OWNER TO postgres;

--
-- Name: quiz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quiz_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quiz_id_seq OWNER TO postgres;

--
-- Name: quiz_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quiz_id_seq OWNED BY public.quiz.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    user_name character varying(45) NOT NULL,
    email character varying(245) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(4) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: answer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer ALTER COLUMN id SET DEFAULT nextval('public.answer_id_seq'::regclass);


--
-- Name: attempt id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempt ALTER COLUMN id SET DEFAULT nextval('public.attempt_id_seq'::regclass);


--
-- Name: followup id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followup ALTER COLUMN id SET DEFAULT nextval('public.followup_id_seq'::regclass);


--
-- Name: module id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module ALTER COLUMN id SET DEFAULT nextval('public.module_id_seq'::regclass);


--
-- Name: question id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question ALTER COLUMN id SET DEFAULT nextval('public.question_id_seq'::regclass);


--
-- Name: quiz id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz ALTER COLUMN id SET DEFAULT nextval('public.quiz_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: answer answer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (id);


--
-- Name: attempt attempt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_pkey PRIMARY KEY (id);


--
-- Name: followup followup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_pkey PRIMARY KEY (id);


--
-- Name: module module_module_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_module_name_key UNIQUE (module_name);


--
-- Name: module module_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_pkey PRIMARY KEY (id);


--
-- Name: question question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);


--
-- Name: quiz quiz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_pkey PRIMARY KEY (id);


--
-- Name: quiz quiz_quiz_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_quiz_name_key UNIQUE (quiz_name);


--
-- Name: module unique_module_per_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT unique_module_per_user UNIQUE (user_id, module_name);


--
-- Name: quiz unique_quiz_name_per_module; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT unique_quiz_name_per_module UNIQUE (user_id, quiz_name);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_user_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_user_name_key UNIQUE (user_name);


--
-- Name: ix_answer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_answer_id ON public.answer USING btree (id);


--
-- Name: ix_answer_module_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_answer_module_id ON public.answer USING btree (module_id);


--
-- Name: ix_answer_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_answer_question_id ON public.answer USING btree (question_id);


--
-- Name: ix_answer_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_answer_quiz_id ON public.answer USING btree (quiz_id);


--
-- Name: ix_answer_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_answer_user_id ON public.answer USING btree (user_id);


--
-- Name: ix_attempt_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_attempt_id ON public.attempt USING btree (id);


--
-- Name: ix_attempt_module_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_attempt_module_id ON public.attempt USING btree (module_id);


--
-- Name: ix_attempt_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_attempt_user_id ON public.attempt USING btree (user_id);


--
-- Name: ix_followup_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_followup_id ON public.followup USING btree (id);


--
-- Name: ix_followup_module_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_followup_module_id ON public.followup USING btree (module_id);


--
-- Name: ix_followup_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_followup_quiz_id ON public.followup USING btree (quiz_id);


--
-- Name: ix_followup_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_followup_user_id ON public.followup USING btree (user_id);


--
-- Name: ix_module_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_module_id ON public.module USING btree (id);


--
-- Name: ix_module_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_module_user_id ON public.module USING btree (user_id);


--
-- Name: ix_question_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_question_id ON public.question USING btree (id);


--
-- Name: ix_question_module_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_question_module_id ON public.question USING btree (module_id);


--
-- Name: ix_question_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_question_quiz_id ON public.question USING btree (quiz_id);


--
-- Name: ix_question_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_question_user_id ON public.question USING btree (user_id);


--
-- Name: ix_quiz_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_quiz_id ON public.quiz USING btree (id);


--
-- Name: ix_quiz_module_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_quiz_module_id ON public.quiz USING btree (module_id);


--
-- Name: ix_quiz_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_quiz_user_id ON public.quiz USING btree (user_id);


--
-- Name: ix_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_user_id ON public."user" USING btree (id);


--
-- Name: answer answer_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: answer answer_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.question(id);


--
-- Name: answer answer_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: answer answer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: attempt attempt_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: attempt attempt_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: attempt attempt_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attempt
    ADD CONSTRAINT attempt_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: followup followup_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: followup followup_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: followup followup_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.followup
    ADD CONSTRAINT followup_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: module module_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.module
    ADD CONSTRAINT module_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: question question_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: question question_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quiz(id) ON DELETE CASCADE;


--
-- Name: question question_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: quiz quiz_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id) ON DELETE CASCADE;


--
-- Name: quiz quiz_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict gm3rkTgOlfyzvY0YBLG1pfFtvdVquNEmuRLPwtrRL0L05v72cS0y7zkEhljBrMc

