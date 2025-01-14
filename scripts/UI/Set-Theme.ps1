function Switch-ToDarkMode {
    try {
        $theme = $itt['window'].FindResource("Dark")
        Update-Theme $theme "true"
    } catch {
        Write-Host "Error switching to dark mode: $_"
    }
}
function Switch-ToLightMode {
    try {
        $theme = $itt['window'].FindResource("Light")
        Update-Theme $theme "Light"
    } catch {
        Write-Host "Error switching to light mode: $_"
    }
}
function Update-Theme ($theme) {
    $itt['window'].Resources.MergedDictionaries.Clear()
    $itt['window'].Resources.MergedDictionaries.Add($theme)
    Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "$theme" -Force
}
function SwitchToSystem {
    try {
        Set-ItemProperty -Path $itt.registryPath  -Name "Theme" -Value "default" -Force
        $AppsTheme = (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme")
        switch ($AppsTheme) {
            "0" {
                $itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource("Dark"))
            }
            "1" {
                $itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource("Light"))
            }
            Default {
                Write-Host "Unknown theme value: $AppsTheme"
            }
        }
    }
    catch {
        Write-Host "Error occurred: $_"
    }
}
function Set-Theme {
    param (
        [string]$Theme
    )
    Switch($Theme)
    {
        "Light"{
            $itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource("Light"))
            Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "Light" -Force
        }
        "Dark"{
            $itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource("Dark"))
            Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "Dark" -Force
        }
        default{
            $itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource("$Theme"))
            Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "Custom" -Force
            Set-ItemProperty -Path $itt.registryPath -Name "UserTheme" -Value "$Theme" -Force
        }
    }
}