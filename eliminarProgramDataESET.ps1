# Comprobar si el script se está ejecutando con privilegios de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Reiniciar el script con privilegios de administrador
    Start-Process powershell "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Ruta de la carpeta a eliminar
$folderPath = "C:/ProgramData/Eset"
$logPath = "$env:TEMP\eliminarESET.log"

# Función para registrar acciones en un archivo log
function Write-Log {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "$timestamp - $message"
    Write-Output $message
}

# Función para detener servicios relacionados con ESET
function Stop-EsetServices {
    $esetServices = Get-Service | Where-Object {$_.DisplayName -like "*ESET*"}
    foreach ($service in $esetServices) {
        if ($service.Status -eq 'Running') {
            try {
                Stop-Service -Name $service.Name -Force
                Write-Log "Servicio detenido: $($service.Name)"
            } catch {
                Write-Log "Error al detener servicio $($service.Name): $_"
            }
        }
    }
}

# Función para cambiar permisos de la carpeta y sus archivos
function Set-Permissions {
    param (
        [string]$path
    )
    try {
        $acl = Get-Acl $path
        $acl.SetAccessRuleProtection($false, $true)
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
        $acl.SetAccessRule($accessRule)
        Set-Acl -Path $path -AclObject $acl
        Write-Log "Permisos cambiados: $path"
    } catch {
        Write-Log "Error al cambiar permisos en $path: $_"
    }
}

# Función para confirmar la eliminación
function Confirm-Deletion {
    param([string]$target)
    $confirmation = Read-Host "¿Seguro que desea eliminar '$target'? (s/n)"
    if ($confirmation -eq 's' -or $confirmation -eq 'S') {
        return $true
    } else {
        Write-Log "Eliminación cancelada por el usuario."
        return $false
    }
}

# Detener servicios relacionados con ESET
Stop-EsetServices

# Pausar por unos segundos para asegurarse de que los servicios se hayan detenido
Start-Sleep -Seconds 5

# Cambiar permisos de la carpeta y su contenido
if (Test-Path -Path $folderPath) {
    if (-not (Confirm-Deletion $folderPath)) {
        exit
    }
    Get-ChildItem -Path $folderPath -Recurse | ForEach-Object { Set-Permissions $_.FullName }
    Set-Permissions $folderPath

    # Verificar si la carpeta existe y eliminarla
    try {
        # Eliminar la carpeta y su contenido
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Log "La carpeta ha sido eliminada exitosamente."
    } catch {
        Write-Log "Error al eliminar la carpeta: $_"
    }
} else {
    Write-Log "La carpeta no existe."
}