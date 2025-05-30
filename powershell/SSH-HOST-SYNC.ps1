# Find the PID of the process using these ports and kill it
$Ports = @(3154)
$killedPIDs = @{}

foreach ($port in $Ports) {
    Write-Host "`n[TASK] :: Checking port ${port}..."
    $connection = netstat -ano | Select-String ":$port\s+.*LISTENING\s+(\d+)"
    
    if ($connection) {
        foreach ($match in $connection.Matches) {
            $procId = $match.Groups[1].Value
            if (-not $killedPIDs.ContainsKey($procId)) {
                try { Write-Host ">> Stopping process with an Id: ${procId}"
                    Stop-Process -Id $procId -Force
                    $killedPIDs[$procId] = $true
                    Write-Host ">>[STATUS]: Process Stopped."
                } catch {
                    Write-Warning ">>[STATUS]: Failed to kill PID ${procId}: $($_.Exception.Message)"
                }
            }
        }
    } else {
        Write-Host "No process found on port ${port}."
    }
}

# Terminate WSL2 Distro
$wslDistro = "WLinux"
Write-Host "`n[TASK] :: Terminating WSL2 distro: ${wslDistro}..."
try {
    wsl --terminate $wslDistro
    Write-Host ">>[STATUS]: WSL2 distro ${wslDistro} terminated successfully."
} catch {
    Write-Host ">>[STATUS]: Failed to terminate WSL2 distro: $_"
}

# Start SSH Service.
Write-Host "`n[TASK] :: Starting SSH service..."
try {
    wsl sudo service ssh start
    Write-Host ">>[STATUS]: SSH service started successfully."
} catch {
    Write-Host ">>[STATUS]: Failed to start SSH service: $_"
}

# WSL2 network port forwarding script v1
#   for enable script, 'Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser' in Powershell,
#   for delete exist rules and ports use 'delete' as parameter, for show ports use 'list' as parameter.

# Display all portproxy information
If ($Args[0] -eq "list") {
    netsh interface portproxy show v4tov4;
    exit;
} 

# If elevation needed, start new process
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path), "$Args runas" -Verb RunAs
    exit
}

# You should modify '$Ports' for your applications 
$Ports = (3154, 22, 2222, 80, 443, 8080)

# Check WSL ip address
wsl hostname -I | Set-Variable -Name "WSL"
$found = $WSL -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
if (-not $found) {
    Write-Output ">>[FAILED]: WSL2 cannot be found. Terminate script.";
    exit;
}

# Remove and Create NetFireWallRule
Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock';
if ($Args[0] -ne "delete") {
    New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $Ports -Action Allow -Protocol TCP;
    New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $Ports -Action Allow -Protocol TCP;
}

# Add each port into portproxy
$Addr = "0.0.0.0"
Foreach ($Port in $Ports) {
    Invoke-Expression "netsh interface portproxy delete v4tov4 listenaddress=$Addr listenport=$Port | Out-Null";
    if ($Args[0] -ne "delete") {
        Invoke-Expression "netsh interface portproxy add v4tov4 listenaddress=$Addr listenport=$Port connectaddress=$WSL connectport=$Port | Out-Null";
    }
}

# Display all portproxy information
netsh interface portproxy show v4tov4;

# Give user to chance to see above list when relaunched start
If ($Args[0] -eq "runas" -Or $Args[1] -eq "runas") {
    Write-Host -NoNewLine 'Press any key to close! ';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}
