FROM registry.gitlab.com/islandoftex/images/texlive:TL2025-historic

# set repo to TexLive 2025 and update tlmgr
RUN tlmgr option repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2025/tlnet-final && tlmgr update --self

COPY ./setup_tlmgr.sh /usr/local/bin/setup_tlmgr.sh
RUN chmod +x /usr/local/bin/setup_tlmgr.sh
