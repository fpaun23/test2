DROP DATABASE mydatabase3;

CREATE DATABASE IF NOT EXISTS mydatabase3;

USE mydatabase3;

CREATE TABLE `category` (
  `id_cat` INT NOT NULL AUTO_INCREMENT,
  `name_cat` varchar(255) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cat`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `products` (
  `id_prod` int(11) NOT NULL AUTO_INCREMENT,
  `id_cat` int(11) NOT NULL,
  `name_prod` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_prod`),
  CONSTRAINT `fk_category` FOREIGN KEY (`id_cat`) REFERENCES `category` (`id_cat`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `colors` (
  `id_color` int(11) NOT NULL AUTO_INCREMENT,
  `color` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_color`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dimensions` (
  `id_dimension` int(11) NOT NULL AUTO_INCREMENT,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_dimension`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `product_color_dimension` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_product` int(11) NOT NULL,
  `id_color` int(11) NOT NULL,
  `id_dimension` int(11) NOT NULL,
   PRIMARY KEY (`id`),
  CONSTRAINT `fk_product` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_prod`) ON DELETE CASCADE,
  CONSTRAINT `fk_color` FOREIGN KEY (`id_color`) REFERENCES `colors` (`id_color`) ON DELETE CASCADE,
  CONSTRAINT `fk_dimension` FOREIGN KEY (`id_dimension`) REFERENCES `dimensions` (`id_dimension`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) UNIQUE NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `delivery_type` enum('courier','self_pick') DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `products_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_orders_products` FOREIGN KEY (`products_id`) REFERENCES `products` (`id_prod`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `category` (`name_cat`) VALUES ('Lactate'); 
INSERT INTO `category` (`name_cat`) VALUES ('Mezeluri');
INSERT INTO `category` (`name_cat`) VALUES ('Electrocasnice');
INSERT INTO `category` (`name_cat`) VALUES ('Fructe');

INSERT INTO `products` (`id_cat`, `name_prod`) VALUES (1, 'Hochland');
INSERT INTO `products` (`id_cat`, `name_prod`) VALUES (2, 'Cristim');
INSERT INTO `products` (`id_cat`, `name_prod`) VALUES (3, 'Masina de spalat');
INSERT INTO `products` (`id_cat`, `name_prod`) VALUES (4, 'Pere');

INSERT INTO `dimensions` (`value`) VALUES (4);
INSERT INTO `dimensions` (`value`) VALUES (5);
INSERT INTO `dimensions` (`value`) VALUES (6);
INSERT INTO `dimensions` (`value`) VALUES (7);
INSERT INTO `dimensions` (`value`) VALUES (8);

INSERT INTO `colors` (`color`) VALUES ('alb');
INSERT INTO `colors` (`color`) VALUES ('negru');
INSERT INTO `colors` (`color`) VALUES ('rosu');

INSERT INTO `product_color_dimension` (`id_product`, `id_color`, `id_dimension`) VALUES (1, 1, 1);
INSERT INTO `product_color_dimension` (`id_product`, `id_color`, `id_dimension`) VALUES (1, 2, 2);
INSERT INTO `product_color_dimension` (`id_product`, `id_color`, `id_dimension`) VALUES (2, 3, 3);
INSERT INTO `product_color_dimension` (`id_product`, `id_color`, `id_dimension`) VALUES (3, 1, 4);
INSERT INTO `product_color_dimension` (`id_product`, `id_color`, `id_dimension`) VALUES (4, 3, 1);

INSERT INTO `customer` (`email`) VALUES ('florin.paun1@devnest.ro'); 
INSERT INTO `customer` (`email`) VALUES ('florin.paun2@devnest.ro'); 
INSERT INTO `customer` (`email`) VALUES ('florin.paun3@devnest.ro'); 

INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('courier', 1, 1); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('courier', 1, 2); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('courier', 1, 3); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('self_pick', 1, 4); 

INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('self_pick', 2, 1); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('self_pick', 2, 2); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('courier', 2, 3); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('self_pick', 1, 4); 

INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('self_pick', 3, 1); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('courier', 3, 2); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('courier', 3, 3); 
INSERT INTO `orders` (`delivery_type`,`customer_id`,`products_id`) VALUES ('self_pick', 3, 4); 

1. get all products with all category information - using JOIN;
SELECT * FROM products
JOIN category on products.id_cat = category.id_cat;

2. get the number of products from each category - using JOIN, Count, Group BY
display 2 columns: nb of products, category name
SELECT count(*), category.name_cat FROM products
JOIN category on products.id_cat = category.id_cat
GROUP BY category.id_cat
;

3. get all orders with the all information about products and categories the products belong to - using JOIN
SELECT * FROM `orders` 
join products on products.id_prod = orders.products_id
join category on category.id_cat = products.id_cat
;

4. get the number of orders for each category - using JOIN, Count, Group By
display 2 columns: nb of orders, category name

SELECT count(*) as nb_orders, category.name_cat FROM `orders` 
join products on products.id_prod = orders.products_id
join category on category.id_cat = products.id_cat
group by category.id_cat
;

5. get all orders of all customers - using JOIN
select * from customer
JOIN orders on orders.customer_id = customer.id
;

6.get the number of ordersfor each customer.
diaplay 2 columns nb of orders, customr email
the result must be ordered by number of orders descending

select count(*) as nb_orders, customer.email from customer
JOIN orders on orders.customer_id = customer.id
GROUP BY customer.id
ORDER BY nb_orders DESC
;

7. get all orders of customers grouped by category and orderes and ordered descending
SELECT count(*) as nb_orders, category.name_cat, customer.email FROM `orders` 
join customer on customer.id = orders.customer_id
join products on products.id_prod = orders.products_id
join category on category.id_cat = products.id_cat
group by category.id_cat,customer.id
ORDER BY nb_orders DESC
;
