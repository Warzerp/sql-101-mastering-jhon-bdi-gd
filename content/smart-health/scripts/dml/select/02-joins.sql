-- La tercera consulta obtiene el listado de municipios y sus respectivos 
-- departamentos, uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar
--  la localización geográfica, mostrando los 15 primeros resultados.

-- INNER JOIN
-- 1. Tablas asociadas
-- smart_health.municipalities T1
-- smart_health.departments T2

-- 2. Llaves de cruce
-- T1.department_code
-- T2.department_code
SELECT
    T1.municipality_code AS codigo_municipio,
    T1.municipality_name AS municipio,
    T2.department_name AS departamento

FROM municipalities T1
INNER JOIN departments T2 ON T1.department_code = T2.department_code
ORDER BY T2.department_name
LIMIT 15;

-- Contar los pacientes que tengan o no tengan
-- un numero de telefono asociado.

-- RIGTH JOIN
-- 1. Tablas asociadas
-- smart_health.patients T1
-- smart_health.patients_phones T2

-- 2. Llaves de cruce
-- T1.patient_id
-- T2.patient_id
SELECT
    COUNT(DISTINCT T1.patient_id)
FROM patient_phones T1
RIGHT JOIN patients T2 ON T1.patient_id = T2.patient_id;

-- 3.

-- Contar los doctores que no tengan una especialidad.
SELECT
    COUNT(*)
FROM doctor_specialties T1
LEFT JOIN  doctors T2 ON T1.doctor_id = T2.doctor_id
WHERE T1.specialty_id= NULL;



-- 4. Mostrar las citas que se haya cancelado
-- entre el 20 de octubre del 2025 y el 23 de octubre del 2025.
-- Adicionalmente, es importante conocer, en que cuarto se iban 
-- a atender estas citas. Y la razon de la cancelacion si la hay.
-- Mostrar solo los 10 primeros registros.
-- Rehabilitación
SELECT
    T1.appointment_date,
    T2.room_name,
    T1.appointment_type,
    T1.reason

FROM appointments T1
INNER JOIN rooms T2 ON T1.room_id = T2.room_id
WHERE appointment_date BETWEEN '2025-10-20' AND '2025-10-23'
AND T1.status = 'Cancelled'
ORDER BY T2.room_name
LIMIT 10;

-- -- 3️⃣ La tercera consulta obtiene el listado de municipios y sus respectivos 
-- departamentos, uniendo ambas tablas mediante la clave foránea department_code. 
-- Se ordena por el nombre del departamento para facilitar la localización 
-- geográfica, mostrando los 15 primeros resultados.
--------------------------------------------------------

--Obtener los pacientes(primer nombre,genero y correo, numero telf), con sus numeros de telefonos
-- que tengan los siguientes numeros de documentos

--identificar tipo join, tablas comprometidas, relaciones
--SELECT:
--primer nombre
--genero
--numero de telefono
--INNER JOIN
-- smart_health.patients: patient_id (PK)
-- : patient_id (FK)

SELECT
    A.first_name AS primer_nombre,
    A.gender AS genero,
    A.email AS correo,
    B.phone_number AS numero_telefono

FROM smart_health.patients A
INNER JOIN smart_health.patient_phones B 
    ON  A.patient_id = B.patient_id

WHERE A.document_number IN
(
'30451580'
'1006631391',
'1009149871',
'1298083',
'1004928596',
'1008188849',
'1607132',
'30470003'

);    

--------------------------------------
--Obtener los pacientes(primer nombre,genero y correo, numero telf), con sus numeros de telefonos
-- que tengan los siguientes numeros de documentos (tengan o no number )

--identificar tipo join, tablas comprometidas, relaciones
--SELECT:
--primer nombre
--genero
--numero de telefono
--INNER JOIN
-- smart_health.patients: patient_id (PK)
-- : patient_id (FK)

SELECT
    B.first_name AS primer_nombre,
    B.gender AS genero,
    B.email AS correo,
    A.phone_number AS numero_telefono

FROM smart_health.patient_phones A
RIGHT JOIN smart_health.patients B 
    ON  A.patient_id = B.patient_id

WHERE B.document_number IN
(
'30451580'   
'1006631391',
'1009149871',
'1298083',
'1004928596',
'1008188849',
'1607132',
'30470003'

);  
--------------------------------------------------------------------
--CONTAR MEDICOS QUE NO TIENEN DIRECCION

--LEFT JOIN

--smart_health.doctors:  doctor_id (PK)
--smart_health.doctor.addresses: doctor_id(FK)
SELECT
    COUNT(*) AS total_doctores_sin_dirección

FROM smart_health.doctors A
LEFT JOIN  smart_health.doctor_addresses B
    ON A.doctor_id = B.doctor_id
