sudoku(List):-
  convertVarToZero(List, NewList),
  convertTo2D(NewList, Board),
  sudokuBoard(Board, Ans),
  convertTo1D(Ans, List).

sudokuBoard(Board, Board):-
  findMin(Board, _, 0),
  checkTable(Board, Board),
  !.

sudokuBoard(Board, Ans):-
  findMin(Board, Pos, Domain),
  changeBoard(Board, Pos, Domain, ChangedBoard),
  [N, M|_] = Pos,
  get2D(N, M, ChangedBoard, Value),
  TmpN is N + 1,
  TmpM is M + 1,
  write('('),
  write(TmpN),
  write(','),
  write(TmpM),
  write(','),
  write(Value),
  writeln(')'),
  sudokuBoard(ChangedBoard, Ans).

changeBoard(Board, [N, M|_], [H|T], ChangedBoard):-
  change2D(H, N, M, Board, ChangedBoard);
  changeBoard(Board, [N, M], T, ChangedBoard).

convertVarToZero([H], [0]):-
  \+(integer(H)),
  !.

convertVarToZero([H], [H]):-
  member(H, [1, 2, 3, 4, 5, 6, 7, 8, 9]),
  !.

convertVarToZero([H|T], NewList):-
  \+(integer(H)),
  convertVarToZero(T, TmpNewList),
  append([0], TmpNewList, NewList).

convertVarToZero([H|T], NewList):-
  member(H, [1, 2, 3, 4, 5, 6, 7, 8, 9]),
  convertVarToZero(T, TmpNewList),
  append([H], TmpNewList, NewList).

checkTable(List, Board):-
  checkTable(List, 0, Board).

checkTable([H], N, Board):-
  checkTable(H, N, 0, Board),
  !.

checkTable([H|T], N, Board):-
  checkTable(H, N, 0, Board),
  TmpN is N + 1,
  checkTable(T, TmpN, Board).

checkTable([_], N, M, Board):-
  checkCell(N, M, Board),
  !.

checkTable([_|T], N, M, Board):-
  checkCell(N, M, Board),
  TmpM is M + 1,
  checkTable(T, N, TmpM, Board).

checkCell(N, M, Board):-
  findNeighborVertival([N, M], List0),
  findNeighborHorizontal([N, M], List1),
  findNeighborSquare([N, M], List2),
  getNeighborsValue(Board, List0, Values0),
  getNeighborsValue(Board, List1, Values1),
  getNeighborsValue(Board, List2, Values2),
  permutation(Values0, Values1),
  permutation(Values1, Values2),
  permutation(Values2, [1, 2, 3, 4, 5, 6, 7, 8, 9]).

isSubset([],_).
isSubset([H|T],Y):-
  member(H,Y),
  select(H,Y,Z),
  isSubset(T,Z).
equal(X,Y):-
  isSubset(X,Y),
  isSubset(Y,X).

/*
change fucking input to logical input
*/
convertTo2D([], []):- !.

convertTo2D([A0, A1, A2, A3, A4, A5, A6, A7, A8|T], ListOfList):-
  convertTo2D(T, TmpAns),
  append([[A0, A1, A2, A3, A4, A5, A6, A7, A8]], TmpAns, ListOfList).

convertTo1D([], []):- !.

convertTo1D([[A0, A1, A2, A3, A4, A5, A6, A7, A8]|T], Ans):-
    convertTo1D(T, TmpAns),
    append([A0, A1, A2, A3, A4, A5, A6, A7, A8], TmpAns, Ans).

/*
find neighbors
*/
findAllNeighbor(Pos, List):-
  findNeighborVertival(Pos, List0),
  findNeighborHorizontal(Pos, List1),
  findNeighborSquare(Pos, List2),
  append(List0, List1, List3),
  append(List2, List3, List4),
  list_to_set(List4, List).

findNeighborVertival(Pos, List):-
  findNeighborVertival(Pos, 0, List).

findNeighborVertival(_, 9, []):- !.

findNeighborVertival([_, M|_], Counter, List):-
  TmpCounter is Counter + 1,
  findNeighborVertival([_, M], TmpCounter, TmpList),
  append([[Counter, M]], TmpList, List).

findNeighborHorizontal(Pos, List):-
  findNeighborHorizontal(Pos, 0, List).

findNeighborHorizontal(_, 9, []):- !.

findNeighborHorizontal([N|_], Counter, List):-
  TmpCounter is Counter + 1,
  findNeighborHorizontal([N, _], TmpCounter, TmpList),
  append([[N, Counter]], TmpList, List).

