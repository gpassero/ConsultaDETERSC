<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>VRaptor Blank Project</title>
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script src="${pageContext.request.contextPath}/js/typeahead.bundle.js"></script>
<script type="text/javascript">
		$(document).ready(function(){
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
		});  
	</script>
</head>
<body>
	It works!! ${variable} ${linkTo[IndexController].index}
	<input id="teste" class="typeahead" />
</body>
</html>