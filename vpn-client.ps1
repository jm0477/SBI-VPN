$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
 
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    write-host "please re-run the script with administrative priviliege!!!" -ForegroundColor Red -BackgroundColor Yellow
    #return
}
else
{
    Set-ExecutionPolicy unrestricted
}


#set location to the netshare
$path_source= "\\localhost\Temp\SBI_VPN"

$path_destination = "$env:HOMEPATH" + "\" + "desktop"
#copy latest cow online to local machine's desktop
Copy-Item -Path $path_source -Destination $path_destination -Recurse -Force

#creating shortcut of GoAgent on the desktop
$shell= New-Object -ComObject WScript.Shell
$desktop= [System.Environment]::GetFolderPath('Desktop')
$shortcut = $shell.CreateShortcut("$desktop\Start_VPN.lnk")
$shortcut.TargetPath = "$path_destination\SBI_VPN\proxy.exe"
$shortcut.WorkingDirectory = "$path_destination\SBI_VPN"
$shortcut.WindowStyle = 5
$shortcut.IconLocation = "shell32.dll,41"
$shortcut.save()

#creating  Stop_VPN.cmd to desktop

Write-Output 'echo off' | out-file $home\desktop\Stop_VPN.cmd -Append ascii
Write-Output 'echo stopping IE settings...' | out-file $home\desktop\Stop_VPN.cmd -Append utf8
Write-Output 'reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f' | out-file $home\desktop\Stop_VPN.cmd -Append utf8
Write-Output 'reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "" /f' | out-file $home\desktop\Stop_VPN.cmd -Append utf8
Write-Output 'reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "<local>" /f  ' | out-file $home\desktop\Stop_VPN.cmd -Append utf8
Write-Output 'echo cleaning up...' | out-file $home\desktop\Stop_VPN.cmd -Append utf8
Write-Output 'echo VPN is stopped now' | out-file $home\desktop\Stop_VPN.cmd -Append utf8
Write-Output 'pause' | out-file $home\desktop\Stop_VPN.cmd -Append utf8



#setting IE proxy settings

#Set-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "AutoConfigURL" -value "http://127.0.0.1:8086/proxy.pac" 
#Remove-ItemProperty -Path 'HKCU:\software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name "AutoConfigURL"

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "127.0.0.1:7777" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "<local>" /f  

