--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)

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
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


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


ALTER TABLE public.answer_id_seq OWNER TO postgres;

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


ALTER TABLE public.attempt_id_seq OWNER TO postgres;

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


ALTER TABLE public.followup_id_seq OWNER TO postgres;

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


ALTER TABLE public.module_id_seq OWNER TO postgres;

--
-- Name: module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.module_id_seq OWNED BY public.module.id;


--
-- Name: question; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.question_id_seq OWNER TO postgres;

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
    repetitions integer DEFAULT 0,
    "interval" integer DEFAULT 0,
    ease_factor double precision DEFAULT 2.5,
    next_due timestamp without time zone,
    last_score integer DEFAULT 0
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


ALTER TABLE public.quiz_id_seq OWNER TO postgres;

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
    password character varying(245) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role character varying(4) DEFAULT 'user'::character varying NOT NULL
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


ALTER TABLE public.user_id_seq OWNER TO postgres;

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
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
a402a2b24cc3
\.


--
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.answer (id, answer_name, answer_correct, user_id, module_id, quiz_id, question_id, created_at, updated_at) FROM stdin;
1	Load from memory	f	41	6	4	7	2025-05-23 09:59:14.763204	\N
3	Increment register	f	41	6	4	7	2025-05-23 10:00:10.296324	\N
4	Load instruction	f	41	6	4	7	2025-05-23 10:00:38.203405	\N
72	Modulation is the process of increasing the strength of a signal so it can travel longer distances.	f	41	8	6	22	2025-05-26 22:03:34.272518	\N
2	Load a constant into a register	t	41	6	4	7	2025-05-23 09:59:43.86056	2025-05-23 10:06:49.131958
5	x1	f	41	6	4	8	2025-05-23 16:11:54.48735	\N
6	a0	f	41	6	4	8	2025-05-23 16:12:03.504982	\N
7	x0	t	41	6	4	8	2025-05-23 16:12:16.044966	\N
8	s0	f	41	6	4	8	2025-05-23 16:12:28.741725	\N
9	Calls a subroutine	f	41	6	4	9	2025-05-23 16:19:46.928617	\N
10	Allocates memory	f	41	6	4	9	2025-05-23 16:20:04.041102	\N
11	Requests a service from the OS	t	41	6	4	9	2025-05-23 16:20:32.745277	\N
12	Returns from a function	f	41	6	4	9	2025-05-23 16:22:01.653355	\N
13	10	f	41	6	4	10	2025-05-23 16:23:31.202357	\N
14	15	f	41	6	4	10	2025-05-23 16:23:36.269127	\N
15	20	t	41	6	4	10	2025-05-23 16:23:51.88385	\N
16	5	f	41	6	4	10	2025-05-23 16:24:05.235418	\N
17	Move a value from memory to register	f	41	6	4	11	2025-05-23 16:25:39.001416	\N
18	Copy a register’s value to another register	t	41	6	4	11	2025-05-23 16:26:02.099715	\N
19	Move data to the screen	f	41	6	4	11	2025-05-23 16:26:40.814066	\N
20	Move program counter	f	41	6	4	11	2025-05-23 16:26:59.127871	\N
21	a0	t	41	6	4	12	2025-05-23 16:28:59.547474	\N
22	sp	f	41	6	4	12	2025-05-23 16:29:11.797385	\N
23	s0	f	41	6	4	12	2025-05-23 16:29:16.695893	\N
24	x0	f	41	6	4	12	2025-05-23 16:29:20.754397	\N
25	Branch if t0 == t1	f	41	6	4	13	2025-05-23 16:31:03.543349	\N
26	Branch if t0 > t1	f	41	6	4	13	2025-05-23 16:33:40.060887	\N
27	Branch if t0 < t1	t	41	6	4	13	2025-05-23 16:35:21.213465	\N
28	Unconditional jump	f	41	6	4	13	2025-05-23 16:35:45.942945	\N
29	div s0, s1, s2	f	41	6	4	14	2025-05-23 16:39:53.60521	\N
30	add s0, s1, s2	f	41	6	4	14	2025-05-23 16:40:06.993185	\N
31	mul s0, s1, s2	t	41	6	4	14	2025-05-23 16:40:49.587407	\N
32	xor s0, s1, s2	f	41	6	4	14	2025-05-23 16:41:06.726477	\N
33	Exit	f	41	6	4	15	2025-05-23 16:42:49.224655	\N
34	Print float	t	41	6	4	15	2025-05-23 16:43:17.73251	\N
35	Print integer	f	41	6	4	15	2025-05-23 16:43:33.071699	\N
36	Read string	f	41	6	4	15	2025-05-23 16:43:45.564688	\N
42	Stores binary form of Hello	f	41	2	4	16	2025-05-23 17:14:58.55407	\N
43	Stores null-terminated string	t	41	2	4	16	2025-05-23 17:15:52.389247	\N
44	Stores integer	f	41	2	4	16	2025-05-23 17:16:10.663125	\N
45	Creates a label	f	41	2	4	16	2025-05-23 17:16:24.592519	\N
46	Stores binary form of Hello	f	41	6	4	16	2025-05-25 16:57:41.302913	\N
47	Stores null-terminated string	t	41	6	4	16	2025-05-25 16:58:24.981229	\N
48	Stores integer	f	41	6	4	16	2025-05-25 16:58:57.117152	\N
49	Creates a label	f	41	6	4	16	2025-05-25 16:59:12.489305	\N
51	Solid Random Access Memory	f	41	8	6	17	2025-05-26 16:24:33.61443	\N
52	Static Random Access Memory	t	41	8	6	17	2025-05-26 16:25:18.707028	\N
53	Supervisor Random Access Memory	f	41	8	6	17	2025-05-26 16:25:50.724636	\N
54	Spaced Random Access Memory	f	41	8	6	17	2025-05-26 16:26:17.91563	\N
55	SRAM is a type of volatile memory for fast and temporary storage. Mainly used for CPU register files, Cache memory and Scratchpad memory	t	41	8	6	18	2025-05-26 16:47:26.056883	\N
56	Volatile main memory in most computers.Needs constant refreshing. Used for main RAM in laptops/desktops	f	41	8	6	18	2025-05-26 16:51:14.291204	\N
57	Non-volatile memory used for small persistent settings	f	41	8	6	18	2025-05-26 16:53:54.50225	\N
58	non-volatile memory used to store program code and data even after power loss	f	41	8	6	18	2025-05-26 16:54:25.922901	\N
59	Real-Time Counter	f	41	8	6	19	2025-05-26 17:05:50.721214	\N
60	Real-Time CPU	f	41	8	6	19	2025-05-26 17:06:05.023291	\N
61	Real-Time Call	f	41	8	6	19	2025-05-26 17:06:30.444403	\N
62	Real-Time Clock	t	41	8	6	19	2025-05-26 17:06:42.818522	\N
64	The RTC is a software-based timer that uses the system clock to track time while the CPU is active.	f	41	8	6	20	2025-05-26 17:16:15.398479	\N
65	The RTC requires the main CPU to remain in an active low-power mode to keep counting time.	f	41	8	6	20	2025-05-26 17:16:53.59272	\N
66	The RTC keeps time while the CPU is off, but only if the microcontroller remains connected to an external debugger or programmer.	f	41	8	6	20	2025-05-26 17:17:11.13761	\N
67	Data is transmitted by modulating electrical signals over copper wires between wireless devices.	f	41	8	6	21	2025-05-26 21:20:27.971678	\N
68	Data is transmitted through infrared light reflected off surfaces, which enables long-distance communication.	f	41	8	6	21	2025-05-26 21:21:02.173815	\N
69	Data is transmitted by modulating electromagnetic (radio) waves that travel through air	t	41	8	6	21	2025-05-26 21:21:42.538099	\N
70	Data is transmitted by modulating electromagnetic waves, but only in the microwave frequency range above 10 GHz.	f	41	8	6	21	2025-05-26 21:22:36.816617	\N
71	Modulation is the conversion of digital signals into analog signals using error correction.	f	41	8	6	22	2025-05-26 22:03:12.879959	\N
73	Modulation is the process of changing a wave’s amplitude, frequency, or phase to encode digital data.	t	41	8	6	22	2025-05-26 22:04:07.801407	\N
74	Modulation is the process of altering a signal’s amplitude, frequency, or phase to improve sound quality in audio systems.	f	41	8	6	22	2025-05-26 22:04:33.050239	\N
75	To shift the signal to a frequency where it can be transmitted wirelessly through the air and received efficiently over distance.	t	41	8	6	23	2025-05-26 23:27:24.697628	\N
76	To increase the power of the signal so that it can overcome obstacles like buildings and trees.	f	41	8	6	23	2025-05-26 23:28:13.345029	\N
77	To directly transmit digital bits (1s and 0s) without any need for modulation.	f	41	8	6	23	2025-05-26 23:28:32.123366	\N
78	To shift the signal to a lower frequency range to reduce interference with other wireless devices.	f	41	8	6	23	2025-05-26 23:28:57.499979	\N
84	Waving your hand faster or slower (same height, different tempo)	f	41	8	6	24	2025-05-26 23:57:56.729795	\N
85	Waving your hand high or low (same tempo, different height)	t	41	8	6	24	2025-05-26 23:59:57.917861	\N
86	Turning a light on and off at random intervals to send a message	f	41	8	6	24	2025-05-27 00:01:20.522773	\N
87	Switching your hand from left to right while keeping the same speed and height	f	41	8	6	24	2025-05-27 00:01:35.656316	\N
88	Waving higher or lower (same tempo, different height)	f	41	8	6	25	2025-05-27 00:06:02.116149	\N
89	Changing the direction of your wave mid-motion (e.g., flipping it 180°)	f	41	8	6	25	2025-05-27 00:06:20.241185	\N
90	Waving faster or slower (different tempos)	t	41	8	6	25	2025-05-27 00:06:45.974741	\N
91	Pausing the wave entirely at intervals to signal data	f	41	8	6	25	2025-05-27 00:07:12.021919	\N
92	same tempo and height, but flipping direction suddenly (phase)	t	41	8	6	26	2025-05-27 00:10:09.175201	\N
93	Waving faster or slower while keeping the same direction and height	f	41	8	6	26	2025-05-27 00:10:35.567144	\N
94	Waving higher or lower with the same tempo	f	41	8	6	26	2025-05-27 00:10:57.889113	\N
95	Waving with varying brightness to represent data	f	41	8	6	26	2025-05-27 00:11:12.763232	\N
96	Waving faster or slower without changing direction or height	f	41	8	6	27	2025-05-27 00:36:02.559604	\N
97	Waving at the same height while changing direction only	f	41	8	6	27	2025-05-27 00:36:26.104381	\N
98	Turning the wave on and off with long pauses in between	f	41	8	6	27	2025-05-27 00:36:52.723119	\N
99	Waving your hand at different heights and flipping direction at the same time (amplitude + phase)	t	41	8	6	27	2025-05-27 00:37:31.069651	\N
100	It uses a single high-speed carrier to send all data faster.	f	41	8	6	28	2025-05-27 10:55:40.438417	\N
101	It uses multiple subcarriers and adds all of them to the final message.	t	41	8	6	28	2025-05-27 10:56:41.739423	\N
102	It sends different messages on the same carrier by shifting the phase rapidly.	f	41	8	6	28	2025-05-27 10:57:09.483822	\N
103	It compresses all digital data into a single waveform using Fourier Transform and sends it over a wire.	f	41	8	6	28	2025-05-27 10:57:38.533957	\N
104	The data passed by a layer to the layer above after processing.	f	41	8	6	29	2025-05-27 12:04:15.817641	\N
105	The fully formatted data with all headers and trailers, ready for transmission.	f	41	8	6	29	2025-05-27 12:04:35.96003	\N
106	The signal converted from analog to digital before entering the application layer.	f	41	8	6	29	2025-05-27 12:06:43.270393	\N
107	The data received by a layer from the layer above.	t	41	8	6	29	2025-05-27 12:07:45.432163	\N
108	The data sent by a layer to the layer below after adding headers/trailers (encapsulation).	t	41	8	6	30	2025-05-27 12:20:49.820331	\N
109	The data received from the physical layer before stripping the headers.	f	41	8	6	30	2025-05-27 12:21:27.615858	\N
110	The data passed from one layer to another without modification.	f	41	8	6	30	2025-05-27 12:21:41.018031	\N
111	The service used to authenticate data between layers.	f	41	8	6	30	2025-05-27 12:21:53.02542	\N
120	Combines multiple MAC frames into one physical-layer transmission without altering frame structure	f	41	8	6	31	2025-05-27 12:45:10.769242	\N
121	Encrypts several IP packets together before handing them to the MAC layer	f	41	8	6	31	2025-05-27 12:45:27.701053	\N
122	Fragments large IP packets into smaller MAC frames to improve reliability	f	41	8	6	31	2025-05-27 12:45:41.831806	\N
123	Combines multiple Layer 3+ packets (like IP packets) into one larger MAC frame	t	41	8	6	31	2025-05-27 12:46:21.414965	\N
124	Combines multiple MAC frames into a single physical-layer transmission	t	41	8	6	32	2025-05-27 12:48:47.739639	\N
125	Combines multiple IP packets into a larger MAC frame before encryption	f	41	8	6	32	2025-05-27 12:49:32.836135	\N
126	Combines several physical-layer signals into one wideband signal	f	41	8	6	32	2025-05-27 12:49:43.882663	\N
127	Fragments a large MAC frame into smaller subframes for retransmission	f	41	8	6	32	2025-05-27 12:49:58.755029	\N
128	A guard interval is a frequency buffer between two channels to prevent crosstalk.	f	41	8	6	33	2025-05-27 12:50:38.67199	\N
129	A guard interval is a short time gap inserted between transmitted symbols to prevent interference caused by signal reflections (a.k.a. multipath interference)	t	41	8	6	33	2025-05-27 12:51:10.126829	\N
130	A guard interval is a time slot reserved for error correction during retransmission.	f	41	8	6	33	2025-05-27 12:51:49.332916	\N
131	A guard interval is the fixed time between data encryption and decryption in secure communication.	f	41	8	6	33	2025-05-27 12:52:07.725152	\N
132	The full frequency range available for wireless communication	t	41	8	6	34	2025-05-27 14:26:36.342948	\N
133	A device that analyzes signal strength and interference in a wireless channel	f	41	8	6	34	2025-05-27 14:27:03.618177	\N
134	A bandwidth limiter that restricts the rate of data transmission in wireless systems	f	41	8	6	34	2025-05-27 14:27:17.087346	\N
135	A predefined set of MAC addresses used to manage wireless access control	f	41	8	6	34	2025-05-27 14:27:31.01432	\N
136	0 MHz to 2400 MHz	f	41	8	6	35	2025-05-27 14:43:57.265655	\N
137	2400 MHz to 2500 MHz	f	41	8	6	35	2025-05-27 14:44:12.476937	\N
138	2400 MHz to 2483.5 MHz	t	41	8	6	35	2025-05-27 14:44:39.178226	\N
139	2450 MHz to 2650 MHz	f	41	8	6	35	2025-05-27 14:44:57.808046	\N
140	To separate Wi-Fi from Bluetooth signals operating in the same frequency range.	f	41	8	6	36	2025-05-27 14:51:10.429291	\N
141	To define the midpoint of the channel’s frequency range so devices can tune in accurately despite overlapping channels.	t	41	8	6	36	2025-05-27 14:51:29.97263	\N
142	To control the speed of data transmission by increasing frequency dynamically.	f	41	8	6	36	2025-05-27 14:52:18.845825	\N
143	To guarantee non-overlapping channels even when spaced 5 MHz apart.	f	41	8	6	36	2025-05-27 14:52:36.711742	\N
144	Because these are the only channels that support high-speed Wi-Fi standards like 802.11ac.	f	41	8	6	37	2025-05-27 14:54:12.568391	\N
145	Because they are automatically assigned by the operating system and cannot be changed.	f	41	8	6	37	2025-05-27 14:54:26.085168	\N
146	Because they are the only three non-overlapping 20 MHz channels, reducing interference between adjacent networks.	t	41	8	6	37	2025-05-27 14:54:46.924781	\N
147	Because only these channels support both 2.4 GHz and 5 GHz bands simultaneously.	f	41	8	6	37	2025-05-27 14:55:09.762577	\N
148	Bluetooth is a short-range wireless communication technology for exchanging data over the 2.4 GHz spectrum.	t	41	8	6	38	2025-05-27 16:19:55.212571	\N
149	 Bluetooth is a long-range wireless protocol that uses multiple frequency bands to stream video content.	f	41	8	6	38	2025-05-27 16:21:54.959853	\N
150	Bluetooth is a wired protocol for connecting audio devices and transferring large files.	f	41	8	6	38	2025-05-27 16:22:12.244165	\N
151	Bluetooth is a short-range wireless protocol that uses the 5 GHz band to avoid interference.	f	41	8	6	38	2025-05-27 16:22:24.768318	\N
152	To maximize battery life and support devices that only occasionally send small packets of data.	f	41	8	6	39	2025-05-27 16:31:55.922075	\N
153	For large data transfer, when power consumption is not critical, the device must stay always connected, and the largest possible physical range is needed.	t	41	8	6	39	2025-05-27 16:33:01.391119	\N
154	To communicate over Wi-Fi instead of using proprietary radio protocols.	f	41	8	6	39	2025-05-27 16:33:31.618042	\N
155	To take advantage of mesh networking and ultra-low latency audio transmission in modern wearables.	f	41	8	6	39	2025-05-27 16:33:47.44395	\N
156	High-quality, real-time audio streaming between headphones and smartphones.	f	41	8	6	40	2025-05-27 16:47:32.105445	\N
157	Wireless HDMI transmission for streaming full HD video.	f	41	8	6	40	2025-05-27 16:47:49.450521	\N
158	Connecting servers in a data center for backup communication.	f	41	8	6	40	2025-05-27 16:48:08.737491	\N
159	Battery-powered devices like fitness trackers, beacons, and sensors that transmit small amounts of data intermittently.	t	41	8	6	40	2025-05-27 16:48:40.893787	\N
172	It segments and reassembles data, multiplexes logical channels, and provides transport services to higher layers.	f	41	8	6	43	2025-05-27 19:28:12.176793	\N
173	It modulates and transmits raw bits over the 2.4 GHz spectrum.	f	41	8	6	43	2025-05-27 19:31:37.918675	\N
174	It handles encryption and authentication between paired devices.	f	41	8	6	43	2025-05-27 19:32:00.25264	\N
175	It converts analog audio signals into digital packets for wireless transmission.	f	41	8	6	43	2025-05-27 19:32:19.617224	\N
176	To provide high-throughput bulk file transfers with error correction.	f	41	8	6	44	2025-05-27 21:58:45.384166	\N
177	To support time-sensitive data like voice by reserving fixed time slots and ensuring low-latency delivery.	t	41	8	6	44	2025-05-27 22:00:23.982932	\N
178	To stream encrypted video data over BLE with guaranteed delivery.	f	41	8	6	44	2025-05-27 22:00:54.605872	\N
179	To reduce Bluetooth signal interference by dynamically hopping between Wi-Fi channels.	f	41	8	6	44	2025-05-27 22:01:12.791469	\N
180	Bluetooth Classic has a separate Baseband layer, while in BLE, its functions are integrated into the Link Layer.	t	41	8	6	41	2025-05-27 22:06:30.440991	\N
181	BLE has a more complex Baseband layer than Classic Bluetooth to support mesh networking.	f	41	8	6	41	2025-05-27 22:07:08.621874	\N
182	In BLE, the Baseband layer handles audio streaming and file transfer protocols.	f	41	8	6	41	2025-05-27 22:07:26.575568	\N
183	In Classic Bluetooth, the Baseband layer is replaced entirely by the Logical Link Control and Adaptation Protocol (L2CAP).	f	41	8	6	41	2025-05-27 22:07:41.344218	\N
184	The Link Layer in BLE handles audio compression and multiplexing for synchronous streaming.	f	41	8	6	45	2025-05-27 22:18:24.028582	\N
185	BLE does not use a Link Layer; all connections are handled by the application.	f	41	8	6	45	2025-05-27 22:18:36.635849	\N
186	In BLE, the Link Layer manages advertising, connections, and packet control consolidating roles that are handled by the Baseband and Link Manager in Classic Bluetooth.	t	41	8	6	45	2025-05-27 22:19:22.354247	\N
187	The Link Layer in Classic Bluetooth provides better power efficiency than in BLE.	f	41	8	6	45	2025-05-27 22:19:44.636611	\N
188	To define how devices advertise, discover each other, and establish connections through roles like central and peripheral.	t	41	8	6	46	2025-05-27 22:21:53.27358	\N
189	To encrypt all communication between BLE devices and manage authentication.	f	41	8	6	46	2025-05-27 22:22:23.621506	\N
190	To transmit high-bandwidth data between BLE audio devices.	f	41	8	6	46	2025-05-27 22:22:28.795009	\N
191	To route packets between multiple BLE devices in a mesh topology.	f	41	8	6	46	2025-05-27 22:23:19.76361	\N
192	In Classic Bluetooth, the Baseband layer is replaced entirely by the Logical Link Control and Adaptation Protocol (L2CAP).	f	41	8	6	47	2025-05-27 22:25:16.900503	\N
193	To advertise the presence of BLE devices and manage their roles as central or peripheral.	f	41	8	6	47	2025-05-27 22:25:47.244603	\N
164	It defines how services like audio and file transfer are exposed to the application.	f	41	8	6	42	2025-05-27 19:11:48.613705	2025-05-30 12:27:14.096373
165	It modulates the analog radio signals used for transmission.	f	41	8	6	42	2025-05-27 19:12:03.75752	2025-05-30 12:28:09.425361
166	It performs encryption and pairing between devices.	f	41	8	6	42	2025-05-27 19:12:35.708689	2025-05-30 12:34:15.840436
167	It manages physical links, handles low-level packet formatting, error correction, and device synchronization.	t	41	8	6	42	2025-05-27 19:13:10.60785	2025-05-30 12:34:44.906638
194	To manage encryption keys and perform pairing and bonding between devices.	f	41	8	6	47	2025-05-27 22:26:01.477159	\N
195	To route data across a mesh of BLE devices using multi-hop communication.	f	41	8	6	47	2025-05-27 22:26:14.291244	\N
196	To define a client-server protocol for reading, writing, and exchanging data organized as attributes with handles and permissions.	t	41	8	6	47	2025-05-27 22:26:52.403033	\N
197	To define how services, characteristics, and descriptors are structured and accessed using the Attribute Protocol.	t	41	8	6	48	2025-05-27 22:37:26.937325	\N
198	To provide low-level packet delivery and address handling between BLE layers.	f	41	8	6	48	2025-05-27 22:38:26.777436	\N
199	To control connection timing and frequency hopping between devices.	f	41	8	6	48	2025-05-27 22:38:39.859288	\N
200	To negotiate encryption and bonding between devices securely.	f	41	8	6	48	2025-05-27 22:38:56.732105	\N
201	False	t	41	8	6	49	2025-05-27 22:46:19.636202	\N
202	True	f	41	8	6	54	2025-05-27 22:56:11.344732	\N
203	True	f	41	8	6	49	2025-05-27 22:58:55.178375	\N
204	False	t	41	8	6	54	2025-05-27 23:00:34.197167	\N
205	True	t	41	8	6	50	2025-05-27 23:01:06.995648	\N
206	False	f	41	8	6	50	2025-05-27 23:01:21.515562	\N
207	True	t	41	8	6	51	2025-05-27 23:02:02.175366	\N
208	False	f	41	8	6	51	2025-05-27 23:02:13.898567	\N
209	True	f	41	8	6	52	2025-05-27 23:02:45.342936	\N
210	False	t	41	8	6	52	2025-05-27 23:03:01.001345	\N
211	True	t	41	8	6	53	2025-05-27 23:03:28.739457	\N
212	False	f	41	8	6	53	2025-05-27 23:03:47.470555	\N
213	True	f	41	8	6	55	2025-05-27 23:05:05.004401	\N
215	False	t	41	8	6	55	2025-05-27 23:08:06.071504	\N
216	True	t	41	8	6	56	2025-05-27 23:09:13.079295	\N
217	False	f	41	8	6	56	2025-05-27 23:09:34.997374	\N
218	True	f	41	8	6	57	2025-05-27 23:10:33.140583	\N
219	False	t	41	8	6	57	2025-05-27 23:10:45.897813	\N
220	True	t	41	8	6	58	2025-05-27 23:15:25.384239	\N
221	False	f	41	8	6	58	2025-05-27 23:15:43.792141	\N
222	They specify Bluetooth protocol versions like 4.0, 5.0, or 5.2.	f	41	8	6	59	2025-05-27 23:46:29.570844	\N
223	They define the maximum transmission power and range of Bluetooth devices for different use cases.	t	41	8	6	59	2025-05-27 23:47:13.173961	\N
224	They define encryption levels in Bluetooth pairing.	f	41	8	6	59	2025-05-27 23:47:36.328789	\N
225	They categorize the number of simultaneous devices a Bluetooth controller can handle.	f	41	8	6	59	2025-05-27 23:47:54.373631	\N
226	To avoid interference by dynamically skipping over congested or noisy frequency channels in the 2.4 GHz band.	t	41	8	6	60	2025-05-27 23:51:10.784777	\N
227	To increase the modulation speed of each Bluetooth channel.	f	41	8	6	60	2025-05-27 23:51:37.697272	\N
228	To enforce encryption during the frequency hopping process.	f	41	8	6	60	2025-05-27 23:51:56.585099	\N
229	To switch between the 2.4 GHz and 5 GHz bands for improved performance.	f	41	8	6	60	2025-05-27 23:52:20.766954	\N
230	They are special pins used only for PWM output and cannot be read by the CPU.	f	41	8	6	61	2025-05-28 00:17:26.617174	\N
231	They are always high-speed SPI pins used for external flash memory.	f	41	8	6	61	2025-05-28 00:17:58.418037	\N
232	They determine the chip’s boot configuration by reading pin levels during power-up or reset.	t	41	8	6	61	2025-05-28 00:18:46.34493	\N
233	They are used to monitor battery levels and adjust voltage regulators dynamically.	f	41	8	6	61	2025-05-28 00:19:26.094411	\N
234	A synchronous protocol that uses a clock line along with data lines.	f	41	8	6	62	2025-05-28 00:22:07.086364	\N
235	A wireless protocol for data transmission between Bluetooth devices.	f	41	8	6	62	2025-05-28 00:22:40.094339	\N
236	A file transfer format used for flashing SD cards on embedded devices.	f	41	8	6	62	2025-05-28 00:22:55.657509	\N
237	A serial communication protocol that transmits data asynchronously over TX and RX lines without a shared clock.	t	41	8	6	62	2025-05-28 00:23:22.988855	\N
238	A high-speed synchronous protocol where a master communicates with one or more slaves using a clock and separate data lines.	t	41	8	6	63	2025-05-28 00:28:17.167512	\N
239	A wireless protocol used for long-distance sensor communication.	f	41	8	6	63	2025-05-28 00:28:51.523816	\N
240	An asynchronous protocol with automatic device addressing.	f	41	8	6	63	2025-05-28 00:29:04.357232	\N
241	A protocol designed to communicate between computers over USB.	f	41	8	6	63	2025-05-28 00:29:25.230927	\N
242	For serial data transfer between microcontrollers using two wires only.	f	41	8	6	64	2025-05-28 00:38:04.056013	\N
243	For wireless communication between devices in a secure digital format.	f	41	8	6	64	2025-05-28 00:38:16.824946	\N
244	For connecting peripheral modules like Wi-Fi or Bluetooth using the SD card interface.	t	41	8	6	64	2025-05-28 00:38:36.027637	\N
245	For reading encrypted files from SD cards over a USB interface.	f	41	8	6	64	2025-05-28 00:38:53.650577	\N
246	Connecting multiple devices over a shared two-wire interface.	t	41	8	6	65	2025-05-28 00:41:58.231852	\N
247	Sending data wirelessly over long distances using analog signals.	f	41	8	6	65	2025-05-28 00:42:19.548866	\N
248	Performing direct memory access between two microcontrollers.	f	41	8	6	65	2025-05-28 00:42:32.297253	\N
249	Encrypting serial communication between USB and SPI modules.	f	41	8	6	65	2025-05-28 00:42:48.604112	\N
250	It changes the voltage to increase or decrease the current through the LED.	f	41	8	6	66	2025-05-28 10:58:52.378491	\N
251	It adjusts the on-off timing rapidly to simulate different brightness levels.	f	41	8	6	66	2025-05-28 10:59:18.9957	\N
252	It adjusts the on-off timing rapidly to simulate different brightness levels.	t	41	8	6	66	2025-05-28 11:00:42.835412	\N
253	It encodes brightness as binary data sent over I²C.	f	41	8	6	66	2025-05-28 11:01:05.528583	\N
254	It uses frequency modulation to change LED flickering speed.	f	41	8	6	66	2025-05-28 11:01:28.184786	\N
255	By changing the voltage with a DAC to adjust motor speed.	f	41	8	6	67	2025-05-28 11:08:11.875484	\N
256	By rapidly switching the motor power on and off at a fixed frequency.	t	41	8	6	67	2025-05-28 11:08:45.411367	\N
257	By reversing current direction through the motor at regular intervals.	f	41	8	6	67	2025-05-28 11:09:05.731219	\N
258	By sending binary commands over a UART interface to the motor coils.	f	41	8	6	67	2025-05-28 11:09:30.662817	\N
259	To send digital audio data between chips like microcontrollers and Digital-To-Analogs converters.	t	41	8	6	68	2025-05-28 11:13:18.195171	\N
260	To send analog signals over serial ports using a shared clock.	f	41	8	6	68	2025-05-28 11:13:39.463718	\N
261	To perform encrypted communication between SPI and I²C buses.	f	41	8	6	68	2025-05-28 11:13:52.282901	\N
262	To connect USB audio devices using I²C-compatible pins.	f	41	8	6	68	2025-05-28 11:14:05.746407	\N
263	Sending control signals over short distances using light. 	t	41	8	6	69	2025-05-28 11:19:03.464146	\N
264	Sending control signals over short distances using light.	f	41	8	6	69	2025-05-28 11:19:22.892332	\N
265	Sending digital data through copper wires using RF modulation.	f	41	8	6	69	2025-05-28 11:19:39.584094	\N
266	Connecting devices to a router using 2.4 GHz signals.	f	41	8	6	69	2025-05-28 11:19:52.291839	\N
267	To generate precise square waves using digital timers.	f	41	8	6	70	2025-05-28 17:08:37.361512	\N
268	To detect and count input pulses from external signals.	t	41	8	6	70	2025-05-28 17:09:15.45984	\N
269	To convert analog voltage into digital values for processing.	f	41	8	6	70	2025-05-28 17:09:41.126679	\N
270	To synchronize I²C communication using clock stretching.	f	41	8	6	70	2025-05-28 17:09:54.382422	\N
271	It performs high-speed analog-to-digital conversions.	f	41	8	6	71	2025-05-28 17:14:46.482526	\N
272	It manages internal flash memory addressing.	f	41	8	6	71	2025-05-28 17:15:08.497682	\N
273	It is a configurable pin used for digital input or output.	t	41	8	6	71	2025-05-28 17:15:27.8836	\N
274	It controls wireless communication over the 2.4 GHz band.	f	41	8	6	71	2025-05-28 17:15:48.528037	\N
275	It measures light levels using an internal photodiode.	f	41	8	6	72	2025-05-28 17:21:50.998236	\N
276	It detects touch input by sensing changes in electrical capacitance.	t	41	8	6	72	2025-05-28 17:22:11.474319	\N
277	It triggers an interrupt when ambient sound exceeds a threshold.	f	41	8	6	72	2025-05-28 17:22:33.979155	\N
278	It measures temperature changes using a thermal resistor.	f	41	8	6	72	2025-05-28 17:22:54.833001	\N
279	To convert digital signals into analog waveforms for audio output.	f	41	8	6	73	2025-05-28 17:24:48.234616	\N
280	To measure voltage levels and produce corresponding digital values.	t	41	8	6	73	2025-05-28 17:25:08.967753	\N
281	To switch GPIOs between input and output modes dynamically.	f	41	8	6	73	2025-05-28 17:26:40.864521	\N
282	To generate PWM signals for controlling servo motors.	f	41	8	6	73	2025-05-28 17:26:57.561195	\N
283	It converts analog voltage into a digital value.	f	41	8	6	74	2025-05-28 17:29:01.965694	\N
284	It encodes serial data using pulse-width modulation.	f	41	8	6	74	2025-05-28 17:29:19.180596	\N
285	 It stores digital data in flash memory for audio playback.	f	41	8	6	74	2025-05-28 17:29:37.081143	\N
286	It converts digital values into analog voltage signals.	t	41	8	6	74	2025-05-28 17:30:02.333999	\N
287	To provide short-range wireless communication between embedded devices.	f	41	8	6	75	2025-05-28 17:33:08.089795	\N
288	To establish a low-speed serial link using only one data line.	f	41	8	6	75	2025-05-28 17:33:27.887951	\N
289	To enable reliable communication between devices over a two-wire bus in noisy environments.	t	41	8	6	75	2025-05-28 17:34:06.105971	\N
290	To synchronize multiple UART peripherals using a shared baud rate.	f	41	8	6	75	2025-05-28 17:34:31.629236	\N
291	A USB interface for high-speed camera streaming.	f	41	8	6	76	2025-05-28 17:35:44.61839	\N
292	A wireless protocol designed for remote telemetry.	f	41	8	6	76	2025-05-28 17:36:05.072634	\N
293	A CAN 2.0-compliant controller used for reliable wired communication.	t	41	8	6	76	2025-05-28 17:36:31.921975	\N
294	A UART extension used for debugging multiple serial devices.	f	41	8	6	76	2025-05-28 17:36:52.991507	\N
63	The RTC (Real-Time Clock) is a dedicated hardware peripheral in microcontrollers that keeps track of time, even when the main CPU is off or sleeping.	t	41	8	6	20	2025-05-26 17:12:40.899532	2025-05-30 11:43:18.066907
422	Too much RAM usage	f	41	6	30	115	2025-05-30 15:52:55.212508	\N
423	Limited screen size	f	41	6	30	115	2025-05-30 15:52:55.212508	\N
424	Switching between tasks	t	41	6	30	115	2025-05-30 15:52:55.212508	\N
425	Preventing hardware interrupts	f	41	6	30	115	2025-05-30 15:52:55.212508	\N
426	The dot continues bouncing	f	41	6	30	116	2025-05-30 15:52:55.212508	\N
427	The game saves the position and continues	f	41	6	30	116	2025-05-30 15:52:55.212508	\N
428	The dot bouncing stops	t	41	6	30	116	2025-05-30 15:52:55.212508	\N
429	The program restarts	f	41	6	30	116	2025-05-30 15:52:55.212508	\N
430	Parallel execution	f	41	6	30	117	2025-05-30 15:52:55.212508	\N
431	Simplicity and efficiency	t	41	6	30	117	2025-05-30 15:52:55.212508	\N
432	No need for a keyboard	f	41	6	30	117	2025-05-30 15:52:55.212508	\N
433	Uses multiple CPUs	f	41	6	30	117	2025-05-30 15:52:55.212508	\N
434	In multiple threads	f	41	6	30	118	2025-05-30 15:52:55.212508	\N
435	With hardware interrupts	f	41	6	30	118	2025-05-30 15:52:55.212508	\N
436	As a sequence of states	t	41	6	30	118	2025-05-30 15:52:55.212508	\N
437	Through shell scripts	f	41	6	30	118	2025-05-30 15:52:55.212508	\N
438	Wait, Accept, Render	f	41	6	30	119	2025-05-30 15:52:55.212508	\N
439	Wait for input, Read X, Read Y	t	41	6	30	119	2025-05-30 15:52:55.212508	\N
440	Bounce, Input, Replot	f	41	6	30	119	2025-05-30 15:52:55.212508	\N
441	Start, Pause, End	f	41	6	30	119	2025-05-30 15:52:55.212508	\N
442	Typing the character Y	f	41	6	30	120	2025-05-30 15:52:55.212508	\N
443	Enter key	t	41	6	30	120	2025-05-30 15:52:55.212508	\N
444	Any key	f	41	6	30	120	2025-05-30 15:52:55.212508	\N
445	A non-digit key	f	41	6	30	120	2025-05-30 15:52:55.212508	\N
446	Too many registers used	f	41	6	30	121	2025-05-30 15:52:55.212508	\N
447	Poor CPU efficiency	f	41	6	30	121	2025-05-30 15:52:55.212508	\N
448	Algorithm rewrites required	t	41	6	30	121	2025-05-30 15:52:55.212508	\N
449	Shared memory issues	f	41	6	30	121	2025-05-30 15:52:55.212508	\N
450	Terminates a process	f	41	6	30	122	2025-05-30 15:52:55.212508	\N
451	Triggers an interrupt	f	41	6	30	122	2025-05-30 15:52:55.212508	\N
452	Switches control to the other task	t	41	6	30	122	2025-05-30 15:52:55.212508	\N
453	Locks the execution	f	41	6	30	122	2025-05-30 15:52:55.212508	\N
454	Thread ID	f	41	6	30	123	2025-05-30 15:52:55.212508	\N
455	Hardware queue	f	41	6	30	123	2025-05-30 15:52:55.212508	\N
456	Program stack	t	41	6	30	123	2025-05-30 15:52:55.212508	\N
457	CPU core	f	41	6	30	123	2025-05-30 15:52:55.212508	\N
458	Books on a shelf	f	41	6	30	124	2025-05-30 15:52:55.212508	\N
459	Players taking turns in a game	t	41	6	30	124	2025-05-30 15:52:55.212508	\N
460	Cars racing on different tracks	f	41	6	30	124	2025-05-30 15:52:55.212508	\N
461	Synchronous file reading	f	41	6	30	124	2025-05-30 15:52:55.212508	\N
462	A virtual address space	f	41	6	30	125	2025-05-30 15:52:55.212508	\N
463	The active screen buffer	f	41	6	30	125	2025-05-30 15:52:55.212508	\N
464	Register data needed to resume a task	t	41	6	30	125	2025-05-30 15:52:55.212508	\N
465	The file being executed	f	41	6	30	125	2025-05-30 15:52:55.212508	\N
466	a0–a7	f	41	6	30	126	2025-05-30 15:52:55.212508	\N
467	s0–s11	f	41	6	30	126	2025-05-30 15:52:55.212508	\N
468	sp and ra	f	41	6	30	126	2025-05-30 15:52:55.212508	\N
469	t0–t6	t	41	6	30	126	2025-05-30 15:52:55.212508	\N
470	Registers are cleared	f	41	6	30	127	2025-05-30 15:52:55.212508	\N
471	Stack memory is erased	f	41	6	30	127	2025-05-30 15:52:55.212508	\N
472	Registers of one task are saved and another’s are restored	t	41	6	30	127	2025-05-30 15:52:55.212508	\N
473	All processes are paused	f	41	6	30	127	2025-05-30 15:52:55.212508	\N
474	Inefficient memory usage	f	41	6	30	128	2025-05-30 15:52:55.212508	\N
475	Low-level system access	f	41	6	30	128	2025-05-30 15:52:55.212508	\N
476	Context switching overhead	t	41	6	30	128	2025-05-30 15:52:55.212508	\N
477	Difficulty understanding algorithms	f	41	6	30	128	2025-05-30 15:52:55.212508	\N
478	It initializes memory	f	41	6	30	129	2025-05-30 15:52:55.212508	\N
479	To avoid skipping tasks	f	41	6	30	129	2025-05-30 15:52:55.212508	\N
480	To reduce unnecessary context switches	t	41	6	30	129	2025-05-30 15:52:55.212508	\N
481	It creates additional stack frames	f	41	6	30	129	2025-05-30 15:52:55.212508	\N
482	O(log n)	f	41	23	31	130	2025-05-30 17:12:15.026211	\N
483	O(n)	f	41	23	31	130	2025-05-30 17:12:15.026211	\N
484	O(n log n)	f	41	23	31	130	2025-05-30 17:12:15.026211	\N
485	O(n^2)	t	41	23	31	130	2025-05-30 17:12:15.026211	\N
486	O(n)	f	41	23	31	131	2025-05-30 17:12:15.026211	\N
487	O(log n)	t	41	23	31	131	2025-05-30 17:12:15.026211	\N
488	O(n log n)	f	41	23	31	131	2025-05-30 17:12:15.026211	\N
489	O(1)	f	41	23	31	131	2025-05-30 17:12:15.026211	\N
490	O(n)	f	41	23	31	132	2025-05-30 17:12:15.026211	\N
491	O(log n)	t	41	23	31	132	2025-05-30 17:12:15.026211	\N
492	O(1)	f	41	23	31	132	2025-05-30 17:12:15.026211	\N
493	O(n log n)	f	41	23	31	132	2025-05-30 17:12:15.026211	\N
494	O(n)	f	41	23	31	133	2025-05-30 17:12:15.026211	\N
495	O(n log n)	f	41	23	31	133	2025-05-30 17:12:15.026211	\N
496	O(n^2)	t	41	23	31	133	2025-05-30 17:12:15.026211	\N
497	O(log n)	f	41	23	31	133	2025-05-30 17:12:15.026211	\N
498	Linear search	f	41	23	31	134	2025-05-30 17:12:15.026211	\N
499	Binary search	f	41	23	31	134	2025-05-30 17:12:15.026211	\N
500	Hash table	t	41	23	31	134	2025-05-30 17:12:15.026211	\N
501	Selection sort	f	41	23	31	134	2025-05-30 17:12:15.026211	\N
502	O(n)	f	41	23	31	135	2025-05-30 17:12:15.026211	\N
503	O(n log n)	f	41	23	31	135	2025-05-30 17:12:15.026211	\N
504	O(n^2)	t	41	23	31	135	2025-05-30 17:12:15.026211	\N
505	O(log n)	f	41	23	31	135	2025-05-30 17:12:15.026211	\N
506	Theta (Θ)	f	41	23	31	136	2025-05-30 17:12:15.026211	\N
507	Omega (Ω)	f	41	23	31	136	2025-05-30 17:12:15.026211	\N
508	Zeta (Ζ)	t	41	23	31	136	2025-05-30 17:12:15.026211	\N
509	Big-O (O)	f	41	23	31	136	2025-05-30 17:12:15.026211	\N
510	O(n)	f	41	23	31	137	2025-05-30 17:12:15.026211	\N
511	O(n log n)	f	41	23	31	137	2025-05-30 17:12:15.026211	\N
512	O(log n)	t	41	23	31	137	2025-05-30 17:12:15.026211	\N
513	O(n^2)	f	41	23	31	137	2025-05-30 17:12:15.026211	\N
514	O(n)	f	41	23	31	138	2025-05-30 17:12:15.026211	\N
515	O(n log n)	t	41	23	31	138	2025-05-30 17:12:15.026211	\N
516	O(log n)	f	41	23	31	138	2025-05-30 17:12:15.026211	\N
517	O(n^2)	f	41	23	31	138	2025-05-30 17:12:15.026211	\N
518	O(n)	f	41	23	31	139	2025-05-30 17:12:15.026211	\N
519	O(log n)	f	41	23	31	139	2025-05-30 17:12:15.026211	\N
520	O(2n)	t	41	23	31	139	2025-05-30 17:12:15.026211	\N
521	O(n^2)	f	41	23	31	139	2025-05-30 17:12:15.026211	\N
522	Quick sort	f	41	23	31	140	2025-05-30 17:12:15.026211	\N
523	Heap sort	t	41	23	31	140	2025-05-30 17:12:15.026211	\N
524	Bubble sort	f	41	23	31	140	2025-05-30 17:12:15.026211	\N
525	Selection sort	f	41	23	31	140	2025-05-30 17:12:15.026211	\N
526	O(n)	t	41	23	31	141	2025-05-30 17:12:15.026211	\N
527	O(n log n)	f	41	23	31	141	2025-05-30 17:12:15.026211	\N
528	O(n^2)	f	41	23	31	141	2025-05-30 17:12:15.026211	\N
529	O(log n)	f	41	23	31	141	2025-05-30 17:12:15.026211	\N
530	O(log n)	t	41	23	31	142	2025-05-30 17:12:15.026211	\N
531	O(n)	f	41	23	31	142	2025-05-30 17:12:15.026211	\N
532	O(n log n)	f	41	23	31	142	2025-05-30 17:12:15.026211	\N
533	O(n^2)	f	41	23	31	142	2025-05-30 17:12:15.026211	\N
534	Binary Search	f	41	23	31	143	2025-05-30 17:12:15.026211	\N
535	Merge Sort	f	41	23	31	143	2025-05-30 17:12:15.026211	\N
536	Bubble Sort	t	41	23	31	143	2025-05-30 17:12:15.026211	\N
537	Heap Sort	f	41	23	31	143	2025-05-30 17:12:15.026211	\N
538	O(n)	f	41	23	31	144	2025-05-30 17:12:15.026211	\N
539	O(log n)	f	41	23	31	144	2025-05-30 17:12:15.026211	\N
540	O(n log n)	t	41	23	31	144	2025-05-30 17:12:15.026211	\N
541	O(n^2)	f	41	23	31	144	2025-05-30 17:12:15.026211	\N
542	Selection Sort	f	41	23	32	145	2025-05-30 21:45:10.359687	\N
543	Bubble Sort	t	41	23	32	145	2025-05-30 21:45:10.359687	\N
544	Quick Sort	f	41	23	32	145	2025-05-30 21:45:10.359687	\N
545	Heap Sort	f	41	23	32	145	2025-05-30 21:45:10.359687	\N
546	Bubble Sort	f	41	23	32	146	2025-05-30 21:45:10.359687	\N
547	Insertion Sort	t	41	23	32	146	2025-05-30 21:45:10.359687	\N
548	Selection Sort	f	41	23	32	146	2025-05-30 21:45:10.359687	\N
549	Counting Sort	f	41	23	32	146	2025-05-30 21:45:10.359687	\N
550	O(n)	f	41	23	32	147	2025-05-30 21:45:10.359687	\N
551	O(log n)	f	41	23	32	147	2025-05-30 21:45:10.359687	\N
552	O(n²)	t	41	23	32	147	2025-05-30 21:45:10.359687	\N
553	O(n log n)	f	41	23	32	147	2025-05-30 21:45:10.359687	\N
554	O(n)	t	41	23	32	148	2025-05-30 21:45:10.359687	\N
555	O(n log n)	f	41	23	32	148	2025-05-30 21:45:10.359687	\N
556	O(log n)	f	41	23	32	148	2025-05-30 21:45:10.359687	\N
557	O(n²)	f	41	23	32	148	2025-05-30 21:45:10.359687	\N
558	Compare and swap adjacent elements	f	41	23	32	149	2025-05-30 21:45:10.359687	\N
559	Place elements in a heap structure	f	41	23	32	149	2025-05-30 21:45:10.359687	\N
560	Find the smallest element and place it at the front	t	41	23	32	149	2025-05-30 21:45:10.359687	\N
561	Merge two halves	f	41	23	32	149	2025-05-30 21:45:10.359687	\N
562	arr[j] = arr[j + 1];	f	41	23	32	150	2025-05-30 21:45:10.359687	\N
563	swap(arr[j], arr[j + 1]);	t	41	23	32	150	2025-05-30 21:45:10.359687	\N
564	arr[j + 1] = j;	f	41	23	32	150	2025-05-30 21:45:10.359687	\N
565	break;	f	41	23	32	150	2025-05-30 21:45:10.359687	\N
566	n	f	41	23	32	151	2025-05-30 21:45:10.359687	\N
567	n log n	f	41	23	32	151	2025-05-30 21:45:10.359687	\N
568	n(n-1)/2	t	41	23	32	151	2025-05-30 21:45:10.359687	\N
569	n² log n	f	41	23	32	151	2025-05-30 21:45:10.359687	\N
570	Selection Sort	f	41	23	32	152	2025-05-30 21:45:10.359687	\N
571	Insertion Sort	t	41	23	32	152	2025-05-30 21:45:10.359687	\N
572	Bubble Sort	f	41	23	32	152	2025-05-30 21:45:10.359687	\N
573	Heap Sort	f	41	23	32	152	2025-05-30 21:45:10.359687	\N
574	!swapped	t	41	23	32	153	2025-05-30 21:45:10.359687	\N
575	swapped	f	41	23	32	153	2025-05-30 21:45:10.359687	\N
576	arr[j] < arr[j+1]	f	41	23	32	153	2025-05-30 21:45:10.359687	\N
577	i == n	f	41	23	32	153	2025-05-30 21:45:10.359687	\N
578	Selection Sort	f	41	23	32	154	2025-05-30 21:45:10.359687	\N
579	Bubble Sort	t	41	23	32	154	2025-05-30 21:45:10.359687	\N
580	Heap Sort	f	41	23	32	154	2025-05-30 21:45:10.359687	\N
581	Merge Sort	f	41	23	32	154	2025-05-30 21:45:10.359687	\N
582	Pulling the largest elements to the front	f	41	23	32	155	2025-05-30 21:45:10.359687	\N
583	Placing new cards into your hand in order	t	41	23	32	155	2025-05-30 21:45:10.359687	\N
584	Random shuffling	f	41	23	32	155	2025-05-30 21:45:10.359687	\N
585	Stacking books by height	f	41	23	32	155	2025-05-30 21:45:10.359687	\N
586	arr[i] = key;	f	41	23	32	156	2025-05-30 21:45:10.359687	\N
587	arr[j] = key;	f	41	23	32	156	2025-05-30 21:45:10.359687	\N
588	arr[j + 1] = key;	t	41	23	32	156	2025-05-30 21:45:10.359687	\N
589	arr[i + 1] = key;	f	41	23	32	156	2025-05-30 21:45:10.359687	\N
590	Insertion Sort	f	41	23	32	157	2025-05-30 21:45:10.359687	\N
591	Bubble Sort	f	41	23	32	157	2025-05-30 21:45:10.359687	\N
592	Selection Sort	t	41	23	32	157	2025-05-30 21:45:10.359687	\N
593	Merge Sort	f	41	23	32	157	2025-05-30 21:45:10.359687	\N
594	Reversed array	f	41	23	32	158	2025-05-30 21:45:10.359687	\N
595	Sorted array	t	41	23	32	158	2025-05-30 21:45:10.359687	\N
596	Random array	f	41	23	32	158	2025-05-30 21:45:10.359687	\N
597	All elements the same	f	41	23	32	158	2025-05-30 21:45:10.359687	\N
598	It checks if swaps were made	f	41	23	32	159	2025-05-30 21:45:10.359687	\N
599	It skips elements already in place	t	41	23	32	159	2025-05-30 21:45:10.359687	\N
600	It divides the array in halves	f	41	23	32	159	2025-05-30 21:45:10.359687	\N
601	It selects the max value each time	f	41	23	32	159	2025-05-30 21:45:10.359687	\N
602	Bubble Sort	f	41	23	32	160	2025-05-30 21:45:10.359687	\N
603	Insertion Sort	f	41	23	32	160	2025-05-30 21:45:10.359687	\N
604	Selection Sort	f	41	23	32	160	2025-05-30 21:45:10.359687	\N
605	Counting Sort	t	41	23	32	160	2025-05-30 21:45:10.359687	\N
606	Sorted input	f	41	23	32	161	2025-05-30 21:45:10.359687	\N
607	All elements equal	f	41	23	32	161	2025-05-30 21:45:10.359687	\N
608	Counting swaps only	t	41	23	32	161	2025-05-30 21:45:10.359687	\N
609	Time complexity	f	41	23	32	161	2025-05-30 21:45:10.359687	\N
610	O(n)	f	41	23	32	162	2025-05-30 21:45:10.359687	\N
611	O(n log n)	f	41	23	32	162	2025-05-30 21:45:10.359687	\N
612	O(n²)	t	41	23	32	162	2025-05-30 21:45:10.359687	\N
613	O(log n)	f	41	23	32	162	2025-05-30 21:45:10.359687	\N
614	Sorted in ascending order	f	41	23	32	163	2025-05-30 21:45:10.359687	\N
615	Random order	f	41	23	32	163	2025-05-30 21:45:10.359687	\N
616	Sorted in descending order	t	41	23	32	163	2025-05-30 21:45:10.359687	\N
617	All elements the same	f	41	23	32	163	2025-05-30 21:45:10.359687	\N
618	Insertion Sort	f	41	23	32	164	2025-05-30 21:45:10.359687	\N
619	Selection Sort	t	41	23	32	164	2025-05-30 21:45:10.359687	\N
620	Bubble Sort	f	41	23	32	164	2025-05-30 21:45:10.359687	\N
621	Merge Sort	f	41	23	32	164	2025-05-30 21:45:10.359687	\N
622	Merge Sort	t	41	23	33	165	2025-05-30 21:51:47.173557	\N
623	Quick Sort	f	41	23	33	165	2025-05-30 21:51:47.173557	\N
624	Heap Sort	f	41	23	33	165	2025-05-30 21:51:47.173557	\N
625	Insertion Sort	f	41	23	33	165	2025-05-30 21:51:47.173557	\N
626	arr.sort(l, r)	f	41	23	33	166	2025-05-30 21:51:47.173557	\N
627	merge(arr, l, m, r)	t	41	23	33	166	2025-05-30 21:51:47.173557	\N
628	split(arr, l, m, r)	f	41	23	33	166	2025-05-30 21:51:47.173557	\N
629	combine(arr, l, r)	f	41	23	33	166	2025-05-30 21:51:47.173557	\N
630	O(n²)	f	41	23	33	167	2025-05-30 21:51:47.173557	\N
631	O(n log n)	t	41	23	33	167	2025-05-30 21:51:47.173557	\N
632	O(log n)	f	41	23	33	167	2025-05-30 21:51:47.173557	\N
633	O(n)	f	41	23	33	167	2025-05-30 21:51:47.173557	\N
634	O(n)	f	41	23	33	168	2025-05-30 21:51:47.173557	\N
635	O(n log n)	f	41	23	33	168	2025-05-30 21:51:47.173557	\N
636	O(n²)	t	41	23	33	168	2025-05-30 21:51:47.173557	\N
637	O(log n)	f	41	23	33	168	2025-05-30 21:51:47.173557	\N
638	Merge Sort	f	41	23	33	169	2025-05-30 21:51:47.173557	\N
639	Quick Sort	t	41	23	33	169	2025-05-30 21:51:47.173557	\N
640	Bubble Sort	f	41	23	33	169	2025-05-30 21:51:47.173557	\N
641	Insertion Sort	f	41	23	33	169	2025-05-30 21:51:47.173557	\N
642	Heapify	f	41	23	33	170	2025-05-30 21:51:47.173557	\N
643	Pivot element	t	41	23	33	170	2025-05-30 21:51:47.173557	\N
644	Binary tree	f	41	23	33	170	2025-05-30 21:51:47.173557	\N
645	Split index	f	41	23	33	170	2025-05-30 21:51:47.173557	\N
646	Quick Sort	f	41	23	33	171	2025-05-30 21:51:47.173557	\N
647	Heap Sort	t	41	23	33	171	2025-05-30 21:51:47.173557	\N
648	Merge Sort	f	41	23	33	171	2025-05-30 21:51:47.173557	\N
649	Insertion Sort	f	41	23	33	171	2025-05-30 21:51:47.173557	\N
650	return largest	f	41	23	33	172	2025-05-30 21:51:47.173557	\N
651	heapify(A)	f	41	23	33	172	2025-05-30 21:51:47.173557	\N
652	maxHeapify(A, largest)	t	41	23	33	172	2025-05-30 21:51:47.173557	\N
653	continue	f	41	23	33	172	2025-05-30 21:51:47.173557	\N
654	Quick Sort	f	41	23	33	173	2025-05-30 21:51:47.173557	\N
655	Merge Sort	f	41	23	33	173	2025-05-30 21:51:47.173557	\N
656	Heap Sort	t	41	23	33	173	2025-05-30 21:51:47.173557	\N
657	Insertion Sort	f	41	23	33	173	2025-05-30 21:51:47.173557	\N
658	Divide and conquer	t	41	23	33	174	2025-05-30 21:51:47.173557	\N
659	Heapify	f	41	23	33	174	2025-05-30 21:51:47.173557	\N
660	Iterative comparison	f	41	23	33	174	2025-05-30 21:51:47.173557	\N
661	Counting	f	41	23	33	174	2025-05-30 21:51:47.173557	\N
662	Pivot = middle	f	41	23	33	175	2025-05-30 21:51:47.173557	\N
663	Pivot = median-of-three	f	41	23	33	175	2025-05-30 21:51:47.173557	\N
664	Pivot = first element on sorted input	t	41	23	33	175	2025-05-30 21:51:47.173557	\N
665	Random pivot	f	41	23	33	175	2025-05-30 21:51:47.173557	\N
666	O(n²)	f	41	23	33	176	2025-05-30 21:51:47.173557	\N
667	O(n)	t	41	23	33	176	2025-05-30 21:51:47.173557	\N
668	O(log n)	f	41	23	33	176	2025-05-30 21:51:47.173557	\N
669	O(1)	f	41	23	33	176	2025-05-30 21:51:47.173557	\N
670	Merge Sort	f	41	23	33	177	2025-05-30 21:51:47.173557	\N
671	Quick Sort	t	41	23	33	177	2025-05-30 21:51:47.173557	\N
672	Heap Sort	f	41	23	33	177	2025-05-30 21:51:47.173557	\N
673	Bubble Sort	f	41	23	33	177	2025-05-30 21:51:47.173557	\N
674	heapify(arr)	f	41	23	33	178	2025-05-30 21:51:47.173557	\N
675	maxHeapify(arr, 0)	f	41	23	33	178	2025-05-30 21:51:47.173557	\N
676	maxHeapify(arr, 0, i)	t	41	23	33	178	2025-05-30 21:51:47.173557	\N
677	sort(arr)	f	41	23	33	178	2025-05-30 21:51:47.173557	\N
678	Quick Sort	f	41	23	33	179	2025-05-30 21:51:47.173557	\N
679	Merge Sort	t	41	23	33	179	2025-05-30 21:51:47.173557	\N
680	Heap Sort	f	41	23	33	179	2025-05-30 21:51:47.173557	\N
681	Counting Sort	f	41	23	33	179	2025-05-30 21:51:47.173557	\N
682	O(n²)	f	41	23	33	180	2025-05-30 21:51:47.173557	\N
683	O(n log n)	t	41	23	33	180	2025-05-30 21:51:47.173557	\N
684	O(n)	f	41	23	33	180	2025-05-30 21:51:47.173557	\N
685	O(log n)	f	41	23	33	180	2025-05-30 21:51:47.173557	\N
686	It is in-place	f	41	23	33	181	2025-05-30 21:51:47.173557	\N
687	It is stable	t	41	23	33	181	2025-05-30 21:51:47.173557	\N
688	It uses a pivot	f	41	23	33	181	2025-05-30 21:51:47.173557	\N
689	It performs well on average	f	41	23	33	181	2025-05-30 21:51:47.173557	\N
690	Quick Sort	f	41	23	33	182	2025-05-30 21:51:47.173557	\N
691	Heap Sort	f	41	23	33	182	2025-05-30 21:51:47.173557	\N
692	Merge Sort	t	41	23	33	182	2025-05-30 21:51:47.173557	\N
693	Selection Sort	f	41	23	33	182	2025-05-30 21:51:47.173557	\N
694	Stack	f	41	23	33	183	2025-05-30 21:51:47.173557	\N
695	Linked List	f	41	23	33	183	2025-05-30 21:51:47.173557	\N
696	Binary Heap	t	41	23	33	183	2025-05-30 21:51:47.173557	\N
697	Binary Search Tree	f	41	23	33	183	2025-05-30 21:51:47.173557	\N
698	O(n)	t	41	23	33	184	2025-05-30 21:51:47.173557	\N
699	O(n log n)	f	41	23	33	184	2025-05-30 21:51:47.173557	\N
700	O(log n)	f	41	23	33	184	2025-05-30 21:51:47.173557	\N
701	O(n²)	f	41	23	33	184	2025-05-30 21:51:47.173557	\N
702	Compares pattern to all substrings of text	t	41	23	34	185	2025-05-30 21:56:39.93923	\N
703	Uses prefix function to skip characters	f	41	23	34	185	2025-05-30 21:56:39.93923	\N
704	Builds a DFA table in advance	f	41	23	34	185	2025-05-30 21:56:39.93923	\N
705	Uses hashing to speed up search	f	41	23	34	185	2025-05-30 21:56:39.93923	\N
706	O(m+n)	f	41	23	34	186	2025-05-30 21:56:39.93923	\N
707	O(n)	f	41	23	34	186	2025-05-30 21:56:39.93923	\N
708	O(mn)	t	41	23	34	186	2025-05-30 21:56:39.93923	\N
709	O(log n)	f	41	23	34	186	2025-05-30 21:56:39.93923	\N
710	Brute Force	f	41	23	34	187	2025-05-30 21:56:39.93923	\N
711	KMP	t	41	23	34	187	2025-05-30 21:56:39.93923	\N
712	Naive Search	f	41	23	34	187	2025-05-30 21:56:39.93923	\N
713	Binary Search	f	41	23	34	187	2025-05-30 21:56:39.93923	\N
714	To count number of matches	f	41	23	34	188	2025-05-30 21:56:39.93923	\N
715	To find the next possible match after mismatch	t	41	23	34	188	2025-05-30 21:56:39.93923	\N
716	To skip characters in text	f	41	23	34	188	2025-05-30 21:56:39.93923	\N
717	To compute edit distance	f	41	23	34	188	2025-05-30 21:56:39.93923	\N
718	There is a prefix of length 2 also found at the suffix ending at index 2	f	41	23	34	189	2025-05-30 21:56:39.93923	\N
719	The first 3 characters repeat later	f	41	23	34	189	2025-05-30 21:56:39.93923	\N
720	The pattern has overlap allowing partial reuse after mismatch	t	41	23	34	189	2025-05-30 21:56:39.93923	\N
721	The pattern has no overlaps	f	41	23	34	189	2025-05-30 21:56:39.93923	\N
722	π[i] = k + 1	t	41	23	34	190	2025-05-30 21:56:39.93923	\N
723	π[i] = i	f	41	23	34	190	2025-05-30 21:56:39.93923	\N
724	π[i] = k	f	41	23	34	190	2025-05-30 21:56:39.93923	\N
725	π[i] = π[k]	f	41	23	34	190	2025-05-30 21:56:39.93923	\N
726	O(mn)	f	41	23	34	191	2025-05-30 21:56:39.93923	\N
727	O(m + n)	t	41	23	34	191	2025-05-30 21:56:39.93923	\N
728	O(n²)	f	41	23	34	191	2025-05-30 21:56:39.93923	\N
729	O(log n)	f	41	23	34	191	2025-05-30 21:56:39.93923	\N
730	It matches substrings randomly	f	41	23	34	192	2025-05-30 21:56:39.93923	\N
731	It builds a finite state machine to transition on characters	t	41	23	34	192	2025-05-30 21:56:39.93923	\N
732	It compresses the text	f	41	23	34	192	2025-05-30 21:56:39.93923	\N
733	It finds the longest common prefix	f	41	23	34	192	2025-05-30 21:56:39.93923	\N
734	The pattern is short	f	41	23	34	193	2025-05-30 21:56:39.93923	\N
827	Load factor exceeds threshold	t	41	23	35	216	2025-05-30 22:00:04.934239	\N
735	There are many overlapping prefixes and suffixes	t	41	23	34	193	2025-05-30 21:56:39.93923	\N
736	The pattern has no repetition	f	41	23	34	193	2025-05-30 21:56:39.93923	\N
737	The text is compressed	f	41	23	34	193	2025-05-30 21:56:39.93923	\N
738	It checks fewer characters in text	f	41	23	34	194	2025-05-30 21:56:39.93923	\N
739	It avoids redundant comparisons using prefix function	t	41	23	34	194	2025-05-30 21:56:39.93923	\N
740	It is faster for all cases	f	41	23	34	194	2025-05-30 21:56:39.93923	\N
741	It builds a heap	f	41	23	34	194	2025-05-30 21:56:39.93923	\N
742	1	f	41	23	34	195	2025-05-30 21:56:39.93923	\N
743	0	t	41	23	34	195	2025-05-30 21:56:39.93923	\N
744	-1	f	41	23	34	195	2025-05-30 21:56:39.93923	\N
745	length of pattern	f	41	23	34	195	2025-05-30 21:56:39.93923	\N
746	"aaaaaa"	t	41	23	34	196	2025-05-30 21:56:39.93923	\N
747	"abcdef"	f	41	23	34	196	2025-05-30 21:56:39.93923	\N
748	"ababab"	f	41	23	34	196	2025-05-30 21:56:39.93923	\N
749	"abcabc"	f	41	23	34	196	2025-05-30 21:56:39.93923	\N
750	The pointer moves forward by 1 in the text	f	41	23	34	197	2025-05-30 21:56:39.93923	\N
751	It shifts by full pattern length	f	41	23	34	197	2025-05-30 21:56:39.93923	\N
752	It uses π[k-1] to resume from earlier match	t	41	23	34	197	2025-05-30 21:56:39.93923	\N
753	It restarts from index 0 of pattern	f	41	23	34	197	2025-05-30 21:56:39.93923	\N
754	n × m	f	41	23	34	198	2025-05-30 21:56:39.93923	\N
755	|Σ| × m	t	41	23	34	198	2025-05-30 21:56:39.93923	\N
756	|Σ| × n	f	41	23	34	198	2025-05-30 21:56:39.93923	\N
757	m × m	f	41	23	34	198	2025-05-30 21:56:39.93923	\N
758	KMP	t	41	23	34	199	2025-05-30 21:56:39.93923	\N
759	DFA	f	41	23	34	199	2025-05-30 21:56:39.93923	\N
760	Both are same	f	41	23	34	199	2025-05-30 21:56:39.93923	\N
761	Depends on implementation	f	41	23	34	199	2025-05-30 21:56:39.93923	\N
762	Finding repeated substrings in DNA sequences	t	41	23	34	200	2025-05-30 21:56:39.93923	\N
763	Finding minimum value in an array	f	41	23	34	200	2025-05-30 21:56:39.93923	\N
764	Reversing strings	f	41	23	34	200	2025-05-30 21:56:39.93923	\N
765	Encrypting data	f	41	23	34	200	2025-05-30 21:56:39.93923	\N
766	By avoiding unnecessary comparisons	t	41	23	34	201	2025-05-30 21:56:39.93923	\N
767	By increasing array size	f	41	23	34	201	2025-05-30 21:56:39.93923	\N
768	By hashing pattern	f	41	23	34	201	2025-05-30 21:56:39.93923	\N
769	By removing duplicate characters	f	41	23	34	201	2025-05-30 21:56:39.93923	\N
770	Searching the text	f	41	23	34	202	2025-05-30 21:56:39.93923	\N
771	Building the prefix function table	t	41	23	34	202	2025-05-30 21:56:39.93923	\N
772	Calculating frequency of characters	f	41	23	34	202	2025-05-30 21:56:39.93923	\N
773	Constructing the DFA	f	41	23	34	202	2025-05-30 21:56:39.93923	\N
774	It always performs better than brute force	t	41	23	34	203	2025-05-30 21:56:39.93923	\N
775	It guarantees O(n) time for search	f	41	23	34	203	2025-05-30 21:56:39.93923	\N
776	It precomputes a prefix array	f	41	23	34	203	2025-05-30 21:56:39.93923	\N
777	It skips unnecessary matches	f	41	23	34	203	2025-05-30 21:56:39.93923	\N
778	O(n)	f	41	23	34	204	2025-05-30 21:56:39.93923	\N
779	O(m)	t	41	23	34	204	2025-05-30 21:56:39.93923	\N
780	O(nm)	f	41	23	34	204	2025-05-30 21:56:39.93923	\N
781	O(1)	f	41	23	34	204	2025-05-30 21:56:39.93923	\N
782	To sort keys alphabetically	f	41	23	35	205	2025-05-30 22:00:04.934239	\N
783	To compress data	f	41	23	35	205	2025-05-30 22:00:04.934239	\N
784	To map keys to array indices	t	41	23	35	205	2025-05-30 22:00:04.934239	\N
785	To encrypt keys	f	41	23	35	205	2025-05-30 22:00:04.934239	\N
786	Sorting	f	41	23	35	206	2025-05-30 22:00:04.934239	\N
787	Chaining	t	41	23	35	206	2025-05-30 22:00:04.934239	\N
788	Compression	f	41	23	35	206	2025-05-30 22:00:04.934239	\N
789	Expansion	f	41	23	35	206	2025-05-30 22:00:04.934239	\N
790	The number of keys per bucket	f	41	23	35	207	2025-05-30 22:00:04.934239	\N
791	The size of the array	f	41	23	35	207	2025-05-30 22:00:04.934239	\N
792	The ratio of number of entries to table size	t	41	23	35	207	2025-05-30 22:00:04.934239	\N
793	The hash value of a key	f	41	23	35	207	2025-05-30 22:00:04.934239	\N
794	The table is trimmed	f	41	23	35	208	2025-05-30 22:00:04.934239	\N
795	Hash function is changed	f	41	23	35	208	2025-05-30 22:00:04.934239	\N
796	Rehashing to a larger table occurs	t	41	23	35	208	2025-05-30 22:00:04.934239	\N
797	All keys are sorted	f	41	23	35	208	2025-05-30 22:00:04.934239	\N
798	Chaining	f	41	23	35	209	2025-05-30 22:00:04.934239	\N
799	Linear Probing	t	41	23	35	209	2025-05-30 22:00:04.934239	\N
800	Quadratic Hashing	f	41	23	35	209	2025-05-30 22:00:04.934239	\N
801	Bucket Sorting	f	41	23	35	209	2025-05-30 22:00:04.934239	\N
802	Separate chaining	f	41	23	35	210	2025-05-30 22:00:04.934239	\N
803	Linear probing	t	41	23	35	210	2025-05-30 22:00:04.934239	\N
804	Double hashing	f	41	23	35	210	2025-05-30 22:00:04.934239	\N
805	Good hash function	f	41	23	35	210	2025-05-30 22:00:04.934239	\N
806	O(log n)	f	41	23	35	211	2025-05-30 22:00:04.934239	\N
807	O(n)	t	41	23	35	211	2025-05-30 22:00:04.934239	\N
808	O(1)	f	41	23	35	211	2025-05-30 22:00:04.934239	\N
809	O(n log n)	f	41	23	35	211	2025-05-30 22:00:04.934239	\N
810	One that always returns the same value	f	41	23	35	212	2025-05-30 22:00:04.934239	\N
811	One that produces a uniform distribution	t	41	23	35	212	2025-05-30 22:00:04.934239	\N
812	One that sorts keys	f	41	23	35	212	2025-05-30 22:00:04.934239	\N
813	One that uses a cryptographic algorithm	f	41	23	35	212	2025-05-30 22:00:04.934239	\N
814	Two different hash functions	t	41	23	35	213	2025-05-30 22:00:04.934239	\N
815	Double the array size	f	41	23	35	213	2025-05-30 22:00:04.934239	\N
816	Hashing the key twice	f	41	23	35	213	2025-05-30 22:00:04.934239	\N
817	Sorting the hash table	f	41	23	35	213	2025-05-30 22:00:04.934239	\N
818	New table	f	41	23	35	214	2025-05-30 22:00:04.934239	\N
819	Linked list at the index	t	41	23	35	214	2025-05-30 22:00:04.934239	\N
820	Stack	f	41	23	35	214	2025-05-30 22:00:04.934239	\N
821	Separate memory block	f	41	23	35	214	2025-05-30 22:00:04.934239	\N
822	O(log n)	f	41	23	35	215	2025-05-30 22:00:04.934239	\N
823	O(n)	f	41	23	35	215	2025-05-30 22:00:04.934239	\N
824	O(1)	t	41	23	35	215	2025-05-30 22:00:04.934239	\N
825	O(n log n)	f	41	23	35	215	2025-05-30 22:00:04.934239	\N
826	Empty hash table	f	41	23	35	216	2025-05-30 22:00:04.934239	\N
828	All keys are even	f	41	23	35	216	2025-05-30 22:00:04.934239	\N
829	Too many zero hash values	f	41	23	35	216	2025-05-30 22:00:04.934239	\N
830	Linear probing	f	41	23	35	217	2025-05-30 22:00:04.934239	\N
831	Quadratic probing	t	41	23	35	217	2025-05-30 22:00:04.934239	\N
832	Double hashing	f	41	23	35	217	2025-05-30 22:00:04.934239	\N
833	Chaining	f	41	23	35	217	2025-05-30 22:00:04.934239	\N
834	Requires extra memory for linked lists	f	41	23	35	218	2025-05-30 22:00:04.934239	\N
835	Reduces clustering	f	41	23	35	218	2025-05-30 22:00:04.934239	\N
836	Handles collisions using arrays	t	41	23	35	218	2025-05-30 22:00:04.934239	\N
837	Can degrade to O(n) search	f	41	23	35	218	2025-05-30 22:00:04.934239	\N
838	One that works for all keys	f	41	23	35	219	2025-05-30 22:00:04.934239	\N
839	Randomly chosen from a family of functions	t	41	23	35	219	2025-05-30 22:00:04.934239	\N
840	A function that always avoids collisions	f	41	23	35	219	2025-05-30 22:00:04.934239	\N
841	A hash that stores multiple keys in one index	f	41	23	35	219	2025-05-30 22:00:04.934239	\N
842	Modulo by prime number	f	41	23	35	220	2025-05-30 22:00:04.934239	\N
843	Clustering of hash values	t	41	23	35	220	2025-05-30 22:00:04.934239	\N
844	Large table size	f	41	23	35	220	2025-05-30 22:00:04.934239	\N
845	Randomized function	f	41	23	35	220	2025-05-30 22:00:04.934239	\N
846	SHA-256	f	41	23	35	221	2025-05-30 22:00:04.934239	\N
847	MD5	f	41	23	35	221	2025-05-30 22:00:04.934239	\N
848	`hashCode()` with bit spreading	t	41	23	35	221	2025-05-30 22:00:04.934239	\N
849	CRC-32	f	41	23	35	221	2025-05-30 22:00:04.934239	\N
850	Cannot use arrays	f	41	23	35	222	2025-05-30 22:00:04.934239	\N
851	Uses extra memory	f	41	23	35	222	2025-05-30 22:00:04.934239	\N
852	Hard to delete elements cleanly	t	41	23	35	222	2025-05-30 22:00:04.934239	\N
853	Load factor is irrelevant	f	41	23	35	222	2025-05-30 22:00:04.934239	\N
854	Separate chaining	f	41	23	35	223	2025-05-30 22:00:04.934239	\N
855	Open addressing	t	41	23	35	223	2025-05-30 22:00:04.934239	\N
856	Hybrid hashing	f	41	23	35	223	2025-05-30 22:00:04.934239	\N
857	Tree-based hashing	f	41	23	35	223	2025-05-30 22:00:04.934239	\N
858	Choose data type	f	41	23	35	224	2025-05-30 22:00:04.934239	\N
859	Select table size and hash function	t	41	23	35	224	2025-05-30 22:00:04.934239	\N
860	Build search tree	f	41	23	35	224	2025-05-30 22:00:04.934239	\N
861	Compress keys	f	41	23	35	224	2025-05-30 22:00:04.934239	\N
862	To increase data transfer time	f	41	23	36	225	2025-05-30 22:05:38.89144	\N
863	To reduce file size	t	41	23	36	225	2025-05-30 22:05:38.89144	\N
864	To improve encryption	f	41	23	36	225	2025-05-30 22:05:38.89144	\N
865	To duplicate data	f	41	23	36	225	2025-05-30 22:05:38.89144	\N
866	JPEG	f	41	23	36	226	2025-05-30 22:05:38.89144	\N
867	MP3	f	41	23	36	226	2025-05-30 22:05:38.89144	\N
868	Huffman coding	t	41	23	36	226	2025-05-30 22:05:38.89144	\N
869	MPEG	f	41	23	36	226	2025-05-30 22:05:38.89144	\N
870	Equal-length codes	f	41	23	36	227	2025-05-30 22:05:38.89144	\N
871	Suffix-free codes	f	41	23	36	227	2025-05-30 22:05:38.89144	\N
872	Prefix-free codes	t	41	23	36	227	2025-05-30 22:05:38.89144	\N
873	Numeric codes only	f	41	23	36	227	2025-05-30 22:05:38.89144	\N
874	LZW	f	41	23	36	228	2025-05-30 22:05:38.89144	\N
875	Run-length encoding	f	41	23	36	228	2025-05-30 22:05:38.89144	\N
876	Huffman coding	t	41	23	36	228	2025-05-30 22:05:38.89144	\N
877	Arithmetic coding	f	41	23	36	228	2025-05-30 22:05:38.89144	\N
878	Hash table	f	41	23	36	229	2025-05-30 22:05:38.89144	\N
879	Array	f	41	23	36	229	2025-05-30 22:05:38.89144	\N
880	Min-heap or priority queue	t	41	23	36	229	2025-05-30 22:05:38.89144	\N
881	Stack	f	41	23	36	229	2025-05-30 22:05:38.89144	\N
882	It is removed	f	41	23	36	230	2025-05-30 22:05:38.89144	\N
883	It gets the shortest code	f	41	23	36	230	2025-05-30 22:05:38.89144	\N
884	It is merged earlier	t	41	23	36	230	2025-05-30 22:05:38.89144	\N
885	It is encoded twice	f	41	23	36	230	2025-05-30 22:05:38.89144	\N
886	Energy loss in transmission	f	41	23	36	231	2025-05-30 22:05:38.89144	\N
887	The amount of disorder in a system	f	41	23	36	231	2025-05-30 22:05:38.89144	\N
888	The theoretical limit of compressibility	t	41	23	36	231	2025-05-30 22:05:38.89144	\N
889	The average number of characters	f	41	23	36	231	2025-05-30 22:05:38.89144	\N
890	ABCD	f	41	23	36	232	2025-05-30 22:05:38.89144	\N
891	AABBCC	f	41	23	36	232	2025-05-30 22:05:38.89144	\N
892	AAAAAAA	t	41	23	36	232	2025-05-30 22:05:38.89144	\N
893	ABCABC	f	41	23	36	232	2025-05-30 22:05:38.89144	\N
894	Maximum frequency of symbols	f	41	23	36	233	2025-05-30 22:05:38.89144	\N
895	Entropy of the data	t	41	23	36	233	2025-05-30 22:05:38.89144	\N
896	Binary tree depth	f	41	23	36	233	2025-05-30 22:05:38.89144	\N
897	Size of the input	f	41	23	36	233	2025-05-30 22:05:38.89144	\N
898	Optimal among all prefix codes	f	41	23	36	234	2025-05-30 22:05:38.89144	\N
899	Variable-length	f	41	23	36	234	2025-05-30 22:05:38.89144	\N
900	Fixed-length	t	41	23	36	234	2025-05-30 22:05:38.89144	\N
901	Greedy construction	f	41	23	36	234	2025-05-30 22:05:38.89144	\N
902	Works only on numbers	f	41	23	36	235	2025-05-30 22:05:38.89144	\N
903	Doesn’t adapt to changing input	t	41	23	36	235	2025-05-30 22:05:38.89144	\N
904	Needs floating point math	f	41	23	36	235	2025-05-30 22:05:38.89144	\N
905	Requires sorting	f	41	23	36	235	2025-05-30 22:05:38.89144	\N
906	At most 2	f	41	23	36	236	2025-05-30 22:05:38.89144	\N
907	One	t	41	23	36	236	2025-05-30 22:05:38.89144	\N
908	Depends on frequency	f	41	23	36	236	2025-05-30 22:05:38.89144	\N
909	One for leaf and one for internal node	f	41	23	36	236	2025-05-30 22:05:38.89144	\N
910	Huffman coding	f	41	23	36	237	2025-05-30 22:05:38.89144	\N
911	Run-length encoding	f	41	23	36	237	2025-05-30 22:05:38.89144	\N
912	LZW	t	41	23	36	237	2025-05-30 22:05:38.89144	\N
913	Shannon-Fano coding	f	41	23	36	237	2025-05-30 22:05:38.89144	\N
914	They are ignored	f	41	23	36	238	2025-05-30 22:05:38.89144	\N
915	They are sorted by character value	f	41	23	36	238	2025-05-30 22:05:38.89144	\N
916	They can be joined in any order	t	41	23	36	238	2025-05-30 22:05:38.89144	\N
917	The algorithm stops	f	41	23	36	238	2025-05-30 22:05:38.89144	\N
918	Run-length encoding	f	41	23	36	239	2025-05-30 22:05:38.89144	\N
919	Fixed-length binary coding	f	41	23	36	239	2025-05-30 22:05:38.89144	\N
920	Arithmetic coding	t	41	23	36	239	2025-05-30 22:05:38.89144	\N
921	Binary search coding	f	41	23	36	239	2025-05-30 22:05:38.89144	\N
922	Cannot be used with binary data	f	41	23	36	240	2025-05-30 22:05:38.89144	\N
923	Inefficient for random data	t	41	23	36	240	2025-05-30 22:05:38.89144	\N
924	Too slow	f	41	23	36	240	2025-05-30 22:05:38.89144	\N
925	Lossy	f	41	23	36	240	2025-05-30 22:05:38.89144	\N
926	Use smaller alphabet	f	41	23	36	241	2025-05-30 22:05:38.89144	\N
927	Exploit symbol frequency	t	41	23	36	241	2025-05-30 22:05:38.89144	\N
928	Avoid prefix codes	f	41	23	36	241	2025-05-30 22:05:38.89144	\N
929	Use fixed-length codes	f	41	23	36	241	2025-05-30 22:05:38.89144	\N
930	PNG	t	41	23	36	242	2025-05-30 22:05:38.89144	\N
931	MP4	f	41	23	36	242	2025-05-30 22:05:38.89144	\N
932	WAV	f	41	23	36	242	2025-05-30 22:05:38.89144	\N
933	TXT	f	41	23	36	242	2025-05-30 22:05:38.89144	\N
934	Always the same	f	41	23	36	243	2025-05-30 22:05:38.89144	\N
935	Largest	f	41	23	36	243	2025-05-30 22:05:38.89144	\N
936	Smallest	t	41	23	36	243	2025-05-30 22:05:38.89144	\N
937	Depends on tree shape only	f	41	23	36	243	2025-05-30 22:05:38.89144	\N
938	Reordering symbols by frequency	t	41	23	36	244	2025-05-30 22:05:38.89144	\N
939	Switching to a larger alphabet	f	41	23	36	244	2025-05-30 22:05:38.89144	\N
940	Reducing input length	f	41	23	36	244	2025-05-30 22:05:38.89144	\N
941	Using fixed-length codes	f	41	23	36	244	2025-05-30 22:05:38.89144	\N
942	It solves subproblems recursively	f	41	23	37	245	2025-05-30 22:06:48.483891	\N
943	It considers all possible solutions	f	41	23	37	245	2025-05-30 22:06:48.483891	\N
944	It builds up a solution piece by piece choosing the local optimum	t	41	23	37	245	2025-05-30 22:06:48.483891	\N
945	It backtracks when needed	f	41	23	37	245	2025-05-30 22:06:48.483891	\N
946	0/1 Knapsack	f	41	23	37	246	2025-05-30 22:06:48.483891	\N
947	Fractional Knapsack	t	41	23	37	246	2025-05-30 22:06:48.483891	\N
948	Subset Sum	f	41	23	37	246	2025-05-30 22:06:48.483891	\N
949	Travelling Salesman Problem	f	41	23	37	246	2025-05-30 22:06:48.483891	\N
950	Because it allows sorting by value	f	41	23	37	247	2025-05-30 22:06:48.483891	\N
951	Because we can take fractions and pick the most valuable items first	t	41	23	37	247	2025-05-30 22:06:48.483891	\N
952	Because greedy always works	f	41	23	37	247	2025-05-30 22:06:48.483891	\N
953	Because it's based on brute-force	f	41	23	37	247	2025-05-30 22:06:48.483891	\N
954	Matrix multiplication	f	41	23	37	248	2025-05-30 22:06:48.483891	\N
955	Huffman coding	t	41	23	37	248	2025-05-30 22:06:48.483891	\N
956	Depth-first search	f	41	23	37	248	2025-05-30 22:06:48.483891	\N
957	Minimum spanning tree	t	41	23	37	248	2025-05-30 22:06:48.483891	\N
958	Dijkstra's Algorithm	f	41	23	37	249	2025-05-30 22:06:48.483891	\N
959	Prim's or Kruskal's Algorithm	t	41	23	37	249	2025-05-30 22:06:48.483891	\N
960	Bellman-Ford	f	41	23	37	249	2025-05-30 22:06:48.483891	\N
961	Floyd-Warshall	f	41	23	37	249	2025-05-30 22:06:48.483891	\N
962	By start time	f	41	23	37	250	2025-05-30 22:06:48.483891	\N
963	By duration	f	41	23	37	250	2025-05-30 22:06:48.483891	\N
964	By finish time	t	41	23	37	250	2025-05-30 22:06:48.483891	\N
965	By profit	f	41	23	37	250	2025-05-30 22:06:48.483891	\N
966	Backtracking property	f	41	23	37	251	2025-05-30 22:06:48.483891	\N
967	Optimal substructure and greedy-choice property	t	41	23	37	251	2025-05-30 22:06:48.483891	\N
968	Exponential search space	f	41	23	37	251	2025-05-30 22:06:48.483891	\N
969	Divide-and-conquer	f	41	23	37	251	2025-05-30 22:06:48.483891	\N
970	Huffman coding	f	41	23	37	252	2025-05-30 22:06:48.483891	\N
971	Prim’s algorithm	f	41	23	37	252	2025-05-30 22:06:48.483891	\N
972	Dijkstra’s algorithm	f	41	23	37	252	2025-05-30 22:06:48.483891	\N
973	Merge sort	t	41	23	37	252	2025-05-30 22:06:48.483891	\N
974	It can be changed later	f	41	23	37	253	2025-05-30 22:06:48.483891	\N
975	It is final and cannot be revisited	t	41	23	37	253	2025-05-30 22:06:48.483891	\N
976	It requires recursive validation	f	41	23	37	253	2025-05-30 22:06:48.483891	\N
977	It depends on backtracking	f	41	23	37	253	2025-05-30 22:06:48.483891	\N
978	Dijkstra’s Algorithm	t	41	23	37	254	2025-05-30 22:06:48.483891	\N
979	Merge Sort	f	41	23	37	254	2025-05-30 22:06:48.483891	\N
980	Bellman-Ford	f	41	23	37	254	2025-05-30 22:06:48.483891	\N
981	DFS	f	41	23	37	254	2025-05-30 22:06:48.483891	\N
982	When the problem has a brute-force solution	f	41	23	37	255	2025-05-30 22:06:48.483891	\N
983	When the problem has optimal substructure and greedy-choice property	t	41	23	37	255	2025-05-30 22:06:48.483891	\N
984	When recursion is used	f	41	23	37	255	2025-05-30 22:06:48.483891	\N
985	When the input size is small	f	41	23	37	255	2025-05-30 22:06:48.483891	\N
986	Greedy solves problems bottom-up	f	41	23	37	256	2025-05-30 22:06:48.483891	\N
987	Greedy uses recursion, dynamic programming doesn't	f	41	23	37	256	2025-05-30 22:06:48.483891	\N
988	Greedy makes local decisions; DP considers all subproblems	t	41	23	37	256	2025-05-30 22:06:48.483891	\N
989	Dynamic programming is faster	f	41	23	37	256	2025-05-30 22:06:48.483891	\N
990	Item values are all equal	f	41	23	37	257	2025-05-30 22:06:48.483891	\N
991	Fractions are not allowed	t	41	23	37	257	2025-05-30 22:06:48.483891	\N
992	Items are sorted by weight	f	41	23	37	257	2025-05-30 22:06:48.483891	\N
993	Items have the same ratio	f	41	23	37	257	2025-05-30 22:06:48.483891	\N
994	Combining least frequent nodes repeatedly	t	41	23	37	258	2025-05-30 22:06:48.483891	\N
995	Merging maximum nodes	f	41	23	37	258	2025-05-30 22:06:48.483891	\N
996	Greedy on max heap	f	41	23	37	258	2025-05-30 22:06:48.483891	\N
997	Assigning equal bits	f	41	23	37	258	2025-05-30 22:06:48.483891	\N
998	O(n)	f	41	23	37	259	2025-05-30 22:06:48.483891	\N
999	O(n log n)	t	41	23	37	259	2025-05-30 22:06:48.483891	\N
1000	O(n^2)	f	41	23	37	259	2025-05-30 22:06:48.483891	\N
1001	O(log n)	f	41	23	37	259	2025-05-30 22:06:48.483891	\N
1002	The activity with the shortest duration	f	41	23	37	260	2025-05-30 22:06:48.483891	\N
1003	The activity with the earliest start time	f	41	23	37	260	2025-05-30 22:06:48.483891	\N
1004	The activity that finishes earliest	t	41	23	37	260	2025-05-30 22:06:48.483891	\N
1005	The activity with maximum idle time	f	41	23	37	260	2025-05-30 22:06:48.483891	\N
1006	Correctness for all problems	f	41	23	37	261	2025-05-30 22:06:48.483891	\N
1007	Optimal solutions in all cases	f	41	23	37	261	2025-05-30 22:06:48.483891	\N
1008	Efficient but not always optimal solutions	t	41	23	37	261	2025-05-30 22:06:48.483891	\N
1009	Worst-case time complexity	f	41	23	37	261	2025-05-30 22:06:48.483891	\N
1010	Interval scheduling	f	41	23	37	262	2025-05-30 22:06:48.483891	\N
1011	Fractional knapsack	f	41	23	37	262	2025-05-30 22:06:48.483891	\N
1012	0/1 knapsack	t	41	23	37	262	2025-05-30 22:06:48.483891	\N
1013	Prim’s algorithm	f	41	23	37	262	2025-05-30 22:06:48.483891	\N
1014	Making change with coins	t	41	23	37	263	2025-05-30 22:06:48.483891	\N
1015	Sorting a list	f	41	23	37	263	2025-05-30 22:06:48.483891	\N
1016	Calculating factorial	f	41	23	37	263	2025-05-30 22:06:48.483891	\N
1017	Evaluating expressions	f	41	23	37	263	2025-05-30 22:06:48.483891	\N
1018	They are recursive	t	41	23	37	264	2025-05-30 22:06:48.483891	\N
1019	They work in stages	f	41	23	37	264	2025-05-30 22:06:48.483891	\N
1020	They make locally optimal choices	f	41	23	37	264	2025-05-30 22:06:48.483891	\N
1021	They are used in scheduling	f	41	23	37	264	2025-05-30 22:06:48.483891	\N
1022	They can be solved using recursion only	f	41	23	38	265	2025-05-30 22:09:57.84616	\N
1023	They require brute force enumeration	f	41	23	38	265	2025-05-30 22:09:57.84616	\N
1024	They have overlapping subproblems and optimal substructure	t	41	23	38	265	2025-05-30 22:09:57.84616	\N
1025	They must be greedy in nature	f	41	23	38	265	2025-05-30 22:09:57.84616	\N
1026	Greedy	f	41	23	38	266	2025-05-30 22:09:57.84616	\N
1027	Divide and Conquer	f	41	23	38	266	2025-05-30 22:09:57.84616	\N
1028	Memoization	t	41	23	38	266	2025-05-30 22:09:57.84616	\N
1029	Branch and Bound	f	41	23	38	266	2025-05-30 22:09:57.84616	\N
1030	O(n)	t	41	23	38	267	2025-05-30 22:09:57.84616	\N
1031	O(2^n)	f	41	23	38	267	2025-05-30 22:09:57.84616	\N
1032	O(n^2)	f	41	23	38	267	2025-05-30 22:09:57.84616	\N
1033	O(log n)	f	41	23	38	267	2025-05-30 22:09:57.84616	\N
1034	Recursion with caching	f	41	23	38	268	2025-05-30 22:09:57.84616	\N
1035	Top-down recursion	f	41	23	38	268	2025-05-30 22:09:57.84616	\N
1036	Tabulation	t	41	23	38	268	2025-05-30 22:09:57.84616	\N
1037	Backtracking	f	41	23	38	268	2025-05-30 22:09:57.84616	\N
1038	Storing precomputed values in a table	t	41	23	38	269	2025-05-30 22:09:57.84616	\N
1039	Dividing the problem into halves	f	41	23	38	269	2025-05-30 22:09:57.84616	\N
1040	Sorting input before processing	f	41	23	38	269	2025-05-30 22:09:57.84616	\N
1041	Executing only greedy steps	f	41	23	38	269	2025-05-30 22:09:57.84616	\N
1042	Matrix multiplication	f	41	23	38	270	2025-05-30 22:09:57.84616	\N
1043	Fractional knapsack	f	41	23	38	270	2025-05-30 22:09:57.84616	\N
1044	0/1 Knapsack	t	41	23	38	270	2025-05-30 22:09:57.84616	\N
1045	Huffman coding	f	41	23	38	270	2025-05-30 22:09:57.84616	\N
1046	Can be taken partially	f	41	23	38	271	2025-05-30 22:09:57.84616	\N
1047	Can only be taken fully or not at all	t	41	23	38	271	2025-05-30 22:09:57.84616	\N
1048	Is divisible	f	41	23	38	271	2025-05-30 22:09:57.84616	\N
1049	Must be excluded	f	41	23	38	271	2025-05-30 22:09:57.84616	\N
1050	Recursion	f	41	23	38	272	2025-05-30 22:09:57.84616	\N
1051	Memoization	f	41	23	38	272	2025-05-30 22:09:57.84616	\N
1052	Tabulation	t	41	23	38	272	2025-05-30 22:09:57.84616	\N
1053	Greedy recursion	f	41	23	38	272	2025-05-30 22:09:57.84616	\N
1054	Finding prime numbers	f	41	23	38	273	2025-05-30 22:09:57.84616	\N
1055	Binary search	f	41	23	38	273	2025-05-30 22:09:57.84616	\N
1056	Matrix Chain Multiplication	t	41	23	38	273	2025-05-30 22:09:57.84616	\N
1057	DFS traversal	f	41	23	38	273	2025-05-30 22:09:57.84616	\N
1058	Fibonacci	f	41	23	38	274	2025-05-30 22:09:57.84616	\N
1059	0/1 Knapsack	f	41	23	38	274	2025-05-30 22:09:57.84616	\N
1060	Shortest path in DAG	f	41	23	38	274	2025-05-30 22:09:57.84616	\N
1061	Fractional Knapsack	t	41	23	38	274	2025-05-30 22:09:57.84616	\N
1062	Number of items × total weight capacity	t	41	23	38	275	2025-05-30 22:09:57.84616	\N
1063	Total value × weight	f	41	23	38	275	2025-05-30 22:09:57.84616	\N
1064	Item value × item index	f	41	23	38	275	2025-05-30 22:09:57.84616	\N
1065	Number of weights × total items	f	41	23	38	275	2025-05-30 22:09:57.84616	\N
1066	Top-down computes solutions recursively; bottom-up iteratively fills a table	t	41	23	38	276	2025-05-30 22:09:57.84616	\N
1067	Top-down always faster	f	41	23	38	276	2025-05-30 22:09:57.84616	\N
1068	Bottom-up uses backtracking	f	41	23	38	276	2025-05-30 22:09:57.84616	\N
1069	Memoization recomputes all subproblems	f	41	23	38	276	2025-05-30 22:09:57.84616	\N
1070	The minimum weights	f	41	23	38	277	2025-05-30 22:09:57.84616	\N
1071	The index of best item	f	41	23	38	277	2025-05-30 22:09:57.84616	\N
1072	The maximum value achievable for a given weight limit	t	41	23	38	277	2025-05-30 22:09:57.84616	\N
1073	Number of possible subsets	f	41	23	38	277	2025-05-30 22:09:57.84616	\N
1074	The problem has no optimal substructure	f	41	23	38	278	2025-05-30 22:09:57.84616	\N
1075	Subproblems do not overlap	f	41	23	38	278	2025-05-30 22:09:57.84616	\N
1076	Subproblems overlap and their results are reused	t	41	23	38	278	2025-05-30 22:09:57.84616	\N
1077	Greedy solutions exist	f	41	23	38	278	2025-05-30 22:09:57.84616	\N
1078	Greedy-choice property	t	41	23	38	279	2025-05-30 22:09:57.84616	\N
1079	Optimal substructure	f	41	23	38	279	2025-05-30 22:09:57.84616	\N
1080	Overlapping subproblems	f	41	23	38	279	2025-05-30 22:09:57.84616	\N
1081	Storing intermediate solutions	f	41	23	38	279	2025-05-30 22:09:57.84616	\N
1082	It is skipped	f	41	23	38	280	2025-05-30 22:09:57.84616	\N
1083	It is computed and then stored	t	41	23	38	280	2025-05-30 22:09:57.84616	\N
1084	It causes an error	f	41	23	38	280	2025-05-30 22:09:57.84616	\N
1085	The algorithm terminates	f	41	23	38	280	2025-05-30 22:09:57.84616	\N
1086	Computing Fibonacci using naive recursion	t	41	23	38	281	2025-05-30 22:09:57.84616	\N
1087	Binary search	f	41	23	38	281	2025-05-30 22:09:57.84616	\N
1088	Quick sort	f	41	23	38	281	2025-05-30 22:09:57.84616	\N
1089	DFS traversal	f	41	23	38	281	2025-05-30 22:09:57.84616	\N
1090	Heap	f	41	23	38	282	2025-05-30 22:09:57.84616	\N
1091	Stack	f	41	23	38	282	2025-05-30 22:09:57.84616	\N
1092	Table/array	t	41	23	38	282	2025-05-30 22:09:57.84616	\N
1093	Queue	f	41	23	38	282	2025-05-30 22:09:57.84616	\N
1094	fib(1) = 2	f	41	23	38	283	2025-05-30 22:09:57.84616	\N
1095	fib(0) = 0, fib(1) = 1	t	41	23	38	283	2025-05-30 22:09:57.84616	\N
1096	fib(n) = n	f	41	23	38	283	2025-05-30 22:09:57.84616	\N
1097	fib(n-1) + fib(n-2)	f	41	23	38	283	2025-05-30 22:09:57.84616	\N
1098	Memoization	t	41	23	38	284	2025-05-30 22:09:57.84616	\N
1099	Tabulation	f	41	23	38	284	2025-05-30 22:09:57.84616	\N
1100	Both same	f	41	23	38	284	2025-05-30 22:09:57.84616	\N
1101	Depends on language	f	41	23	38	284	2025-05-30 22:09:57.84616	\N
1102	True	t	41	8	39	285	2025-05-31 23:55:40.209674	\N
1103	False	f	41	8	39	285	2025-05-31 23:55:40.209674	\N
1104	True	t	41	8	39	286	2025-05-31 23:55:40.209674	\N
1105	False	f	41	8	39	286	2025-05-31 23:55:40.209674	\N
1106	True	f	41	8	39	287	2025-05-31 23:55:40.209674	\N
1107	False	t	41	8	39	287	2025-05-31 23:55:40.209674	\N
1108	True	t	41	8	39	288	2025-05-31 23:55:40.209674	\N
1109	False	f	41	8	39	288	2025-05-31 23:55:40.209674	\N
1110	True	f	41	8	39	289	2025-05-31 23:55:40.209674	\N
1111	False	t	41	8	39	289	2025-05-31 23:55:40.209674	\N
1112	True	t	41	8	39	290	2025-05-31 23:55:40.209674	\N
1113	False	f	41	8	39	290	2025-05-31 23:55:40.209674	\N
1114	True	f	41	8	39	291	2025-05-31 23:55:40.209674	\N
1115	False	t	41	8	39	291	2025-05-31 23:55:40.209674	\N
1116	True	t	41	8	39	292	2025-05-31 23:55:40.209674	\N
1117	False	f	41	8	39	292	2025-05-31 23:55:40.209674	\N
1118	True	f	41	8	39	293	2025-05-31 23:55:40.209674	\N
1119	False	t	41	8	39	293	2025-05-31 23:55:40.209674	\N
1120	True	t	41	8	39	294	2025-05-31 23:55:40.209674	\N
1121	False	f	41	8	39	294	2025-05-31 23:55:40.209674	\N
1122	True	f	41	8	39	295	2025-05-31 23:55:40.209674	\N
1123	False	t	41	8	39	295	2025-05-31 23:55:40.209674	\N
1124	True	t	41	8	39	296	2025-05-31 23:55:40.209674	\N
1125	False	f	41	8	39	296	2025-05-31 23:55:40.209674	\N
1126	True	f	41	8	39	297	2025-05-31 23:55:40.209674	\N
1127	False	t	41	8	39	297	2025-05-31 23:55:40.209674	\N
1128	True	t	41	8	39	298	2025-05-31 23:55:40.209674	\N
1129	False	f	41	8	39	298	2025-05-31 23:55:40.209674	\N
1130	True	t	41	8	39	299	2025-05-31 23:55:40.209674	\N
1131	False	f	41	8	39	299	2025-05-31 23:55:40.209674	\N
1132	True	t	41	8	39	300	2025-05-31 23:55:40.209674	\N
1133	False	f	41	8	39	300	2025-05-31 23:55:40.209674	\N
1134	True	f	41	8	39	301	2025-05-31 23:55:40.209674	\N
1135	False	t	41	8	39	301	2025-05-31 23:55:40.209674	\N
1136	True	t	41	8	39	302	2025-05-31 23:55:40.209674	\N
1137	False	f	41	8	39	302	2025-05-31 23:55:40.209674	\N
1138	True	t	41	8	39	303	2025-05-31 23:55:40.209674	\N
1139	False	f	41	8	39	303	2025-05-31 23:55:40.209674	\N
1140	True	f	41	8	39	304	2025-05-31 23:55:40.209674	\N
1141	False	t	41	8	39	304	2025-05-31 23:55:40.209674	\N
1142	True	t	41	8	41	315	2025-06-01 01:01:41.125212	\N
1143	False	f	41	8	41	315	2025-06-01 01:01:41.125212	\N
1144	True	t	41	8	41	316	2025-06-01 01:01:41.125212	\N
1145	False	f	41	8	41	316	2025-06-01 01:01:41.125212	\N
1146	True	f	41	8	41	317	2025-06-01 01:01:41.125212	\N
1147	False	t	41	8	41	317	2025-06-01 01:01:41.125212	\N
1148	True	t	41	8	41	318	2025-06-01 01:01:41.125212	\N
1149	False	f	41	8	41	318	2025-06-01 01:01:41.125212	\N
1150	True	f	41	8	41	319	2025-06-01 01:01:41.125212	\N
1151	False	t	41	8	41	319	2025-06-01 01:01:41.125212	\N
1152	True	t	41	8	41	320	2025-06-01 01:01:41.125212	\N
1153	False	f	41	8	41	320	2025-06-01 01:01:41.125212	\N
1154	True	t	41	8	41	321	2025-06-01 01:01:41.125212	\N
1155	False	f	41	8	41	321	2025-06-01 01:01:41.125212	\N
1156	True	t	41	8	41	322	2025-06-01 01:01:41.125212	\N
1157	False	f	41	8	41	322	2025-06-01 01:01:41.125212	\N
1158	True	f	41	8	41	323	2025-06-01 01:01:41.125212	\N
1159	False	t	41	8	41	323	2025-06-01 01:01:41.125212	\N
1160	True	t	41	8	41	324	2025-06-01 01:01:41.125212	\N
1161	False	f	41	8	41	324	2025-06-01 01:01:41.125212	\N
1218	Stable LOW	f	41	8	59	354	2025-06-10 22:59:33.300559	\N
1219	Stable HIGH	f	41	8	59	354	2025-06-10 22:59:33.300559	\N
1220	Unpredictable / noisy	t	41	8	59	354	2025-06-10 22:59:33.300559	\N
1221	Always HIGH	f	41	8	59	354	2025-06-10 22:59:33.300559	\N
1222	Forces pin LOW	f	41	8	59	355	2025-06-10 22:59:33.300559	\N
1223	Connects GPIO weakly to 3.3V	t	41	8	59	355	2025-06-10 22:59:33.300559	\N
1224	Converts GPIO to analog mode	f	41	8	59	355	2025-06-10 22:59:33.300559	\N
1225	Increases GPIO current drive	f	41	8	59	355	2025-06-10 22:59:33.300559	\N
1226	0	f	41	8	59	356	2025-06-10 22:59:33.300559	\N
1227	1	t	41	8	59	356	2025-06-10 22:59:33.300559	\N
1228	Floating	f	41	8	59	356	2025-06-10 22:59:33.300559	\N
1229	Undefined	f	41	8	59	356	2025-06-10 22:59:33.300559	\N
1230	0 → 1	f	41	8	59	357	2025-06-10 22:59:33.300559	\N
1231	1 → 0	t	41	8	59	357	2025-06-10 22:59:33.300559	\N
1232	1 → 1	f	41	8	59	357	2025-06-10 22:59:33.300559	\N
1233	0 → 0	f	41	8	59	357	2025-06-10 22:59:33.300559	\N
1234	To save power	f	41	8	59	358	2025-06-10 22:59:33.300559	\N
1235	To prevent button sticking	f	41	8	59	358	2025-06-10 22:59:33.300559	\N
1236	Because buttons bounce and generate multiple signals per press	t	41	8	59	358	2025-06-10 22:59:33.300559	\N
1237	To make the button press quieter	f	41	8	59	358	2025-06-10 22:59:33.300559	\N
1238	ledState = ledState + 1;	f	41	8	59	359	2025-06-10 22:59:33.300559	\N
1239	ledState = 0;	f	41	8	59	359	2025-06-10 22:59:33.300559	\N
1240	ledState = !ledState;	t	41	8	59	359	2025-06-10 22:59:33.300559	\N
1241	ledState = ledState * 2;	f	41	8	59	359	2025-06-10 22:59:33.300559	\N
1242	To create infinite loop	f	41	8	59	360	2025-06-10 22:59:33.300559	\N
1243	To save battery power and avoid busy loop	t	41	8	59	360	2025-06-10 22:59:33.300559	\N
1244	To delay GPIO state update	f	41	8	59	360	2025-06-10 22:59:33.300559	\N
1245	To make code run faster	f	41	8	59	360	2025-06-10 22:59:33.300559	\N
1246	The voltage in volts	f	41	8	59	361	2025-06-10 22:59:33.300559	\N
1247	The number of button presses	f	41	8	59	361	2025-06-10 22:59:33.300559	\N
1248	Current GPIO logic level (0 or 1)	t	41	8	59	361	2025-06-10 22:59:33.300559	\N
1249	The configured pin direction	f	41	8	59	361	2025-06-10 22:59:33.300559	\N
1250	It prevents button damage	f	41	8	59	362	2025-06-10 22:59:33.300559	\N
1251	It makes the relay faster	f	41	8	59	362	2025-06-10 22:59:33.300559	\N
1252	It allows detecting button press events by comparing with current state	t	41	8	59	362	2025-06-10 22:59:33.300559	\N
1253	It eliminates the need for pull-up	f	41	8	59	362	2025-06-10 22:59:33.300559	\N
1254	GPIO_MODE_OUTPUT	f	41	8	59	363	2025-06-10 22:59:33.300559	\N
1255	GPIO_MODE_ANALOG	f	41	8	59	363	2025-06-10 22:59:33.300559	\N
1256	GPIO_MODE_INPUT	t	41	8	59	363	2025-06-10 22:59:33.300559	\N
1257	GPIO_MODE_PWM	f	41	8	59	363	2025-06-10 22:59:33.300559	\N
1262	A. A file that stores text-based instructions	f	41	6	76	367	2025-06-21 12:57:50.099204	\N
1263	B. A source code file for the C compiler	f	41	6	76	367	2025-06-21 12:57:50.099204	\N
1264	C. A file containing machine code instructions for the CPU	t	41	6	76	367	2025-06-21 12:57:50.099204	\N
1265	D. A shell script	f	41	6	76	367	2025-06-21 12:57:50.099204	\N
1266	A. EXE	f	41	6	76	368	2025-06-21 12:57:50.099204	\N
1267	B. ELF	t	41	6	76	368	2025-06-21 12:57:50.099204	\N
1268	C. BIN	f	41	6	76	368	2025-06-21 12:57:50.099204	\N
1269	D. COFF	f	41	6	76	368	2025-06-21 12:57:50.099204	\N
1270	A. ld	f	41	6	76	369	2025-06-21 12:57:50.099204	\N
1271	B. gcc	f	41	6	76	369	2025-06-21 12:57:50.099204	\N
1272	C. as	t	41	6	76	369	2025-06-21 12:57:50.099204	\N
1273	D. objcopy	f	41	6	76	369	2025-06-21 12:57:50.099204	\N
1274	A. Debug the code	f	41	6	76	370	2025-06-21 12:57:50.099204	\N
1275	B. Link object files into an executable	t	41	6	76	370	2025-06-21 12:57:50.099204	\N
1276	C. Assemble source files	f	41	6	76	370	2025-06-21 12:57:50.099204	\N
1277	D. Preprocess headers	f	41	6	76	370	2025-06-21 12:57:50.099204	\N
1278	A. Global variables	f	41	6	76	371	2025-06-21 12:57:50.099204	\N
1279	B. String literals	f	41	6	76	371	2025-06-21 12:57:50.099204	\N
1280	C. Executable code	t	41	6	76	371	2025-06-21 12:57:50.099204	\N
1281	D. Debug info	f	41	6	76	371	2025-06-21 12:57:50.099204	\N
1282	A. The final executable file	f	41	6	76	372	2025-06-21 12:57:50.099204	\N
1283	B. A header file	f	41	6	76	372	2025-06-21 12:57:50.099204	\N
1284	C. Machine code from one source file, not yet linked	t	41	6	76	372	2025-06-21 12:57:50.099204	\N
1285	D. A symbolic debug file	f	41	6	76	372	2025-06-21 12:57:50.099204	\N
1286	A. Makes a label local	f	41	6	76	373	2025-06-21 12:57:50.099204	\N
1287	B. Prevents compilation	f	41	6	76	373	2025-06-21 12:57:50.099204	\N
1288	C. Makes a label visible to the linker	t	41	6	76	373	2025-06-21 12:57:50.099204	\N
1289	D. Adds documentation	f	41	6	76	373	2025-06-21 12:57:50.099204	\N
1290	A. Converts source to machine code	f	41	6	76	374	2025-06-21 12:57:50.099204	\N
1291	B. Optimizes memory	f	41	6	76	374	2025-06-21 12:57:50.099204	\N
1292	C. Combines object files and resolves references	t	41	6	76	374	2025-06-21 12:57:50.099204	\N
1293	D. Prepares text section	f	41	6	76	374	2025-06-21 12:57:50.099204	\N
1294	A. Avoids linking	f	41	6	76	375	2025-06-21 12:57:50.099204	\N
1295	B. Removes compiler dependency	f	41	6	76	375	2025-06-21 12:57:50.099204	\N
1296	C. Enables incremental compilation	t	41	6	76	375	2025-06-21 12:57:50.099204	\N
1297	D. Stores command-line arguments	f	41	6	76	375	2025-06-21 12:57:50.099204	\N
1298	A. Label is hidden	f	41	6	76	376	2025-06-21 12:57:50.099204	\N
1299	B. Internal static function	f	41	6	76	376	2025-06-21 12:57:50.099204	\N
1300	C. Label is defined in another file	t	41	6	76	376	2025-06-21 12:57:50.099204	\N
1301	D. Memory location is fixed	f	41	6	76	376	2025-06-21 12:57:50.099204	\N
1302	A. Code portability	f	41	6	76	377	2025-06-21 12:57:50.099204	\N
1303	B. Memory efficiency	f	41	6	76	377	2025-06-21 12:57:50.099204	\N
1304	C. Reduced errors and faster builds	t	41	6	76	377	2025-06-21 12:57:50.099204	\N
1305	D. Larger executables	f	41	6	76	377	2025-06-21 12:57:50.099204	\N
1306	A. gcc	f	41	6	76	378	2025-06-21 12:57:50.099204	\N
1307	B. make	t	41	6	76	378	2025-06-21 12:57:50.099204	\N
1308	C. objdump	f	41	6	76	378	2025-06-21 12:57:50.099204	\N
1309	D. strip	f	41	6	76	378	2025-06-21 12:57:50.099204	\N
1310	A. 0x00400000	f	41	6	76	379	2025-06-21 12:57:50.099204	\N
1311	B. 0x10000000	f	41	6	76	379	2025-06-21 12:57:50.099204	\N
1312	C. 0x10010000	t	41	6	76	379	2025-06-21 12:57:50.099204	\N
1313	D. 0xFFFF0000	f	41	6	76	379	2025-06-21 12:57:50.099204	\N
1314	A. ELF	f	41	6	76	380	2025-06-21 12:57:50.099204	\N
1315	B. BIN	f	41	6	76	380	2025-06-21 12:57:50.099204	\N
1316	C. HEX	t	41	6	76	380	2025-06-21 12:57:50.099204	\N
1317	D. SREC	f	41	6	76	380	2025-06-21 12:57:50.099204	\N
1318	A. Linking	t	41	6	76	381	2025-06-21 12:57:50.099204	\N
1319	B. Debugging	f	41	6	76	381	2025-06-21 12:57:50.099204	\N
1320	C. Assembling	f	41	6	76	381	2025-06-21 12:57:50.099204	\N
1321	D. Preprocessing	f	41	6	76	381	2025-06-21 12:57:50.099204	\N
1322	A. Dereferences a pointer	f	41	6	77	382	2025-06-21 13:08:50.156674	\N
1323	B. Returns the address of a variable	t	41	6	77	382	2025-06-21 13:08:50.156674	\N
1324	C. Allocates memory	f	41	6	77	382	2025-06-21 13:08:50.156674	\N
1325	D. Copies values into memory	f	41	6	77	382	2025-06-21 13:08:50.156674	\N
1326	A. Memory address of `a`	f	41	6	77	383	2025-06-21 13:08:50.156674	\N
1327	B. Value 0	f	41	6	77	383	2025-06-21 13:08:50.156674	\N
1328	C. Value 5	t	41	6	77	383	2025-06-21 13:08:50.156674	\N
1329	D. Compilation error	f	41	6	77	383	2025-06-21 13:08:50.156674	\N
1330	A. 15	f	41	6	77	384	2025-06-21 13:08:50.156674	\N
1331	B. 20	t	41	6	77	384	2025-06-21 13:08:50.156674	\N
1332	C. 25	f	41	6	77	384	2025-06-21 13:08:50.156674	\N
1333	D. 30	f	41	6	77	384	2025-06-21 13:08:50.156674	\N
1334	A. Register access	f	41	6	77	385	2025-06-21 13:08:50.156674	\N
1335	B. Code optimization assumptions	t	41	6	77	385	2025-06-21 13:08:50.156674	\N
1336	C. Memory leaks	f	41	6	77	385	2025-06-21 13:08:50.156674	\N
1337	D. Register swapping	f	41	6	77	385	2025-06-21 13:08:50.156674	\N
1338	A. They can only be used with structs	f	41	6	77	386	2025-06-21 13:08:50.156674	\N
1339	B. Their values change without CPU instructions	t	41	6	77	386	2025-06-21 13:08:50.156674	\N
1340	C. They cause segmentation faults otherwise	f	41	6	77	386	2025-06-21 13:08:50.156674	\N
1341	D. They hold floating point values	f	41	6	77	386	2025-06-21 13:08:50.156674	\N
1342	A. Nothing	f	41	6	77	387	2025-06-21 13:08:50.156674	\N
1343	B. Smooth data flow	f	41	6	77	387	2025-06-21 13:08:50.156674	\N
1344	C. Short circuit risk	t	41	6	77	387	2025-06-21 13:08:50.156674	\N
1345	D. Boosted voltage	f	41	6	77	387	2025-06-21 13:08:50.156674	\N
1346	A. Makes a label local	f	41	6	77	388	2025-06-21 13:08:50.156674	\N
1347	B. Prevents compilation	f	41	6	77	388	2025-06-21 13:08:50.156674	\N
1348	C. Makes a label visible to the linker	t	41	6	77	388	2025-06-21 13:08:50.156674	\N
1349	D. Adds a function comment	f	41	6	77	388	2025-06-21 13:08:50.156674	\N
1350	A. Ends a program	f	41	6	77	389	2025-06-21 13:08:50.156674	\N
1351	B. Jumps to memory address 0	f	41	6	77	389	2025-06-21 13:08:50.156674	\N
1352	C. Jumps to subroutine and stores return address	t	41	6	77	389	2025-06-21 13:08:50.156674	\N
1353	D. Transfers memory from heap to stack	f	41	6	77	389	2025-06-21 13:08:50.156674	\N
1354	A. t0	f	41	6	77	390	2025-06-21 13:08:50.156674	\N
1355	B. a0	t	41	6	77	390	2025-06-21 13:08:50.156674	\N
1356	C. ra	f	41	6	77	390	2025-06-21 13:08:50.156674	\N
1357	D. s0	f	41	6	77	390	2025-06-21 13:08:50.156674	\N
1358	A. Stack only	f	41	6	77	391	2025-06-21 13:08:50.156674	\N
1359	B. Memory only	f	41	6	77	391	2025-06-21 13:08:50.156674	\N
1360	C. Registers a0–a7 and memory	t	41	6	77	391	2025-06-21 13:08:50.156674	\N
1361	D. Registers t0–t6	f	41	6	77	391	2025-06-21 13:08:50.156674	\N
1362	A. Clear the stack	f	41	6	77	392	2025-06-21 13:08:50.156674	\N
1363	B. Save `ra`	t	41	6	77	392	2025-06-21 13:08:50.156674	\N
1364	C. Save `a0`	f	41	6	77	392	2025-06-21 13:08:50.156674	\N
1365	D. Move `sp` to `s0`	f	41	6	77	392	2025-06-21 13:08:50.156674	\N
1366	A. Display “Hello, world!”	f	41	6	77	393	2025-06-21 13:08:50.156674	\N
1367	B. Perform runtime initialisation before calling `main()`	t	41	6	77	393	2025-06-21 13:08:50.156674	\N
1368	C. Terminate the program	f	41	6	77	393	2025-06-21 13:08:50.156674	\N
1369	D. Act as a memory allocator	f	41	6	77	393	2025-06-21 13:08:50.156674	\N
1370	A. Functions	f	41	6	77	394	2025-06-21 13:08:50.156674	\N
1371	B. Stack frames	f	41	6	77	394	2025-06-21 13:08:50.156674	\N
1372	C. Uninitialized global variables	t	41	6	77	394	2025-06-21 13:08:50.156674	\N
1373	D. Program instructions	f	41	6	77	394	2025-06-21 13:08:50.156674	\N
1374	A. .data	f	41	6	77	395	2025-06-21 13:08:50.156674	\N
1375	B. .bss	f	41	6	77	395	2025-06-21 13:08:50.156674	\N
1376	C. .rodata	t	41	6	77	395	2025-06-21 13:08:50.156674	\N
1377	D. .init	f	41	6	77	395	2025-06-21 13:08:50.156674	\N
1378	A. ret	t	41	6	77	396	2025-06-21 13:08:50.156674	\N
1379	B. jmp	f	41	6	77	396	2025-06-21 13:08:50.156674	\N
1380	C. mov	f	41	6	77	396	2025-06-21 13:08:50.156674	\N
1381	D. exit	f	41	6	77	396	2025-06-21 13:08:50.156674	\N
1382	A. s0	f	41	6	77	397	2025-06-21 13:08:50.156674	\N
1383	B. fp	f	41	6	77	397	2025-06-21 13:08:50.156674	\N
1384	C. a0	t	41	6	77	397	2025-06-21 13:08:50.156674	\N
1385	D. sp	f	41	6	77	397	2025-06-21 13:08:50.156674	\N
1386	A. Must be allocated on the heap	f	41	6	77	398	2025-06-21 13:08:50.156674	\N
1387	B. Created and destroyed automatically upon scope entry/exit	t	41	6	77	398	2025-06-21 13:08:50.156674	\N
1388	C. Only used in global scope	f	41	6	77	398	2025-06-21 13:08:50.156674	\N
1389	D. Cannot store integers	f	41	6	77	398	2025-06-21 13:08:50.156674	\N
1390	A. Moves t0 to memory	f	41	6	77	399	2025-06-21 13:08:50.156674	\N
1391	B. Copies a0 into t0	t	41	6	77	399	2025-06-21 13:08:50.156674	\N
1392	C. Multiplies values	f	41	6	77	399	2025-06-21 13:08:50.156674	\N
1393	D. Jumps to a0	f	41	6	77	399	2025-06-21 13:08:50.156674	\N
1394	A. To optimize code	f	41	6	77	400	2025-06-21 13:08:50.156674	\N
1395	B. To create documentation	f	41	6	77	400	2025-06-21 13:08:50.156674	\N
1396	C. To place sections at the correct memory addresses	t	41	6	77	400	2025-06-21 13:08:50.156674	\N
1397	D. To write assembly	f	41	6	77	400	2025-06-21 13:08:50.156674	\N
1398	A. A text file	f	41	6	77	401	2025-06-21 13:08:50.156674	\N
1399	B. A bootloader	f	41	6	77	401	2025-06-21 13:08:50.156674	\N
1400	C. A compiled binary file ready for ROM	t	41	6	77	401	2025-06-21 13:08:50.156674	\N
1401	D. A Makefile	f	41	6	77	401	2025-06-21 13:08:50.156674	\N
1402	A. Dereferences a pointer	f	41	6	78	402	2025-06-21 13:12:42.145868	\N
1403	B. Returns the address of a variable	t	41	6	78	402	2025-06-21 13:12:42.145868	\N
1404	C. Allocates memory	f	41	6	78	402	2025-06-21 13:12:42.145868	\N
1405	D. Copies values into memory	f	41	6	78	402	2025-06-21 13:12:42.145868	\N
1406	A. Memory address of `a`	f	41	6	78	403	2025-06-21 13:12:42.145868	\N
1407	B. Value 0	f	41	6	78	403	2025-06-21 13:12:42.145868	\N
1408	C. Value 5	t	41	6	78	403	2025-06-21 13:12:42.145868	\N
1409	D. Compilation error	f	41	6	78	403	2025-06-21 13:12:42.145868	\N
1410	A. 15	f	41	6	78	404	2025-06-21 13:12:42.145868	\N
1411	B. 20	t	41	6	78	404	2025-06-21 13:12:42.145868	\N
1412	C. 25	f	41	6	78	404	2025-06-21 13:12:42.145868	\N
1413	D. 30	f	41	6	78	404	2025-06-21 13:12:42.145868	\N
1414	A. Register access	f	41	6	78	405	2025-06-21 13:12:42.145868	\N
1415	B. Code optimization assumptions	t	41	6	78	405	2025-06-21 13:12:42.145868	\N
1416	C. Memory leaks	f	41	6	78	405	2025-06-21 13:12:42.145868	\N
1417	D. Register swapping	f	41	6	78	405	2025-06-21 13:12:42.145868	\N
1418	A. They can only be used with structs	f	41	6	78	406	2025-06-21 13:12:42.145868	\N
1419	B. Their values change without CPU instructions	t	41	6	78	406	2025-06-21 13:12:42.145868	\N
1420	C. They cause segmentation faults otherwise	f	41	6	78	406	2025-06-21 13:12:42.145868	\N
1421	D. They hold floating point values	f	41	6	78	406	2025-06-21 13:12:42.145868	\N
1422	A. Nothing	f	41	6	78	407	2025-06-21 13:12:42.145868	\N
1423	B. Smooth data flow	f	41	6	78	407	2025-06-21 13:12:42.145868	\N
1424	C. Short circuit risk	t	41	6	78	407	2025-06-21 13:12:42.145868	\N
1425	D. Boosted voltage	f	41	6	78	407	2025-06-21 13:12:42.145868	\N
1426	A. Makes a label local	f	41	6	78	408	2025-06-21 13:12:42.145868	\N
1427	B. Prevents compilation	f	41	6	78	408	2025-06-21 13:12:42.145868	\N
1428	C. Makes a label visible to the linker	t	41	6	78	408	2025-06-21 13:12:42.145868	\N
1429	D. Adds a function comment	f	41	6	78	408	2025-06-21 13:12:42.145868	\N
1430	A. Ends a program	f	41	6	78	409	2025-06-21 13:12:42.145868	\N
1431	B. Jumps to memory address 0	f	41	6	78	409	2025-06-21 13:12:42.145868	\N
1432	C. Jumps to subroutine and stores return address	t	41	6	78	409	2025-06-21 13:12:42.145868	\N
1433	D. Transfers memory from heap to stack	f	41	6	78	409	2025-06-21 13:12:42.145868	\N
1434	A. t0	f	41	6	78	410	2025-06-21 13:12:42.145868	\N
1435	B. a0	t	41	6	78	410	2025-06-21 13:12:42.145868	\N
1436	C. ra	f	41	6	78	410	2025-06-21 13:12:42.145868	\N
1437	D. s0	f	41	6	78	410	2025-06-21 13:12:42.145868	\N
1438	A. Stack only	f	41	6	78	411	2025-06-21 13:12:42.145868	\N
1439	B. Memory only	f	41	6	78	411	2025-06-21 13:12:42.145868	\N
1440	C. Registers a0–a7 and memory	t	41	6	78	411	2025-06-21 13:12:42.145868	\N
1441	D. Registers t0–t6	f	41	6	78	411	2025-06-21 13:12:42.145868	\N
1442	A. Clear the stack	f	41	6	78	412	2025-06-21 13:12:42.145868	\N
1443	B. Save `ra`	t	41	6	78	412	2025-06-21 13:12:42.145868	\N
1444	C. Save `a0`	f	41	6	78	412	2025-06-21 13:12:42.145868	\N
1445	D. Move `sp` to `s0`	f	41	6	78	412	2025-06-21 13:12:42.145868	\N
1446	A. Display “Hello, world!”	f	41	6	78	413	2025-06-21 13:12:42.145868	\N
1447	B. Perform runtime initialisation before calling `main()`	t	41	6	78	413	2025-06-21 13:12:42.145868	\N
1448	C. Terminate the program	f	41	6	78	413	2025-06-21 13:12:42.145868	\N
1449	D. Act as a memory allocator	f	41	6	78	413	2025-06-21 13:12:42.145868	\N
1450	A. Functions	f	41	6	78	414	2025-06-21 13:12:42.145868	\N
1451	B. Stack frames	f	41	6	78	414	2025-06-21 13:12:42.145868	\N
1452	C. Uninitialized global variables	t	41	6	78	414	2025-06-21 13:12:42.145868	\N
1453	D. Program instructions	f	41	6	78	414	2025-06-21 13:12:42.145868	\N
1454	A. .data	f	41	6	78	415	2025-06-21 13:12:42.145868	\N
1455	B. .bss	f	41	6	78	415	2025-06-21 13:12:42.145868	\N
1456	C. .rodata	t	41	6	78	415	2025-06-21 13:12:42.145868	\N
1457	D. .init	f	41	6	78	415	2025-06-21 13:12:42.145868	\N
1458	A. ret	t	41	6	78	416	2025-06-21 13:12:42.145868	\N
1459	B. jmp	f	41	6	78	416	2025-06-21 13:12:42.145868	\N
1460	C. mov	f	41	6	78	416	2025-06-21 13:12:42.145868	\N
1461	D. exit	f	41	6	78	416	2025-06-21 13:12:42.145868	\N
1462	A. s0	f	41	6	78	417	2025-06-21 13:12:42.145868	\N
1463	B. fp	f	41	6	78	417	2025-06-21 13:12:42.145868	\N
1464	C. a0	t	41	6	78	417	2025-06-21 13:12:42.145868	\N
1465	D. sp	f	41	6	78	417	2025-06-21 13:12:42.145868	\N
1466	A. Must be allocated on the heap	f	41	6	78	418	2025-06-21 13:12:42.145868	\N
1467	B. Created and destroyed automatically upon scope entry/exit	t	41	6	78	418	2025-06-21 13:12:42.145868	\N
1468	C. Only used in global scope	f	41	6	78	418	2025-06-21 13:12:42.145868	\N
1469	D. Cannot store integers	f	41	6	78	418	2025-06-21 13:12:42.145868	\N
1470	A. Moves t0 to memory	f	41	6	78	419	2025-06-21 13:12:42.145868	\N
1471	B. Copies a0 into t0	t	41	6	78	419	2025-06-21 13:12:42.145868	\N
1472	C. Multiplies values	f	41	6	78	419	2025-06-21 13:12:42.145868	\N
1473	D. Jumps to a0	f	41	6	78	419	2025-06-21 13:12:42.145868	\N
1474	A. To optimize code	f	41	6	78	420	2025-06-21 13:12:42.145868	\N
1475	B. To create documentation	f	41	6	78	420	2025-06-21 13:12:42.145868	\N
1476	C. To place sections at the correct memory addresses	t	41	6	78	420	2025-06-21 13:12:42.145868	\N
1477	D. To write assembly	f	41	6	78	420	2025-06-21 13:12:42.145868	\N
1478	A. A text file	f	41	6	78	421	2025-06-21 13:12:42.145868	\N
1479	B. A bootloader	f	41	6	78	421	2025-06-21 13:12:42.145868	\N
1480	C. A compiled binary file ready for ROM	t	41	6	78	421	2025-06-21 13:12:42.145868	\N
1481	D. A Makefile	f	41	6	78	421	2025-06-21 13:12:42.145868	\N
1482	A. It doesn't support multiple processes	f	41	6	79	422	2025-06-21 13:23:51.091231	\N
1483	B. The kernel controls all timing	f	41	6	79	422	2025-06-21 13:23:51.091231	\N
1484	C. A process must voluntarily yield the CPU	t	41	6	79	422	2025-06-21 13:23:51.091231	\N
1485	D. It requires hardware interrupts	f	41	6	79	422	2025-06-21 13:23:51.091231	\N
1486	A. A system call	f	41	6	79	423	2025-06-21 13:23:51.091231	\N
1487	B. An environment call	f	41	6	79	423	2025-06-21 13:23:51.091231	\N
1488	C. A hardware timer interrupt	t	41	6	79	423	2025-06-21 13:23:51.091231	\N
1489	D. A privilege bit in mstatus	f	41	6	79	423	2025-06-21 13:23:51.091231	\N
1490	A. A file opened by the process	f	41	6	79	424	2025-06-21 13:23:51.091231	\N
1491	B. A user interface	f	41	6	79	424	2025-06-21 13:23:51.091231	\N
1492	C. The current state of a process (registers, PC, etc.)	t	41	6	79	424	2025-06-21 13:23:51.091231	\N
1493	D. The address of the trap handler	f	41	6	79	424	2025-06-21 13:23:51.091231	\N
1494	A. Switching from user mode to supervisor mode	f	41	6	79	425	2025-06-21 13:23:51.091231	\N
1495	B. Rebooting the processor	f	41	6	79	425	2025-06-21 13:23:51.091231	\N
1496	C. Saving one process's state and loading another's	t	41	6	79	425	2025-06-21 13:23:51.091231	\N
1497	D. Switching memory pages	f	41	6	79	425	2025-06-21 13:23:51.091231	\N
1498	A. When a process finishes	f	41	6	79	426	2025-06-21 13:23:51.091231	\N
1499	B. When the user presses a key	f	41	6	79	426	2025-06-21 13:23:51.091231	\N
1500	C. After a fixed time slice via timer interrupt	t	41	6	79	426	2025-06-21 13:23:51.091231	\N
1501	D. Only on system calls	f	41	6	79	426	2025-06-21 13:23:51.091231	\N
1502	A. Handle hardware exceptions	f	41	6	79	427	2025-06-21 13:23:51.091231	\N
1503	B. Execute user code	f	41	6	79	427	2025-06-21 13:23:51.091231	\N
1504	C. Decide which process runs next	t	41	6	79	427	2025-06-21 13:23:51.091231	\N
1505	D. Save registers on function call	f	41	6	79	427	2025-06-21 13:23:51.091231	\N
1506	A. To switch memory pages	f	41	6	79	428	2025-06-21 13:23:51.091231	\N
1507	B. To handle illegal instructions	f	41	6	79	428	2025-06-21 13:23:51.091231	\N
1508	C. So a process can resume exactly where it left off	t	41	6	79	428	2025-06-21 13:23:51.091231	\N
1509	D. To reset the CPU	f	41	6	79	428	2025-06-21 13:23:51.091231	\N
1510	A. ret	f	41	6	79	429	2025-06-21 13:23:51.091231	\N
1511	B. mret	t	41	6	79	429	2025-06-21 13:23:51.091231	\N
1512	C. csrw	f	41	6	79	429	2025-06-21 13:23:51.091231	\N
1513	D. ecall	f	41	6	79	429	2025-06-21 13:23:51.091231	\N
1514	A. Manage virtual memory	f	41	6	79	430	2025-06-21 13:23:51.091231	\N
1515	B. Trigger timer interrupts for context switching	t	41	6	79	430	2025-06-21 13:23:51.091231	\N
1516	C. Track I/O devices	f	41	6	79	430	2025-06-21 13:23:51.091231	\N
1517	D. Store the trap handler address	f	41	6	79	430	2025-06-21 13:23:51.091231	\N
1518	A. The cause of the exception	f	41	6	79	431	2025-06-21 13:23:51.091231	\N
1519	B. The address of the trap handler	f	41	6	79	431	2025-06-21 13:23:51.091231	\N
1520	C. A temporary value like the previous sp	t	41	6	79	431	2025-06-21 13:23:51.091231	\N
1521	D. The stack pointer of the new process	f	41	6	79	431	2025-06-21 13:23:51.091231	\N
1522	A. That the CPU runs at maximum speed	f	41	6	79	432	2025-06-21 13:23:51.091231	\N
1523	B. That users can access MMIO directly	f	41	6	79	432	2025-06-21 13:23:51.091231	\N
1524	C. That only kernel code can access critical resources	t	41	6	79	432	2025-06-21 13:23:51.091231	\N
1525	D. That system calls are faster	f	41	6	79	432	2025-06-21 13:23:51.091231	\N
1526	A. By jumping to address 0	f	41	6	79	433	2025-06-21 13:23:51.091231	\N
1527	B. Through MMIO directly	f	41	6	79	433	2025-06-21 13:23:51.091231	\N
1528	C. By calling mret	f	41	6	79	433	2025-06-21 13:23:51.091231	\N
1529	D. By issuing a system call (ecall)	t	41	6	79	433	2025-06-21 13:23:51.091231	\N
1530	A. a0	f	41	6	79	434	2025-06-21 13:23:51.091231	\N
1531	B. a7	t	41	6	79	434	2025-06-21 13:23:51.091231	\N
1532	C. mstatus	f	41	6	79	434	2025-06-21 13:23:51.091231	\N
1533	D. sp	f	41	6	79	434	2025-06-21 13:23:51.091231	\N
1534	A. To increase clock speed	f	41	6	79	435	2025-06-21 13:23:51.091231	\N
1535	B. To allow context switches without program cooperation	t	41	6	79	435	2025-06-21 13:23:51.091231	\N
1536	C. To store more files	f	41	6	79	435	2025-06-21 13:23:51.091231	\N
1537	D. To read and write to MMIO	f	41	6	79	435	2025-06-21 13:23:51.091231	\N
1538	A. Stack overflow	f	41	6	79	436	2025-06-21 13:23:51.091231	\N
1539	B. Device failure	f	41	6	79	436	2025-06-21 13:23:51.091231	\N
1540	C. One process reading/modifying another's memory	t	41	6	79	436	2025-06-21 13:23:51.091231	\N
1541	D. Slow multitasking	f	41	6	79	436	2025-06-21 13:23:51.091231	\N
1542	A. Faster RAM access	f	41	6	80	437	2025-06-21 13:37:54.703089	\N
1543	B. Isolating kernel from user space	f	41	6	80	437	2025-06-21 13:37:54.703089	\N
1544	C. Allowing processes to use more memory than physically available	t	41	6	80	437	2025-06-21 13:37:54.703089	\N
1545	D. Using page tables for file access	f	41	6	80	437	2025-06-21 13:37:54.703089	\N
1546	A. Stores user files	f	41	6	80	438	2025-06-21 13:37:54.703089	\N
1547	B. Handles kernel scheduling	f	41	6	80	438	2025-06-21 13:37:54.703089	\N
1548	C. Translates virtual addresses to physical addresses	t	41	6	80	438	2025-06-21 13:37:54.703089	\N
1549	D. Transfers data between HDD and RAM	f	41	6	80	438	2025-06-21 13:37:54.703089	\N
1550	A. A CPU instruction	f	41	6	80	439	2025-06-21 13:37:54.703089	\N
1551	B. A 512-bit block	f	41	6	80	439	2025-06-21 13:37:54.703089	\N
1552	C. A fixed-size block of memory, typically 4096 bytes	t	41	6	80	439	2025-06-21 13:37:54.703089	\N
1553	D. A dynamic section of a process	f	41	6	80	439	2025-06-21 13:37:54.703089	\N
1554	A. They load faster	f	41	6	80	440	2025-06-21 13:37:54.703089	\N
1555	B. They reduce RAM usage by allowing shared pages	t	41	6	80	440	2025-06-21 13:37:54.703089	\N
1556	C. They eliminate the need for syscalls	f	41	6	80	440	2025-06-21 13:37:54.703089	\N
1557	D. They are kernel-only	f	41	6	80	440	2025-06-21 13:37:54.703089	\N
1558	A. All processes share one virtual address space	f	41	6	80	441	2025-06-21 13:37:54.703089	\N
1559	B. Only the kernel has a virtual address space	f	41	6	80	441	2025-06-21 13:37:54.703089	\N
1560	C. Each process has its own virtual address space	t	41	6	80	441	2025-06-21 13:37:54.703089	\N
1561	D. The MMU disables address isolation	f	41	6	80	441	2025-06-21 13:37:54.703089	\N
1562	A. 9	f	41	6	80	442	2025-06-21 13:37:54.703089	\N
1563	B. 12	t	41	6	80	442	2025-06-21 13:37:54.703089	\N
1564	C. 27	f	41	6	80	442	2025-06-21 13:37:54.703089	\N
1565	D. 44	f	41	6	80	442	2025-06-21 13:37:54.703089	\N
1566	A. Scheduler status	f	41	6	80	443	2025-06-21 13:37:54.703089	\N
1567	B. TLB cache	f	41	6	80	443	2025-06-21 13:37:54.703089	\N
1568	C. Root page table physical address and mode info	t	41	6	80	443	2025-06-21 13:37:54.703089	\N
1569	D. Currently executing process ID	f	41	6	80	443	2025-06-21 13:37:54.703089	\N
1570	A. For faster access	f	41	6	80	444	2025-06-21 13:37:54.703089	\N
1571	B. To avoid memory waste due to sparse virtual address spaces	t	41	6	80	444	2025-06-21 13:37:54.703089	\N
1572	C. Because it only uses one address space	f	41	6	80	444	2025-06-21 13:37:54.703089	\N
1573	D. To avoid needing a MMU	f	41	6	80	444	2025-06-21 13:37:54.703089	\N
1574	A. The OS continues anyway	f	41	6	80	445	2025-06-21 13:37:54.703089	\N
1575	B. The process is automatically terminated	f	41	6	80	445	2025-06-21 13:37:54.703089	\N
1576	C. A trap is raised (software exception)	t	41	6	80	445	2025-06-21 13:37:54.703089	\N
1577	D. The kernel disables interrupts	f	41	6	80	445	2025-06-21 13:37:54.703089	\N
1578	A. Increases RAM capacity	f	41	6	80	446	2025-06-21 13:37:54.703089	\N
1579	B. Stores disk block addresses	f	41	6	80	446	2025-06-21 13:37:54.703089	\N
1580	C. Caches recent virtual-to-physical address mappings	t	41	6	80	446	2025-06-21 13:37:54.703089	\N
1581	D. Stores user credentials for privilege checking	f	41	6	80	446	2025-06-21 13:37:54.703089	\N
1582	A. Random access	f	41	6	80	447	2025-06-21 13:37:54.703089	\N
1583	B. Batching	f	41	6	80	447	2025-06-21 13:37:54.703089	\N
1584	C. Locality (working set behavior)	t	41	6	80	447	2025-06-21 13:37:54.703089	\N
1585	D. Isolation	f	41	6	80	447	2025-06-21 13:37:54.703089	\N
1586	A. OS crashes due to MMU failure	f	41	6	80	448	2025-06-21 13:37:54.703089	\N
1587	B. Constant page swapping due to insufficient RAM	t	41	6	80	448	2025-06-21 13:37:54.703089	\N
1588	C. Multithreading errors	f	41	6	80	448	2025-06-21 13:37:54.703089	\N
1589	D. Stack overflow caused by kernel code	f	41	6	80	448	2025-06-21 13:37:54.703089	\N
1590	A. Enables page faults	f	41	6	80	449	2025-06-21 13:37:54.703089	\N
1591	B. Forces context switch	f	41	6	80	449	2025-06-21 13:37:54.703089	\N
1592	C. Flushes TLB after changing `satp`	t	41	6	80	449	2025-06-21 13:37:54.703089	\N
1593	D. Turns on memory-mapped I/O	f	41	6	80	449	2025-06-21 13:37:54.703089	\N
1594	A. The page is shared	f	41	6	80	450	2025-06-21 13:37:54.703089	\N
1595	B. The page was modified (written to)	t	41	6	80	450	2025-06-21 13:37:54.703089	\N
1596	C. The page is inaccessible	f	41	6	80	450	2025-06-21 13:37:54.703089	\N
1597	D. The page table is full	f	41	6	80	450	2025-06-21 13:37:54.703089	\N
1598	A. User mode	f	41	6	80	451	2025-06-21 13:37:54.703089	\N
1599	B. Supervisor mode	f	41	6	80	451	2025-06-21 13:37:54.703089	\N
1600	C. Hypervisor mode	f	41	6	80	451	2025-06-21 13:37:54.703089	\N
1601	D. Machine mode	t	41	6	80	451	2025-06-21 13:37:54.703089	\N
1662	Faster RAM access	f	41	6	81	467	2025-06-21 13:46:47.784456	\N
1663	Isolating kernel from user space	f	41	6	81	467	2025-06-21 13:46:47.784456	\N
1664	Allowing processes to use more memory than physically available	t	41	6	81	467	2025-06-21 13:46:47.784456	\N
1665	Using page tables for file access	f	41	6	81	467	2025-06-21 13:46:47.784456	\N
1666	Stores user files	f	41	6	81	468	2025-06-21 13:46:47.784456	\N
1667	Handles kernel scheduling	f	41	6	81	468	2025-06-21 13:46:47.784456	\N
1668	Translates virtual addresses to physical addresses	t	41	6	81	468	2025-06-21 13:46:47.784456	\N
1669	Transfers data between HDD and RAM	f	41	6	81	468	2025-06-21 13:46:47.784456	\N
1670	A CPU instruction	f	41	6	81	469	2025-06-21 13:46:47.784456	\N
1671	A 512-bit block	f	41	6	81	469	2025-06-21 13:46:47.784456	\N
1672	A fixed-size block of memory, typically 4096 bytes	t	41	6	81	469	2025-06-21 13:46:47.784456	\N
1673	A dynamic section of a process	f	41	6	81	469	2025-06-21 13:46:47.784456	\N
1674	They load faster	f	41	6	81	470	2025-06-21 13:46:47.784456	\N
1675	They reduce RAM usage by allowing shared pages	t	41	6	81	470	2025-06-21 13:46:47.784456	\N
1676	They eliminate the need for syscalls	f	41	6	81	470	2025-06-21 13:46:47.784456	\N
1677	They are kernel-only	f	41	6	81	470	2025-06-21 13:46:47.784456	\N
1678	All processes share one virtual address space	f	41	6	81	471	2025-06-21 13:46:47.784456	\N
1679	Only the kernel has a virtual address space	f	41	6	81	471	2025-06-21 13:46:47.784456	\N
1680	Each process has its own virtual address space	t	41	6	81	471	2025-06-21 13:46:47.784456	\N
1681	The MMU disables address isolation	f	41	6	81	471	2025-06-21 13:46:47.784456	\N
1682	9	f	41	6	81	472	2025-06-21 13:46:47.784456	\N
1683	12	t	41	6	81	472	2025-06-21 13:46:47.784456	\N
1684	27	f	41	6	81	472	2025-06-21 13:46:47.784456	\N
1685	44	f	41	6	81	472	2025-06-21 13:46:47.784456	\N
1686	Scheduler status	f	41	6	81	473	2025-06-21 13:46:47.784456	\N
1687	TLB cache	f	41	6	81	473	2025-06-21 13:46:47.784456	\N
1688	Root page table physical address and mode info	t	41	6	81	473	2025-06-21 13:46:47.784456	\N
1689	Currently executing process ID	f	41	6	81	473	2025-06-21 13:46:47.784456	\N
1690	For faster access	f	41	6	81	474	2025-06-21 13:46:47.784456	\N
1691	To avoid memory waste due to sparse virtual address spaces	t	41	6	81	474	2025-06-21 13:46:47.784456	\N
1692	Because it only uses one address space	f	41	6	81	474	2025-06-21 13:46:47.784456	\N
1693	To avoid needing a MMU	f	41	6	81	474	2025-06-21 13:46:47.784456	\N
1694	The OS continues anyway	f	41	6	81	475	2025-06-21 13:46:47.784456	\N
1695	The process is automatically terminated	f	41	6	81	475	2025-06-21 13:46:47.784456	\N
1696	A trap is raised (software exception)	t	41	6	81	475	2025-06-21 13:46:47.784456	\N
1697	The kernel disables interrupts	f	41	6	81	475	2025-06-21 13:46:47.784456	\N
1698	Increases RAM capacity	f	41	6	81	476	2025-06-21 13:46:47.784456	\N
1699	Stores disk block addresses	f	41	6	81	476	2025-06-21 13:46:47.784456	\N
1700	Caches recent virtual-to-physical address mappings	t	41	6	81	476	2025-06-21 13:46:47.784456	\N
1701	Stores user credentials for privilege checking	f	41	6	81	476	2025-06-21 13:46:47.784456	\N
1702	Random access	f	41	6	81	477	2025-06-21 13:46:47.784456	\N
1703	Batching	f	41	6	81	477	2025-06-21 13:46:47.784456	\N
1704	Locality (working-set behavior)	t	41	6	81	477	2025-06-21 13:46:47.784456	\N
1705	Isolation	f	41	6	81	477	2025-06-21 13:46:47.784456	\N
1706	OS crashes due to MMU failure	f	41	6	81	478	2025-06-21 13:46:47.784456	\N
1707	Constant page swapping due to insufficient RAM	t	41	6	81	478	2025-06-21 13:46:47.784456	\N
1708	Multithreading errors	f	41	6	81	478	2025-06-21 13:46:47.784456	\N
1709	Stack overflow caused by kernel code	f	41	6	81	478	2025-06-21 13:46:47.784456	\N
1710	Enables page faults	f	41	6	81	479	2025-06-21 13:46:47.784456	\N
1711	Forces context switch	f	41	6	81	479	2025-06-21 13:46:47.784456	\N
1712	Flushes TLB after changing `satp`	t	41	6	81	479	2025-06-21 13:46:47.784456	\N
1713	Turns on memory-mapped I/O	f	41	6	81	479	2025-06-21 13:46:47.784456	\N
1714	The page is shared	f	41	6	81	480	2025-06-21 13:46:47.784456	\N
1715	The page was modified (written to)	t	41	6	81	480	2025-06-21 13:46:47.784456	\N
1716	The page is inaccessible	f	41	6	81	480	2025-06-21 13:46:47.784456	\N
1717	The page table is full	f	41	6	81	480	2025-06-21 13:46:47.784456	\N
1718	User mode	f	41	6	81	481	2025-06-21 13:46:47.784456	\N
1719	Supervisor mode	f	41	6	81	481	2025-06-21 13:46:47.784456	\N
1720	Hypervisor mode	f	41	6	81	481	2025-06-21 13:46:47.784456	\N
1721	Machine mode	t	41	6	81	481	2025-06-21 13:46:47.784456	\N
1722	A device that processes CPU instructions	f	41	6	82	482	2025-06-21 13:49:40.719898	\N
1723	A device that communicates over sockets	f	41	6	82	482	2025-06-21 13:49:40.719898	\N
1724	A storage device that reads/writes fixed-size data chunks	t	41	6	82	482	2025-06-21 13:49:40.719898	\N
1725	A special file representing an I/O stream	f	41	6	82	482	2025-06-21 13:49:40.719898	\N
1726	256 bytes	f	41	6	82	483	2025-06-21 13:49:40.719898	\N
1727	512 bytes	t	41	6	82	483	2025-06-21 13:49:40.719898	\N
1728	1024 bytes	f	41	6	82	483	2025-06-21 13:49:40.719898	\N
1729	4096 bytes	f	41	6	82	483	2025-06-21 13:49:40.719898	\N
1730	128 bytes	f	41	6	82	484	2025-06-21 13:49:40.719898	\N
1731	256 bytes	f	41	6	82	484	2025-06-21 13:49:40.719898	\N
1732	512 bytes	f	41	6	82	484	2025-06-21 13:49:40.719898	\N
1733	4096 bytes	t	41	6	82	484	2025-06-21 13:49:40.719898	\N
1734	The name of every file on the disk	f	41	6	82	485	2025-06-21 13:49:40.719898	\N
1735	Actual content of files	f	41	6	82	485	2025-06-21 13:49:40.719898	\N
1736	File system metadata like size, number of inodes, block size	t	41	6	82	485	2025-06-21 13:49:40.719898	\N
1737	Bootloader code	f	41	6	82	485	2025-06-21 13:49:40.719898	\N
1738	Directory entry	f	41	6	82	486	2025-06-21 13:49:40.719898	\N
1739	Superblock	f	41	6	82	486	2025-06-21 13:49:40.719898	\N
1740	Inode	t	41	6	82	486	2025-06-21 13:49:40.719898	\N
1741	Data block	f	41	6	82	486	2025-06-21 13:49:40.719898	\N
1742	A backup copy of the superblock	f	41	6	82	487	2025-06-21 13:49:40.719898	\N
1743	A file made up of indirect blocks	f	41	6	82	487	2025-06-21 13:49:40.719898	\N
1744	A set of contiguous blocks representing part of a file	t	41	6	82	487	2025-06-21 13:49:40.719898	\N
1745	A memory-mapped device node	f	41	6	82	487	2025-06-21 13:49:40.719898	\N
1746	Name → Superblock → Data	f	41	6	82	488	2025-06-21 13:49:40.719898	\N
1747	Name → i-node number → Data blocks	t	41	6	82	488	2025-06-21 13:49:40.719898	\N
1748	Name → Cluster → Page	f	41	6	82	488	2025-06-21 13:49:40.719898	\N
1749	Name → Cache → RAM	f	41	6	82	488	2025-06-21 13:49:40.719898	\N
1750	ls -a	f	41	6	82	489	2025-06-21 13:49:40.719898	\N
1751	mount	t	41	6	82	489	2025-06-21 13:49:40.719898	\N
1752	ln	f	41	6	82	489	2025-06-21 13:49:40.719898	\N
1753	stat	f	41	6	82	489	2025-06-21 13:49:40.719898	\N
1754	A cache of recently opened files	f	41	6	82	490	2025-06-21 13:49:40.719898	\N
1755	A partition for logs	f	41	6	82	490	2025-06-21 13:49:40.719898	\N
1756	A pseudo file system showing kernel/system info	t	41	6	82	490	2025-06-21 13:49:40.719898	\N
1757	A virtual memory folder	f	41	6	82	490	2025-06-21 13:49:40.719898	\N
1758	The actual content of all files	f	41	6	82	491	2025-06-21 13:49:40.719898	\N
1759	Timestamps of all system events	f	41	6	82	491	2025-06-21 13:49:40.719898	\N
1760	Pairs of file names and their inode numbers	t	41	6	82	491	2025-06-21 13:49:40.719898	\N
1761	Mount point data	f	41	6	82	491	2025-06-21 13:49:40.719898	\N
1762	The file is always deleted immediately	f	41	6	82	492	2025-06-21 13:49:40.719898	\N
1763	All links and data are removed	f	41	6	82	492	2025-06-21 13:49:40.719898	\N
1764	The file content remains until the last link is removed	t	41	6	82	492	2025-06-21 13:49:40.719898	\N
1765	The system reboots	f	41	6	82	492	2025-06-21 13:49:40.719898	\N
1766	File size	f	41	6	82	493	2025-06-21 13:49:40.719898	\N
1767	File permissions	f	41	6	82	493	2025-06-21 13:49:40.719898	\N
1768	File name	t	41	6	82	493	2025-06-21 13:49:40.719898	\N
1769	Data block addresses	f	41	6	82	493	2025-06-21 13:49:40.719898	\N
1770	/usr/bin/bash	f	41	6	82	494	2025-06-21 13:49:40.719898	\N
1771	/etc/fstab	f	41	6	82	494	2025-06-21 13:49:40.719898	\N
1772	/dev/sda	t	41	6	82	494	2025-06-21 13:49:40.719898	\N
1773	/home/user/document.txt	f	41	6	82	494	2025-06-21 13:49:40.719898	\N
1774	Slower performance for large files	f	41	6	82	495	2025-06-21 13:49:40.719898	\N
1775	Easier manual backup	f	41	6	82	495	2025-06-21 13:49:40.719898	\N
1776	Efficient file-to-memory mapping	t	41	6	82	495	2025-06-21 13:49:40.719898	\N
1777	Better screen resolution	f	41	6	82	495	2025-06-21 13:49:40.719898	\N
1778	Stores metadata about inodes	f	41	6	82	496	2025-06-21 13:49:40.719898	\N
1779	Tracks used/free data blocks on disk	t	41	6	82	496	2025-06-21 13:49:40.719898	\N
1780	Shows open file descriptors	f	41	6	82	496	2025-06-21 13:49:40.719898	\N
1781	Encrypts the file system	f	41	6	82	496	2025-06-21 13:49:40.719898	\N
1782	The PID of the parent process	f	41	6	84	497	2025-06-21 14:26:56.966806	\N
1783	0	t	41	6	84	497	2025-06-21 14:26:56.966806	\N
1784	The PID of the child process	f	41	6	84	497	2025-06-21 14:26:56.966806	\N
1785	-1	f	41	6	84	497	2025-06-21 14:26:56.966806	\N
1786	Nothing, fork() does not return in the child	f	41	6	84	497	2025-06-21 14:26:56.966806	\N
1787	fork()	f	41	6	84	498	2025-06-21 14:26:56.966806	\N
1788	exit()	f	41	6	84	498	2025-06-21 14:26:56.966806	\N
1789	exec()	t	41	6	84	498	2025-06-21 14:26:56.966806	\N
1790	wait()	f	41	6	84	498	2025-06-21 14:26:56.966806	\N
1791	open()	f	41	6	84	498	2025-06-21 14:26:56.966806	\N
1792	Waits for input from user	f	41	6	84	499	2025-06-21 14:26:56.966806	\N
1793	Sleeps until a child process terminates and retrieves its exit status	t	41	6	84	499	2025-06-21 14:26:56.966806	\N
1794	Suspends the child process	f	41	6	84	499	2025-06-21 14:26:56.966806	\N
1795	Waits for file I/O to complete	f	41	6	84	499	2025-06-21 14:26:56.966806	\N
1796	Kills the parent process	f	41	6	84	499	2025-06-21 14:26:56.966806	\N
1797	A named file for storing logs	f	41	6	84	500	2025-06-21 14:26:56.966806	\N
1798	A virtual file for MMIO	f	41	6	84	500	2025-06-21 14:26:56.966806	\N
1799	A communication channel between two processes	t	41	6	84	500	2025-06-21 14:26:56.966806	\N
1800	A wrapper for standard input	f	41	6	84	500	2025-06-21 14:26:56.966806	\N
1801	A type of mutex lock	f	41	6	84	500	2025-06-21 14:26:56.966806	\N
1802	It returns the PID of the child	f	41	6	84	501	2025-06-21 14:26:56.966806	\N
1803	It prints an error message	f	41	6	84	501	2025-06-21 14:26:56.966806	\N
1804	It never returns	t	41	6	84	501	2025-06-21 14:26:56.966806	\N
1805	It switches to the parent	f	41	6	84	501	2025-06-21 14:26:56.966806	\N
1806	It returns 0	f	41	6	84	501	2025-06-21 14:26:56.966806	\N
1807	0	f	41	6	84	502	2025-06-21 14:26:56.966806	\N
1808	A file path	f	41	6	84	502	2025-06-21 14:26:56.966806	\N
1809	A file descriptor (int)	t	41	6	84	502	2025-06-21 14:26:56.966806	\N
1810	A pointer to a file stream	f	41	6	84	502	2025-06-21 14:26:56.966806	\N
1811	True	f	41	6	84	502	2025-06-21 14:26:56.966806	\N
1812	/bin	f	41	6	84	503	2025-06-21 14:26:56.966806	\N
1813	/dev	t	41	6	84	503	2025-06-21 14:26:56.966806	\N
1814	/sys	f	41	6	84	503	2025-06-21 14:26:56.966806	\N
1815	/proc	f	41	6	84	503	2025-06-21 14:26:56.966806	\N
1816	/etc	f	41	6	84	503	2025-06-21 14:26:56.966806	\N
1817	Open a new directory	f	41	6	84	504	2025-06-21 14:26:56.966806	\N
1818	Delete a file	f	41	6	84	504	2025-06-21 14:26:56.966806	\N
1819	Change the current working directory	t	41	6	84	504	2025-06-21 14:26:56.966806	\N
1820	Check directory permissions	f	41	6	84	504	2025-06-21 14:26:56.966806	\N
1821	Create a new user	f	41	6	84	504	2025-06-21 14:26:56.966806	\N
1822	wait()	f	41	6	84	505	2025-06-21 14:26:56.966806	\N
1823	exit()	t	41	6	84	505	2025-06-21 14:26:56.966806	\N
1824	kill()	f	41	6	84	505	2025-06-21 14:26:56.966806	\N
1825	exec()	f	41	6	84	505	2025-06-21 14:26:56.966806	\N
1826	pause()	f	41	6	84	505	2025-06-21 14:26:56.966806	\N
1827	A pointer to the file	f	41	6	84	506	2025-06-21 14:26:56.966806	\N
1828	A path to the file	f	41	6	84	506	2025-06-21 14:26:56.966806	\N
1829	A permission level	f	41	6	84	506	2025-06-21 14:26:56.966806	\N
1830	A file descriptor returned by open()	t	41	6	84	506	2025-06-21 14:26:56.966806	\N
1831	An index into a buffer	f	41	6	84	506	2025-06-21 14:26:56.966806	\N
1832	Ends all processes	f	41	6	84	507	2025-06-21 14:26:56.966806	\N
1833	Terminates init	f	41	6	84	507	2025-06-21 14:26:56.966806	\N
1834	Sends a signal to the specified process	t	41	6	84	507	2025-06-21 14:26:56.966806	\N
1835	Freezes the filesystem	f	41	6	84	507	2025-06-21 14:26:56.966806	\N
1836	Deletes a user	f	41	6	84	507	2025-06-21 14:26:56.966806	\N
1837	SIGSTOP	f	41	6	84	508	2025-06-21 14:26:56.966806	\N
1838	SIGKILL	f	41	6	84	508	2025-06-21 14:26:56.966806	\N
1839	SIGTERM	t	41	6	84	508	2025-06-21 14:26:56.966806	\N
1840	SIGHUP	f	41	6	84	508	2025-06-21 14:26:56.966806	\N
1841	SIGSEGV	f	41	6	84	508	2025-06-21 14:26:56.966806	\N
1842	Swap two files	f	41	6	84	509	2025-06-21 14:26:56.966806	\N
1843	Duplicate a file name	f	41	6	84	509	2025-06-21 14:26:56.966806	\N
1844	Duplicate one file descriptor to another	t	41	6	84	509	2025-06-21 14:26:56.966806	\N
1845	Flush a file	f	41	6	84	509	2025-06-21 14:26:56.966806	\N
1846	Open stdin	f	41	6	84	509	2025-06-21 14:26:56.966806	\N
1847	Creates a thread	f	41	6	84	510	2025-06-21 14:26:56.966806	\N
1848	Replaces current process image	t	41	6	84	510	2025-06-21 14:26:56.966806	\N
1849	Forks the parent process	f	41	6	84	510	2025-06-21 14:26:56.966806	\N
1850	Returns the child's exit code	f	41	6	84	510	2025-06-21 14:26:56.966806	\N
1851	Closes all file descriptors	f	41	6	84	510	2025-06-21 14:26:56.966806	\N
1852	Success	f	41	6	84	511	2025-06-21 14:26:56.966806	\N
1853	End of file	f	41	6	84	511	2025-06-21 14:26:56.966806	\N
1854	Error occurred	t	41	6	84	511	2025-06-21 14:26:56.966806	\N
1855	Waiting for signal	f	41	6	84	511	2025-06-21 14:26:56.966806	\N
1856	File closed	f	41	6	84	511	2025-06-21 14:26:56.966806	\N
1857	chmod	t	41	6	84	512	2025-06-21 14:26:56.966806	\N
1858	open	f	41	6	84	512	2025-06-21 14:26:56.966806	\N
1859	dup	f	41	6	84	512	2025-06-21 14:26:56.966806	\N
1860	kill	f	41	6	84	512	2025-06-21 14:26:56.966806	\N
1861	read	f	41	6	84	512	2025-06-21 14:26:56.966806	\N
1862	Suspends the system	f	41	6	84	513	2025-06-21 14:26:56.966806	\N
1863	Terminates the process	f	41	6	84	513	2025-06-21 14:26:56.966806	\N
1864	Waits until a signal is received	t	41	6	84	513	2025-06-21 14:26:56.966806	\N
1865	Freezes a file	f	41	6	84	513	2025-06-21 14:26:56.966806	\N
1866	Reads one byte	f	41	6	84	513	2025-06-21 14:26:56.966806	\N
1867	Reads data from memory to file	f	41	6	84	514	2025-06-21 14:26:56.966806	\N
1868	Reads data from a file descriptor into a buffer	t	41	6	84	514	2025-06-21 14:26:56.966806	\N
1869	Parses text input	f	41	6	84	514	2025-06-21 14:26:56.966806	\N
1870	Opens a file for reading	f	41	6	84	514	2025-06-21 14:26:56.966806	\N
1871	Returns exit code	f	41	6	84	514	2025-06-21 14:26:56.966806	\N
1872	Closes the process	f	41	6	84	515	2025-06-21 14:26:56.966806	\N
1873	Closes a file descriptor	t	41	6	84	515	2025-06-21 14:26:56.966806	\N
1874	Terminates a thread	f	41	6	84	515	2025-06-21 14:26:56.966806	\N
1875	Resets buffer memory	f	41	6	84	515	2025-06-21 14:26:56.966806	\N
1876	Creates a pipe	f	41	6	84	515	2025-06-21 14:26:56.966806	\N
1877	exec()	f	41	6	84	516	2025-06-21 14:26:56.966806	\N
1878	fork()	t	41	6	84	516	2025-06-21 14:26:56.966806	\N
1879	wait()	f	41	6	84	516	2025-06-21 14:26:56.966806	\N
1880	open()	f	41	6	84	516	2025-06-21 14:26:56.966806	\N
1881	pause()	f	41	6	84	516	2025-06-21 14:26:56.966806	\N
1882	Debugging tool and scheduler	f	41	6	85	517	2025-06-21 14:37:49.513226	\N
1883	Interactive interface and command compiler	f	41	6	85	517	2025-06-21 14:37:49.513226	\N
1884	Interactive interface and programming language	t	41	6	85	517	2025-06-21 14:37:49.513226	\N
1885	Process manager and file system handler	f	41	6	85	517	2025-06-21 14:37:49.513226	\N
1886	GUI emulator and terminal	f	41	6	85	517	2025-06-21 14:37:49.513226	\N
1887	csh	f	41	6	85	518	2025-06-21 14:37:49.513226	\N
1888	sh	f	41	6	85	518	2025-06-21 14:37:49.513226	\N
1889	zsh	f	41	6	85	518	2025-06-21 14:37:49.513226	\N
1890	bash	t	41	6	85	518	2025-06-21 14:37:49.513226	\N
1891	fish	f	41	6	85	518	2025-06-21 14:37:49.513226	\N
1892	//	f	41	6	85	519	2025-06-21 14:37:49.513226	\N
1893	/* */	f	41	6	85	519	2025-06-21 14:37:49.513226	\N
1894	#	t	41	6	85	519	2025-06-21 14:37:49.513226	\N
1895	;	f	41	6	85	519	2025-06-21 14:37:49.513226	\N
1896	%	f	41	6	85	519	2025-06-21 14:37:49.513226	\N
1897	Lists only executable files	f	41	6	85	520	2025-06-21 14:37:49.513226	\N
1898	Lists files in long format	f	41	6	85	520	2025-06-21 14:37:49.513226	\N
1899	Lists all files including hidden ones	t	41	6	85	520	2025-06-21 14:37:49.513226	\N
1900	Lists archive files only	f	41	6	85	520	2025-06-21 14:37:49.513226	\N
1901	Lists only directories	f	41	6	85	520	2025-06-21 14:37:49.513226	\N
1902	Moves into a subdirectory	f	41	6	85	521	2025-06-21 14:37:49.513226	\N
1903	Returns to the root directory	f	41	6	85	521	2025-06-21 14:37:49.513226	\N
1904	Goes one level up in the directory tree	t	41	6	85	521	2025-06-21 14:37:49.513226	\N
1905	Closes the current terminal	f	41	6	85	521	2025-06-21 14:37:49.513226	\N
1906	Deletes the current directory	f	41	6	85	521	2025-06-21 14:37:49.513226	\N
1907	man	t	41	6	85	522	2025-06-21 14:37:49.513226	\N
1908	help	f	41	6	85	522	2025-06-21 14:37:49.513226	\N
1909	manual	f	41	6	85	522	2025-06-21 14:37:49.513226	\N
1910	info	f	41	6	85	522	2025-06-21 14:37:49.513226	\N
1911	doc	f	41	6	85	522	2025-06-21 14:37:49.513226	\N
1912	Parent working directory	f	41	6	85	523	2025-06-21 14:37:49.513226	\N
1913	Previously written directory	f	41	6	85	523	2025-06-21 14:37:49.513226	\N
1914	Present working directory	t	41	6	85	523	2025-06-21 14:37:49.513226	\N
1915	Public web directory	f	41	6	85	523	2025-06-21 14:37:49.513226	\N
1916	Path with depth	f	41	6	85	523	2025-06-21 14:37:49.513226	\N
1917	Compiles source code	f	41	6	85	524	2025-06-21 14:37:49.513226	\N
1918	Launches a text editor	t	41	6	85	524	2025-06-21 14:37:49.513226	\N
1919	Lists files	f	41	6	85	524	2025-06-21 14:37:49.513226	\N
1920	Encrypts a file	f	41	6	85	524	2025-06-21 14:37:49.513226	\N
1921	Runs background tasks	f	41	6	85	524	2025-06-21 14:37:49.513226	\N
1922	erase	f	41	6	85	525	2025-06-21 14:37:49.513226	\N
1923	remove	f	41	6	85	525	2025-06-21 14:37:49.513226	\N
1924	rm	t	41	6	85	525	2025-06-21 14:37:49.513226	\N
1925	del	f	41	6	85	525	2025-06-21 14:37:49.513226	\N
1926	mv	f	41	6	85	525	2025-06-21 14:37:49.513226	\N
1927	Deletes a directory	f	41	6	85	526	2025-06-21 14:37:49.513226	\N
1928	Moves a directory	f	41	6	85	526	2025-06-21 14:37:49.513226	\N
1929	Creates a directory	t	41	6	85	526	2025-06-21 14:37:49.513226	\N
1930	Links a directory	f	41	6	85	526	2025-06-21 14:37:49.513226	\N
1931	Opens a directory	f	41	6	85	526	2025-06-21 14:37:49.513226	\N
1932	>	f	41	6	85	527	2025-06-21 14:37:49.513226	\N
1933	>>	t	41	6	85	527	2025-06-21 14:37:49.513226	\N
1934	<	f	41	6	85	527	2025-06-21 14:37:49.513226	\N
1935	2>	f	41	6	85	527	2025-06-21 14:37:49.513226	\N
1936	!>	f	41	6	85	527	2025-06-21 14:37:49.513226	\N
1937	Cuts first 3 bytes	f	41	6	85	528	2025-06-21 14:37:49.513226	\N
1938	Extracts fields 1 and 3 using comma as delimiter	t	41	6	85	528	2025-06-21 14:37:49.513226	\N
1939	Deletes fields 1 and 3	f	41	6	85	528	2025-06-21 14:37:49.513226	\N
1940	Sorts the file by fields 1 and 3	f	41	6	85	528	2025-06-21 14:37:49.513226	\N
1941	None of the above	f	41	6	85	528	2025-06-21 14:37:49.513226	\N
1942	Finds and deletes file.txt	f	41	6	85	529	2025-06-21 14:37:49.513226	\N
1943	Finds file.txt and redirects standard output to null	f	41	6	85	529	2025-06-21 14:37:49.513226	\N
1944	Finds file.txt and hides error messages	t	41	6	85	529	2025-06-21 14:37:49.513226	\N
1945	Lists only directories	f	41	6	85	529	2025-06-21 14:37:49.513226	\N
1946	Appends results to null	f	41	6	85	529	2025-06-21 14:37:49.513226	\N
1947	Replaces text	f	41	6	85	530	2025-06-21 14:37:49.513226	\N
1948	Deletes lines	f	41	6	85	530	2025-06-21 14:37:49.513226	\N
1949	Searches for 'text' in file.txt	t	41	6	85	530	2025-06-21 14:37:49.513226	\N
1950	Appends text	f	41	6	85	530	2025-06-21 14:37:49.513226	\N
1951	Counts text occurrences	f	41	6	85	530	2025-06-21 14:37:49.513226	\N
1952	Removes all tabs	f	41	6	85	531	2025-06-21 14:37:49.513226	\N
1953	Translates tabs to spaces	f	41	6	85	531	2025-06-21 14:37:49.513226	\N
1954	Squeezes repeated tabs into one	t	41	6	85	531	2025-06-21 14:37:49.513226	\N
1955	Sorts by tabs	f	41	6	85	531	2025-06-21 14:37:49.513226	\N
1956	Substitutes tabs for dashes	f	41	6	85	531	2025-06-21 14:37:49.513226	\N
1957	cat	f	41	6	85	532	2025-06-21 14:37:49.513226	\N
1958	wc	t	41	6	85	532	2025-06-21 14:37:49.513226	\N
1959	cut	f	41	6	85	532	2025-06-21 14:37:49.513226	\N
1960	tr	f	41	6	85	532	2025-06-21 14:37:49.513226	\N
1961	ls	f	41	6	85	532	2025-06-21 14:37:49.513226	\N
1962	Copies input to a file only	f	41	6	85	533	2025-06-21 14:37:49.513226	\N
1963	Reads a file into stdin	f	41	6	85	533	2025-06-21 14:37:49.513226	\N
1964	Sends output to stdout and a file	t	41	6	85	533	2025-06-21 14:37:49.513226	\N
1965	Merges files	f	41	6	85	533	2025-06-21 14:37:49.513226	\N
1966	Deletes output	f	41	6	85	533	2025-06-21 14:37:49.513226	\N
1967	Prints last 5 lines	f	41	6	85	534	2025-06-21 14:37:49.513226	\N
1968	Prints first 5 lines	t	41	6	85	534	2025-06-21 14:37:49.513226	\N
1969	Deletes 5 lines	f	41	6	85	534	2025-06-21 14:37:49.513226	\N
1970	Sorts file.txt	f	41	6	85	534	2025-06-21 14:37:49.513226	\N
1971	Merges 5 lines	f	41	6	85	534	2025-06-21 14:37:49.513226	\N
1972	Sorts and adds line numbers	f	41	6	85	535	2025-06-21 14:37:49.513226	\N
1973	Sorts and removes duplicates	t	41	6	85	535	2025-06-21 14:37:49.513226	\N
1974	Sorts and deletes uppercase	f	41	6	85	535	2025-06-21 14:37:49.513226	\N
1975	Sorts ignoring case	f	41	6	85	535	2025-06-21 14:37:49.513226	\N
1976	Displays unsorted output	f	41	6	85	535	2025-06-21 14:37:49.513226	\N
1977	tar -xvf	f	41	6	85	536	2025-06-21 14:37:49.513226	\N
1978	zip	f	41	6	85	536	2025-06-21 14:37:49.513226	\N
1979	compress	f	41	6	85	536	2025-06-21 14:37:49.513226	\N
1980	tar -cvf	t	41	6	85	536	2025-06-21 14:37:49.513226	\N
1981	gz	f	41	6	85	536	2025-06-21 14:37:49.513226	\N
1982	Minimize power usage	f	41	6	86	537	2025-06-21 14:58:39.865117	\N
1983	Maximize user interactivity	f	41	6	86	537	2025-06-21 14:58:39.865117	\N
1984	Ensure predictable timing	t	41	6	86	537	2025-06-21 14:58:39.865117	\N
1985	Maximize throughput	f	41	6	86	537	2025-06-21 14:58:39.865117	\N
1986	A warning is logged	f	41	6	86	538	2025-06-21 14:58:39.865117	\N
1987	Performance degrades	f	41	6	86	538	2025-06-21 14:58:39.865117	\N
1988	System failure	t	41	6	86	538	2025-06-21 14:58:39.865117	\N
1989	Nothing happens	f	41	6	86	538	2025-06-21 14:58:39.865117	\N
1990	FIFO	f	41	6	86	539	2025-06-21 14:58:39.865117	\N
1991	Shortest Job First	f	41	6	86	539	2025-06-21 14:58:39.865117	\N
1992	Round Robin	t	41	6	86	539	2025-06-21 14:58:39.865117	\N
1993	Multilevel Feedback Queue	f	41	6	86	539	2025-06-21 14:58:39.865117	\N
1994	Deadlock	f	41	6	86	540	2025-06-21 14:58:39.865117	\N
1995	Stack overflow	f	41	6	86	540	2025-06-21 14:58:39.865117	\N
1996	Starvation of low-priority tasks	t	41	6	86	540	2025-06-21 14:58:39.865117	\N
1997	Increased memory usage	f	41	6	86	540	2025-06-21 14:58:39.865117	\N
1998	By giving longer time slices to older jobs	f	41	6	86	541	2025-06-21 14:58:39.865117	\N
1999	By ignoring I/O-bound processes	f	41	6	86	541	2025-06-21 14:58:39.865117	\N
2000	By periodically boosting the priority of waiting jobs	t	41	6	86	541	2025-06-21 14:58:39.865117	\N
2001	It doesn’t – starvation still occurs	f	41	6	86	541	2025-06-21 14:58:39.865117	\N
2002	FIFO order	f	41	6	86	542	2025-06-21 14:58:39.865117	\N
2003	Oldest arrival time	f	41	6	86	542	2025-06-21 14:58:39.865117	\N
2004	Lowest virtual runtime	t	41	6	86	542	2025-06-21 14:58:39.865117	\N
2005	Smallest memory usage	f	41	6	86	542	2025-06-21 14:58:39.865117	\N
2006	A priority hint for the scheduler	t	41	6	86	543	2025-06-21 14:58:39.865117	\N
2007	The amount of memory allocated	f	41	6	86	543	2025-06-21 14:58:39.865117	\N
2008	A signal number for interrupts	f	41	6	86	543	2025-06-21 14:58:39.865117	\N
2009	A process name	f	41	6	86	543	2025-06-21 14:58:39.865117	\N
2010	CPU-bound	f	41	6	86	544	2025-06-21 14:58:39.865117	\N
2011	Processes with low nice values	f	41	6	86	544	2025-06-21 14:58:39.865117	\N
2012	I/O-bound	t	41	6	86	544	2025-06-21 14:58:39.865117	\N
2013	Processes with high memory	f	41	6	86	544	2025-06-21 14:58:39.865117	\N
2014	Binary search tree	f	41	6	86	545	2025-06-21 14:58:39.865117	\N
2015	Red-black tree	t	41	6	86	545	2025-06-21 14:58:39.865117	\N
2016	AVL tree	f	41	6	86	545	2025-06-21 14:58:39.865117	\N
2017	Trie	f	41	6	86	545	2025-06-21 14:58:39.865117	\N
2018	Assigns it high priority	f	41	6	86	546	2025-06-21 14:58:39.865117	\N
2019	Sets its virtual runtime to max	f	41	6	86	546	2025-06-21 14:58:39.865117	\N
2020	Sets its virtual runtime to minimum	t	41	6	86	546	2025-06-21 14:58:39.865117	\N
2021	Blocks it temporarily	f	41	6	86	546	2025-06-21 14:58:39.865117	\N
2022	Wall clock time	f	41	6	86	547	2025-06-21 14:58:39.865117	\N
2023	Simulated execution cycles	f	41	6	86	547	2025-06-21 14:58:39.865117	\N
2024	Scaled measure of how long a task has run	t	41	6	86	547	2025-06-21 14:58:39.865117	\N
2025	Priority value	f	41	6	86	547	2025-06-21 14:58:39.865117	\N
2026	Predictable cache locality	f	41	6	86	548	2025-06-21 14:58:39.865117	\N
2027	Guaranteed shortest completion time	f	41	6	86	548	2025-06-21 14:58:39.865117	\N
2028	Fairness across tasks	t	41	6	86	548	2025-06-21 14:58:39.865117	\N
2029	Maximizes memory bandwidth	f	41	6	86	548	2025-06-21 14:58:39.865117	\N
2030	Requires knowing job duration ahead of time	t	41	6	86	549	2025-06-21 14:58:39.865117	\N
2031	Uses a lot of memory	f	41	6	86	549	2025-06-21 14:58:39.865117	\N
2032	Prioritizes low-nice processes	f	41	6	86	549	2025-06-21 14:58:39.865117	\N
2033	Causes many interrupts	f	41	6	86	549	2025-06-21 14:58:39.865117	\N
2034	It finishes first	f	41	6	86	550	2025-06-21 14:58:39.865117	\N
2035	It continues normally	f	41	6	86	550	2025-06-21 14:58:39.865117	\N
2036	It is preempted	t	41	6	86	550	2025-06-21 14:58:39.865117	\N
2037	It is terminated	f	41	6	86	550	2025-06-21 14:58:39.865117	\N
2038	They use less memory	f	41	6	86	551	2025-06-21 14:58:39.865117	\N
2039	Their virtual runtime grows more slowly	t	41	6	86	551	2025-06-21 14:58:39.865117	\N
2040	They have higher PID numbers	f	41	6	86	551	2025-06-21 14:58:39.865117	\N
2041	They finish quickly	f	41	6	86	551	2025-06-21 14:58:39.865117	\N
2042	Bootloader	f	41	6	87	552	2025-06-21 15:15:31.553812	\N
2043	BIOS	t	41	6	87	552	2025-06-21 15:15:31.553812	\N
2044	Kernel	f	41	6	87	552	2025-06-21 15:15:31.553812	\N
2045	Init process	f	41	6	87	552	2025-06-21 15:15:31.553812	\N
2046	-kernel none	f	41	6	87	553	2025-06-21 15:15:31.553812	\N
2047	-bios none	t	41	6	87	553	2025-06-21 15:15:31.553812	\N
2048	-nographic	f	41	6	87	553	2025-06-21 15:15:31.553812	\N
2049	-machine virt	f	41	6	87	553	2025-06-21 15:15:31.553812	\N
2050	0x00000000	f	41	6	87	554	2025-06-21 15:15:31.553812	\N
2051	0x80000000	t	41	6	87	554	2025-06-21 15:15:31.553812	\N
2052	0x10000000	f	41	6	87	554	2025-06-21 15:15:31.553812	\N
2053	0xFFFFFFF0	f	41	6	87	554	2025-06-21 15:15:31.553812	\N
2054	-m	t	41	6	87	555	2025-06-21 15:15:31.553812	\N
2055	-smp	f	41	6	87	555	2025-06-21 15:15:31.553812	\N
2056	-drive	f	41	6	87	555	2025-06-21 15:15:31.553812	\N
2057	-global	f	41	6	87	555	2025-06-21 15:15:31.553812	\N
2058	Three virtual block devices	f	41	6	87	556	2025-06-21 15:15:31.553812	\N
2059	Three CPU harts (cores)	t	41	6	87	556	2025-06-21 15:15:31.553812	\N
2060	Three megabytes of RAM	f	41	6	87	556	2025-06-21 15:15:31.553812	\N
2061	Kernel version 3.x	f	41	6	87	556	2025-06-21 15:15:31.553812	\N
2062	USB mass-storage device	f	41	6	87	557	2025-06-21 15:15:31.553812	\N
2063	Virtio block device	t	41	6	87	557	2025-06-21 15:15:31.553812	\N
2064	SATA controller	f	41	6	87	557	2025-06-21 15:15:31.553812	\N
2065	NVMe device	f	41	6	87	557	2025-06-21 15:15:31.553812	\N
2066	BIOS	f	41	6	87	558	2025-06-21 15:15:31.553812	\N
2067	Bootloader (e.g., GRUB)	t	41	6	87	558	2025-06-21 15:15:31.553812	\N
2068	Init process	f	41	6	87	558	2025-06-21 15:15:31.553812	\N
2069	Daemon processes	f	41	6	87	558	2025-06-21 15:15:31.553812	\N
2070	systemd or /sbin/init	t	41	6	87	559	2025-06-21 15:15:31.553812	\N
2071	QEMU monitor	f	41	6	87	559	2025-06-21 15:15:31.553812	\N
2072	Bootloader	f	41	6	87	559	2025-06-21 15:15:31.553812	\N
2073	Shell	f	41	6	87	559	2025-06-21 15:15:31.553812	\N
2074	Displays BIOS POST codes	f	41	6	87	560	2025-06-21 15:15:31.553812	\N
2075	Provides a command-line interface to control the emulated machine	t	41	6	87	560	2025-06-21 15:15:31.553812	\N
2076	Shows kernel log messages only	f	41	6	87	560	2025-06-21 15:15:31.553812	\N
2077	Runs guest shell commands directly	f	41	6	87	560	2025-06-21 15:15:31.553812	\N
2078	Starting user applications, then loading the kernel	f	41	6	87	561	2025-06-21 15:15:31.553812	\N
2079	Loading the kernel, initialising hardware, starting background services, launching a shell	t	41	6	87	561	2025-06-21 15:15:31.553812	\N
2080	Formatting the disk and installing the OS	f	41	6	87	561	2025-06-21 15:15:31.553812	\N
2081	Flashing the BIOS, then powering off	f	41	6	87	561	2025-06-21 15:15:31.553812	\N
2082	The passwords of all users	f	41	6	88	562	2025-06-21 15:16:00.538445	\N
2083	All possible user names in the system	f	41	6	88	562	2025-06-21 15:16:00.538445	\N
2084	Permitted operations for every subject–object pair	t	41	6	88	562	2025-06-21 15:16:00.538445	\N
2085	Directory structure of the filesystem	f	41	6	88	562	2025-06-21 15:16:00.538445	\N
2086	Command-line shell	f	41	6	88	563	2025-06-21 15:16:00.538445	\N
2087	Reference monitor	t	41	6	88	563	2025-06-21 15:16:00.538445	\N
2088	Login manager	f	41	6	88	563	2025-06-21 15:16:00.538445	\N
2089	Filesystem driver	f	41	6	88	563	2025-06-21 15:16:00.538445	\N
2090	/etc/group	f	41	6	88	564	2025-06-21 15:16:00.538445	\N
2091	/var/log/passwd	f	41	6	88	564	2025-06-21 15:16:00.538445	\N
2092	/etc/passwd	t	41	6	88	564	2025-06-21 15:16:00.538445	\N
2093	/bin/users	f	41	6	88	564	2025-06-21 15:16:00.538445	\N
2094	admin	f	41	6	88	565	2025-06-21 15:16:00.538445	\N
2095	sudo	f	41	6	88	565	2025-06-21 15:16:00.538445	\N
2096	root	t	41	6	88	565	2025-06-21 15:16:00.538445	\N
2097	system	f	41	6	88	565	2025-06-21 15:16:00.538445	\N
2098	Makes the file executable	f	41	6	88	566	2025-06-21 15:16:00.538445	\N
2099	Gives write permission to everyone	f	41	6	88	566	2025-06-21 15:16:00.538445	\N
2100	Sets read/write for owner, read-only for group and others	t	41	6	88	566	2025-06-21 15:16:00.538445	\N
2101	Removes write permission from owner	f	41	6	88	566	2025-06-21 15:16:00.538445	\N
2102	Grants root access to any user	f	41	6	88	567	2025-06-21 15:16:00.538445	\N
2103	Executes the file with the permissions of its owner	t	41	6	88	567	2025-06-21 15:16:00.538445	\N
2104	Locks file permissions permanently	f	41	6	88	567	2025-06-21 15:16:00.538445	\N
2105	Prevents execution by root	f	41	6	88	567	2025-06-21 15:16:00.538445	\N
2106	chmod	f	41	6	88	568	2025-06-21 15:16:00.538445	\N
2107	chown	f	41	6	88	568	2025-06-21 15:16:00.538445	\N
2108	chgrp	t	41	6	88	568	2025-06-21 15:16:00.538445	\N
2109	passwd	f	41	6	88	568	2025-06-21 15:16:00.538445	\N
2110	/etc/users	f	41	6	88	569	2025-06-21 15:16:00.538445	\N
2111	/etc/groups	f	41	6	88	569	2025-06-21 15:16:00.538445	\N
2112	/etc/group	t	41	6	88	569	2025-06-21 15:16:00.538445	\N
2113	/var/log/group	f	41	6	88	569	2025-06-21 15:16:00.538445	\N
2114	Read (r)	f	41	6	88	570	2025-06-21 15:16:00.538445	\N
2115	Write (w)	f	41	6	88	570	2025-06-21 15:16:00.538445	\N
2116	Execute (x)	t	41	6	88	570	2025-06-21 15:16:00.538445	\N
2117	No permission needed	f	41	6	88	570	2025-06-21 15:16:00.538445	\N
2118	Read-only files	f	41	6	88	571	2025-06-21 15:16:00.538445	\N
2119	Hidden files	f	41	6	88	571	2025-06-21 15:16:00.538445	\N
2120	World-writable files	t	41	6	88	571	2025-06-21 15:16:00.538445	\N
2121	Executable scripts	f	41	6	88	571	2025-06-21 15:16:00.538445	\N
2122	Memory fragmentation	f	41	6	89	572	2025-06-21 15:22:47.041305	\N
2123	Deadlock detection	f	41	6	89	572	2025-06-21 15:22:47.041305	\N
2124	Synchronization and mutual exclusion	t	41	6	89	572	2025-06-21 15:22:47.041305	\N
2125	Code compilation	f	41	6	89	572	2025-06-21 15:22:47.041305	\N
2126	A condition where processes terminate prematurely	f	41	6	89	573	2025-06-21 15:22:47.041305	\N
2127	When process output depends on execution timing	t	41	6	89	573	2025-06-21 15:22:47.041305	\N
2128	A type of compiler error	f	41	6	89	573	2025-06-21 15:22:47.041305	\N
2129	A situation where CPU overheats	f	41	6	89	573	2025-06-21 15:22:47.041305	\N
2130	A section of code that executes last	f	41	6	89	574	2025-06-21 15:22:47.041305	\N
2131	A piece of code that modifies shared resources	t	41	6	89	574	2025-06-21 15:22:47.041305	\N
2132	The entry point of a thread	f	41	6	89	574	2025-06-21 15:22:47.041305	\N
2133	Memory reserved for kernel code	f	41	6	89	574	2025-06-21 15:22:47.041305	\N
2134	It requires semaphores	f	41	6	89	575	2025-06-21 15:22:47.041305	\N
2135	It increases disk usage	f	41	6	89	575	2025-06-21 15:22:47.041305	\N
2136	It wastes CPU cycles	t	41	6	89	575	2025-06-21 15:22:47.041305	\N
2137	It crashes the OS	f	41	6	89	575	2025-06-21 15:22:47.041305	\N
2138	It increments the semaphore	f	41	6	89	576	2025-06-21 15:22:47.041305	\N
2139	It puts a thread to sleep if the semaphore is 0	t	41	6	89	576	2025-06-21 15:22:47.041305	\N
2140	It reboots the process	f	41	6	89	576	2025-06-21 15:22:47.041305	\N
2141	It kills the parent thread	f	41	6	89	576	2025-06-21 15:22:47.041305	\N
2142	Binary semaphore only uses 0 and 1	t	41	6	89	577	2025-06-21 15:22:47.041305	\N
2143	General semaphore has negative values	f	41	6	89	577	2025-06-21 15:22:47.041305	\N
2144	Binary semaphore allows multiple accesses	f	41	6	89	577	2025-06-21 15:22:47.041305	\N
2145	There is no difference	f	41	6	89	577	2025-06-21 15:22:47.041305	\N
2146	Pauses a thread	f	41	6	89	578	2025-06-21 15:22:47.041305	\N
2147	Wakes up a sleeping thread	t	41	6	89	578	2025-06-21 15:22:47.041305	\N
2148	Kills a process	f	41	6	89	578	2025-06-21 15:22:47.041305	\N
2149	Creates a mutex	f	41	6	89	578	2025-06-21 15:22:47.041305	\N
2150	By calling join()	f	41	6	89	579	2025-06-21 15:22:47.041305	\N
2151	By chaining wait/signal with specific initial values	t	41	6	89	579	2025-06-21 15:22:47.041305	\N
2152	By busy waiting	f	41	6	89	579	2025-06-21 15:22:47.041305	\N
2153	Using thread.sleep()	f	41	6	89	579	2025-06-21 15:22:47.041305	\N
2154	0	f	41	6	89	580	2025-06-21 15:22:47.041305	\N
2155	1	f	41	6	89	580	2025-06-21 15:22:47.041305	\N
2156	5	t	41	6	89	580	2025-06-21 15:22:47.041305	\N
2157	10	f	41	6	89	580	2025-06-21 15:22:47.041305	\N
2158	Buffer is full	f	41	6	89	581	2025-06-21 15:22:47.041305	\N
2159	Buffer is empty	f	41	6	89	581	2025-06-21 15:22:47.041305	\N
2160	Space available in the buffer	t	41	6	89	581	2025-06-21 15:22:47.041305	\N
2161	Consumer signal	f	41	6	89	581	2025-06-21 15:22:47.041305	\N
2162	New memory page	f	41	6	89	582	2025-06-21 15:22:47.041305	\N
2163	Full buffer slot	t	41	6	89	582	2025-06-21 15:22:47.041305	\N
2164	Free GPU	f	41	6	89	582	2025-06-21 15:22:47.041305	\N
2165	Lock release	f	41	6	89	582	2025-06-21 15:22:47.041305	\N
2166	Tracks idle threads	f	41	6	89	583	2025-06-21 15:22:47.041305	\N
2167	Counts free GPUs	f	41	6	89	583	2025-06-21 15:22:47.041305	\N
2168	Provides mutual exclusion to shared resource	t	41	6	89	583	2025-06-21 15:22:47.041305	\N
2169	Indicates end of critical section	f	41	6	89	583	2025-06-21 15:22:47.041305	\N
2170	Alan Turing	f	41	6	89	584	2025-06-21 15:22:47.041305	\N
2171	John von Neumann	f	41	6	89	584	2025-06-21 15:22:47.041305	\N
2172	Edsger Dijkstra	t	41	6	89	584	2025-06-21 15:22:47.041305	\N
2173	Ken Thompson	f	41	6	89	584	2025-06-21 15:22:47.041305	\N
2174	Better memory management	f	41	6	89	585	2025-06-21 15:22:47.041305	\N
2175	Easier for concurrent programming	t	41	6	89	585	2025-06-21 15:22:47.041305	\N
2176	Supports GPU control	f	41	6	89	585	2025-06-21 15:22:47.041305	\N
2177	Faster thread creation	f	41	6	89	585	2025-06-21 15:22:47.041305	\N
2178	0	t	41	6	89	586	2025-06-21 15:22:47.041305	\N
2179	1	f	41	6	89	586	2025-06-21 15:22:47.041305	\N
2180	N	f	41	6	89	586	2025-06-21 15:22:47.041305	\N
2181	Undefined	f	41	6	89	586	2025-06-21 15:22:47.041305	\N
2182	A desktop-class general-purpose operating system	f	41	6	90	587	2025-06-24 00:34:18.163888	\N
2183	A command-line shell for embedded processors	f	41	6	90	587	2025-06-24 00:34:18.163888	\N
2184	A real-time kernel designed to run on microcontrollers	t	41	6	90	587	2025-06-24 00:34:18.163888	\N
2185	A networking stack for embedded systems	f	41	6	90	587	2025-06-24 00:34:18.163888	\N
2186	To save power	f	41	6	90	588	2025-06-24 00:34:18.163888	\N
2187	To ensure fairness between applications	f	41	6	90	588	2025-06-24 00:34:18.163888	\N
2188	To meet strict timing requirements predictably	t	41	6	90	588	2025-06-24 00:34:18.163888	\N
2189	To run multiple apps simultaneously like in desktop OS	f	41	6	90	588	2025-06-24 00:34:18.163888	\N
2190	By using time slicing and round-robin scheduling	f	41	6	90	589	2025-06-24 00:34:18.163888	\N
2191	By dynamically re-prioritizing tasks at runtime	f	41	6	90	589	2025-06-24 00:34:18.163888	\N
2192	By allowing users to assign priorities to tasks	t	41	6	90	589	2025-06-24 00:34:18.163888	\N
2193	By running all tasks in parallel	f	41	6	90	589	2025-06-24 00:34:18.163888	\N
2194	An entire application	f	41	6	90	590	2025-06-24 00:34:18.163888	\N
2195	A hardware interrupt handler	f	41	6	90	590	2025-06-24 00:34:18.163888	\N
2196	A thread of execution within the system	t	41	6	90	590	2025-06-24 00:34:18.163888	\N
2197	A compiled binary loaded in Flash memory	f	41	6	90	590	2025-06-24 00:34:18.163888	\N
2198	General Purpose OS can run on microcontrollers	f	41	6	90	591	2025-06-24 00:34:18.163888	\N
2199	Real-Time OS guarantees timing deadlines for tasks	t	41	6	90	591	2025-06-24 00:34:18.163888	\N
2200	General Purpose OS supports embedded networking stacks	f	41	6	90	591	2025-06-24 00:34:18.163888	\N
2201	Real-Time OS always uses graphical user interfaces	f	41	6	90	591	2025-06-24 00:34:18.163888	\N
2202	Task scheduling mechanisms	f	41	6	90	592	2025-06-24 00:34:18.163888	\N
2203	Inter-task communication primitives	f	41	6	90	592	2025-06-24 00:34:18.163888	\N
2204	Full networking stack and GUI	t	41	6	90	592	2025-06-24 00:34:18.163888	\N
2205	Timing and synchronization primitives	f	41	6	90	592	2025-06-24 00:34:18.163888	\N
2206	Because it can only handle a single task	f	41	6	90	593	2025-06-24 00:34:18.163888	\N
2207	Because it focuses only on scheduling, not high-level features	t	41	6	90	593	2025-06-24 00:34:18.163888	\N
2208	Because it runs on Windows only	f	41	6	90	593	2025-06-24 00:34:18.163888	\N
2209	Because it cannot be used in embedded applications	f	41	6	90	593	2025-06-24 00:34:18.163888	\N
2210	High CPU utilization	f	41	6	90	594	2025-06-24 00:34:18.163888	\N
2211	Graphical interface support	f	41	6	90	594	2025-06-24 00:34:18.163888	\N
2212	Predictable and deterministic task execution	t	41	6	90	594	2025-06-24 00:34:18.163888	\N
2213	Multi-user login capabilities	f	41	6	90	594	2025-06-24 00:34:18.163888	\N
2214	Task deadlines	f	41	6	90	595	2025-06-24 00:34:18.163888	\N
2215	External interrupts	f	41	6	90	595	2025-06-24 00:34:18.163888	\N
2216	User interactivity and fairness	t	41	6	90	595	2025-06-24 00:34:18.163888	\N
2217	Hard-coded event priorities	f	41	6	90	595	2025-06-24 00:34:18.163888	\N
2218	Multiple threads are always executed at the same time	f	41	6	90	596	2025-06-24 00:34:18.163888	\N
2219	Only RTOS can support multiple threads	f	41	6	90	596	2025-06-24 00:34:18.163888	\N
2220	Multitasking is achieved by rapidly switching between tasks	t	41	6	90	596	2025-06-24 00:34:18.163888	\N
2221	Schedulers are unnecessary if you have enough memory	f	41	6	90	596	2025-06-24 00:34:18.163888	\N
2222	Large and feature-rich	f	41	6	91	597	2025-06-26 00:28:26.713617	\N
2223	Designed for user-friendliness	f	41	6	91	597	2025-06-26 00:28:26.713617	\N
2224	Deterministic and lightweight	t	41	6	91	597	2025-06-26 00:28:26.713617	\N
2225	Runs on desktop systems only	f	41	6	91	597	2025-06-26 00:28:26.713617	\N
2226	Fastest execution	f	41	6	91	598	2025-06-26 00:28:26.713617	\N
2227	Predictable and timely response	t	41	6	91	598	2025-06-26 00:28:26.713617	\N
2228	Multi-core utilization	f	41	6	91	598	2025-06-26 00:28:26.713617	\N
2229	Random task execution	f	41	6	91	598	2025-06-26 00:28:26.713617	\N
2230	They support multiple users	f	41	6	91	599	2025-06-26 00:28:26.713617	\N
2231	They consume a lot of memory	f	41	6	91	599	2025-06-26 00:28:26.713617	\N
2232	They are small, efficient, and meet timing constraints	t	41	6	91	599	2025-06-26 00:28:26.713617	\N
2233	They use graphical interfaces	f	41	6	91	599	2025-06-26 00:28:26.713617	\N
2234	Process	f	41	6	91	600	2025-06-26 00:28:26.713617	\N
2235	Fiber	f	41	6	91	600	2025-06-26 00:28:26.713617	\N
2236	Task	t	41	6	91	600	2025-06-26 00:28:26.713617	\N
2237	Routine	f	41	6	91	600	2025-06-26 00:28:26.713617	\N
2238	Running all tasks in parallel	f	41	6	91	601	2025-06-26 00:28:26.713617	\N
2239	Quick task switching by the scheduler	t	41	6	91	601	2025-06-26 00:28:26.713617	\N
2240	Using multiple CPUs	f	41	6	91	601	2025-06-26 00:28:26.713617	\N
2241	Assigning tasks to different threads	f	41	6	91	601	2025-06-26 00:28:26.713617	\N
2242	Loads drivers and hardware	f	41	6	91	602	2025-06-26 00:28:26.713617	\N
2243	Decides which task to execute next	t	41	6	91	602	2025-06-26 00:28:26.713617	\N
2244	Executes only background tasks	f	41	6	91	602	2025-06-26 00:28:26.713617	\N
2245	Initializes memory	f	41	6	91	602	2025-06-26 00:28:26.713617	\N
2246	It blocks and yields CPU time to others	t	41	6	91	603	2025-06-26 00:28:26.713617	\N
2247	It restarts execution immediately	f	41	6	91	603	2025-06-26 00:28:26.713617	\N
2248	It is destroyed	f	41	6	91	603	2025-06-26 00:28:26.713617	\N
2249	It becomes the highest priority task	f	41	6	91	603	2025-06-26 00:28:26.713617	\N
2250	Multitasking uses multiple cores; concurrency does not	f	41	6	91	604	2025-06-26 00:28:26.713617	\N
2251	Concurrency means tasks truly run in parallel	f	41	6	91	604	2025-06-26 00:28:26.713617	\N
2252	Multitasking switches tasks rapidly to appear concurrent	t	41	6	91	604	2025-06-26 00:28:26.713617	\N
2253	They are exactly the same	f	41	6	91	604	2025-06-26 00:28:26.713617	\N
2254	Calling a blocking API (e.g. waiting for input)	t	41	6	91	605	2025-06-26 00:28:26.713617	\N
2255	Having the lowest priority	f	41	6	91	605	2025-06-26 00:28:26.713617	\N
2256	Being in an infinite loop	f	41	6	91	605	2025-06-26 00:28:26.713617	\N
2257	Being manually deleted	f	41	6	91	605	2025-06-26 00:28:26.713617	\N
2258	A task you create to do nothing	f	41	6	91	606	2025-06-26 00:28:26.713617	\N
2259	A built-in task that runs only when no others are ready	t	41	6	91	606	2025-06-26 00:28:26.713617	\N
2260	A debugging tool	f	41	6	91	606	2025-06-26 00:28:26.713617	\N
2261	The lowest priority user-defined task	f	41	6	91	606	2025-06-26 00:28:26.713617	\N
2262	To determine execution order when multiple tasks are ready	t	41	6	91	607	2025-06-26 00:28:26.713617	\N
2263	To speed up all tasks equally	f	41	6	91	607	2025-06-26 00:28:26.713617	\N
2264	To avoid task creation overhead	f	41	6	91	607	2025-06-26 00:28:26.713617	\N
2265	To balance memory usage	f	41	6	91	607	2025-06-26 00:28:26.713617	\N
2266	Because it uses more memory	f	41	6	91	608	2025-06-26 00:28:26.713617	\N
2267	Because its deadline is stricter	t	41	6	91	608	2025-06-26 00:28:26.713617	\N
2268	Because it starts later	f	41	6	91	608	2025-06-26 00:28:26.713617	\N
2269	Because it's smaller	f	41	6	91	608	2025-06-26 00:28:26.713617	\N
2270	To avoid stack overflows	f	41	6	91	609	2025-06-26 00:28:26.713617	\N
2271	To keep filters and control outputs stable	t	41	6	91	609	2025-06-26 00:28:26.713617	\N
2272	To reduce power consumption	f	41	6	91	609	2025-06-26 00:28:26.713617	\N
2273	To handle interrupts more easily	f	41	6	91	609	2025-06-26 00:28:26.713617	\N
2274	Running	f	41	6	91	610	2025-06-26 00:28:26.713617	\N
2275	Blocked	t	41	6	91	610	2025-06-26 00:28:26.713617	\N
2276	Ready	f	41	6	91	610	2025-06-26 00:28:26.713617	\N
2277	Idle	f	41	6	91	610	2025-06-26 00:28:26.713617	\N
2278	It terminates and restarts	f	41	6	91	611	2025-06-26 00:28:26.713617	\N
2279	It manually gives up the CPU	t	41	6	91	611	2025-06-26 00:28:26.713617	\N
2280	It increases its priority	f	41	6	91	611	2025-06-26 00:28:26.713617	\N
2281	It goes into blocked state	f	41	6	91	611	2025-06-26 00:28:26.713617	\N
2282	Only one will ever run	f	41	6	91	612	2025-06-26 00:28:26.713617	\N
2283	The RTOS shares CPU time fairly between them	t	41	6	91	612	2025-06-26 00:28:26.713617	\N
2284	They merge into one thread	f	41	6	91	612	2025-06-26 00:28:26.713617	\N
2285	Only the one with lower memory use runs	f	41	6	91	612	2025-06-26 00:28:26.713617	\N
2286	It selects the best memory region for each task	f	41	6	91	613	2025-06-26 00:28:26.713617	\N
2287	It handles timing and task selection based on state and priority	t	41	6	91	613	2025-06-26 00:28:26.713617	\N
2288	It only starts the idle task	f	41	6	91	613	2025-06-26 00:28:26.713617	\N
2289	It swaps in threads randomly	f	41	6	91	613	2025-06-26 00:28:26.713617	\N
2290	The real boot entry point	f	41	6	91	614	2025-06-26 00:28:26.713617	\N
2291	A FreeRTOS task created by the framework	t	41	6	91	614	2025-06-26 00:28:26.713617	\N
2292	An infinite loop handler	f	41	6	91	614	2025-06-26 00:28:26.713617	\N
2293	A task created manually with xTaskCreate()	f	41	6	91	614	2025-06-26 00:28:26.713617	\N
2294	The kernel halts	f	41	6	91	615	2025-06-26 00:28:26.713617	\N
2295	The system restarts	f	41	6	91	615	2025-06-26 00:28:26.713617	\N
2296	The idle task runs	t	41	6	91	615	2025-06-26 00:28:26.713617	\N
2297	All interrupts are disabled	f	41	6	91	615	2025-06-26 00:28:26.713617	\N
2298	To test stack sizes	f	41	6	91	616	2025-06-26 00:28:26.713617	\N
2299	To partition the system into simpler components	t	41	6	91	616	2025-06-26 00:28:26.713617	\N
2300	To reduce code size	f	41	6	91	616	2025-06-26 00:28:26.713617	\N
2301	To keep the CPU constantly busy	f	41	6	91	616	2025-06-26 00:28:26.713617	\N
2303	Return the array directly	f	41	75	93	618	2025-07-22 17:28:20.634885	\N
2304	Return a void*	f	41	75	93	618	2025-07-22 17:28:20.634885	\N
2305	Return a pointer and allocate memory inside the function	t	41	75	93	618	2025-07-22 17:28:20.634885	\N
2306	Use a global variable	f	41	75	93	618	2025-07-22 17:28:20.634885	\N
2307	Local arrays can be safely returned by value	f	41	75	93	619	2025-07-22 17:28:20.634885	\N
2308	You must return a pointer, and the memory must remain valid after function exits	t	41	75	93	619	2025-07-22 17:28:20.634885	\N
2309	Arrays are automatically resized when returned	f	41	75	93	619	2025-07-22 17:28:20.634885	\N
2310	Arrays return their size when returned	f	41	75	93	619	2025-07-22 17:28:20.634885	\N
2311	It works fine	f	41	75	93	620	2025-07-22 17:28:20.634885	\N
2312	It causes a compile error	f	41	75	93	620	2025-07-22 17:28:20.634885	\N
2313	It returns a pointer to freed stack memory (undefined behavior)	t	41	75	93	620	2025-07-22 17:28:20.634885	\N
2314	It copies the entire array	f	41	75	93	620	2025-07-22 17:28:20.634885	\N
2315	Function has no base case	f	41	75	93	621	2025-07-22 17:28:20.634885	\N
2316	Recursive call is unreachable	t	41	75	93	621	2025-07-22 17:28:20.634885	\N
2317	Syntax error	f	41	75	93	621	2025-07-22 17:28:20.634885	\N
2318	It returns the wrong type	f	41	75	93	621	2025-07-22 17:28:20.634885	\N
2319	The function still runs correctly	f	41	75	93	622	2025-07-22 17:28:20.634885	\N
2320	The recursion stops automatically	f	41	75	93	622	2025-07-22 17:28:20.634885	\N
2321	Only the first call’s return value is used	t	41	75	93	622	2025-07-22 17:28:20.634885	\N
2322	Nothing useful is returned from deeper calls	f	41	75	93	622	2025-07-22 17:28:20.634885	\N
2323	It returned the result of fgetc()	f	41	75	93	623	2025-07-22 17:28:20.634885	\N
2324	It ignored the result of the recursive call	t	41	75	93	623	2025-07-22 17:28:20.634885	\N
2325	It was missing a pointer	f	41	75	93	623	2025-07-22 17:28:20.634885	\N
2326	It was inside the wrong control flow	f	41	75	93	623	2025-07-22 17:28:20.634885	\N
2327	It divides the number by 10	f	41	75	93	624	2025-07-22 17:28:20.634885	\N
2328	It retrieves the most significant digit	f	41	75	93	624	2025-07-22 17:28:20.634885	\N
2329	It retrieves the least significant bit	t	41	75	93	624	2025-07-22 17:28:20.634885	\N
2330	It checks if the number is even	f	41	75	93	624	2025-07-22 17:28:20.634885	\N
2331	A file descriptor	f	41	75	93	625	2025-07-22 17:28:20.634885	\N
2332	A FILE* stream	t	41	75	93	625	2025-07-22 17:28:20.634885	\N
2333	An integer	f	41	75	93	625	2025-07-22 17:28:20.634885	\N
2334	The first character of the file	f	41	75	93	625	2025-07-22 17:28:20.634885	\N
2335	if (fopen(...) == 0)	f	41	75	93	626	2025-07-22 17:28:20.634885	\N
2336	if (!fopen(...))	f	41	75	93	626	2025-07-22 17:28:20.634885	\N
2337	if ((file = fopen(...)) == NULL)	t	41	75	93	626	2025-07-22 17:28:20.634885	\N
2338	if (file != NULL)	f	41	75	93	626	2025-07-22 17:28:20.634885	\N
2339	char	f	41	75	93	627	2025-07-22 17:28:20.634885	\N
2340	int	t	41	75	93	627	2025-07-22 17:28:20.634885	\N
2341	char*	f	41	75	93	627	2025-07-22 17:28:20.634885	\N
2342	void	f	41	75	93	627	2025-07-22 17:28:20.634885	\N
2343	To return ASCII codes	f	41	75	93	628	2025-07-22 17:28:20.634885	\N
2344	Because char is too small	f	41	75	93	628	2025-07-22 17:28:20.634885	\N
2345	To distinguish between character values and EOF	t	41	75	93	628	2025-07-22 17:28:20.634885	\N
2346	Because int is faster	f	41	75	93	628	2025-07-22 17:28:20.634885	\N
2347	1 if end of file is reached	t	41	75	93	629	2025-07-22 17:28:20.634885	\N
2348	The last character read	f	41	75	93	629	2025-07-22 17:28:20.634885	\N
2349	The file size	f	41	75	93	629	2025-07-22 17:28:20.634885	\N
2350	The error code	f	41	75	93	629	2025-07-22 17:28:20.634885	\N
2351	It allocates memory on the heap	f	41	75	93	630	2025-07-22 17:28:20.634885	\N
2352	It's not null-terminated	f	41	75	93	630	2025-07-22 17:28:20.634885	\N
2353	The string is in read-only memory and shouldn't be modified	t	41	75	93	630	2025-07-22 17:28:20.634885	\N
2354	It causes a segmentation fault immediately	f	41	75	93	630	2025-07-22 17:28:20.634885	\N
2355	rc is a pointer and cannot be assigned	f	41	75	93	631	2025-07-22 17:28:20.634885	\N
2356	rc is an int and cannot be cast to char* safely	t	41	75	93	631	2025-07-22 17:28:20.634885	\N
2357	buffer is uninitialized	f	41	75	93	631	2025-07-22 17:28:20.634885	\N
2358	rc should have been dereferenced	f	41	75	93	631	2025-07-22 17:28:20.634885	\N
2359	It's perfectly safe	f	41	75	93	632	2025-07-22 17:28:20.634885	\N
2360	It updates the first character	f	41	75	93	632	2025-07-22 17:28:20.634885	\N
2361	It's undefined behavior — might walk into invalid memory	t	41	75	93	632	2025-07-22 17:28:20.634885	\N
2362	It allocates more memory	f	41	75	93	632	2025-07-22 17:28:20.634885	\N
2363	The address of the first char in the string	f	41	75	93	633	2025-07-22 17:28:20.634885	\N
2364	The value of the pointer	f	41	75	93	633	2025-07-22 17:28:20.634885	\N
2365	The address of the pointer variable buffer itself	t	41	75	93	633	2025-07-22 17:28:20.634885	\N
2366	The memory content at buffer	f	41	75	93	633	2025-07-22 17:28:20.634885	\N
2367	printf("%p", &buffer);	f	41	75	93	634	2025-07-22 17:28:20.634885	\N
2368	printf("%p", buffer);	t	41	75	93	634	2025-07-22 17:28:20.634885	\N
2369	printf("%p", *buffer);	f	41	75	93	634	2025-07-22 17:28:20.634885	\N
2370	printf("%d", buffer);	f	41	75	93	634	2025-07-22 17:28:20.634885	\N
2371	To prevent buffer overflows and undefined behavior	t	41	75	93	635	2025-07-22 17:28:20.634885	\N
2372	To simplify printing	f	41	75	93	635	2025-07-22 17:28:20.634885	\N
2373	To allow pointer casting	f	41	75	93	635	2025-07-22 17:28:20.634885	\N
2374	To enable using global variables	f	41	75	93	635	2025-07-22 17:28:20.634885	\N
2375	To make them easier to display	f	41	75	93	636	2025-07-22 17:28:20.634885	\N
2376	Because garbage collection requires it	f	41	75	93	636	2025-07-22 17:28:20.634885	\N
2377	To allow safe sharing across threads and enable optimizations like interning and caching	t	41	75	93	636	2025-07-22 17:28:20.634885	\N
2378	To reduce string length	f	41	75	93	636	2025-07-22 17:28:20.634885	\N
2379	It's faster	f	41	75	93	637	2025-07-22 17:28:20.634885	\N
2380	It supports larger files and avoids overflow	t	41	75	93	637	2025-07-22 17:28:20.634885	\N
2381	It avoids null terminators	f	41	75	93	637	2025-07-22 17:28:20.634885	\N
2382	It’s the only way to print strings	f	41	75	93	637	2025-07-22 17:28:20.634885	\N
2386	Answer 1	t	41	82	96	650	2025-07-26 21:25:04.07915	\N
2387	Answer 2	f	41	82	96	650	2025-07-26 21:25:04.07915	\N
2388	Answer 3	f	41	82	96	650	2025-07-26 21:25:04.07915	\N
2389	Answer 4	f	41	82	96	650	2025-07-26 21:25:04.07915	\N
2390	Answer 5	f	41	82	96	650	2025-07-26 21:25:04.07915	\N
2391	dd	t	41	82	96	651	2025-07-26 22:30:16.298422	\N
2392	dfg	f	41	82	96	651	2025-07-26 22:30:16.298422	\N
2393	Roma	t	41	82	96	652	2025-07-26 22:36:41.597203	\N
2394	Genoa	f	41	82	96	652	2025-07-26 22:36:41.597203	\N
2395	Milan	f	41	82	96	652	2025-07-26 22:36:41.597203	\N
2396	Napoli	f	41	82	96	652	2025-07-26 22:36:41.597203	\N
2397	Torino	f	41	82	96	652	2025-07-26 22:36:41.597203	\N
2398	Blue	t	41	82	96	653	2025-07-27 02:00:57.856673	\N
2399	Green	f	41	82	96	653	2025-07-27 02:00:57.856673	\N
2400	Red	f	41	82	96	653	2025-07-27 02:00:57.856673	\N
2401	Black	f	41	82	96	653	2025-07-27 02:00:57.856673	\N
2402	Dog	f	41	82	96	654	2025-07-27 02:00:57.856673	\N
2403	Cat	t	41	82	96	654	2025-07-27 02:00:57.856673	\N
2404	Cow	f	41	82	96	654	2025-07-27 02:00:57.856673	\N
2405	Duck	f	41	82	96	654	2025-07-27 02:00:57.856673	\N
2406	6	f	41	82	96	655	2025-07-27 02:00:57.856673	\N
2407	8	t	41	82	96	655	2025-07-27 02:00:57.856673	\N
2408	4	f	41	82	96	655	2025-07-27 02:00:57.856673	\N
2409	10	f	41	82	96	655	2025-07-27 02:00:57.856673	\N
2410	Earth	t	41	82	96	656	2025-07-27 02:00:57.856673	\N
2411	Mars	f	41	82	96	656	2025-07-27 02:00:57.856673	\N
2412	Jupiter	f	41	82	96	656	2025-07-27 02:00:57.856673	\N
2413	Venus	f	41	82	96	656	2025-07-27 02:00:57.856673	\N
2414	HTML	f	41	82	96	657	2025-07-27 02:00:57.856673	\N
2415	CSS	t	41	82	96	657	2025-07-27 02:00:57.856673	\N
2416	Python	f	41	82	96	657	2025-07-27 02:00:57.856673	\N
2417	SQL	f	41	82	96	657	2025-07-27 02:00:57.856673	\N
2418	Blue	t	41	82	99	658	2025-07-27 02:04:52.157076	\N
2419	Green	f	41	82	99	658	2025-07-27 02:04:52.157076	\N
2420	Red	f	41	82	99	658	2025-07-27 02:04:52.157076	\N
2421	Black	f	41	82	99	658	2025-07-27 02:04:52.157076	\N
2422	Dog	f	41	82	99	659	2025-07-27 02:04:52.157076	\N
2423	Cat	t	41	82	99	659	2025-07-27 02:04:52.157076	\N
2424	Cow	f	41	82	99	659	2025-07-27 02:04:52.157076	\N
2425	Duck	f	41	82	99	659	2025-07-27 02:04:52.157076	\N
2426	6	f	41	82	99	660	2025-07-27 02:04:52.157076	\N
2427	8	t	41	82	99	660	2025-07-27 02:04:52.157076	\N
2428	4	f	41	82	99	660	2025-07-27 02:04:52.157076	\N
2429	10	f	41	82	99	660	2025-07-27 02:04:52.157076	\N
2430	Earth	t	41	82	99	661	2025-07-27 02:04:52.157076	\N
2431	Mars	f	41	82	99	661	2025-07-27 02:04:52.157076	\N
2432	Jupiter	f	41	82	99	661	2025-07-27 02:04:52.157076	\N
2433	Venus	f	41	82	99	661	2025-07-27 02:04:52.157076	\N
2434	HTML	f	41	82	99	662	2025-07-27 02:04:52.157076	\N
2435	CSS	t	41	82	99	662	2025-07-27 02:04:52.157076	\N
2436	Python	f	41	82	99	662	2025-07-27 02:04:52.157076	\N
2437	SQL	f	41	82	99	662	2025-07-27 02:04:52.157076	\N
2438	Blue	t	41	82	100	663	2025-07-27 02:07:40.101284	\N
2439	Green	f	41	82	100	663	2025-07-27 02:07:40.101284	\N
2440	Red	f	41	82	100	663	2025-07-27 02:07:40.101284	\N
2441	Black	f	41	82	100	663	2025-07-27 02:07:40.101284	\N
2442	Dog	f	41	82	100	664	2025-07-27 02:07:40.101284	\N
2443	Cat	t	41	82	100	664	2025-07-27 02:07:40.101284	\N
2444	Cow	f	41	82	100	664	2025-07-27 02:07:40.101284	\N
2445	Duck	f	41	82	100	664	2025-07-27 02:07:40.101284	\N
2446	6	f	41	82	100	665	2025-07-27 02:07:40.101284	\N
2447	8	t	41	82	100	665	2025-07-27 02:07:40.101284	\N
2448	4	f	41	82	100	665	2025-07-27 02:07:40.101284	\N
2449	10	f	41	82	100	665	2025-07-27 02:07:40.101284	\N
2450	Earth	t	41	82	100	666	2025-07-27 02:07:40.101284	\N
2451	Mars	f	41	82	100	666	2025-07-27 02:07:40.101284	\N
2452	Jupiter	f	41	82	100	666	2025-07-27 02:07:40.101284	\N
2453	Venus	f	41	82	100	666	2025-07-27 02:07:40.101284	\N
2454	HTML	f	41	82	100	667	2025-07-27 02:07:40.101284	\N
2455	CSS	t	41	82	100	667	2025-07-27 02:07:40.101284	\N
2456	Python	f	41	82	100	667	2025-07-27 02:07:40.101284	\N
2457	SQL	f	41	82	100	667	2025-07-27 02:07:40.101284	\N
2458	Blue	t	41	82	101	668	2025-07-27 02:13:33.503166	\N
2459	Green	f	41	82	101	668	2025-07-27 02:13:33.503166	\N
2460	Red	f	41	82	101	668	2025-07-27 02:13:33.503166	\N
2461	Black	f	41	82	101	668	2025-07-27 02:13:33.503166	\N
2462	Dog	f	41	82	101	669	2025-07-27 02:13:33.503166	\N
2463	Cat	t	41	82	101	669	2025-07-27 02:13:33.503166	\N
2464	Cow	f	41	82	101	669	2025-07-27 02:13:33.503166	\N
2465	Duck	f	41	82	101	669	2025-07-27 02:13:33.503166	\N
2466	6	f	41	82	101	670	2025-07-27 02:13:33.503166	\N
2467	8	t	41	82	101	670	2025-07-27 02:13:33.503166	\N
2468	4	f	41	82	101	670	2025-07-27 02:13:33.503166	\N
2469	10	f	41	82	101	670	2025-07-27 02:13:33.503166	\N
2470	Earth	t	41	82	101	671	2025-07-27 02:13:33.503166	\N
2471	Mars	f	41	82	101	671	2025-07-27 02:13:33.503166	\N
2472	Jupiter	f	41	82	101	671	2025-07-27 02:13:33.503166	\N
2473	Venus	f	41	82	101	671	2025-07-27 02:13:33.503166	\N
2474	HTML	f	41	82	101	672	2025-07-27 02:13:33.503166	\N
2475	CSS	t	41	82	101	672	2025-07-27 02:13:33.503166	\N
2476	Python	f	41	82	101	672	2025-07-27 02:13:33.503166	\N
2477	SQL	f	41	82	101	672	2025-07-27 02:13:33.503166	\N
2478	Blue	t	41	82	103	673	2025-07-27 02:16:42.170352	\N
2479	Green	f	41	82	103	673	2025-07-27 02:16:42.170352	\N
2480	Red	f	41	82	103	673	2025-07-27 02:16:42.170352	\N
2481	Black	f	41	82	103	673	2025-07-27 02:16:42.170352	\N
2482	Dog	f	41	82	103	674	2025-07-27 02:16:42.170352	\N
2483	Cat	t	41	82	103	674	2025-07-27 02:16:42.170352	\N
2484	Cow	f	41	82	103	674	2025-07-27 02:16:42.170352	\N
2485	Duck	f	41	82	103	674	2025-07-27 02:16:42.170352	\N
2486	6	f	41	82	103	675	2025-07-27 02:16:42.170352	\N
2487	8	t	41	82	103	675	2025-07-27 02:16:42.170352	\N
2488	4	f	41	82	103	675	2025-07-27 02:16:42.170352	\N
2489	10	f	41	82	103	675	2025-07-27 02:16:42.170352	\N
2490	Earth	t	41	82	103	676	2025-07-27 02:16:42.170352	\N
2491	Mars	f	41	82	103	676	2025-07-27 02:16:42.170352	\N
2492	Jupiter	f	41	82	103	676	2025-07-27 02:16:42.170352	\N
2493	Venus	f	41	82	103	676	2025-07-27 02:16:42.170352	\N
2494	HTML	f	41	82	103	677	2025-07-27 02:16:42.170352	\N
2495	CSS	t	41	82	103	677	2025-07-27 02:16:42.170352	\N
2496	Python	f	41	82	103	677	2025-07-27 02:16:42.170352	\N
2497	SQL	f	41	82	103	677	2025-07-27 02:16:42.170352	\N
2498	Dublin	t	41	82	96	678	2025-07-27 19:57:42.587519	\N
2499	Cork	f	41	82	96	678	2025-07-27 19:57:42.587519	\N
2500	Mayo	f	41	82	96	678	2025-07-27 19:57:42.587519	\N
2501	mm	t	41	82	96	679	2025-07-28 22:08:49.998707	\N
2502	Blue is a color	t	41	82	119	680	2025-07-28 22:10:34.875616	\N
2503	Sky is a color	f	41	82	119	680	2025-07-28 22:10:34.875616	\N
2504	Bogota	t	41	82	120	681	2025-07-28 22:12:56.805741	\N
2505	Paris	f	41	82	120	681	2025-07-28 22:12:56.805741	\N
2506	Rio	f	41	82	120	682	2025-07-28 22:13:40.863582	\N
2507	Sao Paulo	f	41	82	120	682	2025-07-28 22:13:40.863582	\N
2508	Brasilia	t	41	82	120	682	2025-07-28 22:13:40.863582	\N
2509	Boca	f	41	82	120	683	2025-07-28 22:14:32.509995	\N
2510	Buenos Aires	t	41	82	120	683	2025-07-28 22:14:32.509995	\N
2511	Montevideo	f	41	82	120	683	2025-07-28 22:14:32.509995	\N
2512	Santiago	t	41	82	120	684	2025-07-28 22:19:09.839971	\N
2513	Bernabeu	f	41	82	120	684	2025-07-28 22:19:09.839971	\N
2514	Caracas	f	41	82	120	684	2025-07-28 22:19:09.839971	\N
\.


--
-- Data for Name: attempt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attempt (id, attempt_score, user_id, module_id, quiz_id, created_at, updated_at) FROM stdin;
1	11	41	6	4	2025-05-24 21:07:48.519502	\N
2	80	41	6	4	2025-05-25 17:01:04.669007	\N
3	80	41	6	4	2025-05-25 17:11:13.094458	\N
4	80	41	6	4	2025-05-26 00:27:24.000505	\N
5	80	41	6	4	2025-05-26 09:12:50.726875	\N
6	40	41	6	4	2025-05-26 09:21:51.488311	\N
7	50	41	6	4	2025-05-26 09:23:25.862612	\N
8	90	41	6	4	2025-05-26 09:29:04.43391	\N
9	90	41	6	4	2025-05-26 09:33:26.874725	\N
10	90	41	6	4	2025-05-26 09:40:54.667984	\N
11	90	41	6	4	2025-05-26 09:59:49.096088	\N
12	90	41	6	4	2025-05-26 10:02:22.162075	\N
13	100	41	6	4	2025-05-28 01:01:58.26526	\N
14	83	41	8	6	2025-05-29 01:01:35.186939	\N
20	100	41	6	30	2025-05-30 15:56:06.612342	\N
21	92	41	8	6	2025-05-30 22:50:44.291985	\N
22	60	41	8	39	2025-06-01 00:00:02.513174	\N
23	100	41	8	41	2025-06-01 01:09:03.681823	\N
24	80	41	8	39	2025-06-01 11:44:53.114422	\N
25	100	41	6	4	2025-06-03 17:12:55.222657	\N
26	80	41	23	31	2025-06-03 18:00:01.526899	\N
27	80	41	23	31	2025-06-05 09:56:59.060018	\N
28	88	41	8	6	2025-06-06 22:57:29.012931	\N
29	75	41	8	39	2025-06-06 23:02:38.722358	\N
30	80	41	8	41	2025-06-06 23:06:08.401234	\N
31	100	41	6	30	2025-06-07 00:18:46.74378	\N
32	100	41	6	30	2025-06-07 00:24:40.625376	\N
33	55	41	23	32	2025-06-08 17:18:18.099571	\N
41	100	41	6	30	2025-06-08 19:17:44.658449	\N
42	100	41	6	30	2025-06-08 19:25:29.851516	\N
43	80	41	23	33	2025-06-09 16:43:48.430107	\N
44	60	41	23	34	2025-06-09 17:01:34.503716	\N
45	70	41	23	35	2025-06-09 17:14:04.239006	\N
46	55	41	23	36	2025-06-09 17:22:49.44546	\N
47	75	41	23	37	2025-06-09 17:30:12.477049	\N
48	75	41	23	33	2025-06-12 23:41:41.963065	\N
49	60	41	23	34	2025-06-12 23:55:53.9139	\N
50	60	41	8	59	2025-06-17 12:29:51.618512	\N
51	85	41	23	35	2025-06-17 16:58:03.714847	\N
52	60	41	23	36	2025-06-17 23:15:22.052968	\N
53	90	41	23	37	2025-06-17 23:30:40.93433	\N
54	87	41	23	31	2025-06-17 23:36:16.161771	\N
55	80	41	8	41	2025-06-17 23:41:43.153586	\N
56	60	41	8	59	2025-06-18 20:24:59.206791	\N
57	90	41	23	36	2025-06-18 21:07:08.945844	\N
58	85	41	23	33	2025-06-18 21:13:37.123756	\N
59	75	41	23	34	2025-06-18 21:37:36.52403	\N
60	70	41	8	39	2025-06-19 23:24:56.771156	\N
62	93	41	6	76	2025-06-21 18:23:26.494432	\N
63	85	41	6	77	2025-06-21 18:31:34.934168	\N
64	80	41	6	84	2025-06-23 13:01:51.868695	\N
65	80	41	6	85	2025-06-23 13:14:29.30561	\N
66	93	41	6	86	2025-06-23 13:24:57.504447	\N
67	50	41	6	87	2025-06-23 13:42:23.186044	\N
68	50	41	6	88	2025-06-23 13:53:39.260552	\N
69	73	41	6	89	2025-06-23 14:06:50.867669	\N
70	93	41	6	79	2025-06-23 17:21:53.938051	\N
71	100	41	6	80	2025-06-23 18:27:58.533885	\N
72	55	41	23	38	2025-06-23 19:21:03.719335	\N
73	100	41	6	80	2025-06-23 19:29:32.417715	\N
74	47	41	6	81	2025-06-23 19:37:44.915493	\N
75	80	41	6	82	2025-06-23 19:40:55.995159	\N
77	85	41	6	77	2025-06-23 21:23:52.389081	\N
78	100	41	6	76	2025-06-23 21:25:48.771135	\N
79	93	41	8	6	2025-06-23 21:56:51.155891	\N
80	75	41	23	35	2025-06-23 22:02:18.149859	\N
81	80	41	23	37	2025-06-23 22:16:33.901432	\N
82	100	41	6	84	2025-06-23 22:20:03.595696	\N
83	90	41	6	90	2025-06-24 00:37:13.163958	\N
84	95	41	6	85	2025-06-25 11:46:16.445913	\N
85	100	41	6	86	2025-06-25 11:52:40.318223	\N
86	100	41	6	87	2025-06-25 11:58:42.211484	\N
87	80	41	6	88	2025-06-25 12:03:30.977678	\N
88	80	41	6	89	2025-06-25 12:08:19.302445	\N
89	93	41	6	79	2025-06-25 12:13:09.757221	\N
90	80	41	23	38	2025-06-25 12:25:48.103149	\N
91	100	41	6	81	2025-06-25 12:40:35.303558	\N
92	93	41	6	82	2025-06-25 12:43:31.015552	\N
93	90	41	8	59	2025-06-25 13:14:02.572449	\N
94	85	41	23	36	2025-06-25 13:23:28.491706	\N
95	90	41	6	90	2025-06-25 13:37:04.265174	\N
96	100	41	6	91	2025-06-26 09:14:04.906744	\N
97	70	41	6	87	2025-07-03 22:57:33.829224	\N
98	70	41	6	88	2025-07-03 23:10:42.689245	\N
99	85	41	23	38	2025-07-03 23:24:50.900357	\N
100	93	41	6	81	2025-07-03 23:27:35.463697	\N
101	85	41	6	91	2025-07-03 23:33:11.824179	\N
102	93	41	6	80	2025-07-03 23:38:27.721212	\N
103	95	41	6	77	2025-07-03 23:49:47.273511	\N
104	100	41	6	76	2025-07-03 23:52:26.751194	\N
105	85	41	23	34	2025-07-04 00:02:49.697776	\N
106	95	41	6	84	2025-07-04 12:48:03.834925	\N
107	85	41	6	85	2025-07-04 20:33:22.158565	\N
108	93	41	6	86	2025-07-04 22:47:41.970387	\N
109	93	41	6	89	2025-07-04 23:15:22.487845	\N
110	100	41	6	79	2025-07-04 23:36:30.57462	\N
111	87	41	6	82	2025-07-04 23:49:14.494615	\N
112	100	41	6	90	2025-07-04 23:56:30.868867	\N
113	90	41	23	33	2025-07-05 00:09:05.413745	\N
114	87	41	23	31	2025-07-05 00:20:13.401593	\N
115	100	41	8	41	2025-07-05 00:24:35.961402	\N
116	95	41	23	36	2025-07-06 14:50:05.693279	\N
117	70	41	8	59	2025-07-06 15:13:18.65185	\N
118	90	41	23	35	2025-07-10 21:11:47.611191	\N
119	80	41	23	37	2025-07-10 21:25:36.112867	\N
120	100	41	6	87	2025-07-10 21:38:11.704899	\N
121	90	41	6	88	2025-07-10 21:41:49.877442	\N
122	100	41	23	38	2025-07-10 21:53:36.267881	\N
123	100	41	6	81	2025-07-10 21:59:09.355773	\N
125	55	41	75	93	2025-07-22 17:44:29.03099	\N
126	50	41	82	120	2025-07-28 23:17:23.641	\N
127	100	41	82	119	2025-07-28 23:34:02.019	\N
128	25	41	82	120	2025-07-28 23:54:05.038	\N
129	100	41	82	120	2025-07-29 00:15:24.72	\N
130	75	41	82	120	2025-07-29 00:50:14.514	\N
131	50	41	82	120	2025-07-29 00:55:40.802	\N
132	50	41	82	120	2025-07-29 00:56:09.175	\N
133	50	41	82	120	2025-07-29 00:58:04.84	\N
134	75	41	82	120	2025-07-29 01:00:06.876	\N
135	25	41	82	120	2025-07-29 01:02:04.12	\N
136	50	41	82	120	2025-07-29 01:02:31.441	\N
137	25	41	82	120	2025-07-29 01:03:49.977	\N
138	25	41	82	120	2025-07-29 01:07:23.669	\N
139	75	41	82	120	2025-07-29 01:07:55.065	\N
140	25	41	82	120	2025-07-29 01:09:02.164	\N
141	75	41	82	120	2025-08-02 10:15:13.027	\N
142	70	41	6	91	2025-08-02 10:45:01.721	\N
143	100	41	82	120	2025-08-03 00:02:52.842	\N
144	100	41	82	120	2025-08-03 00:06:37.788	\N
145	100	41	82	120	2025-08-03 00:08:58.693	\N
146	25	41	82	120	2025-08-03 00:19:06.732	\N
147	75	41	82	120	2025-08-03 00:22:37.475	\N
148	25	41	82	120	2025-08-03 00:22:57.143	\N
149	25	41	82	120	2025-08-03 00:32:37.12	\N
150	25	41	82	120	2025-08-03 00:43:48.971	\N
151	50	41	82	120	2025-08-03 00:44:28.435	\N
152	50	41	82	120	2025-08-03 00:47:11.704	\N
153	0	41	82	120	2025-08-03 00:49:19.576	\N
154	25	41	82	120	2025-08-03 00:55:13.299	\N
155	25	41	82	120	2025-08-03 00:58:06.889	\N
156	50	41	82	120	2025-08-03 01:02:40.953	\N
157	25	41	82	120	2025-08-03 01:05:27.035	\N
158	50	41	82	120	2025-08-03 01:06:01.633	\N
159	75	41	82	120	2025-08-03 01:06:24.342	\N
160	75	41	82	120	2025-08-03 01:07:11.837	\N
161	0	41	82	120	2025-08-03 01:07:37.935	\N
162	25	41	82	120	2025-08-03 01:07:59.602	\N
163	25	41	82	120	2025-08-03 09:20:11.918	\N
164	25	41	82	120	2025-08-03 09:31:15.196	\N
165	50	41	82	120	2025-08-03 09:46:13.625	\N
166	25	41	82	120	2025-08-03 09:46:45.525	\N
167	25	41	82	120	2025-08-03 09:47:29.644	\N
168	50	41	82	120	2025-08-03 09:55:24.511	\N
169	50	41	82	120	2025-08-03 09:55:58.421	\N
170	25	41	82	120	2025-08-03 09:58:23.616	\N
171	25	41	82	120	2025-08-03 10:00:14.458	\N
172	75	41	8	39	2025-08-03 10:44:51.332	\N
173	53	41	6	89	2025-08-03 21:41:19.933	\N
174	90	41	6	77	2025-08-04 08:51:50.224	\N
175	95	41	23	36	2025-08-06 21:22:05.391	\N
176	80	41	6	88	2025-08-06 22:41:32.585	\N
177	100	41	6	80	2025-08-06 22:43:51.519	\N
178	100	41	6	76	2025-08-06 22:46:52.739	\N
179	95	41	6	84	2025-08-06 22:50:29.395	\N
180	90	41	6	85	2025-08-06 22:57:17.689	\N
181	60	41	6	87	2025-08-06 22:59:46.971	\N
182	100	41	23	38	2025-08-06 23:11:26.626	\N
183	100	41	6	86	2025-08-06 23:14:33.896	\N
184	87	41	6	79	2025-08-06 23:18:07.978	\N
185	93	41	6	82	2025-08-06 23:20:48.935	\N
186	90	41	6	90	2025-08-06 23:23:07.973	\N
187	100	41	6	81	2025-08-06 23:25:15.64	\N
188	80	41	23	34	2025-08-06 23:30:44.947	\N
189	100	41	82	119	2025-08-06 23:31:27.462	\N
190	100	41	82	120	2025-08-06 23:31:44.647	\N
191	60	41	75	93	2025-08-07 10:12:07.323	\N
192	80	41	8	59	2025-08-07 10:15:57.784	\N
\.


--
-- Data for Name: followup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.followup (id, followup_due_date, user_id, module_id, quiz_id, created_at, updated_at) FROM stdin;
26	2025-09-16 11:15:57.907273	41	8	59	2025-06-17 12:29:51.641239	2025-08-07 11:15:57.916424
14	2025-08-24 17:12:55.246847	41	6	4	2025-06-03 17:12:55.252346	\N
9	2025-10-17 19:25:29.878757	41	6	30	2025-05-30 15:56:06.638925	2025-06-08 19:25:29.892869
17	2025-08-04 21:56:51.173232	41	8	6	2025-06-06 22:57:29.048574	2025-06-23 21:56:51.177331
42	2025-08-18 11:45:01.812113	41	6	91	2025-06-26 09:14:04.983077	2025-08-02 11:45:01.82112
21	2025-08-07 00:09:05.42369	41	23	33	2025-06-09 16:43:48.463646	2025-07-05 00:09:05.425522
16	2025-08-12 00:20:13.411351	41	23	31	2025-06-05 09:56:59.143567	2025-07-05 00:20:13.413931
19	2025-08-16 00:24:35.971511	41	8	41	2025-06-06 23:06:08.470082	2025-07-05 00:24:35.973495
23	2025-08-10 21:11:47.676754	41	23	35	2025-06-09 17:14:04.255152	2025-07-10 21:11:47.681603
25	2025-08-16 21:25:36.129759	41	23	37	2025-06-09 17:30:12.481707	2025-07-10 21:25:36.138781
18	2025-09-23 11:44:51.482034	41	8	39	2025-06-06 23:02:38.73856	2025-08-03 11:44:51.495859
35	2025-08-04 22:41:20.05599	41	6	89	2025-06-23 14:06:50.879895	2025-08-03 22:41:20.063557
29	2025-09-12 09:51:50.38726	41	6	77	2025-06-21 18:31:34.959015	2025-08-04 09:51:50.402367
24	2025-08-27 22:22:05.569851	41	23	36	2025-06-09 17:22:49.460799	2025-08-06 22:22:05.584231
34	2025-08-21 23:41:32.689839	41	6	88	2025-06-23 13:53:39.272772	2025-08-06 23:41:32.700355
37	2025-09-20 23:43:51.616301	41	6	80	2025-06-23 18:27:58.551721	2025-08-06 23:43:51.627191
28	2025-09-20 23:46:52.858927	41	6	76	2025-06-21 18:23:26.581569	2025-08-06 23:46:52.867209
30	2025-09-18 23:50:29.48741	41	6	84	2025-06-23 13:01:51.922647	2025-08-06 23:50:29.494709
31	2025-09-17 23:57:17.807667	41	6	85	2025-06-23 13:14:29.321724	2025-08-06 23:57:17.814985
33	2025-08-24 23:59:47.102271	41	6	87	2025-06-23 13:42:23.218006	2025-08-06 23:59:47.109028
38	2025-08-25 00:11:26.707441	41	23	38	2025-06-23 19:21:03.734214	2025-08-07 00:11:26.713612
32	2025-09-21 00:14:33.974211	41	6	86	2025-06-23 13:24:57.51888	2025-08-07 00:14:33.980351
36	2025-09-21 00:18:08.061716	41	6	79	2025-06-23 17:21:54.088033	2025-08-07 00:18:08.067463
40	2025-09-18 00:20:49.020061	41	6	82	2025-06-23 19:40:56.018535	2025-08-07 00:20:49.026165
41	2025-09-21 00:23:08.042991	41	6	90	2025-06-24 00:37:13.176632	2025-08-07 00:23:08.049254
39	2025-08-29 00:25:15.715617	41	6	81	2025-06-23 19:37:44.943797	2025-08-07 00:25:15.722989
22	2025-09-09 00:30:45.047044	41	23	34	2025-06-09 17:01:34.571101	2025-08-07 00:30:45.053212
46	2025-08-13 00:31:27.546696	41	82	119	2025-07-29 00:34:02.065303	2025-08-07 00:31:27.552401
45	2025-08-08 00:31:44.695237	41	82	120	2025-07-29 00:17:23.794012	2025-08-07 00:31:44.703639
44	2025-08-08 11:12:07.494565	41	75	93	2025-07-22 17:44:29.108641	2025-08-07 11:12:07.509707
\.


--
-- Data for Name: module; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.module (id, module_name, user_id, created_at, updated_at) FROM stdin;
6	Introduction to OS	41	2025-05-23 09:55:16.329692	\N
8	Introduction to IOT with ESP-32	41	2025-05-26 16:11:06.396428	\N
2	Computer Networks	41	2025-05-22 00:01:52.562329	2025-05-29 13:37:43.229461
22	Data Structures	41	2025-05-29 17:27:31.314529	\N
23	Algorithms	41	2025-05-29 17:27:31.314529	\N
75	Computer Programming	41	2025-07-22 01:15:28.897255	\N
82	Dummy	41	2025-07-25 14:28:52.583159	\N
83	Dummy 2	41	2025-07-27 19:56:10.679299	\N
\.


--
-- Data for Name: question; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question (id, question_name, user_id, module_id, quiz_id, created_at, updated_at) FROM stdin;
7	What does the li instruction do in RISC-V assembly?	41	6	4	2025-05-23 09:57:51.623149	\N
8	Which register always holds the value 0?	41	6	4	2025-05-23 16:11:13.486409	\N
9	What does the ecall instruction do?	41	6	4	2025-05-23 16:12:47.091158	\N
10	What is the result of slli t0, t1, 2 if t1 = 5?	41	6	4	2025-05-23 16:23:11.974045	\N
11	What is the purpose of the mv instruction?	41	6	4	2025-05-23 16:25:20.351648	\N
12	Which register is used to pass return values from functions?	41	6	4	2025-05-23 16:27:41.206458	\N
13	What does blt t0, t1, label do?	41	6	4	2025-05-23 16:30:35.979432	\N
14	Which instruction would multiply the contents of s1 and s2, storing the result in s0?	41	6	4	2025-05-23 16:39:24.408379	\N
15	Which of these is NOT a standard system call service in RISC-V?	41	6	4	2025-05-23 16:41:50.033027	\N
16	The .asciz \\"Hello\\" directive:	41	2	4	2025-05-23 17:07:07.343815	\N
17	What SRAM stands for?	41	8	6	2025-05-26 16:22:24.857422	\N
18	What is SRAM?	41	8	6	2025-05-26 16:30:05.087641	\N
19	What does RTC stands for?	41	8	6	2025-05-26 17:05:02.916817	\N
20	What is RTC?	41	8	6	2025-05-26 17:11:40.443047	\N
21	How is data transmitted in a wireless system (e.g. Wi-Fi)?	41	8	6	2025-05-26 21:19:57.871698	\N
22	What is modulation?	41	8	6	2025-05-26 22:02:36.67371	\N
23	Why do we use a carrier wave in radio signals (e.g., ASK)?	41	8	6	2025-05-26 23:26:49.42393	\N
24	Which analogy best describes Amplitude Shift Keying (ASK)?	41	8	6	2025-05-26 23:57:26.778181	\N
25	Which analogy best describes Frequency Shift Keying (FSK)?	41	8	6	2025-05-27 00:04:47.485397	\N
26	Which analogy best describes Phase Shift Keying (PSK)?	41	8	6	2025-05-27 00:09:37.937653	\N
27	Which analogy best describes Quadrature Amplitude Modulation (QAM)?	41	8	6	2025-05-27 00:35:31.412101	\N
28	How OFDM (Orthogonal Frequency Division Multiplexing) work?	41	8	6	2025-05-27 10:52:40.733213	\N
29	What does SDU (Service Data Unit) mean?	41	8	6	2025-05-27 12:01:51.248437	\N
30	What does PDU (Protocol Data Unit) mean?	41	8	6	2025-05-27 12:18:39.578342	\N
31	What does an A-MSDU (Aggregated MAC Service Data Unit) do in wireless communication?	41	8	6	2025-05-27 12:27:16.211495	\N
32	What does an A-MPDU (Aggregated MAC Protocol Data Unit) do in wireless communication?	41	8	6	2025-05-27 12:30:29.552792	\N
33	What Does Guard Interval Mean?	41	8	6	2025-05-27 12:36:23.245165	\N
34	What is spectrum in the context of wireless communication?	41	8	6	2025-05-27 14:18:23.221412	\N
35	The 2.4 GHz Wi-Fi spectrum is the most widely used and globally available spectrum for Wi-Fi. What is its range of frequencies?	41	8	6	2025-05-27 14:43:29.291659	\N
36	Why do we need a center frequency for each Wi-Fi channel in the 2.4 GHz band?	41	8	6	2025-05-27 14:50:40.306643	\N
37	Why are only channels 1, 6, and 11 typically used in the 2.4 GHz Wi-Fi band?	41	8	6	2025-05-27 14:53:51.811783	\N
38	What is Bluetooth?	41	8	6	2025-05-27 16:18:56.068763	\N
39	Why would you choose Classic Bluetooth (BR/EDR) over Bluetooth Low Energy (BLE)?	41	8	6	2025-05-27 16:31:05.081294	\N
40	What are ideal use cases for Bluetooth Low Energy (BLE)?	41	8	6	2025-05-27 16:46:27.751516	\N
42	What is the main function of the Baseband layer in Bluetooth communication?	41	8	6	2025-05-27 19:08:15.091914	\N
43	What does L2CAP do?	41	8	6	2025-05-27 19:24:39.461358	\N
44	What is the main purpose of a Synchronous Connection-Oriented (SCO) link in Bluetooth Classic?	41	8	6	2025-05-27 21:58:13.441727	\N
45	What is the main role of the Link Layer (LL) in Bluetooth Low Energy, and how does it differ from Bluetooth Classic?	41	8	6	2025-05-27 22:14:08.082004	\N
46	What is the main role of GAP (Generic Access Profile) in Bluetooth Low Energy (BLE)?	41	8	6	2025-05-27 22:21:26.757569	\N
47	What is the main role of the Attribute Protocol (ATT) in Bluetooth Low Energy (BLE)?	41	8	6	2025-05-27 22:24:48.364365	\N
48	What is the main role of GATT (Generic Attribute Profile) in Bluetooth Low Energy (BLE)?	41	8	6	2025-05-27 22:36:48.512712	\N
49	BLE uses a serial stream model similar to Classic Bluetooth's RFCOMM.	41	8	6	2025-05-27 22:44:48.768638	\N
50	Classic Bluetooth is optimized for continuous, high-bandwidth audio streaming.	41	8	6	2025-05-27 22:48:41.556053	\N
51	BLE supports both advertising and connected communication modes.	41	8	6	2025-05-27 22:49:44.604767	\N
52	Classic Bluetooth has lower protocol overhead than BLE.	41	8	6	2025-05-27 22:50:45.850708	\N
53	BLE is more power-efficient than Classic Bluetooth, making it ideal for battery-powered IoT devices.	41	8	6	2025-05-27 22:51:32.421538	\N
54	Classic Bluetooth is the preferred choice for fitness trackers and smart sensors.	41	8	6	2025-05-27 22:54:29.921464	\N
55	BLE can transfer files and stream high-quality audio more efficiently than Classic Bluetooth.	41	8	6	2025-05-27 23:04:32.633319	\N
56	BLE defines services and characteristics using the Generic Attribute Profile (GATT).	41	8	6	2025-05-27 23:06:13.281642	\N
57	Classic Bluetooth supports advertising for device discovery without a connection.	41	8	6	2025-05-27 23:10:00.575451	\N
58	BLE’s data model is structured and defined around attributes, not byte streams.	41	8	6	2025-05-27 23:14:04.87985	\N
59	What are Bluetooth Class-1, Class-2, and Class-3 transmitters used for?	41	8	6	2025-05-27 23:45:56.249241	\N
60	What is the role of AFH (Adaptive Frequency Hopping) in Bluetooth communication?	41	8	6	2025-05-27 23:50:17.355112	\N
61	What are strapping GPIOs used for in microcontrollers like the ESP32?	41	8	6	2025-05-28 00:16:51.204262	\N
62	What is UART and how does it work in microcontroller communication?	41	8	6	2025-05-28 00:21:34.568774	\N
63	What is SPI (Serial Peripheral Interface)?	41	8	6	2025-05-28 00:27:39.052331	\N
64	What is SDIO (Secure Digital Input Output) used for in embedded systems?	41	8	6	2025-05-28 00:37:20.314638	\N
65	What is I2C(Inter-Integrated Circuit) used for in embedded systems?	41	8	6	2025-05-28 00:41:10.270954	\N
66	How does PWM(Pulse-Width Modulation) control the brightness of an LED?	41	8	6	2025-05-28 10:57:40.149968	\N
67	What is PWM used for in motor control?	41	8	6	2025-05-28 11:07:38.002305	\N
68	What is the purpose of the I2S(Inter-IC Sound) interface in embedded systems?	41	8	6	2025-05-28 11:12:13.112693	\N
69	What is infrared (IR) communication used for in embedded systems?	41	8	6	2025-05-28 11:18:35.004546	\N
70	What is the role of a pulse counter (PCNT) in an embedded system like the ESP32?	41	8	6	2025-05-28 17:08:00.483492	\N
71	What is the function of a GPIO pin on a microcontroller like the ESP32?	41	8	6	2025-05-28 17:14:28.812514	\N
72	What does a capacitive touch sensor do on a microcontroller like the ESP32?	41	8	6	2025-05-28 17:21:31.376284	\N
73	What is the role of an ADC in a microcontroller like the ESP32?	41	8	6	2025-05-28 17:24:17.707221	\N
74	What does a DAC(Digital-to-Analog Converter) do in a microcontroller like the ESP32?	41	8	6	2025-05-28 17:28:33.82342	\N
536	Q20. Which command creates a .tar archive?	41	6	85	2025-06-21 14:37:49.513226	\N
75	What is the main purpose of the Controller Area Network (CAN) protocol?	41	8	6	2025-05-28 17:32:43.457308	\N
76	What is TWAI® on the ESP32, and what is it used for?	41	8	6	2025-05-28 17:35:11.36049	\N
41	How does the Baseband layer differ between Bluetooth Classic (BR/EDR) and Bluetooth Low Energy (BLE)?	41	8	6	2025-05-27 18:35:49.742204	2025-05-30 12:36:16.469514
115	What is the key challenge in making a program do multiple things with a single CPU?	41	6	30	2025-05-30 15:52:55.212508	\N
116	In the “blocking” version of the Pong game, what happens when the user inputs data?	41	6	30	2025-05-30 15:52:55.212508	\N
117	What is the main advantage of the blocking approach?	41	6	30	2025-05-30 15:52:55.212508	\N
118	In the FSM approach, how is user input processed?	41	6	30	2025-05-30 15:52:55.212508	\N
119	What are the three FSM stages in processing keyboard input?	41	6	30	2025-05-30 15:52:55.212508	\N
120	In FSM, what triggers a transition from 'Reading new X' to 'Reading new Y'?	41	6	30	2025-05-30 15:52:55.212508	\N
121	What is a main drawback of FSM-based multitasking?	41	6	30	2025-05-30 15:52:55.212508	\N
122	What is the role of swtch() in coroutines?	41	6	30	2025-05-30 15:52:55.212508	\N
123	In cooperative multitasking, each task has its own:	41	6	30	2025-05-30 15:52:55.212508	\N
124	Which metaphor best describes coroutine multitasking?	41	6	30	2025-05-30 15:52:55.212508	\N
125	What is “execution context”?	41	6	30	2025-05-30 15:52:55.212508	\N
126	Which registers do NOT need to be saved during a context switch?	41	6	30	2025-05-30 15:52:55.212508	\N
127	What happens during a context switch?	41	6	30	2025-05-30 15:52:55.212508	\N
128	What is a downside of using coroutines?	41	6	30	2025-05-30 15:52:55.212508	\N
129	Why must swtch() be placed strategically?	41	6	30	2025-05-30 15:52:55.212508	\N
130	Which of the following functions grows faster asymptotically?	41	23	31	2025-05-30 17:12:15.026211	\N
131	If a loop runs as `for (int i = 1; i < n; i *= 2)`, what is the time complexity?	41	23	31	2025-05-30 17:12:15.026211	\N
132	What is the worst-case time complexity of binary search on a sorted array?	41	23	31	2025-05-30 17:12:15.026211	\N
133	What is the Big-O time complexity of the following nested loop?\nfor (int i = 0; i < n; i++)\n  for (int j = 0; j < n; j++)\n    sum++;	41	23	31	2025-05-30 17:12:15.026211	\N
134	Which of the following has the *best* average-case time complexity for searching?	41	23	31	2025-05-30 17:12:15.026211	\N
135	What is the time complexity of this function?\nvoid func(int n) {\n  for (int i = 0; i < n; i++) {\n    for (int j = i; j < n; j++) {\n      print(i, j);\n    }\n  }\n}	41	23	31	2025-05-30 17:12:15.026211	\N
136	Which of these is **not** an asymptotic notation?	41	23	31	2025-05-30 17:12:15.026211	\N
137	A recursive function that halves `n` in each call has what time complexity?	41	23	31	2025-05-30 17:12:15.026211	\N
138	What is the Big-O time complexity of this code?\nfor (int i = 0; i < n; i++)\n  for (int j = 1; j < n; j *= 2)\n    print(i, j);	41	23	31	2025-05-30 17:12:15.026211	\N
139	What is the time complexity of merging two sorted arrays of size n each?	41	23	31	2025-05-30 17:12:15.026211	\N
140	Which sorting algorithm has a guaranteed worst-case time of O(n log n)?	41	23	31	2025-05-30 17:12:15.026211	\N
141	Which case is the best-case time complexity for Insertion Sort?	41	23	31	2025-05-30 17:12:15.026211	\N
142	Which one of the following complexities is the fastest as n → ∞?	41	23	31	2025-05-30 17:12:15.026211	\N
143	Which algorithm is most likely to have O(n^2) worst-case time?	41	23	31	2025-05-30 17:12:15.026211	\N
144	What is the tightest upper bound on T(n) = 2T(n/2) + n?	41	23	31	2025-05-30 17:12:15.026211	\N
145	Which of the following sorting algorithms is stable?	41	23	32	2025-05-30 21:45:10.359687	\N
146	Which sorting algorithm performs best on nearly sorted data?	41	23	32	2025-05-30 21:45:10.359687	\N
147	What is the worst-case time complexity of Insertion Sort?	41	23	32	2025-05-30 21:45:10.359687	\N
148	In the best case, Insertion Sort performs in _____ time.	41	23	32	2025-05-30 21:45:10.359687	\N
149	Which of the following best describes Selection Sort's approach?	41	23	32	2025-05-30 21:45:10.359687	\N
150	Which line is missing in the following code snippet for Bubble Sort?\n\nfor (int i = 0; i < n - 1; i++) {\n    for (int j = 0; j < n - i - 1; j++) {\n        if (arr[j] > arr[j + 1]) {\n            ________;\n        }\n    }\n}	41	23	32	2025-05-30 21:45:10.359687	\N
151	What is the total number of comparisons in Selection Sort for an array of size n?	41	23	32	2025-05-30 21:45:10.359687	\N
152	Which sorting algorithm adapts to the input when it's nearly sorted?	41	23	32	2025-05-30 21:45:10.359687	\N
213	What does double hashing use to resolve collisions?	41	23	35	2025-05-30 22:00:04.934239	\N
214	If a hash table uses chaining, where are colliding keys stored?	41	23	35	2025-05-30 22:00:04.934239	\N
153	Fill in the missing condition for early termination in Bubble Sort:\n\nboolean swapped = false;\nfor (int i = 0; i < n - 1; i++) {\n    swapped = false;\n    for (int j = 0; j < n - i - 1; j++) {\n        if (arr[j] > arr[j+1]) {\n            swap(arr[j], arr[j+1]);\n            swapped = true;\n        }\n    }\n    if (_________) break;\n}	41	23	32	2025-05-30 21:45:10.359687	\N
154	Which of the following sorts is in-place and stable?	41	23	32	2025-05-30 21:45:10.359687	\N
155	Which of the following real-world analogies matches Insertion Sort?	41	23	32	2025-05-30 21:45:10.359687	\N
156	Which loop control variable must be used in this Insertion Sort loop?\n\nfor (int i = 1; i < n; i++) {\n    int key = arr[i];\n    int j = i - 1;\n    while (j >= 0 && arr[j] > key) {\n        arr[j + 1] = arr[j];\n        j--;\n    }\n    ________;\n}	41	23	32	2025-05-30 21:45:10.359687	\N
157	Which algorithm guarantees exactly n−1 swaps in all cases?	41	23	32	2025-05-30 21:45:10.359687	\N
158	What is the best-case input for Bubble Sort?	41	23	32	2025-05-30 21:45:10.359687	\N
159	Which of the following makes Insertion Sort adaptive?	41	23	32	2025-05-30 21:45:10.359687	\N
160	Which of these sorts does NOT rely on comparisons?	41	23	32	2025-05-30 21:45:10.359687	\N
161	In which case is Selection Sort *better* than Bubble Sort?	41	23	32	2025-05-30 21:45:10.359687	\N
162	Which is the average-case time complexity for all three elementary sorts?	41	23	32	2025-05-30 21:45:10.359687	\N
163	What is the worst-case input for Insertion Sort?	41	23	32	2025-05-30 21:45:10.359687	\N
164	Which sorting algorithm sorts by comparing and *placing* the minimum element at the beginning?	41	23	32	2025-05-30 21:45:10.359687	\N
165	Which sorting algorithm uses a divide-and-conquer approach and always divides the array in half?	41	23	33	2025-05-30 21:51:47.173557	\N
166	Which line completes the recursive Merge Sort algorithm?\n\nmergeSort(arr, l, r):\n    if l < r:\n        m = (l + r) // 2\n        mergeSort(arr, l, m)\n        mergeSort(arr, m+1, r)\n        ________	41	23	33	2025-05-30 21:51:47.173557	\N
167	What is the time complexity of Merge Sort in the best case?	41	23	33	2025-05-30 21:51:47.173557	\N
168	What is the worst-case time complexity of Quick Sort?	41	23	33	2025-05-30 21:51:47.173557	\N
169	Which of these sorting algorithms is not stable?	41	23	33	2025-05-30 21:51:47.173557	\N
170	Which of the following is used in Quick Sort to partition the array?	41	23	33	2025-05-30 21:51:47.173557	\N
171	Which sorting algorithm has the best worst-case time complexity?	41	23	33	2025-05-30 21:51:47.173557	\N
172	Which of the following completes this maxHeapify pseudocode?\n\nmaxHeapify(A, i):\n    l = left(i)\n    r = right(i)\n    largest = i\n    if l < heap_size and A[l] > A[largest]:\n        largest = l\n    if r < heap_size and A[r] > A[largest]:\n        largest = r\n    if largest != i:\n        swap(A[i], A[largest])\n        ________	41	23	33	2025-05-30 21:51:47.173557	\N
173	Which algorithm builds a binary heap from an array?	41	23	33	2025-05-30 21:51:47.173557	\N
174	Quick Sort uses which method to sort elements around the pivot?	41	23	33	2025-05-30 21:51:47.173557	\N
175	Which version of Quick Sort gives the worst performance?	41	23	33	2025-05-30 21:51:47.173557	\N
176	In Merge Sort, merging two sorted subarrays takes:	41	23	33	2025-05-30 21:51:47.173557	\N
177	Which sort is most space-efficient among Merge, Quick, and Heap?	41	23	33	2025-05-30 21:51:47.173557	\N
178	Fill in the line for heapSort:\n\nheapSort(arr):\n    buildMaxHeap(arr)\n    for i = n-1 downto 1:\n        swap(arr[0], arr[i])\n        ________	41	23	33	2025-05-30 21:51:47.173557	\N
179	Which algorithm has a recurrence relation of T(n) = 2T(n/2) + O(n)?	41	23	33	2025-05-30 21:51:47.173557	\N
180	Heap Sort always has time complexity of:	41	23	33	2025-05-30 21:51:47.173557	\N
181	Which is NOT true about Quick Sort?	41	23	33	2025-05-30 21:51:47.173557	\N
182	In which sorting algorithm is a merge function essential?	41	23	33	2025-05-30 21:51:47.173557	\N
183	Which data structure underlies Heap Sort?	41	23	33	2025-05-30 21:51:47.173557	\N
184	What is the time complexity of building a max heap from an array of n elements?	41	23	33	2025-05-30 21:51:47.173557	\N
185	Which of the following best describes the brute-force string matching algorithm?	41	23	34	2025-05-30 21:56:39.93923	\N
186	What is the worst-case time complexity of the brute-force algorithm for searching a pattern of length m in a text of length n?	41	23	34	2025-05-30 21:56:39.93923	\N
187	Which algorithm avoids re-checking characters using a prefix function?	41	23	34	2025-05-30 21:56:39.93923	\N
188	What is the prefix function π[i] in KMP used for?	41	23	34	2025-05-30 21:56:39.93923	\N
189	If the prefix function π = [0,0,1,2,0] for pattern P = "ababc", which of the following is true?	41	23	34	2025-05-30 21:56:39.93923	\N
190	Which of these is the correct missing line to compute the prefix function π for pattern P?\n\nfor i from 1 to m-1:\n    k = π[i - 1]\n    while k > 0 and P[k] != P[i]:\n        k = π[k - 1]\n    if P[k] == P[i]:\n        ________	41	23	34	2025-05-30 21:56:39.93923	\N
191	What is the total time complexity of building the prefix table and scanning the text using KMP?	41	23	34	2025-05-30 21:56:39.93923	\N
192	What is the role of DFA in string matching?	41	23	34	2025-05-30 21:56:39.93923	\N
193	KMP algorithm is most efficient when:	41	23	34	2025-05-30 21:56:39.93923	\N
194	Which property makes KMP better than brute force for certain patterns?	41	23	34	2025-05-30 21:56:39.93923	\N
195	What value is assigned to π[0] in KMP?	41	23	34	2025-05-30 21:56:39.93923	\N
196	Which of the following patterns will generate the most non-zero values in its prefix table?	41	23	34	2025-05-30 21:56:39.93923	\N
197	What happens when a mismatch occurs in KMP after matching k characters?	41	23	34	2025-05-30 21:56:39.93923	\N
198	In DFA-based matching, the transition table has dimensions:	41	23	34	2025-05-30 21:56:39.93923	\N
199	Which is more space-efficient: DFA or KMP?	41	23	34	2025-05-30 21:56:39.93923	\N
200	Which is a correct application of KMP?	41	23	34	2025-05-30 21:56:39.93923	\N
201	In KMP, how does the prefix table improve efficiency?	41	23	34	2025-05-30 21:56:39.93923	\N
202	Which step comes first in applying KMP?	41	23	34	2025-05-30 21:56:39.93923	\N
203	Which of these is false about KMP?	41	23	34	2025-05-30 21:56:39.93923	\N
204	What is the space complexity of KMP?	41	23	34	2025-05-30 21:56:39.93923	\N
205	What is the primary purpose of a hash function in a hash table?	41	23	35	2025-05-30 22:00:04.934239	\N
206	Which of the following is a collision resolution strategy?	41	23	35	2025-05-30 22:00:04.934239	\N
207	What does the term ‘load factor’ refer to in a hash table?	41	23	35	2025-05-30 22:00:04.934239	\N
208	What happens when the load factor of a hash table becomes too high?	41	23	35	2025-05-30 22:00:04.934239	\N
209	Which method resolves collision by probing sequentially?	41	23	35	2025-05-30 22:00:04.934239	\N
210	Which of the following can cause clustering in a hash table?	41	23	35	2025-05-30 22:00:04.934239	\N
211	What is the worst-case time complexity for searching in a hash table with chaining?	41	23	35	2025-05-30 22:00:04.934239	\N
212	Which hash function is best?	41	23	35	2025-05-30 22:00:04.934239	\N
215	What is the average-case time for search in a well-distributed hash table?	41	23	35	2025-05-30 22:00:04.934239	\N
216	Which scenario is most likely to require rehashing?	41	23	35	2025-05-30 22:00:04.934239	\N
217	In open addressing, which technique jumps by square values?	41	23	35	2025-05-30 22:00:04.934239	\N
218	Which of the following is NOT true about chaining?	41	23	35	2025-05-30 22:00:04.934239	\N
219	What is a universal hash function?	41	23	35	2025-05-30 22:00:04.934239	\N
220	In a good hash function, what should be avoided?	41	23	35	2025-05-30 22:00:04.934239	\N
221	Which hash function is used in Java’s `HashMap`?	41	23	35	2025-05-30 22:00:04.934239	\N
222	What is a disadvantage of open addressing?	41	23	35	2025-05-30 22:00:04.934239	\N
223	Which of the following is best for memory efficiency?	41	23	35	2025-05-30 22:00:04.934239	\N
224	What is the initial step in designing a hash table?	41	23	35	2025-05-30 22:00:04.934239	\N
225	What is the main goal of data compression?	41	23	36	2025-05-30 22:05:38.89144	\N
226	Which of the following is a lossless compression algorithm?	41	23	36	2025-05-30 22:05:38.89144	\N
227	In Huffman coding, what property must the codes satisfy?	41	23	36	2025-05-30 22:05:38.89144	\N
228	Which of the following is a greedy algorithm used for compression?	41	23	36	2025-05-30 22:05:38.89144	\N
229	What structure is typically used to construct Huffman codes?	41	23	36	2025-05-30 22:05:38.89144	\N
230	In Huffman coding, what happens to the character with the lowest frequency?	41	23	36	2025-05-30 22:05:38.89144	\N
231	What is entropy in the context of information theory?	41	23	36	2025-05-30 22:05:38.89144	\N
232	Which of the following sequences is most compressible using run-length encoding (RLE)?	41	23	36	2025-05-30 22:05:38.89144	\N
233	What is the average code length of a Huffman code related to?	41	23	36	2025-05-30 22:05:38.89144	\N
234	Which of the following is NOT a property of Huffman codes?	41	23	36	2025-05-30 22:05:38.89144	\N
235	What makes Huffman coding inefficient in some practical situations?	41	23	36	2025-05-30 22:05:38.89144	\N
236	In Huffman coding, how many codes are assigned to each character?	41	23	36	2025-05-30 22:05:38.89144	\N
237	Which compression method encodes frequent substrings as dictionary entries?	41	23	36	2025-05-30 22:05:38.89144	\N
238	What happens when two characters have the same frequency in Huffman coding?	41	23	36	2025-05-30 22:05:38.89144	\N
239	Which technique typically gives better compression than Huffman coding?	41	23	36	2025-05-30 22:05:38.89144	\N
240	Which of the following is a limitation of run-length encoding?	41	23	36	2025-05-30 22:05:38.89144	\N
241	Which of these could help in improving compression ratio?	41	23	36	2025-05-30 22:05:38.89144	\N
242	Which real-world file format uses Huffman coding?	41	23	36	2025-05-30 22:05:38.89144	\N
243	In Huffman coding, what is the depth of the character with highest frequency?	41	23	36	2025-05-30 22:05:38.89144	\N
244	Which of the following can improve compression without changing the algorithm?	41	23	36	2025-05-30 22:05:38.89144	\N
245	Which of the following best describes a greedy algorithm?	41	23	37	2025-05-30 22:06:48.483891	\N
246	Which problem can be solved optimally using a greedy algorithm?	41	23	37	2025-05-30 22:06:48.483891	\N
247	Why does the greedy algorithm work for the fractional knapsack problem?	41	23	37	2025-05-30 22:06:48.483891	\N
248	Which of these problems is commonly solved using a greedy strategy?	41	23	37	2025-05-30 22:06:48.483891	\N
249	Which greedy algorithm is used to find the minimum spanning tree?	41	23	37	2025-05-30 22:06:48.483891	\N
250	In the activity selection problem, how are activities typically sorted to apply a greedy strategy?	41	23	37	2025-05-30 22:06:48.483891	\N
251	What is a necessary condition for a greedy algorithm to be optimal?	41	23	37	2025-05-30 22:06:48.483891	\N
252	Which of the following algorithms is NOT greedy?	41	23	37	2025-05-30 22:06:48.483891	\N
253	In greedy algorithms, once a decision is made:	41	23	37	2025-05-30 22:06:48.483891	\N
254	Which of the following greedy algorithms uses a min-heap?	41	23	37	2025-05-30 22:06:48.483891	\N
255	When is a greedy algorithm most likely to work?	41	23	37	2025-05-30 22:06:48.483891	\N
256	What is the key difference between greedy algorithms and dynamic programming?	41	23	37	2025-05-30 22:06:48.483891	\N
257	Which of the following conditions makes greedy algorithm fail for 0/1 knapsack?	41	23	37	2025-05-30 22:06:48.483891	\N
258	Which greedy algorithm constructs a Huffman tree?	41	23	37	2025-05-30 22:06:48.483891	\N
259	What is the time complexity of building a Huffman Tree with n characters?	41	23	37	2025-05-30 22:06:48.483891	\N
260	The greedy algorithm for activity selection always chooses:	41	23	37	2025-05-30 22:06:48.483891	\N
261	What does the greedy algorithm guarantee?	41	23	37	2025-05-30 22:06:48.483891	\N
262	Which one is a counter-example where greedy fails?	41	23	37	2025-05-30 22:06:48.483891	\N
263	Which real-life problem can be modeled as a greedy algorithm?	41	23	37	2025-05-30 22:06:48.483891	\N
264	Which is NOT true for greedy algorithms?	41	23	37	2025-05-30 22:06:48.483891	\N
265	What is the defining characteristic of problems suitable for dynamic programming?	41	23	38	2025-05-30 22:09:57.84616	\N
266	Which of the following techniques stores solutions to subproblems to avoid recomputation?	41	23	38	2025-05-30 22:09:57.84616	\N
267	What is the time complexity of computing the nth Fibonacci number using memoization?	41	23	38	2025-05-30 22:09:57.84616	\N
268	Which approach is typically used in bottom-up dynamic programming?	41	23	38	2025-05-30 22:09:57.84616	\N
269	What does memoization rely on?	41	23	38	2025-05-30 22:09:57.84616	\N
270	Which dynamic programming problem requires you to find the maximum value using a weight constraint?	41	23	38	2025-05-30 22:09:57.84616	\N
271	In the 0/1 Knapsack problem, each item:	41	23	38	2025-05-30 22:09:57.84616	\N
272	Which dynamic programming technique fills a table starting from smaller subproblems to larger ones?	41	23	38	2025-05-30 22:09:57.84616	\N
273	Which is a classic example of a dynamic programming problem?	41	23	38	2025-05-30 22:09:57.84616	\N
274	Which of the following problems **cannot** be optimally solved with dynamic programming?	41	23	38	2025-05-30 22:09:57.84616	\N
275	When using bottom-up DP to solve 0/1 Knapsack, what are the dimensions of the table?	41	23	38	2025-05-30 22:09:57.84616	\N
276	How does top-down memoization differ from bottom-up tabulation?	41	23	38	2025-05-30 22:09:57.84616	\N
277	What is stored in the DP table for the 0/1 Knapsack problem?	41	23	38	2025-05-30 22:09:57.84616	\N
278	Dynamic programming is most efficient when:	41	23	38	2025-05-30 22:09:57.84616	\N
279	Which of the following is not necessary for a problem to be solved using dynamic programming?	41	23	38	2025-05-30 22:09:57.84616	\N
280	In memoization, what happens when a result is not found in the cache?	41	23	38	2025-05-30 22:09:57.84616	\N
281	Which of the following leads to exponential time if dynamic programming is not applied?	41	23	38	2025-05-30 22:09:57.84616	\N
389	Q8. What does the RISC-V `jal` instruction do?	41	6	77	2025-06-21 13:08:50.156674	\N
282	What data structure is typically used in tabulation-based dynamic programming?	41	23	38	2025-05-30 22:09:57.84616	\N
283	In DP, what is the base case for computing the nth Fibonacci number?	41	23	38	2025-05-30 22:09:57.84616	\N
284	Which version of DP typically consumes more memory?	41	23	38	2025-05-30 22:09:57.84616	\N
285	A development board always includes the microcontroller module.	41	8	39	2025-05-31 23:55:40.209674	\N
286	The ESP32-D0WD-V3 is the SoC located inside the ESP32-WROOM-32 module.	41	8	39	2025-05-31 23:55:40.209674	\N
287	The ESP32-WROOM-32 module includes a USB-to-serial converter chip.	41	8	39	2025-05-31 23:55:40.209674	\N
288	The development board exposes GPIOs from the module through pin headers.	41	8	39	2025-05-31 23:55:40.209674	\N
289	A SoC like the ESP32-D0WD-V3 always includes a metal shield.	41	8	39	2025-05-31 23:55:40.209674	\N
290	The ESP32-WROOM-32 is a microcontroller module that includes a SoC and supporting components.	41	8	39	2025-05-31 23:55:40.209674	\N
291	All ESP32 development boards use the same ESP32 module.	41	8	39	2025-05-31 23:55:40.209674	\N
292	The development board typically includes a USB port and a voltage regulator.	41	8	39	2025-05-31 23:55:40.209674	\N
293	The metal square on the ESP32 development board is the SoC.	41	8	39	2025-05-31 23:55:40.209674	\N
294	The ESP32 SoC includes the Wi-Fi and Bluetooth radio transceivers.	41	8	39	2025-05-31 23:55:40.209674	\N
295	The ESP32 module always includes external PSRAM.	41	8	39	2025-05-31 23:55:40.209674	\N
296	A microcontroller module is a pre-certified unit designed for easy integration.	41	8	39	2025-05-31 23:55:40.209674	\N
297	The ESP32 development board cannot function without an external USB-to-UART adapter.	41	8	39	2025-05-31 23:55:40.209674	\N
298	The ESP32-D0WD-V3 is a full microcontroller system integrated into a single chip.	41	8	39	2025-05-31 23:55:40.209674	\N
299	The development board contains the GPIO breakout, but the actual GPIO functionality comes from the SoC inside the module.	41	8	39	2025-05-31 23:55:40.209674	\N
300	The ESP32-WROOM-32E is a more recent revision of the ESP32-WROOM-32.	41	8	39	2025-05-31 23:55:40.209674	\N
301	The development board always includes a Wi-Fi antenna on the PCB.	41	8	39	2025-05-31 23:55:40.209674	\N
302	ESP32 modules are often used in commercial products because they are pre-certified for RF compliance.	41	8	39	2025-05-31 23:55:40.209674	\N
303	The SoC inside the ESP32 module is responsible for executing user code and managing peripherals.	41	8	39	2025-05-31 23:55:40.209674	\N
304	The development board has its own processor separate from the one in the ESP32 module.	41	8	39	2025-05-31 23:55:40.209674	\N
315	The ESP32 SoC includes a dual-core Xtensa CPU running up to 240 MHz.	41	8	41	2025-06-01 01:01:41.125212	\N
316	The ESP32 SoC contains both ROM and SRAM.	41	8	41	2025-06-01 01:01:41.125212	\N
317	ROM on the ESP32 SoC is used to store user programs permanently.	41	8	41	2025-06-01 01:01:41.125212	\N
318	SRAM on the ESP32 SoC is used for temporary data and the stack.	41	8	41	2025-06-01 01:01:41.125212	\N
319	The ESP32 SoC does not include RTC SRAM.	41	8	41	2025-06-01 01:01:41.125212	\N
320	The ESP32 SoC includes integrated Wi-Fi and Bluetooth (BR/EDR + BLE).	41	8	41	2025-06-01 01:01:41.125212	\N
321	The ESP32 SoC includes GPIO, ADC, DAC, PWM, and UART peripherals.	41	8	41	2025-06-01 01:01:41.125212	\N
322	The ESP32-WROOM-32 module includes the ESP32 SoC, flash memory, crystal oscillator, and RF components.	41	8	41	2025-06-01 01:01:41.125212	\N
323	The ESP32-WROOM-32 module does not include an antenna.	41	8	41	2025-06-01 01:01:41.125212	\N
324	The ESP32 module is designed to be soldered directly onto a custom PCB or placed on a dev board.	41	8	41	2025-06-01 01:01:41.125212	\N
354	What is the typical behavior of a floating GPIO input pin?	41	8	59	2025-06-10 22:59:33.300559	\N
355	What does an internal pull-up resistor do?	41	8	59	2025-06-10 22:59:33.300559	\N
356	With internal pull-up enabled, a button wired to GND will read what value when unpressed?	41	8	59	2025-06-10 22:59:33.300559	\N
357	What transition do we detect to implement edge detection for button press?	41	8	59	2025-06-10 22:59:33.300559	\N
358	Why do we need to debounce a mechanical button?	41	8	59	2025-06-10 22:59:33.300559	\N
359	What is a typical software pattern to toggle a state variable?	41	8	59	2025-06-10 22:59:33.300559	\N
360	What is the purpose of vTaskDelay() inside the main loop?	41	8	59	2025-06-10 22:59:33.300559	\N
361	What does gpio_get_level(GPIO_PIN) return?	41	8	59	2025-06-10 22:59:33.300559	\N
362	Why is using last_but_state helpful?	41	8	59	2025-06-10 22:59:33.300559	\N
363	Which GPIO pin mode is used for a button input?	41	8	59	2025-06-10 22:59:33.300559	\N
367	Q1. What is a binary executable file?	41	6	76	2025-06-21 12:57:50.099204	\N
368	Q2. Which file format is used for executables on Unix/Linux systems?	41	6	76	2025-06-21 12:57:50.099204	\N
369	Q3. What tool translates assembly source files into object files?	41	6	76	2025-06-21 12:57:50.099204	\N
370	Q4. What is the purpose of the `ld` tool in `binutils`?	41	6	76	2025-06-21 12:57:50.099204	\N
371	Q5. Which `.text` section in memory usually stores:	41	6	76	2025-06-21 12:57:50.099204	\N
372	Q6. What is an object file?	41	6	76	2025-06-21 12:57:50.099204	\N
373	Q7. What is the role of `.globl` in assembly?	41	6	76	2025-06-21 12:57:50.099204	\N
374	Q8. What happens during linking?	41	6	76	2025-06-21 12:57:50.099204	\N
375	Q9. What is the benefit of using object files?	41	6	76	2025-06-21 12:57:50.099204	\N
376	Q10. What does `.extern` mean in assembly?	41	6	76	2025-06-21 12:57:50.099204	\N
377	Q11. What is the main advantage of build automation?	41	6	76	2025-06-21 12:57:50.099204	\N
378	Q12. Which tool uses `Makefile` to determine how to build targets?	41	6	76	2025-06-21 12:57:50.099204	\N
379	Q13. In the RARS memory map, which address typically stores program data?	41	6	76	2025-06-21 12:57:50.099204	\N
380	Q14. Which format is commonly used for microcontroller firmware?	41	6	76	2025-06-21 12:57:50.099204	\N
381	Q15. What is the final step in producing an executable program from C code?	41	6	76	2025-06-21 12:57:50.099204	\N
382	Q1. What does the `&` operator do in C?	41	6	77	2025-06-21 13:08:50.156674	\N
383	Q2. What does `*(&a)` return if `a = 5`?	41	6	77	2025-06-21 13:08:50.156674	\N
384	Q3. What is the output of the following?\nint num = 25;\nint *p = &num;\nint *q = p;\nnum = num - 10;\n*q = *q + 5;\nprintf("%d", num);	41	6	77	2025-06-21 13:08:50.156674	\N
385	Q4. What does the keyword `volatile` prevent?	41	6	77	2025-06-21 13:08:50.156674	\N
386	Q5. Why must MMIO pointers be declared `volatile`?	41	6	77	2025-06-21 13:08:50.156674	\N
387	Q6. What happens if multiple tri-state outputs are enabled simultaneously?	41	6	77	2025-06-21 13:08:50.156674	\N
388	Q7. What is the purpose of `.globl` in an assembly file?	41	6	77	2025-06-21 13:08:50.156674	\N
390	Q9. In RISC-V, what register is used to return values from functions?	41	6	77	2025-06-21 13:08:50.156674	\N
391	Q10. How are parameters passed in RISC-V calling convention?	41	6	77	2025-06-21 13:08:50.156674	\N
392	Q11. What must be done before calling a subroutine from inside another subroutine?	41	6	77	2025-06-21 13:08:50.156674	\N
393	Q12. What’s the purpose of `crt0.o`?	41	6	77	2025-06-21 13:08:50.156674	\N
394	Q13. What is the `.bss` section used for?	41	6	77	2025-06-21 13:08:50.156674	\N
395	Q14. Which section contains strings like "Hello World!"?	41	6	77	2025-06-21 13:08:50.156674	\N
396	Q15. What instruction replaces `jr ra` in pseudoinstruction form?	41	6	77	2025-06-21 13:08:50.156674	\N
397	Q16. In the C function `int max(int x, int y)`, where is the result stored before returning?	41	6	77	2025-06-21 13:08:50.156674	\N
398	Q17. What is true about automatic (local) variables?	41	6	77	2025-06-21 13:08:50.156674	\N
399	Q18. What does the RISC-V instruction `mv t0, a0` do?	41	6	77	2025-06-21 13:08:50.156674	\N
400	Q19. Why do we use a linker script?	41	6	77	2025-06-21 13:08:50.156674	\N
401	Q20. What’s the result of linking `crt0.o` and `main.o` into an ELF executable?	41	6	77	2025-06-21 13:08:50.156674	\N
402	Q1. What does the `&` operator do in C?	41	6	78	2025-06-21 13:12:42.145868	\N
403	Q2. What does `*(&a)` return if `a = 5`?	41	6	78	2025-06-21 13:12:42.145868	\N
404	Q3. What is the output of the following?\nint num = 25;\nint *p = &num;\nint *q = p;\nnum = num - 10;\n*q = *q + 5;\nprintf("%d", num);	41	6	78	2025-06-21 13:12:42.145868	\N
405	Q4. What does the keyword `volatile` prevent?	41	6	78	2025-06-21 13:12:42.145868	\N
406	Q5. Why must MMIO pointers be declared `volatile`?	41	6	78	2025-06-21 13:12:42.145868	\N
407	Q6. What happens if multiple tri-state outputs are enabled simultaneously?	41	6	78	2025-06-21 13:12:42.145868	\N
408	Q7. What is the purpose of `.globl` in an assembly file?	41	6	78	2025-06-21 13:12:42.145868	\N
409	Q8. What does the RISC-V `jal` instruction do?	41	6	78	2025-06-21 13:12:42.145868	\N
410	Q9. In RISC-V, what register is used to return values from functions?	41	6	78	2025-06-21 13:12:42.145868	\N
411	Q10. How are parameters passed in RISC-V calling convention?	41	6	78	2025-06-21 13:12:42.145868	\N
412	Q11. What must be done before calling a subroutine from inside another subroutine?	41	6	78	2025-06-21 13:12:42.145868	\N
413	Q12. What’s the purpose of `crt0.o`?	41	6	78	2025-06-21 13:12:42.145868	\N
414	Q13. What is the `.bss` section used for?	41	6	78	2025-06-21 13:12:42.145868	\N
415	Q14. Which section contains strings like "Hello World!"?	41	6	78	2025-06-21 13:12:42.145868	\N
416	Q15. What instruction replaces `jr ra` in pseudoinstruction form?	41	6	78	2025-06-21 13:12:42.145868	\N
417	Q16. In the C function `int max(int x, int y)`, where is the result stored before returning?	41	6	78	2025-06-21 13:12:42.145868	\N
418	Q17. What is true about automatic (local) variables?	41	6	78	2025-06-21 13:12:42.145868	\N
419	Q18. What does the RISC-V instruction `mv t0, a0` do?	41	6	78	2025-06-21 13:12:42.145868	\N
420	Q19. Why do we use a linker script?	41	6	78	2025-06-21 13:12:42.145868	\N
421	Q20. What’s the result of linking `crt0.o` and `main.o` into an ELF executable?	41	6	78	2025-06-21 13:12:42.145868	\N
422	Q1. What is the main limitation of cooperative multitasking?	41	6	79	2025-06-21 13:23:51.091231	\N
423	Q2. What enables preemptive multitasking to forcibly interrupt a process?	41	6	79	2025-06-21 13:23:51.091231	\N
424	Q3. What is a context in the context of multitasking?	41	6	79	2025-06-21 13:23:51.091231	\N
425	Q4. What is a context switch?	41	6	79	2025-06-21 13:23:51.091231	\N
426	Q5. When is a context switch typically triggered in preemptive multitasking?	41	6	79	2025-06-21 13:23:51.091231	\N
427	Q6. What is the role of the scheduler?	41	6	79	2025-06-21 13:23:51.091231	\N
428	Q7. Why is it necessary to save and restore the program counter (PC)?	41	6	79	2025-06-21 13:23:51.091231	\N
429	Q8. Which special instruction is used to return from a trap handler?	41	6	79	2025-06-21 13:23:51.091231	\N
430	Q9. What is the function of mtime and mtimecmp?	41	6	79	2025-06-21 13:23:51.091231	\N
431	Q10. What is stored in mscratch during a trap?	41	6	79	2025-06-21 13:23:51.091231	\N
432	Q11. What does the supervisor mode (privileged mode) ensure?	41	6	79	2025-06-21 13:23:51.091231	\N
433	Q12. How do user-mode programs request OS services?	41	6	79	2025-06-21 13:23:51.091231	\N
434	Q13. What register is used to indicate the system call number?	41	6	79	2025-06-21 13:23:51.091231	\N
435	Q14. Why does preemptive multitasking require hardware support?	41	6	79	2025-06-21 13:23:51.091231	\N
436	Q15. What does process isolation protect against?	41	6	79	2025-06-21 13:23:51.091231	\N
437	Q1. What is the main benefit of virtual memory in an operating system?	41	6	80	2025-06-21 13:37:54.703089	\N
438	Q2. What does the Memory Management Unit (MMU) do?	41	6	80	2025-06-21 13:37:54.703089	\N
439	Q3. What is a page in virtual memory?	41	6	80	2025-06-21 13:37:54.703089	\N
440	Q4. Why are dynamically linked libraries (.so/.dll) beneficial in virtual memory?	41	6	80	2025-06-21 13:37:54.703089	\N
441	Q5. Which of the following is true about virtual address spaces?	41	6	80	2025-06-21 13:37:54.703089	\N
442	Q6. In RISC-V Sv39, how many bits are used for the page offset?	41	6	80	2025-06-21 13:37:54.703089	\N
443	Q7. What does the `satp` register store?	41	6	80	2025-06-21 13:37:54.703089	\N
444	Q8. Why is the Sv39 page table implemented as a 3-level tree?	41	6	80	2025-06-21 13:37:54.703089	\N
445	Q9. What happens if a page table entry is invalid (V = 0)?	41	6	80	2025-06-21 13:37:54.703089	\N
446	Q10. What is the role of the TLB (Translation Lookaside Buffer)?	41	6	80	2025-06-21 13:37:54.703089	\N
447	Q11. What principle makes TLB effective?	41	6	80	2025-06-21 13:37:54.703089	\N
448	Q12. What is page thrashing?	41	6	80	2025-06-21 13:37:54.703089	\N
449	Q13. What does `sfence.vma` do?	41	6	80	2025-06-21 13:37:54.703089	\N
450	Q14. In the RISC-V page table entry, what does the “D” (dirty) flag indicate?	41	6	80	2025-06-21 13:37:54.703089	\N
451	Q15. In RISC-V privilege levels, which mode is the most privileged?	41	6	80	2025-06-21 13:37:54.703089	\N
467	Q1. What is the main benefit of virtual memory in an operating system?	41	6	81	2025-06-21 13:46:47.784456	\N
468	Q2. What does the Memory Management Unit (MMU) do?	41	6	81	2025-06-21 13:46:47.784456	\N
469	Q3. What is a page in virtual memory?	41	6	81	2025-06-21 13:46:47.784456	\N
470	Q4. Why are dynamically linked libraries (.so/.dll) beneficial in virtual memory?	41	6	81	2025-06-21 13:46:47.784456	\N
471	Q5. Which of the following is true about virtual address spaces?	41	6	81	2025-06-21 13:46:47.784456	\N
472	Q6. In RISC-V Sv39, how many bits are used for the page offset?	41	6	81	2025-06-21 13:46:47.784456	\N
473	Q7. What does the `satp` register store?	41	6	81	2025-06-21 13:46:47.784456	\N
474	Q8. Why is the Sv39 page table implemented as a 3-level tree?	41	6	81	2025-06-21 13:46:47.784456	\N
475	Q9. What happens if a page table entry is invalid (V = 0)?	41	6	81	2025-06-21 13:46:47.784456	\N
476	Q10. What is the role of the TLB (Translation Lookaside Buffer)?	41	6	81	2025-06-21 13:46:47.784456	\N
477	Q11. What principle makes TLB effective?	41	6	81	2025-06-21 13:46:47.784456	\N
478	Q12. What is page thrashing?	41	6	81	2025-06-21 13:46:47.784456	\N
479	Q13. What does `sfence.vma` do?	41	6	81	2025-06-21 13:46:47.784456	\N
480	Q14. In the RISC-V page table entry, what does the “D” (dirty) flag indicate?	41	6	81	2025-06-21 13:46:47.784456	\N
481	Q15. In RISC-V privilege levels, which mode is the most privileged?	41	6	81	2025-06-21 13:46:47.784456	\N
482	Q1. What is a block device?	41	6	82	2025-06-21 13:49:40.719898	\N
483	Q2. What is the standard hardware block size on most SSDs and HDDs?	41	6	82	2025-06-21 13:49:40.719898	\N
484	Q3. File systems often use 'software blocks' or clusters. What is their typical size?	41	6	82	2025-06-21 13:49:40.719898	\N
485	Q4. What is stored in a file system’s superblock?	41	6	82	2025-06-21 13:49:40.719898	\N
486	Q5. Which part of a file system stores file metadata but not the name?	41	6	82	2025-06-21 13:49:40.719898	\N
487	Q6. What is an extent?	41	6	82	2025-06-21 13:49:40.719898	\N
488	Q7. How are file names mapped to their actual data in a file system like ext4?	41	6	82	2025-06-21 13:49:40.719898	\N
489	Q8. What command mounts a file system in Linux?	41	6	82	2025-06-21 13:49:40.719898	\N
490	Q9. What does the /proc directory represent in Linux?	41	6	82	2025-06-21 13:49:40.719898	\N
491	Q10. In a directory, what is stored?	41	6	82	2025-06-21 13:49:40.719898	\N
492	Q11. What happens when you delete a file that has hard links?	41	6	82	2025-06-21 13:49:40.719898	\N
493	Q12. Which of these is NOT part of an inode?	41	6	82	2025-06-21 13:49:40.719898	\N
494	Q13. Which of these is a real hardware device file?	41	6	82	2025-06-21 13:49:40.719898	\N
495	Q14. What’s the advantage of matching software block size (4096 bytes) to virtual memory page size?	41	6	82	2025-06-21 13:49:40.719898	\N
496	Q15. What is the purpose of a block allocation bitmap?	41	6	82	2025-06-21 13:49:40.719898	\N
497	Q1. What is the return value of fork() in the child process?	41	6	84	2025-06-21 14:26:56.966806	\N
498	Q2. Which system call causes the current process to be replaced by a new program?	41	6	84	2025-06-21 14:26:56.966806	\N
499	Q3. What does wait(&status) do?	41	6	84	2025-06-21 14:26:56.966806	\N
500	Q4. In Unix, what is a pipe?	41	6	84	2025-06-21 14:26:56.966806	\N
501	Q5. What happens if the exec() system call is successful?	41	6	84	2025-06-21 14:26:56.966806	\N
502	Q6. What does the open() system call return on success?	41	6	84	2025-06-21 14:26:56.966806	\N
503	Q7. Which directory typically contains device pseudo-files in Unix?	41	6	84	2025-06-21 14:26:56.966806	\N
504	Q8. What is the purpose of chdir()?	41	6	84	2025-06-21 14:26:56.966806	\N
505	Q9. Which of the following system calls is responsible for terminating a process?	41	6	84	2025-06-21 14:26:56.966806	\N
506	Q10. In the write(fd, data, num) system call, what does fd represent?	41	6	84	2025-06-21 14:26:56.966806	\N
507	Q11. What does the kill(pid, sig) system call do?	41	6	84	2025-06-21 14:26:56.966806	\N
508	Q12. Which signal is sent by default using `kill(pid)`?	41	6	84	2025-06-21 14:26:56.966806	\N
509	Q13. What is the purpose of the dup2(oldfd, newfd) system call?	41	6	84	2025-06-21 14:26:56.966806	\N
510	Q14. What does execve() do that exec() also does?	41	6	84	2025-06-21 14:26:56.966806	\N
511	Q15. What is the meaning of a negative return value from a system call?	41	6	84	2025-06-21 14:26:56.966806	\N
512	Q16. Which system call is used to change file permissions?	41	6	84	2025-06-21 14:26:56.966806	\N
513	Q17. What does pause() do?	41	6	84	2025-06-21 14:26:56.966806	\N
514	Q18. What is the role of the `read(fd, buf, count)` system call?	41	6	84	2025-06-21 14:26:56.966806	\N
515	Q19. What does the close(fd) system call do?	41	6	84	2025-06-21 14:26:56.966806	\N
516	Q20. Which system call would you use to create a new process?	41	6	84	2025-06-21 14:26:56.966806	\N
517	Q1. What is the dual role of the Unix shell?	41	6	85	2025-06-21 14:37:49.513226	\N
518	Q2. Which of the following shells is the default in Ubuntu?	41	6	85	2025-06-21 14:37:49.513226	\N
519	Q3. Which character starts a comment in a Bash script?	41	6	85	2025-06-21 14:37:49.513226	\N
520	Q4. What is the effect of the command: ls -a ?	41	6	85	2025-06-21 14:37:49.513226	\N
521	Q5. What does the command 'cd ..' do?	41	6	85	2025-06-21 14:37:49.513226	\N
522	Q6. Which command displays the manual page for a command?	41	6	85	2025-06-21 14:37:49.513226	\N
523	Q7. What does 'pwd' display?	41	6	85	2025-06-21 14:37:49.513226	\N
524	Q8. What does 'nano' do in Unix?	41	6	85	2025-06-21 14:37:49.513226	\N
525	Q9. Which command deletes a file in Unix?	41	6	85	2025-06-21 14:37:49.513226	\N
526	Q10. What does 'mkdir dirname' do?	41	6	85	2025-06-21 14:37:49.513226	\N
527	Q11. Which command appends output to an existing file?	41	6	85	2025-06-21 14:37:49.513226	\N
528	Q12. What does 'cut -d "," -f 1,3 file.csv' do?	41	6	85	2025-06-21 14:37:49.513226	\N
529	Q13. What is the effect of 'find / -name file.txt 2>/dev/null'?	41	6	85	2025-06-21 14:37:49.513226	\N
530	Q14. What does 'grep "text" file.txt' do?	41	6	85	2025-06-21 14:37:49.513226	\N
531	Q15. What does 'tr -s "\\t"' do?	41	6	85	2025-06-21 14:37:49.513226	\N
532	Q16. Which command counts lines, words, and characters in a file?	41	6	85	2025-06-21 14:37:49.513226	\N
533	Q17. What does 'tee file' do?	41	6	85	2025-06-21 14:37:49.513226	\N
534	Q18. What does 'head -5 file.txt' do?	41	6	85	2025-06-21 14:37:49.513226	\N
535	Q19. What does 'sort -u file.txt' do?	41	6	85	2025-06-21 14:37:49.513226	\N
537	Q1. What is the key objective of a real-time operating system (RTOS)?	41	6	86	2025-06-21 14:58:39.865117	\N
538	Q2. In a hard real-time system, what is the consequence of missing a deadline?	41	6	86	2025-06-21 14:58:39.865117	\N
539	Q3. Which algorithm gives each process equal CPU time in cycles?	41	6	86	2025-06-21 14:58:39.865117	\N
540	Q4. In naive priority queue scheduling, what issue can occur?	41	6	86	2025-06-21 14:58:39.865117	\N
541	Q5. How does Multilevel Feedback Queue Scheduling prevent starvation?	41	6	86	2025-06-21 14:58:39.865117	\N
542	Q6. What does the Linux Completely Fair Scheduler (CFS) use to determine the next process?	41	6	86	2025-06-21 14:58:39.865117	\N
543	Q7. What is a ‘nice’ value in Linux scheduling?	41	6	86	2025-06-21 14:58:39.865117	\N
544	Q8. Which processes tend to get more CPU time in CFS?	41	6	86	2025-06-21 14:58:39.865117	\N
545	Q9. What kind of tree structure is used in CFS for tracking runnable tasks?	41	6	86	2025-06-21 14:58:39.865117	\N
546	Q10. What does CFS do when a new process is created?	41	6	86	2025-06-21 14:58:39.865117	\N
547	Q11. What is virtual runtime in CFS?	41	6	86	2025-06-21 14:58:39.865117	\N
548	Q12. What is a key benefit of Round Robin scheduling?	41	6	86	2025-06-21 14:58:39.865117	\N
549	Q13. Why might Shortest Job First (SJF) be inefficient in practice?	41	6	86	2025-06-21 14:58:39.865117	\N
550	Q14. What happens to a high-priority process in preemptive scheduling if a higher-priority task arrives?	41	6	86	2025-06-21 14:58:39.865117	\N
551	Q15. Why does CFS favor I/O-bound processes?	41	6	86	2025-06-21 14:58:39.865117	\N
552	Q1. Which firmware component stored in ROM performs hardware initialisation and the power-on self-test (POST)?	41	6	87	2025-06-21 15:15:31.553812	\N
553	Q2. In QEMU, which option tells the emulator to skip the BIOS and load the kernel directly?	41	6	87	2025-06-21 15:15:31.553812	\N
554	Q3. In the sample QEMU command, at which address is the RISC-V kernel loaded into RAM?	41	6	87	2025-06-21 15:15:31.553812	\N
555	Q4. Which QEMU command-line option sets the amount of RAM for the emulated system?	41	6	87	2025-06-21 15:15:31.553812	\N
556	Q5. What does the option “-smp 3” specify in the sample command?	41	6	87	2025-06-21 15:15:31.553812	\N
557	Q6. Which virtual device type is used to expose the disk image fs.img to the guest OS?	41	6	87	2025-06-21 15:15:31.553812	\N
558	Q7. During a typical Linux boot on real hardware, which stage loads the OS kernel from disk into RAM?	41	6	87	2025-06-21 15:15:31.553812	\N
559	Q8. After the kernel finishes initialising subsystems, which user-space process traditionally starts all other programs?	41	6	87	2025-06-21 15:15:31.553812	\N
560	Q9. What is the purpose of the QEMU monitor (Ctrl-a c)?	41	6	87	2025-06-21 15:15:31.553812	\N
561	Q10. In general terms, “booting” a computer involves which sequence of actions?	41	6	87	2025-06-21 15:15:31.553812	\N
562	Q1. What does an access control matrix specify?	41	6	88	2025-06-21 15:16:00.538445	\N
563	Q2. What component checks operations against the access control matrix?	41	6	88	2025-06-21 15:16:00.538445	\N
564	Q3. Which file in Unix-like systems defines user accounts?	41	6	88	2025-06-21 15:16:00.538445	\N
565	Q4. Which user has unrestricted privileges in Unix?	41	6	88	2025-06-21 15:16:00.538445	\N
566	Q5. What does the command 'chmod 644 myfile.txt' do?	41	6	88	2025-06-21 15:16:00.538445	\N
567	Q6. What is the function of the setuid bit on an executable file?	41	6	88	2025-06-21 15:16:00.538445	\N
568	Q7. Which command changes the group ownership of a file?	41	6	88	2025-06-21 15:16:00.538445	\N
569	Q8. Which file lists group memberships in Unix?	41	6	88	2025-06-21 15:16:00.538445	\N
570	Q9. Which permission must be set on a directory to allow searching/browsing inside it?	41	6	88	2025-06-21 15:16:00.538445	\N
571	Q10. What type of files should generally be avoided because they pose security risks?	41	6	88	2025-06-21 15:16:00.538445	\N
572	Q1. What problem do semaphores help solve in concurrent programming?	41	6	89	2025-06-21 15:22:47.041305	\N
573	Q2. What is a race condition?	41	6	89	2025-06-21 15:22:47.041305	\N
574	Q3. What is a critical section?	41	6	89	2025-06-21 15:22:47.041305	\N
575	Q4. Why is busy waiting considered inefficient?	41	6	89	2025-06-21 15:22:47.041305	\N
576	Q5. What does wait(S) do in semaphore logic?	41	6	89	2025-06-21 15:22:47.041305	\N
577	Q6. What is the main difference between a binary semaphore and a general semaphore?	41	6	89	2025-06-21 15:22:47.041305	\N
578	Q7. What does signal(S) do?	41	6	89	2025-06-21 15:22:47.041305	\N
579	Q8. How do semaphores help order execution of threads A > B > C?	41	6	89	2025-06-21 15:22:47.041305	\N
580	Q9. In the GPU-sharing example, what is the initial value of semaphore Sg?	41	6	89	2025-06-21 15:22:47.041305	\N
581	Q10. What condition does the producer wait for in the producer-consumer problem?	41	6	89	2025-06-21 15:22:47.041305	\N
582	Q11. What does the consumer wait for in the producer-consumer pattern?	41	6	89	2025-06-21 15:22:47.041305	\N
583	Q12. What is the role of semaphore Sm in the examples?	41	6	89	2025-06-21 15:22:47.041305	\N
584	Q13. Who invented the concept of semaphores?	41	6	89	2025-06-21 15:22:47.041305	\N
585	Q14. What is the main advantage of monitors over semaphores?	41	6	89	2025-06-21 15:22:47.041305	\N
586	Q15. What is the typical initial value of semaphore Sfull in producer-consumer?	41	6	89	2025-06-21 15:22:47.041305	\N
587	Q1. What best describes FreeRTOS?	41	6	90	2025-06-24 00:34:18.163888	\N
588	Q2. What is the main reason embedded systems use a Real-Time Operating System (RTOS)?	41	6	90	2025-06-24 00:34:18.163888	\N
589	Q3. How does FreeRTOS achieve deterministic behavior?	41	6	90	2025-06-24 00:34:18.163888	\N
590	Q4. In FreeRTOS, what is a 'task'?	41	6	90	2025-06-24 00:34:18.163888	\N
591	Q5. What is the key difference between a General Purpose OS (like Linux) and a Real-Time OS?	41	6	90	2025-06-24 00:34:18.163888	\N
592	Q6. Which of the following is *least* likely to be found in FreeRTOS by default?	41	6	90	2025-06-24 00:34:18.163888	\N
593	Q7. Why is FreeRTOS referred to as a 'real-time kernel' rather than a full RTOS?	41	6	90	2025-06-24 00:34:18.163888	\N
594	Q8. Which characteristic is essential for a scheduler to support hard real-time systems?	41	6	90	2025-06-24 00:34:18.163888	\N
595	Q9. In a general-purpose OS, what often drives the scheduler's decisions?	41	6	90	2025-06-24 00:34:18.163888	\N
596	Q10. Which of the following statements is true about multitasking in an OS?	41	6	90	2025-06-24 00:34:18.163888	\N
597	Q1. What is the primary characteristic of a Real-Time Operating System (RTOS)?	41	6	91	2025-06-26 00:28:26.713617	\N
598	Q2. What does 'deterministic' mean in the context of RTOS?	41	6	91	2025-06-26 00:28:26.713617	\N
599	Q3. Why are RTOSes ideal for embedded systems?	41	6	91	2025-06-26 00:28:26.713617	\N
600	Q4. In FreeRTOS, what is the term used instead of 'thread'?	41	6	91	2025-06-26 00:28:26.713617	\N
601	Q5. What enables multitasking on a single-core system?	41	6	91	2025-06-26 00:28:26.713617	\N
602	Q6. What role does the scheduler play in an RTOS?	41	6	91	2025-06-26 00:28:26.713617	\N
603	Q7. What happens when a task calls vTaskDelay()?	41	6	91	2025-06-26 00:28:26.713617	\N
604	Q8. What is the difference between multitasking and concurrency?	41	6	91	2025-06-26 00:28:26.713617	\N
605	Q9. What causes a task to be 'blocked' in FreeRTOS?	41	6	91	2025-06-26 00:28:26.713617	\N
606	Q10. What is the idle task in FreeRTOS?	41	6	91	2025-06-26 00:28:26.713617	\N
607	Q11. What is the purpose of assigning priorities to tasks?	41	6	91	2025-06-26 00:28:26.713617	\N
608	Q12. Why should the control task be given higher priority than the key handler task?	41	6	91	2025-06-26 00:28:26.713617	\N
609	Q13. Why is regularity in sampling (e.g. 2ms ± 0.5ms) important for control loops?	41	6	91	2025-06-26 00:28:26.713617	\N
610	Q14. Which task state prevents a task from being scheduled until an event occurs?	41	6	91	2025-06-26 00:28:26.713617	\N
611	Q15. What does it mean for a task to 'yield'?	41	6	91	2025-06-26 00:28:26.713617	\N
612	Q16. What happens when two tasks of equal priority are ready to run?	41	6	91	2025-06-26 00:28:26.713617	\N
613	Q17. What is the role of the RTOS kernel in scheduling?	41	6	91	2025-06-26 00:28:26.713617	\N
614	Q18. In ESP-IDF, what is `app_main()`?	41	6	91	2025-06-26 00:28:26.713617	\N
615	Q19. What happens if no user tasks are ready to run in FreeRTOS?	41	6	91	2025-06-26 00:28:26.713617	\N
616	Q20. What is the best reason to use multiple tasks in a FreeRTOS application?	41	6	91	2025-06-26 00:28:26.713617	\N
618	What is the safest and most common way to return an array from a function in C?	41	75	93	2025-07-22 17:28:20.634885	\N
619	Which of the following is true about returning arrays in C?	41	75	93	2025-07-22 17:28:20.634885	\N
620	What happens if you return a local array from a function like this? int* getArray() { int arr[10]; return arr; }	41	75	93	2025-07-22 17:28:20.634885	\N
621	What is the flaw in the following recursive function? int digits(int n) { if (n == 0) return 0; else return 1; int d = digits(n / 10); return d; }	41	75	93	2025-07-22 17:28:20.634885	\N
622	In recursion, if a function doesn’t return the result of the recursive call, what happens?	41	75	93	2025-07-22 17:28:20.634885	\N
623	In the binary-to-decimal recursion bug you had, why did return n; cause the wrong result?	41	75	93	2025-07-22 17:28:20.634885	\N
624	In your fixed version of binaryToDecimal, what role does the % 10 operator play?	41	75	93	2025-07-22 17:28:20.634885	\N
625	What does fopen("file.txt", "r") return?	41	75	93	2025-07-22 17:28:20.634885	\N
626	Which statement correctly checks for file opening errors?	41	75	93	2025-07-22 17:28:20.634885	\N
627	What is the return type of fgetc(FILE *f)?	41	75	93	2025-07-22 17:28:20.634885	\N
628	Why is int used as the return type of fgetc() instead of char?	41	75	93	2025-07-22 17:28:20.634885	\N
629	What does feof(file) return?	41	75	93	2025-07-22 17:28:20.634885	\N
630	Why is char* buffer = ""; dangerous in your original code?	41	75	93	2025-07-22 17:28:20.634885	\N
631	What was wrong with this line? buffer = rc;	41	75	93	2025-07-22 17:28:20.634885	\N
632	What happens when you increment a pointer that points to a string literal?	41	75	93	2025-07-22 17:28:20.634885	\N
633	What does &buffer give you in printf("%p", &buffer);?	41	75	93	2025-07-22 17:28:20.634885	\N
634	Which of the following would correctly print the address of the first character in a string pointed to by buffer?	41	75	93	2025-07-22 17:28:20.634885	\N
635	Why must the size of a string (or buffer) be known before memory allocation or safe pointer navigation?	41	75	93	2025-07-22 17:28:20.634885	\N
636	Why are strings immutable in Java or Python?	41	75	93	2025-07-22 17:28:20.634885	\N
637	In your fixed file-reading code, why does malloc() + realloc() work better than fixed-size arrays?	41	75	93	2025-07-22 17:28:20.634885	\N
641	Q1	41	82	96	2025-07-26 13:12:16.611192	\N
642	CQ	41	82	96	2025-07-26 13:12:22.959095	\N
643	CQ	41	82	96	2025-07-26 13:12:25.054172	\N
644	Q4	41	82	96	2025-07-26 13:12:43.278879	\N
650	Test Quiz with Answers	41	82	96	2025-07-26 21:25:04.07915	\N
651	Fra?	41	82	96	2025-07-26 22:30:16.298422	\N
652	Capitale of Italy	41	82	96	2025-07-26 22:36:41.597203	\N
653	What color is the sky on a clear day?	41	82	96	2025-07-27 02:00:57.856673	\N
654	Which animal says 'meow'?	41	82	96	2025-07-27 02:00:57.856673	\N
655	How many legs does a spider have?	41	82	96	2025-07-27 02:00:57.856673	\N
656	What planet do we live on?	41	82	96	2025-07-27 02:00:57.856673	\N
657	Which language is primarily used to style websites?	41	82	96	2025-07-27 02:00:57.856673	\N
658	What color is the sky on a clear day?	41	82	99	2025-07-27 02:04:52.157076	\N
659	Which animal says 'meow'?	41	82	99	2025-07-27 02:04:52.157076	\N
660	How many legs does a spider have?	41	82	99	2025-07-27 02:04:52.157076	\N
661	What planet do we live on?	41	82	99	2025-07-27 02:04:52.157076	\N
662	Which language is primarily used to style websites?	41	82	99	2025-07-27 02:04:52.157076	\N
663	What color is the sky on a clear day?	41	82	100	2025-07-27 02:07:40.101284	\N
664	Which animal says 'meow'?	41	82	100	2025-07-27 02:07:40.101284	\N
665	How many legs does a spider have?	41	82	100	2025-07-27 02:07:40.101284	\N
666	What planet do we live on?	41	82	100	2025-07-27 02:07:40.101284	\N
667	Which language is primarily used to style websites?	41	82	100	2025-07-27 02:07:40.101284	\N
668	What color is the sky on a clear day?	41	82	101	2025-07-27 02:13:33.503166	\N
669	Which animal says 'meow'?	41	82	101	2025-07-27 02:13:33.503166	\N
670	How many legs does a spider have?	41	82	101	2025-07-27 02:13:33.503166	\N
671	What planet do we live on?	41	82	101	2025-07-27 02:13:33.503166	\N
672	Which language is primarily used to style websites?	41	82	101	2025-07-27 02:13:33.503166	\N
673	What color is the sky on a clear day?	41	82	103	2025-07-27 02:16:42.170352	\N
674	Which animal says 'meow'?	41	82	103	2025-07-27 02:16:42.170352	\N
675	How many legs does a spider have?	41	82	103	2025-07-27 02:16:42.170352	\N
676	What planet do we live on?	41	82	103	2025-07-27 02:16:42.170352	\N
677	Which language is primarily used to style websites?	41	82	103	2025-07-27 02:16:42.170352	\N
678	What is the capital of Ireland	41	82	96	2025-07-27 19:57:42.587519	\N
679	kgk	41	82	96	2025-07-28 22:08:49.998707	\N
680	Q1	41	82	119	2025-07-28 22:10:34.875616	\N
681	Colombia?	41	82	120	2025-07-28 22:12:56.805741	\N
682	Brazil	41	82	120	2025-07-28 22:13:40.863582	\N
683	Argentina?	41	82	120	2025-07-28 22:14:32.509995	\N
684	Chile?	41	82	120	2025-07-28 22:19:09.839971	\N
\.


--
-- Data for Name: quiz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz (id, quiz_name, user_id, module_id, created_at, updated_at, repetitions, "interval", ease_factor, next_due, last_score) FROM stdin;
34	String Matching	41	23	2025-05-30 21:53:19.303402	2025-08-07 00:30:45.045361	5	33	1.7199999999999998	2025-09-09 00:30:45.047044	80
96	Quiz 1	41	82	2025-07-25 15:48:57.696453	\N	0	0	2.5	\N	0
97	Quiz 2	41	82	2025-07-25 15:53:04.808042	\N	0	0	2.5	\N	0
98	Quiz 3	41	82	2025-07-25 16:48:09.96131	\N	0	0	2.5	\N	0
91	5.2 RTOS Fundamentals	41	6	2025-06-26 00:27:27.100057	2025-08-02 11:45:01.80995	3	16	2.46	2025-08-18 11:45:01.812113	70
76	1.2 RISC-V Development Tools	41	6	2025-06-21 12:49:17.972137	2025-08-06 23:46:52.85716	4	45	2.9000000000000004	2025-09-20 23:46:52.858927	100
99	Quiz 4	41	82	2025-07-25 16:50:01.796612	\N	0	0	2.5	\N	0
84	3.1 Unix System Call & OS Interface	41	6	2025-06-21 14:17:40.0298	2025-08-06 23:50:29.485361	4	43	2.8000000000000003	2025-09-18 23:50:29.48741	95
85	3.2 OS Interfaces - Shell	41	6	2025-06-21 14:17:40.0298	2025-08-06 23:57:17.804367	4	42	2.7	2025-09-17 23:57:17.807667	90
119	New Quiz	41	82	2025-07-28 22:10:11.289131	2025-08-07 00:31:27.544866	2	6	2.7	2025-08-13 00:31:27.546696	100
100	QUiz 5	41	82	2025-07-25 16:52:07.017877	\N	0	0	2.5	\N	0
101	Quiz 6	41	82	2025-07-25 16:54:25.589498	\N	0	0	2.5	\N	0
102	QUiz 7	41	82	2025-07-25 16:55:43.19893	\N	0	0	2.5	\N	0
103	Quiz 8	41	82	2025-07-25 16:57:30.703428	\N	0	0	2.5	\N	0
104	Quiz 10	41	82	2025-07-25 16:58:05.380635	\N	0	0	2.5	\N	0
105	Q1	41	82	2025-07-25 17:10:03.292848	\N	0	0	2.5	\N	0
87	4.2 OS Bootstrapping	41	6	2025-06-21 14:17:40.0298	2025-08-06 23:59:47.100205	4	18	1.4400000000000004	2025-08-24 23:59:47.102271	60
4	1.1 RISC-V Assembly Language	41	6	2025-05-23 09:55:58.273396	2025-06-21 12:33:51.59061	7	82	2.0000000000000004	2025-08-24 17:12:55.246847	100
30	2.1 Cooperative Multitasking & Execution Context	41	6	2025-05-30 15:49:13.528732	2025-06-21 12:37:35.318309	5	131	3.0000000000000004	2025-10-17 19:25:29.878757	100
78	2.2 Computer Architecture and Interrupts	41	6	2025-06-21 12:49:17.972137	\N	0	0	2.5	\N	0
106	Q2	41	82	2025-07-25 17:10:47.302417	\N	0	0	2.5	\N	0
120	Capital cities of South America	41	82	2025-07-28 22:11:38.746764	2025-08-07 00:31:44.693452	1	1	1.4000000000000001	2025-08-08 00:31:44.695237	100
93	Labs weeks 2-5	41	75	2025-07-22 17:27:47.715	2025-08-07 11:12:07.490488	1	1	1.3800000000000001	2025-08-08 11:12:07.494565	60
32	Elementary Sorting Algorithms	41	23	2025-05-30 21:45:05.746942	2025-06-08 17:18:18.116295	0	1	1.7000000000000002	2025-06-09 17:18:18.117277	55
107	Q5	41	82	2025-07-25 17:17:04.428009	\N	0	0	2.5	\N	0
108	QUIZ 6	41	82	2025-07-25 17:17:45.235983	\N	0	0	2.5	\N	0
6	ESP32 & IoT Foundations: Communication, Peripherals, and Wireless	41	8	2025-05-26 16:17:34.604512	2025-06-23 21:56:51.170806	4	42	2.7	2025-08-04 21:56:51.173232	93
109	Q10	41	82	2025-07-25 17:29:21.296972	\N	0	0	2.5	\N	0
110	q23	41	82	2025-07-25 17:30:31.493013	\N	0	0	2.5	\N	0
111	Q123	41	82	2025-07-25 17:31:35.301909	\N	0	0	2.5	\N	0
112	q123245	41	82	2025-07-25 17:40:11.963288	\N	0	0	2.5	\N	0
113	Q1234567	41	82	2025-07-25 17:41:23.672062	\N	0	0	2.5	\N	0
114	QWuiz	41	82	2025-07-25 23:54:03.344341	\N	0	0	2.5	\N	0
115	aaaaa	41	82	2025-07-26 00:22:01.263177	\N	0	0	2.5	\N	0
116	avsw	41	82	2025-07-26 00:51:27.991222	\N	0	0	2.5	\N	0
117	ljkhbkh	41	82	2025-07-26 01:48:13.014674	\N	0	0	2.5	\N	0
118	Capitals of UK and Ireland 	41	82	2025-07-28 15:42:02.695607	\N	0	0	2.5	\N	0
59	Phase 2: Button + GPIO Concepts	41	8	2025-06-10 22:58:10.304583	2025-08-07 11:15:57.903217	5	40	1.8199999999999998	2025-09-16 11:15:57.907273	80
38	Dynamic Programming	41	23	2025-05-30 22:07:18.332141	2025-08-07 00:11:26.705243	4	18	1.9000000000000004	2025-08-25 00:11:26.707441	100
33	Efficient Sorting.	41	23	2025-05-30 21:48:16.643465	2025-07-05 00:09:05.423152	4	33	2.46	2025-08-07 00:09:05.42369	90
31	Time Complexity & Algorithm Analysis	41	23	2025-05-30 17:08:51.53649	2025-07-05 00:20:13.410745	4	38	2.5	2025-08-12 00:20:13.411351	87
41	ESP32 SoC and module internal components	41	8	2025-06-01 00:54:52.937751	2025-07-05 00:24:35.970907	4	42	2.7	2025-08-16 00:24:35.971511	100
86	4.1 Process Scheduling	41	6	2025-06-21 14:17:40.0298	2025-08-07 00:14:33.971947	4	45	2.9000000000000004	2025-09-21 00:14:33.974211	100
35	Hash Functions	41	23	2025-05-30 21:57:24.450591	2025-07-10 21:11:47.675953	4	31	2.32	2025-08-10 21:11:47.676754	90
37	Greedy Algorithms	41	23	2025-05-30 22:06:13.006672	2025-07-10 21:25:36.127469	4	37	2.46	2025-08-16 21:25:36.129759	80
79	2.3 Preemptive Multitasking	41	6	2025-06-21 12:49:17.972137	2025-08-07 00:18:08.059829	4	45	2.8000000000000003	2025-09-21 00:18:08.061716	87
82	2.6 File System Concepts	41	6	2025-06-21 12:49:17.972137	2025-08-07 00:20:49.017914	4	42	2.7	2025-09-18 00:20:49.020061	93
39	SoC, module, and development board for esp32	41	8	2025-05-31 23:54:29.348434	2025-08-03 11:44:51.477909	5	51	1.7599999999999998	2025-09-23 11:44:51.482034	75
89	4.4 Interprocess Communication and Synchronisation	41	6	2025-06-21 14:17:40.0298	2025-08-03 22:41:20.052829	0	1	1.6600000000000001	2025-08-04 22:41:20.05599	53
77	1.3 Low-Level C & RISC-V Integration	41	6	2025-06-21 12:49:17.972137	2025-08-04 09:51:50.383119	4	39	2.7	2025-09-12 09:51:50.38726	90
36	Compression Algorithms	41	23	2025-05-30 22:00:45.161308	2025-08-06 22:22:05.565868	5	21	1.6800000000000004	2025-08-27 22:22:05.569851	95
88	4.3 OS Access Control Mechanism	41	6	2025-06-21 14:17:40.0298	2025-08-06 23:41:32.686622	4	15	1.6600000000000004	2025-08-21 23:41:32.689839	80
90	5.1 Introduction to RTOS	41	6	2025-06-24 00:30:58.338299	2025-08-07 00:23:08.040909	4	45	2.9000000000000004	2025-09-21 00:23:08.042991	90
80	2.4 Virtual Memory	41	6	2025-06-21 12:49:17.972137	2025-08-06 23:43:51.613465	4	45	2.9000000000000004	2025-09-20 23:43:51.616301	100
81	2.5 Synchronization	41	6	2025-06-21 12:49:17.972137	2025-08-07 00:25:15.713408	4	22	2.1000000000000005	2025-08-29 00:25:15.715617	100
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, user_name, email, password, created_at, updated_at, role) FROM stdin;
41	Aissa	user1@example.com	$2b$12$SdErdFodLeQ8EaidM/n2WuXd.pWjQPOW3JpPXc9CWnmFqN8xYtNES	2025-01-21 04:54:22.178324	2025-08-12 10:42:36.471029	root
184	Guest	admin@studyquiz.co	$2b$12$Jx4hn71AqDUKu/F8REM.u.4r3Sc3nZB5dTR8Bg6tYTE5jODvR/Hi6	2025-08-12 11:30:08.536136	\N	user
\.


--
-- Name: answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answer_id_seq', 2514, true);


--
-- Name: attempt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attempt_id_seq', 192, true);


--
-- Name: followup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.followup_id_seq', 46, true);


--
-- Name: module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.module_id_seq', 83, true);


--
-- Name: question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_id_seq', 684, true);


--
-- Name: quiz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quiz_id_seq', 120, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 184, true);


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
    ADD CONSTRAINT answer_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT question_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT quiz_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.module(id);


--
-- Name: quiz quiz_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz
    ADD CONSTRAINT quiz_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

