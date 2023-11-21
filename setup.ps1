# setup.ps1 -- Reference https://realpython.com/python-coding-setup-windows/#discovering-the-windows-terminal

Write-Output "Downloading and installing Chocolatey"
Invoke-WebRequest -useb community.chocolatey.org/install.ps1 | Invoke-Expression

Write-Output "Configuring Chocolatey"
choco feature enable -n allowGlobalConfirmation

Write-Output "Installing Chocolatey Packages"
choco install powershell-core
choco install vscode
choco install git --package-parameters="/NoAutoCrlf /NoShellIntegration"
choco install pyenv-win

# refreshenv

# The refreshenv command usually doesn't work on first install.
# This is a way to make sure that the Path gets updated for the following
# operations that require Path to be refreshed.
# Source: https://stackoverflow.com/a/22670892/10445017
foreach ($level in "Machine", "User") {
    [Environment]::GetEnvironmentVariables($level).GetEnumerator() |
    ForEach-Object {
        if ($_.Name -match 'Path$') {
            $combined_path = (Get-Content "Env:$($_.Name)") + ";$($_.Value)"
            $_.Value = (
                ($combined_path -split ';' | Select-Object -unique) -join ';'
            )
        }
        $_
    } | Set-Content -Path { "Env:$($_.Name)" }
}

Write-Output "Setting up pyenv and installing Python"
pyenv update
pyenv install --quiet 3.11.0 
pyenv global 3.11.0

Write-Output "Generating SSH key"
ssh-keygen -C rdnotlaw91@outlook.com -P '""' -f "$HOME/.ssh/id_rsa"
Get-Content $HOME/.ssh/id_rsa.pub | clip

Write-Output "Your SSH key has been copied to the clipboard. Add it to GitHub."