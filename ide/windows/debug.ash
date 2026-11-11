
; flat assembler g IDE for Windows - definitions for the integrated debugger

; states of the debugging session

DBGS_NONE     = 0	; no program is being debugged
DBGS_RUNNING  = 1	; the debugged program is executing
DBGS_PAUSED   = 2	; the debugged program is stopped and can be inspected

; commands for the debugger thread (accepted when the program is paused)

DBGC_GO       = 1	; resume execution
DBGC_INTO     = 2	; execute a single line, entering the called procedures
DBGC_OVER     = 3	; execute a single line, treating calls as single instructions
DBGC_OUT      = 4	; execute until the current procedure returns
DBGC_RUNTO    = 5	; resume execution with temporary breakpoints set
DBGC_STOP     = 6	; terminate the debugged program
DBGC_SYNC     = 7	; update the breakpoints
DBGC_INSN     = 8	; execute a single instruction (used internally)

; requests for the debugger thread (accepted when the program is running)

DBGR_BREAK    = 1	; pause the program
DBGR_STOP     = 2	; terminate the program
DBGR_SYNC     = 4	; update the breakpoints

; notifications sent by the debugger thread with FM_DEBUG message

DBGN_RUNNING  = 1	; program has started or resumed execution
DBGN_PAUSED   = 2	; program has been stopped, lparam = DBGP_# reason
DBGN_EXITED   = 3	; program has ended, lparam = exit code
DBGN_FAILED   = 4	; program could not be started, lparam = error code
DBGN_OUTPUT   = 5	; lparam = text for the output log (allocated from process heap)

; reasons for the pause

DBGP_BREAKPOINT = 1	; breakpoint set by user has been reached
DBGP_STEP	= 2	; requested step has been completed
DBGP_BREAK	= 3	; execution has been interrupted on request
DBGP_EXCEPTION	= 4	; exception has occured in the program
DBGP_INT3	= 5	; breakpoint instruction embedded in the program

; kinds of breakpoints kept by the debugger thread

DBP_USER      = 1	; set by user
DBP_TEMPORARY = 2	; discarded the next time the program stops
DBP_STEP      = 4	; marks the place where the interrupted tracing should continue

; classes of instructions that are relevant to tracing

DBGI_OTHER    = 0
DBGI_CALL     = 1
DBGI_JUMP     = 2
DBGI_RETURN   = 3
DBGI_REPEAT   = 4

; marks for the lines of text displayed by the editor

DBGM_BREAKPOINT = FELM_MARK1
DBGM_FRAME	= FELM_MARK2
DBGM_EXECUTION	= FELM_MARK3

; pages of the debugger panel

DBGV_MEMORY   = 0
DBGV_STACK    = 1
DBGV_OUTPUT   = 2

; limits

MAX_BREAKPOINTS   = 256
MAX_DEBUG_POINTS  = 1024
MAX_DEBUG_WANTED  = 512
MAX_DEBUG_RUN_TO  = 64
MAX_DEBUG_THREADS = 256
MAX_DEBUG_PASSES  = 16
MAX_DEBUG_SOURCES = 2048
MAX_DEBUG_SECTIONS = 96

DEBUG_POLL_INTERVAL = 50
DEBUG_TOKEN_LENGTH = 100h
DEBUG_NAME_LENGTH = 400h
DEBUG_MEMORY_ROWS = 32
DEBUG_STACK_ROWS = 64

; system definitions that are not provided by the standard headers

EXCEPTION_DEBUG_EVENT	   = 1
CREATE_THREAD_DEBUG_EVENT  = 2
CREATE_PROCESS_DEBUG_EVENT = 3
EXIT_THREAD_DEBUG_EVENT    = 4
EXIT_PROCESS_DEBUG_EVENT   = 5
LOAD_DLL_DEBUG_EVENT	   = 6
UNLOAD_DLL_DEBUG_EVENT	   = 7
OUTPUT_DEBUG_STRING_EVENT  = 8
RIP_EVENT		   = 9

DBG_CONTINUE		  = 00010002h
DBG_EXCEPTION_NOT_HANDLED = 80010001h

