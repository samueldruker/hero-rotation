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
  local SpellProtection  = Spell.Paladin.Protection;
  local SpellRetribution = Spell.Paladin.Retribution;
-- Lua

--- ============================ CONTENT ============================
-- Holy, ID: 65

-- Protection, ID: 66

-- Retribution, ID: 70
  local RetOldSpellIsCastableP
  RetOldSpellIsCastableP = HL.AddCoreOverride ("Spell.IsCastableP",
    function (self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
      local BaseCheck = RetOldSpellIsCastableP(self, Range, AoESpell, ThisUnit, BypassRecovery, Offset)
      if self == SpellRetribution.HammerofWrath then
        return BaseCheck and self:IsUsable()
      elseif self == SpellRetribution.AvengingWrath or self == SpellRetribution.Crusade then
        return BaseCheck and HR.CDsON()
      else
        return BaseCheck
      end
    end
  , 70);

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
