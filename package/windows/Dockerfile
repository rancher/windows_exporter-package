ARG SERVERCORE_VERSION

FROM mcr.microsoft.com/windows/servercore:${SERVERCORE_VERSION} as download
ENV ARCH=amd64
ENV WINDOWS_EXPORTER_ARCHIVER_VERSION 0.16.0

SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $WINS_URL = 'https://github.com/rancher/wins/releases/download/v0.1.0/wins.exe'; \
    $DST_PATH = 'c:\wins.exe'; \
    \
    Write-Host ('Downloading Wins from {0} ...' -f $URL); \
    \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -UseBasicParsing -OutFile $DST_PATH -Uri $WINS_URL; \
    \
    Write-Host 'Downloading Wins complete.';


RUN $BINARY_URL = $('https://github.com/prometheus-community/windows_exporter/releases/download/v{0}/windows_exporter-{0}-{1}.exe' -f $env:WINDOWS_EXPORTER_ARCHIVER_VERSION, $env:ARCH); \
    $DST_PATH = 'c:\windows-exporter.exe'; \
    \
    Write-Host ('Downloading Windows Exporter binary from {0} ...' -f $BINARY_URL); \
    \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -UseBasicParsing -OutFile $DST_PATH -Uri $BINARY_URL; \
    \
    Write-Host 'Downloading Windows Exporter binary complete.';


FROM mcr.microsoft.com/powershell:nanoserver-${SERVERCORE_VERSION}

COPY --from=download /wins.exe /Windows/
COPY --from=download /windows-exporter.exe /etc/windows-exporter/
COPY entry.ps1 entry.ps1
USER ContainerAdministrator

CMD ["pwsh", "-f", "entry.ps1"]

