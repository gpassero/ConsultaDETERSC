package passero.deter.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.text.DateFormat;
import java.text.MessageFormat;
import java.text.Normalizer;
import java.text.Normalizer.Form;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.inject.Inject;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.google.common.io.Files;
import com.google.gson.Gson;

import br.com.caelum.vraptor.Controller;
import br.com.caelum.vraptor.Path;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.util.StringUtils;
import br.com.caelum.vraptor.view.Results;
import passero.deter.model.Local;
import passero.deter.model.Horario;

@Controller
public class HorarioController {
	@Inject
	private Result result;
	private List<Local> locais;
	private HashMap<String, String> locaisMap;
	private ArrayList<String> locaisNome;
	private final String MASCARA_URL = "http://www2.deter.sc.gov.br/cgi-bin/users/relatorio.pl?localo=%s&locald=%s";
	private final String MASCARA_URL_LOCAIS = "http://www2.deter.sc.gov.br/cgi-bin/users/localidades.pl?origem=%s&destino=xx";
	private final String ARQUIVO_LOCAIS = "locais.json";
	private final String ARQUIVO_CIDADES_SC = "todas_as_cidades_de_sc.txt";
	private File arquivoLocais;
	private File arquivoCidadesSC;
	private String localOrigem;
	private String localDestino;
	private List<String> cidadesSC;

	@Path("/horario/")
	public void index() {
		//String url = "http://www2.deter.sc.gov.br/cgi-bin/users/relatorio.pl?localo=PRES+GETULIO&locald=RIO+DO+SUL";
		//List<Horario> horarios = consultar(url);
		//System.out.println(new Gson().toJson(horarios));
	}	

	public List<Horario> consultar(String origem, String destino) {					
		//Procura o nome abreviado (padrão DETER) no mapa de locais		
		carregarLocaisLocal();
		localOrigem = locaisMap.get(normalizar(origem));
		localDestino = locaisMap.get(normalizar(destino));
		if (localOrigem == null  || localOrigem.isEmpty())  localOrigem = origem;
		if (localDestino == null || localDestino.isEmpty()) localDestino = destino;		
		localOrigem = localOrigem.toUpperCase().replace(" ", "+").trim();
		localDestino = localDestino.toUpperCase().replace(" ", "+").trim();
		String url = String.format(MASCARA_URL, localOrigem, localDestino);
		result.include("origem", origem);
		result.include("destino", destino);
		return consultar(url);
	}

	private List<Horario> consultar(String url) {
		List<Horario> horarios = new ArrayList<Horario>();
		try {
			System.out.println("Conectando-se a " + url);										
			Document doc = Jsoup.connect(url).get();
			boolean cabecalho = true;
			for (Element table : doc.select("table")) {				
				for (Element row : table.select("tr")) {
					Elements tds = row.select("td");		
					if (cabecalho) {
						cabecalho = false;
					} else {
						//No caso de rota não encontrada retorna tabela vazia
						if(!tds.get(1).text().isEmpty()) {
							horarios.add(new Horario(tds.get(0).text(),
									tds.get(1).text(),
									tds.get(2).text(),
									tds.get(3).text(),
									tds.get(4).text(),
									tds.get(5).text(),
									tds.get(6).text(),
									tds.get(7).text()=="Partida",
									Double.valueOf(tds.get(8).text().replace(",", "."))));							
						}
					}
				}
			}	
			System.out.println("Resposta " + doc.html());			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();			
		}		
		return horarios;
	}

	public void listarLocais(boolean simplificado) {
		carregarLocaisLocal();
		if(locais != null) {
			if (simplificado) {
				//				locaisNome = new ArrayList<String>();
				//				locaisNome.add("Agonomica");
				//				locaisNome.add("Trombudo");
				//				locaisNome.add("Rio do Sul");
				result.use(Results.json()).withoutRoot().from(locaisNome).serialize();
			} else {
				result.use(Results.json()).from(locais).serialize();
			}			
		} else {
			result.use(Results.status()).internalServerError();
			result.forwardTo(ErroController.class).erro();
		}
	}

	public void listarLocaisRemoto() {
		carregarLocaisRemoto();
		result.use(Results.json()).from(locais).serialize();
	}	

