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
