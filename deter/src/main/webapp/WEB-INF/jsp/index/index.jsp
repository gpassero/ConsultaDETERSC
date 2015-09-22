<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>VRaptor Blank Project</title>
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script src="${pageContext.request.contextPath}/js/typeahead.bundle.js"></script>

<style type="text/css">
@font-face {
    font-family:"Prociono";
    src: url("../font/Prociono-Regular-webfont.ttf");
}
html {
    overflow-y: scroll;
}
.container {
    margin: 0 auto;
    max-width: 750px;
    text-align: center;
}
.tt-dropdown-menu, .gist {
    text-align: left;
}
html {
    color: #333333;
    font-family:"Helvetica Neue", Helvetica, Arial, sans-serif;
    font-size: 18px;
    line-height: 1.2;
}
.title, .example-name {
    font-family: Prociono;
}
p {
    margin: 0 0 10px;
}
.title {
    font-size: 64px;
    margin: 20px 0 0;
}
.example {
    padding: 30px 0;
}
.example-name {
    font-size: 32px;
    margin: 20px 0;
}
.demo {
    margin: 50px 0;
    position: relative;
}
.typeahead, .tt-query, .tt-hint {
    border: 2px solid #CCCCCC;
    border-radius: 8px 8px 8px 8px;
    font-size: 24px;
    height: 30px;
    line-height: 30px;
    outline: medium none;
    padding: 8px 12px;
    width: 396px;
}
.typeahead {
    background-color: #FFFFFF;
}
.typeahead:focus {
    border: 2px solid #0097CF;
}
.tt-query {
    box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
}
.tt-hint {
    color: #999999;
}
.tt-dropdown-menu {
    background-color: #FFFFFF;
    border: 1px solid rgba(0, 0, 0, 0.2);
    border-radius: 8px 8px 8px 8px;
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    margin-top: 12px;
    padding: 8px 0;
    width: 422px;
}
.tt-suggestion {
    font-size: 18px;
    line-height: 24px;
    padding: 3px 20px;
}
.tt-suggestion.tt-cursor {
    background-color: #0097CF;
    color: #FFFFFF;
}
.tt-suggestion p {
    margin: 0;
}
.gist {
    font-size: 14px;
}
.example-twitter-oss .tt-suggestion {
    padding: 8px 20px;
}
.example-twitter-oss .tt-suggestion + .tt-suggestion {
    border-top: 1px solid #CCCCCC;
}
.example-twitter-oss .repo-language {
    float: right;
    font-style: italic;
}
.example-twitter-oss .repo-name {
    font-weight: bold;
}
.example-twitter-oss .repo-description {
    font-size: 14px;
}
.example-sports .league-name {
    border-bottom: 1px solid #CCCCCC;
    margin: 0 20px 5px;
    padding: 3px 0;
}
.example-arabic .tt-dropdown-menu {
    text-align: right;
}
</style>
<script type='text/javascript'>
//$(function(){
	var url = '${pageContext.request.contextPath}/horario/listarLocais?simplificado=true';

var names = ["Sánchez", "Árbol", "Müller", "Ératio", "Niño"];

var charMap = {'àáâããäå': 'a', 'èéêë': 'e', 'ìíî': 'i', 'òóô': 'o', 'ùúû': 'u', 'ç': 'c', 'ß': 'ss', /* ... */};

var normalize = function(str) {
  $.each(charMap, function(chars, normalized) {
    var regex = new RegExp('[' + chars + ']', 'gi');
    str = str.replace(regex, normalized);
  });

  return str;
}

var locais = $.map(names, function (nome) {
    // Normalize the name - use this for searching
    var normalized = normalize(nome);
    return {
        value: normalized,
        // Include the original name - use this for display purposes
        displayValue: nome
    };})
    
    
var queryTokenizer = function(q) {
  var normalized = normalize(q);
  return Bloodhound.tokenizers.whitespace(normalized);
};	

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
	var nombres = new Bloodhound({
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

	nombres.initialize();

	$('#search').typeahead({
	    minLength: 1,
	    hint: false,
	    highlight: true
	}, {
	    name: 'locais',
		displayKey: 'displayValue',
	    source: nombres.ttAdapter(),
	    limit: 20
	});
});
	
</script>
</head>
<body>
	It works!! ${variable} ${linkTo[IndexController].index}
	<input id="search" class="typeahead" type="text"></input>
</body>
</html>