	private void carregarLocaisLocal() {

		try {
			BufferedReader br = new BufferedReader(new FileReader(getArquivoLocais()));
			Local[] locaisArray = new Gson().fromJson(br, Local[].class);
			if (locaisArray != null && locaisArray.length > 0) {
				setLocais(Arrays.asList(locaisArray));					
			} else {
				if (locaisArray != null && locaisArray.length == 0) {
					carregarLocaisRemoto();
				}
				result.use(Results.status()).internalServerError();
				result.forwardTo(ErroController.class).erro();					
				System.out.println("Não foi possível carregar o arquivo " + ARQUIVO_LOCAIS + ".");
			}							
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			result.use(Results.status()).internalServerError();
			result.forwardTo(ErroController.class).erro();			
		}							

	}

	private void setLocais(List<Local> locais) {	
		this.locais = locais;
		Collections.sort(locais, new Comparator() {
			public int compare(Object o1, Object o2) {
				String s1 = ((Local) o1).getNome();
				String s2 = ((Local) o2).getNome();
				boolean s1Principal = s1.contains("-");
				boolean s2Principal = s2.contains("-");
				if (s1Principal == s2Principal) {
					return s1.compareTo(s2);
				} else {
					if (s1Principal && !s2Principal) {
						return 1;								
					} else {
						return -1;
					}
				}
			}
		});		
		locaisMap = new HashMap<String, String>();
		locaisNome = new ArrayList<String>();
		if (locais != null) { 
			for (Local l : locais) {
				locaisMap.put(normalizar(l.getNome()), l.getId());
				locaisNome.add(l.getNome());
			}
		}

	}

