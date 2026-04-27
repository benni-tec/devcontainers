FROM qmcgaw/latexdevcontainer:latest

# set repo to TexLive 2025 and update tlmgr
RUN tlmgr repository set https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2025/tlnet-final && tlmgr update --self

# install python (required for texliveonfly)
RUN apt-get update && apt-get install -y python3 python-is-python3
RUN 

# install packages
RUN tlmgr install texliveonfly && texhash
