# Consulta de Linhas Intermunicipais de �nibus (SC) 
==============
### O que �?
Este projeto visa melhorar a consulta de linhas intermunicipais de �nibus existente hoje no [site do DETER/SC](www.deter.sc.gov.br/index.php?modulo=conteudo&int_seq_secao=15&int_seq_subsecao=95&int_seq_conteudo=21).
 
### Instala��o
No Tomcat 8 fazer deploy do �ltimo WAR disponibilizado na pasta dist/.
### Execu��o
Acessar a URL http://host[:porta]/contexto/horario.
Ex.: http://localhost:8080/deter-1/horario.
### Como trabalhar no c�digo fonte?
Sugiro importar o projeto no eclipse como Projeto Maven.
### Bibliotecas utilizadas
 - VRaptor 4.2.0-RC3
 - Java Servlet API 3.1
 - JSP 2.2
 - jsoup 1.8.3
 - gson 2.2.2


