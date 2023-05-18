--    S S SS     DDD        HHH HHH
--    S    S     D   D      HHH HHH
--    S          D     D    HHHHHHH
--    SSSSS      D     D    HHHHHHH             <- типо наш значок (SDH)
--        S      D     D    HHHHHHH
--        S      D   D      HHH HHH
--    SSSSS      DDD        HHH HHH

local frame = CreateFrame("Frame", nil, UIParent) -- создаем фрейм
frame:SetSize(200, 50) -- не знаю что это и зачем, но пусть будет
frame:SetPoint("CENTER") -- не знаю что это и зачем, но пусть будет

local startButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate") -- создаем кнопку старт
startButton:SetSize(80, 25) -- размеры кнопки старт
startButton:SetPoint("LEFT", 10, -400) -- позиция кнопки старт
startButton:SetText("Старт") -- текст кнопки

local stopButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate") -- создаем кнопку стоп
stopButton:SetSize(80, 25) -- размеры кнопки стоп
stopButton:SetPoint("RIGHT", -10, -400) -- позиция кнопки стоп
stopButton:SetText("Стоп") -- текст кнопки
stopButton:Disable() -- кнопка стоп по умолчания выключена

-- текст песни в [[ хз что это, в луа не шарю
local songText = [[
Крестики нолики
Две Миланы в домике
Укатились даже шарики за ролики
Улы-улыбаемся, разгоняя тучки
Люди обзываются что мы две почемучки

Отпути, не путю
Но кому я говорю
Не путю ведь я люблю
Свою лучшую подругу
Отпути, не путю
Но кому я говорю
Не путю ведь я люблю
Навсегда мы друг для друга

ЛП

Эники беники
В ютубе и на телеке
Мы тик ток доводим топы до истерики
Сразу все влюбляются
Когда хочу на ручки
Люди обзываются что мы две липучки

Отпути, не путю
Но кому я говорю
Не путю ведь я люблю
Свою лучшую подругу
Отпути, не путю
Но кому я говорю
Не путю ведь я люблю
Навсегда мы друг для друга
ЛП

У нас с тобой свой Дисней
Нам не надо кукол
Повсюду за мной везде
Моя лучшая подруга
ЛП
]]

local soundFile = "Interface\\AddOns\\MyAddon\\lp.mp3" -- Путь к вашему MP3 файлу
local currentSoundID -- Добавленная переменная для хранения идентификатора текущего звука

local function PlaySoundFiles(file) -- бред какой-то написанный чатомГПТ, но работает
    local soundID = PlayMusic(file) -- Воспроизведение звука и получение идентификатора звука
    currentSoundID = soundID

    return soundID
end


local lines = {}
local currentIndex = 1
local isPlaying = false

local function StopPlaying() -- кнопка Стоп (должна быть тут) почему хз
    if isPlaying and currentSoundID then
        -- Остановка звука с использованием сохраненного идентификатора звука
        StopMusic(currentSoundID)

        isPlaying = false
        startButton:Enable()
        stopButton:Disable()

        if frame.timer then
            frame.timer:Cancel()
            frame.timer = nil
        end
    end
end


local function StartPlaying() -- кнопка Старт
    if not isPlaying then
        isPlaying = true
        startButton:Disable()
        stopButton:Enable()

        lines = {}
        for line in songText:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        currentSoundID = nil

        -- Вызов функции воспроизведения звука и сохранение идентификатора звука
        currentSoundID = PlaySoundFiles(soundFile)

        currentIndex = 1

        frame.timer = C_Timer.NewTicker(2.5, function() -- повтор действий каждые 2.5 сек, как на JS
            if isPlaying then
                if currentIndex <= #lines then
                    SendChatMessage(lines[currentIndex], "SAY")
                    currentIndex = currentIndex + 1
                end

                if currentIndex > #lines then
                    StopPlaying()
                end
            end
        end)

    end
end


-- кнопки старт стоп --
startButton:SetScript("OnClick", StartPlaying)
stopButton:SetScript("OnClick", StopPlaying)
-- !кнопки старт стоп --




local select_key = false -- Флаг, определяющий, выбраны ли классы
local frame2 = CreateFrame("Frame", "MyMultiSelectFrame", UIParent, "UIPanelDialogTemplate")
find_class = "" -- Пустая переменная для склеивания выбранных пунктов

frame2:SetSize(300, 200)
frame2:SetPoint("CENTER")
frame2:SetMovable(true)
frame2:EnableMouse(true)
frame2:RegisterForDrag("LeftButton")
frame2:SetScript("OnDragStart", frame2.StartMoving)
frame2:SetScript("OnDragStop", frame2.StopMovingOrSizing)

frame2.title = frame2:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
frame2.title:SetText("Выберите, кто вам нужен")
frame2.title:SetPoint("TOP", 0, -10)

frame2.checkboxes = {}
local numCheckboxes = 5


local myClass = {"Танк", "Лок", "Сова", "Маг", "Хант"}

for i = 1, numCheckboxes do
    local checkbox = CreateFrame("CheckButton", nil, frame2, "UICheckButtonTemplate")
    checkbox:SetSize(24, 24)
    checkbox:SetPoint("TOPLEFT", 20, -30 - (i - 1) * 30)
    checkbox.text = checkbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")

    checkbox.text:SetText(myClass[i])
    checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)

    frame2.checkboxes[i] = checkbox
end

frame2.okayButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
frame2.okayButton:SetSize(80, 22)
frame2.okayButton:SetPoint("BOTTOMRIGHT", 46, -67)
frame2.okayButton:SetText("Ок")
-- Создание текстуры фона
frame2.bgTexture = frame2:CreateTexture(nil, "BACKGROUND")
frame2.bgTexture:SetAllPoints(frame2)
frame2.bgTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")

-- Определение цвета фона
frame2.bgTexture:SetVertexColor(0.2, 0.2, 0.2, 0.8)
-- Обработка выбранных пунктов

frame2.cancelButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
frame2.cancelButton:SetSize(80, 22)
frame2.cancelButton:SetPoint("RIGHT", frame.okayButton, "LEFT", -10, 0)
frame2.cancelButton:SetText("Отмена")

frame2.cancelButton:SetScript("OnClick", function()
    frame2:Hide()
end)

frame2:SetScript("OnShow", function()
    -- Сброс состояния чекбоксов при открытии окошка
    for i = 1, numCheckboxes do
        frame2.checkboxes[i]:SetChecked(false)
    end
end)

-- Пример использования:
frame2:Hide()
frame2.okayButton:Hide()

local f_key = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate") -- создаем кнопку
local enabled_key = false -- Флаг, определяющий, включен ли поиск ключа

f_key:SetSize(200, 30) -- размеры
f_key:SetPoint("LEFT", 0, -520) -- позиция
f_key:SetText(enabled_key and "Остановить поиск ключа" or "Начать поиск ключа") -- текст кнопки


frame2.okayButton:SetScript("OnClick", function() -- тут уже открыто окно, выбираем галочки, нажали ок - выполняем код снизу
    frame2.okayButton:Hide() -- закрываем кнопку ок

    enabled_key = not enabled_key
    f_key:SetText(enabled_key and "Остановить поиск ключа" or "Начать поиск ключа") -- меняем текст

    for i = 1, numCheckboxes do -- получаем наши галочки
        local checkbox = frame2.checkboxes[i]
        local isChecked = checkbox:GetChecked()
        local text = checkbox.text:GetText()

        if isChecked then
            find_class = find_class .. " " .. text -- Добавление текста выбранного пункта к переменной
        end
    end

    if find_class == '' then
        frame2.timer:Cancel() -- останавливаем таймер
        frame2.timer = nil
    end

    if enabled_key == true then
        print("Поиск ключа начат")
    else
        print("Поиск ключа остановлен")
        find_class = '' -- очищаем переменную
    end

    if enabled_key == true and find_class ~= '' then
        local bagID = 0 -- Идентификатор сумки (0 для сумки персонажа)
        local slot = 3 -- Номер слота

        local itemLink = GetContainerItemLink(bagID, slot)

        if itemLink then
            local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemLink)

            SendChatMessage (itemLink .. " " .. find_class, "CHANNEL", nil, 1)
            frame2.timer = C_Timer.NewTicker(31, function() -- повтор действий каждые 31 сек, как на JS
                if enabled_key == true then
                    SendChatMessage (itemLink .. " " .. find_class, "CHANNEL", nil, 1)
                else
                    frame2.timer:Cancel()
                end
            end)

        else
            print("Поместить ключ в 3-й слот сумки")
        end

    else
        print("Выбери классы, который нужно найти")
    end


    frame2:Hide() -- закрываем окошко поиска
end)


