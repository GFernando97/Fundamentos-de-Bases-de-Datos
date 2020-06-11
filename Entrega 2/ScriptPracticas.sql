--Ejercicio 3.42
--Mostrar los códigos de aquellos proveedores que hayan superado
--las ventas totales realizadas por el proveedor ’S1’.

select codpro, sum(cantidad) from ventas 
group by codpro having sum(cantidad) >
(select sum(cantidad) from ventas where codpro = 'S1');



--Ejercicio 3.43 
--Mostrar los mejores proveedores, 
--entendiéndose como los que tienen mayores
--cantidades totales.

select codpro, sum(cantidad) from ventas
group by codpro having sum(cantidad) >=
all(select sum(cantidad) from ventas group by codpro);



--Ejercicio 3.44 
--Mostrar los proveedores que venden piezas a todas las ciudades de los
--proyectos a los que suministra ’S3’, sin incluirlo.

select v2.codpro from ventas v2, proyecto j2 
where v2.codpj = j2.codpj and v2.codpro='S3'
minus (select codpro from proveedor where codpro='S3');



--Ejercicio 3.45
--Encontrar aquellos proveedores que hayan hecho al menos diez pedidos

select codpro from ventas group by codpro having  count(*)>=10;



--Ejercicio 3.46 
--Se entiende que S1 no está incluido, sino que forma parte de la condición
--Encontrar aquellos proveedores que venden todas las piezas suministradas
--por S1.

select codpro from proveedor where not exists (
select * from pieza,ventas where ventas.codpro='S1' and
pieza.codpie=ventas.codpie and not exists (
select * from ventas where pieza.codpie=ventas.codpie and
proveedor.codpro=ventas .codpro));


--Ejercicio 3.47 
--Encontrar la cantidad total de piezas que ha vendido cada proveedor que
--cumple la condición de vender todas las piezas suministradas por S1.

select sum(cantidad) from ventas where
codpro = (select codpro from proveedor where not exists (
select * from pieza,ventas where ventas.codpro='S1' and
pieza.codpie=ventas.codpie and not exists (
select * from ventas where pieza.codpie=ventas.codpie and
proveedor.codpro=ventas .codpro)));



--Ejercicio 3.48 
--Encontrar qué proyectos están suministrados por todos los proveedores 
--que suministran la pieza P3.

select distinct codpj from ventas v1 where not exists
((select codpro from ventas v2 where v2.codpie='P3') minus
(select codpro from ventas v3 where v3.codpj=v1.codpj));



--Ejercicio 3.49 
--Encontrar la cantidad media de piezas suministrada a 
--aquellos proveedores que venden la pieza P3.

select avg(cantidad) from ventas where codpro in
(select codpro from ventas where codpie='P3');



--Ejercicio 3.50 
--Queremos saber los nombres de tus índices y sobre 
--qué tablas están montados, indica además su propietario.

--select index_name, table_name, table_owner from user_indexes;



--Ejercicio 3.51 
--Implementar el comando DESCRIBE para tu tabla ventas a través de una
--consulta a las vistas del catálogo.

select column_name, nullable, data_type, data_length from
USER_TAB_COLUMNS where table_name='VENTAS';



--Ejercicio 3.52 
--Mostrar para cada proveedor la media de productos suministrados 
--cada año. Piensa con detenimiento el significado de la palabra 
--todos/as en las siguientes tres consultas y resuélvelas convenientemente:

select fecha, codpro, avg(cantidad) from ventas group by codpro,fecha order by fecha;



--Ejercicio 3.53 
--Encontrar todos los proveedores que venden una pieza roja

select distinct codpro from ventas  where codpie in
(select codpie from pieza where color='Rojo') group by
ventas.codpro having count(*)=1;



--Ejercicio 3.55 
--Encontrar todos los proveedores tales que todas las piezas 
--que venden son rojas. 

select distinct codpro from ventas where codpro in 
(select v2.codpro from ventas v2, pieza p
where v2.codpie=p.codpie and p.color='Rojo');



