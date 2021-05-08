select schema_name(objeto.schema_id) + '.' + objeto.name as [procedure],					
       'usada por' as ref,														
       schema_name(referencia.schema_id) + '.' + referencia.name as [object],				
       referencia.type_desc as object_type											
from sys.objects objeto																
	join sys.sql_expression_dependencies dependencia on objeto.object_id = dependencia.referenced_id	
	join sys.objects referencia  on dep.referencing_id = referencia.object_id
where 
	objeto.type in ('P', 'X')
      and schema_name(objeto.schema_id) = 'dbo'  -- put schema name here
      and objeto.name = 'uspPrintError'  -- put procedure name here
order by [object];


/* 
schema_name(o.schema_id) exibe o nome do schema que é a referência e o.name exibe o nome do procedimento que foi passado no where.
schema_name(ref_o.schema_id) exibe o nome do schema que faz a referência, assim como ref_o.nam exibe o nome do procedimento que faz a referência.
ref_o.type exibe o tipo dos objetos que fazem a referência.

A tabela sys.objects é uma tabela do sistema que armazena os objetos do sistema.
A tabela sys.sql_expression_dependencies armazena as relações de dependências entre objetos do sistema.

Dessa forma, o primeiro join vincula o Objeto do sistema, que foi passado, aos Objetos que dependem dele. 	(relação de pai com seus filhos)
O segundo join vincula os objetos do sistema que dependem do Objeto que foi passado.						(relação de filho com seu pai)

A variável 'P', no tipo dos objetos (o.type) é para exibir os procedimentos armazenados (Stored Procedures).
schema_name(o.schema_id) é a variável para receber o schema que desejamos observar.
o.name é a variável para receber a procedure que desejamos observar

A ordenação é de acordo com os objetos "filhos".
*/