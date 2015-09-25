param([string]$url= "$url", [string]$dest= "$dest")
Write-Host "$url"
Write-Host "$dest"

Try {
  $client = New-Object System.Net.WebClient
  $client.Headers.Add("Cookie", "oraclelicense=accept-securebackup-cookie")
  $client.DownloadFile("$url", "$dest")
} Catch {
  Exit -1
}


