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
SELECT
    first_name,
    middle_name,
    first_surname,
    second_surname,
    gender,
    blood_type,
    address_id,
    municipality_code
    postal_code

FROM smart_health.address A 
RIGHT JOIN smart_health.patients B
    ON A.patients_id = B.patients_id  
    ORDER BY first_name DESC
    LIMIT 5;




