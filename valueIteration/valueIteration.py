import numpy as np
import drawHeatMap as hm
import rewardTable as rt
import transitionTable as tt

def getSPrimeRDistribution(s, action, rewardTable, transitionTable):
    reward = lambda sPrime: rewardTable[s][action][sPrime]
    p = lambda sPrime: transitionTable[s][action][sPrime]
    sPrimeRDistribution = {(sPrime, reward(sPrime)): p(sPrime) for sPrime in transitionTable[s][action].keys()}
    return sPrimeRDistribution

def getExpected(s, action, V, transitionTable):
    output = 0
    for stateN, p in transitionTable[s][action].items():
        output = output + V[stateN] * p
    return output

def getReward(s,bonus,trap,cost):
    if s in bonus:
        return bonus[s]
    if s in trap:
        return trap[s]
    else:
        return cost

def policy(Q, roundingTolerance):
    actionMaxQ = [action for action in Q.keys() if abs(Q[action] - max(Q.values())) < roundingTolerance]
    output = {}
    for action in actionMaxQ:
        output[action] = 1/len(actionMaxQ)
    return output

def stateExpectedValue(s, policy, V, transitionTable, rewardTable, gamma,roundingTolerance,block,bonus,trap,cost):
    if s in block: return 0
    if s in bonus: return bonus[s]
    if s in trap: return trap[s]
    Q = {action: getExpected(s, action, V, transitionTable) for action in transitionTable[s].keys()}
    maxActions = policy(Q,roundingTolerance)
    value = actionVal = 0
    for action, pAction in maxActions.items():
        stateVal = 0
        for (endState, reward), pState in getSPrimeRDistribution(s, action, rewardTable, transitionTable).items():
            stateVal = stateVal + pState * V[endState]
        actionVal = actionVal + stateVal
        value = value + actionVal * pAction
    value = gamma * value + getReward(s,bonus,trap,cost)
    return value



def getMove(s,V,transitionTable):
    val = []
    actionBest = []
    for action in transitionTable[s].keys():
        val.append(V[list(transitionTable[s][action])[0]])

    for action in transitionTable[s].keys():
        if V[list(transitionTable[s][action])[0]] == max(val):
            actionBest.append(action)

    output = {action:1/len(actionBest) for action in actionBest}


    return output

def main():
    minX, maxX, minY, maxY = (0, 3, 0, 2)
    convergenceTolerance = 10e-7
    roundingTolerance = 10e-7
    gamma = 0.8

    possibleAction = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    possibleState = [(i, j) for i in range(maxX + 1) for j in range(maxY + 1)]
    V = {s: 0 for s in possibleState}

    normalCost = -0.04
    trapDict = {(3, 1): -1}
    bonusDict = {(3, 0): 1}
    blockList = [(1, 1)]

    p = 0.8
    transitionProbability = {'forward': p, 'left': (1 - p) / 2, 'right': (1 - p) / 2, 'back': 0}
    transitionProbability = {move: p for move, p in transitionProbability.items() if transitionProbability[move] != 0}

    transitionTable = tt.createTransitionTable(minX, minY, maxX, maxY, trapDict, bonusDict, blockList, possibleAction,
                                               transitionProbability)
    rewardTable = rt.createRewardTable(transitionTable, normalCost, trapDict, bonusDict)

    def updateMultipleSteps(S, V, policy, transitionTable, rewardTable, convergenceTolerance, gamma,roundingTolerance,block,bonus,trap,cost):

        deltas = {s: np.Inf for s in S}

        getValueOfAState = lambda s, v: stateExpectedValue(s, policy, v, transitionTable, rewardTable, gamma,roundingTolerance,block,bonus,trap,cost)

        while max(deltas.values()) > convergenceTolerance:
            deltas = {s: 0 for s in S}
            v = V.copy()
            V = {s: getValueOfAState(s, v) for s in S}
            deltas = {s: abs(V[s] - v[s]) for s in S}

        moveStates = transitionTable.keys()
        V[(3,0)] = 1
        V[(3,1)] = -1
        finalPolicy = {s:getMove(s, V, transitionTable) for s in moveStates}

        return [V,finalPolicy]

    Output = updateMultipleSteps(possibleState, V, policy, transitionTable, rewardTable, convergenceTolerance, gamma,roundingTolerance,blockList,bonusDict,trapDict,normalCost)



    hm.drawFinalMap(Output[0], Output[1], trapDict, bonusDict, blockList, normalCost)

    print(Output[0])
    print(Output[1])

if __name__ == '__main__':
    main()
