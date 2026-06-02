local Dispatcher = require("dispatcher")
local InfoMessage = require("ui/widget/infomessage")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")
local T = require("ffi/util").template

local WordMaster = require("wordmaster")

local WordMasterPlugin = WidgetContainer:extend{
    name = "wordmaster",
    is_doc_only = false,
}

function WordMasterPlugin:onDispatcherRegisterActions()
    Dispatcher:registerAction("wordmaster_colorize", {
        category = "none",
        event = "ColorizeVocabHighlights",
        title = _("Colorize Vocab Highlights"),
        general = true,
    })
end

function WordMasterPlugin:init()
    self:onDispatcherRegisterActions()
    self.ui.menu:registerToMainMenu(self)
end

function WordMasterPlugin:addToMainMenu(menu_items)
    menu_items.wordmaster = {
        text = _("Word Mastery"),
        sorting_hint = "more_tools",
        sub_item_table = {
            {
                text = _("Colorize Vocab Highlights"),
                callback = function()
                    self:onColorizeVocabHighlights()
                end,
                hold_callback = function()
                    UIManager:show(InfoMessage:new{
                        text = _("Updates highlight colors based on vocabulary mastery level:\n\nRed – new or forgot the word\nYellow – learning (reviewed, not yet mastered)\nGreen – mastered (5+ correct reviews)"),
                    })
                end,
            },
        },
    }
end

function WordMasterPlugin:onColorizeVocabHighlights()
    if not self.ui.annotation or not self.ui.annotation.annotations then
        UIManager:show(InfoMessage:new{
            text = _("No annotations found in the current document."),
        })
        return true
    end

    local vocab_words = WordMaster.getVocabWords()
    if vocab_words == nil then
        UIManager:show(InfoMessage:new{
            text = _("Vocabulary Builder database not found. Open the Vocabulary Builder plugin and add some words first."),
        })
        return true
    end

    local word_count = 0
    for _, _ in pairs(vocab_words) do
        word_count = word_count + 1
    end
    if word_count == 0 then
        UIManager:show(InfoMessage:new{
            text = _("No vocabulary words found. Add words using the Vocabulary Builder plugin first."),
        })
        return true
    end

    local stats = {}
    local count = WordMaster.colorizeAnnotations(
        self.ui.annotation.annotations,
        vocab_words,
        stats
    )

    if count == 0 then
        UIManager:show(InfoMessage:new{
            text = _("No highlights matched vocabulary words in this document."),
        })
        return true
    end

    self.ui.doc_settings:saveSetting("annotations", self.ui.annotation.annotations)
    UIManager:setDirty("all", "ui")

    local summary = T(
        _("Updated %1 highlights:\n  Red (new): %2\n  Yellow (learning): %3\n  Green (mastered): %4"),
        count,
        stats["red"] or 0,
        stats["yellow"] or 0,
        stats["green"] or 0
    )

    UIManager:show(InfoMessage:new{
        text = summary,
    })

    return true
end

return WordMasterPlugin
