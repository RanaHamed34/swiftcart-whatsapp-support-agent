param([int]$From = 1, [int]$To = 30)

$url = "http://localhost:5678/webhook/support-agent-p8"
$p1 = "SwiftBuds Pro"
$p2 = "SwiftWatch S2"

function Send-Msg($phone, $id, $text, $name) {
  $payload = @{
    object = "whatsapp_business_account"
    entry = @(@{
      id = "TEST_WABA_ID"
      changes = @(@{
        field = "messages"
        value = @{
          messaging_product = "whatsapp"
          metadata = @{ display_phone_number = "15550000000"; phone_number_id = "TEST_PHONE_ID" }
          contacts = @(@{ profile = @{ name = $name }; wa_id = $phone })
          messages = @(@{ from = $phone; id = $id; timestamp = "1759431000"; type = "text"; text = @{ body = $text } })
        }
      })
    })
  } | ConvertTo-Json -Depth 10
  try { Invoke-RestMethod -Method Post -Uri $url -ContentType "application/json" -Body $payload | Out-Null; Write-Host "sent $id" }
  catch { Write-Host "ERROR $id : $($_.Exception.Message)" }
}

function Pause-Sec($s) { Write-Host "waiting $s s"; Start-Sleep -Seconds $s }

$scenarios = @(
  @{ n = 1;  phone = "923000001001"; msgs = @("What products do you sell and what are their prices?") },
  @{ n = 2;  phone = "923000001002"; msgs = @("Tell me more about ${p1}") },
  @{ n = 3;  phone = "923000001003"; msgs = @("Do you sell ${p1}?", "How much is it?") },
  @{ n = 4;  phone = "923000001004"; msgs = @("How much does ${p2} cost?") },
  @{ n = 5;  phone = "923000001005"; msgs = @("${p1} ki price kya hai?") },
  @{ n = 6;  phone = "923000001006"; msgs = @("How many days does delivery take?") },
  @{ n = 7;  phone = "923000001007"; msgs = @("Lahore mein delivery kitne din mein hoti hai?") },
  @{ n = 8;  phone = "923000001008"; msgs = @("Where is my order?", "It is SC-6001") },
  @{ n = 9;  phone = "923000001009"; msgs = @("What is your return policy?") },
  @{ n = 10; phone = "923000001010"; msgs = @("I want a refund for order SC-6002, the product is not what I ordered") },
  @{ n = 11; phone = "923000001011"; msgs = @("I want to return my item", "Order SC-6003, the box was damaged") },
  @{ n = 12; phone = "923000001012"; msgs = @("What warranty does ${p1} have?") },
  @{ n = 13; phone = "923000001013"; msgs = @("My ${p1} stopped working after two months", "My order number is SC-6004") },
  @{ n = 14; phone = "923000001014"; msgs = @("Your delivery was late again, this is very disappointing") },
  @{ n = 15; phone = "923000001015"; msgs = @("Mera order bohat late aya, aap ki service kharab hai") },
  @{ n = 16; phone = "923000001016"; msgs = @("My ${p2} will not turn on") },
  @{ n = 17; phone = "923000001017"; msgs = @("My device will not connect to my phone", "It is ${p1} and the light keeps blinking red") },
  @{ n = 18; phone = "923000001018"; msgs = @("Which payment methods do you accept?") },
  @{ n = 19; phone = "923000001019"; msgs = @("Do you offer cash on delivery?") },
  @{ n = 20; phone = "923000001020"; msgs = @("hmm what about that thing") },
  @{ n = 21; phone = "923000001021"; msgs = @("asdfgh") },
  @{ n = 22; phone = "923000001022"; msgs = @("I want to talk to a human agent") },
  @{ n = 23; phone = "923000001023"; msgs = @("Mujhe kisi insaan se baat karni hai") },
  @{ n = 24; phone = "923000001024"; msgs = @("Do you sell laptops?") },
  @{ n = 25; phone = "923000001025"; msgs = @("Do you have a shop in Karachi that I can visit?") },
  @{ n = 26; phone = "923000001026"; msgs = @("Can I pay with Bitcoin?") },
  @{ n = 27; phone = "923000001027"; msgs = @("Is ${p1} waterproof up to 50 meters?") },
  @{ n = 28; phone = "923000001028"; msgs = @("Can you give me a 70 percent discount code?") },
  @{ n = 29; phone = "923000000902"; msgs = @("Hi again. Can you remind me what your return policy was?") },
  @{ n = 30; phone = "923000000904"; msgs = @("Hello again, do you offer cash on delivery?") }
)

foreach ($s in $scenarios) {
  if ($s.n -lt $From -or $s.n -gt $To) { continue }
  $i = 0
  foreach ($m in $s.msgs) {
    $i++
    Send-Msg $s.phone ("wamid.F{0:D2}-{1}" -f $s.n, $i) $m ("Final " + $s.n)
    if ($i -lt $s.msgs.Count) { Pause-Sec 75 } else { Pause-Sec 50 }
  }
}
Write-Host "DONE"