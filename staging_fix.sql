--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

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
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price double precision NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    uuid character varying(36),
    order_number character varying(10),
    user_name character varying(100),
    user_email character varying(100),
    total_price double precision,
    created_at timestamp without time zone,
    is_open boolean,
    address1 character varying(255),
    address2 character varying(255),
    city character varying(100),
    state character varying(100),
    country character varying(100),
    zip_code character varying(20),
    mobile character varying(20),
    card_name character varying(100),
    card_number character varying(20),
    expiry_date character varying(5),
    cvv character varying(4)
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    price double precision NOT NULL,
    description character varying(500),
    short_description character varying(200),
    image character varying(255)
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
a11283937150
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, price) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, uuid, order_number, user_name, user_email, total_price, created_at, is_open, address1, address2, city, state, country, zip_code, mobile, card_name, card_number, expiry_date, cvv) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, price, description, short_description, image) FROM stdin;
1	Webcam Ultra HD 4K MX Brio	1299	A Logitech MX Brio é uma webcam de alta performance, ideal para streamers que buscam qualidade excepcional em vídeo. Com resolução 4K Ultra HD e tecnologia HDR, oferece imagens nítidas e cores vibrantes. Possui autofoco avançado e campo de visão ajustável, além de microfones estéreo embutidos, proporcionando áudio claro e sem ruídos. A MX Brio ainda conta com suporte para Windows Hello e Logitech Capture, facilitando o ajuste de configurações para streaming.	Imagem Ultra HD 4K com HDR e foco automático	product-1.jpg
2	Elgato Stream Deck	1199	O Elgato Stream Deck é uma ferramenta essencial para criadores de conteúdo que desejam uma experiência de streaming dinâmica e profissional. Com 15 teclas LCD personalizáveis, o Stream Deck permite controle total das ações no streaming, facilitando comandos para transições, inserção de sons, mensagens no chat e muito mais. Ele é compatível com OBS, Twitch, YouTube e outras plataformas, tornando cada transmissão mais prática e interativa.	Controle suas streams com 15 teclas personalizáveis	product-2.jpg
3	Galaxy Book4	4199	O Galaxy Book4 é o notebook ideal para streamers e criadores que priorizam mobilidade e desempenho. Com processadores de última geração e integração total com o ecossistema Samsung, ele facilita a troca de arquivos e permite o espelhamento de tela com dispositivos Galaxy. A tela Full HD e a bateria de longa duração tornam o Galaxy Book4 perfeito para transmissões ao vivo e edições de vídeo.	Notebook leve e potente com integração Samsung	product-3.jpg
4	Notebook Dell XPS 13	8999	O Dell XPS 13 é um dos notebooks mais recomendados para streamers e criadores de conteúdo devido ao seu desempenho de ponta e design premium. Com uma tela infinita de alta resolução 4K, ele oferece uma experiência visual imersiva, perfeita para edições e transmissões. Equipado com processadores Intel Core i7 e armazenamento SSD, o XPS 13 combina velocidade e eficiência, ideal para multitarefa.	Notebook compacto com tela infinita 4K e desempenho premium	product-4.jpg
5	JBL Tune 720BT	349	O JBL Tune 720BT é um fone de ouvido Bluetooth acessível e confortável, perfeito para quem busca boa qualidade de som com graves impactantes. Com até 50 horas de reprodução contínua, ele é ideal para sessões prolongadas de streaming ou edição de vídeos. Leve e fácil de ajustar, proporciona boa vedação contra ruídos externos.	Fone Bluetooth leve com graves intensos e longa bateria	product-5.jpg
6	Smartphone Samsung Galaxy S22	4499	O Samsung Galaxy S22 é um dos smartphones mais avançados para criação de conteúdo móvel. Equipado com uma câmera principal de alta resolução e gravação em 8K, ele captura imagens e vídeos em qualidade profissional. Ideal para vloggers e streamers que gostam de transmitir de qualquer lugar.	Smartphone com câmera avançada e gravação em 8K	product-6.jpg
7	Câmera EOS Rebel SL3	3999	A Canon EOS Rebel SL3 é uma câmera DSLR leve e compacta, ideal para streamers e vloggers que buscam alta qualidade de imagem sem comprometer a portabilidade. Com sensor de 24.1 MP e capacidade de gravação em 4K, oferece captura de detalhes impressionantes e cores vibrantes.	DSLR compacta com 24.1 MP e gravação em 4K	product-7.jpg
8	Microfone Hollyland Lark M2 Duo	1399	O Hollyland Lark M2 Duo é um microfone de lapela sem fio que oferece áudio de qualidade para streamers e criadores de conteúdo. Com dois transmissores e um receptor, ele permite captação de áudio para entrevistas e transmissões em dupla, mantendo clareza e baixo ruído.	Microfone de lapela duplo com áudio cristalino e transmissão sem fio	product-8.jpg
9	Microfone Condensador Blue Yeti	899	O Blue Yeti é um microfone condensador USB amplamente usado por streamers e podcasters devido à sua qualidade sonora e versatilidade. Oferecendo múltiplos padrões de captação, ele é perfeito para diferentes tipos de gravação, seja streaming, podcasting ou entrevistas.	Microfone condensador USB para gravações de alta qualidade	product-9.jpg
\.


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 9, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: orders orders_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_uuid_key UNIQUE (uuid);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- PostgreSQL database dump complete
--

