$PCS = get-content -path C:\Users\s5136c\Desktop\file_with_list_of_computers.txt
$path = "C:\Users\s5136c\Desktop\Exporeted_list.csv"
$i = 1

foreach ($PC in $PCS){

        $save = new-Object -TypeName PSObject -Property  @{
                Count =$i
                IP = $PC
                Extracted_value = $extracted_value
                }

        try{

            if (test-connection -computername $PC -count 1 -Quiet){
            try{

                $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $PC)
                $RegistryKey = $Registry.OpenSubKey("SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName", $true)
                $extracted_value = $RegistryKey.GetValue('ComputerName')
                $i += 1

                Write-host $i $PC $extracted_value
                $save | Export-Csv $path -Append

                }

            catch{

                  $extracted_value = 'Error'
                  $i += 1
                  write-host $i $PC
                  $save | Export-Csv $path -Append

                  }

            }

            else{$extracted_value = 'Offline'
            $i += 1
            write-host $i $PC ' Offline'
            $save | Export-Csv $path -Append

                }
         }   

        catch{

            write-host $i $PC 'Error'
            $extracted_value = 'Error'
            $i += 1
            $save | Export-Csv $path -Append
            
             }
  }
