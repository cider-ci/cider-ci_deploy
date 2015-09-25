param([string]$script, `
      [string]$workdingdir = "C:\cider-ci\setup\tmp")

. "C:\cider-ci\setup\tmp\run-command.ps1"

RunCommand  -file "C:\Program Files (x86)\Microsoft SDKs\F#\4.0\Framework\v4.0\Fsi.exe" `
            -arguments "$script" `
            -workingdir "$workingdir"

Exit 0