findNeighborSquare([N, M | _], List):-
  TmpN is (N//3)*3,
  TmpM is (M//3)*3,
  TmpNPlus1 is TmpN + 1,
  TmpMPlus1 is TmpM + 1,
  TmpNPlus2 is TmpN + 2,
  TmpMPlus2 is TmpM + 2,
  List = [[TmpN, TmpM], [TmpN, TmpMPlus1], [TmpN, TmpMPlus2], [TmpNPlus1, TmpM], [TmpNPlus1, TmpMPlus1], [TmpNPlus1, TmpMPlus2], [TmpNPlus2, TmpM], [TmpNPlus2, TmpMPlus1], [TmpNPlus2, TmpMPlus2]].

/*
get an object in a one dimention and two dimention array,
List and List of List
*/
get1D(0, List, Result):-
  [Result|_] = List,
  !.

get1D(N, List, Result):-
  [_|T] = List,
  TmpN is N - 1,
  get1D(TmpN, T, Result).

get2D(0, M, List, Result):-
  [H|_] = List,
  get1D(M, H, Result),
  !.

get2D(N, M, List, Result):-
  [_|T] = List,
  TmpN is N - 1,
  get2D(TmpN, M, T, Result).

/*
change an object in a one dimention and two dimention array,
List and List of List
*/
change1D(X, 0, List, Result):-
  [_|T] = List,
  append([X], T, Result),
  !.

change1D(X, N, List, Result):-
  [H|T] = List,
  TmpN is N - 1,
  change1D(X, TmpN, T, TmpResult),
	append([H], TmpResult, Result).

change2D(X, 0, M, List, Result):-
  [H|T] = List,
  change1D(X, M, H, TmpResult),
  append([TmpResult], T, Result),
  !.

change2D(X, N, M, List, Result):-
  [H|T] = List,
  TmpN is N - 1,
  change2D(X, TmpN, M, T, TmpResult),
  append([H], TmpResult, Result).

/*
get values of neighbors
*/
getDomain(Board, Pos, 0):-
  [N, M|_] = Pos,
  get2D(N, M, Board, Result),
  Result \= 0,
  !.

getDomain(Board, Pos, Domain):-
  findAllNeighbor(Pos, Neighbors),
  getNeighborsValue(Board, Neighbors, TmpNeighborsValues),
  list_to_set(TmpNeighborsValues, NeighborsValues),
  subtract([1, 2, 3, 4, 5, 6, 7, 8, 9], NeighborsValues, Domain).

getNeighborsValue(Board, [H], NeighborsValues):-
  [N, M|_] = H,
  get2D(N, M, Board, Result),
  NeighborsValues = [Result],
  !.

getNeighborsValue(Board, [H|T], NeighborsValues):-
  [N, M|_] = H,
  getNeighborsValue(Board, T, TmpAns),
  get2D(N, M, Board, Result),
  append([Result], TmpAns, NeighborsValues).

/*
get all domains
*/
forDomains(Board, N, 8, Ans):-
  getDomain(Board, [N, 8], Domain),
  Ans = [Domain],
  !.

forDomains(Board, N, M, Ans):-
  TmpM is M + 1,
  forDomains(Board, N, TmpM, TmpAns),
  getDomain(Board, [N, M], Domain),
  append([Domain], TmpAns, Ans).

forDomains(Board, 8, Ans):-
  forDomains(Board, 8, 0, TmpAns),
  Ans = [TmpAns],
  !.

forDomains(Board, N, Ans):-
  TmpN is N + 1,
  forDomains(Board, TmpN, TmpAns1),
  forDomains(Board, N, 0, TmpAns2),
  append([TmpAns2], TmpAns1, Ans).

getDomains(Board, Ans):-
  forDomains(Board, 0, Ans).

/*
find min len in domains
*/
difMin1D(_, Val1, Pos2, Val2, Pos, Min):-
      Val1 > Val2,
      Pos is Pos2 + 1,
      Min is Val2,
      !.

difMin1D(Pos, Min, _, _, Pos, Min).

min1D([0], 0, 100):- !.

min1D([H], 0, Min):-
  length(H, Min),
  !.

min1D(List, Pos, Min):-
  [H|T] = List,
  min1D(T, TmpPos, TmpMin),
  H == 0,
  difMin1D(0, 100, TmpPos, TmpMin, Pos, Min),
  !.

min1D(List, Pos, Min):-
  [H|T] = List,
  min1D(T, TmpPos, TmpMin),
  length(H, Len),
  difMin1D(0, Len, TmpPos, TmpMin, Pos, Min).

difMin2D(_, Val1, Pos2, Val2, Pos, Min):-
  Val1 > Val2,
  [N|T] = Pos2,
  [M|_] = T,
  TmpN is N + 1,
  Pos = [TmpN, M],
  Min is Val2,
  !.

difMin2D(Pos, Min, _, _, Pos, Min).

min2D([H], [0, Pos], Min):-
  min1D(H, Pos, Min),
  !.

min2D(List, Pos, Min):-
  [H|T] = List,
  min2D(T, TmpPos1, TmpMin1),
  min1D(H, TmpPos2, TmpMin2),
  difMin2D([0, TmpPos2], TmpMin2, TmpPos1, TmpMin1, Pos, Min).

findMin(Board, Pos, Domain):-
  getDomains(Board, Ans),
  min2D(Ans, Pos, Min),
  Min \= 0,
  getDomain(Board, Pos, Domain),
  !.

findMin(Board, Pos, []):-
  getDomains(Board, Ans),
  min2D(Ans, Pos, 0),
  writeln('BT'),
  false.
