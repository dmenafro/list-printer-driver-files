# the purpose of this script is to list all printers, their drivers, and the files associated with the driver.

# Define what you want the script to run against
[string]$PrintServer = "localhost OR servername"

# Define where you want the output to reside
$outputpath = "c:\temp\driver.dependencies.csv"

# Array for the result data
$results = @()

# Loop through all the printer drivers on the target system
ForEach ($Driver in (Get-WmiObject Win32_PrinterDriver -ComputerName $PrintServer))
{   
    
    # Find the drive letter the files reside on
    $Drive = $Driver.DriverPath.Substring(0,1)    
        
        # Create a new object to populate with data
        $CustomObject = [PSCustomObject] @{
            DriverName = $Driver.Name
            Version = (Get-ItemProperty ($Driver.DriverPath.Replace("$Drive`:","\\$PrintServer\$Drive`$"))).VersionInfo.ProductVersion
            Path = $Driver.DriverPath
            DriverFiles = ($Driver.DependentFiles -join ', ')
        }#EndCustomObject

    # Update array with collected data
    $results += $CustomObject

}#EndLoop

# Export result data to file​​​​​​
$Results | export-csv -Path $outputpath -NoTypeInformation
