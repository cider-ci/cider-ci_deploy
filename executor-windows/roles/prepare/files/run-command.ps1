Function RunCommand($file, $arguments, $ignore =$false, $workingdir, $username, $password )
{
  Try {
    $psi = New-object System.Diagnostics.ProcessStartInfo
    $psi.CreateNoWindow = $true
    $psi.UseShellExecute = $false
    $psi.LoadUserProfile = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.FileName= "$file"
    $psi.Arguments= "$arguments"
    if($workingdir){
      $psi.WorkingDirectory = "$workingdir"
    }
    if($username){
      $psi.UserName = "$username"
    }
    if($password){
      $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
      $psi.Password = $securePassword
    }
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    $process.Start() | Out-Null
    $process.WaitForExit()
    Write-Host $process.StandardOutput.ReadToEnd()
    Write-Host $process.StandardError.ReadToEnd()
    # Write-Host $process.ExitCode
    # Write-Host "######################################"
    if ($process.ExitCode -ne 0) {
      Write-Host "RunCommand '$file', '$arguments', '$workingdir' failed"
      if(! $ignore){
        throw "RunCommand '$file', '$arguments', '$workingdir' failed"
      }
    }
  } Catch {
    Write-Host $Error
    if(! $ignore){
      throw $Error
    }
  }
}
