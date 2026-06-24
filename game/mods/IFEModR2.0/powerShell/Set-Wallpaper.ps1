$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupFile = "$scriptPath\original_wallpaper.txt"
$originalWallpaper = (Get-ItemProperty 'HKCU:\Control Panel\Desktop' -Name WallPaper).WallPaper
Set-Content -Path $backupFile -Value $originalWallpaper
$candylandImage = Get-ChildItem "$scriptPath\candyland.*" -Include *.jpg, *.png, *.bmp | Select-Object -First 1
if ($originalWallpaper -ne $candylandImage.FullName) {
    Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
    [Wallpaper]::SystemParametersInfo(20, 0, $candylandImage.FullName, 3)
}
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class TaskbarHelper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    public const int SW_HIDE = 0;
    public const int SW_SHOW = 5;
}
"@
$hwndTaskbar = [TaskbarHelper]::FindWindow("Shell_TrayWnd", $null)
[TaskbarHelper]::ShowWindow($hwndTaskbar, [TaskbarHelper]::SW_HIDE)