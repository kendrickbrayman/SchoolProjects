gameboard <- data.frame(space = 1:40, title = c("Go" , "Mediterranean Avenue" , "Community Chest" , "Baltic Avenue" , "Income Tax" , "Reading Railroad" , "Oriental Avenue" , "Chance" , "Vermont Avenue" , "Connecticut Avenue" , "Jail" , "St. Charles Place" , "Electric Company" , "States Avenue" , "Virginia Avenue" , "Pennsylvania Railroad" , "St. James Place" , "Community Chest" , "Tennessee Avenue" , "New York Avenue" , "Free Parking" , "Kentucky Avenue" , "Chance" , "Indiana Avenue" , "Illinois Avenue" , "B & O Railroad" , "Atlantic Avenue" , "Ventnor Avenue" , "Water Works" , "Marvin Gardens" , "Go to jail" , "Pacific Avenue" , "North Carolina Avenue" , "Community Chest" , "Pennsylvania Avenue" , "Short Line Railroad" , "Chance" , "Park Place" , "Luxury Tax" , "Boardwalk"), stringsAsFactors = FALSE)
chancedeck <- data.frame(index = 1:15, card = c("Advance to Go" , "Advance to Illinois Ave." , "Advance to St. Charles Place" , "Advance token to nearest Utility" , "Advance token to the nearest Railroad" , "Take a ride on the Reading Railroad" , "Take a walk on the Boardwalk" , "Go to Jail" , "Go Back 3 Spaces" , "Bank pays you dividend of $50" , "Get out of Jail Free" , "Make general repairs on all your property" , "Pay poor tax of $15" , "You have been elected Chairman of the Board" , "Your building loan matures"), stringsAsFactors = FALSE)
communitydeck <- data.frame(index = 1:16, card = c("Advance to Go" , "Go to Jail" , "Bank error in your favor. Collect $200" , "Doctor's fees Pay $50" , "From sale of stock you get $45" , "Get Out of Jail Free" , "Grand Opera Night Opening" , "Xmas Fund matures" , "Income tax refund" , "Life insurance matures. Collect $100" , "Pay hospital fees of $100" , "Pay school tax of $150" , "Receive for services $25" , "You are assessed for street repairs" , "You have won second prize in a beauty contest" , "You inherit $100"), stringsAsFactors = FALSE)



# Dice --------------------------------------------------------------------

random_dice <- function(verbose=FALSE){
  faces <- sample(1:6, 2, replace=TRUE)
  if(faces[1] == faces[2]) doubles = TRUE
  else doubles = FALSE
  movement = sum(faces)
  if(verbose) cat("Rolled:", faces[1], faces[2], "\n")
  return(list(faces=faces, doubles=doubles, movement=movement))
}

# Manual Dice -------------------------------------------------------------

# this Reference Class allows you to create a set of manual dice
manual_dice = setRefClass("manual_dice", 
                          fields = list(
                            rolls = "numeric",
                            pos = "numeric",
                            verbose = "logical"
                          ), 
                          methods = list(
                            roll = function() {
                              faces = rolls[pos + seq_len(2)]
                              pos <<- pos + 2
                              if(faces[1] == faces[2]) doubles = TRUE
                              else doubles = FALSE
                              movement = sum(faces)
                              if(verbose) cat("Rolled:", faces[1], faces[2], "\n")
                              return(list(faces=faces, doubles=doubles, movement=movement))
                            }
                          )
)

# preset_rolls is an instance of the manual_dice reference class
preset_rolls <- manual_dice$new(rolls = c(6,4, 5,3, 3,5, 6,2, 5,4, 4,1, 2,6, 4,4, 4,4, 2,2, 
                                          4,3, 4,4, 1,4, 3,4, 1,2, 3,6, 5,4, 5,5, 1,2, 5,4, 3,3, 1,1, 2,1, 1,3),
                                pos = 0, verbose = TRUE)
# preset_dice is a function that simply calls the roll() method from this preset_rolls object
preset_dice <- function() preset_rolls$roll()

player <- setRefClass("player", 
                      fields = list(
                        pos = "numeric",      # position on the board
                        verbose = "logical",   # option to have it print all the info
                        jail = "logical",
                        speed = "numeric"
                      ), 
                      methods = list(
                        initialize = function(pos, verbose)
                        {
                          pos <<- pos
                          verbose <<- verbose
                          jail <<- FALSE
                          speed <<- 0
                        },
                        move_fwd = function(x) {
                          if(verbose) cat("Player at:", pos)
                          if(verbose) cat(" Player moves:", x)
                          pos <<- pos + x
                          if(pos > 40) pos <<- pos - 40
                          if(verbose) cat(" Player now at:", pos,"\n")
                        },
                        go_2_space_n = function(n){
                          if(verbose) cat("Player at:", pos,".")
                          pos <<- n
                          if(verbose) cat(" Player now at:", pos,".\n")
                        },
                        go2jail = function(player,tracking){
                          jail <<- TRUE
                          setspeed(player,0)
                          if(verbose) cat("Player at:", pos,".")
                          pos <<- 11
                          if(verbose) cat(" Player now at:", pos,".\n")
                          tracking$increase_count(11)
                        },
                        clearJail = function(player)
                        {
                          jail <<- FALSE
                          speed <<- 0
                        },
                        setspeed = function(player,spd)
                        {
                          speed <<- spd
                        }
                        
                        
                      )
)

