--- STEAMODDED HEADER
--- MOD_NAME: 7 Deadly Sins
--- MOD_ID: 7deadlysins
--- MOD_AUTHOR: [Alex Davies, elbe]
--- MOD_DESCRIPTION: A mod themed around the seven deadly sins
--- BADGE_COLOUR: C24527
--- PREFIX: 7sins

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas({
    key = "sins",
    atlas_table = "ASSET_ATLAS",
    path = "jokers.png",
    px = 71,
    py = 95
})

local lust = SMODS.Joker{
	name = "Lust",
	key = "lust",
    config = { extra={ chips=100 } },
    pos = { x = 2, y = 0 },
	loc_txt = {
        name = "Lust",
        text = {
            "{C:chips}+#1#{} Chips if played",
            "hand contains both",
            "a scoring {C:attention}King{} and {C:attention}Queen{}"
        }
	},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
        if context.joker_main then
            local king = nil;
            local queen = nil;
            for _, v in pairs(context.scoring_hand) do
                if v.base.id == 13 and (king == nil or king.debuff) then king = v end
                if v.base.id == 12 and (queen == nil or queen.debuff) then queen = v end
            end
            if king and queen then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        king:juice_up();
                        queen:juice_up();
                        return true;
                    end
                }));
                if not king.debuff and not queen.debuff then
                    return {
                        message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                        chip_mod = card.ability.extra.chips,
                        colour = G.C.CHIPS
                    };
                else
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    };
                end
            end
        end
	end,
}
local gluttony = SMODS.Joker{
	name = "Gluttony",
	key = "gluttony",
    config = {
        extra= {
            chips=0,
            increment=8
        }
    },
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Gluttony",
        text = { 
            "This joker gains {C:chips}+#2#{} Chips",
            "per card destroyed",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}"
        }
	},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips, center.ability.extra.increment } }
	end,
	calculate = function(self, card, context)
        if context.cards_destroyed and not context.blueprint then
            print("cards destroyed")
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.increment * #context.glass_shattered;
            if #context.glass_shattered > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type='variable',key='a_mult',vars={card.ability.extra.increment * #context.glass_shattered}},
                            colour = G.C.CHIPS
                        });
                        return true
                    end }));
            end
        elseif context.remove_playing_cards and not context.blueprint then
            print("cards removed")
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.increment * #context.removed;
            if #context.removed > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type='variable',key='a_mult',vars={card.ability.extra.increment * #context.removed}}, 
                            colour = G.C.CHIPS
                        });
                        return true
                    end }));
            end
        elseif context.joke_main and card.ability.extra.chips > 0 then
            print("doing an update")
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
	end,
}
local greed = SMODS.Joker{
	name = "Greed",
	key = "greed",
    config = { extra = {xmult = 0.25, dollars = 15} },
    pos = { x = 6, y = 0 },
	loc_txt = {
        name = "Greed",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult for",
            "every {C:gold}#2#${} you have",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive}){}"
        }
	},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        local greed_mult = 1 + center.ability.extra.xmult * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/center.ability.extra.dollars)
        return { vars = { center.ability.extra.xmult, center.ability.extra.dollars, greed_mult } }
	end,
	calculate = function(self, card, context)
        if context.joker_main then 
            local greed_mult = math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.dollars)
            return {
                message = localize{type='variable',key='a_xmult',vars={1 + card.ability.extra.xmult * greed_mult}},
                Xmult_mod = 1 + card.ability.extra.xmult * greed_mult
            }
        end
	end,
}
local wrath = SMODS.Joker{
	name = "Wrath",
	key = "wrath",
    config = {  },
    pos = { x = 5, y = 0 },
	loc_txt = {
        name = "Wrath",
        text = {
            "When {C:attention}Blind{} is selected,",
            "{C:attention}destroy{} a random Joker",
            "then create a random {C:spectral}Spectral{} card",
            "{C:inactive}(Can destroy self){}",
        }
	},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        return { vars = {  } }
	end,
	calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local destructable_jokers = {}
            for i = 1, #G.jokers.cards do
                if not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
            end
            local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('wrath')) or nil

            if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        local new_card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sea');
                        new_card:add_to_deck();
                        G.consumeables:emplace(new_card);
                        G.GAME.consumeable_buffer = 0;
                    else
                        card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = localize('k_plus_spectral')});
                    end
                return true end }))
            end
        end
	end,
}
local sloth = SMODS.Joker{
	name = "Sloth",
	key = "sloth",
    config = { extra= {
        xmult=2.0,
        decrement=0.25,
        in_shop = false}
    },
    pos = { x = 1, y = 0 },
	loc_txt = {
        name = "Sloth",
        text = {
            "This Joker loses {X:mult,C:white}X#2#{} Mult",
            "each time you buy from",
            "the {C:gold}shop{}, resets when",
            "{C:attention}Boss Blind{} is defeated",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
        }
	},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = false,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.xmult, center.ability.extra.decrement} }
	end,
	calculate = function(self, card, context)
        if context.end_of_round then
            card.ability.extra.in_shop = true;
        elseif context.ending_shop  then
            card.ability.extra.in_shop = false;
        elseif (context.buying_card or context.open_booster) then
            if (card.ability.extra.in_shop) then
                card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.decrement;
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.decrement}},
                            colour = G.C.MULT
                        });
                        return true
                    end }));
            end
        end
        if context.end_of_round and not context.blueprint and G.GAME.blind.boss and card.ability.extra.xmult < 2 then
            card.ability.extra.xmult = 2;
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        elseif context.joker_main and card.ability.extra.xmult > 1 then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                Xmult_mod = card.ability.extra.xmult
            }
        end
	end,
}
local envy = SMODS.Joker{
	name = "Envy",
	key = "envy",
    config = { extra={mult=3} },
    pos = { x = 4, y = 0 },
	loc_txt = {
        name = "Envy",
        text = {
            "Adds {C:attention}triple{} the difference",
            "in rank between the {C:attention}lowest{}",
            "and {C:attention}highest{} scoring cards to Mult"
        }
	},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        return { vars = {  } }
	end,
	calculate = function(self, card, context)
        if context.joker_main then
            local min_rank = 11;
            local max_rank = 0;
            local min_card = nil;
            local max_card = nil;
            for _, v in ipairs(context.scoring_hand) do
                if v.ability.effect ~= 'Stone Card' then
                    if v.base.nominal > max_rank then
                        max_rank = v.base.nominal;
                        max_card = v;
                    end
                    if v.base.nominal <= min_rank then
                        min_rank = v.base.nominal;
                        min_card = v;
                    end
                end
            end
            local diff = max_rank - min_rank;
            if min_card and max_card and diff > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        min_card:juice_up();
                        max_card:juice_up();
                        return true;
                    end
                }));
                if not min_card.debuff and not max_card.debuff then
                    return {
                        message = localize{type='variable',key='a_mult',vars={diff * card.ability.extra.mult}},
                        mult_mod = diff * card.ability.extra.mult
                    };
                else
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    };
                end
            end
        end
	end,
}
local pride = SMODS.Joker{
	name = "Pride",
	key = "pride",
    config = { },
    pos = { x = 3, y = 0 },
	loc_txt = {
        name = "Pride",
        text = { 
            "Other Jokers give Mult based on rarity",
            "{C:blue}Common{}: {C:mult}+2{} Mult",
            "{C:green}Uncommon{}: {C:mult}+4{} Mult",
            "{C:red}Rare{}: {C:mult}+8{} Mult",
            "{C:legendary,E:1}Legendary{}: {C:mult}+16{} Mult"
        }
	},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        return { vars = { } }
	end,
	calculate = function(self, card, context)
        if context.other_joker and context.other_joker ~= card then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }));
            local score = 0;
            local rarity = context.other_joker.config.center.rarity;
            if rarity == 1 then score = 2
            elseif rarity == 2 then score = 4
            elseif rarity == 3 then score = 8
            elseif rarity == 4 then score = 16
            end
            return {
                message = localize{type='variable',key='a_mult',vars={score}},
                mult_mod = score,
                card = card
            }
        end
	end,
}

