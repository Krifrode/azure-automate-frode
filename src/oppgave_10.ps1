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


#Returnerer kortstokk på formen CA H6 D9
function kortstokkprint {
    param (
    [Parameter()]
    [Objekt[]]
    $cards
    )
    $Kortstokk = @()
    foreach ($card in $Cards) {
        $Kortstokk += ($card.suit)[0] + $card.value 
    }
    $Kortstokk
}
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


function skrivUtResultat {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkMeg        
    )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumPoengKortstokk -kortstokk $kortStokkMagnus) | $(kortstokkTilStreng -kortstokk $kortStokkMagnus)"   
    Write-Output "meg    | $(sumPoengKortstokk -kortstokk $kortStokkMeg) | $(KortstokkTilStreng -kortstokk $kortStokkMeg)"
}

# bruker 'blackjack' som et begrep - er 21
$blackjack = 21
if(((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) -and ((somPoengKortstokk -korstokk $magnus) -eq $blackjack)){
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}


elseif ((sumPoengKortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
elseif ((sumPoengKortstokk -kortstokk $magnus) -eq $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}


# ...

while ((sumPoengKortstokk -kortstokk $meg) -lt 17) {
    $meg += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Count]
}

if ((sumPoengKortstokk -kortstokk $meg) -gt $blackjack) {
    skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}


# ...

while ((sumPoengKortstokk -kortstokk $magnus) -le (sumPoengKortstokk -kortstokk $meg)) {
    $magnus += $kortstokk[0]
    $kortstokk = $kortstokk[1.. $kortstokk.Count]
}

### Magnus taper spillet dersom poengsummen er høyere enn 21
if ((sumPoengKortstokk -kortstokk $magnus) -gt $blackjack) {
    skrivUtResultat -vinner $meg -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}

# ...

skrivUtResultat -vinner "magnus" -kortStokkMagnus $magnus - $kortStokkMeg $meg