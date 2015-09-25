. "C:\cider-ci\setup\tmp\run-command.ps1"


Function SetService($parameter)
{
  RunCommand  -file 'C:\cider-ci\bin\nssm.exe' `
    -arguments "set cider-ci_executor $parameter"
}

RunCommand -file "icacls" `
           -arguments 'c:\cider-ci\executor\tmp /grant "cider-ci_executor:(OI)(CI)F"'

RunCommand -file "icacls" `
           -arguments 'c:\cider-ci\executor\log /grant "cider-ci_executor:(OI)(CI)F"'

RunCommand -file "icacls" `
           -arguments 'c:\cider-ci\executor /grant "cider-ci_executor:(OI)(CI)R"'

RunCommand  -file 'C:\cider-ci\bin\nssm.exe' `
  -arguments 'stop cider-ci_executor' `
  -ignore $true

RunCommand  -file 'C:\cider-ci\bin\nssm.exe' `
  -arguments 'remove cider-ci_executor confirm' `
  -ignore $true

RunCommand  -file 'C:\cider-ci\bin\nssm.exe' `
  -arguments 'install cider-ci_executor java'

SetService 'AppParameters "-jar C:\cider-ci\executor\target\cider-ci_executor-3.0.0-standalone.jar -classpath config;resources run"'
SetService 'AppDirectory C:\cider-ci\executor'
SetService 'ObjectName ".\cider-ci_executor" "{{win_executor_user_password}}"'
SetService 'AppThrottle 1500'
SetService 'AppExit Default Restart'
SetService 'AppRestartDelay 100000'
SetService 'AppStdout C:\cider-ci\executor\log\console.log'
SetService 'AppStderr C:\cider-ci\executor\log\console.log'

RunCommand  -file 'C:\cider-ci\bin\nssm.exe' `
  -arguments 'start cider-ci_executor'

