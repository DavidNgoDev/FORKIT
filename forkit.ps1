Import-Module ActiveDirectory

# Checking if script was ran with administrative privledges
#Requires -RunAsAdministrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Host "This Script Needs To Be Ran With Administrative Privledges" -ForegroundColor Red
  Write-Host "Right Click The Script and Run With Admin. Thanks!" -ForegroundColor Red
  Read-Host  "Press any key to continue"
  exit
}

# Auto Script Update
$currentVersion = "1.0"
$url = "https://downloads.kizio.tech/version.txt"
$output = "$env:tmp\version.txt"
(New-Object System.Net.WebClient).DownloadFile($url, $output)
$latestVersion = Get-Content -Path $env:tmp\version.txt
if ($latestVersion -gt $currentVersion) {
      Write-Host "New Script Avaliable. Do You Want To Download It?"
      $confirmation = Read-Host "'y' for Yes, 'n' for No:"
      if ($confirmation -eq 'y') {
            $url = "https://raw.githubusercontent.com/DavidNgoDev/FORKIT/master/updater.ps1"
            $output = "$PSScriptRoot\updater.ps1"
            # Make a verifier script to replace active script and del old script
            $start_time = Get-Date
            (New-Object System.Net.WebClient).DownloadFile($url, $output)
            Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
            Write-Host "CSV Template Downloaded and Saved to Desktop"
}
else {
      echo "Script is up to date."
}

}
Clear-Host

function Show-Menu {
Write-Host "    __________  ____  __ __ __________" -ForegroundColor Green 
Write-Host "   / ____/ __ \/ __ \/ //_//  _/_  __/" -ForegroundColor Green 
Write-Host "  / /_  / / / / /_/ / ,<   / /  / /   " -ForegroundColor Green 
Write-Host " / __/ / /_/ / _, _/ /| |_/ /  / /    " -ForegroundColor Green 
Write-Host "/_/    \____/_/ |_/_/ |_/___/ /_/     " -ForegroundColor Green
Write-Host "                                      "
Write-Host "--------------------------------------"
Write-Host "| Made By David Ngo      Version 1.0 |"
Write-Host "--------------------------------------"
Write-Host "                                      "                                      
Write-Host "   What Would You Like To Do Today?   "
Write-Host "                                      " 
Write-Host "--------------------------------------"
Write-Host "| Option Menu                [-] [X] |"
Write-Host "--------------------------------------"
Write-Host "| 1) Create AD DS CSV Template File  |"
Write-Host "| 2) Import CSV File For AD DS       |"
Write-Host "| 3) Add Users                       |"
Write-Host "| 4) Delete Users                    |"
Write-Host "| 5) Block User Access               |"
Write-Host "| 6) Reset User Password             |"
Write-Host "| 7) Apply GPO To User or OU         |"
Write-Host "| 8) Settings                        |"
Write-Host "| 9) Information                     |"
Write-Host "--------------------------------------"      
Write-Host "                                      "
}

function Import-CSV-File {
    $filePath = Read-Host -Prompt "Please Enter or Drag Your CSV Path Here"
    $users = Import-Csv $filePath
    ForEach ($user in $user) {
        $firstName = $user.'First Name'
        $lastName = $user.'Last Name'
        $password = $user.Password
        $jobTitle = $user.'Job Title'
        $officePhone = $user.'Office Phone'
        $emailAddress = $user.'Email Address'
        $OUpath = $user.'Organisational Unit'
        $securePassword = ConvertTo-SecureString "$password" -AsPlainText -Force
        $lastNameUp = ($lastName.ToUpper())
        $Final = $firstName + $lastNameUp[0]
        New-ADuser -Name "$firstName $lastName" -DisplayName "$firstName $lastName" -GivenName $firstName -Surname $lastName -UserPrincipalName "$Final" -Path $OUpath -AccountPassword $securePassword -ChangePasswordAtLogon $True -OfficePhone $officePhone -EmailAddress $emailAddress -Enabled $True
        Write-Host "$firstName $lastName was sucessfully added to $OUpath"
    }
}

function Get-All-OU {
      
}

function Add-Users {
$exit = ""
While($exit -ne "q") {
    # Store Users Information as Varibles
    $firstName = Read-Host -Prompt "Please Enter Your First Name"
    $lastName = Read-Host -Prompt "Now Please Enter Your Last Name"
    $password = Read-Host -Prompt "Finally, Enter Your Password"

    # Output The Information
    echo "Your Full Name Is $firstName $lastName."
    $numberOfSubOU = Read-Host -Prompt "How many Sub OU Do You Have"
    $mainOU = Read-Host -Prompt "What OU Would You Like To Place The User In?"
    $subOU = Read-Host -Prompt "What Is The Sub OU of the Main OU?"
    $ADDSdomain = Read-Host -Prompt "What Is Your Domain"
    $ReacallDomain = ""
    echo "Would You Like To Save This Configuration For This Session?"
    echo "You Can Also Save Other Data In The Settings Menu."
    # Storing Information 
    $OUpath =  "OU=Power Shell Users,OU=Kizio Technologies,DC=Kizio,DC=Tech"

    # Secure Password String
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    $lastNameUp = ($lastName.ToUpper())
    $Final = $firstName + $lastNameUp[0]

    # Create The User Account
    New-ADUser -Name "$firstName $lastName" -GivenName $firstName -Surname $lastName -UserPrincipalName "$Final" -Path $OUpath -AccountPassword $securePassword -ChangePasswordAtLogon $True -Enabled $True

    #Output
    echo "User Was Created Sucessfully!"
    $exit = Read-Host -Prompt "Type 'q' To Quit! Enter To Continue Using The Tool"
}
}

function Del-User {

}

function Information {
      Write-Host "--------------------------------------------------------------------------"
      Write-Host "| Forkit | Infromation                                           [-] [X] |"
      Write-Host "--------------------------------------------------------------------------"
      Write-Host "| What is Frokit?                                                        |"
      Write-Host "| Forkit is a PS script for AD DS admin's to use to quickly make changes |"
      Write-Host "| regardings users and OU units. Forkit has many features such as        |"
      Write-Host "| the ability to import and create CSV files as well as quick user add   |"
      Write-Host "| deleteion and blocking. Forkit also had a wizard to help setup your    |"
      Write-Host "| AD DS Server in a flash by setting up basic GPO and OU Units as well   |"
      Write-Host "| as users and permission groups.                                        |"
      Write-Host "--------------------------------------------------------------------------"
}

Show-Menu
do
{
     $input = Read-Host "Please make a selection or 'q' to quit"
     Write-Host "                                      "
     switch ($input)
     {
           '1' {
                 $url = "http://mirror.internode.on.net/pub/test/10meg.test"
                 $DesktopPath = [Environment]::GetFolderPath("Desktop")
                 $output = "$DesktopPath\10meg.test"
                 $start_time = Get-Date
                 (New-Object System.Net.WebClient).DownloadFile($url, $output)
                 Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
                 Write-Host "CSV Template Downloaded and Saved to Desktop"
                 pause          
                 Clear-Host
                 Show-Menu
           } '2' {
                 Write-Host "--------------------------------------"
                 Write-Host "| User Input Needed              [x] |"
                 Write-Host "--------------------------------------"
                 Write-Host "                                      "   
                 Import-CSV-File
           } '3' {

                'You chose option #3'
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q') 


