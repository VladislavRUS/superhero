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

delete
from client
where email = 'admin';

insert into client (email, password, role, is_legal_entity, company_name, address)
values ('admin',
        '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
        'admin',
        true,
        'Сетевая компания',
        'Казань, Красносельская ул. 51, здание КГЭУ');

insert into client (email, password, role, is_legal_entity, first_name, last_name, address)
values ('customer',
        'b6c45863875e34487ca3c155ed145efe12a74581e27befec5aa661b8ee8ca6dd',
        'customer',
        false,
        'Александр',
        'Иванов',
        'Бондаренко, 25');

insert into client (email, password, role, is_legal_entity, company_name, address)
values ('contractor',
        '2c7e34291dba41872286fd3e95575fd44eb9d8d776b81a89b82e0e681e289514',
        'contractor',
        true,
        'ООО "Казань-Энерго"',
        'Четаева, 47');

insert into client (email, password, role, is_legal_entity, first_name, last_name, address)
values ('customer2',
        'b6c45863875e34487ca3c155ed145efe12a74581e27befec5aa661b8ee8ca6dd',
        'customer',
        false,
        'Александр',
        'Иванов',
        'Бондаренко, 25');

insert into client (email, password, role, is_legal_entity, company_name, address)
values ('contractor2',
        '2c7e34291dba41872286fd3e95575fd44eb9d8d776b81a89b82e0e681e289514',
        'contractor',
        true,
        'ООО "Казань-Энерго"',
        'Четаева, 47');


insert into request (customer_id, contractor_id, type, address, expiration_date, response_count, publish_date)
values ((select id from client where email = 'customer'),
        null,
        'technologyConnection',
        'Ямашева проспект, 35а',
        '2019-04-06',
        0,
        '2019-04-01');

insert into request (customer_id, contractor_id, type, address, expiration_date, response_count, publish_date)
values ((select id from client where email = 'customer2'),
        null,
        'technologyConnection',
        'Ямашева проспект, 35а',
        '2019-04-06',
        0,
        '2019-04-01');