CONTEXT_i386		   = 10000h
CONTEXT_CONTROL 	   = CONTEXT_i386 or 1
CONTEXT_INTEGER 	   = CONTEXT_i386 or 2
CONTEXT_SEGMENTS	   = CONTEXT_i386 or 4
CONTEXT_FULL		   = CONTEXT_CONTROL or CONTEXT_INTEGER or CONTEXT_SEGMENTS

EFLAGS_TF = 100h

struct DEBUG_EXCEPTION
  ExceptionCode        dd ?
  ExceptionFlags       dd ?
  ExceptionRecord      dd ?
  ExceptionAddress     dd ?
  NumberParameters     dd ?
  ExceptionInformation rd 15
  dwFirstChance        dd ?
ends

struct DEBUG_NEW_THREAD
  hThread	    dd ?
  lpThreadLocalBase dd ?
  lpStartAddress    dd ?
ends

struct DEBUG_NEW_PROCESS
  hFile 	    dd ?
  hProcess	    dd ?
  hThread	    dd ?
  lpBaseOfImage     dd ?
  dwDebugInfoOffset dd ?
  nDebugInfoSize    dd ?
  lpThreadLocalBase dd ?
  lpStartAddress    dd ?
  lpImageName	    dd ?
  fUnicode	    dw ?
ends

struct DEBUG_LIBRARY
  hFile 	    dd ?
  lpBaseOfDll	    dd ?
  dwDebugInfoOffset dd ?
  nDebugInfoSize    dd ?
  lpImageName	    dd ?
  fUnicode	    dw ?
ends

struct DEBUG_STRING
  lpDebugStringData  dd ?
  fUnicode	     dw ?
  nDebugStringLength dw ?
ends

struct DEBUG_EVENT
  dwDebugEventCode dd ?
  dwProcessId	   dd ?
  dwThreadId	   dd ?
  union
    Exception	   DEBUG_EXCEPTION
    NewThread	   DEBUG_NEW_THREAD
    NewProcess	   DEBUG_NEW_PROCESS
    Module	   DEBUG_LIBRARY
    DebugString    DEBUG_STRING
    dwExitCode	   dd ?
  ends
ends

struct CONTEXT
  ContextFlags dd ?
  iDr0	       dd ?
  iDr1	       dd ?
  iDr2	       dd ?
  iDr3	       dd ?
  iDr6	       dd ?
  iDr7	       dd ?
  FloatSave    rb 112
  regGs        dd ?
  regFs        dd ?
  regEs        dd ?
  regDs        dd ?
  regEdi       dd ?
  regEsi       dd ?
  regEbx       dd ?
  regEdx       dd ?
  regEcx       dd ?
  regEax       dd ?
  regEbp       dd ?
  regEip       dd ?
  regCs        dd ?
  regFlag      dd ?
  regEsp       dd ?
  regSs        dd ?
  ExtendedRegisters rb 512
ends

; record associating a portion of the generated output with a line of source text

struct DebugLine
  position dd ? 	; offset within the output file
  number   dd ? 	; number of line
  path	   dd ? 	; path to the file containing the line
ends

; record describing a source file that contributed to the output

struct DebugSource
  name dd ?		; name used by the assembler (valid only during the assembly)
  path dd ?		; full path to the file (allocated from process heap)
ends

; breakpoint set up by user in one of the edited files

struct Breakpoint
  hwnd dd ?		; window of the editor
  line dd ?		; number of line
ends

; breakpoint placed in the memory of the debugged program

struct DebugPoint
  address  dd ?
  flags    db ? 	; DBP_#, zero when the record is not used
  original db ? 	; the byte replaced with the breakpoint instruction
  lifted   db ? 	; number of threads for which the original byte is temporarily restored
  reserved db ?
  thread   dd ? 	; for DBP_STEP: identifier of the traced thread
  limit    dd ? 	; for DBP_STEP: minimum value of stack pointer
ends

; record of a thread that is passing over a lifted breakpoint

struct DebugPass
  thread dd ?		; identifier of thread, zero when the record is not used
  point  dd ?		; pointer to DebugPoint
ends
