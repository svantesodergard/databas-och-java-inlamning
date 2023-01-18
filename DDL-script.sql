drop database if exists MyShoeStore;
create database MyShoeStore;
use MyShoeStore;

-- Create Tables
create table costumer(
    id int not null primary key auto_increment,
    name VARCHAR(255) not null
);

create table product (
    id int not null primary key auto_increment,
    brand VARCHAR(255),
    model VARCHAR(255),
    price int not null
);

-- Index, En av de vanligaste sökningar i en butik kommer vara efter dess produkter
create index IX_brand on product(brand);
create index IX_model on product(model);

create table product_variation (
    id int not null primary key auto_increment,
    product_id int,
    -- Om en produkt tas bort tas även varianterna av den borts
    foreign key (product_id) references product(id) on delete cascade,
    size int,
    color VARCHAR(255),
    stock int
);

create table category(
    id int not null primary key auto_increment,
    name VARCHAR(255) not null
);

create table product_in_category(
    id int not null primary key auto_increment,
    category_id int,
    product_id int,
    -- Cascade då tabellens syfte är att spara relationer mellan produkter och kategori
    -- finns ingen vits att spara en rad om de inte finns
    foreign key (category_id) references category(id) on delete cascade,
    foreign key (product_id) references product(id) on delete cascade
);

create table `order`(
    id int not null primary key auto_increment,
    delivery_city VARCHAR(255),
    time_placed TIMESTAMP default CURRENT_TIMESTAMP,
    costumer_id int,
    -- Kan vara användbart att ha en historik alla över beställningar som gjort även om en kund tar
    -- bort sitt konto
    foreign key (costumer_id) references costumer(id) on delete set null
);

create table product_variation_in_order (
    id int not null primary key auto_increment,
    order_id int not null,
    product_variation_id int not null,
    -- Cascade då tabellens syfte är att spara relationer mellan produkter och beställningar
    -- finns ingen vits att spara en rad om de inte finns
    foreign key (order_id) references `order`(id) on delete cascade,
    foreign key (product_variation_id) references product_variation(id) on delete cascade,
    amount int not null default 0
);


-- Fill with data

-- Fill products
insert into product (brand, model, price) values
    ('Ecco', 'Sandaler 2000', 799),
    ('Jordans', 'Mid 1s', 1299),
    ('Vans', 'The Old Skool', 699),
    ('Crocs', 'Vita', 349),
    ('Vans', 'Slip-On', 849),
    ('Converse', 'All Stars', 879),
    ('LeBron', '14', 1589),
    ('Timberland', 'Sandaler', 659);

insert into product_variation (product_id, size, color, stock) values
    (1, 38, 'Black', 12),
    (1, 41, 'Black', 12),
    (1, 42, 'Black', 12),
    (1, 43, 'Black', 12),
    (1, 44, 'Black', 12),

    (2, 39, 'Orange', 12),
    (2, 42, 'Orange', 11),
    (2, 43, 'Orange', 10),
    (2, 44, 'Orange', 9),
    (2, 45, 'Orange', 8),

    (2, 39, 'Light Blue', 12),
    (2, 42, 'Light Blue', 13),
    (2, 43, 'Light Blue', 14),
    (2, 44, 'Light Blue', 15),
    (2, 45, 'Light Blue', 12),

    (3, 38, 'Yacht Club', 3),
    (3, 39, 'Yacht Club', 8),
    (3, 40, 'Yacht Club', 10),
    (3, 41, 'Yacht Club', 23),
    (3, 42, 'Yacht Club', 17),

    (4, 42, 'Black', 10),
    (5, 42, 'Black', 10),
    (6, 42, 'Black', 10),
    (7, 42, 'Black', 10),
    (8, 42, 'Black', 10);

-- Add products to category
insert into category(name) values
    ('Sneakers'),
    ('Sandaler'),
    ('Foppa-tofflor'),
    ('Basketskor'),
    ('Slip-ons');

insert into product_in_category(category_id, product_id) values
    (1, 2),
    (1, 3),
    (1, 5),
    (1, 6),
    (1, 7),

    (2, 1),
    (2, 4),
    (2, 8),

    (3, 1),

    (4, 2),
    (4, 3),

    (5, 4),
    (5, 5);

-- Add costumers
insert into costumer(name) values
    ('Adam Alpha'),
    ('Bertil Bravo'),
    ('Charlie Cesar'),
    ('David Delta'),
    ('Erik Echo');

-- Place orders
insert into `order`(delivery_city, costumer_id) values
    ('Stockholm', 1),
    ('Göteborg', 2),
    ('Eskilstuna', 3),
    ('Stockholm', 4),
    ('Norrköping', 5),
    ('Mark', 2);

-- Assign products to orders
insert into product_variation_in_order(order_id, product_variation_id, amount) values
    (1, 1, 1),
    (1, 7, 2),

    (2, 5, 4),
    (3, 3, 1),
    (4, 1, 2),
    (5, 5, 1),
    (6, 9, 3);

-- Change date for some orders
update `order` set time_placed = timestamp('2023-02-01 00:00:01') where id >= 3;
