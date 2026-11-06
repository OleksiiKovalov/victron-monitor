# Puts victron-monitor.html on the GX; after that the page opens from any device on the network:
#   http://<GX IP>/monitor/
#
# Once, on the GX (Remote Console):
#   1. Settings -> General -> Access level -> Superuser
#      (if it's not listed: select "Access level" and hold the "right" button for ~5 s).
#   2. On the same page: Set root password, then turn on "SSH on LAN".
#
# Run (from the script's folder):
#   powershell -ExecutionPolicy Bypass -File .\deploy-to-gx.ps1 -Gx 192.168.1.50   (your GX IP)
# The root password is asked twice (copy and install). Running it again updates the page.

param([Parameter(Mandatory = $true, HelpMessage = 'GX IP address, e.g. 192.168.1.50')][string]$Gx)
$ErrorActionPreference = 'Stop'

$page = Join-Path $PSScriptRoot 'victron-monitor.html'
$inst = Join-Path $PSScriptRoot 'install-monitor.sh'
foreach ($f in $page, $inst) { if (-not (Test-Path $f)) { throw "File not found: $f" } }

Write-Host "1/2 Copying files to $Gx (GX root password)..."
scp -o StrictHostKeyChecking=accept-new $page $inst "root@${Gx}:/tmp/"
if ($LASTEXITCODE) { throw "Copy failed (exit code $LASTEXITCODE). Is SSH enabled on the GX?" }

Write-Host "2/2 Installing (GX root password again)..."
$cmd = 'mkdir -p /data/www/monitor && mv /tmp/victron-monitor.html /data/www/monitor/index.html' +
       ' && mv /tmp/install-monitor.sh /data/www/install-monitor.sh && tr -d ''\r'' </data/www/install-monitor.sh > /tmp/im.sh' +
       ' && mv /tmp/im.sh /data/www/install-monitor.sh && chmod 755 /data/www/install-monitor.sh && /data/www/install-monitor.sh'
ssh -o StrictHostKeyChecking=accept-new "root@$Gx" $cmd
if ($LASTEXITCODE) { throw "Install failed (exit code $LASTEXITCODE)." }

Write-Host "Open on your phone: http://$Gx/monitor/   (wall mode: http://$Gx/monitor/?wall=1)"
