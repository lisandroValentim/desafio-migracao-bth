CREATE SEQUENCE public.seq_estados
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_estados
  OWNER TO postgres;

CREATE TABLE "estados" (
	"id_estados" smallint NOT NULL DEFAULT nextval('seq_estados'::regclass),
	"nome" char(20) NOT NULL,
	"uf" char(2) NOT NULL,
	PRIMARY KEY ( "id_estados" )
);
COMMENT ON TABLE  "estados" IS 'Registros de Estados';
COMMENT ON COLUMN "estados"."id_estados" IS 'Código do Estado';
COMMENT ON COLUMN "estados"."nome" IS 'Nome';
COMMENT ON COLUMN "estados"."uf" IS 'unidade federativa';

CREATE SEQUENCE public.seq_cidades
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_cidades
  OWNER TO postgres;

CREATE TABLE "cidades" ( 
	"id_cidades" integer NOT NULL DEFAULT nextval('seq_cidades'::regclass), 
	"id_estados" smallint NULL, 
	"nome" char(50) NOT NULL,
	"cod_siafi" integer NULL,
	PRIMARY KEY ( "id_cidades" )
);
COMMENT ON TABLE  "cidades" IS 'Registros de Cidades';
COMMENT ON COLUMN "cidades"."id_cidades" IS 'Código da Cidade'; 
COMMENT ON COLUMN "cidades"."id_estados" IS 'Sigla do Estado'; 
COMMENT ON COLUMN "cidades"."nome" IS 'Descrição'; 
COMMENT ON COLUMN "cidades"."cod_siafi" IS 'Código no SIAFI'; 
ALTER TABLE "cidades" ADD FOREIGN KEY ( "id_estados" )  REFERENCES "estados"  ( "id_estados" ); 

CREATE SEQUENCE public.seq_bairros
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_bairros
  OWNER TO postgres;

CREATE TABLE "bairros"(
	"id_bairros" integer NOT NULL DEFAULT nextval('seq_bairros'::regclass), 
    "id_cidades" integer NOT NULL, 
	"nome" char(50)      NOT NULL,
	PRIMARY KEY ( "id_bairros" )
);
COMMENT ON TABLE  "bairros" IS 'Registros de Bairros';
COMMENT ON COLUMN "bairros"."id_bairros" IS 'Código do Bairro';
COMMENT ON COLUMN "bairros"."nome" IS 'Descrição';
COMMENT ON COLUMN "bairros"."id_cidades" IS 'Código da Cidade';
ALTER TABLE "bairros" ADD FOREIGN KEY ( "id_cidades" )  REFERENCES "cidades"  ( "id_cidades" ); 

CREATE SEQUENCE public.seq_ruas
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_ruas
  OWNER TO postgres;

CREATE TABLE "ruas" (
	"id_ruas" integer    NOT NULL DEFAULT nextval('seq_ruas'::regclass),
	"id_cidades" integer NOT NULL,
	"nome" char(50)      NOT NULL,
	"cep" char(8)        NULL,
	PRIMARY KEY ( "id_ruas" ) 
);
COMMENT ON TABLE  "ruas" IS 'Registros de Ruas';
COMMENT ON COLUMN "ruas"."id_ruas" IS 'Código da Rua';
COMMENT ON COLUMN "ruas"."id_cidades" IS 'Código da Cidade';
COMMENT ON COLUMN "ruas"."nome" IS 'Nome';
COMMENT ON COLUMN "ruas"."cep" IS 'CEP';
ALTER TABLE "ruas" ADD FOREIGN KEY ( "id_cidades" )  REFERENCES "cidades"  ( "id_cidades" ); 

CREATE SEQUENCE public.seq_pessoas
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_pessoas
  OWNER TO postgres;

CREATE TABLE pessoas(
	"id_pessoas"     integer NOT NULL DEFAULT nextval('seq_pessoas'::regclass),
	"nome"           char(60) NOT NULL,
    "documento"      char(11) NULL,
	"ddd"            char(2)  NULL,
	"telefone"       char(9)  NULL,
	"ddd_cel"        char(2)  NULL,
	"celular"        char(9)  NULL,
	"email"          char(60) NULL,
	PRIMARY KEY ( "id_pessoas" )
);

COMMENT ON TABLE pessoas IS 'Registros de Pessoas';
COMMENT ON COLUMN pessoas.id_pessoas IS 'Código da Pessoa';
COMMENT ON COLUMN pessoas.nome IS 'Nome';
COMMENT ON COLUMN pessoas.Documento  IS 'Documento';
COMMENT ON COLUMN pessoas.ddd IS 'DDD';
COMMENT ON COLUMN pessoas.telefone IS 'Telefone';
COMMENT ON COLUMN pessoas.ddd_cel IS 'DDD do celular';
COMMENT ON COLUMN pessoas.celular IS 'Celular';
COMMENT ON COLUMN pessoas.email IS 'Email';

CREATE SEQUENCE public.seq_pessoas_enderecos
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_pessoas_enderecos
  OWNER TO postgres;