player1 <- player$new(pos = 1, verbose = TRUE)  # create new players
player2 <- player$new(pos = 1, verbose = TRUE)


# Space Tracking Reference Class ------------------------------------------

tracking <- setRefClass("tracking",
                        fields = list(
                          tally = "numeric",
                          verbose = "logical"
                        ),
                        methods = list(
                          increase_count = function(n){
                            tally[n] <<- tally[n] + 1
                            if(verbose) cat("Tally at ",n,": ", gameboard$title[n],"\n",sep="")
                          }
                        )
)

#community deck draw

comdraw <- function(player,tracking){
  drawn <- sample(1:16,1, replace = T)
  if(communitydeck[drawn,1] == 1) {
    player$go_2_space_n(1)
    tracking$increase_count(1)
  }
  else if(communitydeck[drawn,1] == 2) player$go2jail(player, tracking)
  
}

#chance deck draw

chancedraw <- function(player, tracking){
  drawn <- sample(1:15,1, replace = T)
  
  if(chancedeck[drawn,1] == 1) {
    cat("Player drew: ",chancedeck[drawn,2])
    player$go_2_space_n(1)
    tracking$increase_count(1)
  }
  else if(chancedeck[drawn,1] == 2) {
    cat("Player drew: ",chancedeck[drawn,2])
    player$go_2_space_n(25)
    tracking$increase_count(25)
  }
  else if(chancedeck[drawn,1] == 3) {
    cat("Player drew: ",chancedeck[drawn,2])
    player$go_2_space_n(12)
    tracking$increase_count(12)
  }
  else if(chancedeck[drawn,1] == 4) {
    cat("Player drew: ",chancedeck[drawn,2])
    if(player$pos == 23){
      player$go_2_space_n(29)
      tracking$increase_count(29)
    }
    else {
      player$go_2_space_n(13)
      tracking$increase_count(13)
    }
    
  }
  else if(chancedeck[drawn,1] == 5) {
    cat("Player drew: ",chancedeck[drawn,2])
    if(player$pos == 37)
    {
      player$go_2_space_n(6)
      tracking$increase_count(6)
    }
    else if(player$pos == 8){
      player$go_2_space_n(16)
      tracking$increase_count(16)
    }
    else if(player$pos == 23){
      player$go_2_space_n(26)
      tracking$increase_count(26)
    }
  }
  else if(chancedeck[drawn,1] == 6)
  {
    cat("Player drew: ",chancedeck[drawn,2])
    player$go_2_space_n(6)
    tracking$increase_count(6)
  }
  else if(chancedeck[drawn,1] == 7)
  {
    cat("Player drew: ",chancedeck[drawn,2])
    player$go_2_space_n(40)
    tracking$increase_count(40)
  }
  else if(chancedeck[drawn,1] == 8)
  {
    cat("Player drew: ",chancedeck[drawn,2])
    player$go2jail(player,tracking)
  }
  else if(chancedeck[drawn,1] == 9)
  {
    cat("Player drew: ",chancedeck[drawn,2])
    player$go_2_space_n(player$pos - 3)
    tracking$increase_count(player$pos - 3)
  }
}

# Taking a turn -----------------------------------------------------------

# take_turn accepts a player object and a tracking object.
# The take_turn code executes methods in the player object that will 
# alter variables in the player object
# take_turn also executes methods in the tracking object that modifies its values

taketurn <- function(player, tracking){  
  if(player$jail) {
    player$setspeed(player,player$speed + 1)
    if(player$speed >= 3) {
      player$clearJail(player)
      roll <- dice()
      player$move_fwd(roll$movement)
      tracking$increase_count(player$pos)
      if(gameboard[player$pos,2] == "Community Chest") comdraw(player,tracking)
      else if(gameboard[player$pos,2] == "Chance") chancedraw(player,tracking)
      return()
    }
    roll <- dice()
    if(roll$doubles){
      player$clearJail(player)
      player$move_fwd(roll$movement)
      tracking$increase_count(player$pos)
      if(gameboard[player$pos,2] == "Community Chest") comdraw(player,tracking)
      else if(gameboard[player$pos,2] == "Chance") chancedraw(player,tracking)
      return()
    }
    else {
      
      return()
    }
  }
  else {
    player$setspeed(player,0)
    while(TRUE)
    {
      roll <- dice()
      if(!roll$doubles){
        player$move_fwd(roll$movement)
        if(player$pos == 31) {player$go2jail(player,tracking)}
        else {tracking$increase_count(player$pos)}
        break
      }
      player$setspeed(player,player$speed + 1)
      if(player$speed >= 3) {
        player$go2jail(player,tracking)
        break
      }
      player$move_fwd(roll$movement)
      if(player$pos == 31) {player$go2jail(player,tracking)}
      else {tracking$increase_count(player$pos)}
      if(gameboard[player$pos,2] == "Community Chest") comdraw(player,tracking)
      else if(gameboard[player$pos,2] == "Chance") chancedraw(player,tracking)
      if(player$jail) return()
    }
    if(gameboard[player$pos,2] == "Community Chest") comdraw(player,tracking)
    else if(gameboard[player$pos,2] == "Chance") chancedraw(player,tracking)
  }
  
}