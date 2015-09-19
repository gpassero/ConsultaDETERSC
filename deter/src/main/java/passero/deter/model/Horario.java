package passero.deter.model;

public class Horario {
	private String linha;
	private String transportadora;
	private String tipoVeiculo;
	private String hora;
	private String periodo;
	private String frequencia;
	private String tempo;
	private boolean partida;
	private Double tarifa;	
	
	public Horario(String linha, String transportadora, String tipoVeiculo, String hora, String periodo,
			String frequencia, String tempo, boolean partida, Double tarifa) {
		super();
		this.linha = linha;
		this.transportadora = transportadora;
		this.tipoVeiculo = tipoVeiculo;
		this.hora = hora;
		this.periodo = periodo;
		this.frequencia = frequencia;
		this.tempo = tempo;
		this.partida = partida;
		this.tarifa = tarifa;
	}
	public String getLinha() {
		return linha;
	}
	public void setLinha(String linha) {
		this.linha = linha;
	}
	public String getTransportadora() {
		return transportadora;
	}
	public void setTransportadora(String transportadora) {
		this.transportadora = transportadora;
	}
	public String getTipoVeiculo() {
		return tipoVeiculo;
	}
	public void setTipoVeiculo(String tipoVeiculo) {
		this.tipoVeiculo = tipoVeiculo;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getFrequencia() {
		return frequencia;
	}
	public void setFrequencia(String frequencia) {
		this.frequencia = frequencia;
	}
	public String getTempo() {
		return tempo;
	}
	public void setTempo(String tempo) {
		this.tempo = tempo;
	}
	public boolean isPartida() {
		return partida;
	}
	public void setPartida(boolean partida) {
		this.partida = partida;
	}
	public Double getTarifa() {
		return tarifa;
	}
	public void setTarifa(Double tarifa) {
		this.tarifa = tarifa;
	}
			
}
