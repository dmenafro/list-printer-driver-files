# the purpose of this script is to list all printers, their drivers, and the files associated with the driver.

$servername = "name of server you want to collect information on"
$outputpath = "folder you want the results file to go to\driver.dependencies.csv"
Param ([string]$PrintServer = $servername)

$Results = ForEach ($Driver in (Get-WmiObject Win32_PrinterDriver -ComputerName $PrintServer))
{   $Drive = $Driver.DriverPath.Substring(0,1)    
    New-Object PSObject -Property @{
        Name = $Driver.Name
        Version = (Get-ItemProperty ($Driver.DriverPath.Replace("$Drive`:","\\$PrintServer\$Drive`$"))).VersionInfo.ProductVersion
        Path = $Driver.DriverPath
        DF = $Driver.DependentFiles -join ', '
    }​​​​​​​​​​​​​​
}​​​​​​​​​​​​​​​​​​​​​
$Results | export-csv -Path $outputpath
