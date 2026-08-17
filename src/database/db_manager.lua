local sqlite3 = require("lsqlite3")
local DBManager = {}

function DBManager.init()
    DBManager.db = sqlite3.open("batalha_naval.db")
    DBManager.db:exec[[
        CREATE TABLE IF NOT EXISTS ranking (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            score INTEGER,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        );
    ]]
end

function DBManager.save_score(name, score)
    local stmt = DBManager.db:prepare("INSERT INTO ranking (name, score) VALUES (?, ?)")
    stmt:bind_values(name, score)
    stmt:step()
    stmt:finalize()
end

function DBManager.get_ranking()
    local ranking = {}
    for row in DBManager.db:nrows("SELECT name, score, timestamp FROM ranking ORDER BY score DESC LIMIT 10") do
        table.insert(ranking, row)
    end
    return ranking
end

return DBManager
