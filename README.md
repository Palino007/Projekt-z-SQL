## # Projekt z SQL

**Úvod do projektu:**
Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.

# Tento projekt vznikl v rámci Engeto Data Akademie a jeho cílem je pomocí SQL odpovědět na výzkumné otázky:
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách     
   potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Projekt využívá dvě vlastní tabulky:

- **Primary:** `t_pavol_medo_project_SQL_primary_final`
- **Secondary:** `t_pavol_medo_project_SQL_secondary_final`

Obě tabulky byly vytvořeny z dat dostupných v PostgreSQL.

---

## Struktura projektu

README.md                        # Popis projektu, komentáře a odpovědi k výzkumným otázkám
p_create_primary_table.sql       # Skript vytvářející tabulku t_pavol_medo_project_SQL_primary_final
p_create_secondary_table.sql     # Skript vytvářející tabulku t_pavol_medo_project_SQL_secondary_final
1-5_vyzkumna_otazka.sql          # Skripty generující tabulky s daty potřebnými k zodpovězení 1.-5. výzkumné otázce

---

# Popis tabulek

## **Primary table**  
` t_pavol_medo_project_SQL_primary_final `

### **Sloupce:**
| Sloupec        | Popis |
|----------------|-------|
| year           | Rok |
| industry_name  | Název odvětví |
| avg_wage       | Průměrná mzda v odvětví |
| category_name  | Název potraviny |
| avg_price      | Průměrná cena potraviny |
| units          | Jednotka (kg / l) |

---

## **Secondary table**  
` t_pavol_medo_project_SQL_secondary_final `

### **Sloupce:**
| Sloupec        | Popis |
|----------------|-------|
| country_name   | Název státu |
| year           | Rok |
| gdp_million    | HDP v milionech (zaokrouhlené) |
| gini           | Koeficient příjmové nerovnosti |
| population     | Populace |

---

# Odpovědi na výzkumné otázky

Součástí projektu je sada SQL dotazů, které získávají datový podklad k odpovědím na výzkumné otázky:

## ** 1. Otázka:**  
**Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

V průběhu let 2006 - 2018 byl celkový trend růstu mezd kladný, avšak v některých odvětvích došlo meziročně i k poklesu mezd. Největší pokles nastal v r. 2013, konkrétně v odvětvích:
Peněžnictví a pojišťovnictví -4 484,-
Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu -1 895,50,-
Těžba a dobývání -1 053,75,-

---

## ** 2. Otázka:**  
**Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

Pracovník si na začátku období mohl za průměrnou mzdu koupit téměř 1 465 litrů mléka a 1 313 kg chleba. Na konci období 1 669 litrů mléka a 1 365 kg chleba. Kupní síla se tedy v čase změnila, přičemž je vidět, jak růst mezd a cen ovlivnil dostupnost základních potravin.

---

## ** 3. Otázka:**  
**Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

Nejpomaleji se meziročními změnami cen zdražoval cukr krystalový, jehož průměrná cena v daném období dokonce klesala o 1,92 % ročně.

---

## ** 4. Otázka:**  
**Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

Analýza meziročního růstu ukazuje, že v žádném roce (mezi lety 2006 - 2018) nedošlo k růstu cen potravin výrazně vyššímu než růstu mezd (většímu než 10 %). V některých letech rostly ceny pomaleji než mzdy (záporné hodnoty ve sloupci difference). Nejvyšší rozdíl nastal v roce 2013, kdy ceny potravin rostly o 6,65 % rychleji než mzdy.

---

## ** 5. Otázka:**  
**Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**

Výraznější roční růst HDP se nepromítá jednoznačně do výraznějšího růstu mezd ani cen potravin v daném nebo následujícím roce. Data tedy nenaznačují silnou bezprostřední závislost mezi HDP a těmito ukazateli. Nejvýraznější změna nastala v r. 2017, kdy nárůst HDP činil cca 12 milionů oproti předešlému roku, ceny potravin se zvýšili o 9,63% a mzdy vzrostly o 6,17%.

---

# Závěr a shrnutí

Projekt ukazuje, že:
- mzdy v ČR rostly dlouhodobě stabilně,
- kupní síla domácností výrazně posílila,
- nejnižší meziroční procentuální růst vykázal cukr,
- nejvyšší rozdíl nastal v roce 2013, kdy ceny potravin rostly o 6,65 % rychleji než mzdy,
- růst HDP se výrazně (více než 10%) nepromítá do růstu mezd a cen potravin.

---

# Autor

*Pavol Medo* 
Engeto; Data Academy
2025