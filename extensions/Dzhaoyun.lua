--[[
	太阳神三国杀武将扩展包·赵云合集
	适用版本：V2 - 终结版（版本号：20150926）
	说明：修改palno取值可获得不同版本的赵云
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
module("extensions.Dzhaoyun", package.seeall)
extension = sgs.Package("Dzhaoyun", sgs.Package_GeneralPack)
--翻译信息
sgs.LoadTranslationTable{
	["Dzhaoyun"] = "赵云合集",
}
--[[****************************************************************
	武将配置
]]--****************************************************************
palno = 1
--[[****************************************************************
	基本信息
]]--****************************************************************
--称号
local info = {
	"少年将军", "少年将军", "虎威将军", "虎威将军", "神威如龙", "神威如龙",
	"少年将军", "常山的游龙", "白马先锋", "长坂坡圣骑", "不败神话", "神威如龙",
}
--色表检测
if not info[palno] then
	palno = 1
end
--名称
local name = string.format("Dzhaoyun%dP", palno)
--势力
local kingdom = "shu"
if palno == 5 or palno == 6 or palno >= 10 then
	kingdom = "god"
elseif palno == 9 then
	kingdom = "qun"
end
--体力上限
local maxhp = 4
if palno == 5 or palno == 6 then
	maxhp = 2
elseif palno == 8 or palno == 9 then
	maxhp = 3
elseif palno == 10 then
	maxhp = 8
elseif palno == 12 then
	maxhp = 1
end
--武将
ZhaoYun = sgs.General(extension, name, kingdom, maxhp)
--设计者
local designer = "官方"
if palno == 7 then
	designer = "凌天翼"
elseif palno == 9 then
	designer = "Danny"
elseif palno == 10 or palno == 11 then
	designer = "洛神工作室"
end
--配音
local cv = "官方"
if palno == 5 or palno == 6 or palno == 12 then
	cv = "猎狐"
elseif palno == 9 then
	cv = "墨宣砚韵"
elseif palno == 10 or palno == 11 then
	cv = "黄昏"
end
--画师
local illustrator = "KayaK"
if palno == 2 then
	illustrator = "湯翔麟"
elseif palno == 4 then
	illustrator = "DH"
elseif palno == 9 then
	illustrator = "Vincent"
elseif palno == 10 or palno == 11 then
	illustrator = "洛神工作室"
elseif palno == 12 then
	illustrator = "巴萨小马"
end
--阵亡台词
local death = "武将 赵云 的阵亡台词"
if palno == 1 then
	death = "这就是失败的滋味吗？"
elseif palno == 2 or palno == 3 or palno == 4 or palno == 7 or palno == 8 then
	death = "你们谁……还敢再上？"
elseif palno == 5 or palno == 6 or palno == 12 then
	death = "血染鳞甲，龙坠九天……"
elseif palno == 9 then
	death = "力量不及，请原谅……"
end
--翻译信息
sgs.LoadTranslationTable{
	[name] = "赵云"..palno.."P",
	["&"..name] = "赵云",
	["#"..name] = info[palno],
	["designer:"..name] = designer,
	["cv:"..name] = cv,
	["illustrator:"..name] = illustrator,
	["~"..name] = death,
}
--[[****************************************************************
	技能效果
]]--****************************************************************
--[[
	技能：龙胆
	描述：你可以将一张【杀】当【闪】使用或打出，或将一张【闪】当普通【杀】使用或打出。 
]]--
if palno <= 4 or palno == 7 or palno == 9 or palno == 10 or palno == 11 then
	ZhaoYun:addSkill("longdan")
end
--[[
	技能：救主
	描述：每当一名其他己方角色处于濒死状态时，若你的体力值大于1，你可以失去1点体力并弃置一张牌：若如此做，该角色回复1点体力。
]]--
if palno == 3 then
	ZhaoYun:addSkill("jiuzhu")
end
--[[
	技能：涯角
	描述：每当你于回合外使用或打出手牌时，你可以展示牌堆顶的一张牌：若此牌与你使用或打出的手牌类别相同，你可以令一名角色获得之，否则你可以将之置入弃牌堆。
]]--
if palno == 4 then
	ZhaoYun:addSkill("yajiao")
end
--[[
	效果：单挑准备
	描述：游戏开始时，你将体力重置为1点。
]]--
if palno == 5 then
	Dzhaoyun5PEffect = sgs.CreateTriggerSkill{
		name = "#Dzhaoyun5PEffect",
		frequency = sgs.Skill_Compulsory,
		events = {sgs.GameStart, sgs.TurnStart},
		on_trigger = function(self, event, player, data)
			if player:getMark("Dzhaoyun5PEffect") == 0 then
				local room = player:getRoom()
				local msg = sgs.LogMessage()
				msg.type = "#Dzhaoyun5PEffectTrigger"
				msg.from = player
				msg.arg = 1
				room:sendLog(msg) --发送提示信息
				room:setPlayerProperty(player, "hp", sgs.QVariant(1))
				room:detachSkillFromPlayer(player, "#Dzhaoyun5PEffect")
				room:setPlayerMark(player, "Dzhaoyun5PEffect", 1)
			end
			return false
		end,
	}
	ZhaoYun:addSkill(Dzhaoyun5PEffect)
	sgs.LoadTranslationTable{
		["#Dzhaoyun5PEffectTrigger"] = "%from 将体力重置为 %arg",
	}
end
--[[
	技能：绝境（锁定技）
	描述：摸牌阶段，你额外摸X张牌。你的手牌上限+2。（X为你已损失的体力值）
]]--
if palno == 5 or palno == 6 then
	ZhaoYun:addSkill("juejing")
end
--[[
	技能：龙魂
	描述：你可以将X张同花色的牌按以下规则使用或打出：♥当【桃】；♦当火【杀】；♠当【无懈可击】；♣当【闪】。（X为你的体力值且至少为1）
]]--
if palno == 5 or palno == 6 then
	ZhaoYun:addSkill("longhun")
end
--[[
	技能：赤心
	描述：你可以将一张♦牌当【杀】或【闪】使用或打出。出牌阶段，你对此阶段内你没有对其使用过【杀】，且在你攻击范围内的角色使用【杀】无次数限制。
]]--
if palno == 8 then
	ZhaoYun:addSkill("chixin")
end
--[[
	技能：随仁（限定技）
	描述：准备阶段开始时，你可以失去技能“义从”，然后加1点体力上限并回复1点体力，再令一名角色摸三张牌。
]]--
if palno == 8 then
	ZhaoYun:addSkill("suiren")
end
--[[
	技能：义从（锁定技）
	描述：若你的体力值大于2，你与其他角色的距离-1；若你的体力值小于或等于2，其他角色与你的距离+1。
]]--
if palno == 7 or palno == 8 then
	ZhaoYun:addSkill("yicong")
	ZhaoYun:addSkill("#yicong-effect")
end
--[[
	技能：冲阵
	描述：每当你发动“龙胆”使用或打出一张手牌时，你可以获得对方的一张手牌。
]]--
if palno == 9 then
	ZhaoYun:addSkill("chongzhen")
end
--[[
	技能：青釭
	描述：你每造成1点伤害，你可以让目标选择弃掉一张手牌或者让你从其装备区获得一张牌。
]]--
if palno == 10 or palno == 11 then
	QingGang = sgs.CreateTriggerSkill{
		name = "DzhaoyunQingGang",
		frequency = sgs.Skill_NotFrequent,
		events = {sgs.Damage},
		on_trigger = function(self, event, player, data)
			local damage = data:toDamage()
			local victim = damage.to
			local room = player:getRoom()
			local prompt = string.format("@DzhaoyunQingGang:%s:", player:objectName())
			for i=1, damage.damage, 1 do
				if victim:isDead() or player:isDead() or victim:isNude() then
					return false
				elseif room:askForSkillInvoke(player, "DzhaoyunQingGang", data) then
					room:notifySkillInvoked(player, "DzhaoyunQingGang") --显示技能发动
					local canDiscard = victim:canDiscard(victim, "h")
					local canObtain = victim:hasEquip()
					if canDiscard and canObtain then
						if room:askForDiscard(victim, "DzhaoyunQingGang", 1, 1, true, false, prompt) then
							room:broadcastSkillInvoke("DzhaoyunQingGang", 1) --播放配音
							canDiscard, canObtain = false, false
						end
					end
					if canDiscard then
						if not room:askForDiscard(victim, "DzhaoyunQingGang", 1, 1, false, false) then
							local card = victim:getRandomHandCard()
							room:throwCard(card, victim, victim)
						end
						room:broadcastSkillInvoke("DzhaoyunQingGang", 1) --播放配音
					elseif canObtain then
						local id = room:askForCardChosen(player, victim, "e", "DzhaoyunQingGang")
						if id >= 0 then
							room:broadcastSkillInvoke("DzhaoyunQingGang", 2) --播放配音
							room:obtainCard(player, id, true)
						end
					end
				else
					return false
				end
			end
			return false
		end,
	}
	ZhaoYun:addSkill(QingGang)
	sgs.LoadTranslationTable{
		["DzhaoyunQingGang"] = "青釭",
		[":DzhaoyunQingGang"] = "你每造成1点伤害，你可以让目标选择弃掉一张手牌或者让你从其装备区获得一张牌。",
		["@DzhaoyunQingGang"] = "青釭：请弃置1张手牌，否则 %src 将从你的装备区获得一张牌",
	}
end
--[[
	效果：聚气规则
	描述：在回合开始阶段之后，判定阶段之前，加入一个聚气阶段。在聚气阶段，你可以从牌堆顶亮出一张牌置于你的武将牌上，称之为“怒”。上限为4张，若超出4张，需立即选择一张弃置。无论拥有多少聚气技，只能翻一张牌作为“怒”。
]]--
if palno == 11 then
	DzhaoyunJuQi = sgs.CreateTriggerSkill{
		name = "#DzhaoyunJuQi",
		frequency = sgs.Skill_NotFrequent,
		events = {sgs.EventPhaseChanging},
		on_trigger = function(self, event, player, data)
			local change = data:toPhaseChange()
			if change.from == sgs.Player_Start and change.to == sgs.Player_Judge then
				local room = player:getRoom()
				local thread = room:getThread()
				if player:askForSkillInvoke("DzhaoyunJuQi", data) then
					room:notifySkillInvoked(player, "DzhaoyunJuQi") --显示技能发动
					local id = room:drawCard()
					local move = sgs.CardsMoveStruct()
					move.to = player
					move.to_place = sgs.Player_PlaceTable
					move.reason = sgs.CardMoveReason(
						sgs.CardMoveReason_S_REASON_TURNOVER, player:objectName(), "DzhaoyunJuQi", ""
					)
					move.card_ids:append(id)
					room:moveCardsAtomic(move, true)
					thread:delay()
					player:addToPile("DzhaoyunJuQiPile", id, true)
					thread:trigger(sgs.NonTrigger, room, player, sgs.QVariant("DzhaoyunJuQiDiscard"))
				end
				thread:trigger(sgs.NonTrigger, room, player, sgs.QVariant("DzhaoyunJuQiPhase"))
			end
			return false
		end,
	}
	DzhaoyunJuQiDiscard = sgs.CreateTriggerSkill{
		name = "#DzhaoyunJuQiDiscard",
		frequency = sgs.Skill_Compulsory,
		events = {sgs.NonTrigger},
		on_trigger = function(self, event, player, data)
			if data:toString() == "DzhaoyunJuQiDiscard" then
				local pile = player:getPile("DzhaoyunJuQiPile")
				if pile:length() > 4 then
					local room = player:getRoom()
					room:fillAG(pile, player)
					id = room:askForAG(player, pile, false, "DzhaoyunJuQiDiscard")
					room:clearAG(player)
					if id >= 0 then
						room:throwCard(id, player, player)
					end
				end
			end
			return false
		end,
	}
	ZhaoYun:addSkill(DzhaoyunJuQi)
	ZhaoYun:addSkill(DzhaoyunJuQiDiscard)
	extension:insertRelatedSkills("#DzhaoyunJuQi", "#DzhaoyunJuQiDiscard")
	sgs.LoadTranslationTable{
		["DzhaoyunJuQi"] = "聚气",
		["DzhaoyunJuQiPile"] = "怒",
		["DzhaoyunJuQiDiscard"] = "聚气过剩",
	}
end
--[[
	技能：龙怒（聚气技）
	描述：出牌阶段，你可以弃两张相同颜色的“怒”，若如此做，你使用的下一张【杀】不可被闪避。
]]--
if palno == 11 then
	LongNuCard = sgs.CreateSkillCard{
		name = "DzhaoyunLongNuCard",
		skill_name = "DzhaoyunLongNu",
		target_fixed = true,
		will_throw = true,
		mute = true,
		on_use = function(self, room, source, targets)
			room:broadcastSkillInvoke("DzhaoyunLongNu", 1) --播放配音
			source:gainMark("@DzhaoyunLongNuMark", 1)
		end,
	}
	LongNuVS = sgs.CreateViewAsSkill{
		name = "DzhaoyunLongNu",
		n = 2,
		expand_pile = "DzhaoyunJuQiPile",
		view_filter = function(self, selected, to_select)
			local id = to_select:getEffectiveId()
			if sgs.Self:getPile("DzhaoyunJuQiPile"):contains(id) then
				if #selected == 0 then
					return true
				elseif #selected == 1 then
					return to_select:sameColorWith(selected[1])
				end
			end
			return false
		end,
		view_as = function(self, cards)
			if #cards == 2 then
				local card = LongNuCard:clone()
				card:addSubcard(cards[1])
				card:addSubcard(cards[2])
				return card
			end
		end,
		enabled_at_play = function(self, player)
			return player:getPile("DzhaoyunJuQiPile"):length() >= 2
		end,
	}
	LongNu = sgs.CreateTriggerSkill{
		name = "DzhaoyunLongNu",
		frequency = sgs.Skill_NotFrequent,
		events = {sgs.TargetSpecified},
		view_as_skill = LongNuVS,
		on_trigger = function(self, event, player, data)
			local room = player:getRoom()
			if event == sgs.TargetSpecified then
				local use = data:toCardUse()
				local slash = use.card
				if slash and slash:isKindOf("Slash") then
					if player:getMark("@DzhaoyunLongNuMark") > 0 then
						room:broadcastSkillInvoke("DzhaoyunLongNu", 2) --播放配音
						room:notifySkillInvoked(player, "DzhaoyunLongNu") --显示技能发动
						local msg = sgs.LogMessage()
						msg.type = "#DzhaoyunLongNuNoJink"
						msg.from = player
						msg.arg = "DzhaoyunLongNu"
						msg.card_str = slash:toString()
						local jinkList = sgs.IntList()
						for _,target in sgs.qlist(use.to) do
							jinkList:append(0)
							msg.to:append(target)
						end
						room:sendLog(msg) --发送提示信息
						player:loseMark("@DzhaoyunLongNuMark", 1)
						local key = string.format("Jink_%s", slash:toString())
						local tag = sgs.QVariant()
						tag:setValue(jinkList)
						player:setTag(key, tag)
					end
				end
			end
			return false
		end,
	}
	ZhaoYun:addSkill(LongNu)
	sgs.LoadTranslationTable{
		["DzhaoyunLongNu"] = "龙怒",
		[":DzhaoyunLongNu"] = "<font color=\"cyan\"><b>聚气技</b></font>，出牌阶段，你可以弃两张相同颜色的“怒”，若如此做，你使用的下一张【杀】不可被闪避。",
		["#DzhaoyunLongNuNoJink"] = "%from 发动了“%arg”，对 %to 使用的此 %card 不可被闪避",
		["@DzhaoyunLongNuMark"] = "龙怒",
	}
end
--[[
	技能：浴血（聚气技）
	描述：你可以将你的任意红桃或方片花色的“怒”当【桃】使用。
]]--
if palno == 11 then
	YuXue = sgs.CreateViewAsSkill{
		name = "DzhaoyunYuXue",
		n = 1,
		expand_pile = "DzhaoyunJuQiPile",
		view_filter = function(self, selected, to_select)
			if #selected == 0 and to_select:isRed() then
				local id = to_select:getEffectiveId()
				if sgs.Self:getPile("DzhaoyunJuQiPile"):contains(id) then
					return true
				end
			end
			return false
		end,
		view_as = function(self, cards)
			if #cards == 1 then
				local card = cards[1]
				local suit = card:getSuit()
				local point = card:getNumber()
				local peach = sgs.Sanguosha:cloneCard("peach", suit, point)
				peach:addSubcard(card)
				peach:setSkillName("DzhaoyunYuXue")
				return peach
			end
		end,
		enabled_at_play = function(self, player)
			if player:hasFlag("Global_PreventPeach") then
				return false
			elseif player:getLostHp() > 0 then
				if player:getPile("DzhaoyunJuQiPile"):length() > 0 then
					return true
				end
			end
			return false
		end,
		enabled_at_response = function(self, player, pattern)
			if string.find(pattern, "peach") then
				if player:hasFlag("Global_PreventPeach") then
					return false
				elseif player:getPile("DzhaoyunJuQiPile"):length() > 0 then
					return true
				end
			end
			return false
		end,
	}
	ZhaoYun:addSkill(YuXue)
	sgs.LoadTranslationTable{
		["DzhaoyunYuXue"] = "浴血",
		[":DzhaoyunYuXue"] = "<font color=\"cyan\"><b>聚气技</b></font>，你可以将你的任意红桃或方片花色的“怒”当【桃】使用。",
	}
end
--[[
	技能：龙吟（聚气技）
	描述：聚气阶段，你可以从牌堆顶亮出三张牌，选择其中一张做为“怒”，其余收为手牌。
]]--
if palno == 11 then
	LongYin = sgs.CreateTriggerSkill{
		name = "DzhaoyunLongYin",
		frequency = sgs.Skill_NotFrequent,
		events = {sgs.NonTrigger},
		on_trigger = function(self, event, player, data)
			if data:toString() == "DzhaoyunJuQiPhase" then
				if player:hasFlag("DzhaoyunJuQiLongYinInvoked") then
					return false
				elseif player:askForSkillInvoke("DzhaoyunLongYin") then
					local room = player:getRoom()
					room:broadcastSkillInvoke("DzhaoyunLongYin") --播放配音
					room:notifySkillInvoked(player, "DzhaoyunLongYin") --显示技能发动
					local ids = room:getNCards(3)
					local move = sgs.CardsMoveStruct()
					move.to = player
					move.to_place = sgs.Player_PlaceTable
					move.reason = sgs.CardMoveReason(
						sgs.CardMoveReason_S_REASON_TURNOVER, player:objectName(), "DzhaoyunLongYin", ""
					)
					move.card_ids = ids
					room:moveCardsAtomic(move, true)
					local thread = room:getThread()
					thread:delay()
					room:fillAG(ids, player)
					local id = room:askForAG(player, ids, false, "DzhaoyunLongYin")
					room:clearAG(player)
					if id >= 0 then
						ids:removeOne(id)
						player:addToPile("DzhaoyunJuQiPile", id, true)
						thread:trigger(sgs.NonTrigger, room, player, sgs.QVariant("DzhaoyunJuQiDiscard"))
					end
					move.to_place = sgs.Player_PlaceHand
					move.reason = sgs.CardMoveReason(
						sgs.CardMoveReason_S_REASON_PUT, player:objectName(), "DzhaoyunLongYin", ""
					)
					move.card_ids = ids
					room:moveCardsAtomic(move, true)
				end
			end
			return false
		end,
	}
	ZhaoYun:addSkill(LongYin)
	sgs.LoadTranslationTable{
		["DzhaoyunLongYin"] = "龙吟",
		[":DzhaoyunLongYin"] = "<font color=\"cyan\"><b>聚气技</b></font>，聚气阶段，你可以从牌堆顶亮出三张牌，选择其中一张做为“怒”，其余收为手牌。",
	}
end
--[[
	技能：绝境（锁定技）
	描述：摸牌阶段，你不摸牌。每当你的手牌数变化后，若你的手牌数不为4，你须将手牌补至或弃置至四张。 
]]--
if palno == 12 then
	ZhaoYun:addSkill("gdjuejing")
	ZhaoYun:addSkill("#gdjuejing")
end
--[[
	技能：龙魂
	描述：你可以将一张牌按以下规则使用或打出：♥当【桃】；♦当火【杀】；♠当【无懈可击】；♣当【闪】。准备阶段开始时，若其他角色的装备区内有【青釭剑】，你可以获得之。
]]--
if palno == 12 then
	ZhaoYun:addSkill("gdlonghun")
	ZhaoYun:addSkill("#gdlonghun-duojian")
end
--[[****************************************************************
	----------------------------------------------------------------
	---- 前！方！禁！区！请！注！意！------ 游！客！止！步！--------
	----------------------------------------------------------------
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	----------------------------------------------------------------
]]--****************************************************************
--[[****************************************************************
	虐杀开关
	说明一：修改GenLv的值以在游戏开始时召唤隐藏武将
		GenLv = 0：禁用此功能
		GenLv = 1：召唤 超神·赵云（要求：palno = 6）[级别：狂下位]
		GenLv = 2：召唤 无上·神云（要求：palno = 5）[级别：狂上位]
		GenLv = 3：召唤 BUG·云（要求：palno = 12）[级别：神]
	说明二：修改GenRate的值以获得不同的召唤成功率
	说明三：打开OpenMode开关以解除palno限制
	说明四：打开DebugMode开关以解除完全隐藏
]]--****************************************************************
GenLv = 0 
GenRate = 0.6 
OpenMode = false
DebugMode = false
--[[****************************************************************
	延伸阅读：武将单挑实力分级制度
	1、纸：
		要求：不能通过弱级审核。
		代表：一限素将
	2、弱：
		要求：50%及以上比率击败审核武将，同时不能通过并级审核。
		审核：二限素将
		代表：二将成名·步练师
	3、并：
		要求：50%及以上比率击败至少一名审核武将，同时不能通过强级审核。
		审核：五限素将；原标准版·赵云；
		代表：原标准版·关羽
	4、强：
		要求：50%及以上比率击败审核武将，同时不能通过凶级审核。
		审核：原标准版·诸葛亮
	4.1、强下位：
		要求：通过强级审核，同时不能通过强上位审核。
		代表：原标准版·貂蝉
	*4.2、强中位（非正式等级）：
		概念：与至少一名强上位审核武将不相上下的强级武将。
	4.3、强上位：
		要求：50%及以上比率击败至少一名审核武将的强级武将。
		审核：原标准版·甄姬；神·赵云
		代表：神·司马懿
	5、凶：
		要求：50%及以上比率击败审核武将，同时不能通过狂级审核。
		审核：原标准版·孙权
		代表：神·吕蒙
	6、狂：
		要求：50%及以上比率击败审核武将，同时不能通过神级审核。
		审核：测试·五星诸葛
	6.1、狂下位：
		要求：通过狂级审核，同时不能通过狂上位审核。
		代表：SP·暴怒战神
		注：本作隐藏武将 超神·赵云[AI等级0~6] 实力处于此等级。
	*6.2、狂中位（非正式等级）：
		概念：与狂上位审核武将不相上下的狂级武将。
		注：本作隐藏武将 无上·神云[AI等级0~3]、BUG·云[AI等级0~3] 实力处于此等级。
	6.3、狂上位：
		要求：50%及以上比率击败审核武将的狂级武将。
		审核：测试·高达一号
		注：本作隐藏武将 无上·神云[AI等级4~6]、BUG·云[AI等级4~5] 实力处于此等级。
	*6.4、准神（非正式等级）：
		要求：与神审核武将不相上下的狂上位武将。
	7、神：
		要求：50%及以上比率击败审核武将。
		审核：经典再临·掀桌于吉（注：该审核员自身实力为狂上位）
		注：本作隐藏武将 BUG·云[AI等级6] 实力处于此等级
	*8、论外（非正式等级）：
		概念：与其讨论单挑实力几乎没有意义的一类武将。
		代表：山·左慈
]]--****************************************************************
--[[****************************************************************
	隐藏武将：超神·赵云
]]--****************************************************************
SuperZhaoYun = sgs.General(extension, "DzhaoyunSP", "god", 9, true, true, not DebugMode)
sgs.LoadTranslationTable{
	["DzhaoyunSP"] = "超神·赵云",
	["&DzhaoyunSP"] = "赵云",
	["#DzhaoyunSP"] = "神威之龙",
	["designer:DzhaoyunSP"] = "DGAH",
	["cv:DzhaoyunSP"] = "猎狐",
	["illustrator:DzhaoyunSP"] = "KayaK",
	["~DzhaoyunSP"] = "血染鳞甲，龙坠九天……",
}
--绝境
SuperJueJing = sgs.CreateTriggerSkill{
	name = "DzhaoyunSuperJueJing",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DrawNCards},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		room:broadcastSkillInvoke("DzhaoyunSuperJueJing") --播放配音
		room:notifySkillInvoked(player, "DzhaoyunSuperJueJing") --显示技能发动
		local x = player:getLostHp()
		x = math.max(2, x)
		local n = data:toInt() + x
		data:setValue(n)
		return false
	end,
}
SuperJueJingKeep = sgs.CreateMaxCardsSkill{
	name = "#DzhaoyunSuperJueJingKeep",
	fixed_func = function(self, player)
		if player:hasSkill("DzhaoyunSuperJueJing") then
			return player:getMaxHp() + 2
		end
		return -1
	end,
}
extension:insertRelatedSkills("DzhaoyunSuperJueJing", "#DzhaoyunSuperJueJingKeep")
SuperZhaoYun:addSkill(SuperJueJing)
SuperZhaoYun:addSkill(SuperJueJingKeep)
sgs.LoadTranslationTable{
	["DzhaoyunSuperJueJing"] = "绝境",
	[":DzhaoyunSuperJueJing"] = "锁定技。摸牌阶段，你额外摸X张牌（X为你已损失的体力值且至少为2）；你的手牌上限为你的体力上限+2。",
	["$DzhaoyunSuperJueJing"] = "龙战于野，其血玄黄！",
}
--龙魂
SuperLongHunSelectCard = sgs.CreateSkillCard{
	name = "DzhaoyunSuperLongHunSelectCard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		local name = sgs.Self:property("DzhaoyunSuperLongHunCardName"):toString()
		local suit = sgs.Self:getMark("DzhaoyunSuperLongHunSuit")
		local point = sgs.Self:getMark("DzhaoyunSuperLongHunPoint")
		local id = sgs.Self:getMark("DzhaoyunSuperLongHunID")
		local card = sgs.Sanguosha:cloneCard(name, suit, point)
		card:addSubcard(id)
		card:setSkillName("DzhaoyunSuperLongHun")
		card:deleteLater()
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		return card:targetFilter(selected, to_select, sgs.Self)
	end,
	feasible = function(self, targets)
		local name = sgs.Self:property("DzhaoyunSuperLongHunCardName"):toString()
		local suit = sgs.Self:getMark("DzhaoyunSuperLongHunSuit")
		local point = sgs.Self:getMark("DzhaoyunSuperLongHunPoint")
		local id = sgs.Self:getMark("DzhaoyunSuperLongHunID")
		local card = sgs.Sanguosha:cloneCard(name, suit, point)
		card:addSubcard(id)
		card:setSkillName("DzhaoyunSuperLongHun")
		card:deleteLater()
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		return card:targetsFeasible(selected, sgs.Self)
	end,
	on_use = function(self, room, source, targets)
		for _,p in ipairs(targets) do
			room:setPlayerFlag(p, "DzhaoyunSuperLongHunTarget")
		end
	end,
}
SuperLongHunCard = sgs.CreateSkillCard{
	name = "DzhaoyunSuperLongHunCard",
	skill_name = "DzhaoyunSuperLongHun",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		local info = self:getUserString()
		if string.find(info, "+") then
			return false
		end
		local reason = sgs.Sanguosha:getCurrentCardUseReason()
		if reason == sgs.CardUseStruct_CARD_USE_REASON_RESPONSE then
			return false
		end
		local card = sgs.Sanguosha:cloneCard(info)
		card:deleteLater()
		if card:targetFixed() then
			return false
		end
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		return card:targetFilter(selected, to_select, sgs.Self)
	end,
	feasible = function(self, targets)
		local info = self:getUserString()
		if string.find(info, "+") then
			return true
		end
		local reason = sgs.Sanguosha:getCurrentCardUseReason()
		if reason == sgs.CardUseStruct_CARD_USE_REASON_RESPONSE then
			return true
		end
		local card = sgs.Sanguosha:cloneCard(info)
		card:deleteLater()
		if card:targetFixed() then
			return true
		end
		local selected = sgs.PlayerList()
		for _,p in ipairs(targets) do
			selected:append(p)
		end
		return card:targetsFeasible(selected, sgs.Self)
	end,
	on_validate = function(self, use)
		local info = self:getUserString()
		local name = info
		if string.find(info, "+") then
			local user = use.from
			local room = user:getRoom()
			local choices = info .. "+cancel"
			name = room:askForChoice(user, "DzhaoyunSuperLongHun", choices)
			if name == "cancel" then
				return nil
			end
		end
		local subcards = self:getSubcards()
		local id = subcards:first()
		local suit = self:getSuit()
		local point = self:getNumber()
		local card = sgs.Sanguosha:cloneCard(name, suit, point)
		card:addSubcard(id)
		card:setSkillName("_DzhaoyunSuperLongHun")
		if card:targetFixed() or not use.to:isEmpty() then
			return card
		end
		local reason = sgs.Sanguosha:getCurrentCardUseReason()
		if reason == sgs.CardUseStruct_CARD_USE_REASON_RESPONSE then
			return card
		end
		self:setUserString(name)
		return self
	end,
	on_validate_in_response = function(self, user)
		local info = self:getUserString()
		local name = info
		if string.find(info, "+") then
			local room = user:getRoom()
			local choices = info .. "+cancel"
			name = room:askForChoice(user, "DzhaoyunSuperLongHun", choices)
			if name == "cancel" then
				return nil
			end
		end
		local subcards = self:getSubcards()
		local id = subcards:first()
		local suit = self:getSuit()
		local point = self:getNumber()
		local card = sgs.Sanguosha:cloneCard(name, suit, point)
		card:addSubcard(id)
		card:setSkillName("_DzhaoyunSuperLongHun")
		if card:targetFixed() then
			return card
		end
		local reason = sgs.Sanguosha:getCurrentCardUseReason()
		if reason == sgs.CardUseStruct_CARD_USE_REASON_RESPONSE then
			return card
		end
		self:setUserString(name)
		return self
	end,
	about_to_use = function(self, room, use)
		local name = self:getUserString()
		local suit = self:getSuit()
		local point = self:getNumber()
		local id = self:getEffectiveId()
		local source = use.from
		room:setPlayerProperty(source, "DzhaoyunSuperLongHunCardName", sgs.QVariant(name))
		room:setPlayerMark(source, "DzhaoyunSuperLongHunSuit", suit)
		room:setPlayerMark(source, "DzhaoyunSuperLongHunPoint", point)
		room:setPlayerMark(source, "DzhaoyunSuperLongHunID", id)
		local prompt = string.format("@DzhaoyunSuperLongHun:::%s:", name)
		local success = room:askForUseCard(source, "@@DzhaoyunSuperLongHun", prompt)
		room:setPlayerProperty(source, "DzhaoyunSuperLongHunCardName", sgs.QVariant(""))
		room:setPlayerMark(source, "DzhaoyunSuperLongHunSuit", 0)
		room:setPlayerMark(source, "DzhaoyunSuperLongHunPoint", 0)
		room:setPlayerMark(source, "DzhaoyunSuperLongHunID", 0)
		local data = sgs.QVariant()
		local msg = sgs.LogMessage()
		if success then
			local alives = room:getAlivePlayers()
			local targets = sgs.SPlayerList()
			for _,p in sgs.qlist(alives) do
				if p:hasFlag("DzhaoyunSuperLongHunTarget") then
					room:setPlayerFlag(p, "-DzhaoyunSuperLongHunTarget")
					targets:append(p)
				end
			end
			local vs_card = sgs.Sanguosha:cloneCard(name, suit, point)
			vs_card:addSubcards(self:getSubcards())
			vs_card:setSkillName("_DzhaoyunSuperLongHun")
			use.card = vs_card
			use.to = targets
			data:setValue(use)
			msg.type = "#UseCard"
			msg.from = source
			msg.to = targets
			msg.card_str = vs_card:toString()
		else
			return
		end
		local thread = room:getThread()
		thread:trigger(sgs.PreCardUsed, room, source, data)
		room:sendLog(msg) --发送提示信息
		room:addPlayerHistory(source, use.card:getClassName())
		local reason = sgs.CardMoveReason(
			sgs.CardMoveReason_S_REASON_THROW, 
			source:objectName(), 
			"", 
			"DzhaoyunSuperLongHun", 
			""
		)
		room:moveCardTo(self, source, nil, sgs.Player_DiscardPile, reason, true)
		thread:trigger(sgs.CardUsed, room, source, data)
		thread:trigger(sgs.CardFinished, room, source, data)
	end,
}
SuperLongHun = sgs.CreateViewAsSkill{
	name = "DzhaoyunSuperLongHun",
	n = 1,
	view_filter = function(self, selected, to_select)
		local pattern = sgs.Sanguosha:getCurrentCardUsePattern()
		if pattern == "@@DzhaoyunSuperLongHun" then
			return false
		elseif pattern == "nullification" then
			return to_select:getSuit() == sgs.Card_Spade
		elseif string.find(pattern, "peach") then
			return to_select:getSuit() == sgs.Card_Heart
		elseif pattern == "jink" then
			return to_select:getSuit() == sgs.Card_Club
		elseif pattern == "slash" then
			return to_select:getSuit() == sgs.Card_Diamond
		else
			if to_select:isKindOf("Slash") then
				return true
			elseif to_select:isKindOf("Jink") then
				return true
			elseif to_select:isKindOf("Peach") then
				return true
			elseif to_select:isKindOf("Analeptic") then
				return true
			else
				local suit = to_select:getSuit()
				if suit == sgs.Card_Heart then
					if sgs.Self:getLostHp() > 0 then
						return not sgs.Self:hasFlag("Global_PreventPeach")
					end
				elseif suit == sgs.Card_Diamond then
					return sgs.Slash_IsAvailable(sgs.Self)
				end
			end
		end
		return false
	end,
	view_as = function(self, cards)
		local pattern = sgs.Sanguosha:getCurrentCardUsePattern()
		if pattern == "@@DzhaoyunSuperLongHun" then
			return SuperLongHunSelectCard:clone()
		end
		if #cards == 1 then
			local card = cards[1]
			local suit = card:getSuit()
			local point = card:getNumber()
			local info = {}
			if pattern == "nullification" then
				table.insert(info, "nullification")
			elseif string.find(pattern, "peach") then
				table.insert(info, "peach")
			elseif pattern == "jink" then
				table.insert(info, "jink")
			elseif pattern == "slash" then
				table.insert(info, "fire_slash")
			else
				if suit == sgs.Card_Heart then
					if sgs.Self:getLostHp() > 0 then
						if not sgs.Self:hasFlag("Global_PreventPeach") then
							table.insert(info, "peach")
						end
					end
				elseif suit == sgs.Card_Diamond then
					if sgs.Slash_IsAvailable(sgs.Self) then
						table.insert(info, "fire_slash")
					end
				end
				if card:isKindOf("Slash") then
					table.insert(info, "archery_attack")
				elseif card:isKindOf("Jink") then
					table.insert(info, "god_salvation")
				elseif card:isKindOf("Peach") then
					table.insert(info, "ex_nihilo")
				elseif card:isKindOf("Analeptic") then
					table.insert(info, "duel")
				end
			end
			info = table.concat(info, "+")
			if info == "" then
				return nil
			end
			local vs_card = SuperLongHunCard:clone()
			vs_card:addSubcard(card)
			vs_card:setSuit(suit)
			vs_card:setNumber(point)
			vs_card:setSkillName("DzhaoyunSuperLongHun")
			vs_card:setUserString(info)
			return vs_card
		end
	end,
	enabled_at_play = function(self, player)
		return not player:isNude()
	end,
	enabled_at_response = function(self, player, pattern)
		if pattern == "@@DzhaoyunSuperLongHun" then
			return true
		elseif player:isNude() then
			return false
		elseif pattern == "nullification" then
			return true
		elseif string.find(pattern, "peach") then
			return not player:hasFlag("Global_PreventPeach")
		elseif pattern == "jink" then
			return true
		elseif pattern == "slash" then
			return true
		end
		return false
	end,
	enabled_at_nullification = function(self, player)
		local cards = player:getCards("he")
		for _,spade in sgs.qlist(cards) do
			if spade:getSuit() == sgs.Card_Spade then
				return true
			end
		end
		return false
	end,
}
SuperZhaoYun:addSkill(SuperLongHun)
sgs.LoadTranslationTable{
	["DzhaoyunSuperLongHun"] = "龙魂",
	[":DzhaoyunSuperLongHun"] = "你可以将一张牌按如下规则使用或打出：\
♠当【无懈可击】，\
♥当【桃】，\
♣当【闪】，\
♦当火【杀】，\
【杀】当【万箭齐发】，\
【闪】当【桃园结义】，\
【桃】当【无中生有】，\
【酒】当【决斗】。",
	["@DzhaoyunSuperLongHun"] = "龙魂：请选择此【%arg】的目标",
	["~DzhaoyunSuperLongHun"] = "选择一些角色->点击“确定”",
	["dzhaoyunsuperlonghunselect"] = "龙魂·选择目标",
}
--[[****************************************************************
	隐藏武将：无上·神云
]]--****************************************************************
UltraZhaoYun = sgs.General(extension, "DzhaoyunUP", "god", 1, true, true, not DebugMode)
sgs.LoadTranslationTable{
	["DzhaoyunUP"] = "无上·神云",
	["&DzhaoyunUP"] = "赵云",
	["#DzhaoyunUP"] = "神威真龙",
	["designer:DzhaoyunUP"] = "DGAH",
	["cv:DzhaoyunUP"] = "猎狐",
	["illustrator:DzhaoyunUP"] = "KayaK",
	["~DzhaoyunUP"] = "血染鳞甲，龙坠九天……",
}
--绝境
UltraJueJing = sgs.CreateTriggerSkill{
	name = "DzhaoyunUltraJueJing",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.CardUsed, sgs.CardResponded, sgs.CardsMoveOneTime, sgs.DamageForseen, sgs.EventPhaseEnd},
	on_trigger = function(self, event, player, data)
		if player:isDead() then
			return false
		end
		local room = player:getRoom()
		if event == sgs.CardUsed then
			local use = data:toCardUse()
			if not use.card:isKindOf("SkillCard") then
				room:broadcastSkillInvoke("DzhaoyunUltraJueJing", 1) --播放配音
				room:notifySkillInvoked(player, "DzhaoyunUltraJueJing") --显示技能发动
				room:drawCards(player, 1, "DzhaoyunUltraJueJing")
			end
		elseif event == sgs.CardResponded then
			local response = data:toCardResponse()
			if not response.m_card:isKindOf("SkillCard") then
				room:broadcastSkillInvoke("DzhaoyunUltraJueJing", 2) --播放配音
				room:notifySkillInvoked(player, "DzhaoyunUltraJueJing") --显示技能发动
				room:drawCards(player, 1, "DzhaoyunUltraJueJing")
			end
		elseif event == sgs.CardsMoveOneTime then
			local move = data:toMoveOneTime()
			local source = move.from
			if source and source:objectName() == player:objectName() then
				local reason = bit32.band(move.reason.m_reason, sgs.CardMoveReason_S_MASK_BASIC_REASON)
				if reason == sgs.CardMoveReason_S_REASON_DISCARD then
					room:broadcastSkillInvoke("DzhaoyunUltraJueJing", 3) --播放配音
					room:notifySkillInvoked(player, "DzhaoyunUltraJueJing") --显示技能发动
					local count = move.card_ids:length()
					room:drawCards(player, count, "DzhaoyunUltraJueJing")
				end
			end
		elseif event == sgs.DamageForseen then
			local avoid = false
			if player:getMark("DzhaoyunUltraJueJingAvoid") == 0 then
				avoid = true
			else
				local damage = data:toDamage()
				local card = damage.card
				if not card or card:isKindOf("SkillCard") then
					avoid = true
				end
			end
			if avoid then
				room:broadcastSkillInvoke("DzhaoyunUltraJueJing", 4) --播放配音
				room:notifySkillInvoked(player, "DzhaoyunUltraJueJing") --显示技能发动
				local msg = sgs.LogMessage()
				msg.type = "#DzhaoyunUltraJueJingAvoid"
				msg.from = player
				msg.arg = "DzhaoyunUltraJueJing"
				room:sendLog(msg) --发送提示信息
				room:throwEvent(sgs.TurnBroken)
				return true
			end
		elseif event == sgs.EventPhaseEnd then
			if player:getPhase() == sgs.Player_Play then
				room:setPlayerMark(player, "DzhaoyunUltraJueJingAvoid", 1)
			end
		end
		return false
	end,
}
UltraZhaoYun:addSkill(UltraJueJing)
sgs.LoadTranslationTable{
	["DzhaoyunUltraJueJing"] = "绝境",
	[":DzhaoyunUltraJueJing"] = "锁定技。你每使用、打出、弃置一张牌时，你摸一张牌。以你为目标的伤害开始结算时，若该伤害为：1、你第一次出牌阶段结束前受到的；2、非卡牌造成的，你防止之，并立即结束当前回合。",
	["#DzhaoyunUltraJueJingAvoid"] = "%from 的技能“%arg”被触发，防止了本次伤害，并立即结束当前回合",
}
--龙魂
UltraLongHunCard = sgs.CreateSkillCard{
	name = "DzhaoyunUltraLongHunCard",
	--skill_name = "DzhaoyunUltraLongHun",
	target_fixed = false,
	will_throw = false,
	filter = function(self, targets, to_select)
		return #targets == 0
	end,
	on_use = function(self, room, source, targets)
		local target = targets[1]
		room:obtainCard(target, self, true)
		local subcards = self:getSubcards()
		local x = subcards:length()
		local id = subcards:first()
		local card = sgs.Sanguosha:getCard(id)
		local suit = card:getSuit()
		if suit == sgs.Card_Spade then
			room:broadcastSkillInvoke("DzhaoyunUltraLongHun", 1)
			local damage = sgs.DamageStruct()
			damage.from = nil
			damage.to = target
			damage.damage = 2 * x
			damage.nature = sgs.DamageStruct_Thunder
			room:damage(damage)
		elseif suit == sgs.Card_Heart then
			room:broadcastSkillInvoke("DzhaoyunUltraLongHun", 2)
			local recover = sgs.RecoverStruct()
			recover.who = source
			recover.recover = 2 * x
			room:recover(target, recover)
		elseif suit == sgs.Card_Club then
			room:broadcastSkillInvoke("DzhaoyunUltraLongHun", 3)
			room:addPlayerMark(target, "UltraLongHunSkipTurnCount", 2 * x)
		elseif suit == sgs.Card_Diamond then
			room:broadcastSkillInvoke("DzhaoyunUltraLongHun", 4)
			room:addPlayerMark(target, "UltraLongHunRestProtectCount", 2 * x)
		end
	end,
}
UltraLongHunVS = sgs.CreateViewAsSkill{
	name = "DzhaoyunUltraLongHun",
	n = 999,
	view_filter = function(self, selected, to_select)
		if #selected == 0 then
			return true
		elseif to_select:getSuit() == selected[1]:getSuit() then
			return true
		end
		return false
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local card = UltraLongHunCard:clone()
			for _,c in ipairs(cards) do
				card:addSubcard(c)
			end
			return card
		end
	end,
	enabled_at_play = function(self, player)
		if player:isNude() then
			return false
		elseif player:usedTimes("#DzhaoyunUltraLongHunCard") < 7 then
			return true
		end
		return false
	end,
}
UltraLongHun = sgs.CreateTriggerSkill{
	name = "DzhaoyunUltraLongHun",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.TurnStart, sgs.TargetConfirming, sgs.CardUsed},
	view_as_skill = UltraLongHunVS,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.TurnStart then
			if player:getMark("UltraLongHunSkipTurnCount") == 0 then
				return false
			end
			local current = player
			while true do
				local skip = current:getMark("UltraLongHunSkipTurnCount")
				if skip == 0 then
					if player:objectName() ~= current:objectName() then
						room:setCurrent(current)
					end
					return false
				end
				skip = skip - 1
				room:setPlayerMark(current, "UltraLongHunSkipTurnCount", skip)
				room:broadcastSkillInvoke("DzhaoyunUltraLongHun", 3)
				local msg = sgs.LogMessage()
				msg.type = "#UltraLongHunSkip"
				msg.from = current
				msg.arg = "DzhaoyunUltraLongHun"
				msg.arg2 = skip
				room:sendLog(msg) --发送提示信息
				current = current:getNextAlive()
			end
		elseif event == sgs.TargetConfirming then
			if player:getMark("UltraLongHunRestProtectCount") == 0 then
				return false
			end
			local use = data:toCardUse()
			local card = use.card
			if card:isKindOf("Slash") or card:isKindOf("Duel") then
				for _,target in sgs.qlist(use.to) do
					if target:objectName() == player:objectName() then
						local source = use.from
						local canReplace = false
						if source and source:isAlive() then
							canReplace = true
							if source:isProhibited(source, card) then
								canReplace = false
							end
						end
						local new_targets = sgs.SPlayerList()
						for _,p in sgs.qlist(use.to) do
							if p:objectName() == player:objectName() then
								room:broadcastSkillInvoke("DzhaoyunUltraLongHun", 4)
								if canReplace then
									local msg = sgs.LogMessage()
									msg.type = "#UltraLongHunReplace"
									msg.from = player
									msg.to:append(source)
									msg.card_str = card:toString()
									msg.arg = "DzhaoyunUltraLongHun"
									room:sendLog(msg) --发送提示信息
									new_targets:append(source)
								else
									local msg = sgs.LogMessage()
									msg.type = "#UltraLongHunCancel"
									msg.from = player
									msg.to:append(source)
									msg.card_str = card:toString()
									msg.arg = "DzhaoyunUltraLongHun"
									room:sendLog(msg) --发送提示信息
								end
							else
								new_targets:append(p)
							end
						end
						use.to = new_targets
						data:setValue(use)
						return false
					end
				end
			end
		elseif event == sgs.CardUsed then
			local use = data:toCardUse()
			if use.card:isKindOf("SkillCard") then
				return false
			end
			local protect = player:getMark("UltraLongHunRestProtectCount")
			if protect == 0 then
				return false
			end
			protect = protect - 1
			local msg = sgs.LogMessage()
			msg.from = player
			msg.arg = "DzhaoyunUltraLongHun"
			if protect == 0 then
				msg.type = "#UltraLongHunProtectClear"
			else
				msg.type = "#UltraLongHunProtect"
				msg.arg2 = protect
			end
			room:sendLog(msg) --发送提示信息
			room:setPlayerMark(player, "UltraLongHunRestProtectCount", protect)
		end
		return false
	end,
	can_trigger = function(self, target)
		return target and target:isAlive()
	end,
}
UltraZhaoYun:addSkill(UltraLongHun)
sgs.LoadTranslationTable{
	["DzhaoyunUltraLongHun"] = "龙魂",
	[":DzhaoyunUltraLongHun"] = "出牌阶段限七次，你可以将X张（X至少为1）相同花色的牌正面向上交给一名角色，然后该角色按如下规则执行相应的效果：\
♠：受到2X点雷电伤害；\
♥：回复2X点体力；\
♣：跳过2X个回合；\
♦：使用2X张牌之前，若成为【杀】或【决斗】的目标，由使用者代替之。",
	["#UltraLongHunSkip"] = "受技能“%arg”影响，%from 的当前回合被跳过。此影响还将持续 %arg2 个回合。",
	["#UltraLongHunProtect"] = "%from 使用了一张牌，在技能“%arg”的保护作用消失前还可以使用 %arg2 张牌",
	["#UltraLongHunProtectClear"] = "注意：%from 受技能“%arg”的保护作用消失！",
	["#UltraLongHunReplace"] = "受技能“%arg”影响，卡牌使用者 %to 将代替 %from 成为此【%card】的目标",
	["#UltraLongHunCancel"] = "受技能“%arg”影响，%from 不能被指定为 %to 使用的此【%card】的目标",
	["$DzhaoyunUltraLongHun1"] = "千里一怒，红莲灿世！",
	["$DzhaoyunUltraLongHun2"] = "潜龙于渊，涉灵愈伤。",
	["$DzhaoyunUltraLongHun3"] = "金甲映日，驱邪祛秽！",
	["$DzhaoyunUltraLongHun4"] = "腾龙行云，首尾不见！",
	["dzhaoyunultralonghun"] = "龙魂",
}
--[[****************************************************************
	隐藏武将：BUG·云
]]--****************************************************************
BugZhaoYun = sgs.General(extension, "DzhaoyunBP", "god", 0, true, true, not DebugMode)
sgs.LoadTranslationTable{
	["DzhaoyunBP"] = "BUG·云",
	["&DzhaoyunBP"] = "赵云",
	["#DzhaoyunBP"] = "传说真龙",
	["designer:DzhaoyunBP"] = "DGAH",
	["cv:DzhaoyunBP"] = "猎狐",
	["illustrator:DzhaoyunBP"] = "巴萨小马",
	["~DzhaoyunBP"] = "血染鳞甲，龙坠九天……",
}
--劫云：必杀技，弃置至少1张雷【杀】或【闪电】，令一名角色受到X点雷电伤害（X为所弃置牌的点数之和）。若弃置的牌中有【闪电】，则此伤害额外结算3次。
BugJieYunCard = sgs.CreateSkillCard{
	name = "BugJieYunCard",
	skill_name = "BugJieYun",
	target_fixed = true,
	will_throw = true,
	on_use = function(self, room, source, targets)
		local subcards = self:getSubcards()
		local extra = false
		local x = 0
		for _,id in sgs.qlist(subcards) do
			local card = sgs.Sanguosha:getCard(id)
			x = x + card:getNumber()
			extra = extra or card:isKindOf("Lightning")
		end
		local alives = room:getAlivePlayers()
		local times = 1
		if extra then
			times = times + 3
		end
		local prompt = string.format("@BugJieYun:::%d:%d", x, times)
		room:setPlayerMark(source, "BugJieYunDamage_ForAI", x)
		room:setPlayerMark(source, "BugJieYunDamageTimes_ForAI", times)
		local victim = room:askForPlayerChosen(source, alives, "BugJieYun", prompt, false, true)
		room:setPlayerMark(source, "BugJieYunDamage_ForAI", 0)
		room:setPlayerMark(source, "BugJieYunDamageTimes_ForAI", 0)
		if victim then
			if extra then
				room:doSuperLightbox("DzhaoyunBP", "BugJieYun") --播放全屏技能特效
			end
			local damage = sgs.DamageStruct()
			damage.from = nil
			damage.to = victim
			damage.damage = x
			damage.nature = sgs.DamageStruct_Thunder
			local thread = room:getThread()
			for i=1, times, 1 do
				if victim:isDead() then
					return
				end
				thread:delay()
				room:damage(damage)
			end
		end
	end,
}
BugJieYun = sgs.CreateViewAsSkill{
	name = "BugJieYun",
	n = 999,
	view_filter = function(self, selected, to_select)
		if to_select:isKindOf("ThunderSlash") or to_select:isKindOf("Lightning") then
			return sgs.Self:canDiscard(sgs.Self, to_select:getEffectiveId())
		end
		return false
	end,
	view_as = function(self, cards)
		if #cards > 0 then
			local card = BugJieYunCard:clone()
			for _,c in ipairs(cards) do
				card:addSubcard(c)
			end
			return card
		end
	end,
	enabled_at_play = function(self, player)
		return not player:isNude()
	end,
}
BugZhaoYun:addSkill(BugJieYun)
sgs.LoadTranslationTable{
	["BugJieYun"] = "劫云",
	[":BugJieYun"] = "<font color=\"RoyalBlue\"><b>必杀技</b></font>，出牌阶段，你可以弃置至少1张雷【杀】或【闪电】，令一名角色受到X点雷电伤害（X为你弃置牌的点数之和）。若你弃置的牌中有【闪电】，此伤害额外结算3次。",
	["@BugJieYun"] = "请选择一名角色，令其受到 %arg 点雷电伤害（此伤害结算 %arg2 次）",
}
--龙威：超必杀技，弃置不同花色的牌，重置一名角色的某项数值
BugLongWeiCard = sgs.CreateSkillCard{
	name = "BugLongWeiCard",
	skill_name = "BugLongWei",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		if #targets == 0 then
			if to_select:objectName() == sgs.Self:objectName() then
				return false
			end
			local subcards = self:getSubcards()
			local case = 0x0000
			for _,id in sgs.qlist(subcards) do
				local card = sgs.Sanguosha:getCard(id)
				local suit = card:getSuit()
				if suit == sgs.Card_Spade then
					case = bit32.bor(case, 0x1000)
				elseif suit == sgs.Card_Heart then
					case = bit32.bor(case, 0x0100)
				elseif suit == sgs.Card_Club then
					case = bit32.bor(case, 0x0010)
				elseif suit == sgs.Card_Diamond then
					case = bit32.bor(case, 0x0001)
				end
			end
			if case == 0x0000 then
				return to_select:getMark("BugLongWeiZeroDist") == 0
			elseif case == 0x1000 then
				return to_select:getMark("BugLongWeiZeroDamage") == 0
			elseif case == 0x0100 then
				return to_select:getMark("BugLongWeiZeroRecover") == 0
			elseif case == 0x0010 then
				return to_select:hasEquip()
			elseif case == 0x0001 then
				return not to_select:isKongcheng()
			elseif case == 0x1010 then
				return to_select:getHp() ~= 0
			elseif case == 0x0101 then
				return to_select:getMark("BugLongWeiZeroMaxCards") == 0
			elseif case == 0x0111 then
				return to_select:getMark("BugLongWeiZeroTurn") == 0
			elseif case == 0x1011 then
				return to_select:getMark("BugLongWeiZeroPlay") == 0
			elseif case == 0x1101 then
				return to_select:getMark("BugLongWeiZeroDraw") == 0
			elseif case == 0x1110 then
				local skills = to_select:getVisibleSkillList()
				return not skills:isEmpty()
			elseif case == 0x1111 then
				return to_select:getMaxHp() > 0
			end
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local case = 0x0000
		local subcards = self:getSubcards()
		for _,id in sgs.qlist(subcards) do
			local card = sgs.Sanguosha:getCard(id)
			local suit = card:getSuit()
			if suit == sgs.Card_Spade then
				case = bit32.bor(case, 0x1000)
			elseif suit == sgs.Card_Heart then
				case = bit32.bor(case, 0x0100)
			elseif suit == sgs.Card_Club then
				case = bit32.bor(case, 0x0010)
			elseif suit == sgs.Card_Diamond then
				case = bit32.bor(case, 0x0001)
			end
		end
		local victim = targets[1]
		if case == 0x0000 then
			room:setPlayerMark(victim, "BugLongWeiZeroDist", 1)
			local msg = sgs.LogMessage()
			msg.type = "#BugLongWeiCase0x0000"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugLongWei"
			msg.arg2 = 0
			room:sendLog(msg) --发送提示信息
		elseif case == 0x1000 then
			room:setPlayerMark(victim, "BugLongWeiZeroDamage", 1)
			local msg = sgs.LogMessage()
			msg.type = "#BugLongWeiCase0x1000"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugLongWei"
			msg.arg2 = 0
			room:sendLog(msg) --发送提示信息
		elseif case == 0x0100 then
			room:setPlayerMark(victim, "BugLongWeiZeroRecover", 1)
			local msg = sgs.LogMessage()
			msg.type = "#BugLongWeiCase0x0100"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugLongWei"
			msg.arg2 = 0
			room:sendLog(msg) --发送提示信息
		elseif case == 0x0010 then
			victim:throwAllEquips()
		elseif case == 0x0001 then
			victim:throwAllHandCards()
		elseif case == 0x1010 then
			room:setPlayerProperty(victim, "hp", sgs.QVariant(0))
			room:enterDying(victim, nil)
		elseif case == 0x0101 then
			room:setPlayerMark(victim, "BugLongWeiZeroMaxCards", 1)
			local msg = sgs.LogMessage()
			msg.type = "#BugLongWeiCase0x0101"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugLongWei"
			msg.arg2 = 0
			room:sendLog(msg) --发送提示信息
		elseif case == 0x0111 then
			room:setPlayerMark(victim, "BugLongWeiZeroTurn", 1)
			local msg = sgs.LogMessage()
			msg.type = "#BugLongWeiCase0x0111"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugLongWei"
			room:sendLog(msg) --发送提示信息
		elseif case == 0x1011 then
			room:setPlayerMark(victim, "BugLongWeiZeroPlay", 1)
			local msg = sgs.LogMessage()
			msg.type = "#BugLongWeiCase0x1011"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugLongWei"
			room:sendLog(msg) --发送提示信息
		elseif case == 0x1101 then
			room:setPlayerMark(victim, "BugLongWeiZeroDraw", 1)
			local msg = sgs.LogMessage()
			msg.type = "#BugLongWeiCase0x1101"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugLongWei"
			room:sendLog(msg) --发送提示信息
		elseif case == 0x1110 then
			local skills = victim:getVisibleSkillList()
			for _,skill in sgs.qlist(skills) do
				room:detachSkillFromPlayer(victim, skill:objectName())
			end
		elseif case == 0x1111 then
			room:doSuperLightbox("DzhaoyunBP", "BugLongWei") --播放全屏技能特效
			room:setPlayerProperty(victim, "maxhp", sgs.QVariant(0))
			room:enterDying(victim, nil)
		end
	end,
}
BugLongWeiVS = sgs.CreateViewAsSkill{
	name = "BugLongWei",
	n = 4,
	view_filter = function(self, selected, to_select)
		if sgs.Self:canDiscard(sgs.Self, to_select:getEffectiveId()) then
			local suit = to_select:getSuit()
			for _,card in ipairs(selected) do
				if suit == card:getSuit() then
					return false
				end
			end
		end
		return true
	end,
	view_as = function(self, cards)
		local card = BugLongWeiCard:clone()
		for _,c in ipairs(cards) do
			card:addSubcard(c)
		end
		return card
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#BugLongWeiCard")
	end,
}
BugLongWei = sgs.CreateTriggerSkill{
	name = "BugLongWei",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.PreDamageDone, sgs.PreHpRecover, sgs.TurnStart, sgs.EventPhaseStart, sgs.EventPhaseEnd, sgs.DrawNCards},
	global = true,
	view_as_skill = BugLongWeiVS,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.PreDamageDone then
			local damage = data:toDamage()
			local source = damage.from
			if source and source:getMark("BugLongWeiZeroDamage") > 0 then
				local msg = sgs.LogMessage()
				msg.type = "#BugLongWeiZeroDamage"
				msg.from = source
				msg.to:append(player)
				msg.arg = damage.damage
				msg.arg2 = 0
				room:sendLog(msg) --发送提示信息
				damage.damage = 0
				data:setValue(damage)
			end
		elseif event == sgs.PreHpRecover then
			if player:getMark("BugLongWeiZeroRecover") > 0 then
				local recover = data:toRecover()
				local msg = sgs.LogMessage()
				msg.type = "#BugLongWeiZeroRecover"
				msg.from = player
				msg.arg = recover.recover
				msg.arg2 = 0
				room:sendLog(msg) --发送提示信息
				recover.recover = 0
				data:setValue(recover)
				return true
			end
		elseif event == sgs.TurnStart then
			if player:getMark("BugLongWeiZeroTurn") > 0 then
				local target = player:getNextAlive()
				while target:objectName() ~= player:objectName() do
					if target:getMark("BugLongWeiZeroTurn") == 0 then
						room:setCurrent(target)
						return false
					end
					target = target:getNextAlive()
				end
				room:gameOver(".")
			end
		elseif event == sgs.EventPhaseStart then
			if player:getMark("BugLongWeiZeroPlay") > 0 then
				if player:getPhase() == sgs.Player_Play then
					local msg = sgs.LogMessage()
					msg.type = "#BugLongWeiZeroPlay"
					msg.from = player
					msg.arg = 0
					room:sendLog(msg) --发送提示信息
					room:setPlayerCardLimitation(player, "use", ".|.|.|hand,equipped", true)
				end
			end
		elseif event == sgs.EventPhaseEnd then
			if player:getMark("BugLongWeiZeroPlay") > 0 then
				if player:getPhase() == sgs.Player_Play then
					room:removePlayerCardLimitation(player, "use", ".|.|.|hand,equipped$1")
				end
			end
		elseif event == sgs.DrawNCards then
			if player:getMark("BugLongWeiZeroDraw") > 0 then
				local n = data:toInt()
				if n > 0 then
					local msg = sgs.LogMessage()
					msg.type = "#BugLongWeiZeroDraw"
					msg.from = player
					msg.arg = n
					msg.arg2 = 0
					room:sendLog(msg) --发送提示信息
					data:setValue(0)
				end
			end
		end
		return false
	end,
}
BugLongWeiDist = sgs.CreateDistanceSkill{
	name = "#BugLongWeiDist",
	correct_func = function(self, from, to)
		if to:hasFlag("BugLongWeiDist_StackOverflow") then
			return 0
		elseif to:getMark("BugLongWeiZeroDist") > 0 then
			to:setFlags("BugLongWeiDist_StackOverflow")
			local dist = from:distanceTo(to)
			to:setFlags("-BugLongWeiDist_StackOverflow")
			return -dist
		end
		return 0
	end,
}
BugLongWeiKeep = sgs.CreateMaxCardsSkill{
	name = "#BugLongWeiKeep",
	fixed_func = function(self, target)
		if target:getMark("BugLongWeiZeroMaxCards") > 0 then
			return 0
		end
		return -1
	end,
}
extension:insertRelatedSkills("BugLongWei", "#BugLongWeiDist")
extension:insertRelatedSkills("BugLongWei", "#BugLongWeiKeep")
BugZhaoYun:addSkill(BugLongWei)
BugZhaoYun:addSkill(BugLongWeiDist)
BugZhaoYun:addSkill(BugLongWeiKeep)
sgs.LoadTranslationTable{
	["BugLongWei"] = "龙威",
	[":BugLongWei"] = "<font color=\"DarkViolet\"><b>超必杀技</b></font>，出牌阶段限一次，你可以弃置至多四张不同花色的牌，将一名其他角色的某项数值重置为零：\
无 - 对其的距离；\
♠ - 每次伤害数；\
♥ - 每次回复数；\
♣ - 当前装备数：\
♦ - 当前手牌数；\
♠♣ - 当前体力值；\
♥♦ - 手牌上限；\
♥♣♦ - 剩余回合数；\
♠♣♦ - 每阶段可用牌数；\
♠♥♦ - 每次摸牌数；\
♠♥♣ - 技能数；\
♠♥♣♦ - 体力上限。",
	["#BugLongWeiZeroDamage"] = "BUG：%from 受“龙威”影响，对 %to 造成的伤害从 %arg 点降为 %arg2 点",
	["#BugLongWeiZeroRecover"] = "BUG：%from 受“龙威”影响，体力回复点数从 %arg 点降为 %arg2 点",
	["#BugLongWeiZeroPlay"] = "BUG：%from 受“龙威”影响，出牌阶段可使用牌数锁定为 %arg 张",
	["#BugLongWeiZeroDraw"] = "BUG：%from 受“龙威”影响，摸牌阶段摸牌数从 %arg 张降为 %arg2 张",
	["#BugLongWeiDist"] = "龙威",
	["#BugLongWeiKeep"] = "龙威",
	["#BugLongWeiCase0x0000"] = "BUG：%from 发动了技能“%arg”，自此所有角色计算的与 %to 的距离为 %arg2",
	["#BugLongWeiCase0x1000"] = "BUG：%from 发动了技能“%arg”，自此 %to 造成的所有伤害视为 %arg2 点",
	["#BugLongWeiCase0x0100"] = "BUG：%from 发动了技能“%arg”，自此 %to 每次回复的点数视为 %arg2",
	["#BugLongWeiCase0x0101"] = "BUG：%from 发动了技能“%arg”，自此 %to 的手牌上限视为 %arg2",
	["#BugLongWeiCase0x0111"] = "BUG：%from 发动了技能“%arg”，自此 %to 将跳过其所有剩余回合",
	["#BugLongWeiCase0x1011"] = "BUG：%from 发动了技能“%arg”，自此 %to 将跳过其所有出牌阶段",
	["#BugLongWeiCase0x1101"] = "BUG：%from 发动了技能“%arg”，自此 %to 将跳过其所有摸牌阶段",
}
--锋灵：即死技，令一名角色按翻开的牌型弃置牌，否则将其即死。
BugFengLingCard = sgs.CreateSkillCard{
	name = "BugFengLingCard",
	skill_name = "BugFengLing",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		if #targets == 0 then
			if to_select:objectName() == sgs.Self:objectName() then
				return false
			end
			local others = sgs.Self:getSiblings()
			local dist = sgs.Self:distanceTo(to_select)
			for _,p in sgs.qlist(others) do
				if p:objectName() == to_select:objectName() then
				elseif sgs.Self:distanceTo(p) < dist then
					return false
				end
			end
			return true
		end
		return false
	end,
	on_use = function(self, room, source, targets)
		local x = room:alivePlayerCount()
		local card_ids = room:getNCards(x + 1)
		local move = sgs.CardsMoveStruct()
		move.card_ids = card_ids
		move.to = nil
		move.to_place = sgs.Player_PlaceTable
		move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_TURNOVER, source:objectName())
		room:moveCardsAtomic(move, false)
		local thread = room:getThread()
		thread:delay()
		move.to_place = sgs.Player_DiscardPile
		move.reason = sgs.CardMoveReason(sgs.CardMoveReason_S_REASON_PUT, source:objectName())
		room:moveCardsAtomic(move, false)
		local victim = targets[1]
		local avoid = true
		for _,id in sgs.qlist(card_ids) do
			local card = sgs.Sanguosha:getCard(id)
			local pattern, prompt = "..", nil
			if card:isKindOf("BasicCard") then
				pattern = "BasicCard|.|.|."
				prompt = "@BugFengLing:::BasicCard:"
			elseif card:isKindOf("EquipCard") then
				pattern = "EquipCard|.|.|."
				prompt = "@BugFengLing:::EquipCard:"
			elseif card:isKindOf("TrickCard") then
				pattern = "TrickCard|.|.|."
				prompt = "@BugFengLing:::TrickCard"
			end
			if not room:askForCard(victim, pattern, prompt) then
				avoid = false
				break
			end
		end
		if not avoid then
			local msg = sgs.LogMessage()
			msg.type = "#BugFengLingInvoked"
			msg.from = source
			msg.to:append(victim)
			msg.arg = "BugFengLing"
			room:sendLog(msg) --发送提示信息
			room:doSuperLightbox("DzhaoyunBP", "BugFengLing") --播放全屏技能特效
			room:killPlayer(victim)
		end
	end,
}
BugFengLing = sgs.CreateViewAsSkill{
	name = "BugFengLing",
	n = 0,
	view_as = function(self, cards)
		return BugFengLingCard:clone()
	end,
	enabled_at_play = function(self, player)
		return not player:hasUsed("#BugFengLingCard")
	end,
}
BugZhaoYun:addSkill(BugFengLing)
sgs.LoadTranslationTable{
	["BugFengLing"] = "锋灵",
	[":BugFengLing"] = "<font color=\"Crimson\"><b>即死技</b></font>，出牌阶段限一次，你可以翻开牌堆顶的X+1张牌，令一名与你距离最近的其他角色依次弃置等量同类型的牌。若该角色不能如此做，你令其立即死亡（X为场上存活角色数）。",
	["@BugFengLing"] = "锋灵：请弃置一张 %arg，否则你立即死亡",
	["#BugFengLingInvoked"] = "BUG：%from 的“%arg”即死判定生效，目标 %to 立即死亡",
}
--防止受到的一切伤害、体力流失，并在体力上限被严重扣减后立即重置
BugAvoid = sgs.CreateTriggerSkill{
	name = "#BugAvoid",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.DamageForseen, sgs.PreHpLost, sgs.MaxHpChanged},
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event == sgs.DamageForseen then
			room:notifySkillInvoked(player, "DzhaoyunBP") --显示技能发动
			local damage = data:toDamage()
			local msg = sgs.LogMessage()
			msg.type = "#DzhaoyunBPBugAvoid_Damage"
			msg.from = player
			msg.arg = damage.damage
			room:sendLog(msg) --发送提示信息
			return true
		elseif event == sgs.PreHpLost then
			room:notifySkillInvoked(player, "DzhaoyunBP") --显示技能发动
			local msg = sgs.LogMessage()
			msg.type = "#DzhaoyunBPBugAvoid_LoseHp"
			msg.from = player
			msg.arg = data:toInt()
			room:sendLog(msg) --发送提示信息
			return true
		elseif event == sgs.MaxHpChanged then
			local maxhp = player:getMark("DzhaoyunBPReviveTimes")
			maxhp = math.max(1, maxhp)
			if player:getMaxHp() < maxhp then
				room:notifySkillInvoked(player, "DzhaoyunBP") --显示技能发动
				room:setPlayerProperty(player, "maxhp", sgs.QVariant(maxhp))
				room:setPlayerProperty(player, "hp", sgs.QVariant(maxhp))
				local msg = sgs.LogMessage()
				msg.type = "#DzhaoyunBPBugAvoid_LoseMaxHp"
				msg.from = player
				msg.arg = maxhp
				room:sendLog(msg) --发送提示信息
			end
		end
		return false
	end,
	priority = 999,
}
BugZhaoYun:addSkill(BugAvoid)
sgs.LoadTranslationTable{
	["#DzhaoyunBPBugAvoid_Damage"] = "BUG：%from 防止了 %arg 点伤害",
	["#DzhaoyunBPBugAvoid_LoseHp"] = "BUG：%from 防止了 %arg 点体力流失",
	["#DzhaoyunBPBugAvoid_LoseMaxHp"] = "BUG：%from 将体力上限和体力重置为 %arg",
}
--防止成为其他角色使用的技能卡的目标
BugProtect = sgs.CreateProhibitSkill{
	name = "#BugProtect",
	is_prohibited = function(self, from, to, card)
		if to:hasSkill("#BugProtect") and card:isKindOf("SkillCard") then
			if from:objectName() ~= to:objectName() then
				return true
			end
		end
		return false
	end,
}
BugZhaoYun:addSkill(BugProtect)
sgs.LoadTranslationTable{
	["#BugProtect"] = "BUG",
}
--手牌上限+999
BugKeep = sgs.CreateMaxCardsSkill{
	name = "#BugKeep",
	extra_func = function(self, target)
		if target:hasSkill("#BugKeep") then
			return 999
		end
		return 0
	end,
}
BugZhaoYun:addSkill(BugKeep)
sgs.LoadTranslationTable{
	["#BugKeep"] = "BUG",
}
--死后满状态复活，每复活1次加1点体力上限，复活7次后强制判定胜利
BugRevive = sgs.CreateTriggerSkill{
	name = "#BugRevive",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameOverJudge, sgs.Death, sgs.BuryVictim},
	global = true,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local death = data:toDeath()
		local victim = death.who
		if victim and victim:objectName() == player:objectName() then
			if event == sgs.GameOverJudge then
				if player:hasSkill("#BugRevive") then
					room:setTag("SkipGameRule", sgs.QVariant(true))
				end
			elseif event == sgs.Death then
				if player:hasSkill("#BugRevive") then
					room:setPlayerMark(player, "DzhaoyunBPRevive", 1)
				end
			elseif event == sgs.BuryVictim then
				if player:getMark("DzhaoyunBPRevive") == 0 then
					return false
				end
				room:setPlayerMark(player, "DzhaoyunBPRevive", 0)
				room:notifySkillInvoked(player, "DzhaoyunBP") --显示技能发动
				local msg = sgs.LogMessage()
				msg.type = "#DzhaoyunBPRevive"
				msg.from = player
				room:sendLog(msg) --发送提示信息
				local revive_times = player:getMark("DzhaoyunBPReviveTimes") + 1
				room:revivePlayer(player)
				room:setPlayerMark(player, "DzhaoyunBPReviveTimes", revive_times)
				if player:getMaxHp() < revive_times then
					room:setPlayerProperty(player, "maxhp", sgs.QVariant(revive_times))
				end
				local maxhp = player:getMaxHp()
				if player:getHp() < maxhp then
					room:setPlayerProperty(player, "hp", sgs.QVariant(maxhp))
				end
				if player:isChained() then
					room:setPlayerProperty(player, "chained", sgs.QVariant(false))
					room:broadcastProperty(player, "chained")
				end
				if not player:faceUp() then
					room:setPlayerProperty(player, "faceup", sgs.QVariant(true))
					room:broadcastProperty(player, "faceup")
				end
				if revive_times >= 7 then
					room:gameOver(player:objectName())
				end
				player:acquireSkill("#BugAvoid")
				player:acquireSkill("#BugProtect")
				player:acquireSkill("#BugKeep")
				room:setTag("SkipGameRule", sgs.QVariant(true))
			end
		end
		return false
	end,
	can_trigger = function(self, target)
		return target
	end,
	priority = 999,
}
BugZhaoYun:addSkill(BugRevive)
sgs.LoadTranslationTable{
	["#BugRevive"] = "BUG",
	["#DzhaoyunBPRevive"] = "BUG：%from 是永生的！"
}
--[[****************************************************************
	召唤隐藏武将
]]--****************************************************************
callHiddenGeneral = sgs.CreateTriggerSkill{
	name = "#callHiddenGeneral",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.GameStart},
	on_trigger = function(self, event, player, data)
		if GenLv == 0 then
			return false
		elseif math.random(1, 100) > 100 * GenRate then
			return false
		end
		local room = player:getRoom()
		if room:getTag("Dzhaoyun_CallHiddenGeneral"):toBool() then
			return false
		end
		local name = player:getGeneralName()
		local zhaoyun = nil
		if OpenMode then
			if GenLv >= 9999 then
				zhaoyun = "DzhaoyunBP"
			elseif GenLv >= 999 then
				zhaoyun = "DzhaoyunUP"
			elseif GenLv >= 99 then
				zhaoyun = "DzhaoyunSP"
			elseif GenLv > 0 then
				local x = math.random(1, 3)
				if x == 1 then
					zhaoyun = "DzhaoyunSP"
				elseif x == 2 then
					zhaoyun = "DzhaoyunUP"
				elseif x == 3 then
					zhaoyun = "DzhaoyunBP"
				end
			elseif GenLv < 0 then
				room:killPlayer(player)
				return false
			end
		elseif GenLv == 1 and name == "Dzhaoyun6P" then
			zhaoyun = "DzhaoyunSP"
		elseif GenLv == 2 and name == "Dzhaoyun5P" then
			zhaoyun = "DzhaoyunUP"
		elseif GenLv == 3 and name == "Dzhaoyun12P" then
			zhaoyun = "DzhaoyunBP"
		end
		if zhaoyun then
			room:doSuperLightbox(zhaoyun, zhaoyun) --播放全屏技能特效
			room:setTag("Dzhaoyun_CallHiddenGeneral", sgs.QVariant(true))
			room:changeHero(player, zhaoyun, true, true, false, true)
			room:setTag("Dzhaoyun_CallHiddenGeneral", sgs.QVariant(false))
		end
		return false
	end,
}
if OpenMode or palno == 5 or palno == 6 or palno == 12 then
	ZhaoYun:addSkill(callHiddenGeneral)
end