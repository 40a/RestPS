$script:ModuleName = 'RestPS'
$Routes = @(
    @{
        'RequestType'    = 'GET'
        'RequestURL'     = '/proc'
        'RequestCommand' = 'get-process | select-object ProcessName'
    }
)
$RoutesFilePath = "Invoke-AvailableRouteSet"
Describe "Invoke-RequestRouter function for $moduleName" {
    It "Should return True" {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return 'True @{ProcessName=calc.exe}'
        }
        Mock -CommandName 'Set-Location' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should Be $true
    }
    It "Should return Invalid Command, if invoke expression fails." {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Set-Location' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/proc" -RoutesFilePath $RoutesFilePath | Should be "Invalid Command"
    }
    It "Should return No Matching Routes, if the URL is invalid." {
        Mock -CommandName 'Invoke-Expression' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Output' -MockWith {}
        Invoke-RequestRouter -RequestType "GET" -RequestURL "/FakeURL" -RoutesFilePath $RoutesFilePath | Should be "No Matching Routes"
    }
}