param([string]$id= "id")

. "C:\cider-ci\setup\tmp\run-command.ps1"

RunCommand  -file "C:\Program Files\Git\bin\git.exe" `
            -arguments "reset --hard $id" `
            -workingdir "C:\cider-ci\executor"

RunCommand  -file "C:\Program Files\Git\bin\git.exe" `
            -arguments "clean -f -d" `
            -workingdir "C:\cider-ci\executor"

Exit 0
