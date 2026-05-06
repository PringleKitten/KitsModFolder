Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
}
"@
$SWP_NOMOVE = 0x2
$SWP_NOSIZE = 0x1
$HWND_TOPMOST = [intptr]::MinusOne
$window = Get-Process | Where-Object { $_.MainWindowTitle -like "*Friday Night Funkin': Internet Favorites Engine*" }
if ($window) {
    $hwnd = $window.MainWindowHandle
    [Win]::SetWindowPos($hwnd, $HWND_TOPMOST, 0, 0, 0, 0, $SWP_NOMOVE -bor $SWP_NOSIZE)
}
