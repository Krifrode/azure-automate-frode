param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = "stop"

$response = Invoke-WebRequest -Uri $Url

$cards = $response.Content | ConvertFrom-Json

$Sum = 0
foreach ($card in $cards) {
  $Sum += switch ($card.value){
      'J' { 10 }
      'Q' { 10 }
      'K' { 10 }
      'A' { 11 }
      Default {$card.value}
  }
 }

#Skriver ut kortstokk
$kortstokk = @()
foreach ($card in $cards) {
   $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
}

Write-Host "kortstokk: $kortstokk"
Write-Host "Poengsum: $sum"