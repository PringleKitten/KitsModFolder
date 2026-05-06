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