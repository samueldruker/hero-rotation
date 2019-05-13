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
  local SpellElemental   = Spell.Shaman.Elemental;
  local SpellEnhance     = Spell.Shaman.Enhancement;
-- Lua

--- ============================ CONTENT ============================
-- Elemental, ID: 262
local OldEleIsCastableP
OldEleIsCastableP = HL.AddCoreOverride("Spell.IsCastableP",
function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  local BaseCheck = OldEleIsCastableP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
  if self == SpellElemental.TotemMastery then
    return BaseCheck and (not Player:BuffP(SpellElemental.ResonanceTotemBuff))
  else
    return BaseCheck
  end
end
, 262);

-- Enhancement, ID: 263

-- Restoration, ID: 264

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
