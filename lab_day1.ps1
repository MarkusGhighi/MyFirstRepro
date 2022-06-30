
 Function New-AccountName 
 {    param([parameter(Mandatory)]$AccountName)    
      $UniqueName = $AccountName    
      $count = 1    
        While ([bool](Get-Aduser -filter { SamAccountName -eq $UniqueName })) 
        {
            $UniqueName = $AccountName + $count        
            $Count++    
        }    
            if ($UniqueName -ne $AccountName) 
            {  
                Write-Warning "$AccountName already exists, using $UniqueName instead"
            }    
        $UniqueName
}  
    
    Function New-ContosoUser 
    {    [cmdletbinding(SupportsShouldProcess)]    
        param([parameter(Mandatory, HelpMessage = "Provide the path to a CSV file that contains at least NAME as a header", ValueFromPipeline)]$csv)    
        
        process 
        { $Users = Import-Csv $csv
                foreach ($user in $users) 
                { $User.Name = New-AccountName -AccountName $User.Name            
                    if ($PSCmdlet.ShouldProcess($User.Name, "Adding user")) 
                    { $user | New-ADUser 
                        Write-Verbose "Adding User: $($User.Name)..."            
                    }        
                }    
        }
    }  
    
    function Get-LabUsers 
    {    param([int]$Hours = 6)    
        $Created = (Get-Date).AddHours(-$Hours)    
        Get-Aduser -filter { WhenCreated -gt $Created } | Select-Object Name
    }  
    
    function Remove-LabUsers 
    {    param([int]$Hours = 6)    
        $Created = (Get-Date).AddHours(-$Hours)    
        Get-Aduser -filter { WhenCreated -gt $Created } | Remove-ADUser -Confirm:$false -Verbos
    }        
        
        

    "C:\PShell\Labs\NewEmployees.csv", "C:\PShell\Labs\NewEmployees2.csv", "C:\PShell\Labs\NewEmployees3.csv" | New-ContosoUser    