# Anslut till Tenant
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Hämta sökvägen och läs in CSV-filen
$csvPath = "scripts\create users from csv\users.csv"
$users = Import-Csv -Path $csvPath

# Sätt lösenord, tvinga byta vid första inloggning
$passwordProfile = @{
    Password = "NewUser2026!_"
    ForceChangePasswordNextSignIn = $true
}

# Loopa igenom listan med användare och skapa konton
foreach ($user in $users) {
    Write-Host "Skapar användare: $($user.DisplayName)" 
    $userParams = @{
        DisplayName       = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        AccountEnabled    = $true
        MailNickName      = $user.UserPrincipalName.Split('@')[0]
        Department        = $user.Department
        JobTitle          = $user.JobTitle
        PasswordProfile   = $passwordProfile
    }
    New-MgUser @userParams
}