	private void carregarLocaisRemoto() {
		HashSet<String> locaisSet = new HashSet<String>();
		int ascii_a = 97;
		int ascii_l = 108;
		int ascii_z = 122;
		Document doc;
		String url;
		String pesquisa;
		Date inicio = new Date();
		String word;
		System.out.println("Carregamento de locais iniciado em " + inicio.toLocaleString());
		try {
			for(int ascii1 = ascii_a; ascii1 <= ascii_z; ascii1++){
				if (ascii1 == ascii_a) {
					ascii1 = ' ';
				}
				for(int ascii2 = ascii_a; ascii2 <= ascii_z; ascii2++){
					if (ascii1 == ' ') {
						ascii2 = ' ';
					}
					pesquisa = Character.toString((char) ascii1) + Character.toString((char) ascii2);
					url = String.format(MASCARA_URL_LOCAIS, pesquisa);
					doc = Jsoup.connect(url).get();					
					for (Element table : doc.select("table")) {				
						for (Element opt : table.select("option")) {		
							locaisSet.add(opt.text());							
							if (opt.text().contains("-")) {
								word = opt.text().split("-")[1].trim();
								locaisSet.add(word + " - " + word);
							}
						}
					}	
					if (ascii2 == ' ') {
						break;
					}
				} 
				if (ascii1 == ' ') {
					ascii1 = ascii_l;
				}
			}		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Date termino = new Date();
		long tempo = (termino.getTime() - inicio.getTime())/1000;
		System.out.println("Carregamento de locais terminado em " + tempo + " segundos");
		locais = new ArrayList<Local>();
		String localNome;
		String words[];
		for (String localId : locaisSet) {
			if (localId.contains("-")) {
				words = localId.split("-");			
				if (words[0].trim().equals(words[1].trim())) {
					localId = words[0].trim();
				}
			}				
			localNome = localId;
			localNome = corrigirNome(localNome);
			localNome = corrigirMaiusculas(localNome);				
			locais.add(new Local(localId, localNome));
			//DEBUG
//			if (!localId.equals(localNome)) {
//				System.out.println("Nome corrigido: " + localId + " -> " + localNome);
//			}
		}		
		setLocais(locais);
		gravarLocais(locais);	
	}
	
	public String corrigirMaiusculas(String txt) {
		// uma palavra por vez  
		String[] words = txt.trim().split(" ");  
		String out = "";  
		for (int i = 0; i < words.length; i++) {
			words[i] = words[i].toLowerCase();
			if (!out.isEmpty() && (words[i].equals("dos") || words[i].equals("das") ||
					words[i].equals("da") || words[i].equals("do") ||
					words[i].equals("de"))){  
				out += words[i] + " ";    
			} else {  
				out += StringUtils.capitalize(words[i]) + " ";  
			}  		
		}	
		return out.trim();
	}	
	
	//Completa cidades com nome incompleto
	public String corrigirNome(String localNome) {
		String out = "";
		String[] palavras = {localNome};
		if (localNome.contains(" - ")) {
			palavras = localNome.split(" - ");
		}
		carregarCidadesSC();			
		String nomeCorreto = palavras[palavras.length-1];
		String nomeNormalizado = normalizar(palavras[palavras.length-1]);
		for (String cidadeSC : cidadesSC) {			
			if (normalizar(cidadeSC).matches(nomeNormalizado.replace(" ", ".*")+".*")) {				
				nomeCorreto = cidadeSC;				
				if (normalizar(cidadeSC).equals(nomeNormalizado)) {
					break;
				}				
			}										
		}		
		palavras[palavras.length-1] = nomeCorreto;
		if (palavras.length == 1) {
			out = palavras[0];
		} else {
			out = palavras[0].trim() + " - " + palavras[1].trim();
		}
		return out;
	}
	
	private static String normalizar(String palavra) {
	    return Normalizer.normalize(palavra, Form.NFD)
	        .replaceAll("\\p{InCombiningDiacriticalMarks}+", "").trim().toUpperCase();
	}	

	private void carregarCidadesSC() {
		if (cidadesSC == null || cidadesSC.size() == 0) {
			try {
				BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(getArquivoCidadesSC()), "UTF-8"));
				String linha;
				cidadesSC = new ArrayList<String>();
				while ((linha = br.readLine()) != null) {
					cidadesSC.add(linha);
				}
				if (cidadesSC == null || cidadesSC.size() == 0) {
					result.use(Results.status()).internalServerError();
					result.forwardTo(ErroController.class).erro();					
					System.out.println("Não foi possível carregar o arquivo " + ARQUIVO_LOCAIS + ".");
				}							
			} catch (FileNotFoundException e) {
				result.use(Results.status()).internalServerError();
				result.forwardTo(ErroController.class).erro();			
			} catch (IOException e) {
				result.use(Results.status()).internalServerError();
				result.forwardTo(ErroController.class).erro();		
			}	
		}			
	}

	private void gravarLocais(List<Local> locais) {
		try {
			File file = getArquivoLocais();
			if (file.exists()) {
				Date agora = new Date();
				Files.copy(file, new File(file.getAbsolutePath()+"."+String.valueOf(agora.getTime())));
			}
			FileWriter writer = new FileWriter(file);
			String json = new Gson().toJson(locais);
			writer.write(json);
			writer.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}

	private File getArquivoLocais() {
		if (arquivoLocais == null) {
			try {
				arquivoLocais = new File(getClass().getClassLoader().getResource(ARQUIVO_LOCAIS).toURI());
			} catch (URISyntaxException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (NullPointerException e) {
				e.printStackTrace();
			}
		}
		return arquivoLocais;		
	}
	
	private File getArquivoCidadesSC() {
		if (arquivoCidadesSC == null) {
			try {
				
				arquivoCidadesSC = new File(getClass().getClassLoader().getResource(ARQUIVO_CIDADES_SC).toURI());
			} catch (URISyntaxException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return arquivoCidadesSC;		
	}	
	
	public String getLocalOrigem() {
		return localOrigem;
	}

	public void setLocalOrigem(String localOrigem) {
		this.localOrigem = localOrigem;
	}

	public String getLocalDestino() {
		return localDestino;
	}

	public void setLocalDestino(String localDestino) {
		this.localDestino = localDestino;
	}
	
	public static String decodeParametro(String texto) {
	    try {
	        byte[] bytes = texto.getBytes("ISO-8859-1");
	        texto = new String(bytes, "UTF-8");
	    } catch (UnsupportedEncodingException e) {
	        e.printStackTrace();
	        return texto;
	    }

	    return texto;
	}	
}