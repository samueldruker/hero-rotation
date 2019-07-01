--- ============================ HEADER ============================
  -- HeroLib
  local HL      = HeroLib;
  local Cache   = HeroCache;
  local Unit    = HL.Unit;
  local Player  = Unit.Player;
  local Pet     = Unit.Pet;
  local Target  = Unit.Target;
  local Spell   = HL.Spell;
  local Item    = HL.Item;
-- HeroRotation
  local HR      = HeroRotation;
-- Spells
  local SpellBM = Spell.Hunter.BeastMastery;
  local SpellMM = Spell.Hunter.Marksmanship;
  local SpellSV = Spell.Hunter.Survival;
-- Lua

--- ============================ CONTENT ============================
-- Beast Mastery, ID: 253
local OldBMIsCastableP
OldBMIsCastableP = HL.AddCoreOverride("Spell.IsCastableP",
function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  local BaseCheck = OldBMIsCastableP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  if self == SpellBM.SummonPet then
    return (not Pet:IsActive()) and BaseCheck
  else
    return BaseCheck
  end
end
, 253);

-- Marksmanship, ID: 254
local OldMMIsCastableP
OldMMIsCastableP = HL.AddCoreOverride("Spell.IsCastableP",
function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  local BaseCheck = OldMMIsCastableP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  if self == SpellMM.SummonPet then
    return (not Pet:IsActive() and not HR.GUISettings.APL.Hunter.Marksmanship.UseLoneWolf) and BaseCheck
  else
    return BaseCheck
  end
end
, 254);

local OldMMIsReadyP
OldMMIsReadyP = HL.AddCoreOverride("Spell.IsReadyP",
function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  local BaseCheck = OldMMIsReadyP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  if self == SpellMM.AimedShot then
    return BaseCheck and (not Player:IsCasting(SpellMM.AimedShot))
  else
    return BaseCheck
  end
end
, 254);

-- Survival, ID: 255
local OldSVIsCastableP
OldSVIsCastableP = HL.AddCoreOverride("Spell.IsCastableP",
function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  if self.SpellID == 259387 or self.SpellID == 186270 then
    return OldSVIsCastableP(self, "Melee", AoESpell, ThisUnit, BypassRecovery, Offset)
  else
    local BaseCheck = OldSVIsCastableP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
    if self == SpellSV.SummonPet then
      return (not Pet:IsActive()) and BaseCheck
    elseif self == SpellSV.AspectoftheEagle then
      return HR.GUISettings.APL.Hunter.Survival.AspectoftheEagle and BaseCheck
    else
      return BaseCheck
    end
  end
end
, 255);

-- Example (Arcane Mage)
-- HL.AddCoreOverride ("Spell.IsCastableP",
-- function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
--   if Range then
--     local RangeUnit = ThisUnit or Target;
--     return self:IsLearned() and self:CooldownRemainsP( BypassRecovery, Offset or "Auto") == 0 and RangeUnit:IsInRange( Range, AoESpell );
--   elseif self == SpellArcane.MarkofAluneth then
--     return self:IsLearned() and self:CooldownRemainsP( BypassRecovery, Offset or "Auto") == 0 and not Player:IsCasting(self);
--   else
--     return self:IsLearned() and self:CooldownRemainsP( BypassRecovery, Offset or "Auto") == 0;
--   end;
-- end
-- , 62);
