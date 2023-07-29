Pasos a realizar:


dvd rental es uan agencia d earriendos de dvd, por lo en su bd debe tener clientes, su direccion,telefoo,dvd aarrendar, fecha arriendo,fecha devolucion
nombre de peli, el actor, año de lanzamiento,puntuacion,etc

1- Importar la base de datos usando el script restore.sql
2- Crear la BD en PostgreSQL , la que llamaremos dvdrental con el comando
CREATE DATABASE dvdrental;
3- acceder a nuestra bd con el comando \c dvdrental
4 para hacer operaciones en la bd, se usa BEGIN TRANSACTION;
4 hacer las siguientes consultas:

insertar, modificar y eliminar un Customer, Staff y Actor

acciones al customer. El customer tiene 3 tablas relacionadas  entre si: city, y adress,por lo tanto 
hay que crear una city y una adress para el customer


CLIENTE:

crear city:
\echo 
\echo INSERT INTO city(country_id, city) VALUES ((SELECT max(country_id) FROM country WHERE country = 'Chile'), 'Santiago');


crear adress:
\echo INSERT INTO address (address, city_id, phone, postal_code, district)
		VALUES('Lord Cochrane 635', (
				SELECT
					max(city_id)
					FROM city
				WHERE
					city = 'Santiago'), '987543433', '800056544', 'Santiago');
                        
\echo 
crear customer:
usando 
\echo INSERT INTO customer(store_id, first_name, last_name, email, address_id, active)
    VALUES
        (1,'Daisy', 'Castillo', 'daisyktbpa@gmail.com',
        (SELECT max(address_id) from address WHERE address='Lord Cochrane 635' AND district = 'Santiago' ), 1 );


Verificar si se selecciona el cliente
\echo SELECT customer.activebool, customer.customer_id, customer.email FROM customer WHERE email = 'daisyktbpa@gmail.com';

Modificar cliente
\echo UPDATE customer SET activebool = false WHERE email = 'daisyktbpa@gmail.com';

Verficar si se modificó al cliente usando el campo activebool
\echo SELECT activebool, first_name, last_name, customer_id, email FROM customer WHERE email = 'daisyktbpa@gmail.com';

Eliminar cliente:
\echo DELETE FROM customer WHERE email = 'daisyktbpa@gmail.com';

Verificar si se eliminó un cliente:
\echo SELECT activebool, first_name, last_name, email FROM customer WHERE email = 'daisyktbpa@gmail.com';

COMMIT;

ACTOR:

Agregar un nuevo actor
\echo INSERT INTO Actor(first_name,last_name) VALUES ('Jim','Caviezel');
SELECT * from Actor where actor_id = (SELECT max(actor_id) FROM actor);

Modificar nombre del nuevo actor
\echo UPDATE actor SET first_name = 'Jim' WHERE actor_id = (SELECT max(actor_id) FROM actor);
SELECT * from Actor where actor_id = (SELECT max(actor_id) FROM actor);

Eliminar nuevo acctor
\echo DELETE FROM actor WHERE actor_id = (SELECT max(actor_id) FROM actor);

Comprobar eliminacion de actor
\echo SELECT * from Actor where first_name = 'Jim' and last_name = 'Caviezel';

COMMIT;

Listar todas las “rental” con los datos del “customer” dado un año y mes.

SELECT r.rental_id id ,r.rental_date fecha_arriendo, r.return_date fecha_devolucion, c.first_name nombre, c.last_name apellido, c.email 
FROM rental r LEFT JOIN customer c 
ON r.customer_id = c.customer_id WHERE EXTRACT(YEAR FROM rental_date) = 2010 AND EXTRACT(MONTH FROM rental_date) = 8;

Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment'

SELECT  p.payment_id, p.payment_date, p.amount FROM payment;


Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0'

SELECT film_id, title, description, release_year, rental_duration, rental_rate 
 FROM public.film WHERE rental_rate > 4 AND release_year = 2006 ORDER BY rental_rate DESC;
