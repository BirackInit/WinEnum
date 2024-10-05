<#
Script: Nom_du_Script.ps1
Description: Ce script affiche diverses informations sur le système d'exploitation, les utilisateurs, les services, les journaux d'événements, etc.
Auteur: Hassan ATTEIB
LinkedIn: https://www.linkedin.com/in/atteib-hassan-mahamat-%F0%9F%94%90-83a657221/
Date: 14/05/2024
#>

"#####                                                       #####"
"#####  Must be executed from a Domain Admin account         #####"
"#####                                                       #####"
"#####  Developped by Hassan ATTEIB #####"
"#####  https://www.linkedin.com/in/atteib-hassan-mahamat-%F0%9F%94%90-83a657221/       #####"
"#################################################################"

" __          ___                         _ _ _       "
" \ \        / (_)         /\            | (_) |      "
"  \ \  /\  / / _ _ __    /  \  _   _  __| |_| |_ ___ "
"   \ \/  \/ / | | '_ \  / /\ \| | | |/ _` | | __/ _ \"
"    \  /\  /  | | | | |/ ____ \ |_| | (_| | | ||  __/"
"     \/  \/   |_|_| |_/_/    \_\__,_|\__,_|_|\__\___|"
"                                                     "


# Fonction pour afficher des informations sur le système d'exploitation
function Show-OSInfo {
    $osInfo = Get-WmiObject Win32_OperatingSystem
    $networkInfo = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }

    Write-Host "Système d'exploitation : " $osInfo.Caption
    Write-Host "Version : " $osInfo.Version
    Write-Host "Architecture du processeur : " (Get-WmiObject Win32_Processor).Architecture
    Write-Host "Nom de l'ordinateur : " $env:COMPUTERNAME
    Write-Host "Utilisateur actuel : " $env:USERNAME

    if ($networkInfo) {
        Write-Host "Adresse IP : " $networkInfo.IPAddress[0]
        Write-Host "Adresse MAC : " $networkInfo.MACAddress
    } else {
        Write-Host "Adresse IP : Non disponible"
        Write-Host "Adresse MAC : Non disponible"
    }
}

# Fonction pour afficher des informations système
function Show-SystemInfo {
    Write-Host "Options :"
    Write-Host "1- Afficher des informations sur le système d'exploitation"
    Write-Host "2- Afficher les fichiers de partage sur les systèmes"
    Write-Host "3- Afficher les utilisateurs"
    Write-Host "4- Afficher les services en cours d'exécution"
    Write-Host "5- Afficher les journaux d'événements récents"
    Write-Host "6- Afficher les services malconfigurés"
    Write-Host "Saisir l'option que vous souhaitez exécuter :"
    $option = Read-Host

    switch ($option) {
        1 { Show-OSInfo }
        2 { Show-SharedFiles }
        3 { Show-Users }
        4 { Show-Services }
        5 { Show-EventLogs }
        6 { Show-MisconfiguredServices }
        default { Write-Host "Option invalide." }
    }
}

# Fonction pour afficher ses fichiers de partage
function Show-SharedFiles {
    Write-Host "Fichiers de partage sur les systèmes : "
    Get-SmbShare | Select-Object Name, Path
}

# Fonction pour lister les utilisateurs
function Show-Users {
    Write-Host "Utilisateurs : "
    Get-WmiObject Win32_UserAccount | Select-Object Name, FullName
}

# Fonction pour lister les services en cours d'exécution
function Show-Services {
    Write-Host "Services en cours d'exécution : "
    Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object DisplayName, Status
}

# Fonction pour lister les journaux d'événements récents
function Show-EventLogs {
    Write-Host "Journaux d'événements récents : "
    Get-EventLog -LogName Application -Newest 10 | Select-Object TimeGenerated, Source, EventID, Message
}

# Fonction pour lister les services malconfigurés
function Show-MisconfiguredServices {
    Write-Host "Services malconfigurés : "

    # Recherche des services avec des paramètres de démarrage non standard
    $misconfiguredServices = Get-WmiObject Win32_Service | Where-Object {$_.StartMode -ne "Auto"}

    if ($misconfiguredServices) {
        Write-Host "Services avec des paramètres de démarrage non standard : "
        $misconfiguredServices | Select-Object Name, StartMode
    }

    # Autres vérifications de configuration peuvent être ajoutées ici
}

# Appel de la fonction principale
Show-SystemInfo
