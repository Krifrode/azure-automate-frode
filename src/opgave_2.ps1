param (
    [Parameter()]
    [string]
    $navn = "Frode",
    [Parameter(Mandatory = $true)]
    [string]
    $lokasjon    
)

Write-Host "Hei $navn, som kommer fra $lokasjon"
