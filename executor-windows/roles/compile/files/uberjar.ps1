. "C:\cider-ci\setup\tmp\run-command.ps1"

RunCommand -file "C:\cider-ci\bin\lein.bat" `
           -arguments "uberjar" `
           -workingdir "C:\cider-ci\executor"
