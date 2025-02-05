local export = {}

function export.languages()
    local ret = {}

    -- https://zh.wiktionary.org/wiki/Module:Zh
    local m_zh = require("Module:Zh")
    -- https://zh.wiktionary.org/wiki/Module:Languages
    local m_languages = require("Module:Languages")
    -- https://zh.wiktionary.org/wiki/Module:Languages/alldata
    local allData = mw.loadData("Module:Languages/alldata")

    local function addNames(allNames, names)
        for _, name in ipairs(names) do
            table.insert(allNames, name)
            local nameSimplified = m_zh.ts(name)
            if nameSimplified ~= name then
                table.insert(allNames, nameSimplified)
            end
        end
    end

    for code, _ in pairs(allData) do
        names = {}
        local lang = m_languages.getByCode(code)
        local canonicalName = lang:getCanonicalName()
        addNames(names, {canonicalName})
        -- the true arg gets ONLY otherNames, not including aliases/varieties
        local otherNames = lang:getOtherNames(true)
        addNames(names, otherNames)
        local aliases = lang:getAliases()
        addNames(names, aliases)
        ret[code] = names
    end
    
    return require("Module:wiktextract-json").toJSON(ret)

end

return export