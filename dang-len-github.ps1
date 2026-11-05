# Doi ten audio theo map.csv va day toan bo len GitHub. (Chi dung chu khong dau de tranh loi ma hoa.)
Set-Location $PSScriptRoot
Write-Host '=== 1. Doi ten file audio theo map.csv ==='
$map=@{}
Import-Csv -Encoding UTF8 'audio\map.csv' | ForEach-Object { $map[[int]$_.moc]=$_.khoa }
$n=0
Get-ChildItem 'audio' -File | ForEach-Object {
  if ($_.Name -match '^\d+-P(\d+)\.(wav|mp3)$') {
    $p=[int]$Matches[1]; $e=$Matches[2]
    if ($map.ContainsKey($p)) { Move-Item -Force -LiteralPath $_.FullName -Destination (Join-Path 'audio' ($map[$p]+'.'+$e)); $n++ }
  }
}
Write-Host ("Da doi ten {0} file. Tong so file audio hien co: {1}" -f $n, (Get-ChildItem 'audio' -File | Where-Object { $_.Extension -in '.wav','.mp3' }).Count)
Write-Host '=== 2. Day len GitHub ==='
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host 'Chua cai Git. Tai o https://git-scm.com/download/win roi chay lai.'; exit 1 }
if (-not (Test-Path '.git')) { git init -b main | Out-Null }
if (-not (git config user.name)) { $u=Read-Host 'Ten cua ban (dung cho lich su GitHub)'; git config user.name $u }
if (-not (git config user.email)) { $m=Read-Host 'Email GitHub cua ban'; git config user.email $m }
$remote = git remote get-url origin 2>$null
if (-not $remote) { $url=Read-Host 'Dan dia chi kho GitHub (vi du https://github.com/tenban/cham-trac-nghiem.git)'; git remote add origin $url }
git add -A
git commit -m ("Cap nhat " + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
git branch -M main
git push -u origin main
if ($LASTEXITCODE -eq 0) { Write-Host 'XONG. Vao GitHub > Settings > Pages de bat trang web (xem HUONG-DAN.txt).' } else { Write-Host 'Day len chua thanh cong. Doc thong bao loi o tren (thuong la sai dia chi kho hoac chua dang nhap GitHub).' }
