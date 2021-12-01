[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $UrlKortstokk = "http://nav-deckofcards.herokuapp.com/shuffle"
)

$ErrorActionPreference = 'Stop'

$webRequest = Invoke-WebRequest -Uri $UrlKortstokk


$kortstokkJson = $webRequest.Content | ConvertFrom-Json

#Sum up the value of the cards
#J, Q and K are 10 and Ace is 11
$sum = 0
foreach ($kort in $kortstokkJson)
{
    $sum +=  switch ($kort.value) {
        "J" { 10 }
        "Q" { 10 }
        "K" { 10 }
        "A" { 11 }
        Default {$kort.value}
    }
    
}


# Print short format of a card and its value
# input is Json formatted data
# Output is array of short formatted key-value pair 
function KortstokkPrint {
    param (
        [Parameter()]
        [Object[]]
        $kortstokkJs
    )
    $kortstokk = @()
    foreach ($kort in $kortstokkJs)
    {
        $kortstokk +=  ($kort.suit[0] + $kort.value + ",")
    }

    return $kortstokk
}



Write-Host "Kortstokk:  $(kortstokkPrint($kortstokkJson))"
Write-Host "Poengsum:   $sum"


# 2 players and each take first cards on the deck/kortstokkJson
# Print players hand and the rest of deck
$Frode = $kortstokkJson[0..1]
$Magnus = $kortstokkJson[2..3]
$kortstokkJson = $kortstokkJson[4..$kortstokkJson.Length]


function kortVerdi {
    param (
        [Parameter()]
        [Object[]]
        $kort
    )
    $value = 0
    $value = switch ($kort.value) {
                    "J" { 10  }
                    "Q" { 10  }
                    "K" { 10  }
                    "A" { 11  }
                    Default {$kort.value}
    }
    return $value
}
#sum the cards value and announce the winner
function sumPoengKortstokk{
    param (
        [Parameter()]
        [Object[]]
        $kortstokkJs
    )

    $sum = 0
    foreach ($kort in $kortstokkJs)
    {
         $sum +=  kortVerdi($kort)
    }

    return [int]$sum
}

function resultsPrint {
    param (
        [string]
        $vinner,        
        [object[]]
        $kortStokkMagnus,
        [object[]]
        $kortStokkFrode        
        )
        Write-Output "Vinner: $vinner"
        Write-Output "magnus | $(sumPoengKortstokk -kortstokk $Magnus) | $(KortstokkPrint -kortstokkJs $Magnus)"    
        Write-Output "Frode    | $(sumPoengKortstokk -kortstokk $Frode) | $(KortstokkPrint -kortstokkJs $Frode)"
}

$blackjack = 21



# Draw a card if sum of existing cards are less than 17
while ((sumPoengKortstokk -kortstokk $Frode) -lt 17) {
    
    $Frode += $kortstokkJson[0]
    $kortstokkJson = $kortstokkJson[1..$kortstokkJson.length]
    #Write-Host "My hand is $(KortstokkPrint($Frode))"
    #Write-Host "kortstokkJs is $(KortstokkPrint($kortstokkJson))"
}




#Write-Host "Kortstokk:  $(kortstokkPrint($Frode)) $(KortstokkPrint($Magnus))"
#$kortihands = $Frode + $Magnus
#Write-Host "Poengsum:   $(sumPoengKortstokk $kortihands)"

#Write-Host "Frode:  $(KortstokkPrint($Frode))"
#Write-Host "Magnus:  $(KortstokkPrint($Magnus))"

if ((sumPoengKortstokk -kortstokk $Frode) -gt $blackjack) {
    resultsPrint -vinner "Magnus" -kortStokkMagnus $Magnus -kortStokkMeg $Frode
    Write-Host "Kortstokk:  $(kortstokkPrint($kortstokkJson))"
    exit
}

while ((sumPoengKortstokk -kortstokk $Magnus) -le (sumPoengKortstokk -kortstokk $Frode)) {
    $Magnus += $kortstokkJson[0]
    $kortstokkJson = $kortstokkJson[1..$kortstokkJson.length]
}

### Magnus taper spillet dersom poengsummen er høyere enn 21
if ((sumPoengKortstokk -kortstokk $Magnus) -gt 21) {
    resultsPrint -vinner "Frode" -kortStokkMagnus $magnus -kortStokkMeg $Frode
    Write-Host "Kortstokk:  $(kortstokkPrint($kortstokkJson))"
    exit
}

if ((sumPoengKortstokk -kortstokk $Magnus) -eq $blackjack) {
    resultsPrint -vinner "Magnus" -kortStokkMagnus $Magnus -kortStokkMeg $Frode
    Write-Host "Kortstokk:  $(kortstokkPrint($kortstokkJson))"
    exit
}
elseif ((sumPoengKortstokk -kortstokk $Frode) -eq $blackjack) {
    resultsPrint -vinner "Frode" -kortStokkMagnus $Magnus -kortStokkMeg $Frode
    Write-Host "Kortstokk:  $(kortstokkPrint($kortstokkJson))"
    exit
}
elseif (((sumPoengKortstokk -kortstokk $Magnus) -eq $blackjack) -and
        ((sumPoengKortstokk -kortstokk $Frode) -eq $blackjack)) {
    resultsPrint -vinner "Draw" -kortStokkMagnus $Magnus -kortStokkMeg $Frode
    Write-Host "Kortstokk:  $(kortstokkPrint($kortstokkJson))"
    exit
}elseif (((sumPoengKortstokk -kortstokk $Magnus) -lt $blackjack) -and
         ((sumPoengKortstokk -kortstokk $Frode) -lt $blackjack)) {
    resultsPrint -vinner "undecided" -kortStokkMagnus $Magnus -kortStokkMeg $Frode
    Write-Host "Kortstokk:  $(kortstokkPrint($kortstokkJson))"
     exit
}
