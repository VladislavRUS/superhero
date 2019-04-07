drop table if exists client cascade;
CREATE TABLE client (
  id              serial primary key,
  email           varchar(255) NOT NULL unique,
  password        varchar(255) NOT NULL,
  role            varchar(255) NOT NULL,
  is_legal_entity boolean      NOT NULL,
  first_name      varchar(255),
  last_name       varchar(255),
  company_name    varchar(255),
  address         varchar(255),
  about           text
);

drop table if exists token;
CREATE TABLE token (
  value     varchar(255) NOT NULL,
  client_id integer REFERENCES client (id)
);

drop table if exists request cascade;

create table request (
  id                        serial primary key,
  customer_id               integer references client (id),
  contractor_id             integer references client (id),
  type                      varchar(255) not null,
  address                   text,
  expiration_date           date,
  is_finished_by_customer   boolean,
  is_finished_by_contractor boolean,
  is_approved               boolean,
  response_count            int,
  publish_date              date,
  is_payed                  boolean
);

drop table if exists response cascade;

create table response (
  id            serial primary key,
  request_id    integer references request (id),
  contractor_id integer references client (id),
  date          date,
  payment       integer,
  planned_date  date
);

drop table if exists message;

create table message (
  id          serial primary key,
  response_id integer references response (id),
  sender_id   integer references client (id),
  text        text,
  is_system   boolean,
  timestamp   text
);

drop table if exists feedback;
create table feedback (
  id            serial primary key,
  customer_id   integer references client (id),
  contractor_id integer references client (id),
  value         integer,
  comment       text
);