if JokerDisplay then
    local jd_def = JokerDisplay.Definitions

    jd_def['j_7sins_lust'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
        calc_function = function(card)
            local _, _, scoring_hand = JokerDisplay.evaluate_hand()
            local chips = 0
            local king = false
            local queen = false
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() and scoring_card:get_id() == 12 then
                    queen = true
                elseif scoring_card:get_id() and scoring_card:get_id() == 13 then
                    king = true
                end
            end
            if king and queen then
                chips = card.ability.extra.chips
            end
            card.joker_display_values.dollars = chips
        end
    }
    jd_def['j_7sins_gluttony'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
    }
    jd_def['j_7sins_greed'] = {
        text = {
            {
                border_nodes = {
                    { text = 'X'},
                    { ref_table = 'card.joker_display_values', ref_value = 'Xmult', retrigger_type = 'exp' },
                }
            }
        },
        calc_function = function(card)
            local greed_mult = math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.extra.dollars)
            card.joker_display_values.Xmult = 1 + card.ability.extra.xmult * greed_mult
        end
    }
    jd_def['j_7sins_sloth'] = {
        text = {
            {
                border_nodes = {
                    { text = 'X'},
                    { ref_table = 'card.ability.extra', ref_value = 'xmult', retrigger_type = 'exp' },
                }
            }
        },
    }
    jd_def['j_7sins_envy'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local min_rank = 11;
            local max_rank = 0;
            local _, _, scoring_hand = JokerDisplay.evaluate_hand()
            for _, v in pairs(scoring_hand) do
                if v.ability.effect ~= 'Stone Card' then
                    if v.base.nominal > max_rank then
                        max_rank = v.base.nominal;
                    end
                    if v.base.nominal <= min_rank then
                        min_rank = v.base.nominal;
                    end
                end
            end
            local diff = max_rank - min_rank;
            card.joker_display_values.mult = diff * card.ability.extra.mult
        end
    }
    jd_def['j_7sins_pride'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local mult = 0
            if G.jokers then
                for _,v in pairs(G.jokers.cards) do
                    local score = 0
                    if v ~= card then
                        local rarity = v.config.center.rarity;
                        if rarity == 1 then score = 2
                        elseif rarity == 2 then score = 4
                        elseif rarity == 3 then score = 8
                        elseif rarity == 4 then score = 16
                        end
                        mult = mult + score
                    end
                end
            end
            card.joker_display_values.mult = mult
        end
    }
