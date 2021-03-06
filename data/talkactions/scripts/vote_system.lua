	-- Made by Leon Zawodowiec --
function vote_clean() -- Czysci wyniki ostatniego g這sowania
    setGlobalStorageValue(9855, 0) -- Odpowiada, aby tylko 1 g這sowanie by這 naraz
    setGlobalStorageValue(2299, 0) -- Odpowiada za g這sy na TAK
    setGlobalStorageValue(2288, 0) -- Odpowiada za g這sy na NIE
return true
end

function vote_end() -- Og豉sza wyniki g這sowania
    doBroadcastMessage("Wyniki Glosowania:")
	doBroadcastMessage("".. getGlobalStorageValue(2299) .. " na TAK !")
	doBroadcastMessage("".. getGlobalStorageValue(2288) .. " na NIE !")
	addEvent(vote_clean, 2000) -- Czy�ci wszystkie wpisy (Aktualne wyniki, g這sowanie)
return true
end

function vote_cancel() -- Anuluje aktualne g這sowanie
	doBroadcastMessage("Glosowanie zostalo anulowane !")
	vote_clean() -- Czy�ci wszystkie wpisy (Aktualne wyniki, g這sowanie)
return true
end

function onSay(cid, words, param) -- G這wna struktura skryptu
	local vote_end_time = 60 -- Czas g這sowania w sekundach

    if getGlobalStorageValue(9855) ~= 1 and getGlobalStorageValue(7200) <= os.time() and words == '/vote' then -- Rozpoczyna g這sowanie
		if words == '/vote' then
            addEvent(vote_end, vote_end_time * 1000) -- Ustawia licznik po kt鏎ym zako鎍zy g這sowanie i wy�wietli wyniki
			doBroadcastMessage("UWAGA - GLOSOWANIE !")
			doBroadcastMessage("Pytanie: " .. param .. "")
			doBroadcastMessage("Aby zaglosowac wpisz na czacie:  !tak  lub  !nie")
			vote_clean() -- Zeruje liczniki na pocz靖ku
            setGlobalStorageValue(9855, 1) -- Ustawia Global Storage Value aby nie by這 mo積a zacz寞 kilku g這sowa� naraz.
			setGlobalStorageValue(7200, os.time() + vote_end_time) -- Ustawia Licznik aby nie by這 mo積a zacz寞 nast瘼nego g這sowania w kr鏒szym odst瘼ie od "vote_end_time", aby przy anulowaniu g這sowania i rozpocz璚iu kolejnego wszyscy mogli znowu g這sowa�
        end
	else
		if getPlayerAccess(cid) >= 5 and words == '/vote' then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Do nastepnego glosowania musisz odczekac jeszcze " .. getGlobalStorageValue(7200) - os.time() .. " sekund !")
		end
    end
	
    if getGlobalStorageValue(9855) == 1 then -- Je瞠li g這sowanie rozpocz窸o si�
		if words == '!tak' and getPlayerStorageValue(cid, 7200) <= os.time() then -- Je瞠li gracz g這suje na TAK
			setGlobalStorageValue(2299, getGlobalStorageValue(2299) + 1) -- Dodaje 1 g這s na TAK
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Zaglosowales na TAK !")
			setPlayerStorageValue(cid, 7200, os.time() + vote_end_time) -- Ustawia czas w jakim gracz nie mo瞠 g這sowa�
		elseif words == '!nie' and getPlayerStorageValue(cid, 7200) <= os.time() then
			setGlobalStorageValue(2288, getGlobalStorageValue(2288) + 1) -- Dodaje 1 g這s na TAK
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Zaglosowales na NIE !")
			setPlayerStorageValue(cid, 7200, os.time() + vote_end_time) -- Ustawia czas w jakim gracz nie mo瞠 g這sowa�
		elseif getPlayerStorageValue(cid, 7200) >= os.time() then -- Je瞠li gracz pr鏏uje zag這sowa� w niedozwolonych czasie
			doPlayerSendCancel(cid, "Juz glosowales !")
		end
	else -- Je瞠li 瘸dne g這sowanie nie zosta這 rozpocz皻e
		doPlayerSendCancel(cid, "Zadne glosowanie nie zostalo rozpoczete !")
	end
return true
end