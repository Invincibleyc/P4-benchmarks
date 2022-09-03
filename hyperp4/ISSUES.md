# Known Issues

## Unsupported: Headers With Multiple Potential Offsets

HyPer4 assumes that every potential parsed representation header
has just one possible offset, which is not true of P4 programs
in general.

In hp4.p4, the parse control state (parse_ctrl.state) is not
a match parameter in the virtual ingress pipeline.

Adding it would require additional development in p4_hp4 and
hp4controller / ConViDa that is not critical to completing
support for VIBRANT.  We would need to make the compiler and
interpreter support the additional rules required for each
terminal parse control state in which affected headers end
up at different offsets.  When it is time to implement this,
we can be smart by making the match parameter in hp4.p4
ternary, and leaving it turned off for those matches where
the parse control state does not matter (because the headers
being matched are always at the same offset despite other
headers having multiple potential offsets).

For now, we can implement a check in p4_hp4 that detects
headers with multiple potential offsets, and terminate
with an error.
