Program Purpose
This program will solve the properly constructed fill-in puzzle by 
always matching the slot which fills fewest matching words.

This program is to solve the filled-in puzzle 
which only has one and only one solution given the list of the world.

The approach will solve the puzzle within 20 seconds. Steps are as follows:
S1. Devide puzzle into rows, then devide each row into left, slot and rest
S2. Transpose the puzzle and so we can treat columns as rows
S3. Get the slots of the puzzle
S4. Reverse sort the list of slots 
    Slots with longer length are more possible to match less words
S5. Reverse sort the list of wordlist
    Corresponding the order of slots
    Then iterating the list when match slot terminates earlier
S6. Sort the slot by matching times
S7. Get the slot which is least mathing with wordlist
S8. Match the slot and a word from wordlist
S9. remove the slot and word then recursive from S6 with new slotlist and wordlist
    if failed, rematch from S8

Until both slots and wordlist are empty, 
we will find the solution if there is one and fail if there is not
