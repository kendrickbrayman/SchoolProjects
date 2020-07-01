#Kendrick Brayman Tic Tac Toe
triples <- list(c(1,2,3), c(4,5,6), c(7,8,9), c(1,4,7), c(2,5,8), c(3,6,9), c(1,5,9), c(3,5,7))

display <- function(board)
{
  for(i in 1:9)
  {
    if(is.na(board[i])){out <- i}
    else{out <- board[i]}
    cat(c("",out, ""))
    if(i %% 3 != 0)
    {
      cat("|")
    }
    else
    {
      cat("\n---+---+---\n")
    }
  }
  cat("\n\n")
}

update <- function(who, board, pos)
{
  b <- board
  b[pos] <- who 
  return(b)
}
prompt_user <- function(who,board)
{
  pos <- readline(prompt = "Select square to play: ")
  pos <- as.integer(pos)
  while(TRUE)
    {
    if(!is.na(board[pos]))
      {
        pos <- readline(prompt = "Illegal move. Select Again: ")
        pos <- as.integer(pos)
      }
    else{break}
    }
  update(who,board,pos)
}
check_win <- function(board)
{
  b <- board
  if(sum(is.na(b)) == 0){return(TRUE)}
  for(i in 1:8)
  {
    if(length(unique(b[triples[i][[1]]])) == 1 & sum(is.na(b[triples[i][[1]]])) == 0) 
    {
      return(TRUE)
    }
  }
  return(FALSE)
}
computer_turn <- function(board)
{
  b <- board
  if(length(b[b == "X"]) > length(b[b == "O"])){who <- "O"}
  else{who <- "X"}
 if(sum(is.na(b)) == 9) 
   {
   return(update(who,b,5))
   }
  if(sum(is.na(b)) == 1)
  {
    return(update(who,b,which(is.na(b))))
  }
  else
  {
    for(i in 1:8)
    {
      if((sum(is.na(b[triples[i][[1]]])) == 1 ) & length(subset(board[triples[i][[1]]],board[triples[i][[1]]] == who)) == 2)
      {
        return(update(who,b,triples[i][[1]][which(is.na(b[triples[i][[1]]]))]))
      }
    }
    for(i in 1:8)
    {
        if((sum(is.na(b[triples[i][[1]]])) == 1 ) & length(unique(b[triples[i][[1]]])) < 3)
        {
          return(update(who,b,triples[i][[1]][which(is.na(b[triples[i][[1]]]))]))
        }
    }
    return(update(who,b,sample(which(is.na(board)),1)))
  }
}
play <- function()
{
  board <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA)
  numplay <- readline(prompt = "Enter the number of players: ")
  comfirst <- "N"
  if(numplay == 1)
  {
    comfirst <- readline(prompt = "Enter Y for the computer to play first or any key for the player to begin: ")
  }
  display(board)
  while(TRUE)
  {
    player <- "X"
    if(comfirst == "Y")
    {
      board <- computer_turn(board)
    }
    else
    {
      board <- prompt_user(player,board)
    }
    if(check_win(board)){break}
    player <- "O"
    display(board)
    if(comfirst != "Y" & numplay == 1)
    {
      board <- computer_turn(board)
    }
    else
    {
      board <- prompt_user(player,board)
    }
    if(check_win(board)){break}
    display(board)
  }
  if(sum(is.na(board)) == 0)
  {
    cat(c("\n Tie!\n"))
  }
  else
  {
    cat(c("\n",player, " wins!\n"))
  }
  display(board)
}

