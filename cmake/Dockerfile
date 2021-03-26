FROM ubuntu:latest

WORKDIR /usr/src/app

# Update apt sources
RUN apt update

# Install git
RUN apt install -y git

# Get latest source code of PPSSPP (without folder, destination needs to be empty)
RUN git clone --recurse-submodules https://github.com/hrydgard/ppsspp.git .

# Install debconf (automated prompt answering tool)
RUN apt install debconf-utils

# Add Interaction-answer (Europe) to debconf for libsdl2
RUN echo "libgl1-mesa-dev libgl1-mesa-dev/Geographic area: String 8" | debconf-set-selections

# Install necessary packages to build ppsspp
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    libgl1-mesa-dev \
    libsdl2-dev \
    build-essential \
    cmake \
    libgl1-mesa-dev \
    libsdl2-dev \
    libvulkan-dev 

# Set execution permission for build script & build the current source
RUN chmod +rx ./b.sh && ./b.sh

# Install Virtual Framebuffer (runs app with a virtual display)
RUN apt install -y xvfb

# Add a user (to enable saving configuration files, as /root is not accessible)
RUN useradd -ms /bin/bash user

# Copy source directory to container
COPY ./ ./

# Set execution permission for entrypoint script
RUN chmod +rx ./entrypoint.sh

# Setting permissions for home dir
RUN chmod -R ugo+rwx /root/

# Creating stuff ppsspp fails to create itself and more (GAME, ISO, ...)
RUN mkdir -p "/root/.config/ppsspp/PSP/GAME"
RUN mkdir -p "/root/.config/ppsspp/PSP/SYSTEM"

RUN touch "/root/.config/ppsspp/PSP/SYSTEM/controls.ini"
RUN touch "/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"

# # Create a fresh ppsspp.ini with necessery settings
# RUN echo "[General]\n \
#     FirstRun = False\n \
#     RunCount = 1337\n \
#     Enable Logging = True\n \
#     AutoRun = True\n \
#     IgnoreBadMemAccess = True\n \
#     CacheFullIsoInRam = False\n \
#     RemoteISOPort = 8300\n \
#     LastRemoteISOServer = localhost\n \
#     LastRemoteISOPort = 8300\n \
#     RemoteISOManualConfig = True\n \
#     RemoteShareOnStartup = True\n \
#     RemoteISOSubdir = /\n \
#     RemoteDebuggerOnStartup = False\n \
#     PauseOnLostFocus = False\n \
#     PauseWhenMinimized = False\n \
#     [SystemParam]\n \
#     PSPModel = 1\n \
#     PSPFirmwareVersion = 660\n \
#     NickName = PPSSPP - Docker Server\n \
#     WlanPowerSave = False\n \
#     [Recent]\n \
#     MaxRecent = 1000\n \
#     " >"/root/.config/ppsspp/PSP/SYSTEM/ppsspp.ini"

# Expose PPSSPP server port for remote disc streaming
EXPOSE 8300

# Start the application
CMD ["/usr/src/app/entrypoint.sh"]