import numpy as np
import drawHeatMap as hm
import rewardTable as rt
import transitionTable as tt


def main():
    
    minX, maxX, minY, maxY=(0, 3, 0, 2)
    convergenceTolerance = 10e-7
    roundingTolerance= 10e-7
    gamma = 0.8
    
    possibleAction=[(0,1), (0,-1), (1,0), (-1,0)]
    possibleState=[(i,j) for i in range(maxX+1) for j in range(maxY+1)]
    V={s:0 for s in possibleState}
    
    normalCost=-0.04
    trapDict={(3,1):-1}
    bonusDict={(3,0):1}
    blockList=[(1,1)]
    
    p=0.8
    transitionProbability={'forward':p, 'left':(1-p)/2, 'right':(1-p)/2, 'back':0}
    transitionProbability={move: p for move, p in transitionProbability.items() if transitionProbability[move]!=0}
    
    transitionTable=tt.createTransitionTable(minX, minY, maxX, maxY, trapDict, bonusDict, blockList, possibleAction, transitionProbability)
    rewardTable=rt.createRewardTable(transitionTable, normalCost, trapDict, bonusDict)
    
    """
    levelsReward  = ["state", "action", "next state", "reward"]
    levelsTransition  = ["state", "action", "next state", "probability"]
    
    viewDictionaryStructure(transitionTable, levelsTransition)
    viewDictionaryStructure(rewardTable, levelsReward)
    """


    hm.drawFinalMap(V, policy, trapDict, bonusDict, blockList, normalCost)

    
    
    
if __name__=='__main__': 
    main()
