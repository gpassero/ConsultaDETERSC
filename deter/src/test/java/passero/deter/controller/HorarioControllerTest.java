package passero.deter.controller;

import java.text.MessageFormat;

import br.com.caelum.vraptor.util.StringUtils;

public class HorarioControllerTest {

	public static void main(String args[]) {
//		System.out.println(StringUtils.capitalize("teste"));
//		String MASCARA_URL = "http://www2.deter.sc.gov.br/cgi-bin/users/relatorio.pl?localo=%s&locald=%s";
//		String url = String.format(MASCARA_URL, "RIO+DO+SUL", "TROMB+CENTRAL");
//		System.out.println("URL formatada: " + url);
		String[] cidades = {"TROMB CENTRAL", "BRAACATINGA - TROMB CENTRAL", "Agronomica", "Braco Trombudo", "Rio do Sul"};
		HorarioController c = new HorarioController();
		for (String cidade : cidades) {			
			System.out.println(cidade + " -> " + c.corrigirMaiusculas(c.corrigirNome(cidade)));
			//System.out.println(c.consultar("Trombudo Central", "Agronomica").size());
		}		
	}
}
