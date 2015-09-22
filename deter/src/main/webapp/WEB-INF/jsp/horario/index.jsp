<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" 
%>
<!DOCTYPE html>
<html lang="pt-br">
<head> 
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" charset="utf-8">
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
		</div>

	</div>
	<!-- /.container -->

	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>  -->
	<script type='text/javascript' src='//code.jquery.com/jquery-2.1.0.js'></script>
	<script src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/typeahead.bundle.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){			
			$('#consulta-form').submit(function(event) {
	            $(this).ajaxSubmit({type : "post",
	                  url : '${pageContext.request.contextPath}/horario/consultar',
	                  contentType: 'application/x-www-form-urlencoded; charset=utf-8',
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
			var charMap = {'àáâããäå': 'a', 'èéêë': 'e', 'ìíî': 'i', 'òóô': 'o', 'ùúû': 'u', 'ç': 'c', 'ß': 'ss', /* ... */};
			var normalize = function(str) {
			  $.each(charMap, function(chars, normalized) {
			    var regex = new RegExp('[' + chars + ']', 'gi');
			    str = str.replace(regex, normalized);
			  });

			  return str;
			}
			var queryTokenizer = function(q) {
			  var normalized = normalize(q);
			  return Bloodhound.tokenizers.whitespace(normalized);
			};		
			var url = '${pageContext.request.contextPath}/horario/listarLocais?simplificado=true';
			var locais;
			$.get(url, function(data) {
				locais = $.map(data, function (nome) {
		        // Normalize the name - use this for searching
		        var normalized = normalize(nome);
		        return {
		            value: normalized,
		            // Include the original name - use this for display purposes
		            displayValue: nome
		        };})  
	 			var engine = new Bloodhound({
	 				datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
					queryTokenizer: queryTokenizer,					  
				    local: locais,				
				    sorter: function(a, b) {
						var al = a.value.indexOf('-', 0) > 0;
						var bl = b.value.indexOf('-', 0) > 0;
	                 	if(al != bl){ 
		                	return al ? 1 : -1;
		                 } else {
		                	 return a.value.localeCompare(b.value);         	 
		                 } 
	                 	}						
	 				});
	 			engine.initialize();
				$('input.typeahead').typeahead({
					  hint: true,
					  highlight: true,
					  minLength: 1					  
					},
					{
					  name: 'locais',
					  displayKey: 'displayValue',
					  source: engine.ttAdapter(),	
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
