FROM ubuntu:latest

WORKDIR /usr/src/app

# Update apt sources
RUN apt update

# Install add-apt-repo
RUN apt install -y software-properties-common

# Add Flatpak repository to apt
RUN add-apt-repository ppa:alexlarsson/flatpak

# Update apt sources
RUN apt update

# Install Flatpak
RUN apt install -y flatpak

# Install the Software Flatpak plugin
RUN apt install -y gnome-software-plugin-flatpak

# Add the Flathub repository
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install PPSSPP
RUN flatpak install -y flathub org.ppsspp.PPSSPP

# Run PPSSPP
RUN flatpak run org.ppsspp.PPSSPP