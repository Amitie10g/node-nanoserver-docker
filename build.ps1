$DockerUser = "amitie10g"

$baseURL = "https://nodejs.org/dist/"
$versionPattern = "node-v(\d+\.\d+\.\d+)-win-x64\.zip"

$directories = @(
    "latest-v10.x/",
    "latest-v11.x/",
    "latest-v12.x/",
    "latest-v13.x/",
    "latest-v14.x/",
    "latest-v15.x/",
    "latest-v16.x/",
    "latest-v17.x/",
    "latest-v18.x/",
    "latest-v19.x/",
    "latest-v20.x/",
    "latest-v4.x/",
    "latest-v5.x/",
    "latest-v6.x/",
    "latest-v7.x/",
    "latest-v8.x/",
    "latest-v9.x/"
)

$elementDirectories = @(
    "latest-argon",
    "latest-boron",
    "latest-carbon",
    "latest-dubnium",
    "latest-erbium",
    "latest-fermium",
    "latest-gallium",
	"latest-hydrogen"
)

$versionPattern = "node-v(\d+\.\d+\.\d+)-win-x64\.zip"

$versionHashTable = @{}

# Itera a través de los directorios de elementos químicos
foreach ($elementDirectory in $elementDirectories) {
    $url = $baseURL + $elementDirectory
    $htmlContent = Invoke-WebRequest -Uri $url
    $links = $htmlContent.Links | Where-Object { $_.href -match $versionPattern }

    foreach ($link in $links) {
        $version = [regex]::Match($link.href, $versionPattern).Groups[1].Value
        $elementName = ($elementDirectory -split '-')[1]
        $versionHashTable[$elementName] = $version
    }
}

$versionNumbers = @()

foreach ($directory in $directories) {
    $url = $baseURL + $directory
    $htmlContent = Invoke-WebRequest -Uri $url
    $links = $htmlContent.Links | Where-Object { $_.href -match $versionPattern }

    foreach ($link in $links) {
        $version = [regex]::Match($link.href, $versionPattern).Groups[1].Value
        $versionNumbers += $version
    }
}

$uniqueVersions = $versionNumbers | Select-Object -Unique

$sortedUniqueVersions = $uniqueVersions | Sort-Object { [version]$_ }

$NodeJSversions = $sortedUniqueVersions

$LatestVersion = $arrayForLoop | Sort-Object -Property {[Version]$_} | Select-Object -Last 1

#escape=`
# Build for Nano Server ltsc2022
foreach ($version in $NodeJSversions) {
	$majorVersion=$version -replace '^(\d+)\..*', '$1'
	$TAGS1 = "-t $DockerUser/node-nanoserver:$version -t $DockerUser/node-nanoserver:$majorVersion"
	$TAGS2 = "-t $DockerUser/node-nanoserver:$version-pwsh -t $DockerUser/node-nanoserver:$majorVersion-pwsh"

	if ($LatestVersion -eq $version) {
		$TAGS1 += " -t $DockerUser/node-nanoserver"
		$TAGS2 += " -t $DockerUser/node-nanoserver:pwsh"
	}
	
	foreach ($element in $versionHashTable.Keys) {
	    $versionElement = $versionHashTable[$element]
		if ($versionElement -eq $version){
			$TAGS1 += " -t $DockerUser/node-nanoserver:$element"
			$TAGS2 += " -t $DockerUser/node-nanoserver:$element-pwsh"
		}
	}

	cmd /c "docker build $TAGS1 --build-arg NODE_VER=$version ."
	cmd /c "docker build $TAGS2 --build-arg NODE_VER=$version --build-arg CONT_VER=7.3-nanoserver-ltsc2022 --build-arg BASE_IMG=powershell ."
}

docker push $DockerUser/node-nanoserver --all-tags
