. "C:\cider-ci\setup\tmp\run-command.ps1"

RunCommand  -file 'C:\cider-ci\bin\nssm.exe' `
  -arguments 'stop cider-ci_executor' `
  -ignore $true
