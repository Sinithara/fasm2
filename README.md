# fasm2

## Debugger in the Windows IDE

The IDE (`ide/windows/fasmgw.asm`) can run the assembled program under its own debugger.
It works at the level of source lines: the assembler records which lines of which files
generated which bytes of the output, so no additional directives are needed in the source.

| Command | Key | Notes |
| --- | --- | --- |
| Debug or continue | F8 | Assembles and starts the program, or resumes it when it is stopped. |
| Step into | F11 | Executes one line, entering called procedures that have source. |
| Step over | F10 | Executes one line, treating calls as a single step. |
| Step out | Shift+F11 | Runs until the current procedure returns. |
| Run to cursor | Ctrl+F10 | Runs until the line with the caret is reached. |
| Break | Shift+F8 | Interrupts the running program. |
| Stop debugging | Ctrl+F2 | Terminates the program. |
| Toggle breakpoint | Ctrl+F8 | Sets or removes a breakpoint at the line with the caret. |

When no program is being debugged, the stepping commands start it and stop at its entry point.
A breakpoint on a line that generates no code takes effect at the first following line that does.
When the program stops in code that has no source (for example inside a system library),
the line containing the call that led there is marked instead, and stepping brings the program back to it.

The panel at the bottom shows the registers, the memory at a given address, the stack and
the output (texts sent with `OutputDebugString`, exceptions, the exit code). The address is an
expression made of hexadecimal numbers, registers, labels of the program, `+`, `-`, `*`,
parentheses and `[...]` to read a value from memory (optionally with `byte`, `word` or `dword`),
for example `buffer`, `esp+8` or `[ebx]+10h`.

Only 32-bit Windows executables can be debugged, because the IDE itself is a 32-bit program.
