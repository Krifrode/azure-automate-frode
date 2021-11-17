param (
    [Parameter()]
    [string]
    $navn = "Frode",
    [Parameter()]
    [string]
    $lokasjon ="Stange" 
)

Write-Host "Hei $navn, som kommer fra $lokasjon"