end

local sin_jokers = { 'j_7sins_lust', 'j_7sins_gluttony', 'j_7sins_greed', 'j_7sins_wrath', 'j_7sins_sloth', 'j_7sins_envy', 'j_7sins_pride' };

local function deepcopy(o, seen)
    seen = seen or {}
    if o == nil then return nil end
    if seen[o] then return seen[o] end

    local no
    if type(o) == 'table' then
    no = {}
    seen[o] = no

        for k, v in next, o, nil do
            no[deepcopy(k, seen)] = deepcopy(v, seen)
        end
        setmetatable(no, deepcopy(getmetatable(o), seen))
    else -- number, string, boolean, etc
        no = o
    end
    return no
end

local function apply_sin_card_ui(card)
    local joker_key = card.ability.extra.current_sin
    local joker = G.P_CENTERS[joker_key];

    card.ability.name = joker.name;
    card.children.center.sprite_pos = { x = joker.pos.x, y = 1 };
    local new_config = deepcopy(card.config);
    if not new_config then return end
    new_config.center.key = joker_key..'_sin';
    card.config = new_config;
end

local function update_sin_card(card, choices)
    local new_joker_key = pseudorandom_element(choices, pseudoseed('sin'));
    local new_joker = G.P_CENTERS[new_joker_key]
    if not new_joker then
        new_joker_key = new_joker_key:gsub("7sins_","")
        new_joker = G.P_CENTERS[new_joker_key]
    end
    
    print(new_joker_key)
    print(tostring(new_joker.config))
    local old_joker_key = card.ability.extra.current_sin;
    -- Store current card data
    if old_joker_key then
        local old_joker = G.P_CENTERS[old_joker_key];
        local saved = {}
        for k, _ in pairs(old_joker.config) do
            saved[k] = card.ability.extra[k];
        end
        card.ability.extra.saved[old_joker_key] = saved;
    end

    for k, v in pairs(new_joker.config.extra or {}) do
        if (card.ability.extra.saved[new_joker_key] or {})[k] ~= nil then
            card.ability.extra[k] = card.ability.extra.saved[new_joker_key][k];
        else
            card.ability.extra[k] = v;
        end
    end

    card.ability.extra.current_sin = new_joker_key;

    apply_sin_card_ui(card, choices);
end

local sin = SMODS.Joker{
	name = "Sin",
	key = "Sin",
    config = { extra = {is_sin = true, saved = {}} },
    pos = { x = 7, y = 1 },
    soul_pos = {x = 7, y = 0},
	loc_txt = {
        name = "Sin",
        text = {
            "Disguises as a random Sin",
            "Sin changes when {C:attention}Boss Blind{} is defeated"
        }
	},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "sins",
	loc_vars = function(self, info_queue, center)
        return { vars = {  } }
	end,
	calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and G.GAME.blind.boss and not card.getting_sliced and type(card.ability.extra) == 'table' and not context.blueprint then
            update_sin_card(card, sin_jokers);
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up();
                    return true
                end
            }));
        end
	end,
    load = function(self, card, cardTable, other_card)
        update_sin_card(card, sin_jokers);
    end,
    add_to_deck = function(self, card, from_debuff)
        update_sin_card(card, sin_jokers);
    end
}

