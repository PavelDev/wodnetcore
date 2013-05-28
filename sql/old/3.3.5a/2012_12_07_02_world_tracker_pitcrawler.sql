-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- Issue 4787: Quests 11984, 12255, 12259
SET @NPC_BUDD := 26422;
SET @NPC_FLAMEBRINGER := 27292;
SET @NPC_FLAMEBRINGERS_CHAIN := 27297;
SET @NPC_THANE_TORVALD := 27377;
SET @NPC_BUDD_PET := 32663;
SET @GUID := 43489; -- Need 2
-- Creature Spawns
UPDATE `creature` SET `spawndist`=0, `MovementType`=0 WHERE `id`=27377; -- Thane Torvald
DELETE FROM `creature` WHERE `id`=@NPC_FLAMEBRINGERS_CHAIN;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`dynamicflags`) VALUES
(@GUID+0,@NPC_FLAMEBRINGERS_CHAIN,571,1,1,17188,0,2786.589,-2483.958,49.05502,4.171337,120,0,0,42,0,0,0,33555200,8),
(@GUID+1,@NPC_FLAMEBRINGERS_CHAIN,571,1,1,17188,0,2802.708,-2520.483,52.75195,2.443461,120,0,0,42,0,0,0,33555200,8);
-- Creature Templates
UPDATE `creature_template` SET `InhabitType`=`InhabitType`|4, `spell1`=48619, `spell2`=48620, `spell3`=52812 WHERE `entry`=@NPC_FLAMEBRINGER;
UPDATE `creature_template` SET `spell1`=47031 WHERE `entry`=@NPC_BUDD_PET;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (@NPC_BUDD,@NPC_FLAMEBRINGER,@NPC_FLAMEBRINGERS_CHAIN,@NPC_BUDD_PET);
UPDATE `creature_template` SET `InhabitType`=4 WHERE `entry`=@NPC_FLAMEBRINGERS_CHAIN;
-- Modelinfo
UPDATE `creature_model_info` SET `combat_reach`=1.95 WHERE `modelid`=134;
UPDATE `creature_model_info` SET `bounding_radius`=0.62, `combat_reach`=4 WHERE `modelid`=22657;
-- SmartScripts for them
UPDATE `smart_scripts` SET `event_param1`=9615 WHERE `entryorguid`=26423; -- Drakuru correct gossip_menu from sniff
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_BUDD,@NPC_FLAMEBRINGER,@NPC_FLAMEBRINGERS_CHAIN,@NPC_BUDD_PET) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_BUDD,0,0,1,62,0,100,0,9301,0,0,0,11,61545,0,0,0,0,0,7,0,0,0,0,0,0,0,'Budd - On gossip select - Spellcast'),
(@NPC_BUDD,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Budd - On gossip select - Close gossip'),
(@NPC_FLAMEBRINGER,0,0,1,62,0,100,0,9512,0,0,0,11,48606,0,0,0,0,0,7,0,0,0,0,0,0,0,'Flamebringer - On gossip select - Spellcast'),
(@NPC_FLAMEBRINGER,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Flamebringer - On gossip select - Close gossip'),
(@NPC_FLAMEBRINGER,0,2,3,54,0,100,0,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Flamebringer - On summon - Remove npcflag'),
(@NPC_FLAMEBRINGER,0,3,4,61,0,100,0,0,0,0,0,11,48602,0,0,0,0,0,1,0,0,0,0,0,0,0,'Flamebringer - On summon - Spellcast'),
(@NPC_FLAMEBRINGER,0,4,0,61,0,100,0,0,0,0,0,85,46598,0,0,0,0,0,1,0,0,0,0,0,0,0,'Flamebringer - On summon - Spellcast'), -- actually cast 48598 on invoker but the linked spell 48600 doesn't work maybe because of effect 1: Dummy (4207) which means this spell works in area Voldrune only and will be removed if the area is left
(@NPC_FLAMEBRINGER,0,5,0,28,0,100,0,0,0,0,0,41,500,0,0,0,0,0,1,0,0,0,0,0,0,0,'Flamebringer - On passenger removed - Despawn'), -- not working
(@NPC_FLAMEBRINGERS_CHAIN,0,0,0,11,0,100,0,0,0,0,0,11,48293,0,30,0,0,0,10,110538,0,0,0,0,0,0,'Flamebringer''s Chain - On update - Spellcast'),
(@NPC_BUDD_PET,0,0,1,54,0,100,0,0,0,0,0,11,47014,0,0,0,0,0,7,0,0,0,0,0,0,0,'Budd pet - On summon - Spellcast'),
(@NPC_BUDD_PET,0,1,2,61,0,100,0,0,0,0,0,11,47025,0,0,0,0,0,1,0,0,0,0,0,0,0,'Budd pet - On summon - Spellcast'),
(@NPC_BUDD_PET,0,2,3,61,0,100,0,0,0,0,0,8,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Budd pet - On summon - Set react defensive'),
(@NPC_BUDD_PET,0,3,0,61,0,100,0,0,0,0,0,29,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Budd pet - On summon - Follow'),
(@NPC_BUDD_PET,0,4,0,60,0,100,0,5000,5000,15000,15000,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Budd pet - Frequently - Say random line');
-- Insert creature_text from sniff
DELETE FROM `creature_text` WHERE `entry`=@NPC_BUDD_PET;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_BUDD_PET,0,0,'You sure we be goin'' da right way, mon?',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,1,'Nuttin'' says luvin'' like a little tap on da noggin.',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,2,'You be it now, brudda!',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,3,'Hee hee hee! Dis gunna be some fun, mon!',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,4,'My troll bruddas be in for some real fun today, mon!',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,5,'Time to play some troll tag, mon!',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,6,'<sniff, sniff> I can smell ''em, mon.',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,7,'No, no, mon. Dere be no trolls here....',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,8,'Ok, mon. Tell me when we be close to mah troll bruddas.',12,0,10,0,0,0,'Budd'),
(@NPC_BUDD_PET,0,9,'Ey, mon! Take me to mah troll bruddas!',12,0,10,0,0,0, 'Budd');
-- Conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=48293;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry`=47042;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,48293,0,0,31,0,3,27292,0,0,0,'','Spell Flamebringer''s Chain targets Flamebringer'),
(17,0,47042,0,0,31,1,3,26425,0,0,0,'','Spell Assemble Cage can only be cast on Drakkari Warrior'),
(17,0,47042,0,1,31,1,3,26447,0,0,0,'','Spell Assemble Cage can only be cast on Drakkari Shaman');
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- Issue 8577: Quests: Seeking the Windserpent Godess, Setting the Stage
SET @GUID := 136095; -- need 83 set by TDB team
SET @OGUID := 71445; -- need 51 set by TDB team
SET @NPC_MATERIAL_YOU := 28473;
SET @NPC_QUETZLUN := 28030;
SET @NPC_SOUL_FONT_VOID_ZONE := 28719;
SET @NPC_SOUL_FONT_BUNNY := 28724;
SET @NPC_QUTEZLUN_WORSHIPPER := 28747;
SET @NPC_SERPENTTOUCHED_BERSERKER := 28748;
SET @NPC_HIGH_PRIEST_MUFUNU := 28752;
SET @NPC_HIGH_PRIESTESS_TUATUA := 28754;
SET @NPC_HIGH_PRIEST_HAWINNI := 28756;
SET @SPELL_GHOSTLY := 51671;
SET @SPELL_MATERIAL_YOU_MIRROR_IMAGE := 51719;
SET @SPELL_QUETZLUN_JUDGMENT := 53096;
-- Creature Spawns
UPDATE `creature` SET `phaseMask`=3 WHERE `guid`=101830;
DELETE FROM `creature` WHERE `guid` BETWEEN @GUID+0 AND @GUID+82;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`MovementType`) VALUES
(@GUID+0,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5636.122,-4146.7,351.608,3.089233,300,0,0),
(@GUID+1,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5664.044,-4147.331,352.7899,1.553343,300,0,0),
(@GUID+2,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5664.018,-4147.648,351.4565,2.548181,300,0,0),
(@GUID+3,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5675.395,-4137.262,351.502,3.787364,300,0,0),
(@GUID+4,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5664.217,-4085.715,353.6724,4.764749,300,0,0),
(@GUID+5,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5635.908,-4084.476,352.2891,3.228859,300,0,0),
(@GUID+6,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5613.329,-4115.911,353.2454,3.089233,300,0,0),
(@GUID+7,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5674.509,-4074.528,354.1718,3.944444,300,0,0),
(@GUID+8,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5664.241,-4085.23,352.2626,3.647738,300,0,0),
(@GUID+9,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5639.341,-4053.244,353.2463,2.876765,300,0,0),
(@GUID+10,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5622.78,-4115.903,353.1671,3.138673,300,0,2),
(@GUID+11,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5716.746,-4227.831,362.8311,3.769911,300,0,0),
(@GUID+12,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5716.862,-4227.003,363.9283,1.448623,300,0,0),
(@GUID+13,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5675.243,-4215.884,362.8769,2.487047,300,10,1),
(@GUID+14,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5672.002,-4169.415,353.3519,1.175808,300,10,1),
(@GUID+15,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5629.758,-4220.245,363.0638,0.003776325,300,0,2),
(@GUID+16,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5769.077,-4148.809,352.1679,1.239184,300,0,0),
(@GUID+17,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5769.101,-4148.125,353.5637,1.570796,300,0,0),
(@GUID+18,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5754.831,-4147.796,352.168,6.248279,300,0,0),
(@GUID+19,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5736.187,-4221.563,362.641,3.203449,300,0,2),
(@GUID+20,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5754.225,-4091.116,352.1982,0.3839724,300,0,0),
(@GUID+21,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5689.841,-4294.694,375.4998,4.625123,300,0,0),
(@GUID+22,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5689.859,-4293.607,374.0815,2.96706,300,0,0),
(@GUID+23,@NPC_HIGH_PRIESTESS_TUATUA,571,1,2,0,5645.158,-4272.998,375.6752,5.8294,300,0,0),
(@GUID+24,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5688.647,-4271.216,375.4739,1.64061,300,0,0),
(@GUID+25,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5665.319,-4285.886,374.0784,1.797689,300,0,0),
(@GUID+26,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5606.6504,-4317.5366,373.995,6.254433,300,0,2),
(@GUID+27,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5742.73,-4293.231,375.2595,4.625123,300,0,0),
(@GUID+28,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5742.742,-4292.647,374.0793,3.630285,300,0,0),
(@GUID+29,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5745.571,-4271.291,375.4861,1.570796,300,0,0),
(@GUID+30,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5820.372,-4211.103,363.6525,4.660029,300,0,0),
(@GUID+31,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5778.949,-4177.473,354.4064,5.271958,300,10,1),
(@GUID+32,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5820.291,-4210.607,362.4237,3.124139,300,0,0),
(@GUID+33,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5777.957,-4234.875,360.5455,5.426627,300,10,1),
(@GUID+34,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5812.099,-4175.637,353.3968,6.254186,300,0,2),
(@GUID+35,@NPC_QUETZLUN,571,1,2,0,5717.112,-4364.71,385.8849,1.570796,300,0,0),
(@GUID+36,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5650.962,-4311.059,374.12,0.1213555,300,10,1),
(@GUID+37,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5689.269,-4377.144,385.8853,0.3490658,300,0,0),
(@GUID+38,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5672.371,-4325.267,374.9322,4.607669,300,0,0),
(@GUID+39,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5826.438,-4297.896,374.0838,5.026548,300,0,0),
(@GUID+40,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5826.199,-4297.682,375.6247,3.211406,300,0,0),
(@GUID+41,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5813.962,-4295.513,374.6385,6.126106,300,0,0),
(@GUID+42,@NPC_HIGH_PRIEST_MUFUNU,571,1,2,0,5757.949,-4321.796,374.0786,1.762783,300,0,0),
(@GUID+43,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5717.151,-4417.467,390.0197,1.553343,300,0,0),
(@GUID+44,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5717.597,-4465.906,394.4915,4.8708,300,10,1),
(@GUID+45,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5784.318,-4450.26,387.2599,1.58825,300,0,0),
(@GUID+46,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5784.426,-4450.768,385.8849,6.073746,300,0,0),
(@GUID+47,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5789.287,-4409.731,386.4334,1.280781,300,10,1),
(@GUID+48,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5647.668,-4377.963,386.065,3.499769,300,0,2),
(@GUID+49,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5649.861,-4449.003,385.8849,3.124139,300,0,0),
(@GUID+50,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5642.891,-4441.074,385.8849,5.462881,300,0,0),
(@GUID+51,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5649.906,-4448.593,387.246,1.570796,300,0,0),
(@GUID+52,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5591.124,-4345.021,374.4803,1.396263,300,0,0),
(@GUID+53,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5616.43,-4299.668,374.1321,1.832596,300,0,0),
(@GUID+54,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5581.104,-4435.173,374.0819,1.553343,300,0,0),
(@GUID+55,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5581.708,-4435.312,375.6412,6.265732,300,0,0),
(@GUID+56,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5591.341,-4395.804,374.0577,1.312582,300,0,2),
(@GUID+57,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5595.193,-4432.799,374.0784,3.316126,300,0,0),
(@GUID+58,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5643.719,-4486.458,385.8680,3.330791,300,10,1),
(@GUID+59,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5613.822,-4286.389,375.3737,5.044002,300,0,0),
(@GUID+60,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5613.496,-4285.685,374.0294,5.986479,300,0,0),
(@GUID+61,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5616.248,-4237.393,363.7526,0.1919862,300,0,0),
(@GUID+62,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5616.471,-4223.491,363.7719,4.694936,300,0,0),
(@GUID+63,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5616.134,-4236.797,365.063,1.58825,300,0,0),
(@GUID+64,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5746.81,-4376.404,386.2263,2.949606,300,0,0),
(@GUID+65,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5819.418,-4267.652,370.2367,5.992916,300,10,1),
(@GUID+66,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5840.336,-4347.718,374.0784,1.623156,300,0,0),
(@GUID+67,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5827.608,-4221.192,362.5218,2.216568,300,0,0),
(@GUID+68,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5798.308,-4147.533,352.1857,6.230825,300,0,0),
(@GUID+69,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5818.01,-4117.077,353.2626,0.01745329,300,0,0),
(@GUID+70,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5769.03,-4084.954,352.1702,3.560472,300,0,0),
(@GUID+71,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5769.066,-4085.207,353.5035,4.764749,300,0,0),
(@GUID+72,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5798.5,-4085.708,352.4719,0.03490658,300,0,0),
(@GUID+73,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5779.8,-4054.32,353.9052,0.0102175,300,10,1),
(@GUID+74,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5831.308,-4381.716,374.6486,1.259763,300,10,1),
(@GUID+75,@NPC_SOUL_FONT_BUNNY,571,1,2,13069,5848.862,-4433.827,375.502,3.159046,300,0,0),
(@GUID+76,@NPC_SOUL_FONT_VOID_ZONE,571,1,2,0,5849.88,-4433.882,374.0784,1.466077,300,0,0),
(@GUID+77,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5842.898,-4440.752,374.0784,0.8377581,300,0,0),
(@GUID+78,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5795.062,-4456.038,385.8848,2.6529,300,0,0),
(@GUID+79,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5831.405,-4489.442,376.4616,2.929957,300,10,1),
(@GUID+80,@NPC_HIGH_PRIEST_HAWINNI,571,1,2,0,5841.862,-4383.027,374.0503,1.571773,300,0,2),
(@GUID+81,@NPC_SERPENTTOUCHED_BERSERKER,571,1,2,0,5793.181,-4386.617,387.4278,2.263534,300,0,2),
(@GUID+82,@NPC_QUTEZLUN_WORSHIPPER,571,1,2,0,5784.907,-4313.739,374.0784,0.9090425,300,10,1);
-- Gameobject Spawns
UPDATE `gameobject_template` SET `flags`=4 WHERE `entry` IN (190717,190718,190719);
DELETE FROM `gameobject` WHERE `guid` BETWEEN @OGUID+0 AND @OGUID+50;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`, `orientation`, `rotation0`, `rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(@OGUID+0,190719,571,1,2,5597.872,-4155.729,362.6012,0.8726639,0,0,0,1,300,100,1),
(@OGUID+1,190719,571,1,2,5632.151,-4150.096,352.3025,4.380776,0,0,0,1,300,100,1),
(@OGUID+2,190717,571,1,2,5707.645,-4061.914,354.3174,3.001947,0,0,0,1,300,100,1),
(@OGUID+3,190719,571,1,2,5610.382,-4115.927,353.4982,1.06465,0,0,0,1,300,100,1),
(@OGUID+4,190717,571,1,2,5742.388,-4150.106,352.4384,1.134463,0,0,0,1,300,100,1),
(@OGUID+5,190719,571,1,2,5726.853,-4062.069,354.3002,1.431168,0,0,0,1,300,100,1),
(@OGUID+6,190719,571,1,2,5768.683,-4106.524,352.6742,5.148723,0,0,0,1,300,100,1),
(@OGUID+7,190719,571,1,2,5797.803,-4286.921,378.6772,4.171338,0,0,0,1,300,100,1),
(@OGUID+8,190718,571,1,2,5680.476,-4381.055,386.0848,4.886924,0,0,0,1,300,100,1),
(@OGUID+9,190718,571,1,2,5676.559,-4325.772,375.9498,3.560473,0,0,0,1,300,100,1),
(@OGUID+10,190717,571,1,2,5706.948,-4324.307,376.862,5.026549,0,0,0,1,300,100,1),
(@OGUID+11,190719,571,1,2,5636.998,-4287.619,378.2026,5.794494,0,0,0,1,300,100,1),
(@OGUID+12,190717,571,1,2,5755.16,-4375.944,386.6035,5.759588,0,0,0,1,300,100,1),
(@OGUID+13,190717,571,1,2,5669.412,-4445.692,385.9232,4.66003,0,0,0,1,300,100,1),
(@OGUID+14,190719,571,1,2,5765.822,-4451.795,386.1481,3.403396,0,0,0,1,300,100,1),
(@OGUID+15,190719,571,1,2,5800.226,-4396.256,388.1242,5.148723,0,0,0,1,300,100,1),
(@OGUID+16,190719,571,1,2,5598.75,-4345.661,377.5887,4.939284,0,0,0,1,300,100,1),
(@OGUID+17,190718,571,1,2,5591.678,-4510.597,377.5719,3.717554,0,0,0,1,300,100,1),
(@OGUID+18,190719,571,1,2,5644.191,-4501.064,387.4688,3.717554,0,0,0,1,300,100,1),
(@OGUID+19,190717,571,1,2,5583.782,-4344.892,377.9865,4.677484,0,0,0,1,300,100,1),
(@OGUID+20,190718,571,1,2,5850.167,-4351.829,374.0035,2.513274,0,0,0,1,300,100,1),
(@OGUID+21,190718,571,1,2,5787.077,-4166.182,352.4897,2.652894,0,0,0,1,300,100,1),
(@OGUID+22,190719,571,1,2,5706.358,-4183.55,353.0656,5.550147,0,0,0,1,300,100,1),
(@OGUID+23,190717,571,1,2,5820.999,-4117.51,353.2778,2.216565,0,0,0,1,300,100,1),
(@OGUID+24,190717,571,1,2,5725.525,-4183.616,356.4301,3.490667,0,0,0,1,300,100,1),
(@OGUID+25,190717,571,1,2,5801.518,-4081.54,352.9559,0.4712385,0,0,0,1,300,100,1),
(@OGUID+26,190718,571,1,2,5783.599,-4199.378,363.9255,1.361356,0,0,0,1,300,100,1),
(@OGUID+27,190718,571,1,2,5788.463,-4028.865,364.6118,3.316144,0,0,0,1,300,100,1),
(@OGUID+28,190718,571,1,2,5679.798,-4084.759,354.015,2.164206,0,0,0,1,300,100,1),
(@OGUID+29,190717,571,1,2,5742.388,-4150.106,352.4384,1.134463,0,0,0,1,300,100,1),
(@OGUID+30,190717,571,1,2,5726.853,-4062.069,354.3002,1.431168,0,0,0,1,300,100,1),
(@OGUID+31,190719,571,1,2,5596.239,-4084.587,362.3596,1.151916,0,0,0,1,300,100,1),
(@OGUID+32,190718,571,1,2,5631.854,-4079.604,352.2866,3.089183,0,0,0,1,300,100,1),
(@OGUID+33,190718,571,1,2,5647.27,-4029.999,365.4366,1.570796,0,0,0,1,300,100,1),
(@OGUID+34,190717,571,1,2,5860.241,-4433.489,375.8128,5.654869,0,0,0,1,300,100,1),
(@OGUID+35,190718,571,1,2,5843.092,-4513.476,376.2388,1.989672,0,0,0,1,300,100,1),
(@OGUID+36,190707,571,1,2,5664.056,-4146.634,351.3731,1.570796,0,0,0,1,300,255,1),
(@OGUID+37,190707,571,1,2,5664.211,-4086.191,352.1793,4.747296,0,0,0,1,300,255,1),
(@OGUID+38,190707,571,1,2,5716.826,-4226.646,362.7477,1.570796,0,0,0,1,300,255,1),
(@OGUID+39,190707,571,1,2,5769.083,-4147.873,352.0845,1.553341,0,0,0,1,300,255,1),
(@OGUID+40,190707,571,1,2,5689.842,-4294.94,373.995,4.677484,0,0,0,1,300,255,1),
(@OGUID+41,190707,571,1,2,5742.686,-4293.651,373.9954,4.729844,0,0,0,1,300,255,1),
(@OGUID+42,190707,571,1,2,5820.354,-4211.717,362.248,4.694937,0,0,0,1,300,255,1),
(@OGUID+43,190707,571,1,2,5825.472,-4297.784,374.0092,3.194002,0,0,0,1,300,255,1),
(@OGUID+44,190707,571,1,2,5784.287,-4449.718,385.8015,1.605702,0,0,0,1,300,255,1),
(@OGUID+45,190707,571,1,2,5649.908,-4447.956,385.8015,1.553341,0,0,0,1,300,255,1),
(@OGUID+46,190707,571,1,2,5582.351,-4435.273,373.9958,6.265733,0,0,0,1,300,255,1),
(@OGUID+47,190707,571,1,2,5613.975,-4286.599,373.9606,5.375615,0,0,0,1,300,255,1),
(@OGUID+48,190707,571,1,2,5616.112,-4236.369,363.7091,1.605702,0,0,0,1,300,255,1),
(@OGUID+49,190707,571,1,2,5769.052,-4085.8,352.0868,4.694937,0,0,0,1,300,255,1),
(@OGUID+50,190707,571,1,2,5848.813,-4433.848,373.995,3.141593,0,0,0,1,300,255,1);
-- Addon data
DELETE FROM `creature_addon` WHERE `guid` IN (@GUID+0,@GUID+3,@GUID+5,@GUID+6,@GUID+7,@GUID+10,@GUID+13,@GUID+14,@GUID+15,@GUID+18,@GUID+19,@GUID+20,@GUID+24,@GUID+25,@GUID+26,@GUID+29,@GUID+31,@GUID+33,@GUID+34,@GUID+36,@GUID+37,@GUID+38,@GUID+41,@GUID+43,@GUID+44,@GUID+47,@GUID+48,@GUID+50,@GUID+53,@GUID+56,@GUID+57,@GUID+58,@GUID+62,@GUID+64,@GUID+65,@GUID+67,@GUID+68,@GUID+69,@GUID+72,@GUID+73,@GUID+74,@GUID+77,@GUID+78,@GUID+79,@GUID+80,@GUID+81,@GUID+82);
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@GUID+0,0,0,8,1,0,''),
(@GUID+3,0,0,0,1,431,''),
(@GUID+5,0,0,8,1,0,''),
(@GUID+6,0,0,8,1,0,''),
(@GUID+7,0,0,0,1,431,''),
(@GUID+10,(@GUID+10)*10,0,0,1,0,''),
(@GUID+13,0,0,0,1,0,'52385'),
(@GUID+14,0,0,0,1,0,'52385'),
(@GUID+15,(@GUID+15)*10,0,0,1,0,''),
(@GUID+18,0,0,0,1,431,''),
(@GUID+19,(@GUID+19)*10,0,0,1,0,''),
(@GUID+20,0,0,0,1,431,''),
(@GUID+24,0,0,8,1,0,''),
(@GUID+25,0,0,0,1,431,''),
(@GUID+26,(@GUID+26)*10,0,0,1,0,''),
(@GUID+29,0,0,8,1,0,''),
(@GUID+31,0,0,0,1,0,'52385'),
(@GUID+33,0,0,0,1,0,'52385'),
(@GUID+34,(@GUID+34)*10,0,0,1,0,''),
(@GUID+36,0,0,0,1,0,'52385'),
(@GUID+37,0,0,0,1,431,''),
(@GUID+38,0,0,8,1,0,''),
(@GUID+41,0,0,0,1,431,''),
(@GUID+43,0,0,0,1,431,''),
(@GUID+44,0,0,0,1,0,'52385'),
(@GUID+47,0,0,0,1,0,'52385'),
(@GUID+48,(@GUID+48)*10,0,0,1,0,''),
(@GUID+50,0,0,0,1,431,''),
(@GUID+53,0,0,0,1,431,''),
(@GUID+56,(@GUID+56)*10,0,0,1,0,''),
(@GUID+57,0,0,0,1,431,''),
(@GUID+58,0,0,0,1,0,'52385'),
(@GUID+62,0,0,0,1,431,''),
(@GUID+64,0,0,0,1,431,''),
(@GUID+65,0,0,0,1,0,'52385'),
(@GUID+67,0,0,0,1,431,''),
(@GUID+68,0,0,8,1,0,''),
(@GUID+69,0,0,8,1,0,''),
(@GUID+72,0,0,8,1,0,''),
(@GUID+73,0,0,0,1,0,'52385'),
(@GUID+74,0,0,0,1,0,'52385'),
(@GUID+77,0,0,0,1,431,''),
(@GUID+78,0,0,0,1,431,''),
(@GUID+79,0,0,0,1,0,'52385'),
(@GUID+80,(@GUID+80)*10,0,0,1,0,''),
(@GUID+81,(@GUID+81)*10,0,0,1,0,''),
(@GUID+82,0,0,0,1,0,'52385');
DELETE FROM `creature_template_addon` WHERE `entry` IN (@NPC_QUETZLUN,@NPC_SOUL_FONT_VOID_ZONE);
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@NPC_QUETZLUN,0,0,0,1,0,'51126 41408'),
(@NPC_SOUL_FONT_VOID_ZONE,0,0,0,1,0,'52222');
-- Creature_updates
UPDATE `creature_template` SET `unit_flags`=33555200, `AIName`='SmartAI' WHERE `entry`=@NPC_MATERIAL_YOU;
UPDATE `creature_template` SET `faction_A`=190, `faction_H`=190, `npcflag`=3, `gossip_menu_id`=9734, `unit_flags`=33536, `AIName`='SmartAI' WHERE `entry`=@NPC_QUETZLUN;
UPDATE `creature_template` SET `minlevel`=77, `maxlevel`=77, `faction_A`=2073, `faction_H`=2073, `unit_flags`=33554432, `flags_extra`=2 WHERE `entry`=@NPC_SOUL_FONT_VOID_ZONE;
UPDATE `creature_template` SET `minlevel`=77, `maxlevel`=77, `unit_flags`=33554432, `unit_flags2`=2080, `InhabitType`=4 WHERE `entry`=@NPC_SOUL_FONT_BUNNY;
UPDATE `creature_template` SET `faction_A`=2069, `faction_H`=2069, `unit_flags`=32768, `equipment_id`=2482, `AIName`='SmartAI' WHERE `entry`=@NPC_QUTEZLUN_WORSHIPPER;
UPDATE `creature_template` SET `speed_walk`=0.6666666, `faction_A`=2069, `faction_H`=2069, `unit_flags`=32768, `AIName`='SmartAI' WHERE `entry` IN (@NPC_SERPENTTOUCHED_BERSERKER,@NPC_HIGH_PRIEST_HAWINNI);
UPDATE `creature_template` SET `faction_A`=2069, `faction_H`=2069, `unit_flags`=32768, `AIName`='SmartAI', `equipment_id`=2483 WHERE `entry`=@NPC_HIGH_PRIEST_MUFUNU;
UPDATE `creature_template` SET `faction_A`=2069, `faction_H`=2069, `unit_flags`=32768, `AIName`='SmartAI', `equipment_id`=2484 WHERE `entry`=@NPC_HIGH_PRIESTESS_TUATUA;
UPDATE `creature_model_info` SET `bounding_radius`=2.38, `combat_reach`=10.5 WHERE `modelid`=25634;
UPDATE `creature_model_info` SET `bounding_radius`=0.3672, `combat_reach`=1.8, `gender`=0, `modelid_other_gender`=25661 WHERE `modelid`=25660;
UPDATE `creature_model_info` SET `bounding_radius`=0.3672, `combat_reach`=1.8, `gender`=1, `modelid_other_gender`=25660 WHERE `modelid`=25661;
UPDATE `creature_model_info` SET `bounding_radius`=2.625, `combat_reach`=2.625 WHERE `modelid`=25662;
UPDATE `creature_model_info` SET `bounding_radius`=3, `combat_reach`=3 WHERE `modelid`=25663;
UPDATE `creature_model_info` SET `bounding_radius`=0.5355, `combat_reach`=2.625 WHERE `modelid`=25666;
UPDATE `creature_model_info` SET `bounding_radius`=4.5, `combat_reach`=4.5 WHERE `modelid`=25667;
UPDATE `creature_model_info` SET `bounding_radius`=0.6076385, `combat_reach`=2.625 WHERE `modelid`=27858;
-- Equipments
DELETE FROM `creature_equip_template` WHERE `entry` IN (2482,2483,2484);
INSERT INTO `creature_equip_template` (`entry`,`itemEntry1`,`itemEntry2`,`itemEntry3`) VALUES
(2482,28678,0,0),
(2483,13622,0,0),
(2484,28739,0,0);
-- Gossips
DELETE FROM `gossip_menu` WHERE `entry`=9734;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(9734,13331);
-- SAI for involved creatures
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_QUETZLUN,@NPC_MATERIAL_YOU,@NPC_QUTEZLUN_WORSHIPPER,@NPC_SERPENTTOUCHED_BERSERKER,@NPC_HIGH_PRIEST_MUFUNU,@NPC_HIGH_PRIESTESS_TUATUA,@NPC_HIGH_PRIEST_HAWINNI) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_QUETZLUN,0,0,0,1,0,100,0,30000,60000,180000,300000,11,@SPELL_QUETZLUN_JUDGMENT,0,0,0,0,0,19,@NPC_QUTEZLUN_WORSHIPPER,30,0,0,0,0,0,'Quetz''lun - On update OOC - Spellcast Quetz''lun''s Judgment'),
(@NPC_MATERIAL_YOU,0,0,1,54,0,100,0,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Material You - Just summoned - Say line'),
(@NPC_MATERIAL_YOU,0,1,2,61,0,100,0,0,0,0,0,85,@SPELL_MATERIAL_YOU_MIRROR_IMAGE,0,0,0,0,0,1,0,0,0,0,0,0,0,'Material You - Just summoned - Invoker spellcast Altar of Quetz''lun: Material You''s Mirror Image Aura'),
(@NPC_MATERIAL_YOU,0,2,3,61,0,100,0,0,0,0,0,85,41055,0,0,0,0,0,1,0,0,0,0,0,0,0,'Material You - Just summoned - Invoker spellcast Copy Weapon'),
(@NPC_MATERIAL_YOU,0,3,0,61,0,100,0,0,0,0,0,85,45206,0,0,0,0,0,1,0,0,0,0,0,0,0,'Material You - Just summoned - Invoker spellcast Copy Off-hand Weapon'),
(@NPC_QUTEZLUN_WORSHIPPER,0,0,0,4,0,100,0,0,0,0,0,11,54594,0,0,0,0,0,7,0,0,0,0,0,0,0,'Quetz''lun Worshipper - On aggro - Spellcast Serpent Strike'),
(@NPC_QUTEZLUN_WORSHIPPER,0,1,0,2,0,100,0,0,50,30000,40000,11,54601,0,0,0,0,0,1,0,0,0,0,0,0,0,'Quetz''lun Worshipper - On health below 50% - Spellcast Serpent Form'),
(@NPC_SERPENTTOUCHED_BERSERKER,0,0,0,4,0,100,0,0,0,0,0,11,54594,0,0,0,0,0,7,0,0,0,0,0,0,0,'Serpent-Touched Berserker - On aggro - Spellcast Serpent Strike'),
(@NPC_HIGH_PRIEST_MUFUNU,0,0,2,11,0,100,0,0,0,0,0,11,51733,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On spawn - Spellcast Shadow Channelling'),
(@NPC_HIGH_PRIEST_MUFUNU,0,1,2,21,0,100,0,0,0,0,0,11,51733,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On homeposition reached - Spellcast Shadow Channelling'),
(@NPC_HIGH_PRIEST_MUFUNU,0,2,3,61,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On homeposition reached - Disable combat movement'),
(@NPC_HIGH_PRIEST_MUFUNU,0,3,0,61,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On homeposition reached - Set event phase 1'),
(@NPC_HIGH_PRIEST_MUFUNU,0,4,5,9,0,100,0,40,80,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On target range more than 40y - Enable combat movement'),
(@NPC_HIGH_PRIEST_MUFUNU,0,5,0,61,0,100,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On target range more than 40y - Set event phase 2'),
(@NPC_HIGH_PRIEST_MUFUNU,0,6,3,9,0,100,0,0,20,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On target range below 20y - Disable combat movement'),
(@NPC_HIGH_PRIEST_MUFUNU,0,7,0,0,1,100,0,0,0,2500,2500,11,20820,0,0,0,0,0,2,0,0,0,0,0,0,0,'High Priest Mu''funu - On update IC (phase 1) - Spellcast Holy Smite'),
(@NPC_HIGH_PRIEST_MUFUNU,0,8,0,2,0,100,0,0,30,0,0,22,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On health below 30% - Set event phase 4'),
(@NPC_HIGH_PRIEST_MUFUNU,0,9,0,0,4,100,0,0,0,30000,30000,11,11974,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On update IC (phase 4) - Spellcast Power Word: Shield'),
(@NPC_HIGH_PRIEST_MUFUNU,0,10,0,0,4,100,0,50,50,15000,20000,11,11640,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Mu''funu - On update IC (phase 4) - Spellcast Renew'),
(@NPC_HIGH_PRIESTESS_TUATUA,0,0,1,11,0,100,0,0,0,0,0,11,51733,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priestess Tua-Tua - On spawn - Spellcast Shadow Channelling'),
(@NPC_HIGH_PRIESTESS_TUATUA,0,1,0,61,0,100,0,0,0,0,0,28,29406,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priestess Tua-Tua - On homeposition reached - Remove aura Shadowform'),
(@NPC_HIGH_PRIESTESS_TUATUA,0,2,1,21,0,100,0,0,0,0,0,11,51733,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priestess Tua-Tua - On homeposition reached - Spellcast Shadow Channelling'),
(@NPC_HIGH_PRIESTESS_TUATUA,0,3,0,4,0,100,0,0,0,0,0,11,29406,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priestess Tua-Tua - On aggro - Spellcast Shadowform'),
(@NPC_HIGH_PRIESTESS_TUATUA,0,4,0,0,0,100,0,2000,3000,15000,20000,11,51818,0,0,0,0,0,2,0,0,0,0,0,0,0,'High Priestess Tua-Tua - On update IC - Spellcast Shadow Word: Death'),
(@NPC_HIGH_PRIESTESS_TUATUA,0,5,0,0,0,100,0,4000,5000,3000,5000,11,13860,0,0,0,0,0,2,0,0,0,0,0,0,0,'High Priestess Tua-Tua - On update IC - Spellcast Mind Blast'),
(@NPC_HIGH_PRIEST_HAWINNI,0,0,0,0,0,100,0,2000,3000,10000,15000,11,54603,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Hawinni - On update IC - Spellcast Serpent''s Agility'),
(@NPC_HIGH_PRIEST_HAWINNI,0,1,2,2,0,100,1,0,40,0,0,11,50420,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Hawinni - On health below 40% - Spellcast Enrage'),
(@NPC_HIGH_PRIEST_HAWINNI,0,2,0,61,0,100,0,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'High Priest Hawinni - On health below 40% - Say line'),
(@NPC_HIGH_PRIEST_HAWINNI,0,3,0,7,0,100,0,0,0,0,0,28,50420,0,0,0,0,0,1,0,0,0,0,0,0,0,'High Priest Hawinni - On evade - Remove aura Enrage');
-- Waypoints
DELETE FROM `waypoint_data` WHERE `id` IN ((@GUID+10)*10,(@GUID+15)*10,(@GUID+19)*10,(@GUID+26)*10,(@GUID+34)*10,(@GUID+48)*10,(@GUID+56)*10,(@GUID+80)*10,(@GUID+81)*10);
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
((@GUID+10)*10,1,5622.78,-4115.903,353.1671,0,0,0,0,100,0),
((@GUID+10)*10,2,5700.014,-4116.477,353.2688,0,0,0,0,100,0),
((@GUID+15)*10,1,5629.758,-4220.245,363.0638,0,0,0,0,100,0),
((@GUID+15)*10,2,5698.905,-4220.559,362.8123,0,0,0,0,100,0),
((@GUID+19)*10,1,5736.187,-4221.563,362.641,0,0,0,0,100,0),
((@GUID+19)*10,2,5765.859,-4221.353,361.5846,0,0,0,0,100,0),
((@GUID+19)*10,3,5781.38,-4231.069,359.3161,0,0,0,0,100,0),
((@GUID+19)*10,4,5799.918,-4242.83,362.6221,0,0,0,0,100,0),
((@GUID+19)*10,5,5817.34,-4242.409,363.7439,0,0,0,0,100,0),
((@GUID+19)*10,6,5844.105,-4244.604,362.7979,0,0,0,0,100,0),
((@GUID+19)*10,7,5817.34,-4242.409,363.7439,0,0,0,0,100,0),
((@GUID+19)*10,8,5799.918,-4242.83,362.6221,0,0,0,0,100,0),
((@GUID+19)*10,9,5781.38,-4231.069,359.3161,0,0,0,0,100,0),
((@GUID+19)*10,10,5765.859,-4221.353,361.5846,0,0,0,0,100,0),
((@GUID+26)*10,1,5606.6504,-4317.5366,373.995,0,0,0,0,100,0),
((@GUID+26)*10,2,5625.5952,-4303.0625,373.995,0,0,0,0,100,0),
((@GUID+26)*10,3,5782.809,-4302.274,374.12,0,0,0,0,100,0),
((@GUID+26)*10,4,5802.482,-4309.014,374.0114,0,0,0,0,100,0),
((@GUID+34)*10,1,5812.099,-4175.637,353.3968,0,0,0,0,100,0),
((@GUID+34)*10,2,5821.506,-4165.563,353.5313,0,0,0,0,100,0),
((@GUID+34)*10,3,5818.826,-4129.878,353.8851,0,0,0,0,100,0),
((@GUID+34)*10,4,5810.663,-4117.67,353.2181,0,0,0,0,100,0),
((@GUID+34)*10,5,5792.259,-4117.242,353.2197,0,0,0,0,100,0),
((@GUID+34)*10,6,5755.833,-4119.403,353.3149,0,0,0,0,100,0),
((@GUID+34)*10,7,5754.487,-4121.689,353.3535,0,0,0,0,100,0),
((@GUID+34)*10,8,5747.097,-4163.901,352.5367,0,0,0,0,100,0),
((@GUID+34)*10,9,5754.965,-4174.736,353.418,0,0,0,0,100,0),
((@GUID+48)*10,1,5647.668,-4377.963,386.065,0,0,0,0,100,0),
((@GUID+48)*10,2,5647.648,-4439.329,385.8019,0,0,0,0,100,0),
((@GUID+56)*10,1,5591.341,-4395.804,374.0577,0,0,0,0,100,0),
((@GUID+56)*10,2,5589.711,-4473.008,373.9948,0,0,0,0,100,0),
((@GUID+80)*10,1,5841.862,-4383.027,374.0503,0,0,0,0,100,0),
((@GUID+80)*10,2,5841.261,-4481.065,376.1894,0,0,0,0,100,0),
((@GUID+81)*10,1,5794.948,-4488.715,387.3983,0,0,0,0,100,0),
((@GUID+81)*10,2,5793.181,-4386.617,387.4278,0,0,0,0,100,0);
-- Spell data
DELETE FROM `spell_area` WHERE `spell`=@SPELL_GHOSTLY AND `area`=4325;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`) VALUES
(@SPELL_GHOSTLY,4325,12667,12675,0,0,2,1,2|64);
-- Spell Linking
DELETE FROM `spell_linked_spell` WHERE `spell_trigger`=@SPELL_GHOSTLY;
INSERT INTO `spell_linked_spell` (`spell_trigger`,`spell_effect`,`type`,`comment`) VALUES
(@SPELL_GHOSTLY,51717,1,'On Ghostly - Spellcast Altar of Quetz''lun: Summon Material You');
-- Conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (@SPELL_MATERIAL_YOU_MIRROR_IMAGE,@SPELL_QUETZLUN_JUDGMENT);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,@SPELL_MATERIAL_YOU_MIRROR_IMAGE,0,0,31,0,3,@NPC_MATERIAL_YOU,0,0,0,'','Spell Altar of Quetz''lun: Material You''s Mirror Image Aura targets Material You'),
(13,2,@SPELL_MATERIAL_YOU_MIRROR_IMAGE,0,0,31,0,3,@NPC_MATERIAL_YOU,0,0,0,'','Spell Altar of Quetz''lun: Material You''s Mirror Image Aura targets Material You'),
(13,4,@SPELL_MATERIAL_YOU_MIRROR_IMAGE,0,0,31,0,3,@NPC_MATERIAL_YOU,0,0,0,'','Spell Altar of Quetz''lun: Material You''s Mirror Image Aura targets Material You'),
(13,1,@SPELL_QUETZLUN_JUDGMENT,0,0,31,0,3,@NPC_QUTEZLUN_WORSHIPPER,0,0,0,'','Spell Quetz''lun''s Judgment targets Quetz''lun Worshipper');
-- Creature Texts
DELETE FROM `creature_text` WHERE `entry` IN (@NPC_MATERIAL_YOU,@NPC_HIGH_PRIEST_HAWINNI);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_MATERIAL_YOU,0,0,'You leave your material body behind!',42,0,100,0,0,0,'Material You'),
(@NPC_HIGH_PRIEST_HAWINNI,0,0,'%s becomes enraged!',16,0,100,0,0,0,'Hawinni');
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- Issue 8515: Quest I Sense a Disturbance
SET @GUID := 88701; -- need 34 set by TDB
SET @GOSSIP := 9687;
SET @QUEST := 12665;
SET @NPC_ELM_BUNNY := 26298;
SET @NPC_HARKOA := 28401;
SET @NPC_CLAW_OF_HARKOA := 28402;
SET @NPC_HARKOA_SUBDUER := 28403;
SET @NPC_CURSED_OFFSPRING := 28404;
SET @NPC_HARKOA_KITTEN := 28665;
SET @NPC_QUETZLUN := 28671;
SET @SPELL_RIDING_HARKOA_KITTEN := 25673;
SET @SPELL_SPEED := 39870;
SET @SPELL_SUMMON_HARKOA_KITTEN := 52187;
SET @SPELL_STEALTH := 52188;
-- Spawns
DELETE FROM `creature` WHERE `guid` BETWEEN @GUID+0 AND @GUID+33;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`dynamicflags`) VALUES
(@GUID+0,@NPC_ELM_BUNNY,571,1,1,21999,0,5309.635,-3772.253,372.5037,5.707227,300,0,0,42,0,0,0,0,0),
(@GUID+1,@NPC_ELM_BUNNY,571,1,1,21999,0,5333.049,-3796.974,372.489,2.356194,300,0,0,42,0,0,0,0,0),
(@GUID+2,@NPC_ELM_BUNNY,571,1,1,21999,0,5309.46,-3772.571,372.4755,5.358161,300,0,0,42,0,0,0,0,0),
(@GUID+3,@NPC_ELM_BUNNY,571,1,1,21999,0,5332.838,-3797.16,372.4756,2.321288,300,0,0,42,0,0,0,0,0),
(@GUID+4,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5375.799,-3758.142,360.5291,0.7330383,300,0,0,0,0,0,0,0,0),
(@GUID+5,@NPC_CURSED_OFFSPRING,571,1,1,0,0,5497.146,-3791.354,359.6451,3.033307,300,5,0,0,0,1,0,0,0),
(@GUID+6,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5323.46,-3813,371.9776,1.553343,300,0,0,0,0,0,0,0,0),
(@GUID+7,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5291.728,-3780.95,371.6594,6.248279,300,0,0,0,0,0,0,0,0),
(@GUID+8,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5316.537,-3755.717,371.5298,5.009095,300,0,0,0,0,0,0,0,0),
(@GUID+9,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5422.518,-3822.243,363.2307,0.01745329,300,0,0,0,0,0,0,0,0),
(@GUID+10,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5335.817,-3846.023,370.8626,3.926991,300,0,0,0,0,0,0,0,0),
(@GUID+11,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5382.776,-3799.292,372.6979,0.7853982,300,0,0,0,0,0,0,0,0),
(@GUID+12,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5347.82,-3790.36,371.4579,2.80998,300,0,0,0,0,0,0,0,0),
(@GUID+13,@NPC_CURSED_OFFSPRING,571,1,1,0,0,5385.085,-3821.307,373.1991,4.390826,300,5,0,0,0,1,0,0,0),
(@GUID+14,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5368.791,-3862.889,373.6328,5.51524,300,0,0,0,0,0,0,0,0),
(@GUID+15,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5263.502,-3717.983,373.0725,2.356194,300,0,0,0,0,0,0,0,0),
(@GUID+16,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5394.254,-3702.963,362.089,0.1570796,300,0,0,0,0,0,0,0,0),
(@GUID+17,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5410.39,-3718.896,362.0468,1.518436,300,0,0,0,0,0,0,0,0),
(@GUID+18,@NPC_CURSED_OFFSPRING,571,1,1,0,0,5395.654,-3862.894,362.4349,4.355803,300,5,0,0,0,1,0,0,0),
(@GUID+19,@NPC_CURSED_OFFSPRING,571,1,1,0,0,5434.535,-3731.848,362.0858,2.675762,300,5,0,0,0,1,0,0,0),
(@GUID+20,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5477.654,-3878.015,361.0569,0.7679449,300,0,0,0,0,0,0,0,0),
(@GUID+21,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5553.428,-3829.976,372.5273,5.654867,300,0,0,0,0,0,0,0,0),
(@GUID+22,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5585.777,-3799.415,366.2234,6.143559,300,0,0,0,0,0,0,0,0),
(@GUID+23,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5537.25,-3846.529,372.089,5.375614,300,0,0,0,0,0,0,0,0),
(@GUID+24,@NPC_CURSED_OFFSPRING,571,1,1,0,0,5510.545,-3926.729,362.0851,5.462688,300,5,0,0,0,1,0,0,0),
(@GUID+25,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5322.316,-3572.04,363.3229,4.834562,300,0,0,0,0,0,0,0,0),
(@GUID+26,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5367.774,-3541.64,364.2363,0.7853982,300,0,0,0,0,0,0,0,0),
(@GUID+27,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5459.911,-3643.151,362.3447,0.9424778,300,0,0,0,0,0,0,0,0),
(@GUID+28,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5323.396,-3644.5,362.0438,5.707227,300,0,0,0,0,0,0,0,0),
(@GUID+29,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5330.009,-3913.493,365.8797,4.694936,300,0,0,0,0,0,0,0,0),
(@GUID+30,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5434.8,-3919.141,361.1612,3.944444,300,0,0,0,0,0,0,0,0),
(@GUID+31,@NPC_CLAW_OF_HARKOA,571,1,1,0,0,5407.908,-3925.006,362.0776,4.746883,300,5,0,0,0,1,0,0,0),
(@GUID+32,@NPC_CURSED_OFFSPRING,571,1,1,0,0,5347.841,-3946.389,362.553,0.7498215,300,5,0,0,0,1,0,0,0),
(@GUID+33,@NPC_HARKOA_SUBDUER,571,1,1,0,0,5277.245,-3619.667,363.3282,6.213372,300,0,0,0,0,0,0,0,0);
-- some corrections to previous spawns
UPDATE `creature` SET `position_x`=5349.371, `position_y`=-3615.906, `position_z`=363.8878, `orientation`=5.462881 WHERE `guid`=118735;
UPDATE `creature` SET `spawndist`=5, `movementType`=1 WHERE `guid` IN (118714,118722,118729,118731,118732,118733);
UPDATE `gameobject_template` SET `flags`=4 WHERE `entry`=190633;
UPDATE `creature_template` SET `gossip_menu_id`=@GOSSIP, `AIName`='SmartAI' WHERE `entry`=28401;
UPDATE `creature_template` SET `speed_run`=2.571429, `unit_flags`=33288, `AIName`='SmartAI' WHERE `entry`=28665;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=@NPC_HARKOA_SUBDUER;
DELETE FROM `creature_template_addon` WHERE `entry`=@NPC_CLAW_OF_HARKOA;
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@NPC_CLAW_OF_HARKOA,0,0,0,1,0,'54608');
DELETE FROM `creature_addon` WHERE `guid` IN (@GUID+0,@GUID+1,@GUID+2,@GUID+3,118591);
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES
(@GUID+0,0,0,0,1,0,'52485 51666'),
(@GUID+1,0,0,0,1,0,'52485 51666'),
(@GUID+2,0,0,0,1,0,'52485 51666'),
(@GUID+3,0,0,0,1,0,'52485 51666'),
(118591,0,0,0,1,0,'52485 51666');
-- SAI info
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=@NPC_HARKOA_SUBDUER;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_HARKOA_SUBDUER,-(@GUID+0),-(@GUID+1),-(@GUID+2),-(@GUID+3)) AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_HARKOA_SUBDUER*100 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@NPC_HARKOA_SUBDUER,0,0,0,11,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On spawn - Disable combatmovement'),
(@NPC_HARKOA_SUBDUER,0,1,0,1,0,100,0,2000,20000,40000,60000,80,@NPC_HARKOA_SUBDUER*100,2,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On update OOC - Run script'),
(@NPC_HARKOA_SUBDUER,0,2,0,4,0,100,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On aggro - Set eventphase 1'),
(@NPC_HARKOA_SUBDUER,0,3,0,0,1,100,0,0,0,2800,3500,11,20822,0,0,0,0,0,2,0,0,0,0,0,0,0,'Har''koa Subduer - On update IC (phase 1) - Spellcast Frostbolt'),
(@NPC_HARKOA_SUBDUER,0,4,0,9,1,100,0,35,80,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On range more than 35y (phase 1) - Enable combatmovement'),
(@NPC_HARKOA_SUBDUER,0,6,0,9,1,100,0,5,15,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On range less than 15y (phase 1) - Disable combatmovement'),
(@NPC_HARKOA_SUBDUER,0,7,0,9,1,100,0,0,5,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On range less than 5y (phase 1) - Enable combatmovement'),
(@NPC_HARKOA_SUBDUER,0,8,9,3,1,100,0,0,15,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On mana below 15% (phase 1) - Set eventphase 2'),
(@NPC_HARKOA_SUBDUER,0,9,0,61,0,100,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On mana below 15% - Enable combatmovement'),
(@NPC_HARKOA_SUBDUER,0,10,0,3,2,100,0,30,100,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On mana over 30% (phase 2) - Set eventphase 1'),
(@NPC_HARKOA_SUBDUER,0,11,12,2,0,100,0,0,15,0,0,22,4,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On health below 15% - Set eventphase 3'),
(@NPC_HARKOA_SUBDUER,0,12,13,61,0,100,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On health below 15% - Enable combat movement'),
(@NPC_HARKOA_SUBDUER,0,13,0,61,0,100,1,0,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On health below 15% - Flee'),
(@NPC_HARKOA_SUBDUER,0,14,0,7,0,100,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On evade - Reset event phase'),
(@NPC_HARKOA_SUBDUER,0,15,0,21,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer - On homeposition reached - Disable combatmovement'),
(-(@GUID+0),0,0,0,11,0,100,0,0,0,0,0,11,51579,0,0,0,0,0,11,28401,10,0,0,0,0,0,'ELM General Purpose Bunny - On spawn - Spellcast Har''koa''s Chains'),
(-(@GUID+1),0,0,0,11,0,100,0,0,0,0,0,11,51577,0,0,0,0,0,11,28401,10,0,0,0,0,0,'ELM General Purpose Bunny - On spawn - Spellcast Har''koa''s Chains'),
(-(@GUID+2),0,0,0,11,0,100,0,0,0,0,0,11,45808,0,0,0,0,0,11,28401,10,0,0,0,0,0,'ELM General Purpose Bunny - On spawn - Spellcast Har''koa''s Chains'),
(-(@GUID+3),0,0,0,11,0,100,0,0,0,0,0,11,45808,0,0,0,0,0,11,28401,10,0,0,0,0,0,'ELM General Purpose Bunny - On spawn - Spellcast Har''koa''s Chains'),
(@NPC_HARKOA_SUBDUER*100,9,0,0,0,0,100,0,0,0,0,0,11,45846,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer script - Spellcast Frost Channelling'),
(@NPC_HARKOA_SUBDUER*100,9,1,0,0,0,100,0,10000,20000,0,0,92,0,45846,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer script - Set unit_field_bytes1 (kneel)'),
(@NPC_HARKOA_SUBDUER*100,9,2,0,0,0,100,0,0,0,0,0,90,8,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa Subduer script - Set unit_field_bytes1 (kneel)');
-- Gossip info
DELETE FROM `gossip_menu` WHERE `entry`=@GOSSIP;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(@GOSSIP,13139);
DELETE FROM `gossip_menu_option` WHERE `menu_id`=@GOSSIP AND `id`=0;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`box_coded`,`box_money`,`box_text`) VALUES
(@GOSSIP,0,0,'Great and powerful Har''koa, please call for one of your children that it might stealthily carry me into the Altar of Quetz''lun.',1,1,0,0,0,0,NULL);
-- Conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (45808,51577,51579);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=@GOSSIP;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,45808,0,0,31,0,3,28401,0,0,0,'','Spell Har''koa''s Chains targets Har''koa'),
(13,1,51577,0,0,31,0,3,28401,0,0,0,'','Spell Har''koa''s Chains targets Har''koa'),
(13,1,51579,0,0,31,0,3,28401,0,0,0,'','Spell Har''koa''s Chains targets Har''koa'),
(15,@GOSSIP,0,0,0,9,0,@QUEST,0,0,0,0,'','Show gossip option if player has taken quest 12655');

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (@NPC_HARKOA,@NPC_HARKOA_KITTEN) AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=@NPC_HARKOA_KITTEN*100 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
-- Har'koa script
(@NPC_HARKOA,0,0,1,62,0,100,0,@GOSSIP,0,0,0,11,@SPELL_SUMMON_HARKOA_KITTEN,0,0,0,0,0,7,0,0,0,0,0,0,0,'Har''koa - On gossip option select - force player to summon Har''koa''s Kitten'),
(@NPC_HARKOA,0,1,0,61,0,100,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Har''koa - On gossip option select - close gossip'),
-- Har'koa's Kitten script
(@NPC_HARKOA_KITTEN,0,0,1,54,0,100,0,0,0,0,0,75,@SPELL_STEALTH,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On spawn - Apply Stealth'),
(@NPC_HARKOA_KITTEN,0,1,0,61,0,100,0,0,0,0,0,53,1,@NPC_HARKOA_KITTEN,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On spawn - Start WP movement'),
(@NPC_HARKOA_KITTEN,0,2,0,40,0,100,0,1,@NPC_HARKOA_KITTEN,0,0,1,0,0,0,0,0,0,23,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 1 reached - Say line'),
(@NPC_HARKOA_KITTEN,0,3,4,40,0,100,0,10,@NPC_HARKOA_KITTEN,0,0,54,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 10 reached - Pause WP movement'),
(@NPC_HARKOA_KITTEN,0,4,0,61,0,100,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On waypoint 10 reached - Say line'),
(@NPC_HARKOA_KITTEN,0,5,6,40,0,100,0,18,@NPC_HARKOA_KITTEN,0,0,54,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 18 reached - Pause WP movement'),
(@NPC_HARKOA_KITTEN,0,6,7,61,0,100,0,0,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 18 reached - Disable run'),
(@NPC_HARKOA_KITTEN,0,7,0,61,0,100,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 18 reached - Say line'),
(@NPC_HARKOA_KITTEN,0,9,0,40,0,100,0,21,@NPC_HARKOA_KITTEN,0,0,84,0,0,0,0,0,0,19,@NPC_QUETZLUN,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 21 reached - Set data 0 1 for Prophet of Quetz''lun'),
(@NPC_HARKOA_KITTEN,0,10,11,40,0,100,0,22,@NPC_HARKOA_KITTEN,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 22 reached - Enable run'),
(@NPC_HARKOA_KITTEN,0,11,0,61,0,100,0,0,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 22 reached - Say line'),
(@NPC_HARKOA_KITTEN,0,12,0,40,0,100,0,31,@NPC_HARKOA_KITTEN,0,0,11,@SPELL_SPEED,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 31 reached - Spellcast Speed Burst'),
(@NPC_HARKOA_KITTEN,0,13,14,40,0,100,0,34,@NPC_HARKOA_KITTEN,0,0,28,@SPELL_SPEED,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 34 reached - Remove aura Speed Burst'),
(@NPC_HARKOA_KITTEN,0,14,15,61,0,100,0,0,0,0,0,97,30,10,0,0,0,0,8,0,0,0,5651.193,-3790.460,361.974,0,'Har''koa''s Kitten - On WP 34 reached - Jump'),
(@NPC_HARKOA_KITTEN,0,15,0,61,0,100,0,0,0,0,0,80,@NPC_HARKOA_KITTEN*100,2,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 34 reached - Run script'),
(@NPC_HARKOA_KITTEN,0,16,17,40,0,100,0,11,@NPC_HARKOA_KITTEN*10,0,0,1,5,0,0,0,0,0,23,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 11 reached - Say line'),
(@NPC_HARKOA_KITTEN,0,17,18,61,0,100,0,0,0,0,0,28,@SPELL_RIDING_HARKOA_KITTEN,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 10 reached - Remove aura Riding Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,0,18,0,61,0,100,0,0,0,0,0,41,500,0,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten - On WP 10 reached - Despawn'),
(@NPC_HARKOA_KITTEN*100,9,0,0,0,0,100,0,2000,2000,0,0,1,4,0,0,0,0,0,23,0,0,0,0,0,0,0,'Har''koa''s Kitten script - Say line'),
(@NPC_HARKOA_KITTEN*100,9,1,0,0,0,100,0,500,500,0,0,53,1,@NPC_HARKOA_KITTEN*10,0,0,0,0,1,0,0,0,0,0,0,0,'Har''koa''s Kitten script - Start WP movement');
-- Waypoints
DELETE FROM `waypoints` WHERE `entry` IN (@NPC_HARKOA_KITTEN,@NPC_HARKOA_KITTEN*10);
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(@NPC_HARKOA_KITTEN, 1,5343.219,-3763.973,373.093,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 2,5365.389,-3750.708,360.531,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 3,5386.707,-3755.923,360.458,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 4,5421.301,-3779.266,361.966,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 5,5464.585,-3784.811,362.422,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 6,5472.514,-3787.657,359.862,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 7,5523.643,-3823.486,360.533,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 8,5539.182,-3838.393,372.141,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN, 9,5714.259,-3895.436,371.987,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,10,5714.515,-3944.740,371.987,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,11,5715.673,-4019.310,372.152,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,12,5716.523,-4054.907,353.671,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,13,5716.630,-4188.195,354.075,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,14,5716.644,-4205.305,362.825,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,15,5724.548,-4238.222,362.746,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,16,5724.905,-4258.611,374.355,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,17,5720.831,-4331.177,374.023,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,18,5722.675,-4351.540,385.496,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,19,5728.693,-4374.917,386.492,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,20,5717.937,-4385.863,386.191,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,21,5705.368,-4379.375,385.803,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,22,5705.883,-4371.388,385.803,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,23,5714.739,-4352.132,385.560,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,24,5720.831,-4331.177,374.023,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,25,5724.905,-4258.611,374.355,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,26,5724.548,-4238.222,362.746,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,27,5716.644,-4205.305,362.825,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,28,5716.630,-4188.195,354.075,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,29,5716.523,-4054.907,353.671,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,30,5715.673,-4019.310,372.152,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,31,5714.515,-3944.740,371.987,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,32,5714.259,-3895.436,371.987,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,33,5709.297,-3844.293,372.012,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,34,5672.465,-3815.550,373.647,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 1,5605.440,-3790.634,362.713,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 2,5579.467,-3789.876,365.829,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 3,5552.734,-3794.191,362.082,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 4,5535.410,-3792.923,362.071,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 5,5472.514,-3787.657,359.862,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 6,5464.585,-3784.811,362.422,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 7,5421.301,-3779.266,361.966,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 8,5386.707,-3755.923,360.458,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10, 9,5365.389,-3750.708,360.531,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10,10,5344.119,-3764.440,373.096,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN*10,11,5331.768,-3774.679,371.341,'Har''koa''s Kitten');
-- Areatrigger info
DELETE FROM `areatrigger_involvedrelation` WHERE `quest`=@QUEST;
INSERT INTO `areatrigger_involvedrelation` (`id`,`quest`) VALUES
(5052,@QUEST);
-- Spell Data
DELETE FROM `spell_area` WHERE `spell`=52485 AND `area`=4322;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`) VALUES
(52485,4322,0,12685,0,0,2,1);
-- Creature Texts
DELETE FROM `creature_text` WHERE `entry` IN (@NPC_HARKOA_KITTEN,@NPC_QUETZLUN);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(@NPC_HARKOA_KITTEN,0,0,'Thank you for saving me, $N. This is the least that I could do to return the favor. Hold on tight. Here we go.',15,0,100,0,0,0,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,1,0,'This doesn''t look good. Whatever you do, don''t fall off. There''s a ton of nasty things in there!',15,0,100,0,0,0,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,2,0,'Oh no... Quetz''lun is dead! Stay still. We''ll sneak past the prophet.',15,0,100,0,0,0,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,3,0,'We''re spotted! Hang on. We have to get out of here!',15,0,100,0,0,0,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,4,0,'I think we''re safe now. Let''s get back!',15,0,100,0,0,0,'Har''koa''s Kitten'),
(@NPC_HARKOA_KITTEN,5,0,'We made it! Take care, $N, and thanks again!',15,0,100,0,0,0,'Har''koa''s Kitten'),
(@NPC_QUETZLUN,0,0,'What was that? I sense an intruder. Find and kill them!',14,0,100,0,0,0,'Quetz''lun');
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
