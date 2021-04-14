$PCS = get-content -path C:\Users\s5136c\Desktop\file_with_list_of_computers.txt
$path = "C:\Users\s5136c\Desktop\Exporeted_list.csv"
$i = 1

foreach ($PC in $PCS){

        $save = new-Object -TypeName PSObject -Property  @{
                Count =$i
                IP = $PC
                Computer_name = $computer_name
                }

        try{

            if (test-connection -computername $PC -count 1 -Quiet){
            try{

                $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $PC)
                $RegistryKeyBnr = $Registry.OpenSubKey("SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName", $true)
                $computer_name = $RegistryKeyBnr.GetValue('ComputerName')
                $i += 1

                Write-host $i $PC $computer_name
                $save | Export-Csv $path -Append

                }

            catch{

                  $computer_name = 'Error'
                  $i += 1
                  write-host $i $PC
                  $save | Export-Csv $path -Append

                  }

            }

            else{$computer_name = 'Offline'
            $i += 1
            write-host $i $PC ' Offline'
            $save | Export-Csv $path -Append

                }
         }   

        catch{

            write-host $i $PC 'Error'
            $computer_name = 'Error'
            $i += 1
            $save | Export-Csv $path -Append
            
             }
  }
