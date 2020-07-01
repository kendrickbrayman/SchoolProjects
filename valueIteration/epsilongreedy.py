import numpy as np
import matplotlib.pyplot as plt


def getSamplar():
    mu = np.random.normal(0, 10)
    sd = abs(np.random.normal(8, 2))
    getSample = lambda: np.random.normal(mu, sd)
    return getSample


def e_greedy(Q, e):
    p = np.random.uniform(0, 1)
    if p > e:
        return np.random.choice(list(Q))
    else:
        return max(Q)


def updateQN(action, reward, Q, N):
    N[action] = N[action] + 1
    Q[action] = Q[action] + 1 / N[action] * (reward - Q[action])
    out = (Q, N)
    return out


def decideMultipleSteps(Q, N, policy, bandit, maxSteps):
    actionReward = []
    for i in range(maxSteps):
        action = policy(Q, N)
        reward = bandit(action)
        updateQN(action, reward, Q, N)
        actionReward.append((action, reward))
    return {'Q': Q,'N':N,'actionReward':actionReward}


def plotMeanReward(actionReward, label):
    maxSteps = len(actionReward)
    reward = [reward for (action, reward) in actionReward]
    meanReward = [sum(reward[:(i + 1)]) / (i + 1) for i in range(maxSteps)]
    plt.plot(range(maxSteps), meanReward, linewidth=0.9, label=label)
    plt.xlabel('Steps')
    plt.ylabel('Average Reward')


def main():
    np.random.seed(1)
    K = 100
    maxSteps = 1000
    Q = {k: 0 for k in range(K)}
    N = {k: 0 for k in range(K)}
    testBed = {k: getSamplar() for k in range(K)}
    bandit = lambda action: testBed[action]()

    policies = {}
    policies["e-greedy-0.5"] = lambda Q, N: e_greedy(Q, 0.5)
    policies["e-greedy-0.1"] = lambda Q, N: e_greedy(Q, 0.1)
    policies["e-greedy-0.0"] = lambda Q, N: e_greedy(Q,0)
    policies["e-greedy-1.0"] = lambda Q, N: e_greedy(Q,1)


    allResults = {name: decideMultipleSteps(Q, N, policy, bandit, maxSteps) for (name, policy) in policies.items()}

    for name, result in allResults.items():
        plotMeanReward(allResults[name]['actionReward'], label=name)
    plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left', ncol=2, mode="expand", borderaxespad=0.)
    plt.show()


if __name__ == '__main__':
    main()
