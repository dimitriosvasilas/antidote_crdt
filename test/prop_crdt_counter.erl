%% -------------------------------------------------------------------
%%
%% Copyright (c) 2014 SyncFree Consortium.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(prop_crdt_counter).

-define(PROPER_NO_TRANS, true).
-include_lib("proper/include/proper.hrl").

%% API
-export([prop_counter_spec/0, counter_op/0, counter_spec/1]).


prop_counter_spec() ->
 crdt_properties:crdt_satisfies_spec(antidote_crdt_counter, fun counter_op/0, fun counter_spec/1).


counter_spec(Operations) ->
  lists:sum([X || {_, {increment, X}} <- Operations])
    + lists:sum([1 || {_, increment} <- Operations])
    - lists:sum([X || {_, {decrement, X}} <- Operations])
    - lists:sum([1 || {_, decrement} <- Operations]).

% generates a random counter operation
counter_op() ->
  oneof([
    increment,
    decrement,
    {increment, integer()},
    {decrement, integer()}
  ]).

