--- ============================ HEADER ============================
--- ======= LOCALIZE =======
-- Addon
local addonName, addonTable = ...
-- HeroLib
local HL     = HeroLib
local Cache  = HeroCache
local Unit   = HL.Unit
local Player = Unit.Player
local Target = Unit.Target
local Pet    = Unit.Pet
local Spell  = HL.Spell
local Item   = HL.Item
-- HeroRotation
local HR     = HeroRotation

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
if not Spell.Druid then Spell.Druid = {} end
Spell.Druid.Feral = {
  Regrowth                              = Spell(8936),
  BloodtalonsBuff                       = Spell(145152),
  Bloodtalons                           = Spell(155672),
  WildFleshrending                      = Spell(279527),
  CatFormBuff                           = Spell(768),
  CatForm                               = Spell(768),
  ProwlBuff                             = Spell(5215),
  Prowl                                 = Spell(5215),
  BerserkBuff                           = Spell(106951),
  Berserk                               = Spell(106951),
  TigersFury                            = Spell(5217),
  TigersFuryBuff                        = Spell(5217),
  Berserking                            = Spell(26297),
  FeralFrenzy                           = Spell(274837),
  Incarnation                           = Spell(102543),
  IncarnationBuff                       = Spell(102543),
  Shadowmeld                            = Spell(58984),
  Rake                                  = Spell(1822),
  RakeDebuff                            = Spell(155722),
  SavageRoar                            = Spell(52610),
  PoolResource                          = Spell(9999000010),
  SavageRoarBuff                        = Spell(52610),
  PrimalWrath                           = Spell(285381),
  RipDebuff                             = Spell(1079),
  Rip                                   = Spell(1079),
  Sabertooth                            = Spell(202031),
  Maim                                  = Spell(22570),
  IronJawsBuff                          = Spell(276026),
  FerociousBiteMaxEnergy                = Spell(22568),
  FerociousBite                         = Spell(22568),
  PredatorySwiftnessBuff                = Spell(69369),
  LunarInspiration                      = Spell(155580),
  BrutalSlash                           = Spell(202028),
  ThrashCat                             = Spell(106830),
  ThrashCatDebuff                       = Spell(106830),
  ScentofBlood                          = Spell(285564),
  ScentofBloodBuff                      = Spell(285646),
  SwipeCat                              = Spell(106785),
  MoonfireCat                           = Spell(155625),
  MoonfireCatDebuff                     = Spell(155625),
  ClearcastingBuff                      = Spell(135700),
  Shred                                 = Spell(5221),
  ShadowmeldBuff                        = Spell(58984)
};
local S = Spell.Druid.Feral;

-- Items
if not Item.Druid then Item.Druid = {} end
Item.Druid.Feral = {
  BattlePotionofAgility            = Item(163223)
};
local I = Item.Druid.Feral;

-- Rotation Var
local ShouldReturn; -- Used to get the return string

-- GUI Settings
local Everyone = HR.Commons.Everyone;
local Settings = {
  General = HR.GUISettings.General,
  Commons = HR.GUISettings.APL.Druid.Commons,
  Feral = HR.GUISettings.APL.Druid.Feral
};

-- Variables
local VarUseThrash = 0;
local VarOpenerDone = 0;

HL:RegisterForEvent(function()
  VarUseThrash = 0
  VarOpenerDone = 0
end, "PLAYER_REGEN_ENABLED")

local EnemyRanges = {8, 5}
local function UpdateRanges()
  for _, i in ipairs(EnemyRanges) do
    HL.GetEnemies(i);
  end
end


local function num(val)
  if val then return 1 else return 0 end
end

local function bool(val)
  return val ~= 0
end

S.FerociousBiteMaxEnergy.CustomCost = {
  [3] = function ()
          if (Player:BuffP(S.IncarnationBuff) or Player:BuffP(S.BerserkBuff)) then return 25
          else return 50
          end
        end
}

