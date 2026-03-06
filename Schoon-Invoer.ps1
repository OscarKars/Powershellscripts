# Invoer- en uitvoerbestanden
$invoerBestand = "input.csv"
$uitvoerBestand = "output.csv"

# Lijst van tussenvoegsels (kleine letters), inclusief Turkse en Arabische tussenvoegsels
$tussenvoegsels = @(
    # Nederlandse tussenvoegsels
    "van", "den", "der", "de", "het", "ten", "ter", "in", "op", "van der", "van den", "van de",

    # Turkse tussenvoegsels
    "el", "al", "oglu", "kizi", "bey", "hanim",

    # Arabische tussenvoegsels (transliteratie)
    "al", "el", "bin", "ibn", "abd", "abu", "ben", "ibn al", "ibn el"
)

# Functie om vreemde tekens te vervangen door de meest waarschijnlijk ASCII-letter
function Schoon-Tekst([string]$tekst) {
    $vertalingTabel = @{
        # Turkse tekens
        'ı' = 'i'; 'ğ' = 'g'; 'ü' = 'u'; 'ş' = 's'; 'ö' = 'o'; 'ç' = 'c';

        # Spaanse, Franse, Duitse, en andere Europese tekens
        'á' = 'a'; 'à' = 'a'; 'â' = 'a'; 'ä' = 'a'; 'ã' = 'a'; 'å' = 'a';
        'é' = 'e'; 'è' = 'e'; 'ê' = 'e'; 'ë' = 'e';
        'í' = 'i'; 'ì' = 'i'; 'î' = 'i'; 'ï' = 'i';
        'ó' = 'o'; 'ò' = 'o'; 'ô' = 'o'; 'õ' = 'o'; 'ø' = 'o';
        'ú' = 'u'; 'ù' = 'u'; 'û' = 'u';
        'ñ' = 'n'; 'ý' = 'y'; 'ÿ' = 'y';

        # Oost-Europese tekens
        'ć' = 'c'; 'č' = 'c'; 'ď' = 'd'; 'ě' = 'e'; 'ľ' = 'l'; 'ň' = 'n';
        'ř' = 'r'; 'š' = 's'; 'ť' = 't'; 'ů' = 'u'; 'ž' = 'z';

        # Poolse tekens
        'ą' = 'a'; 'ę' = 'e'; 'ł' = 'l'; 'ń' = 'n'; 'ś' = 's'; 'ź' = 'z'; 'ż' = 'z';

        # Russisch (transliteratie naar Latijns alfabet)
        'а' = 'a'; 'б' = 'b'; 'в' = 'v'; 'г' = 'g'; 'д' = 'd'; 'е' = 'e'; 'ё' = 'yo'; 'ж' = 'zh'; 'з' = 'z'; 'и' = 'i';
        'й' = 'y'; 'к' = 'k'; 'л' = 'l'; 'м' = 'm'; 'н' = 'n'; 'о' = 'o'; 'п' = 'p'; 'р' = 'r'; 'с' = 's'; 'т' = 't';
        'у' = 'u'; 'ф' = 'f'; 'х' = 'kh'; 'ц' = 'ts'; 'ч' = 'ch'; 'ш' = 'sh'; 'щ' = 'shch'; 'ы' = 'y';
        'э' = 'e'; 'ю' = 'yu'; 'я' = 'ya';

        # Grieks (transliteratie naar Latijns alfabet)
        'α' = 'a'; 'β' = 'b'; 'γ' = 'g'; 'δ' = 'd'; 'ε' = 'e'; 'ζ' = 'z'; 'η' = 'i'; 'θ' = 'th'; 'ι' = 'i'; 'κ' = 'k';
        'λ' = 'l'; 'μ' = 'm'; 'ν' = 'n'; 'ξ' = 'ks'; 'ο' = 'o'; 'π' = 'p'; 'ρ' = 'r'; 'σ' = 's'; 'τ' = 't'; 'υ' = 'y';
        'φ' = 'f'; 'χ' = 'ch'; 'ψ' = 'ps'; 'ω' = 'o';
    }

    # Zet de tekst om naar kleine letters en vervang vreemde tekens
    $resultaat = $tekst.ToLower() -replace '[^a-z]', {
        param($teken)
        if ($vertalingTabel.ContainsKey($teken)) {
            return $vertalingTabel[$teken]
        }
        return ''
    }
    return $resultaat
}

# Functie om namen correct te hoofdletteren (behalve tussenvoegsels)
function Formatteer-Naam([string]$naam) {
    $delen = $naam.Split(' ')
    for ($i = 0; $i -lt $delen.Count; $i++) {
        # Controleer of het deel een tussenvoegsel is
        $isTussenvoegsel = $false
        foreach ($tussenvoegsel in $tussenvoegsels) {
            if ($delen[$i] -eq $tussenvoegsel) {
                $isTussenvoegsel = $true
                break
            }
        }
        if (-not $isTussenvoegsel -and $delen[$i].Length -gt 0) {
            $delen[$i] = $delen[$i].Substring(0,1).ToUpper() + $delen[$i].Substring(1)
        }
    }
    return ($delen -join ' ')
}

# Lees het invoerbestand
$gegevens = Import-Csv -Path $invoerBestand

# Maak een nieuw object voor de uitvoer
$uitvoerGegevens = @()

# Verwerk elke regel
foreach ($rij in $gegevens) {
    $nieuweRij = @{
        DisplayName = (Formatteer-Naam (Schoon-Tekst $rij.DisplayName))
        GivenName = (Formatteer-Naam (Schoon-Tekst $rij.GivenName))
        SurName = (Formatteer-Naam (Schoon-Tekst $rij.SurName))
    }
    $uitvoerGegevens += [PSCustomObject]$nieuweRij
}

# Sla de uitvoer op naar een nieuw CSV-bestand
$uitvoerGegevens | Export-Csv -Path $uitvoerBestand -NoTypeInformation -Encoding UTF8

Write-Output "Het schoongemaakte bestand is opgeslagen als $uitvoerBestand."