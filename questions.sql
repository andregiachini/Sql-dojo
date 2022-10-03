1  Listar os empregados (nomes) que tem salário maior que seu chefe

select *
from empregados e 
WHERE e.salario > (SELECT c.salario from empregados c where c.emp_id = e.supervisor_id)


--  empregado | chefe | emp sal | chef sal 
-- -----------+-------+---------+----------
--  Maria     | Jose  |    9500 |     8000
--  Claudia   | Jose  |   10000 |     8000
--  Ana       | Jose  |   12200 |     8000
--  Luiz      | Pedro |    8000 |     7500


2 Listar o maior salario de cada departamento (pode ser usado o group by)

SELECT d.nome, max(e.salario) as salarioo
from empregados e join departamentos d on e.dep_id = d.dep_id
GROUP by d.nome
order by salarioo DESC






3 Listar o nome do funcionario com maior salario dentro de cada departamento (pode ser usado o IN)

elect e.nome, e.salario, e.dep_id 
from empregados e 
where salario in (select max(salario) from empregados s where e.dep_id = s.dep_id  group by dep_id);


--  dep_id | nome  | salario 
-- --------+-------+---------
--       3 | Joao  | 6000
--       1 | Maria | 9500
--       4 | Ana   | 12200
--       2 | Luiz  | 8000

4 Listar os nomes departamentos que tem menos de 3 empregados;

select d.dep_id, d.nome 
from departamentos d
where (select count(dep_id) from empregados c where d.dep_id=c.dep_id) < 3;



--  nome 
-- ------
--  TI



6 Listar os departamentos  com o número de colaboradores

select dep_id, count(dep_id) as count 
from empregados
group by dep_id;

--    nome    | count 
-- -----------+-------
--  Marketing |     1
--  RH        |     2
--  TI        |     4
--  Vendas    |     1


7 Listar os empregados que não possuem chefes no mesmo departamento 

select e.nome, e.dep_id 
from empregados e
where dep_id != (select dep_id from empregados s where s.emp_id = e.supervisor_id);



--  nome | dep_id 
-- ------+--------
--  Joao |      3
--  Ana  |      4


8 Listar os departamentos com o total de salários pagos 

select dep_id, sum(salario) as sum 
from empregados
where dep_id = dep_id group by dep_id;

9  Listar os colaboradores com salario maior que a média do seu departamento;

select e.nome, e.dep_id 
from empregados e
where salario > (select avg(salario) from empregados d where e.dep_id = d.dep_id);






10 Compare o salario de cada colaborados com média do seu setor. Dica: usar slide windows functions (https://www.postgresqltutorial.com/postgresql-window-function/)


SELECT emp_id, nome, dep_id, salario, AVG(salario) OVER (PARTITION BY dep_id) FROM empregados;


-- emp_id |   nome    | dep_id | salario |          avg           
-- --------+-----------+--------+---------+------------------------
--       1 | Jose      |      1 |    8000 |  8125.0000000000000000
--       6 | Claudia   |      1 |   10000 |  8125.0000000000000000
--       3 | Guilherme |      1 |    5000 |  8125.0000000000000000
--       4 | Maria     |      1 |    9500 |  8125.0000000000000000
--       8 | Luiz      |      2 |    8000 |  7750.0000000000000000
--       5 | Pedro     |      2 |    7500 |  7750.0000000000000000
--       2 | Joao      |      3 |    6000 |  6000.0000000000000000
--       7 | Ana       |      4 |   12200 | 12200.0000000000000000


11 - Encontre os empregados com salario maior ou igual a média do seu departamento. Deve ser reportado o salario do empregado e a média do departamento (dica: usar window function com subconsulta)

select e.salario, e.nome
from empregados as e
where e.salario >= (select avg(e2.salario) as ss
                  from empregados e2
                  where e2.dep_id = e.dep_id);

--   nome   | salario | dep_id |       avg_salary       
-- ---------+---------+--------+------------------------
--  Claudia |   10000 |      1 |  8125.0000000000000000
--  Maria   |    9500 |      1 |  8125.0000000000000000
--  Luiz    |    8000 |      2 |  7750.0000000000000000
--  Joao    |    6000 |      3 |  6000.0000000000000000
--  Ana     |   12200 |      4 | 12200.0000000000000000

N - Faça um questão livre e responda com join e subconsulta; 
