--- ============================ HEADER ============================
--- ======= LOCALIZE =======
  -- Addon
local addonName, addonTable = ...
-- HeroRotation
local HR = HeroRotation

local HL = HeroLib
-- File Locals
local GUI = HL.GUI
local CreateChildPanel = GUI.CreateChildPanel
local CreatePanelOption = GUI.CreatePanelOption
local CreateARPanelOption = HR.GUI.CreateARPanelOption
local CreateARPanelOptions = HR.GUI.CreateARPanelOptions

--- ============================ CONTENT ============================
-- All settings here should be moved into the GUI someday.
HR.GUISettings.APL.DemonHunter = {
  Commons = {
    UsePotions  = true,
    UseTrinkets = true,
    TrinketDisplayStyle = "Suggested",
    EssenceDisplayStyle = "Suggested",
    CovenantDisplayStyle = "Suggested",
    -- {Display OffGCD as OffGCD, ForceReturn}
    OffGCDasOffGCD = {
      Racials = true,
      -- Abilities
      Disrupt = true,
    },
  },
  Vengeance = {
    MetamorphosisHealthThreshold = 50,
    FieryBrandHealthThreshold = 40,
    DemonSpikesHealthThreshold = 65,
    BrandForDamage = false,
    OffensiveSinfulBrand = false,
    ConserveInfernalStrike = true,
    -- {Display OffGCD as OffGCD, ForceReturn}
    OffGCDasOffGCD = {
      -- Abilities
      DemonSpikes = true,
      InfernalStrike = false,
      FieryBrand = false,
    },
    GCDasOffGCD = {
      FelDevastation = true,
    }
  },
  Havoc = {
    FelRushDisplayStyle = "Main Icon",
    UseFABST = false,
    -- {Display OffGCD as OffGCD, ForceReturn}
    OffGCDasOffGCD = {
      -- Abilities
      VengefulRetreat = true,
    },
    GCDasOffGCD = {
      -- Abilities
      Metamorphosis = true,
      EyeBeam = false,
      GlaiveTempest = false,
      ThrowGlaive = false,
    },
  }
}

  HR.GUI.LoadSettingsRecursively(HR.GUISettings)
  local ARPanel = HR.GUI.Panel
  local CP_DemonHunter = CreateChildPanel(ARPanel, "DemonHunter")
  local CP_Havoc = CreateChildPanel(CP_DemonHunter, "Havoc")
  local CP_Vengeance = CreateChildPanel(CP_DemonHunter, "Vengeance")

CreateARPanelOptions(CP_DemonHunter, "APL.DemonHunter.Commons")
CreatePanelOption("CheckButton", CP_DemonHunter, "APL.DemonHunter.Commons.UsePotions", "Use Potions", "Use Potions as part of the rotation")
CreatePanelOption("CheckButton", CP_DemonHunter, "APL.DemonHunter.Commons.UseTrinkets", "Use Trinkets", "Use Trinkets as part of the rotation")
CreatePanelOption("Dropdown", CP_DemonHunter, "APL.DemonHunter.Commons.TrinketDisplayStyle", {"Main Icon", "Suggested", "Cooldown"}, "Trinket Display Style", "Define which icon display style to use for Trinkets.")
CreatePanelOption("Dropdown", CP_DemonHunter, "APL.DemonHunter.Commons.EssenceDisplayStyle", {"Main Icon", "Suggested", "Cooldown"}, "Essence Display Style", "Define which icon display style to use for active Azerite Essences.")
CreatePanelOption("Dropdown", CP_DemonHunter, "APL.DemonHunter.Commons.CovenantDisplayStyle", {"Main Icon", "Suggested", "Cooldown"}, "Covenant Display Style", "Define which icon display style to use for active Shadowlands Covenant Abilities.")

CreatePanelOption("Slider", CP_Vengeance, "APL.DemonHunter.Vengeance.MetamorphosisHealthThreshold", {5, 100, 5}, "Metamorphosis Health Threshold", "Suggest Metamorphosis when below this health percentage.")
CreatePanelOption("Slider", CP_Vengeance, "APL.DemonHunter.Vengeance.FieryBrandHealthThreshold", {5, 100, 5}, "Fiery Brand Health Threshold", "Suggest Fiery Brand when below this health percentage.")
CreatePanelOption("Slider", CP_Vengeance, "APL.DemonHunter.Vengeance.DemonSpikesHealthThreshold", {5, 100, 5}, "Demon Spikes Health Threshold", "Suggest Demon Spikes when below this health percentage.")
CreatePanelOption("CheckButton", CP_Vengeance, "APL.DemonHunter.Vengeance.BrandForDamage", "Fiery Brand for DPS", "Use Fiery Brand as a DPS ability, rather than saving it for defensive use.")
CreatePanelOption("CheckButton", CP_Vengeance, "APL.DemonHunter.Vengeance.ConserveInfernalStrike", "Conserve Infernal Strike", "Save at least 1 Infernal Strike charge for mobility.")
CreateARPanelOptions(CP_Vengeance, "APL.DemonHunter.Vengeance")

CreatePanelOption("Dropdown", CP_Havoc, "APL.DemonHunter.Havoc.FelRushDisplayStyle", {"Main Icon", "Suggested", "Cooldown"}, "Fel Rush Display Style", "Define which icon display style to use for Fel Rush.")
CreatePanelOption("CheckButton", CP_Havoc, "APL.DemonHunter.Havoc.UseFABST", "Use Focused Azerite Beam ST", "Suggest Focused Azerite Beam usage during single target combat.")
CreatePanelOption("CheckButton", CP_Havoc, "APL.DemonHunter.Havoc.ConserveFelRush", "Conserve Fel Rush", "Save at least 1 Fel Rush charge for mobility.")
CreateARPanelOptions(CP_Havoc, "APL.DemonHunter.Havoc")
