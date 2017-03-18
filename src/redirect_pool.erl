-module(redirect_pool).

%% API exports
-export([start/0, loop/2, mod/2]).

%%====================================================================
%% API functions
%%====================================================================


start() ->
    loop([], 0).

loop(Pool, Idx) ->
  receive
    {add_to_redirect_pool, Pid} -> loop([Pid | Pool], Idx + 1) ;
    X when length(Pool) > 0 ->
      Size = length(Pool),
      ModIdx = mod(Idx, Size),
      Mod1Idx = ModIdx + 1,
      Plucked = lists:nth(Mod1Idx, Pool),
      Plucked ! X,
      loop(Pool, Idx + 1) ;
    _ -> loop(Pool, Idx)
  end.

mod(A, B) when A > 0 -> A rem B;
mod(A, B) when A < 0 -> mod(A+B, B);
mod(0, _) -> 0.

%%====================================================================
%% Internal functions
%%====================================================================