--Ejercicio 3.56 
--Encontrar el nombre de aquellos proveedores que venden 
--más de una pieza roja.

select distinct codpro from ventas  where codpie in
(select codpie from pieza where color='Rojo') group by
ventas.codpro having count(*)>1;



--Ejercicio 3.58 
--Coloca el status igual a 1 a aquellos proveedores 
--que sólo suministran la pieza P1.

Update proveedor set status='1' where codpro in
(select codpro from ventas where codpie='P1');



--Ejercicio 3.60 
--Muestra la información disponible acerca de los encuentros de liga.

select * from encuentros;



--Ejercicio 3.61 
--Muestra los nombres de los equipos y de los jugadores 
--ordenados alfabéticamente.

select jugadores.nombreJ, equipos.nombreE from jugadores, equipos where equipos.codE=jugadores.codE;



--Ejercicio 3.62 
--Muestra los jugadores que no tienen ninguna falta.

select nombreJ from jugadores where codJ in
(select codJ from alineaciones where faltas = 0);



--Ejercicio 3.63 
--Muestra los compañeros de equipo del jugador que tiene 
--por código x (codJ=’x’) y donde x es uno elegido por ti.

select codJ, nombreJ from jugadores where codJ<>'C1' and codE in
(select codE from jugadores where codJ='C1');



--Ejercicio 3.64 
--Muestra los jugadores y la localidad donde juegan (la de sus equipos).

select j1.nombreJ, e1.localidad from jugadores j1, equipos e1 where
j1.codE=e1.codE;



--Ejercicio 3.65 
--Muestra los equipos que han ganado algún encuentro jugando como local.

select codE, nombreE from equipos where codE in
(select distinct Elocal from encuentros where Plocal>Pvisitante);



--Ejercicio 3.66 
--Muestra los equipos que han ganado algún encuentro. 

select distinct codE, nombreE from equipos where codE in
(select codE from encuentros where Plocal>Pvisitante or Pvisitante>Plocal);



--Ejercicio 3.67 
--Muestra los equipos que todos los encuentros han ganado lo 
--han hecho como equipo local.

select distinct eq.eLocal from encuentros eq where exists(select eLocal from encuentros where pLocal> pVisitante
minus (select eLocal from encuentros where pLocal < Pvisitante));



--Ejercicio 3.68 
--Muestra los equipos que han ganado todos los 
--encuentros jugando como equipo local.

(select eLocal from encuentros e1 where pLocal > pVisitante) minus
(select eLocal from encuentros where pLocal<pVisitante);



--Ejercicio 3.69 
--Muestra los encuentros que faltan para terminar la liga.

select Elocal, Evisitante, fecha from encuentros where encuentros.fecha > sysdate;



--Ejercicio 3.71 
--Para cada equipo muestra el número de encuentros 
--que ha disputado como local. 

select eLocal, count(eLocal) from encuentros group by eLocal;



--Ejercicio 3.72
--Muestra los encuentros en los que se alcanzó mayor diferencia. 

select eLocal, eVisitante, abs(pLocal-PVisitante) from encuentros order by abs(pLocal-PVisitante) desc;



--Ejercicio 3.73 
--Muestra los jugadores que no han superado 3 faltas acumuladas. 

select codJ, sum(faltas) from alineaciones group by codJ having (sum(faltas)<3);



--Ejercicio 3.74 
--Muestra los equipos con mayores puntuaciones en los partidos 
--jugados fuera de casa. 

select evisitante, sum(pVisitante) from encuentros group by(evisitante) 
order by sum(pvisitante) desc;



--Ejercicio 3.76 
--Muestra el equipo con mayor número de victorias. 

select e.nombree, count(*) from encuentros p, equipos e where 
(pLocal>pVisitante and p.eLocal=e.codE) or (pLocal<pVisitante and p.eVisitante=e.codE)
group by e.nombree order by count(*) desc;



--Ejercicio 3.77 
--Muestra el promedio de puntos por equipo en los encuentros de ida.

select e.codE , avg(p.pLocal) from encuentros p, equipos e
where p.eLocal=e.codE group by e.codE;







