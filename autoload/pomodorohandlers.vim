" autoload/pomodorohandlers.vim
" Author:   Maximilian Nickel <max@inmachina.com>
" License:  MIT License
" Maintainer: Adelar da Silva Queiróz

if exists("g:loaded_autoload_pomodorohandlers") || &cp
    " requires nocompatible
    " also, don't double load
    finish
endif
let g:loaded_autoload_pomodorohandlers = 1

function! pomodorohandlers#pause(name,timer)
    let g:pomodoro_started = 2
		call pomodorocommands#notify()
 		let choice = confirm("Great, pomodoro " . a:name . " is finished!\nNow, take a break for " . g:pomodoro_time_slack . " minutes", "&OK")
		if exists("g:pomodoro_log_file")
			exe "!echo 'Pomodoro " . a:name . " ended at " . strftime("%c") . ", duration: " . g:pomodoro_time_work . " minutes' >> " . g:pomodoro_log_file
		endif
    let tempTimer = timer_start(g:pomodoro_time_slack * 60 * 1000, 'pomodorohandlers#restart')
endfunction

function! pomodorohandlers#restart(timer)
    let g:pomodoro_started = 0
		call pomodorocommands#notify()
 		let choice = confirm(g:pomodoro_time_slack . " minutes break is over... Feeling rested?\nWant to start another pomodoro?", "&Yes\n&No")
		if choice == 1
		  exec "PomodoroStart"
		endif
endfunction