SMODS.Challenge{
    key = 'politics',
    name = 'Politics',
    loc_txt = {
        name = 'Politics',
    },
    deck = {
        type = 'Challenge Deck'
    },
    rules = {
        custom = {},
        modifiers = {
            { id = 'joker_slots', value = 8 }
        }
    },
    jokers = {
        {id = 'j_7sins_sin', eternal = true},
        {id = 'j_7sins_sin', eternal = true},
        {id = 'j_7sins_sin', eternal = true},
        {id = 'j_7sins_sin', eternal = true},
        {id = 'j_7sins_sin', eternal = true},
    },
    consumeables = {},
    vouchers = {},
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    }
}
SMODS.Challenge{
    key = 'furious',
    name = "Forever Furious",
    loc_txt = {
        name = 'Forever Furious',
    },
    deck = {
        type = 'Challenge Deck'
    },
    rules = {
        custom = {},
        modifiers = {}
    },
    jokers = {
        {id = 'j_7sins_wrath', eternal = true}
    },
    consumeables = {},
    vouchers = {},
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    }
}
SMODS.Challenge{
    key = 'delicate',
    name = "Delicate Indulgences",
    loc_txt = {
        name = "Delicate Indulgences",
    },
    deck = {
        cards = {{s='D',r='2',e='m_glass',},{s='D',r='3',e='m_glass',},{s='D',r='4',e='m_glass',},{s='D',r='5',e='m_glass',},{s='D',r='6',e='m_glass',},{s='D',r='7',e='m_glass',},{s='D',r='8',e='m_glass',},{s='D',r='9',e='m_glass',},{s='D',r='T',e='m_glass',},{s='D',r='J',e='m_glass',},{s='D',r='Q',e='m_glass',},{s='D',r='K',e='m_glass',},{s='D',r='A',e='m_glass',},{s='C',r='2',e='m_glass',},{s='C',r='3',e='m_glass',},{s='C',r='4',e='m_glass',},{s='C',r='5',e='m_glass',},{s='C',r='6',e='m_glass',},{s='C',r='7',e='m_glass',},{s='C',r='8',e='m_glass',},{s='C',r='9',e='m_glass',},{s='C',r='T',e='m_glass',},{s='C',r='J',e='m_glass',},{s='C',r='Q',e='m_glass',},{s='C',r='K',e='m_glass',},{s='C',r='A',e='m_glass',},{s='H',r='2',e='m_glass',},{s='H',r='3',e='m_glass',},{s='H',r='4',e='m_glass',},{s='H',r='5',e='m_glass',},{s='H',r='6',e='m_glass',},{s='H',r='7',e='m_glass',},{s='H',r='8',e='m_glass',},{s='H',r='9',e='m_glass',},{s='H',r='T',e='m_glass',},{s='H',r='J',e='m_glass',},{s='H',r='Q',e='m_glass',},{s='H',r='K',e='m_glass',},{s='H',r='A',e='m_glass',},{s='S',r='2',e='m_glass',},{s='S',r='3',e='m_glass',},{s='S',r='4',e='m_glass',},{s='S',r='5',e='m_glass',},{s='S',r='6',e='m_glass',},{s='S',r='7',e='m_glass',},{s='S',r='8',e='m_glass',},{s='S',r='9',e='m_glass',},{s='S',r='T',e='m_glass',},{s='S',r='J',e='m_glass',},{s='S',r='Q',e='m_glass',},{s='S',r='K',e='m_glass',},{s='S',r='A',e='m_glass',},},
        type = 'Challenge Deck'
    },
    rules = {
        custom = {},
        modifiers = {
            scaling = 2
        }
    },
    jokers = {
        {id = 'j_7sins_gluttony', eternal = true}
    },
    consumeables = {},
    vouchers = {},
    restrictions = {
        banned_cards = {
            {id = 'c_magician'},
            {id = 'c_empress'},
            {id = 'c_heirophant'},
            {id = 'c_chariot'},
            {id = 'c_devil'},
            {id = 'c_tower'},
            {id = 'c_lovers'},
            {id = 'c_incantation'},
            {id = 'c_grim'},
            {id = 'c_familiar'},
            {id = 'p_standard_normal_1', ids = {
                'p_standard_normal_1','p_standard_normal_2','p_standard_normal_3','p_standard_normal_4','p_standard_jumbo_1','p_standard_jumbo_2','p_standard_mega_1','p_standard_mega_2',
            }},
            {id = 'j_marble'},
            {id = 'j_vampire'},
            {id = 'j_midas_mask'},
            {id = 'j_certificate'},
            {id = 'v_magic_trick'},
            {id = 'v_illusion'},
        },
        banned_tags = {
            {id = 'tag_standard'},
        },
        banned_other = {}
    }
}

G.localization.misc.v_dictionary['a_xchips'] = "X#1#";

----------------------------------------------
------------MOD CODE END----------------------