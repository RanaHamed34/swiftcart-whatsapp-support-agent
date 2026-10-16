param([string]$Phone, [string]$Text, [string]$Name = "Demo Customer")
$url = "http://localhost:5678/webhook/support-agent-p8"
$payload = @{
  object = "whatsapp_business_account"
  entry = @(@{
    id = "TEST_WABA_ID"
    changes = @(@{
      field = "messages"
      value = @{
        messaging_product = "whatsapp"
        metadata = @{ display_phone_number = "15550000000"; phone_number_id = "TEST_PHONE_ID" }
        contacts = @(@{ profile = @{ name = $Name }; wa_id = $Phone })
        messages = @(@{ from = $Phone; id = ("wamid.D" + (Get-Date -Format "HHmmssfff")); timestamp = "1759431000"; type = "text"; text = @{ body = $Text } })
      }
    })
  })
} | ConvertTo-Json -Depth 10
Invoke-RestMethod -Method Post -Uri $url -ContentType "application/json" -Body $payload | Out-Null
Write-Host "sent"