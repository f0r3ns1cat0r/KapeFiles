param(
[string]$Source,
[string]$Out
)

$patterns = @(
"ssh -L",
"ssh -R",
"ssh -D",
"ssh -N",
"plink -L",
"plink -R",
"plink -D",
"netsh interface portproxy",
"chisel",
"ngrok",
"cloudflared",
"ligolo",
"frp",
"socat"
)

$results = @()

$files = Get-ChildItem -Path $Source -Recurse -File -ErrorAction SilentlyContinue

foreach ($file in $files) {

```
try {

    $lines = Get-Content $file.FullName -ErrorAction SilentlyContinue
    $lineNum = 0

    foreach ($line in $lines) {

        $lineNum++

        foreach ($pattern in $patterns) {

            if ($line -match $pattern) {

                $results += [PSCustomObject]@{
                    FilePath = $file.FullName
                    FileName = $file.Name
                    LineNumber = $lineNum
                    PatternMatched = $pattern
                    CommandLine = $line
                    LastWriteTimeUtc = $file.LastWriteTimeUtc
                }

            }

        }

    }

} catch {}
```

}

$results | Export-Csv $Out -NoTypeInformation
