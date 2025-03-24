--
-- PostgreSQL database dump
--

-- Dumped from database version 15.12
-- Dumped by pg_dump version 15.12

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
-- Name: plugin_declarations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plugin_declarations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    plugin_unique_identifier character varying(255),
    plugin_id character varying(255),
    declaration text
);


ALTER TABLE public.plugin_declarations OWNER TO postgres;

--
-- Name: plugins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plugins (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    plugin_unique_identifier character varying(255),
    plugin_id character varying(255),
    refers bigint DEFAULT 0,
    install_type character varying(127),
    manifest_type character varying(127),
    remote_declaration text
);


ALTER TABLE public.plugins OWNER TO postgres;

--
-- Data for Name: plugin_declarations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plugin_declarations (id, created_at, updated_at, plugin_unique_identifier, plugin_id, declaration) FROM stdin;
83af5330-e1f3-4314-b38a-c6cf2baf1d9d	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/openai:0.0.13	openai	version: 0.0.13\n    type: plugin\n    author: "langgenius"\n    name: "openai"\n    description:\n      en_US: Models provided by OpenAI, such as GPT-3.5-Turbo and GPT-4.\n      zh_Hans: OpenAI 提供的模型，例如 GPT-3.5-Turbo 和 GPT-4。\n    label:\n      en_US: "OpenAI"\n    created_at: "2024-07-12T08:03:44.658609186Z"\n    icon: icon_s_en.svg\n    resource:\n      memory: 1048576\n      permission:\n        tool:\n          enabled: true\n        model:\n          enabled: true\n          llm: true\n    plugins:\n      models:\n        - "provider/openai.yaml"\n    meta:\n      version: 0.0.1\n      arch:\n        - "amd64"\n        - "arm64"\n      runner:\n        language: "python"\n        version: "3.12"\n        entrypoint: "main"
2f027925-6783-4260-8870-96474b8afaf1	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/anthropic:0.0.12	anthropic	version: 0.0.12\n    type: plugin\n    author: "langgenius"\n    name: "anthropic"\n    description:\n      en_US: Anthropic's powerful models.\n      zh_Hans: Anthropic 的强大模型。\n    label:\n      en_US: "Anthropic"\n    created_at: "2024-07-12T08:03:44.658609186Z"\n    icon: icon_s_en.svg\n    resource:\n      memory: 268435456\n      permission:\n        model:\n          enabled: false\n    plugins:\n      models:\n        - "provider/anthropic.yaml"\n    meta:\n      version: 0.0.1\n      arch:\n        - "amd64"\n        - "arm64"\n      runner:\n        language: "python"\n        version: "3.12"\n        entrypoint: "main"
9f78daa1-6712-4263-9289-f1bcbd887424	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/azure_openai:0.0.10	azure_openai	version: 0.0.10\n    type: plugin\n    author: "langgenius"\n    name: "azure_openai"\n    description:\n      en_US: Azure OpenAI Service Model\n    label:\n      en_US: "Azure OpenAI"\n    created_at: "2024-07-12T08:03:44.658609186Z"\n    icon: icon_s_en.svg\n    resource:\n      memory: 268435456\n      permission:\n        model:\n          enabled: false\n    plugins:\n      models:\n        - "provider/azure_openai.yaml"\n    meta:\n      version: 0.0.1\n      arch:\n        - "amd64"\n        - "arm64"\n      runner:\n        language: "python"\n        version: "3.12"\n        entrypoint: "main"
5cd0b157-49a6-43e7-80b6-b93860f048e4	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/gemini:0.0.8	gemini	version: 0.0.8\n    type: plugin\n    author: "langgenius"\n    name: "gemini"\n    description:\n      en_US: Google's Gemini model.\n      zh_Hans: 谷歌提供的 Gemini 模型.\n    label:\n      en_US: "Gemini"\n    created_at: "2024-07-12T08:03:44.658609186Z"\n    icon: icon_s_en.svg\n    resource:\n      memory: 268435456\n      permission:\n        model:\n          enabled: true\n          llm: true\n          moderation: false\n          rerank: true\n          speech2text: false\n          text_embedding: true\n          tts: false\n        tool:\n          enabled: true\n    plugins:\n      models:\n        - "provider/google.yaml"\n    meta:\n      version: 0.0.1\n      arch:\n        - "amd64"\n        - "arm64"\n      runner:\n        language: "python"\n        version: "3.12"\n        entrypoint: "main"
\.


--
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plugins (id, created_at, updated_at, plugin_unique_identifier, plugin_id, refers, install_type, manifest_type, remote_declaration) FROM stdin;
66baad08-a8b5-4d2f-8346-94c8510da9df	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/openai:0.0.13	openai	0	built-in	manifest	\N
c95616f5-d7e0-4fc4-83cf-e06319502c0e	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/anthropic:0.0.12	anthropic	0	built-in	manifest	\N
d6363aa6-1f70-47eb-8185-d0e8bc8bcaa1	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/azure_openai:0.0.10	azure_openai	0	built-in	manifest	\N
313416a7-8cc0-44d7-8101-805f901a00a5	2025-03-24 18:41:34.434331+00	2025-03-24 18:41:34.434331+00	langgenius/gemini:0.0.8	gemini	0	built-in	manifest	\N
\.


--
-- Name: plugin_declarations plugin_declarations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugin_declarations
    ADD CONSTRAINT plugin_declarations_pkey PRIMARY KEY (id);


--
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- Name: plugin_declarations uni_plugin_declarations_plugin_unique_identifier; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plugin_declarations
    ADD CONSTRAINT uni_plugin_declarations_plugin_unique_identifier UNIQUE (plugin_unique_identifier);


--
-- Name: idx_plugin_declarations_plugin_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_plugin_declarations_plugin_id ON public.plugin_declarations USING btree (plugin_id);


--
-- Name: idx_plugins_install_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_plugins_install_type ON public.plugins USING btree (install_type);


--
-- Name: idx_plugins_plugin_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_plugins_plugin_id ON public.plugins USING btree (plugin_id);


--
-- Name: idx_plugins_plugin_unique_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_plugins_plugin_unique_identifier ON public.plugins USING btree (plugin_unique_identifier);


--
-- PostgreSQL database dump complete
--