WHERE B.doctor_id IS NULL;     
------------------------------------------------------------------------------
--mostrar nombre completo del paciente,genero,tipo de sangre,direccion,ciudad(municipio) y 
--departamento de los pacientes que viven en pamplona, ns. ordenar por el
--primer nombre de forma alfabetica. Mostrar los primeros 5 resultados

--identificar tipo join, tablas comprometidas, relaciones
--coalesce(campo,'')
--tablas:pacientes,direcciones,pac-dire,departamentos,muncipios/ciudades


--FROM: patients-->A
--FROM: adresses -->B
-- Ejecuta esto dentro de psql (no en cmd puro)
-- consulta_pacientes.sql
-- mostrar 5 pacientes que viven en Pamplona, NS
SET search_path TO smart_health;

SELECT
  -- nombre completo simple
  COALESCE(p.first_name,'') || ' ' || COALESCE(p.first_surname,'') AS nombre_completo,
  COALESCE(p.gender,'') AS genero,
  COALESCE(p.blood_type, p.document_number, '') AS tipo_sangre_o_doc,
  COALESCE(a.address_line,'') AS direccion,
  COALESCE(m.municipality_name,'') AS municipio,
  COALESCE(d.department_name,'') AS departamento
FROM patients p
JOIN patient_addresses pa ON pa.patient_id = p.patient_id
JOIN addresses a ON a.address_id = pa.address_id
JOIN municipalities m ON m.municipality_code = a.municipality_code
JOIN departments d ON d.department_code = m.department_code
WHERE LOWER(m.municipality_name) = 'pamplona'
  AND LOWER(d.department_name) = 'norte de santander'
ORDER BY p.first_name ASC
LIMIT 5;

----------------------------------------------------------------------
---2. Listar los nombres de los municipios y las direcciones registradas en cada uno, de manera que se muestren 
---todos los municipios, incluso los que no tengan direcciones asociadas.
SET search_path TO smart_health;

SELECT
  m.municipality_name AS municipio,
  COALESCE(a.address_line, '') AS direccion
FROM municipalities m
LEFT JOIN addresses a
  ON a.municipality_code = m.municipality_code
ORDER BY m.municipality_name ASC;
------------------------------------------------------------
--3. Consultar las citas médicas junto con el nombre y apellido del
--- médico asignado, filtrando solo las citas con estado “Confirmed”.

-- Ejecuta esto dentro de psql (SET search_path opcional)
SET search_path TO smart_health;

SELECT
  a.appointment_id,
  a.appointment_date,
  a.start_time,
  a.end_time,
  COALESCE(d.first_name, '') || ' ' || COALESCE(d.last_name, '') AS medico_nombre_apellido,
  COALESCE(a.status, '') AS estado,
  COALESCE(a.reason, '') AS motivo
FROM appointments a
JOIN doctors d ON d.doctor_id = a.doctor_id
WHERE a.status = 'Confirmed'
ORDER BY a.appointment_date, a.start_time;
------------------------------------------------------------------------
-------4. Mostrar los nombres y apellidos de los pacientes junto con su dirección principal, 
--de forma que aparezcan también los pacientes sin dirección registrada.
-- Mostrar nombre y dirección principal (incluir pacientes sin dirección)
SET search_path TO smart_health;

SELECT
  TRIM(
    COALESCE(p.first_name,'') || ' ' || COALESCE(p.middle_name,'') || ' ' ||
    COALESCE(p.first_surname,'') || ' ' || COALESCE(p.second_surname,'')
  ) AS nombre_completo,
  COALESCE(p.gender,'') AS genero,
  COALESCE(a.address_line,'') AS direccion_principal,
  COALESCE(m.municipality_name,'') AS municipio,
  COALESCE(d.department_name,'') AS departamento
FROM smart_health.patients p
LEFT JOIN smart_health.patient_addresses pa
  ON pa.patient_id = p.patient_id
  AND pa.is_primary = TRUE
LEFT JOIN smart_health.addresses a
  ON a.address_id = pa.address_id
LEFT JOIN smart_health.municipalities m
  ON m.municipality_code = a.municipality_code
LEFT JOIN smart_health.departments d
  ON d.department_code = m.department_code
ORDER BY COALESCE(p.first_name,'') ASC
LIMIT 100;
----5. Agrupar los pacientes por tipo de sangre y mostrar la cantidad de tipos de sangre que tienen cada uno.
-- contar pacientes por tipo de sangre
SET search_path TO smart_health;

SELECT
  COALESCE(blood_type, 'SIN_DATOS') AS tipo_sangre,
  COUNT(*) AS cantidad_pacientes
FROM smart_health.patients
GROUP BY COALESCE(blood_type, 'SIN_DATOS')
ORDER BY cantidad_pacientes DESC;
