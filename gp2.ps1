$ip = "192.168.1.40"
$port = 4444
$socket = New-Object System.Net.Sockets.TcpClient($ip, $port)
$stream = $socket.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$reader = New-Object System.IO.StreamReader($stream)

while ($socket.Connected) {
    $command = Read-Host "PS >"
    $writer.WriteLine($command)
    $writer.Flush()
    $response = $reader.ReadLine()
    Write-Host $response
}
$socket.Close()
