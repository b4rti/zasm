# Compilation Hints Proposal

## Summary

This proposal allows WebAssembly modules to provide optional hints that help the compiler take the best decisions for the intended use case. These are mere performance improvements and there is no change in functionality or behavior.


## Motivation

Ensuring scalability for WebAssembly applications often requires engines to take decisions without having all the information available, e.g. when to compile a function in which tier. These are usually driven by heuristics and feedback collected at runtime. Heuristics are only a broad approximation of the real-world behavior and runtime feedback requires time and potentially expensive instrumentation to gather. It can therefore beneficial to provide additional information of the expected usage pattern to the compiler beforehand.

This information can be extracted from source code, AOT analysis or profiling. AOT optimizers can potentially also use this information to take advanced decisions where runtime feedback would normally not be available. They can then decide to act on that information or forward it to the runtime engine.

One interesting aspect to other environments where profiling feedback is to be incorporated is that this usually requires recompiling the code from source and therefore access to the source code while WebAssembly allows to add information after module creation and then re-optimize modules or rely on the engine to incorporate the feedback. This can be useful for libraries that are used in different scenarios where different compilation patterns are preferred.


## Overview

Based on the [branch hinting proposal](https://github.com/WebAssembly/branch-hinting), we extend this mechanism by adding additional custom sections for extra functionality. This can be integrated with the [annotations proposal](https://github.com/WebAssembly/annotations) for the ability to generate these from text format and for round-trips to the text format to preserve them.

Each family of hints is bundled in a respective custom section following the example of branch hints. These sections all have the naming convention `metadata.code.*` and follow the structure
  * *function index* |U32|
  * a vector of hints with entries
    * *byte offset* |U32| of the hinted instruction from the beginning of the function body (0 for function level hints),
    * *hint length* |U32| indicating the number of bytes each hint requires,
    * *values* |U32| with the actual hint information

If not specified otherwise, all numeric values are encoded using the [LEB128](https://en.wikipedia.org/wiki/LEB128) variable-length integer encoding either in its signed or unsigned variant.

*Note: If custom annotations support a `metadata.function.*` namespace, the byte offset could be dropped for function-level annotations.*

The following contains a list of hints to be included in the first version of the proposal. Future extensions can be added as necessity arises. This also includes annotations outside of function or instruction level like annotations for memories, etc.


### Compilation order

The section `metadata.code.compilation_order` contains the order in which functions should be compiled in order to minimize wait times until the compilation is completed. This is especially relevant during instantiation and startup but might also be relevant later.
  * *byte offset* |U32| with value 0 (function level only)
  * *hint length* |U32| in bytes
  * *compilation order* |U32| starting at 0 (functions with the same order value will be compiled in an arbitrary order but before functions with a higher order value)
  * *hotness* |U32| defining how often this function is called

If a length of larger than required to store 2 values is present, only the first two values of the following hint data is evalued while the rest is ignored. This leaves space for future extensions, e.g. grouping functions. Similarly, the *hotness* can be dropped if a length corresponds to only 1 value is given.

The *hotness* attribute has no pre-defined meaning. The larger the value, to more often a function is expected to run. So an engine can simply order the functions by hotness and tier up the ones with the largest *hotness* until the compilation budget is exceeded. The compilation budget might depend on the engine, compiler, available resources, how long the program has been running, etc. The special value of 0 is reserved for functions that only run once (e.g. initialization functions). An engine can decide to interpret those functions only or to free up code space by removing the compiled code after execution. Applications can run sich a function multiple times, but they should not because this might come with severe performance penalties, e.g. for repeated recompilation, not ever getting tiered up, etc.

It is expected and even desired that not all functions are annotated to keep this section small. It is up to th engine if and when the unannotated functions are compiled. It's recommended that these functions get compiled last or lazily on demand.

*Note: This should be moved to `metadata.function.compilation_order` without the byte offset if such a namespace will be supported by custom annotations.*


### Inlining

An engine might decide to inline certain call targets based on its own feedback collection or other hints (e.g. *call targets* section), but explicit hints can be added per call target and per function using the following annotations.

The `metadata.code.inline` section contains instruction level annotations for all affected call sites.
  * *byte offset* |U32| from the beginning of the function to the wire byte index of the call instruction (this must be a `call`, `call_ref` or a `call_indirect`, otherwise the hint will be ignored)
  * *hint length* |U32| in bytes (always 1 for now, might be higher for future extensions)
  * *log call frequency* |U8| determining the estimated number of times the callee gets called per call of the caller.

The call frequency can be thought of the estimated number of times a callee gets called during one call of the caller. It is a logarithmic value based on the formula $f = \max(1, \min(126, 10 \log_{10} \frac{n}{N} + 32))$ where $n$ is the number of callee calls from this call site and $N$ is the number of caller calls.

The actual decision which function should be inlined can be based on runtime data that the engine collected, additional heuristics and available resources. There is no guarantee that a function is or is not inlined, but it should roughly be expected that functions of higher call frequency are prefered over ones with lower frequency.
Special values of 0 and +127 indicate that a function should never or always be inlined respectively. Engines should respect such annotations over their own heuristics and toolchains should therefore avoid generating such annotations unless there is a good reason for it (e.g. "no inline" annotations in the source).

|log call frequency|calls per parent call|
|-----------------:|:-------------------:|
|                 0|       *never inline*|
|                 1|              <0.0008|
|                22|               0.1   |
|                32|               1     |
|                42|              10     |
|                52|             100     |
|                62|           1,000     |
|               126|  >2,511,886,432     |
|               127|      *always inline*|

If the *byte offset* is 0, the hint applies to all call sites where the function is the **target**. It serves as a shorthand notation unless explicitly overridden. In this case, the call frequency should be a rough estimate of the average call frequency of all potential sites. *Note: This should likely be moved to a dedicated section for clearer separation, e.g. `metadata.function.inline` if such a namespace will be supported by custom annotations.*


### Call targets

When dealing with `call_indirect` or `call_ref`, often inefficient code is generated, because the call target is unknown. With code that e.g. uses virtual function calls, there are often very few commonly called targets which a compiler could optimize for. It still needs to have the ability to handle other call targets, but that can then happen at a much lower performance in favor of optimizing for the more commonly called target.

This is especially interesting if functions need to be compiled to the top tier early on, either because they're annotated with a low compilation order, because eager compilation or even AOT compilation is desired.

The `metadata.code.call_targets` section contains instruction level annotations for all relevant call targets identified by their function indexes.
  * *byte offset* |U32| from the beginning of the function to the wire byte index of the call instruction (this must be a `call_ref` or a `call_indirect`, otherwise the hint will be ignored)
  * *hint length* |U32| in bytes
  * call target information
    * *function index* |U32|
    * *call frequency* |U32| in percent

The accumulated call frequency must add up to 100 or less. If it is less than 100, then other call targets that are not listed are responsible for the missing calls. Together with the inline hints on call frequency, this can information can be used to inline function calls as well. The effective call frequency for each call target is then the inlining call frequency multiplied by the fractional call frequency encoded in this section.

Similarly to the compilation order section, not all call sites need to be annotated and not all call targets be listed. However, if other call targets are known but not emitted, then the frequency must be below 100 to inform the engine of the missing information.
