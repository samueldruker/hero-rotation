--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...;
-- HeroRotation
local HR = HeroRotation;
-- HeroLib
local HL = HeroLib;
-- File Locals
local GUI = HL.GUI;
local CreateChildPanel = GUI.CreateChildPanel;
local CreatePanelOption = GUI.CreatePanelOption;
local CreateARPanelOption = HR.GUI.CreateARPanelOption;
local CreateARPanelOptions = HR.GUI.CreateARPanelOptions;

--- ============================ CONTENT ============================
-- All settings here should be moved into the GUI someday.
HR.GUISettings.APL.Priest = {
  Commons = {
    UseTrinkets = true,
    UsePotions = true,
    TrinketDisplayStyle = "Suggested",
    EssenceDisplayStyle = "Suggested",
    GCDasOffGCD = {
      -- Abilities
    },
    OffGCDasOffGCD = {
      -- Racials
      Racials = true,
      -- Abilities
      Silence = true,
    }
  },
  Shadow = {
    DispersionHP = 10,
    MindbenderUsage = 0,
    UseSplashData = true,
    -- {Display GCD as OffGCD, ForceReturn}
    GCDasOffGCD = {
      -- Abilities
      Mindbender = true,
      Shadowform = true,
      VoidEruption = true,
    },
    -- {Display OffGCD as OffGCD, ForceReturn}
    OffGCDasOffGCD = {
      -- Abilities
      Dispersion = true,
      SurrenderToMadness = true,
      -- Items
    }
  },
};

HR.GUI.LoadSettingsRecursively(HR.GUISettings);

-- Child Panels
local ARPanel = HR.GUI.Panel;
local CP_Priest = CreateChildPanel(ARPanel, "Priest");
local CP_Shadow = CreateChildPanel(CP_Priest, "Shadow");

CreateARPanelOptions(CP_Priest, "APL.Priest.Commons");
CreatePanelOption("CheckButton", CP_Priest, "APL.Priest.Commons.UsePotions", "Show Potions", "Enable this if you want the addon to show you when to use potions.");
CreatePanelOption("CheckButton", CP_Priest, "APL.Priest.Commons.UseTrinkets", "Use Trinkets", "Use Trinkets as part of the rotation");
CreatePanelOption("Dropdown", CP_Priest, "APL.Priest.Commons.TrinketDisplayStyle", {"Main Icon", "Suggested", "Cooldown"}, "Trinket Display Style", "Define which icon display style to use for Trinkets.");
CreatePanelOption("Dropdown", CP_Priest, "APL.Priest.Commons.EssenceDisplayStyle", {"Main Icon", "Suggested", "Cooldown"}, "Essence Display Style", "Define which icon display style to use for active Azerite Essences.");

CreatePanelOption("Slider", CP_Shadow, "APL.Priest.Shadow.DispersionHP", {0, 100, 1}, "Dispersion HP", "Set the Dispersion HP threshold.");
CreatePanelOption("CheckButton", CP_Shadow, "APL.Priest.Shadow.UseSplashData", "Use Splash Data for AoE", "Only count AoE enemies that are already hit by AoE abilities.");
CreateARPanelOptions(CP_Shadow, "APL.Priest.Shadow");
CreatePanelOption("Slider", CP_Shadow, "APL.Priest.Shadow.MindbenderUsage", {0, 30, 1}, "Shadowfiend/Mindbender usage Offset", "Number of vf stacks MB/SF will be delayed that you can push");