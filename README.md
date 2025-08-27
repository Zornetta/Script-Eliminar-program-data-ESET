# Script Eliminar ProgramData ESET

## Propósito

Este script de PowerShell está diseñado para ayudar a eliminar completamente la carpeta `ProgramData\Eset` en sistemas Windows. Es útil en situaciones donde el antivirus ESET no se desinstala correctamente, dejando archivos, carpetas o servicios residuales que impiden una nueva instalación o generan errores en el sistema.

## Funcionamiento

1. **Verificación de privilegios:** El script comprueba si se está ejecutando como administrador. Si no es así, se reinicia automáticamente con los permisos necesarios.
2. **Detención de servicios ESET:** Busca y detiene todos los servicios relacionados con ESET para evitar conflictos al eliminar archivos.
3. **Cambio de permisos:** Modifica los permisos de la carpeta y sus archivos para asegurar que puedan ser eliminados sin restricciones.
4. **Confirmación interactiva:** Solicita al usuario una confirmación antes de proceder con la eliminación de la carpeta.
5. **Eliminación segura:** Elimina la carpeta `C:/ProgramData/Eset` y todo su contenido.
6. **Registro de acciones:** Todas las acciones y errores se registran en un archivo log ubicado en la carpeta temporal del sistema (`%TEMP%\eliminarESET.log`).

## Uso

1. Haz clic derecho sobre el script y selecciona "Ejecutar con PowerShell" como administrador.
2. Sigue las instrucciones en pantalla y confirma la eliminación cuando se te solicite.
3. Revisa el archivo de log para detalles sobre el proceso o posibles errores.

## Advertencia

Este script elimina permanentemente la carpeta y todos sus archivos. Úsalo solo si estás seguro de que deseas borrar todos los restos de ESET.

---

**Autor:** Anzor
**Fecha:** Agosto 2025
