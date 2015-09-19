<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
			<h1 class="text-center">Hor�rios dispon�veis</h1>
			<h4 class="text-center">De ${origem} para ${destino}</h4>
			<table class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th>Linha</th>
						<th>Transportadora</th>
						<th>Ve�culo</th>
						<th>Hor�rio</th>
						<th>Per�odo</th>
						<th>Frequ�ncia</th>
						<th>Tempo (min)</th>
						<th>Trans/Part</th>
						<th>Tarifa (R$)</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${horarioList}" var="horario">					
						<tr>
							<td>${horario.linha}</td>
							<td>${horario.transportadora}</td>
							<td>${horario.tipoVeiculo}</td>
							<td>${horario.hora}</td>
							<td>${horario.periodo}</td>
							<td>${horario.frequencia}</td>
							<td>${horario.tempo}</td>
							<td>${horario.partida == false ? "Tr�nsito" : "Partida"}</td>
							<td><b>${horario.tarifa}</b></td>
						</tr>
					</c:forEach>				
				</tbody>
			</table>
			<p class="small text-info">Hor�rios aproximados</p>
			<p class="small text-info">N�o est� incluso o seguro facultativo
				nas tarifas apresentadas</p>