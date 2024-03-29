

function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host ('_' * (get-host).ui.rawui.windowsize.width) -nonewline
    Write-Host $pwd.ProviderPath -fore darkyellow -nonewline
    Write-Host " " -nonewline
    Write-Host "$(git rev-parse --abbrev-ref HEAD)" -nonewline
    Write-Host " >" -fore DarkYellow -nonewline

    $global:LASTEXITCODE = $realLASTEXITCODE
    " "
}

function global:sln {
    get-childitem *.sln | foreach { explorer $_ }
}


function global:Resolve-Error ($ErrorRecord=$Error[0])
{
   $ErrorRecord | Format-List * -Force
   $ErrorRecord.InvocationInfo |Format-List *
   $Exception = $ErrorRecord.Exception
   for ($i = 0; $Exception; $i++, ($Exception = $Exception.InnerException))
   {   "$i" * 80
       $Exception |Format-List * -Force
   }
}

function global:done_beep { 
   (1..3) | foreach { start-sleep -seconds 0.2; [console]::beep(2000,500) }
}

function global:sonarping($target) {
while ($true) {
if (test-connection $target -count 1 -quiet) {
 [console]::beep(500,600);
 start-sleep -s 2
  } else {
 [console]::beep(500,60)
 start-sleep -s 2
 }
 }
}

function global:whenpingable($target, $toExecute) {
    while (!(test-connection $target -count 1 -quiet)) {
        start-sleep -s 2
    }
    & $toExecute
}

function global:runat($time, $toExecute) {
    $seconds = (New-TimeSpan -End $time).TotalSeconds
    if ($seconds -le 1) { throw "$time is in the past" }
    "Sleeping for $seconds seconds and then running `{ $toExecute `}"
    $job = start-job {
        param($seconds, $toExecute)
        Sleep -Seconds $seconds
        & $toExecute
    } -arg $seconds, $toExecute
    $job
}

function global:sleepuntil($time, $toExecute) {
    $seconds = (New-TimeSpan -End $time).TotalSeconds
    if ($seconds -le 1) { throw "$time is in the past" }
    "Sleeping for $seconds seconds and then running `{ $toExecute `}"
    Sleep -Seconds $seconds
    & $toExecute
}

function global:deleteuntrackedfiles() {
    & git status --porcelain --untracked-files=all | grep '^??' | cut -c 4- | remove-item -force
}

# cut-down version of http://blogs.msdn.com/b/timid/archive/2013/03/20/adding-a-timestamp.aspx
function Add-TimeStamp {
    begin {
        write-host "Starting at $(get-date)"
        $sw = [diagnostics.stopwatch]::StartNew()
    }
    process {
        $input | % { "$($sw.Elapsed)`t$($_)"; }
    }
    end {
       write-host "Ending at $(get-date)"
       write-host "Total time: $($sw.Elapsed)"
    }
} 

function Add-Times {
    begin {
        write-host "Starting at $(get-date)"
    }
    process {
        $input | % { "$(get-date)`t$($_)"; }
    }
    end {
       write-host "Ending at $(get-date)"
       write-host "Total time: $($sw.Elapsed)"
    }
} 

function inspect {
    & "C:\Program Files (x86)\Windows Kits\10\bin\x64\inspect.exe"
}

function fixforegroundcolour {
    [console]::ForegroundColor = 'gray'
    [console]::BackgroundColor = 'black'
}

function resetrepo {
    git purge; init; build restorenugetpackages
}

function touch($file) {
    out-file -append -encoding ascii $file
}

function pingslack($message) {
    if (!$env:SLACK_API_TOKEN -or !$env:SLACK_USERNAME) {
        write-warning "SLACK_API_TOKEN and SLACK_USERNAME need to be set to send slack messages"
        return
    }

    $message = [Uri]::EscapeDataString($message)
    $channel = [Uri]::EscapeDataString($env:SLACK_USERNAME)
    $url = "https://slack.com/api/chat.postMessage?token=$($env:SLACK_API_TOKEN)&channel=$($channel)&text=$($message)&pretty=1"
    Invoke-RestMethod $url
}

function withslack() {
  param([scriptblock] $block)

  try {
    invoke-command $block
    pingslack 'done'
  }
  catch {
    pingslack $_
    throw
  }
}

function infolder() {
  param(
  $folder,
  [scriptblock] $block
  )

  try {
    push-location $folder
    invoke-command $block
  }
  finally {
    pop-location
  }
}

function get-definition() {
    (get-command $args).Definition
}

set-alias gd get-definition

# experimental: ideally this would be a nice way to pick a command from history
# annoyingly hitting cancel or close on the out-gridview call still sends a value down the pipeline;
# we always end up running *something* from the history even if we didn't want to
function hx() {
  get-history | sort -descending | out-gridview -outputmode single | invoke-history
}

# try to run a .sh file by running all of the commands in it
function sh($filename) {
  cat $filename | where { $_.trim() } | iex
}

function get-type($thing) {
    if ($thing -eq $null) { return '$null' }
    return $thing.GetType().Name
}

set-alias gt get-type

function ge { gitextensions }
function gec { gitextensions commit }

function reset { [console]::ResetColor() }

function dnr { clear; reset; dotnet restore }
function dnb { clear; reset; dotnet build --no-restore }
function dnt { clear; reset; dotnet test --no-restore }

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function ghpr {
    $SelectedPrLine = @(gh pr list | fzf)
    if ($SelectedPrLine.count -le 0)
    {
        write-host "No PR selected"
        return
    }
    
    $SelectedPrLine = $SelectedPrLine[0]
    $SelectedPrNumber = $SelectedPrLine.split("`t")[0]
    
    gh pr checkout $SelectedPrNumber
}
