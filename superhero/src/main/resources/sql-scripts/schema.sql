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

delete
from client
where email = 'admin';
insert into client (email, password, role, is_legal_entity)
values ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin', true);


drop table if exists token;
CREATE TABLE token (
  value     varchar(255) NOT NULL,
  client_id integer REFERENCES client (id)
);

drop table if exists request cascade;

create table request (
  id              serial primary key,
  customer_id     integer references client (id),
  contractor_id   integer references client (id),
  title           text not null,
  description     text,
  expiration_date date,
  is_confirmed    boolean,
  is_finished     boolean,
  response_count  int,
  publish_date    date,
  budget          int not null
);

drop table if exists response cascade;

create table response (
  id            serial primary key,
  request_id    integer references request (id),
  contractor_id integer references client (id),
  date          date
);

drop table if exists message;

create table message (
  id          serial primary key,
  response_id integer references response (id),
  sender_id   integer references client (id),
  text        text,
  timestamp   text
);

drop table if exists feedback;
create table feedback (
  id serial primary key,
  customer_id integer references client (id),
  contractor_id integer references client (id),
  value integer,
  comment text
);
