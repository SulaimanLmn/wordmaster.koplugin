local DataStorage = require("datastorage")
local SQ3 = require("lua-ljsqlite3/init")

local WordMaster = {}

local DB_PATH = DataStorage:getSettingsDir() .. "/vocabulary_builder.sqlite3"

local MASTERY_LEVELS = {
    { min_streak = 5, color = "green",  label = "mastered" },
    { min_streak = 1, color = "yellow", label = "learning" },
    { min_streak = 0, color = "red",    label = "new" },
}

function WordMaster.getVocabWords()
    local db_conn = SQ3.open(DB_PATH)
    if not db_conn then return nil end
    local sql = "SELECT word, streak_count FROM vocabulary"
    local ok, results = pcall(db_conn.exec, db_conn, sql)
    db_conn:close()
    if not ok or not results or not results.word then return nil end
    local words = {}
    for i = 1, #results.word do
        words[results.word[i]:lower()] = tonumber(results.streak_count[i])
    end
    return words
end

function WordMaster.getMasteryColor(streak_count)
    for _, level in ipairs(MASTERY_LEVELS) do
        if streak_count >= level.min_streak then
            return level.color
        end
    end
    return "gray"
end

function WordMaster.colorizeAnnotations(annotations, vocab_words, stats)
    local updated_count = 0
    for _, annotation in ipairs(annotations) do
        if annotation.drawer and annotation.text then
            local text_lower = annotation.text:lower()
            local matched_streak = nil
            local matched_word = nil
            for word, streak in pairs(vocab_words) do
                if text_lower == word or text_lower:find(word, 1, true) then
                    if matched_streak == nil or streak < matched_streak then
                        matched_streak = streak
                        matched_word = word
                    end
                end
            end
            if matched_streak ~= nil then
                local new_color = WordMaster.getMasteryColor(matched_streak)
                if annotation.color ~= new_color then
                    annotation.color = new_color
                    updated_count = updated_count + 1
                    if stats then
                        stats[new_color] = (stats[new_color] or 0) + 1
                    end
                end
            end
        end
    end
    return updated_count
end

return WordMaster
