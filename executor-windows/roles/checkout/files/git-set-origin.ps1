param([string]$repo = "repo")

. "C:\cider-ci\setup\tmp\run-command.ps1"

RunCommand  -file "C:\Program Files\Git\bin\git.exe" `
            -arguments "remote set-url origin $repo" `
            -workingdir "C:\cider-ci\executor"

Exit 0
