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



function kortstokkprint {
    param (
    [Parameter()]
    [Objekt[]]
    $cards
    )
    #Skriver ut kortstokk
$kortstokk = @()
foreach ($card in $cards) {
   $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
}

#Skriver ut kortstokk
$kortstokk = @()
foreach ($card in $cards) {
   $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
}

Write-Host "kortstokk: $kortstokkprint(cards))"
Write-Host "Poengsum: $sum"

$meg = $cards[0..1]
$cards = $cards[2..$cards.Length]
$magnus = $cards[0..1]
$cards = $cards[2..$cards.Length]

Write-host "meg: $kortstokkprint($meg))"
Write-Host "magnus: $kortstokkprint($magnus))"
Write-Host "kortstokk: $kortstokkprint($cards))"