f_key:SetScript("OnClick", function(self)
    if enabled_key == false then
        frame2:Show()
        frame2.okayButton:Show()
    else -- если поиск идет, то останавливаем
        enabled_key = false
        f_key:SetText("Начать поиск ключа") -- меняем текст

        find_class = ''
    end
end)




--   БОТ ОБРАБОТКИ СООБЩЕНИЙ В ОБЩИЙ ЧАТ  --

frame:RegisterEvent("CHAT_MSG_SAY") -- Регистрация события для сообщений в общем чате

local enabled = true -- Флаг, определяющий, включена ли обработка сообщений

local function OnChatMessage(event, arg1, arg2, arg3) -- функция при получения данный от события (евента)
    if not enabled then
        return -- Если обработка отключена, выходим из функции
    end

    local message = arg2 -- текст сообщения
    local name = arg3:match("([^%-]+)") -- имя отправится без -uwowx100 и тп

    local text = string.lower(message)

    C_Timer.After(1, function()
        if name ~= UnitName("player") then

            if text == 'привет' or text == 'здравствуй' or text == 'ку' then
                SendChatMessage("Привет, " .. name)
            elseif text == 'как дела?' or text == 'как ты?' then
                SendChatMessage("У меня все отлично, спасибо!")
            elseif text == 'что нового?' or text == 'чем занимаешься?' then
                SendChatMessage("Я здесь, чтобы помочь тебе. Чем я могу быть полезен?")
            end

            if text == 'иди за мной' or text == 'за мной' then
                SendChatMessage("Иду, " .. name)
                FollowUnit (name)
            end

            if text == 'зачем' or text == 'зачем?' then
                SendChatMessage("За шкафом под тумбочкой")
            end

            if text == 'а' or text == 'а?' then
                SendChatMessage("Б")
            end

            if text == 'ок' or text == 'ok' then
                SendChatMessage("Хуёк")
            end

            if text == 'ага' then
                SendChatMessage("Нага")
            end

            if text == ')' or text == ')))' then
                SendChatMessage("Хули лыбишься")
            end

            if text == 'ммм' or text == 'м?' then
                SendChatMessage("Че мычишь, корова")
            end

            if text == 'я' then
                SendChatMessage("Головка от хуя")
            end

            if text == 'сколько у тебя голды?' then
                local copper = GetMoney()
                SendChatMessage("У меня на персонаже '" .. UnitName("player") .. ("' %d голд %d серебра %d меди"):format(copper / 100 / 100, (copper / 100) % 100, copper % 100) )
            end

            if text == 'нет' then
                SendChatMessage("Пидора ответ")
            end

            if string.sub(text, 1, string.len("кто")) == "кто" then
                local info = string.sub(text, string.len("кто") + 1)
                info = string.gsub(info, "?", "") -- Удаляем знак вопроса, если есть

                local playerList = {}
                local playerName = UnitName("player")
                local groupSize = 0

                -- Проверяем наличие группы или рейда
                if IsInGroup() then
                    groupSize = GetNumGroupMembers()
                elseif IsInRaid() then
                    groupSize = GetNumGroupMembers(true)
                end

                if groupSize > 0 then
                    -- Проверяем каждого игрока в группе или рейде
                    for i = 1, groupSize do
                        local unit = (IsInRaid() and "raid" or "party") .. i

                        -- Проверяем, находится ли игрок в радиусе 100 метров
                        if UnitInRange(unit, 100) then
                            local name = UnitName(unit)

                            -- Исключаем себя из списка игроков
                            if name ~= playerName then
                                table.insert(playerList, name)
                            end
                        end
                    end

                    -- Выбираем случайного игрока из списка
                    local numPlayers = #playerList
                    if numPlayers > 0 then
                        local randomIndex = math.random(1, numPlayers)
                        local randomPlayer = playerList[randomIndex]

                        SendChatMessage("Я думаю, что " .. info .. " это - " .. randomPlayer:match("([^%-]+)"))
                    else
                        SendChatMessage("В радиусе 100 метров нет других игроков.")
                    end
                end
            end


            -- Список рандомных городов
            local cities = {"Оргриммаре", "Штормграде", "Подгороде", "Дарнасе", "Громовом Утесе", "Серебряном бору", "Луносвете", "Экзодаре", "Караганде", "Пизде"}

            -- Функция для получения случайного города
            local function GetRandomCity()
                local index = math.random(1, #cities)
                return cities[index]
            end


            if string.sub(text, 1, string.len("где")) == "где" then
                local cityName = GetRandomCity()

                SendChatMessage("В " .. cityName)
            end

            local function GetMonthName(monthNumber)
                local monthNumber = tonumber(monthNumber)

                local monthNames = {
                    "января", "февраля", "марта", "апреля", "мая", "июня",
                    "июля", "августа", "сентября", "октября", "ноября", "декабря"
                }
                local monthName = monthNames[monthNumber]
                return monthName or "Unknown"
            end


            local function GetRandomDateTime()
                local currentTime = time()
                local randomTime = math.random(currentTime)
                local randomDateTime = date("!%d ") .. GetMonthName(date("!%m")) .. date(" %Y года в %H:%M", randomTime)
                return randomDateTime
            end

            -- Пример использования
            if string.sub(text, 1, string.len("когда")) == "когда" then
                local randomDateTime = GetRandomDateTime()
                SendChatMessage (randomDateTime)
            end


            if text == 'да' then
                SendChatMessage("Пизда")
            end

            if text == 'неа' then
                SendChatMessage("Ну и хуй с тобой")
            end

            if text == 'хочу' then
                SendChatMessage("Хотеть не вредно, вредно не хотеть")
            end

            -- Функция для получения случайной вероятности быть богатым (от 0 до 100%)
            local function GetRandomRichProbability()
                return math.random(0, 100)
            end

            -- Пример использования
            if string.sub(text, 1, string.len("инфа")) == "инфа" then
                local info = string.sub(text, string.len("инфа") + 1)
                local result = string.gsub(info, "я", "ты")
                result = string.gsub(result, "?", "") -- Удаляем знак вопроса, если есть
                local probability = GetRandomRichProbability()

                SendChatMessage("Вероятность того, что " .. result .. ", равна примерно " .. probability .. "%.")
            end

            if string.sub(text, 1, string.len(".напиши")) == ".напиши" then
                local result = string.sub(message, string.len(".напиши") + 1)
                SendChatMessage(result)
            end

            if string.sub(text, 1, string.len(".эмоция")) == ".эмоция" then
                local result = string.sub(text, string.len(".эмоция") + 1)
                result = string.gsub(result, "^%s*(.-)%s*$", "%1") -- Удаление лишних пробелов
                DoEmote(result)
            end


            local startPos, endPos = string.find(text, "дай голд")

            if startPos then
                local foundText = string.sub(text, startPos, endPos)
                SendChatMessage("А по ебалу тебе не дать, " .. name .. "?")
            end

            local startPos2, endPos2 = string.find(text, "иди нах")

            if startPos2 then
                local foundText = string.sub(text, startPos2, endPos2)
                SendChatMessage("Сам иди нахуй, пидорас на " .. name)
            end

            local startPos3, endPos3 = string.find(text, "аха")

            if startPos3 then
                local foundText = string.sub(text, startPos3, endPos3)
                SendChatMessage("Хули ржешь, кобыла " .. name)
            end

        end
    end)
end


frame:SetScript("OnEvent", OnChatMessage) -- подписываемся на евент

local toggleButton = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate") -- создаем кнопку

toggleButton:SetSize(100, 25) -- размеры
toggleButton:SetPoint("CENTER", 0, -350) -- позиция
toggleButton:SetText(enabled and "Выключить" or "Включить") -- текст кнопки

toggleButton:SetScript("OnClick", function(self) -- функция отключения события
    enabled = not enabled
    self:SetText(enabled and "Выключить" or "Включить")

    if enabled then
        print("Обработка сообщений включена")
    else
        print("Обработка сообщений выключена")
    end
end)

print("Бот запущен!")

--   !БОТ ОБРАБОТКИ СООБЩЕНИЙ В ОБЩИЙ ЧАТ  --
