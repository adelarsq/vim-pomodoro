" plugin/pomodoro.vim
" Author:   Maximilian Nickel <max@inmachina.com>
" License:  MIT License
" Maintainer: Adelar da Silva Queiróz
"
" Vim plugin for the Pomodoro time management technique.
"
" Commands:
" 	:PomodoroStart [name] 	- 	Start a new pomodoro. [name] is optional.
"
" Configuration:
" 	g:pomodoro_time_work 	-	Duration of a pomodoro
" 	g:pomodoro_time_slack 	- 	Duration of a break
" 	g:pomodoro_log_file 	- 	Path to log file

if &cp || exists("g:pomodoro_loaded") && g:pomodoro_loaded
  finish
endif

let g:pomodoro_loaded = 1
let g:pomodoro_started = 0
let g:pomodoro_started_at = -1

if !exists('g:pomodoro_time_work')
  let g:pomodoro_time_work = 25
endif
if !exists('g:pomodoro_time_slack')
  let g:pomodoro_time_slack = 5
endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* PomodoroStart call s:PomodoroStart(<q-args>)
command! PomodoroStatus echo PomodoroStatus()

if !exists("g:no_plugin_maps") || g:no_plugin_maps == 0
    nmap <F7> <ESC>:PomodoroStart<CR>
endif

function! PomodoroStatus()
    if g:pomodoro_started == 0
        silent! if exists('g:vim_pomodoro_icon')
            " inative just show symbol
            return g:vim_pomodoro_icon
        else
            return "Pomodoro inactive"
        endif
	elseif g:pomodoro_started == 1
        silent! if exists('g:vim_pomodoro_icon')
		    return g:vim_pomodoro_icon . " started (remaining: " . pomodorocommands#remaining_time() . " minutes)"
        else
            return "Pomodoro started (remaining: " . pomodorocommands#remaining_time() . " minutes)"
        endif
	elseif g:pomodoro_started == 2
        silent! if exists('g:vim_pomodoro_icon_break')
            return g:vim_pomodoro_icon_break . " break started"
        else
		    return "Pomodoro break started"
        endif
    endif
endfunction

function! s:PomodoroStart(name)
	if g:pomodoro_started != 1
		if a:name == ''
			let name = '(unnamed)'
		else
			let name = a:name
		endif
    let tempTimer = timer_start(g:pomodoro_time_work * 60 * 1000, function('pomodorohandlers#pause', [name]))
		let g:pomodoro_started_at = localtime()
		let g:pomodoro_started = 1
    echom "Pomodoro Started at: " . strftime('%I:%M:%S %d/%m/%Y')
	endif
endfunction
