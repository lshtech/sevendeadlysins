--- STEAMODDED HEADER
--- MOD_NAME: 7 Deadly Sins
--- MOD_ID: 7deadlysins
--- MOD_AUTHOR: [Alex Davies]
--- MOD_DESCRIPTION: A mod themed around the seven deadly sins
--- BADGE_COLOUR: C24527

----------------------------------------------
------------MOD CODE -------------------------

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

function update_sin_card(card, choices, jokers)
    local new_joker_key = pseudorandom_element(choices, pseudoseed('sin'));
    local new_joker = jokers[new_joker_key];

    local old_joker_key = card.ability.extra.current_sin;
    -- Store current card data
    if old_joker_key then
        local old_joker = jokers[old_joker_key];
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

    apply_sin_card_ui(card, jokers);
end

function apply_sin_card_ui(card, jokers)
    local joker_key = card.ability.extra.current_sin
    if joker_key == nil then return end

    local joker = jokers[joker_key];

    card.ability.name = joker.name;
    card.children.center.sprite_pos = { x = joker.spritePos.x, y = 1 };
    local new_config = deepcopy(card.config);
    new_config.center.key = joker_key..'_sin';
    card.config = new_config;
end

function add_challenges()
    table.insert(G.CHALLENGES,1,{
        name = "Politics",
        id = 'c_mod_politics',
        rules = {
            custom = {},
            modifiers = {
                { id = 'joker_slots', value = 8 }
            }
        },
        jokers = {
            {id = 'j_sin', eternal = true},
            {id = 'j_sin', eternal = true},
            {id = 'j_sin', eternal = true},
            {id = 'j_sin', eternal = true},
            {id = 'j_sin', eternal = true},
        },
        consumeables = {},
        vouchers = {},
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {},
            banned_tags = {},
            banned_other = {}
        }
    })
    G.localization.misc.challenge_names.c_mod_politics = "Politics";
    
    table.insert(G.CHALLENGES,2,{
        name = "Forever Furious",
        id = 'c_mod_furious',
        rules = {
            custom = {},
            modifiers = {}
        },
        jokers = {
            {id = 'j_wrath', eternal = true}
        },
        consumeables = {},
        vouchers = {},
        deck = {
            type = 'Challenge Deck'
        },
        restrictions = {
            banned_cards = {},
            banned_tags = {},
            banned_other = {}
        }
    })
    G.localization.misc.challenge_names.c_mod_furious = "Forever Furious";

    table.insert(G.CHALLENGES,3,{
        name = "Delicate Indulgences",
        id = 'c_mod_delicate',
        rules = {
            custom = {},
            modifiers = {
                scaling = 2
            }
        },
        jokers = {
            {id = 'j_gluttony', eternal = true}
        },
        consumeables = {},
        vouchers = {},
        deck = {
            cards = {{s='D',r='2',e='m_glass',},{s='D',r='3',e='m_glass',},{s='D',r='4',e='m_glass',},{s='D',r='5',e='m_glass',},{s='D',r='6',e='m_glass',},{s='D',r='7',e='m_glass',},{s='D',r='8',e='m_glass',},{s='D',r='9',e='m_glass',},{s='D',r='T',e='m_glass',},{s='D',r='J',e='m_glass',},{s='D',r='Q',e='m_glass',},{s='D',r='K',e='m_glass',},{s='D',r='A',e='m_glass',},{s='C',r='2',e='m_glass',},{s='C',r='3',e='m_glass',},{s='C',r='4',e='m_glass',},{s='C',r='5',e='m_glass',},{s='C',r='6',e='m_glass',},{s='C',r='7',e='m_glass',},{s='C',r='8',e='m_glass',},{s='C',r='9',e='m_glass',},{s='C',r='T',e='m_glass',},{s='C',r='J',e='m_glass',},{s='C',r='Q',e='m_glass',},{s='C',r='K',e='m_glass',},{s='C',r='A',e='m_glass',},{s='H',r='2',e='m_glass',},{s='H',r='3',e='m_glass',},{s='H',r='4',e='m_glass',},{s='H',r='5',e='m_glass',},{s='H',r='6',e='m_glass',},{s='H',r='7',e='m_glass',},{s='H',r='8',e='m_glass',},{s='H',r='9',e='m_glass',},{s='H',r='T',e='m_glass',},{s='H',r='J',e='m_glass',},{s='H',r='Q',e='m_glass',},{s='H',r='K',e='m_glass',},{s='H',r='A',e='m_glass',},{s='S',r='2',e='m_glass',},{s='S',r='3',e='m_glass',},{s='S',r='4',e='m_glass',},{s='S',r='5',e='m_glass',},{s='S',r='6',e='m_glass',},{s='S',r='7',e='m_glass',},{s='S',r='8',e='m_glass',},{s='S',r='9',e='m_glass',},{s='S',r='T',e='m_glass',},{s='S',r='J',e='m_glass',},{s='S',r='Q',e='m_glass',},{s='S',r='K',e='m_glass',},{s='S',r='A',e='m_glass',},},
            type = 'Challenge Deck'
        },
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
    })
    G.localization.misc.challenge_names.c_mod_delicate = "Delicate Indulgences";
