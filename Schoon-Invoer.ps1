# PowerShell-script om vreemde tekens te vervangen, onbekende tekens worden underscores

# Invoer- en uitvoerbestandspaden
$inputCsvPath = "input.csv"
$outputCsvPath = "output_with_underscore.csv"

# Lees het CSV-bestand
$data = Import-Csv -Path $inputCsvPath

# Functie om vreemde tekens te vervangen
function Replace-SpecialChars {
    param([string]$text)

    $charMap = @{
        'ı' = 'i'; 'ğ' = 'g'; 'ö' = 'o'; 'ü' = 'u'; 'ç' = 'c'; 'ş' = 's';
        'ë' = 'e'; 'ä' = 'a'; 'å' = 'a'; 'é' = 'e'; 'è' = 'e'; 'ê' = 'e';
        'à' = 'a'; 'â' = 'a'; 'î' = 'i'; 'ï' = 'i'; 'ô' = 'o'; 'û' = 'u';
        'ù' = 'u'; 'û' = 'u'; 'ÿ' = 'y'; 'ñ' = 'n'; 'ß' = 'ss'; 'æ' = 'ae';
        'œ' = 'oe'; 'ø' = 'o'; 'ĳ' = 'ij'; 'İ' = 'I'; 'Ğ' = 'G'; 'Ö' = 'O';
        'Ü' = 'U'; 'Ç' = 'C'; 'Ş' = 'S'; 'Ë' = 'E'; 'Ä' = 'A'; 'Å' = 'A';
        'É' = 'E'; 'È' = 'E'; 'Ê' = 'E'; 'À' = 'A'; 'Â' = 'A'; 'Î' = 'I';
        'Ï' = 'I'; 'Ô' = 'O'; 'Û' = 'U'; 'Ù' = 'U'; 'ÿ' = 'Y'; 'Ñ' = 'N';
        'Æ' = 'AE'; 'Œ' = 'OE'; 'Ø' = 'O'; 'Ĳ' = 'IJ'
    }

    foreach ($char in $charMap.Keys) {
        $text = $text -replace [$char], $charMap[$char]
    }

    # Vervang alle overige tekens die niet in a-z of A-Z vallen door een underscore
    $text = $text -replace '[^a-zA-Z]', '_'

    return $text
}

# Pas de functie toe op elke kolom
foreach ($row in $data) {
    $row.DisplayName = Replace-SpecialChars -text $row.DisplayName
    $row.GivenName = Replace-SpecialChars -text $row.GivenName
    $row.SurName = Replace-SpecialChars -text $row.SurName
}

# Sla het resultaat op in een nieuw CSV-bestand
$data | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Output "Het script is voltooid. Het resultaat is opgeslagen in $outputCsvPath"