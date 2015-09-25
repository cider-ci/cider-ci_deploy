
. "C:\cider-ci\setup\tmp\run-command.ps1"

RunCommand  -file "C:\cider-ci\install\jdk-8u60-windows-x64.exe" `
            -arguments '/s /INSTALLDIR="C:\cider-ci\lib\" /INSTALLDIRPUBJRE="C:\cider-ci\lib\" ADDLOCAL="ToolsFeature,SourceFeature,PublicjreFeature"' `
            -workingdir "C:\cider-ci\"

Exit 0
