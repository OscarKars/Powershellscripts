<#
.SYNOPSIS
    Een PowerShell-module met handige functies.
#>

function Verwijder-VreemdeTekens {
    <#
    .SYNOPSIS
        Verwijdert vreemde tekens uit een woord en vervangt ze door de meest waarschijnlijke overeenkomstige letter of een underscore.
    
    .PARAMETER Woord
        Het woord dat schoongemaakt moet worden.
    
    .EXAMPLE
        Verwijder-VreemdeTekens -woord "Argındoğan"
        # Output: Argindogan
    #>
    param(
        [string]$woord
    )

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
        $woord = $woord -replace [regex]::Escape($char), $charMap[$char]
    }

    # Vervang alle overige tekens die niet in a-z of A-Z vallen door een underscore
    $woord = $woord -replace '[^a-zA-Z]', '_'

    return $woord
}

# Exporteer de functie zodat deze beschikbaar is wanneer de module wordt geïmporteerd
Export-ModuleMember -Function Verwijder-VreemdeTekens