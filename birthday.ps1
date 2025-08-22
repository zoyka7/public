param(
    [Parameter(Mandatory=$true)]
    [datetime]$Birthday
)

$startYear = $Birthday.Year
$endYear = (Get-Date).Year + 50

Write-Host "Calcolo dei giorni della settimana per il compleanno dal $startYear al $endYear`n"  

# Dizionario per contare le occorrenze dei giorni della settimana
$weekdaysCount = @{
    "Lunedì"    = 0
    "Martedì"   = 0
    "Mercoledì" = 0
    "Giovedì"   = 0
    "Venerdì"   = 0
    "Sabato"    = 0
    "Domenica"  = 0
}

Write-Host "Distribuzione dei giorni della settimana per il compleanno ($($Birthday.ToString('dd/MM/yyyy'))):`n"
Write-Host "anno partenza: $startYear   anno finale $endYear" -ForegroundColor Yellow
Write-Host "--------------------------------" -ForegroundColor Yellow       


 for ($year = $startYear; $year -le $endYear; $year++) {
     $currentBirthday = Get-Date -Year $year -Month $Birthday.Month -Day $Birthday.Day
     $weekday = $currentBirthday.ToString("dddd", [System.Globalization.CultureInfo]::GetCultureInfo("it-IT"))
     $weekdaysCount[$weekday]++
     Write-Host "$year : $weekday"
 } 

 
Write-Host "`nRiepilogo:" -ForegroundColor Yellow
foreach ($day in $weekdaysCount.Keys) {
    Write-Host "$day : $($weekdaysCount[$day]) volte" -ForegroundColor Green
} #>