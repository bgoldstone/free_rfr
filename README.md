# free_rfr

A new RFR for ETC Eos-based consoles using OSC Communication

[![Flutter Build](https://github.com/bgoldstone/free_rfr/actions/workflows/flutter_build.yml/badge.svg?branch=main)](https://github.com/bgoldstone/free_rfr/actions/workflows/flutter_build.yml)

> **Warning**  
> This project is under active development and breaking changes are likely. Use at your own risk!
# Flutter Version
Current Flutter Version: 3.24.3

## Hot Keys
Most of the hotkeys are mapped to eos hotkeys which are found [here](https://www.etcconnect.com/webdocs/Controls/EosFamilyOnlineHelp/en-us/Content/03_System_Basics/Keyboard_Shortcuts.htm).

The exception is the <ins>**home**</ins> key for page left and <ins>**end**</ins> key for page right

## Requirements
I have gotten this to work on Eos v3.2, but could work on versions earlier. 

This uses UDP protocol, so the port must be configured properly. See [Getting Started](#getting-started)

## Getting Started
1. Please set up these settings on your console and ensure everything in the red box is configured as in the screenshot.
2. These settings can be found in the Browser -> System Settings -> System -> Show Control -> OSC Tab (Should default to 3032 by default though)
<img width="1472" height="556" alt="image" src="https://github.com/user-attachments/assets/955dad94-2bf4-4b46-bf06-e50866445910" />
3. Put in a Friendly name to remember your Eos Console by
4. To find the IP address of your console, you can select the 'About' key on your eos console. the IP Addresses are located here:
![free_rfr-ip-address](https://github.com/bgoldstone/free_rfr/assets/23127820/36fd53ee-67c9-4740-a2d0-4c08384eb330)

## Screenshots
<img src="https://github.com/bgoldstone/free_rfr/assets/23127820/63fdc059-54ce-4481-b2ad-62aa6ede3edb" alt="free_rfr_1" width=150/>
<img src="https://github.com/bgoldstone/free_rfr/assets/23127820/92c6b8e9-7101-4aee-b4b8-083855689b17" alt="free_rfr_2" width=150/>
<img src="https://github.com/bgoldstone/free_rfr/assets/23127820/5b0c235d-ee3a-4404-82b6-f66a6d0668a5" alt="free_rfr_3" width=150/>
<img src="https://github.com/bgoldstone/free_rfr/assets/23127820/aca7f33f-9639-448a-9fc0-5cb5732bc697" alt="free_rfr_4" width=150/>
<img src="https://github.com/bgoldstone/free_rfr/assets/23127820/1b865f12-ba8f-4083-b6a4-80bb3b9d6b80" alt="free_rfr_5" width=150/>
<img src="https://github.com/bgoldstone/free_rfr/assets/23127820/2fadac4d-a748-49d1-a430-908479da23df" alt="free_rfr_6" width=150/>