CREATE TABLE "pessoas_enderecos"(
	"id" integer  NOT NULL DEFAULT nextval('seq_pessoas_enderecos'::regclass), 
	"id_pessoas" integer NOT NULL,
	"tipo_endereco"  char(1)  NOT NULL,
	"id_ruas"        integer  NULL,
	"id_bairros"     integer  NULL,
	"complemento"    char(50) NULL,
	"numero"         char(8)  NULL,
	PRIMARY KEY ( "id", "id_pessoas", "tipo_endereco" )
);
COMMENT ON TABLE  "pessoas_enderecos" IS 'Registros de Endereços das Pessoas';
COMMENT ON COLUMN "pessoas_enderecos"."id" IS 'Código identificador';
COMMENT ON COLUMN "pessoas_enderecos"."id_pessoas" IS 'Código da Pessoa';
COMMENT ON COLUMN "pessoas_enderecos"."tipo_endereco" IS 'Tipo do endereço (P-Pessoal, C-Correspondência, S-Serviço)';
COMMENT ON COLUMN "pessoas_enderecos"."id_ruas" IS 'Código da Rua'; 
COMMENT ON COLUMN "pessoas_enderecos"."id_bairros" IS 'Código do Bairro';
COMMENT ON COLUMN "pessoas_enderecos"."complemento" IS 'Complemento';
COMMENT ON COLUMN "pessoas_enderecos"."numero" IS 'Número';

ALTER TABLE "pessoas_enderecos" ADD FOREIGN KEY ( "id_ruas" )    REFERENCES "ruas"    ( "id_ruas" ); 
ALTER TABLE "pessoas_enderecos" ADD FOREIGN KEY ( "id_bairros" ) REFERENCES "bairros" ( "id_bairros" );
ALTER TABLE "pessoas_enderecos" ADD FOREIGN KEY ( "id_pessoas" ) REFERENCES "pessoas" ( "id_pessoas" );
ALTER TABLE "pessoas_enderecos" ADD CHECK (tipo_endereco in( 'P','C','S') and(ascii(tipo_endereco) < 97));

CREATE SEQUENCE public.seq_pontos_acessos
   INCREMENT BY 1
   START 1
   MINVALUE 1   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_pontos_acessos
  OWNER TO postgres;

CREATE TABLE "pontos_acessos"(
	"id_ponto"     integer      NOT NULL DEFAULT nextval('seq_pontos_acessos'::regclass),
    "nome"         char(50)     NOT NULL,
	"descricao"    varchar(254) NULL,
	"numero"       Smallint     NULL,
	PRIMARY KEY ( "id_ponto")
);
COMMENT ON TABLE  "pontos_acessos" IS 'Registros dos pontos de acessos da entidade';
COMMENT ON COLUMN "pontos_acessos"."id_ponto"  IS 'Código do Ponto';
COMMENT ON COLUMN "pontos_acessos"."nome"      IS 'Nome do Ponto de acesso';
COMMENT ON COLUMN "pontos_acessos"."descricao" IS 'Descrição para detalhamento do Ponto de acesso';
COMMENT ON COLUMN "pontos_acessos"."numero"    IS 'Número';

CREATE SEQUENCE public.seq_permissoes_acessos
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_permissoes_acessos
  OWNER TO postgres;

CREATE TABLE "permissoes_acessos"(
   "id_permissao"  integer   NOT NULL DEFAULT nextval('seq_permissoes_acessos'::regclass),
   "id_ponto"      integer   NOT NULL,
   "id_pessoas"    integer   NOT NULL,
   "inicio_acesso" timestamp NOT NULL,
   "fim_acesso"    timestamp NULL, 
	PRIMARY KEY ( "id_permissao")
);
COMMENT ON TABLE  "permissoes_acessos" IS 'Registros de permissões de acessos da entidade';
COMMENT ON COLUMN "permissoes_acessos"."id_permissao"  IS 'Código da Permissão';
COMMENT ON COLUMN "permissoes_acessos"."id_pessoas"    IS 'Código da Pessoa';
COMMENT ON COLUMN "permissoes_acessos"."id_ponto"      IS 'Código do Ponto';
COMMENT ON COLUMN "permissoes_acessos"."inicio_acesso" IS 'Inicio do Acesso';
COMMENT ON COLUMN "permissoes_acessos"."fim_acesso"    IS 'Final do Acesso';

ALTER TABLE "permissoes_acessos" ADD FOREIGN KEY ("id_ponto")   REFERENCES "pontos_acessos"  ( "id_ponto" ); 
ALTER TABLE "permissoes_acessos" ADD FOREIGN KEY ("id_pessoas") REFERENCES "pessoas" ( "id_pessoas" );

CREATE SEQUENCE public.seq_acessos
   INCREMENT BY 1
   START 1
   MINVALUE 1
   MAXVALUE 9223372036854775807
   CACHE 1;
ALTER SEQUENCE public.seq_acessos
  OWNER TO postgres;

CREATE TABLE "acessos"(
   "id_acesso"  integer   NOT NULL DEFAULT nextval('seq_acessos'::regclass),
   "id_ponto"   integer   NOT NULL,
   "id_pessoas" integer   NOT NULL,
   "marcacao"   timestamp NOT NULL,
	PRIMARY KEY ("id_ponto")
);
COMMENT ON TABLE  "acessos" IS 'Registros de marcações de acessos a entidade';
COMMENT ON COLUMN "acessos"."id_acesso"     IS 'Código do Acesso';
COMMENT ON COLUMN "acessos"."id_pessoas"    IS 'Código da Pessoa';
COMMENT ON COLUMN "acessos"."id_ponto"      IS 'Código do Ponto';
COMMENT ON COLUMN "acessos"."marcacao"      IS 'Marcação de acesso';

ALTER TABLE "acessos" ADD FOREIGN KEY  ( "id_ponto" )   REFERENCES "pontos_acessos"  ( "id_ponto" ); 
ALTER TABLE "acessos" ADD FOREIGN KEY  ( "id_pessoas" ) REFERENCES "pessoas" ( "id_pessoas" );