S.Rip:RegisterPMultiplier({S.BloodtalonsBuff, 1.2}, {S.SavageRoar, 1.15}, {S.TigersFury, 1.15})
S.Rake:RegisterPMultiplier(
  S.RakeDebuff,
  {function ()
    return Player:IsStealthed(true, true) and 2 or 1;
  end},
  {S.BloodtalonsBuff, 1.2}, {S.SavageRoar, 1.15}, {S.TigersFury, 1.15}
)

local function EvaluateCyclePrimalWrath95(TargetUnit)
  return Cache.EnemiesCount[5] > 1 and TargetUnit:DebuffRemainsP(S.RipDebuff) < 4
end

local function EvaluateCyclePrimalWrath106(TargetUnit)
  return Cache.EnemiesCount[5] >= 2
end

local function EvaluateCycleRip115(TargetUnit)
  return not TargetUnit:DebuffP(S.RipDebuff) or (TargetUnit:DebuffRemainsP(S.RipDebuff) <= S.RipDebuff:BaseDuration() * 0.3) and (not S.Sabertooth:IsAvailable()) or (TargetUnit:DebuffRemainsP(S.RipDebuff) <= S.RipDebuff:BaseDuration() * 0.8 and Player:PMultiplier(S.Rip) > TargetUnit:PMultiplier(S.Rip)) and TargetUnit:TimeToDie() > 8
end

local function EvaluateCycleRake228(TargetUnit)
  return not TargetUnit:DebuffP(S.RakeDebuff) or (not S.Bloodtalons:IsAvailable() and TargetUnit:DebuffRemainsP(S.RakeDebuff) < S.RakeDebuff:BaseDuration() * 0.3) and TargetUnit:TimeToDie() > 4
end

local function EvaluateCycleRake257(TargetUnit)
  return S.Bloodtalons:IsAvailable() and Player:BuffP(S.BloodtalonsBuff) and ((TargetUnit:DebuffRemainsP(S.RakeDebuff) <= 7) and Player:PMultiplier(S.Rake) > TargetUnit:PMultiplier(S.Rake) * 0.85) and TargetUnit:TimeToDie() > 4
end

local function EvaluateCycleMoonfireCat302(TargetUnit)
  return TargetUnit:DebuffRefreshableCP(S.MoonfireCatDebuff)
end

local function EvaluateCycleFerociousBite418(TargetUnit)
  return TargetUnit:DebuffP(S.RipDebuff) and TargetUnit:DebuffRemainsP(S.RipDebuff) < 3 and TargetUnit:TimeToDie() > 10 and (S.Sabertooth:IsAvailable())
