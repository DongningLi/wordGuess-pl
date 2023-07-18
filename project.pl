

:-ensure_loaded(library(clpfd)).

%predict left part before slot as left, which should contains only # or empty
left(Left):-
    maplist(==('#'), Left).

%predict slot as slot, which not contains # and not empty
slot(Slot):-
    length(Slot,Len),
    Len > 0,
    maplist(\==('#'),Slot).

%predict rest part after slot as rest which start with #
rest([X|_]):-
    X == '#'.
%rest can be empty when its then end of a row
rest([]).

%slots, which length equal to 1, are not considered 
filter_slot(Slot):-
    length(Slot, Len),
    Len > 1.

%sort the list by the length of element of list descending
reverse_sort(List, ListSorted):-
    sort(List, ListSorted0),
    reverse(ListSorted0, ListSorted).

%predict one row contains only #
slots_of_row(Row, []) :- 
    %This means the whole row is left part, thus left(Row) should be true 
    left(Row).

%get the slots of ONE row
slots_of_row(Row, [Slot|Slots]):-
    %a row consists of Left part, Slot and Rest part
    append([Left, Slot, Rest], Row),
    
    %Left part is left, Slot is slot, and Rest part is rest
    left(Left),
    slot(Slot),
    rest(Rest),
    
    %recursive the rest of the row and get corresponding slots
    slots_of_row(Rest,Slots).

%get all slots of ALL rows
slots_of_rows(Rows, Slots):-
    %get all slots
    maplist(slots_of_row, Rows, SlotLists),
    % change type of "SlotLists" from "list of list of list" to "list of list"
    append(SlotLists, AllSlots),
    %filter out the slots which length equal to 1
    include(filter_slot, AllSlots, Slots).


%get all slots of puzzle
slots_of_puzzle(Puzzle, Slots):-
    %transpose puzzle to get puzlle' to consider column as row
    transpose(Puzzle, PuzzlePrime),
    %get the slots from puzzle and puzzle'
    slots_of_rows(Puzzle, SlotsP),
    slots_of_rows(PuzzlePrime, SlotsPP),
    %append the slots from puzzle and puzzle' together to get all slots
    append(SlotsP, SlotsPP, Slots).

%match the slot with a word
match_slot(Slot, WordList):-
    member(Word, WordList),
    Slot = Word.

%calculate how many times a slot can be matched a word from wordlist
%    and retrun the times and corresponding slot in "times-slot "
cal_match_times(WordList, Slot, Times-Slot):-
    bagof(Slot, match_slot(Slot, WordList), SlotMatchList),
    %the length of the ag is the times of slot matches with a word
    length(SlotMatchList, Times).

%get the slot list sorted by matching times
match_slots_words(Slots, WordList, SlotsSortedByTimes):-
    
    maplist(cal_match_times(WordList), Slots, TimesSlotsList),
    %sort the list by times
    keysort(TimesSlotsList, TimesSlotsListSorted),
    %get the slot slit
    pairs_values(TimesSlotsListSorted, SlotsSortedByTimes).

%stop when both lists are empty
match_words([],[]).
%match the slots and wordlist
match_words(Slots, WordList):-
    %get which least matched slot
    %	and the slot list sorted by matching times
    match_slots_words(Slots, WordList, [Slot|NewSlots]),
    %match the slot and a word
    match_slot(Slot, WordList),
    %Slot is unified with word in match_slot
    %	thus, remove the Slot from wordlist
    select(Slot, WordList, NewWordList),
    %iterate with new slotlist and new wordlist
    match_words(NewSlots, NewWordList).

%main function
puzzle_solution(Puzzle, WordList):-
    %get all slots
    slots_of_puzzle(Puzzle, Slots),
    %reverse sort the the slots and wordlist
    reverse_sort(Slots, SlotsSorted),
    reverse_sort(WordList, WordListSorted),
    %match the wordlist and slots 
    match_words(SlotsSorted, WordListSorted),
    %stops after one match or not 
    !.
