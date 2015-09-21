# Consulta de Linhas Intermunicipais de Ônibus (SC) 
==============
### O que é?
Este projeto visa melhorar a consulta de linhas intermunicipais de ônibus existente hoje no [site do DETER/SC](http://www.deter.sc.gov.br/index.php?modulo=conteudo&int_seq_secao=15&int_seq_subsecao=95&int_seq_conteudo=21).
- Permitir digitar com acentos (ora, não obriguemos o usuário a cometer erros propositalmente);
- Corrigir a pesquisa por municípios com nome grande (se pesquisar por ''Trombudo Central", por exemplo, não dá resultados, é necessário informar "TROMB CENTRAL");
- Quando o usuário informar o nome completo do município, e não ter municípios com nome parecido, abrir diretamente a tabela com os horários disponíveis, ao invés de exigir do usuário que selecione novamente os municípios já informados;
- Autocompletar o nome dos municípios;
- Existir um meio de cidadãos notificarem horários incorretos (ônibus chega antes ou depois);
- Permitir a consulta via outros dispositivos além do PC (design responsivo ou app nativo).
### Instalação
No Tomcat 8 fazer deploy do último WAR disponibilizado na pasta [dist](deter/dist/).
### Execução
Acessar a URL http://host[:porta]/contexto/horario.
Ex.: http://localhost:8080/deter-1/horario.
### Como trabalhar no código fonte?
Sugiro importar o projeto no eclipse como Projeto Maven.
### Bibliotecas utilizadas
 - VRaptor 4.2.0-RC3
 - Java Servlet API 3.1
 - JSP 2.2
 - jsoup 1.8.3
 - gson 2.2.2


