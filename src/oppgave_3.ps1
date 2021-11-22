#Oppdatert221121 med komentarer
$Url = "http://nav-deckofcards.herokuapp.com/shuffle"
#lese inn i pwsh - invoke web req
$response = Invoke-WebRequest -Uri $Url
#kjør script og se hvilke parameter, content er en parameter
#Leser inn fra url og koverterer kort (content) til Json og lagrer i variabel cards
$cards = $response.Content | ConvertFrom-Json
#lage ny liste og legge til hver av disse i listen 
$kortstokk = @()
#Hente ut første bokstav i suit: Write-Output ($cards [0].suit)[0]
#Skrive ut alle kort med for-løkke, for-each, $card interasjon
#legge til kort i liste/kortstokke +, ellers slette det for hver gang. + legger til element i listen
foreach ($card in $cards) {
   $kortstokk = $kortstokk + ($card.suit[0] + $card.value)
}

Write-Host "kortstokk: $kortstokk"