end
--- ======= ACTION LISTS =======
local function APL()
  local Precombat, Cooldowns, Finishers, Generators, Opener
  UpdateRanges()
  Everyone.AoEToggleEnemiesUpdate()
  Precombat = function()
    -- flask
    -- food
    -- augmentation
    -- regrowth,if=talent.bloodtalons.enabled
    if S.Regrowth:IsCastableP() and (S.Bloodtalons:IsAvailable()) then
      if HR.Cast(S.Regrowth) then return "regrowth 3"; end
    end
    -- variable,name=use_thrash,value=0
    if (true) then
      VarUseThrash = 0
    end
    -- variable,name=use_thrash,value=2,if=azerite.wild_fleshrending.enabled
    if (S.WildFleshrending:AzeriteEnabled()) then
      VarUseThrash = 2
    end
    -- cat_form
    if S.CatForm:IsCastableP() and Player:BuffDownP(S.CatFormBuff) then
      if HR.Cast(S.CatForm, Settings.Feral.GCDasOffGCD.CatForm) then return "cat_form 15"; end
    end
    -- prowl
    if S.Prowl:IsCastableP() and Player:BuffDownP(S.ProwlBuff) then
      if HR.Cast(S.Prowl, Settings.Feral.OffGCDasOffGCD.Prowl) then return "prowl 19"; end
    end
    -- snapshot_stats
    -- potion
    if I.BattlePotionofAgility:IsReady() and Settings.Commons.UsePotions then
      if HR.CastSuggested(I.BattlePotionofAgility) then return "battle_potion_of_agility 24"; end
    end
    -- berserk
    if S.Berserk:IsCastableP() and Player:BuffDownP(S.BerserkBuff) and HR.CDsON() then
      if HR.Cast(S.Berserk, Settings.Feral.OffGCDasOffGCD.Berserk) then return "berserk 26"; end
    end
  end
  Cooldowns = function()
    -- berserk,if=energy>=30&(cooldown.tigers_fury.remains>5|buff.tigers_fury.up)
    if S.Berserk:IsCastableP() and HR.CDsON() and (Player:EnergyPredicted() >= 30 and (S.TigersFury:CooldownRemainsP() > 5 or Player:BuffP(S.TigersFuryBuff))) then
      if HR.Cast(S.Berserk, Settings.Feral.OffGCDasOffGCD.Berserk) then return "berserk 30"; end
    end
    -- tigers_fury,if=energy.deficit>=60
    if S.TigersFury:IsCastableP() and (Player:EnergyDeficitPredicted() >= 60) then
      if HR.Cast(S.TigersFury, Settings.Feral.OffGCDasOffGCD.TigersFury) then return "tigers_fury 36"; end
    end
    -- berserking
    if S.Berserking:IsCastableP() and HR.CDsON() then
      if HR.Cast(S.Berserking, Settings.Commons.OffGCDasOffGCD.Racials) then return "berserking 38"; end
    end
    -- feral_frenzy,if=combo_points=0
    if S.FeralFrenzy:IsCastableP() and (Player:ComboPoints() == 0) then
      if HR.Cast(S.FeralFrenzy) then return "feral_frenzy 40"; end
    end
    -- incarnation,if=energy>=30&(cooldown.tigers_fury.remains>15|buff.tigers_fury.up)
    if S.Incarnation:IsCastableP() and HR.CDsON() and (Player:EnergyPredicted() >= 30 and (S.TigersFury:CooldownRemainsP() > 15 or Player:BuffP(S.TigersFuryBuff))) then
      if HR.Cast(S.Incarnation, Settings.Feral.OffGCDasOffGCD.Incarnation) then return "incarnation 42"; end
    end
    -- potion,name=battle_potion_of_agility,if=target.time_to_die<65|(time_to_die<180&(buff.berserk.up|buff.incarnation.up))
    if I.BattlePotionofAgility:IsReady() and Settings.Commons.UsePotions and (Target:TimeToDie() < 65 or (Target:TimeToDie() < 180 and (Player:BuffP(S.BerserkBuff) or Player:BuffP(S.IncarnationBuff)))) then
      if HR.CastSuggested(I.BattlePotionofAgility) then return "battle_potion_of_agility 48"; end
    end
    -- shadowmeld,if=combo_points<5&energy>=action.rake.cost&dot.rake.pmultiplier<2.1&buff.tigers_fury.up&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>18)&!buff.incarnation.up
    if S.Shadowmeld:IsCastableP() and HR.CDsON() and (Player:ComboPoints() < 5 and Player:EnergyPredicted() >= S.Rake:Cost() and Target:PMultiplier(S.Rake) < 2.1 and Player:BuffP(S.TigersFuryBuff) and (Player:BuffP(S.BloodtalonsBuff) or not S.Bloodtalons:IsAvailable()) and (not S.Incarnation:IsAvailable() or S.Incarnation:CooldownRemainsP() > 18) and not Player:BuffP(S.IncarnationBuff)) then
      if HR.Cast(S.Shadowmeld, Settings.Commons.OffGCDasOffGCD.Racials) then return "shadowmeld 58"; end
    end
    -- use_items
  end
  Finishers = function()
    -- pool_resource,for_next=1
    -- savage_roar,if=buff.savage_roar.down
    if S.SavageRoar:IsCastableP() and (Player:BuffDownP(S.SavageRoarBuff)) then
      if S.SavageRoar:IsUsablePPool() then
        if HR.Cast(S.SavageRoar) then return "savage_roar 84"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 85"; end
      end
    end
    -- pool_resource,for_next=1
    -- primal_wrath,target_if=spell_targets.primal_wrath>1&dot.rip.remains<4
    if S.PrimalWrath:IsCastableP() then
      if HR.CastCycle(S.PrimalWrath, 8, EvaluateCyclePrimalWrath95) then return "primal_wrath 99" end
    end
    -- pool_resource,for_next=1
    -- primal_wrath,target_if=spell_targets.primal_wrath>=2
    if S.PrimalWrath:IsCastableP() then
      if HR.CastCycle(S.PrimalWrath, 8, EvaluateCyclePrimalWrath106) then return "primal_wrath 108" end
    end
    -- pool_resource,for_next=1
    -- rip,target_if=!ticking|(remains<=duration*0.3)&(!talent.sabertooth.enabled)|(remains<=duration*0.8&persistent_multiplier>dot.rip.pmultiplier)&target.time_to_die>8
    if S.Rip:IsCastableP() then
      if HR.CastCycle(S.Rip, 8, EvaluateCycleRip115) then return "rip 155" end
    end
    -- pool_resource,for_next=1
    -- savage_roar,if=buff.savage_roar.remains<12
    if S.SavageRoar:IsCastableP() and (Player:BuffRemainsP(S.SavageRoarBuff) < 12) then
      if S.SavageRoar:IsUsablePPool() then
        if HR.Cast(S.SavageRoar) then return "savage_roar 157"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 158"; end
      end
    end
    -- pool_resource,for_next=1
    -- maim,if=buff.iron_jaws.up
    if S.Maim:IsCastableP() and (Player:BuffP(S.IronJawsBuff)) then
      if S.Maim:IsUsablePPool() then
        if HR.Cast(S.Maim) then return "maim 163"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 164"; end
      end
    end
    -- ferocious_bite,max_energy=1
    if S.FerociousBiteMaxEnergy:IsCastableP() and S.FerociousBiteMaxEnergy:IsUsableP() then
      if HR.Cast(S.FerociousBiteMaxEnergy) then return "ferocious_bite 168"; end
    end
  end
  Generators = function()
    -- regrowth,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&buff.bloodtalons.down&combo_points=4&dot.rake.remains<4
    if S.Regrowth:IsCastableP() and (S.Bloodtalons:IsAvailable() and Player:BuffP(S.PredatorySwiftnessBuff) and Player:BuffDownP(S.BloodtalonsBuff) and Player:ComboPoints() == 4 and Target:DebuffRemainsP(S.RakeDebuff) < 4) then
      if HR.Cast(S.Regrowth) then return "regrowth 174"; end
    end
    -- regrowth,if=talent.bloodtalons.enabled&buff.bloodtalons.down&buff.predatory_swiftness.up&talent.lunar_inspiration.enabled&dot.rake.remains<1
    if S.Regrowth:IsCastableP() and (S.Bloodtalons:IsAvailable() and Player:BuffDownP(S.BloodtalonsBuff) and Player:BuffP(S.PredatorySwiftnessBuff) and S.LunarInspiration:IsAvailable() and Target:DebuffRemainsP(S.RakeDebuff) < 1) then
      if HR.Cast(S.Regrowth) then return "regrowth 184"; end
    end
    -- brutal_slash,if=spell_targets.brutal_slash>desired_targets
    if S.BrutalSlash:IsCastableP() and (Cache.EnemiesCount[8] > 1) then
      if HR.Cast(S.BrutalSlash) then return "brutal_slash 196"; end
    end
    -- pool_resource,for_next=1
    -- thrash_cat,if=(refreshable)&(spell_targets.thrash_cat>2)
    if S.ThrashCat:IsCastableP() and ((Target:DebuffRefreshableCP(S.ThrashCatDebuff)) and (Cache.EnemiesCount[8] > 2)) then
      if S.ThrashCat:IsUsablePPool() then
        if HR.Cast(S.ThrashCat) then return "thrash_cat 199"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 200"; end
      end
    end
    -- pool_resource,for_next=1
    -- thrash_cat,if=(talent.scent_of_blood.enabled&buff.scent_of_blood.down)&spell_targets.thrash_cat>3
    if S.ThrashCat:IsCastableP() and ((S.ScentofBlood:IsAvailable() and Player:BuffDownP(S.ScentofBloodBuff)) and Cache.EnemiesCount[8] > 3) then
      if S.ThrashCat:IsUsablePPool() then
        if HR.Cast(S.ThrashCat) then return "thrash_cat 209"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 210"; end
      end
    end
    -- pool_resource,for_next=1
    -- swipe_cat,if=buff.scent_of_blood.up
    if S.SwipeCat:IsCastableP() and (Player:BuffP(S.ScentofBloodBuff)) then
      if S.SwipeCat:IsUsablePPool() then
        if HR.Cast(S.SwipeCat) then return "swipe_cat 217"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 218"; end
      end
    end
    -- pool_resource,for_next=1
    -- rake,target_if=!ticking|(!talent.bloodtalons.enabled&remains<duration*0.3)&target.time_to_die>4
    if S.Rake:IsCastableP() then
      if HR.CastCycle(S.Rake, 8, EvaluateCycleRake228) then return "rake 250" end
    end
    -- pool_resource,for_next=1
    -- rake,target_if=talent.bloodtalons.enabled&buff.bloodtalons.up&((remains<=7)&persistent_multiplier>dot.rake.pmultiplier*0.85)&target.time_to_die>4
    if S.Rake:IsCastableP() then
      if HR.CastCycle(S.Rake, 8, EvaluateCycleRake257) then return "rake 275" end
    end
    -- moonfire_cat,if=buff.bloodtalons.up&buff.predatory_swiftness.down&combo_points<5
    if S.MoonfireCat:IsCastableP() and (Player:BuffP(S.BloodtalonsBuff) and Player:BuffDownP(S.PredatorySwiftnessBuff) and Player:ComboPoints() < 5) then
      if HR.Cast(S.MoonfireCat) then return "moonfire_cat 276"; end
    end
    -- brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))
    if S.BrutalSlash:IsCastableP() and ((Player:BuffP(S.TigersFuryBuff) and (10000000000 > (1 + S.BrutalSlash:MaxCharges() - S.BrutalSlash:ChargesFractionalP()) * S.BrutalSlash:RechargeP()))) then
      if HR.Cast(S.BrutalSlash) then return "brutal_slash 282"; end
    end
    -- moonfire_cat,target_if=refreshable
    if S.MoonfireCat:IsCastableP() then
      if HR.CastCycle(S.MoonfireCat, 40, EvaluateCycleMoonfireCat302) then return "moonfire_cat 310" end
    end
    -- pool_resource,for_next=1
    -- thrash_cat,if=refreshable&((variable.use_thrash=2&(!buff.incarnation.up|azerite.wild_fleshrending.enabled))|spell_targets.thrash_cat>1)
    if S.ThrashCat:IsCastableP() and (Target:DebuffRefreshableCP(S.ThrashCatDebuff) and ((VarUseThrash == 2 and (not Player:BuffP(S.IncarnationBuff) or S.WildFleshrending:AzeriteEnabled())) or Cache.EnemiesCount[8] > 1)) then
      if S.ThrashCat:IsUsablePPool() then
        if HR.Cast(S.ThrashCat) then return "thrash_cat 312"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 313"; end
      end
    end
    -- thrash_cat,if=refreshable&variable.use_thrash=1&buff.clearcasting.react&(!buff.incarnation.up|azerite.wild_fleshrending.enabled)
    if S.ThrashCat:IsCastableP() and (Target:DebuffRefreshableCP(S.ThrashCatDebuff) and VarUseThrash == 1 and bool(Player:BuffStackP(S.ClearcastingBuff)) and (not Player:BuffP(S.IncarnationBuff) or S.WildFleshrending:AzeriteEnabled())) then
      if HR.Cast(S.ThrashCat) then return "thrash_cat 327"; end
    end
    -- pool_resource,for_next=1
    -- swipe_cat,if=spell_targets.swipe_cat>1
    if S.SwipeCat:IsCastableP() and (Cache.EnemiesCount[8] > 1) then
      if S.SwipeCat:IsUsablePPool() then
        if HR.Cast(S.SwipeCat) then return "swipe_cat 344"; end
      else
        if HR.Cast(S.PoolResource) then return "pool_resource 345"; end
      end
    end
    -- shred,if=dot.rake.remains>(action.shred.cost+action.rake.cost-energy)%energy.regen|buff.clearcasting.react
    if S.Shred:IsCastableP() and (Target:DebuffRemainsP(S.RakeDebuff) > (S.Shred:Cost() + S.Rake:Cost() - Player:EnergyPredicted()) / Player:EnergyRegen() or bool(Player:BuffStackP(S.ClearcastingBuff))) then
      if HR.Cast(S.Shred) then return "shred 347"; end
    end
  end
  Opener = function()
    -- tigers_fury
    if S.TigersFury:IsCastableP() then
      if HR.Cast(S.TigersFury, Settings.Feral.OffGCDasOffGCD.TigersFury) then return "tigers_fury 363"; end
    end
    -- rake,if=!ticking|buff.prowl.up
    if S.Rake:IsCastableP() and (not Target:DebuffP(S.RakeDebuff) or Player:BuffP(S.ProwlBuff)) then
      if HR.Cast(S.Rake) then return "rake 365"; end
    end
    -- variable,name=opener_done,value=dot.rip.ticking
    if (true) then
      VarOpenerDone = num(Target:DebuffP(S.RipDebuff))
    end
    -- wait,sec=0.001,if=dot.rip.ticking
    -- moonfire_cat,if=!ticking
    if S.MoonfireCat:IsCastableP() and (not Target:DebuffP(S.MoonfireCatDebuff)) then
      if HR.Cast(S.MoonfireCat) then return "moonfire_cat 380"; end
    end
    -- rip,if=!ticking
    if S.Rip:IsCastableP() and (not Target:DebuffP(S.RipDebuff)) then
      if HR.Cast(S.Rip) then return "rip 388"; end
    end
  end
  -- call precombat
  if not Player:AffectingCombat() then
    local ShouldReturn = Precombat(); if ShouldReturn then return ShouldReturn; end
  end
  if Everyone.TargetIsValid() then
    -- auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
    -- run_action_list,name=opener,if=variable.opener_done=0
    if (VarOpenerDone == 0) then
      return Opener();
    end
    -- cat_form,if=!buff.cat_form.up
    if S.CatForm:IsCastableP() and (not Player:BuffP(S.CatFormBuff)) then
      if HR.Cast(S.CatForm, Settings.Feral.GCDasOffGCD.CatForm) then return "cat_form 402"; end
    end
    -- rake,if=buff.prowl.up|buff.shadowmeld.up
    if S.Rake:IsCastableP() and (Player:BuffP(S.ProwlBuff) or Player:BuffP(S.ShadowmeldBuff)) then
      if HR.Cast(S.Rake) then return "rake 406"; end
    end
    -- call_action_list,name=cooldowns
    if (true) then
      local ShouldReturn = Cooldowns(); if ShouldReturn then return ShouldReturn; end
    end
    -- ferocious_bite,target_if=dot.rip.ticking&dot.rip.remains<3&target.time_to_die>10&(talent.sabertooth.enabled)
    if S.FerociousBite:IsCastableP() then
      if HR.CastCycle(S.FerociousBite, 8, EvaluateCycleFerociousBite418) then return "ferocious_bite 426" end
    end
    -- regrowth,if=combo_points=5&buff.predatory_swiftness.up&talent.bloodtalons.enabled&buff.bloodtalons.down&(!buff.incarnation.up|dot.rip.remains<8)
    if S.Regrowth:IsCastableP() and (Player:ComboPoints() == 5 and Player:BuffP(S.PredatorySwiftnessBuff) and S.Bloodtalons:IsAvailable() and Player:BuffDownP(S.BloodtalonsBuff) and (not Player:BuffP(S.IncarnationBuff) or Target:DebuffRemainsP(S.RipDebuff) < 8)) then
      if HR.Cast(S.Regrowth) then return "regrowth 427"; end
    end
    -- run_action_list,name=finishers,if=combo_points>4
    if (Player:ComboPoints() > 4) then
      return Finishers();
    end
    -- run_action_list,name=generators
    if (true) then
      return Generators();
    end
  end
end

HR.SetAPL(103, APL)
