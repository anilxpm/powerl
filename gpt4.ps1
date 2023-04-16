[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Mode,
    [Parameter(Mandatory=$false)]
    [string]$IP,
    [Parameter(Mandatory=$false)]
    [int]$Port
)

function GPT4-Listener {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [int]$Port
    )
    
    # Listener'ı başlatıyoruz.
    $listener = New-Object System.Net.Sockets.TcpListener([IPAddress]::Any, $Port)
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

function GPT4-Sender {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$IPAddress,

        [Parameter(Mandatory=$True)]
        [int]$Port,

        [Parameter(Mandatory=$True)]
        [string]$Command
    )

    # Bağlantıyı açıyoruz.
    $client = New-Object System.Net.Sockets.TcpClient($IPAddress, $Port)
    $stream = $client.GetStream()

    # Komut gönderiyoruz.
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.Write($Command)
    $writer.Flush()

    # Cevabı okuyoruz.
    $reader = New-Object System.IO.StreamReader($stream)
    $response = $reader.ReadToEnd()

    # Bağlantıyı kapatıyoruz.
    $client.Close()

    # Cevabı yazdırıyoruz.
    Write-Host $response
}

if ($Mode -eq "listener") {
    GPT4-Listener -Port $Port
}
elseif ($Mode -eq "sender") {
    GPT4-Sender -IPAddress $IP -Port $Port -Command $Command
}
else {
    Write-Host "Kullanım: GPT4 -Mode <listener|sender> [-IP <IP Adresi>] [-Port <Port Numarası>] [-Command <Komut>]"
}