end

function SMODS.INIT.TheDivineComedy()

    add_challenges();
    
    init_localization()

    local localization = {
        j_sloth = {
            name = "Sloth",
            text = {
                "This Joker loses {X:mult,C:white}X#2#{} Mult",
                "each time you buy from",
                "the {C:gold}shop{}, resets when",
                "{C:attention}Boss Blind{} is defeated",
                "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
            }
        },
        j_gluttony = {
            name = "Gluttony",
            text = { 
                "This joker gains {C:chips}+#2#{} Chips",
                "per card destroyed",
                "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}"
            }
        },
        j_pride = {
            name = "Pride",
            text = { 
                "Other Jokers give Mult based on rarity",
                "{C:blue}Common{}: {C:mult}+2{} Mult",
                "{C:green}Uncommon{}: {C:mult}+4{} Mult",
                "{C:red}Rare{}: {C:mult}+8{} Mult",
                "{C:legendary,E:1}Legendary{}: {C:mult}+16{} Mult"
            }
        },
        j_lust = {
            name = "Lust",
            text = {
                "{C:chips}+#1#{} Chips if played",
                "hand contains both",
                "a scoring {C:attention}King{} and {C:attention}Queen{}"
            }
        },
        j_wrath = {
            name = "Wrath",
            text = {
                "When {C:attention}Blind{} is selected,",
                "{C:attention}destroy{} a random Joker",
                "then create a random {C:spectral}Spectral{} card",
                "{C:inactive}(Can destroy self){}",
            }
        },
        j_greed = {
            name = "Greed",
            text = {
                "Gains {X:mult,C:white}X#1#{} Mult for",
                "every {C:gold}#2#${} you have",
                "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive}){}"
            }
        },
        j_envy = {
            name = "Envy",
            text = {
                "Adds {C:attention}triple{} the difference",
                "in rank between the {C:attention}lowest{}",
                "and {C:attention}highest{} scoring cards to Mult"
            }
        },
        j_sin = {
            name = "Sin",
            text = {
                "Disguises as a random Sin",
                "Sin changes when {C:attention}Boss Blind{} is defeated"
            }
        }
    }

    local jokers = {
        j_sloth = SMODS.Joker:new(
            "Sloth", "sloth",
            { extra={xmult=2.0, decrement=0.25, in_shop = false} },
            { x = 1, y = 0 }, loc_def,
            2, 6, true, true, true, true
        ),
        j_gluttony = SMODS.Joker:new(
            "Gluttony", "gluttony",
            { extra={chips=0, increment=8} },
            { x = 0, y = 0 }, loc_def,
            2, 6, true, true, true, true
        ),
        j_pride = SMODS.Joker:new(
            "Pride", "pride",
            { },
            { x = 3, y = 0 }, loc_def,
            2, 6, true, true, true, true
        ),
        j_lust = SMODS.Joker:new(
            "Lust", "lust",
            { extra={chips=100} },
            { x = 2, y = 0 }, loc_def,
            2, 6, true, true, true, true
        ),
        j_wrath = SMODS.Joker:new(
            "Wrath", "wrath",
            { },
            { x = 5, y = 0 }, loc_def,
            2, 6, true, true, true, true
        ),
        j_greed = SMODS.Joker:new(
            "Greed", "greed",
            { extra = {xmult = 0.25, dollars = 15} },
            { x = 6, y = 0 }, loc_def,
            2, 6, true, true, true, true
        ),
        j_envy = SMODS.Joker:new(
            "Envy", "envy",
            { extra={mult=3} },
            { x = 4, y = 0 }, loc_def,
            2, 6, true, true, true, true
        ),
        j_sin = SMODS.Joker:new(
            "Sin", "sin",
            { extra = {is_sin = true, saved = {}} },
            { x = 7, y = 1 }, loc_def,
            3, 6, true, true, true, true
        )
    }
    local sin_jokers = { 'j_sloth', 'j_gluttony', 'j_pride', 'j_lust', 'j_wrath', 'j_greed', 'j_envy' };

    for k, v in pairs(localization) do
        if k ~= 'j_sin' then
            G.localization.descriptions.Joker[k..'_sin'] = {
                name = v.name..'?',
                text = v.text
            };
        end
    end
    G.localization.misc.v_dictionary['a_xchips'] = "X#1#";

    local order = { 'j_lust', 'j_gluttony', 'j_greed', 'j_wrath', 'j_sloth', 'j_envy', 'j_pride', 'j_sin' };

    SMODS.Sprite:new("7deadlysins", SMODS.findModByID("7deadlysins").path, "jokers.png", 71, 95, "asset_atli"):register();
    for _, k in ipairs(order) do
        local v = jokers[k]
        v.slug = k
        v.loc_txt = localization[k]
        v.mod = "7deadlysins"
        v.atlas = "7deadlysins"
        if k == 'j_sin' then
            v.soul_pos = {x = 7, y = 0}
        end
        v:register()
    end

    local load_old = Card.load;
    function Card:load(cardTable, other_card)
        load_old(self, cardTable, other_card);
        if type(self.ability.extra) == 'table' and self.ability.extra.is_sin then
            apply_sin_card_ui(self, jokers);
        end
    end

    local add_to_deck_old = Card.add_to_deck;
    function Card:add_to_deck(from_debuff)
        add_to_deck_old(self, from_debuff);
        if type(self.ability.extra) == 'table' and self.ability.extra.is_sin then
            update_sin_card(self, sin_jokers, jokers);
        end
    end

    local calculate_joker_old = Card.calculate_joker;
    function Card:calculate_joker(context)
        local ret_val = calculate_joker_old(self, context);

        if self.ability.set == "Joker" and not self.debuff then
            if context.other_joker and context.other_joker.ability.name == 'Pride' and context.other_joker ~= self then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        self:juice_up(0.5, 0.5)
                        return true
                    end
                }));
                local score = 0;
                local rarity = self.config.center.rarity;
                if rarity == 1 then score = 2
                elseif rarity == 2 then score = 4
                elseif rarity == 3 then score = 8
                elseif rarity == 4 then score = 16
                end
                return {
                    message = localize{type='variable',key='a_mult',vars={score}},
                    mult_mod = score,
                    card = context.other_joker
                }
            end
            if context.end_of_round and self.ability.name == 'Sloth' then
                self.ability.extra.in_shop = true;
            elseif context.ending_shop and self.ability.name == 'Sloth' then
                self.ability.extra.in_shop = false;
            elseif (context.buying_card or context.open_booster) and self.ability.name == 'Sloth' then
                if (self.ability.extra.in_shop) then
                    self.ability.extra.xmult = self.ability.extra.xmult - self.ability.extra.decrement;
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(self, 'extra', nil, nil, nil, {
                                message = localize{type='variable',key='a_xmult_minus',vars={self.ability.extra.decrement}}, 
                                colour = G.C.MULT
                            });
                            return true
                        end }));
                end
            elseif context.end_of_round then
                if not context.blueprint then
                    if self.ability.name == 'Sloth' and G.GAME.blind.boss and self.ability.extra.xmult < 2 then
                        self.ability.extra.xmult = 2;
                        return {
                            message = localize('k_reset'),
                            colour = G.C.RED
                        }
                    end
                end
            elseif context.setting_blind and not self.getting_sliced then
                if self.ability.name == 'Wrath' and not context.blueprint then
                    local destructable_jokers = {}
                    for i = 1, #G.jokers.cards do
                        if not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i] end
                    end
                    local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('wrath')) or nil
    
                    if joker_to_destroy and not (context.blueprint_card or self).getting_sliced then 
                        joker_to_destroy.getting_sliced = true
                        G.E_MANAGER:add_event(Event({func = function()
                            (context.blueprint_card or self):juice_up(0.8, 0.8)
                            joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                                local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sea');
                                card:add_to_deck();
                                G.consumeables:emplace(card);
                                G.GAME.consumeable_buffer = 0;
                            else
                                card_eval_status_text((context.blueprint_card or self), 'extra', nil, nil, nil, {message = localize('k_plus_spectral')});
                            end
                        return true end }))
                    end
                end                               
            elseif context.cards_destroyed and not context.blueprint then
                if self.ability.name == 'Gluttony' then
                    self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.increment * #context.glass_shattered;
                    if #context.glass_shattered > 0 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_eval_status_text(self, 'extra', nil, nil, nil, {
                                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.increment * #context.glass_shattered}},
                                    colour = G.C.CHIPS
                                });
                                return true
                            end }));
                    end
                end
            elseif context.remove_playing_cards and not context.blueprint then
                if self.ability.name == 'Gluttony' then
                    self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.increment * #context.removed;
                    if #context.removed > 0 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card_eval_status_text(self, 'extra', nil, nil, nil, {
                                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.increment * #context.removed}}, 
                                    colour = G.C.CHIPS
                                });
                                return true
                            end }));
                    end
                end
            end
            if context.cardarea == G.jokers then
                if context.joker_main then
                    if self.ability.name == 'Lust' then
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
                                    message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                                    chip_mod = self.ability.extra.chips,
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
                    if self.ability.name == 'Greed' then 
                        local greed_mult = math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/self.ability.extra.dollars)
                        return {
                            message = localize{type='variable',key='a_xmult',vars={1 + self.ability.extra.xmult * greed_mult}},
                            Xmult_mod = 1 + self.ability.extra.xmult * greed_mult
                        }
                    elseif self.ability.name == 'Sloth' and self.ability.extra.xmult > 1 then
                        return {
                            message = localize{type='variable',key='a_xmult',vars={self.ability.extra.xmult}},
                            Xmult_mod = self.ability.extra.xmult
                        }
                    elseif self.ability.name == 'Gluttony' and self.ability.extra.chips > 0 then
                        return {
                            message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                            chip_mod = self.ability.extra.chips,
                            colour = G.C.CHIPS
                        }
                    elseif self.ability.name == 'Envy' then
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
                                    message = localize{type='variable',key='a_mult',vars={diff * self.ability.extra.mult}},
                                    mult_mod = diff * self.ability.extra.mult
                                };
                            else
                                return {
                                    message = localize('k_debuffed'),
                                    colour = G.C.RED
                                };
                            end
                        end
                    end
                end
            end
            if context.end_of_round and not context.individual and not context.repetition and G.GAME.blind.boss and not self.getting_sliced and type(self.ability.extra) == 'table' and self.ability.extra.is_sin and not context.blueprint then
                update_sin_card(self, sin_jokers, jokers);
                G.E_MANAGER:add_event(Event({
                    func = function()
                        self:juice_up();
                        return true
                    end
                }));
            end
        end
        return ret_val;
    end

    local generate_UIBox_ability_old = Card.generate_UIBox_ability_table
    function Card.generate_UIBox_ability_table(self)
        local card_type, hide_desc = self.ability.set or "None", nil
        local loc_vars = nil
        local main_start, main_end = nil, nil
        local no_badge = nil

        if self.config.center.unlocked == false and not self.bypass_lock then
            -- For everything that is locked
        elseif card_type == 'Undiscovered' and not self.bypass_discovery_ui then
            -- Any Joker or tarot/planet/voucher that is not yet discovered
        elseif self.debuff then
            -- If the card is a debuff
        elseif card_type == 'Default' or card_type == 'Enhanced' then
            -- For Default or Enhanced cards
        elseif self.ability.set == 'Joker' then
            local customJoker = true

            if self.ability.name == 'Greed' then
                local greed_mult = 1 + self.ability.extra.xmult * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/self.ability.extra.dollars)
                loc_vars = {self.ability.extra.xmult, self.ability.extra.dollars, greed_mult}
            elseif self.ability.name == 'Sloth' then loc_vars = {self.ability.extra.xmult, self.ability.extra.decrement}
            elseif self.ability.name == 'Gluttony' then loc_vars = {self.ability.extra.chips, self.ability.extra.increment}
            elseif self.ability.name == 'Lust' then loc_vars = {self.ability.extra.chips}
            else
                customJoker = false
            end

            if customJoker then
                local badges = {}
                if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                    badges.card_type = card_type
                end
                if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                    badges.force_rarity = true
                end
                if self.edition then
                    if self.edition.type == 'negative' and self.ability.consumeable then
                        badges[#badges + 1] = 'negative_consumable'
                    else
                        badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                    end
                end
                if self.seal then
                    badges[#badges + 1] = string.lower(self.seal) .. '_seal'
                end
                if self.ability.eternal then
                    badges[#badges + 1] = 'eternal'
                end
                if self.pinned then
                    badges[#badges + 1] = 'pinned_left'
                end

                if self.sticker then
                    loc_vars = loc_vars or {}
                    loc_vars.sticker = self.sticker
                end

                return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start, main_end)
            end
        end

        return generate_UIBox_ability_old(self)
    end

    local draw_old = Card.draw;
    function Card:draw(layer)
        draw_old(self, layer);

        if self.ability.name == 'Sin' and self.ability.sin_card_sprite then
            -- self.ability.sin_card_sprite:draw_shader('dissolve', nil, 0.4, nil, self.children.center);
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------