ARG SERVER_VERSION

FROM mcr.microsoft.com/windows/servercore:${SERVER_VERSION} as download

SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG TARGET_ARCH=amd64
ENV ARCH=$TARGET_ARCH
ENV WINDOWS_EXPORTER_ARCHIVER_VERSION 0.16.0

RUN $BINARY_URL = $('https://github.com/prometheus-community/windows_exporter/releases/download/v{0}/windows_exporter-{0}-{1}.exe' -f $env:WINDOWS_EXPORTER_ARCHIVER_VERSION, $env:ARCH); \
    $DST_PATH = 'windows-exporter.exe'; \
    Write-Host ('Downloading Windows Exporter binary from {0} ...' -f $BINARY_URL); \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -UseBasicParsing -OutFile $DST_PATH -Uri $BINARY_URL; \
    Write-Host 'Downloading Windows Exporter binary complete.';

FROM mcr.microsoft.com/windows/nanoserver:${SERVER_VERSION}

COPY --from=download ./windows-exporter.exe ./windows-exporter.exe

EXPOSE 9796

CMD windows-exporter.exe --collectors.enabled="net,os,service,system,cpu,cs,logical_disk" --telemetry.addr=":9796" --telemetry.max-requests=5 --telemetry.path="/metrics"
