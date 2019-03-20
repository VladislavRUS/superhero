drop table if exists client cascade;
CREATE TABLE client (
  id serial primary key,
  email varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  role varchar(255) NOT NULL,
  name text,
  information text
);

insert into client (email, password, role) values ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin');

drop table if exists token;
CREATE TABLE token (
  value varchar(255) NOT NULL,
  client_id integer REFERENCES client (id)
);

drop table if exists request cascade;

create table request (
  id serial primary key,
  customer_id integer references client (id),
  contractor_id integer references client(id),
  description text,
  expiration_date date,
  is_confirmed boolean,
  response_count int
);

drop table if exists response;

create table response (
  id serial primary key,
  request_id integer references request (id),
  contractor_id integer references client(id),
  date date
);

