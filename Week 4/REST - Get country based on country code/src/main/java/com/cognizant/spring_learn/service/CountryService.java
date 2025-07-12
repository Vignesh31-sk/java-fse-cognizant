package com.cognizant.spring_learn.service;

import com.cognizant.spring_learn.model.Country;
import org.springframework.stereotype.Service;
import org.w3c.dom.*;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service
public class CountryService {
    public Country getCountry(String code) throws Exception {
        List<Country> countries = getCountriesFromXml();
        return countries.stream()
                .filter(c -> c.getCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseThrow(() -> new Exception("Country not found"));
    }

    private List<Country> getCountriesFromXml() throws Exception {
        List<Country> countries = new ArrayList<>();
        InputStream is = getClass().getClassLoader().getResourceAsStream("country.xml");
        if (is == null)
            throw new Exception("country.xml not found");
        Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
        NodeList nodeList = doc.getElementsByTagName("country");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Element element = (Element) nodeList.item(i);
            String code = element.getElementsByTagName("code").item(0).getTextContent();
            String name = element.getElementsByTagName("name").item(0).getTextContent();
            countries.add(new Country(code, name));
        }
        return countries;
    }
}
