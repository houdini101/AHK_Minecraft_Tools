# AHK Minecraft Tools
> A simple AutoHotkey script created for Minecraft.

------------

### Features
- **AFK-Fishing** : Simply find a safe spot to fish, and let the script do the rest. What it differs from other AFK Fishing script is it's efficiency. It will automatically reel-in the rod **only if it caught something** and quickly cast it again. It also gives a report on how many fish/items you acquired and the elapsed time in HH:MM:SS format.

- **Auto-Sweep Attack** : Running a mob spawning farm that requires you to attack the mobs for exp while AFK? This is answer for you. (see Limitations and Known Bugs for additional info.)

- **Nether Portal Calculator** : No need to go online for Portal Calculators and typing in your coordinates in order to know your Nether Portal coordinates. This script does all the work in-game. Calculates coordinate in Overworld >> Nether and vice-versa.

------------

### Controls
- **Alt + C** : Toggle Auto-Fishing
- **Alt + V** : Toggle Auto-Sweep Attack
- **Alt + Z** : Nether Portal Calculator

------------

### Important Reminders
1. AutoHotkey must be installed before using this script, duh!
2. This Script only works for the following window size: 1280 x 720.
3. Caption (subtitle) must be turned ON in Minecraft's setting.
4. Gui scale must be set to 2 in Minecraft's setting.
5. Attack Indicator must be set to Crosshair in Minecraft's setting.
6. A good item hopper setup is essential for AFK-Fishing.
7. Works for all applicable Minecraft versions up to the latest version.

------------

### Limitations and Known Bugs
1. Auto-Sweep Attack only triggers when there's a **Sword Icon** below the crosshair (Attack Indicator setting is set to Crosshair) and works best when pointed at dark-colored mobs. Pointing the crosshair on light-colors (e.g. white, yellow etc.) will trigger the Auto-Sweep Attack continuously. The Sword Icon visibility is essential for it to work.

------------

### Credits

Thanks to [just me] for simplifying SKAN's work and created Image2Include.ahk
> Image2Include.ahk was used for converting image files to HBitmap. 
> https://www.autohotkey.com/board/topic/93292-image2include-include-images-in-your-scripts/
------------
Thanks to SKAN for creating a wonderful script.
> Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
