$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupFile = "$scriptPath\original_wallpaper.txt"
if (Test-Path $backupFile) {
    $originalWallpaper = Get-Content $backupFile
    if ($originalWallpaper -and (Test-Path $originalWallpaper)) {
        Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
        [Wallpaper]::SystemParametersInfo(20, 0, $originalWallpaper, 3)
    }
    Remove-Item $backupFile -Force
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
[TaskbarHelper]::ShowWindow($hwndTaskbar, [TaskbarHelper]::SW_SHOW)