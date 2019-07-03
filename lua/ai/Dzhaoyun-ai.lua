--[[
	太阳神三国杀武将扩展包·赵云合集（AI部分）
	适用版本：V2 - 终结版（版本号：20150926）
	说明：在extensions/Dzhaoyun.lua中修改palno取值可获得不同版本的赵云
		palno = 1 : 原标准版·赵云（龙胆）--<默认>
		palno = 2 : 台版·赵云（龙胆）
		palno = 3 : 3v3·赵云（龙胆、救主）
		palno = 4 : 标准版·赵云（龙胆、涯角）
		palno = 5 : 单挑测试·一起神云（绝境、龙魂）
		palno = 6 : 神·赵云（绝境、龙魂）
		palno = 7 : 翼·赵云（龙胆、义从）
		palno = 8 : JSP·赵云（赤心、随仁、义从） 
		palno = 9 : ☆SP·赵云（龙胆、冲阵）
		palno = 10 : 长坂坡·长坂坡圣骑（青釭、龙胆）
		palno = 11 : 长坂坡·不败神话（龙怒、浴血、龙吟、龙胆、青釭）
		palno = 12 : 测试·高达一号（绝境、龙魂）
]]--
--[[
	技能：青釭
	描述：你每造成1点伤害，你可以让目标选择弃掉一张手牌或者让你从其装备区获得一张牌。
]]--
--room:askForSkillInvoke(player, "DzhaoyunQingGang", data)
sgs.ai_skill_invoke["DzhaoyunQingGang"] = function(self, data)
	local damage = data:toDamage()
	local target = damage.to
	if self:isFriend(target) then
		if target:getArmor() and self:needToThrowArmor(target) then
			return true
		end
	else
		return true
	end
	return false
end
--room:askForDiscard(victim, "DzhaoyunQingGang", 1, 1, true, false, prompt)
--room:askForDiscard(victim, "DzhaoyunQingGang", 1, 1, false, false)
--room:askForCardChosen(player, victim, "e", "DzhaoyunQingGang")
--[[
	效果：聚气规则
	描述：在回合开始阶段之后，判定阶段之前，加入一个聚气阶段。在聚气阶段，你可以从牌堆顶亮出一张牌置于你的武将牌上，称之为“怒”。上限为4张，若超出4张，需立即选择一张弃置。无论拥有多少聚气技，只能翻一张牌作为“怒”。
]]--
--player:askForSkillInvoke("DzhaoyunJuQi", data)
sgs.ai_skill_invoke["DzhaoyunJuQi"] = true
--room:askForAG(player, pile, false, "DzhaoyunJuQiDiscard")
sgs.ai_skill_askforag["DzhaoyunJuQiDiscard"] = function(self, card_ids)
	for _,id in ipairs(card_ids) do
		local card = sgs.Sanguosha:getCard(id)
		if card:isBlack() then
			return id
		end
	end
	return card_ids[1]
end
--[[
	技能：龙怒（聚气技）
	描述：出牌阶段，你可以弃两张相同颜色的“怒”，若如此做，你使用的下一张【杀】不可被闪避。
]]--
local longnu_skill = {
	name = "DzhaoyunLongNu",
	getTurnUseCard = function(self, inclusive)
		local pile = self.player:getPile("DzhaoyunJuQiPile")
		local blacks, reds = {}, {}
		for _,id in sgs.qlist(pile) do
			local card = sgs.Sanguosha:getCard(id)
			if card:isRed() then
				table.insert(reds, id)
			elseif card:isBlack() then
				table.insert(blacks, id)
			end
		end
		if #blacks >= 2 then
			local card_str = string.format("#DzhaoyunLongNuCard:%s+%s:", blacks[1], blacks[2])
			return sgs.Card_Parse(card_str)
		elseif #reds >= 2 then
			local card_str = string.format("#DZhaoyunLongNuCard:%s+%s:", reds[1], reds[2])
			return sgs.Card_Parse(card_str)
		end
	end,
}
table.insert(sgs.ai_skills, longnu_skill)
sgs.ai_skill_use_func["#DzhaoyunLongNuCard"] = function(card, use, self)
	if not sgs.Slash_IsAvailable(self.player) then
		return nil
	elseif self:getCardsNum("Slash") == 0 then
		return
	elseif sgs.turncount <= 1 and self.role == "renegade" and sgs.isLordHealthy() then
		return
	end
	--Waiting For More Details
	use.card = card
end
--相关信息
sgs.ai_use_value["DzhaoyunLongNuCard"] = 2.7
sgs.ai_use_priority["DzhaoyunLongNuCard"] = sgs.ai_use_priority["Slash"] + 0.3
--[[
	技能：浴血（聚气技）
	描述：你可以将你的任意红桃或方片花色的“怒”当【桃】使用。
]]--
--DzhaoyunYuXue:Play
local yuxue_skill = {
	name = "DzhaoyunYuXue",
	getTurnUseCard = function(self, inclusive)
		if self.player:hasFlag("Global_PreventPeach") then
			return nil
		end
		local pile = self.player:getPile("DzhaoyunJuQiPile")
		for _,id in sgs.qlist(pile) do
			local red = sgs.Sanguosha:getCard(id)
			local suit = red:getSuitString()
			if suit == "heart" or suit == "diamond" then
				local point = red:getNumber()
				local card_str = string.format("peach:DzhaoyunYuXue[%s:%d]=%d", suit, point, id)
				return sgs.Card_Parse(card_str)
			end
		end
	end,
}
--DzhaoyunYuXue:Response
sgs.ai_view_as["DzhaoyunYuXue"] = function(card, player, card_place, class_name)
	if class_name == "Peach" and card_place == sgs.Player_PlaceSpecial then
		local suit = card:getSuitString()
		if suit == "heart" or suit == "diamond" then
			local point = card:getNumber()
			local id = card:getEffectiveId()
			return string.format("peach:DzhaoyunYuXue[%s:%d]=%d", suit, point, id)
		end
	end
