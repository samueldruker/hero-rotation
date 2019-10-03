REM Modify the two vars so it match you own setup. Make sure you have it surrounded by double quotes
REM WoWRep  : World of warcraft main directory
REM GHRep   : Where your github projects are stored (by default in Documents/GitHub)
set WoWRep=c:\bin\World of Warcraft
set GHRep=C:\src
set rboptions=%rboptions% /NDL /nfl /NJH /NJS /np

REM Don't touch anything bellow this if you aren't experienced

robocopy %rboptions% "%GHRep%"\hero-lib\HeroLib "%WoWRep%"\_retail_\Interface\AddOns\HeroLib
robocopy %rboptions% "%GHRep%"\hero-lib\HeroCache "%WoWRep%"\_retail_\Interface\AddOns\HeroCache
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_DeathKnight "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_DeathKnight
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_DemonHunter "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_DemonHunter
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Druid "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Druid
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Hunter "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Hunter
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Mage "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Mage
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Monk "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Monk
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Paladin "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Paladin
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Priest "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Priest
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Rogue "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Rogue
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Shaman "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Shaman
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Warrior "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Warrior
robocopy %rboptions% "%GHRep%"\hero-rotation\HeroRotation_Warlock "%WoWRep%"\_retail_\Interface\AddOns\HeroRotation_Warlock
REM robocopy %rboptions%"%GHRep%"\AethysTools "%WoWRep%"\_retail_\Interface\AddOns\AethysTools

pause
