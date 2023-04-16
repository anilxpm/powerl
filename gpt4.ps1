function GPT4
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True, Position=1)]
        [string]$IPAddress,

        [Parameter(Mandatory=$True, Position=2)]
        [int]$Port
    )

    # Listener'ı başlatıyoruz.
    $listener = New-Object System.Net.Sockets.TcpListener([IPAddress]::Any, $Port)
    $listener.Start()

    # Sinyal gönderme işlemi
    while ($true)
    {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)

        # Sinyal gönderme işlemi
        $writer.Write("Sinyal Gonderildi")
        $writer.Flush()

        # Dosya transferi
        $data = New-Object byte[] 4096
        $fileName = "file.txt"
        $filePath = Join-Path $env:TEMP $fileName
        $fileStream = [System.IO.File]::OpenWrite($filePath)
        $bytesRead = $stream.Read($data, 0, $data.Length)
        while ($bytesRead -gt 0)
        {
            $fileStream.Write($data, 0, $bytesRead)
            $bytesRead = $stream.Read($data, 0, $data.Length)
        }

        # Dosya transferi tamamlandı.
        $fileStream.Close()
        $client.Close()

        # 10 saniye bekleyip tekrar sinyal gönderiyoruz
        Start-Sleep -Seconds 10
    }
}

# Ana işlem başlangıcı
if ($PSBoundParameters.Count -eq 0)
{
    Write-Host "Kullanım: GPT4 -IPAddress <IP Adresi> -Port <Port Numarası>"
    exit
}

# Listener'a bağlanıyoruz.
GPT4 -IPAddress $IPAddress -Port $Port

# Program otomatik olarak kapanmaz, CTRL + C ile kapatılabilir.
