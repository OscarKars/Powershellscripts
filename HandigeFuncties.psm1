<#
.SYNOPSIS
    Een PowerShell-module met handige functies.
#>

function Verwijder-VreemdeTekens {
    <#
    .SYNOPSIS
        Verwijdert vreemde tekens uit een woord en vervangt ze door de meest waarschijnlijke overeenkomstige letter.
    
    .PARAMETER Woord
        Het woord dat schoongemaakt moet worden.
    
    .EXAMPLE
        Verwijder-VreemdeTekens -woord "Argındoğan"
        # Output: Argindogan
    #>
    param(
        [string]$woord
    )

    $VertalingTabel = @{
        # Turkse tekens
        "ı" = "i"; "ğ" = "g"; "ü" = "u"; "ş" = "s"; "ö" = "o"; "ç" = "c";

        # Spaanse, Franse, Duitse, en andere Europese tekens
        "á" = "a"; "à" = "a"; "â" = "a"; "ä" = "a"; "ã" = "a"; "å" = "a";
        "é" = "e"; "è" = "e"; "ê" = "e"; "ë" = "e";
        "í" = "i"; "ì" = "i"; "î" = "i"; "ï" = "i";
        "ó" = "o"; "ò" = "o"; "ô" = "o"; "õ" = "o"; "ø" = "o";
        "ú" = "u"; "ù" = "u"; "û" = "u";
        "ñ" = "n"; "ý" = "y"; "ÿ" = "y";

        # Oost-Europese tekens
        "ć" = "c"; "č" = "c"; "ď" = "d"; "ě" = "e"; "ľ" = "l"; "ň" = "n";
        "ř" = "r"; "š" = "s"; "ť" = "t"; "ů" = "u"; "ž" = "z";

        # Poolse tekens
        "ą" = "a"; "ę" = "e"; "ł" = "l"; "ń" = "n"; "ś" = "s"; "ź" = "z"; "ż" = "z";

        # Russisch (transliteratie naar Latijns alfabet)
        "а" = "a"; "б" = "b"; "в" = "v"; "г" = "g"; "д" = "d"; "е" = "e"; "ё" = "yo"; "ж" = "zh"; "з" = "z"; "и" = "i";
        "й" = "y"; "к" = "k"; "л" = "l"; "м" = "m"; "н" = "n"; "о" = "o"; "п" = "p"; "р" = "r"; "с" = "s"; "т" = "t";
        "у" = "u"; "ф" = "f"; "х" = "kh"; "ц" = "ts"; "ч" = "ch"; "ш" = "sh"; "щ" = "shch"; "ы" = "y";
        "э" = "e"; "ю" = "yu"; "я" = "ya";

        # Grieks (transliteratie naar Latijns alfabet)
        "α" = "a"; "β" = "b"; "γ" = "g"; "δ" = "d"; "ε" = "e"; "ζ" = "z"; "η" = "i"; "θ" = "th"; "ι" = "i"; "κ" = "k";
        "λ" = "l"; "μ" = "m"; "ν" = "n"; "ξ" = "ks"; "ο" = "o"; "π" = "p"; "ρ" = "r"; "σ" = "s"; "τ" = "t"; "υ" = "y";
        "φ" = "f"; "χ" = "ch"; "ψ" = "ps"; "ω" = "o";
    }

    $resultaat = $woord.ToLower()
    foreach ($entry in $VertalingTabel.GetEnumerator()) {
        $resultaat = $resultaat -replace [regex]::Escape($entry.Key), $entry.Value
    }
    
    return $resultaat
}

function Formatteer-Naam {
    <#
    .SYNOPSIS
        Formatteert een naam zodat elk woord met een hoofdletter begint.
    
    .PARAMETER Naam
        De naam die geformatteerd moet worden.
    
    .EXAMPLE
        Formatteer-Naam -naam "oscar van den berg"
        # Output: Oscar van den Berg
    #>
    param(
        [string]$naam
    )

    $delen = $naam.Split(" ")
    for ($i = 0; $i -lt $delen.Count; $i++) {
        if ($delen[$i] -ne "") {
            $delen[$i] = $delen[$i].Substring(0,1).ToUpper() + $delen[$i].Substring(1)
        }
    }
    return ($delen -join " ")
}

# Exporteer de functies zodat deze beschikbaar zijn wanneer de module wordt geïmporteerd
Export-ModuleMember -Function Verwijder-VreemdeTekens, Formatteer-Naam