end
--[[
	技能：龙吟（聚气技）
	描述：聚气阶段，你可以从牌堆顶亮出三张牌，选择其中一张做为“怒”，其余收为手牌。
]]--
--player:askForSkillInvoke("DzhaoyunLongYin")
sgs.ai_skill_invoke["DzhaoyunLongYin"] = true
--room:askForAG(player, ids, false, "DzhaoyunLongYin")
sgs.ai_skill_askforag["DzhaoyunLongYin"] = function(self, card_ids)
	local cards = {}
	for _,id in ipairs(card_ids) do
		local card = sgs.Sanguosha:getCard(id)
		table.insert(cards, card)
	end
	self:sortByUseValue(cards, true)
	return cards[1]:getEffectiveId()
end
--[[****************************************************************
	----------------------------------------------------------------
	---- 前！方！禁！区！请！注！意！------ 游！客！止！步！--------
	----------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	----------------------------------------------------------------
]]--****************************************************************
--[[****************************************************************
	隐藏武将AI等级设定
	0级：不发动任何虐杀技能（全凭本身性能作战）
	1级：不主动发动任何虐杀技能
	2级：只发动虐杀技能进行防御和回复
	3级：正常发动虐杀技能
	4级：必杀技解禁
	5级：超必杀技解禁
	6级：即死技解禁
]]--****************************************************************
AILv = 6
--[[****************************************************************
	隐藏武将：超神·赵云
]]--****************************************************************
--[[
	技能：龙魂
	描述：你可以将一张牌按如下规则使用或打出：♠当【无懈可击】，♥当【桃】，♣当【闪】，♦当火【杀】，
		【杀】当【万箭齐发】，【闪】当【桃园结义】，【桃】当【无中生有】，【酒】当【决斗】。
]]--
--DzhaoyunSuperLongHunCard:Play
local super_longhun_peach_skill = {
	name = "DzhaoyunSuperLongHun",
	getTurnUseCard = function(self, inclusive)
		if self.player:getLostHp() == 0 then
			return nil
		end
		local cards = self.player:getCards("he")
		local hearts = {}
		for _,c in sgs.qlist(cards) do
			if c:getSuit() == sgs.Card_Heart then
				if not c:isKindOf("Peach") then
					table.insert(hearts, c)
				end
			end
		end
		if #hearts == 0 then
			return nil
		end
		self:sortByUseValue(hearts, true)
		local heart = hearts[1]
		local point = heart:getNumber()
		local id = heart:getEffectiveId()
		local card_str = string.format("peach:DzhaoyunSuperLongHun[heart:%d]=%d", point, id)
		return sgs.Card_Parse(card_str)
	end,
}
local super_longhun_fs_skill = {
	name = "DzhaoyunSuperLongHun",
	getTurnUseCard = function(self, inclusive)
		if not sgs.Slash_IsAvailable(self.player) then
			return nil
		end
		local cards = self.player:getCards("he")
		local diamonds = {}
		for _,c in sgs.qlist(cards) do
			if c:getSuit() == sgs.Card_Diamond then
				if not c:isKindOf("FireSlash") then
					table.insert(diamonds, c)
				end
			end
		end
		if #diamonds == 0 then
			return nil
		end
		self:sortByUseValue(diamonds, true)
		local diamond = diamonds[1]
		local point = diamond:getNumber()
		local id = diamond:getEffectiveId()
		local card_str = string.format("fire_slash:DzhaoyunSuperLongHun[diamond:%d]=%d", point, id)
		return sgs.Card_Parse(card_str)
	end,
}
local super_longhun_aa_skill = {
	name = "DzhaoyunSuperLongHun",
	getTurnUseCard = function(self, inclusive)
		local cards = self.player:getHandcards()
		local slashes = {}
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("Slash") then
				table.insert(slashes, c)
			end
		end
		if #slashes == 0 then
			return nil
		end
		self:sortByKeepValue(slashes)
		local slash = slashes[1]
		local suit = slash:getSuitString()
		local point = slash:getNumber()
		local id = slash:getEffectiveId()
		local card_str = string.format("archery_attack:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
		return sgs.Card_Parse(card_str)
	end,
}
local super_longhun_gs_skill = {
	name = "DzhaoyunSuperLongHun",
	getTurnUseCard = function(self, inclusive)
		local cards = self.player:getHandcards()
		local jinks = {}
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("Jink") then
				table.insert(jinks, c)
			end
		end
		if #jinks == 0 then
			return nil
		end
		self:sortByKeepValue(jinks)
		local jink = jinks[1]
		local suit = jink:getSuitString()
		local point = jink:getNumber()
		local id = jink:getEffectiveId()
		local card_str = string.format("god_salvation:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
		return sgs.Card_Parse(card_str)
	end,
}
local super_longhun_en_skill = {
	name = "DzhaoyunSuperLongHun",
	getTurnUseCard = function(self, inclusive)
		if self:getOverflow() > 0 then
			return nil
		end
		local cards = self.player:getHandcards()
		local peaches = {}
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("Peach") then
				table.insert(peaches, c)
			end
		end
		if #peaches == 0 then
			return nil
		end
		self:sortByKeepValue(peaches)
		local peach = peaches[1]
		local suit = peach:getSuitString()
		local point = peach:getNumber()
		local id = peach:getEffectiveId()
		local card_str = string.format("ex_nihilo:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
		return sgs.Card_Parse(card_str)
	end,
}
local super_longhun_duel_skill = {
	name = "DzhaoyunSuperLongHun",
	getTurnUseCard = function(self, inclusive)
		local cards = self.player:getHandcards()
		local anals = {}
		for _,c in sgs.qlist(cards) do
			if c:isKindOf("Analeptic") then
				table.insert(anals, c)
			end
		end
		if #anals == 0 then
			return nil
		end
		self:sortByKeepValue(anals)
		local anal = anals[1]
		local suit = anal:getSuitString()
		local point = anal:getNumber()
		local id = anal:getEffectiveId()
		local card_str = string.format("duel:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
		return sgs.Card_Parse(card_str)
	end,
}
if AILv >= 2 then
table.insert(sgs.ai_skills, super_longhun_peach_skill)
table.insert(sgs.ai_skills, super_longhun_gs_skill)
table.insert(sgs.ai_skills, super_longhun_en_skill)
end
if AILv >= 3 then
table.insert(sgs.ai_skills, super_longhun_fs_skill)
table.insert(sgs.ai_skills, super_longhun_aa_skill)
table.insert(sgs.ai_skills, super_longhun_duel_skill)
end
--DzhaoyunSuperLongHunCard:Response
sgs.ai_view_as["DzhaoyunSuperLongHun"] = function(card, player, card_place, class_name)
	if class_name == "Nullification" then
		if card:getSuit() == sgs.Card_Spade and not card:isKindOf("Nullification") then
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("nullification:DzhaoyunSuperLongHun[spade:%d]=%d", point, id)
			return card_str
		end
	elseif class_name == "Peach" then
		if card:getSuit() == sgs.Card_Heart and not card:isKindOf("Peach") then
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("peach:DzhaoyunSuperLongHun[heart:%d]=%d", point, id)
			return card_str
		end
	elseif class_name == "Jink" then
		if card:getSuit() == sgs.Card_Club and not card:isKindOf("Jink") then
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("jink:DzhaoyunSuperLongHun[club:%d]=%d", point, id)
			return card_str
		end
	elseif class_name == "FireSlash" or class_name == "Slash" then
		if card:getSuit() == sgs.Card_Diamond and not card:isKindOf("FireSlash") then
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("fire_slash:DzhaoyunSuperLongHun[diamond:%d]=%d", point, id)
			return card_str
		end
	elseif class_name == "ArcheryAttack" then
		if card:isKindOf("Slash") then
			local suit = card:getSuitString()
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("archery_attack:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
			return card_str
		end
	elseif class_name == "GodSalvation" then
		if card:isKindOf("Jink") then
			local suit = card:getSuitString()
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("god_salvation:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
			return card_str
		end
	elseif class_name == "ExNihilo" then
		if card:isKindOf("Peach") then
			local suit = card:getSuitString()
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("ex_nihilo:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
			return card_str
		end
	elseif class_name == "Duel" then
		if card:isKindOf("Analeptic") then
			local suit = card:getSuitString()
			local point = card:getNumber()
			local id = card:getEffectiveId()
			local card_str = string.format("duel:DzhaoyunSuperLongHun[%s:%d]=%d", suit, point, id)
			return card_str
		end
	end
end
if AILv == 0 then
sgs.ai_view_as["DzhaoyunSuperLongHun"] = nil
end
--room:askForChoice(user, "DzhaoyunSuperLongHun", choices)
sgs.ai_skill_choice["DzhaoyunSuperLongHun"] = function(self, choices, data)
	local choice = sgs.Dzhaoyun_SuperLongHun_Choice
	local items = choices:split("+")
	if choice then
		sgs.Dzhaoyun_SuperLongHun_Choice = nil
		for _,item in ipairs(items) do
			if item == choice then
				return item
			end
		end
	end
	return "cancel"
end
--room:askForUseCard(source, "@@DzhaoyunSuperLongHun", prompt)
sgs.ai_skill_use_func["@@DzhaoyunSuperLongHun"] = function(self, prompt, method)
	local name = self.player:property("DzhaoyunSuperLongHunCardName"):toString()
	local suit = self.player:getMark("DzhaoyunSuperLongHunSuit")
	local point = self.player:getMark("DzhaoyunSuperLongHunPoint")
	local id = self.player:getMark("DzhaoyunSuperLongHunID")
	local card = sgs.Sanguosha:cloneCard(name, suit, point)
	card:addSubcard(id)
	card:setSkillName("DzhaoyunSuperLongHun")
	card:deleteLater()
	dummy_use = {
		isDummy = true,
		to = sgs.SPlayerList(),
	}
	if card:isKindOf("BasicCard") then
		self:useBasicCard(card, dummy_use)
	elseif card:isKindOf("TrickCard") then
		self:useTrickCard(card, dummy_use)
	end
	if dummy_use.card then
		local targets = {}
		for _,target in ipairs(dummy_use.to) do
			table.insert(targets, target:objectName())
		end
		targets = table.concat(targets, "+")
		if targets == "" then
			targets = "."
		end
		local use_str = "#DzhaoyunSuperLongHunSelectCard:.:->"..targets
		return use_str
	end
	return "."
end
--相关信息
sgs.ai_use_value["DzhaoyunSuperLongHunCard"] = 3.7
sgs.ai_use_priority["DzhaoyunSuperLongHunCard"] = 6.3
--[[****************************************************************
	隐藏武将：无上·神云
]]--****************************************************************
--[[
	技能：龙魂
	描述：出牌阶段限七次，你可以将X张（X至少为1）相同花色的牌正面向上交给一名角色，然后该角色按如下规则执行相应的效果：
		♠：受到2X点雷电伤害；♥：回复2X点体力；♣：跳过2X个回合；
		♦：使用2X张牌之前，若成为【杀】或【决斗】的目标，由使用者代替之。
]]--
--DzhaoyunUltraLongHunCard:
local ultra_longhun_skill = {
	name = "DzhaoyunUltraLongHun",
	getTurnUseCard = function(self, inclusive)
		if self.player:usedTimes("#DzhaoyunUltraLongHunCard") < 7 then
			if self.player:isNude() then
				return nil
			end
			return sgs.Card_Parse("#DzhaoyunUltraLongHunCard:.:")
		end
	end,
}
if AILv >= 2 then
table.insert(sgs.ai_skills, ultra_longhun_skill)
end
sgs.ai_skill_use_func["#DzhaoyunUltraLongHunCard"] = function(card, use, self)
	local cards = self.player:getCards("he")
	local spades, hearts, clubs, diamonds = {}, {}, {}, {}
	for _,c in sgs.qlist(cards) do
		local suit = c:getSuit()
		if suit == sgs.Card_Spade then
			table.insert(spades, c)
		elseif suit == sgs.Card_Heart then
			table.insert(hearts, c)
		elseif suit == sgs.Card_Club then
			table.insert(clubs, c)
		elseif suit == sgs.Card_Diamond then
			table.insert(diamonds, c)
		end
	end
	if #hearts > 0 then
		local target = nil
		self:sort(self.friends, "defense")
		local need = 0
		for _,friend in ipairs(self.friends) do
			local lost = friend:getLostHp()
			if lost > 0 then
				need = math.ceil(lost / 2)
				target = friend
				break
			end
		end
		if target then
			self:sortByKeepValue(hearts)
			local to_use = {}
			for i=1, math.min(#hearts, need), 1 do
				table.insert(to_use, hearts[i]:getEffectiveId())
			end
			local card_str = "#DzhaoyunUltraLongHunCard:"..table.concat(to_use, "+")..":"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			if use.to then
				use.to:append(target)
			end
			return
		end
	end
	local targetB, card_strB = nil, nil
	if #spades > 0 and #self.enemies > 0 and AILv >= 4 then
		local extra_damage = 0
		local nature = sgs.DamageStruct_Thunder
		local fire, water = false, false
		local JinXuanDi = self.room:findPlayerBySkillName("wuling")
		if JinXuanDi then
			if JinXuanDi:getMark("@thunder") > 0 then
				extra_damage = extra_damage + 1
			elseif JinXuanDi:getMark("@fire") > 0 then
				fire = true
				nature = sgs.DamageStruct_Fire
			elseif JinXuanDi:getMark("@water") > 0 then
				water = true
			end
		end
		self:sort(self.enemies, "threat")
		local flag = ( self.role == "renegade" and self.room:alivePlayerCount() > 2 )
		for _,enemy in ipairs(self.enemies) do
			if flag and enemy:isLord() then
			elseif self:damageIsEffective(enemy, nature, nil) then
				local max_damage = extra_damage
				if enemy:hasSkill("chouhai") and enemy:isKongcheng() then
					max_damage = max_damage + 1
				end
				if fire then
					if enemy:hasArmorEffect("vine") or enemy:hasArmorEffect("gale_shell") then
						max_damage = max_damage + 1
					end
				end
				local groupA, groupB, groupC = {}, {}, {}
				local damageA, damageB, damageC = 0, 0, 0
				if enemy:hasSkill("manjuan") then
					groupA = spades
				else
					for _,c in ipairs(spades) do
						if isCard("Peach", c, enemy) then
							table.insert(groupC, c)
						elseif isCard("Analeptic", c, enemy) then
							table.insert(groupB, c)
						else
							table.insert(groupA, c)
						end
					end
				end
				if water then
					damageA, damageB, damageC = 2 * #groupA, #groupB, 0
				else
					damageA, damageB, damageC = 2 * #groupA, #groupB, #groupC
				end
				max_damage = max_damage + damageA + damageB + damageC
				if max_damage > 1 and enemy:hasArmorEffect("silver_lion") then
					max_damage = 1
				end
				local hp = enemy:getHp()
				local peach, need_damage = 0, hp
				local buqu_flag, death_flag = false, false
				if enemy:hasSkill("buqu") then
					max_damage = math.min(max_damage, hp)
					buqu_flag = true
				end
				if max_damage >= hp then
					peach = self:getAllPeachNum(enemy)
					need_damage = hp + peach
					if max_damage >= need_damage then
						death_flag = true
					end
				end
				if death_flag then
					local to_use = {}
					if damageA >= need_damage then
						self:sortByKeepValue(groupA)
						for i=1, math.ceil(need_damage / 2), 1 do
							table.insert(to_use, groupA[i]:getEffectiveId())
						end
					else
						for _,c in ipairs(groupA) do
							table.insert(to_use, c:getEffectiveId())
						end
						need_damage = need_damage - damageA
						if damageB >= need_damage then
							self:sortByKeepValue(groupB)
							for i=1, need_damage, 1 do
								table.insert(to_use, groupB[i]:getEffectiveId())
							end
						else
							for _,c in ipairs(groupB) do
								table.insert(to_use, c:getEffectiveId())
							end
							if damageC > 0 then
								need_damage = need_damage - damageB
								for i=1, need_damage, 1 do
									table.insert(to_use, groupC[i]:getEffectiveId())
								end
							end
						end
					end
					local card_str = "#DzhaoyunUltraLongHunCard:"..table.concat(to_use, "+")..":"
					local acard = sgs.Card_Parse(card_str)
					use.card = acard
					if use.to then
						use.to:append(enemy)
					end
					return
				elseif not targetB then
					targetB = enemy
					local to_use = {}
					for _,c in ipairs(groupA) do
						table.insert(to_use, c:getEffectiveId())
					end
					card_strB = "#DzhaoyunUltraLongHunCard:"..table.concat(to_use, "+")..":"
				end
			end
		end
	end
	if #clubs > 0 and #self.enemies > 0 and AILv >= 3 then
		self:sort(self.enemies, "threat")
		self:sortByKeepValue(clubs)
		for _,enemy in ipairs(self.enemies) do
			if enemy:getMark("UltraLongHunSkipTurnCount") == 0 then
				local to_use = {}
				local isWeak = self:isWeak(enemy)
				for _,c in ipairs(clubs) do
					if isCard("Peach", c, enemy) then
					elseif isCard("Nullification", c, enemy) then
					elseif isWeak and isCard("Analeptic", c, enemy) then
					else
						table.insert(to_use, c:getEffectiveId())
					end
				end
				if #to_use > 0 then
					local card_str = "#DzhaoyunUltraLongHunCard:"..table.concat(to_use, "+")..":"
					local acard = sgs.Card_Parse(card_str)
					use.card = acard
					if use.to then
						use.to:append(enemy)
					end
					return
				end
			end
		end
	end
	if #diamonds > 0 then
		local target = nil
		if self.player:getMark("UltraLongHunRestProtectCount") == 0 then
			target = self.player
		else
			self:sort(self.friends, "defense")
			for _,friend in ipairs(self.friends) do
				if friend:getMark("UltraLongHunRestProtectCount") == 0 then
					target = friend
					break
				end
			end
		end
		target = target or self.friends[1]
		if target then
			local to_use = {}
			if target:objectName() == self.player:objectName() then
				for _,c in ipairs(diamonds) do
					table.insert(to_use, c:getEffectiveId())
				end
			elseif target:getMark("UltraLongHunRestProtectCount") < 50 then
				self:sortByUseValue(diamonds)
				local equips, handequips, will_use, not_will_use, will_keep = {}, {}, {}, {}, {}
				local slash_checked, slash_avail, need_crossbow = 0, 1, false
				if self:hasCrossbowEffect() then
					slash_avail = 1000
					if not self.player:hasSkill("paoxiao") then
						if self:getCardsNum("Slash") > 1 then
							need_crossbow = true
						end
					end
				end
				for _,c in ipairs(diamonds) do
					local id = c:getEffectiveId()
					if self.room:getCardPlace(id) == sgs.Player_PlaceHand then
						if c:isKindOf("EquipCard") then
							table.insert(handequips, c)
						elseif c:isKindOf("Nullification") or c:isKindOf("Jink") then
							table.insert(will_keep, c)
						elseif c:isKindOf("TrickCard") then
							local dummy_use = {
								isDummy = true,
							}
							self:useTrickCard(c, dummy_use)
							if dummy_use.card then
								table.insert(will_use, c)
								return nil -- use card first
							else
								table.insert(not_will_use)
							end
						elseif c:isKindOf("BasicCard") then
							if slash_checked >= slash_avail and c:isKindOf("Slash") then
								table.insert(not_will_use, c)
							else
								local dummy_use = {
									isDummy = true,
								}
								self:useBasicCard(c, dummy_use)
								if dummy_use.card then
									table.insert(will_use, c)
									if c:isKindOf("Slash") then
										slash_checked = slash_checked + 1
									end
									return nil -- use card first
								elseif c:isKindOf("Peach") or c:isKindOf("Analeptic") then
									table.insert(will_keep, c)
								else
									table.insert(not_will_use, c)
								end
							end
						end
					else
						if need_crossbow and c:isKindOf("Crossbow") then
						else
							table.insert(equips, c)
						end
					end
				end
				if target:hasSkill("manjuan") then
					if #not_will_use > 0 then
						for _,c in ipairs(not_will_use) do
							table.insert(to_use, c:getEffectiveId())
						end
					elseif #equips > 0 and #handequips > 0 then
						for _,c in ipairs(equips) do
							table.insert(to_use, c:getEffectiveId())
						end
					elseif #will_keep > 2 then
						self:sortByKeepValue(will_keep)
						table.insert(to_use, will_keep[1]:getEffectiveId())
					end
				else
					if #not_will_use > 0 then
						for _,c in ipairs(not_will_use) do
							table.insert(to_use, c:getEffectiveId())
						end
					end
					if #equips > 0 then
						if #handequips > 0 or self:hasSkills(sgs.lose_equip_skill) then
							for _,c in ipairs(equips) do
								table.insert(to_use, c:getEffectiveId())
							end
						end
					end
					if #will_keep > 0 then
						--self:sortByKeepValue(will_keep)
						for _,c in ipairs(will_keep) do
							table.insert(to_use, c:getEffectiveId())
						end
					end
				end
			end
			if #to_use > 0 then
				local card_str = "#DzhaoyunUltraLongHunCard:"..table.concat(to_use, "+")..":"
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(target)
				end
			end
		end
	end
	if targetB and card_strB then
		local acard = sgs.Card_Parse(card_strB)
		use.card = acard
		if use.to then
			use.to:append(targetB)
		end
	end
end
--[[****************************************************************
	隐藏武将：BUG·云
]]--****************************************************************
--[[
	技能：劫云（必杀技）
	描述：出牌阶段，你可以弃置至少1张雷【杀】或【闪电】，令一名角色受到X点雷电伤害（X为你弃置牌的点数之和）。若你弃置的牌中有【闪电】，此伤害额外结算3次。
]]--
--room:askForPlayerChosen(source, alives, "BugJieYun", prompt, false, true)
sgs.ai_skill_playerchosen["BugJieYun"] = function(self, targets)
	local x = self.player:getMark("BugJieYunDamage_ForAI")
	local times = self.player:getMark("BugJieYunDamageTimes_ForAI")
	local enemies = {}
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			if p:isLord() and self.role == "renegade" then
				if x * times < p:getHp() then
					table.insert(enemies, p)
				end
			else
				table.insert(enemies, p)
			end
		end
	end
	if #enemies > 0 then
		self:sort(enemies, "threat")
		local others = {}
		for _,enemy in ipairs(enemies) do
			if self:damageIsEffective(enemy, sgs.DamageStruct_Thunder, nil) then
				if enemy:getHp() <= x * times then
					return enemy
				else
					table.insert(others, enemy)
				end
			end
		end
		if #others > 0 then
			self:sort(others, "defense")
			return others[1]
		end
	end
end
--BugJieYunCard:Play
local jieyun_skill = {
	name = "BugJieYun",
	getTurnUseCard = function(self, inclusive)
		if #self.enemies == 0 then
			return nil
		elseif self.player:isKongcheng() then
			return nil
		end
		return sgs.Card_Parse("#BugJieYunCard:.:")
	end,
}
if AILv >= 4 then
table.insert(sgs.ai_skills, jieyun_skill)
end
sgs.ai_skill_use_func["#BugJieYunCard"] = function(card, use, self)
	local thunder, lightning = {}, {}
	local handcards = self.player:getHandcards()
	for _,c in sgs.qlist(handcards) do
		if c:isKindOf("ThunderSlash") then
			if self.player:canDiscard(self.player, c:getEffectiveId()) then
				table.insert(thunder, c)
			end
		elseif c:isKindOf("Lightning") then
			if self.player:canDiscard(self.player, c:getEffectiveId()) then
				table.insert(lightning, c)
			end
		end
	end
	if #thunder == 0 and #lightning == 0 then
		return
	end
	self:sort(self.enemies, "threat")
	local targets = {}
	local flag = ( self.role == "renegade" and self.room:alivePlayerCount() > 2 )
	local JinXuanDi = self.room:findPlayerBySkillName("wuling")
	local extra_damage, fire = 0, false
	if JinXuanDi then
		if JinXuanDi:getMark("@thunder") > 0 then
			extra_damage = 1
		elseif JinXuanDi:getMark("@fire") > 0 then
			fire = true
		end
	end
	local nature = fire and sgs.DamageStruct_Fire or sgs.DamageStruct_Thunder 
	for _,enemy in ipairs(self.enemies) do
		if self:damageIsEffective(enemy, nature, nil) then
			if flag and enemy:isLord() then
			else
				table.insert(targets, enemy)
			end
		end
	end
	if #targets == 0 then
		return
	end
	local times = 1
	local maxpointlt = 0
	if #lightning > 0 then
		times = times + 3
		self:sortByKeepValue(lightning)
		for _,lt in ipairs(lightning) do
			local point = lt:getNumber()
			if point > maxpointlt then
				maxpointlt = point
			end
		end
	end
	local sumts = 0
	if #thunder > 0 then
		self:sortByKeepValue(thunder)
		for _,ts in ipairs(thunder) do
			sumts = sumts + ts:getNumber()
		end
	end
	local can_damage = (sumts + maxpointlt) * times
	local target, target2 = nil, nil
	local need_damage = 0
	for _,enemy in ipairs(targets) do
		local hp = enemy:getHp()
		local peach = self:getAllPeachNum(enemy)
		local damage = can_damage + extra_damage
		if enemy:isKongcheng() and enemy:hasSkill("chouhai") then
			damage = damage + 1
		end
		if file then
			if enemy:hasArmorEffect("gale_shell") or enemy:hasArmorEffect("vine") then
				damage = damage + 1
			end
		end
		if damage > 1 and enemy:hasArmorEffect("silver_lion") then
			damage = 1
		end
		if hp + peach > damage then
			target2 = target2 or enemy
		else
			target = enemy
			need_damage = hp + peach
			break
		end
	end
	local to_use = {}
	if target then
		if times == 1 then
			local sum = 0
			for _,c in ipairs(thunder) do
				local point = c:getNumber()
				sum = sum + point
				table.insert(to_use, c:getEffectiveId())
				if sum >= need_damage then
					break
				end
			end
		else
			need_point = math.ceil( need_damage / times )
			for index, lt in ipairs(lightning) do
				local need_ts_point = need_point - lt:getNumber()
				local temp_use = {lt:getEffectiveId()}
				for _,c in ipairs(thunder) do
					if need_ts_point <= 0 then
						break
					end
					need_ts_point = need_ts_point - c:getNumber()
					table.insert(temp_use, c:getEffectiveId())
				end
				if need_ts_point <= 0 then
					to_use = temp_use
					break
				end
			end
		end
	elseif target2 then
		target = target2
		for _,c in ipairs(thunder) do
			table.insert(to_use, c:getEffectiveId())
		end
		for _,c in ipairs(lightning) do
			table.insert(to_use, c:getEffectiveId())
		end
	end
	if target and #to_use > 0 then
		local card_str = "#BugJieYunCard:"..table.concat(to_use, "+")..":"
		local acard = sgs.Card_Parse(card_str)
		use.card = acard
		sgs.AI_BugJieYun_Target = target:objectName()
	end
end
--room:askForPlayerChosen(source, alives, "BugJieYun", prompt, false, true)
sgs.ai_skill_playerchosen["BugJieYun"] = function(self, targets)
	local name = sgs.AI_BugJieYun_Target
	if name then
		sgs.AI_BugJieYun_Target = nil
		for _,target in sgs.qlist(targets) do
			if target:objectName() == name then
				return target
			end
		end
	end
	local enemies, unknowns = {}, {}
	for _,p in sgs.qlist(targets) do
		if self:isEnemy(p) then
			table.insert(enemies, p)
		elseif self:isFriend(p) then
		else
			table.insert(unknowns, p)
		end
	end
	if #enemies > 0 then
		self:sort(enemies, "threat")
		return enemies[1]
	end
	if #unknowns > 0 then
		self:sort(unknowns, "threat")
		return unknowns[1]
	end
	return targets:first()
end
--相关信息
sgs.ai_use_value["BugJieYunCard"] = 10
sgs.ai_use_priority["BugJieYunCard"] = ( sgs.ai_use_priority["ThunderSlash"] or 7.2 ) + 0.1
--[[
	技能：龙威（超必杀技）
	描述：出牌阶段限一次，你可以弃置至多四张不同花色的牌，将一名其他角色的某项数值重置为零：
		无 - 对其的距离；♠ - 每次伤害数；♥ - 每次回复数；♣ - 当前装备数：
		♦ - 当前手牌数；♠♣ - 当前体力值；♥♦ - 手牌上限；♥♣♦ - 剩余回合数；
		♠♣♦ - 每阶段可用牌数；♠♥♦ - 每次摸牌数；♠♥♣ - 技能数；♠♥♣♦ - 体力上限。
]]--
--BugLongWeiCard:Play
local longwei_skill = {
	name = "BugLongWei",
	getTurnUseCard = function(self, inclusive)
		if #self.enemies > 0 then
			if not self.player:hasUsed("#BugLongWeiCard") then
				return sgs.Card_Parse("#BugLongWeiCard:.:")
			end
		end
	end,
}
if AILv >= 3 then
table.insert(sgs.ai_skills, longwei_skill)
end
sgs.ai_skill_use_func["#BugLongWeiCard"] = function(card, use, self)
	local cards = self.player:getCards("he")
	local spade, heart, club, diamond = nil, nil, nil, nil
	local spades, hearts, clubs, diamonds = {}, {}, {}, {}
	for _,c in sgs.qlist(cards) do
		local suit = c:getSuit()
		if suit == sgs.Card_Spade then
			table.insert(spades, c)
		elseif suit == sgs.Card_Heart then
			table.insert(hearts, c)
		elseif suit == sgs.Card_Club then
			table.insert(clubs, c)
		elseif suit == sgs.Card_Diamond then
			table.insert(diamonds, c)
		end
	end
	if #spades > 0 then
		self:sortByUseValue(spades, true)
		for _,c in ipairs(spades) do
			local id = c:getEffectiveId()
			if self.player:canDiscard(self.player, id) then
				spade = id
				break
			end
		end
	end
	if #hearts > 0 then
		self:sortByKeepValue(hearts)
		for _,c in ipairs(hearts) do
			local id = c:getEffectiveId()
			if self.player:canDiscard(self.player, id) then
				heart = id
				break
			end
		end
	end
	if #clubs > 0 then
		self:sortByUseValue(clubs, true)
		for _,c in ipairs(clubs) do
			local id = c:getEffectiveId()
			if self.player:canDiscard(self.player, id) then
				club = id
				break
			end
		end
	end
	if #diamonds > 0 then
		self:sortByKeepValue(diamonds)
		for _,c in ipairs(diamonds) do
			local id = c:getEffectiveId()
			if self.player:canDiscard(self.player, id) then
				diamond = id
				break
			end
		end
	end
	self:sort(self.enemies, "threat")
	local flag = ( self.role == "renegade" and self.room:alivePlayerCount() > 2 )
	if spade and heart and club and diamond and AILv >= 5 then
		for _,enemy in ipairs(self.enemies) do
			if flag and enemy:isLord() then
			else
				local card_str = string.format("#BugLongWeiCard:%s+%s+%s+%s:", spade, heart, club, diamond)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if spade and heart and club and AILv >= 4 then
		for _,enemy in ipairs(self.enemies) do
			local skills = enemy:getVisibleSkillList()
			if not skills:isEmpty() then
				local card_str = string.format("#BugLongWeiCard:%s+%s+%s:", spade, heart, club)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if spade and heart and diamond and AILv >= 4 then
		for _,enemy in ipairs(self.enemies) do
			if enemy:getMark("BugLongWeiZeroDraw") == 0 then
				local card_str = string.format("#BugLongWeiCard:%s+%s+%s:", spade, heart, diamond)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if spade and club and diamond and AILv >= 4 then
		for _,enemy in ipairs(self.enemies) do
			if enemy:getMark("BugLongWeiZeroPlay") == 0 then
				local card_str = string.format("#BugLongWeiCard:%s+%s+%s:", spade, club, diamond)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if heart and club and diamond and AILv >= 5 then
		for _,enemy in ipairs(self.enemies) do
			if enemy:getMark("BugLongWeiZeroTurn") == 0 then
				local card_str = string.format("#BugLongWeiCard:%s+%s+%s:", heart, club, diamond)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if heart and diamond then
		for _,enemy in ipairs(self.enemies) do
			if enemy:getMark("BugLongWeiZeroMaxCards") == 0 then
				local card_str = string.format("#BugLongWeiCard:%s+%s:", heart, diamond)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if spade and club and AILv >= 4 then
		for _,enemy in ipairs(self.enemies) do
			if flag and enemy:isLord() then
			elseif enemy:getHp() > 0 then
				local card_str = string.format("#BugLongWeiCard:%s+%s:", spade, club)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if spade then
		for _,enemy in ipairs(self.enemies) do
			if enemy:getMark("BugLongWeiZeroDamage") == 0 then
				local card_str = string.format("#BugLongWeiCard:%s:", spade)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if heart and AILv >= 4 then
		for _,enemy in ipairs(self.enemies) do
			if flag and enemy:isLord() then
			elseif enemy:getMark("BugLongWeiZeroRecover") == 0 then
				local card_str = string.format("#BugLongWeiCard:%s:", heart)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	if club then
		for _,enemy in ipairs(self.enemies) do
			if enemy:hasEquip() then
				if self:hasSkills(sgs.lose_equip_skill) then
				elseif enemy:getArmor() and self:needToThrowArmor() then
				else
					local card_str = string.format("#BugLongWeiCard:%s:", club)
					local acard = sgs.Card_Parse(card_str)
					use.card = acard
					if use.to then
						use.to:append(enemy)
					end
					return
				end
			end
		end
	end
	if diamond then
		for _,enemy in ipairs(self.enemies) do
			if enemy:isKongcheng() then
			elseif self:hasLoseHandcardEffective(enemy) then
			else
				local card_str = string.format("#BugLongWeiCard:%s:", diamond)
				local acard = sgs.Card_Parse(card_str)
				use.card = acard
				if use.to then
					use.to:append(enemy)
				end
				return
			end
		end
	end
	for _,enemy in ipairs(self.enemies) do
		if enemy:getMark("BugLongWeiZeroDist") == 0 then
			local card_str = "#BugLongWeiCard:.:"
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			if use.to then
				use.to:append(enemy)
			end
			return
		end
	end
end
--相关信息
sgs.ai_use_value["BugLongWeiCard"] = 999
sgs.ai_use_priority["BugLongWeiCard"] = 999
--[[
	技能：锋灵（即死技）
	描述：出牌阶段限一次，你可以翻开牌堆顶的X+1张牌，令一名与你距离最近的其他角色依次弃置等量同类型的牌。若该角色不能如此做，你令其立即死亡（X为场上存活角色数）。
]]--
--BugFengLingCard:Play
local fengling_skill = {
	name = "BugFengLing",
	getTurnUseCard = function(self, inclusive)
		if self.player:hasUsed("#BugFengLingCard") then
			return nil
		elseif #self.enemies == 0 then
			return nil
		end
		return sgs.Card_Parse("#BugFengLingCard:.:")
	end,
}
if AILv >= 6 then
table.insert(sgs.ai_skills, fengling_skill)
end
sgs.ai_skill_use_func["#BugFengLingCard"] = function(card, use, self)
	self:sort(self.enemies, "threat")
	local flag = false
	if self.role == "renegade" and self.room:alivePlayerCount() > 2 then
		flag = true
	end
	local targets = {}
	local others = self.room:getOtherPlayers(self.player)
	local minDist = 9999
	for _,p in sgs.qlist(others) do
		local dist = self.player:distanceTo(p)
		if dist < minDist then
			targets = {p}
			minDist = dist
		elseif dist == minDist then
			table.insert(targets, p)
		end
	end
	for _,enemy in ipairs(targets) do
		if flag and enemy:isLord() then
		elseif self:isEnemy(enemy) then
			local card_str = "#BugFengLingCard:.:->"..enemy:objectName()
			local acard = sgs.Card_Parse(card_str)
			use.card = acard
			if use.to then
				use.to:append(enemy)
			end
			return 
		end
	end
end
--room:askForCard(victim, pattern, prompt)
--相关信息
sgs.ai_use_value["BugFengLingCard"] = 9999
sgs.ai_use_priority["BugFengLingCard"] = 0.001