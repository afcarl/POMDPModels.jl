using POMDPModels
using POMDPToolbox
using POMDPs

problem = BabyPOMDP(-5, -10, 0.1, 0.8, 0.1, 0.9)

n = 1000
results = Vector{Float64}(n)

i = 1
rng = MersenneTwister(i)
init_state = BabyState(false)
od = observation(problem, init_state, BabyAction(false), init_state)
obs = rand(rng, od)
sim = RolloutSimulator(rng=rng, initial_state=init_state, eps=0.0001)
policy = FeedWhenCrying()
results[i] = simulate(sim, problem, policy, updater(policy), PreviousObservation(obs))

using ProfileView

Profile.clear()

@profile @time for i in 1:n
    rng = MersenneTwister(i)
    init_state = BabyState(false)
    od = observation(problem, init_state, BabyAction(false), init_state)
    obs = rand(rng, od)
    sim = RolloutSimulator(rng=rng, initial_state=init_state, eps=0.0001)
    policy = FeedWhenCrying()
    results[i] = simulate(sim, problem, policy, updater(policy), PreviousObservation(obs))
end

ProfileView.view()