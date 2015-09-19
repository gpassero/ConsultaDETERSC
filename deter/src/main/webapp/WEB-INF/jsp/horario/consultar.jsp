<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
			<h1 class="text-center">Horários disponíveis</h1>
			<h4 class="text-center">De ${origem} para ${destino}</h4>
			<table class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th>Linha</th>
						<th>Transportadora</th>
						<th>Veículo</th>
						<th>Horário</th>
						<th>Período</th>
						<th>Frequência</th>
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
							<td>${horario.partida == false ? "Trânsito" : "Partida"}</td>
							<td><b>${horario.tarifa}</b></td>
						</tr>
					</c:forEach>				
				</tbody>
			</table>
			<p class="small text-info">Horários aproximados</p>
			<p class="small text-info">Não está incluso o seguro facultativo
				nas tarifas apresentadas</p>