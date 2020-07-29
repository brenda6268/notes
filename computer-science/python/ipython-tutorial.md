# IPython main features

<!--
ID: 2b059a18-4886-486e-b3f9-1874bbd8f0d4
Status: publish
Date: 2017-08-13T03:31:00
Modified: 2020-05-16T11:48:41
wp_id: 686
-->

* use `?` to get quick help, and use `??` provides additional detail).

* Searching through modules and namespaces with * wildcards, both when using the ? system and via the %psearch command.

* magic commands, % or %% prefixed commands

* Alias facility for defining your own system aliases.

* Lines starting with ! are passed directly to the system shell, and using !! or var = !cmd captures shell output into python variables for further use.

* python variable prefixed with $ is expanded. A double $$ allows passing a literal $ to the shell (for access to shell and environment variables like PATH).

* Filesystem navigation, via a magic %cd command, along with a persistent bookmark system (using %bookmark) for fast access to frequently visited directories.

* A lightweight persistence framework via the %store command, which allows you to save arbitrary Python variables. These get restored when you run the %store -r command.

* Automatic indentation and highlighting of code as you type (through the prompt_toolkit library).

* %macro command. Macros can be stored persistently via %store and edited via %edit.
* Session logging (you can then later use these logs as code in your programs). Logs can optionally timestamp all input, and also store session output (marked as comments, so the log remains valid Python source code).
Session restoring: logs can be replayed to restore a previous session to the state where you left it.

* Auto-parentheses via the %autocall command: callable objects can be executed without parentheses: sin 3 is automatically converted to sin(3)
* Auto-quoting: using `,`, or `;` as the first character forces auto-quoting of the rest of the line: `,my_function a b` becomes automatically `my_function("a","b")`, while ;my_function a b becomes my_function("a b").

* Extensible input syntax. You can define filters that pre-process user input to simplify input in special situations. This allows for example pasting multi-line code fragments which start with >>> or ... such as those from other python sessions or the standard Python documentation.

Flexible configuration system. It uses a configuration file which allows permanent setting of all command-line options, module loading, code and file execution. The system allows recursive file inclusion, so you can have a base file with defaults and layers which load other customizations for particular projects.

* Embeddable. You can call IPython as a python shell inside your own python programs. This can be used both for debugging code or for providing interactive abilities to your programs with knowledge about the local namespaces (very useful in debugging and data analysis situations).

* Easy debugger access. You can set IPython to call up an enhanced version of the Python debugger (pdb) every time there is an uncaught exception. This drops you inside the code which triggered the exception with all the data live and it is possible to navigate the stack to rapidly isolate the source of a bug. The %run magic command (with the -d option) can run any script under pdb’s control, automatically setting initial breakpoints for you. This version of pdb has IPython-specific improvements, including tab-completion and traceback coloring support. For even easier debugger access, try %debug after seeing an exception.

* Profiler support. You can run single statements (similar to profile.run()) or complete programs under the profiler’s control. While this is possible with standard cProfile or profile modules, IPython wraps this functionality with magic commands (see %prun and %run -p) convenient for rapid interactive work.

* Simple timing information. You can use the %timeit command to get the execution time of a Python statement or expression. This machinery is intelligent enough to do more repetitions for commands that finish very quickly in order to get a better estimate of their running time.
```
In [1]: %timeit 1+1
10000000 loops, best of 3: 25.5 ns per loop

In [2]: %timeit [math.sin(x) for x in range(5000)]
1000 loops, best of 3: 719 µs per loop
```
To get the timing information for more than one expression, use the %%timeit cell magic command.

* Doctest support. The special %doctest_mode command toggles a mode to use doctest-compatible prompts, so you can use IPython sessions as doctest code. By default, IPython also allows you to paste existing doctests, and strips out the leading >>> and ... prompts in them.