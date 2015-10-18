# MSSSM Fall 2015 – Research Plan

> * Group Name: Transmissionary
> * Group participants names: Steffen Arnold, Joris Cadow
> * Project Title: Social discovery and its impact on the spreading of infectious diseases


## General Introduction

*Social discovery platforms* have recently gained much in popularity and they change the structure of influences to our everyday lives.
In this work, we would like to consider the emergence of people discovery platforms such as Tinder: Establishing real-life connections outside of one's circle of acquaintances has become increasingly easier and thereby more common. This opens new ways for the spread of infectious diseases.

Consequently, government agencies of Rhode Island, USA, are now claiming that Tinder is responsible for a dramatic increase in the incidence of sexually transmitted diseases (STDs), e.g. a 79 % increase for Syphilis.

Simulations are a fundamental tool to understand the spread of infectious diseases in a population. It depends of course on the chosen model, i.e. how accurately it represents the real world, which conclusions may be drawn from such a simulation.

The topology of a contact network depicting a society is not the defining characteristic alone for the dynamics of an epidemic outbreak, but behavior has an immense impact as well [Funk, 2009]. Behavior may for example decrease the infection rate due to higher awareness of hygiene, or it might alter the network topology as sick people isolate themselves or are avoided. Individual behavior is a result of available information. The emergence and propagation of information has a different, though coupled dynamic to the spread of a disease. Various simulations exist in the literature with a focus on strictly local spreading of disease and information.

The introduction of *social discovery* has impact on the dynamics of both the disease and the information, e.g by transmitting a disease at a Tinder date during incubation time without knowing of the susceptible individual.


## The Model

We link an epidemiological model to contact and information networks such that information emerges and propagates depending on the proximity to an infected individual. The amount of information available to a susceptible individual in turn influences the probability of an infection. This type of simulation was done before and is well established.

The key feature of *our* model is that infection can also spread in a *non-local* way between individuals that are otherwise largely separated in the contact network, while information spreads strictly locally.

- We choose the S(E)IR model with possibly R=S. Asymptomatic individuals might be treated through the information network (see below), or otherwise we include the fourth E compartment.

- We have a contact/social network which is an undirected graph. If a link between two nodes (individuals) exists, we call them neighbors.

- We have an information network, where each two nodes share a *perceived contagiousness* of one another, i.e. a directed weighted graph.

- Each node holds the following data:

  1. To which of the SIR compartments is he/she assigned?

  2. At which rate is he/she willing to commit to a casual relationship?

- The disease can potentially spread via 2 channels:

  1. Locally: At a given rate an infected individual may infect one of his susceptible neighbors.

  2. Non-locally: Depending on the *willingness rates* of an infected individual and a randomly selected susceptible individual within an adjustable neighborhood, the disease may also spread between these two.

- Whenever an individual is newly assigned to the infected compartment, information is created towards only his/her neighbors about his/her new *perceived contagiousness*.

- *Perceived contagiousness* is time-dependent, i.e. it fades away, and it may take some time until it becomes effective.

- The effective *perceived contagiousness* reduces the probability of an infection in 2 ways:

  1. Locally: The *perceived contagiousness* of the susceptible about the infected individual.

  2. Globally: The mean *perceived contagiousness* within an information radius of a susceptible individual.

- *Perceived contagiousness* spreads to neighbors similarly to the disease, but it is reduced from transition to transition to account for authenticity of information.

From a Monte Carlo simulation of this model we hope to be able to derive data in the dynamics and critical behavior of an epidemic outbreak.


## Fundamental Questions

- Is there an actual change in the course of a disease by introducing Tinder-like connections? Are there diseases that are more likely to profit from Tinder-like connections than others? We intend to measure this by comparing the critical values of some disease parameters (reproduction rate, time dependency of infected ratio, etc. in some equilibrium) for different parameters characterizing the emergence of Tinder-like connections.

- Can the data from our extended model be explained by the existing models or does our model introduce a new and necessary degree of freedom? In other words, is the claim that increasing use of Tinder leads to higher incidences of STDs valid or could/should this be explained by a changed sexual behavior in general?

- On the assumption that diseases spread more easily in our model due to divergences in disease and information transition, we are interested in the necessary increase on information flow to balance the resulting effects.


## Expected Results

- Information about a disease may reduce its reproduction rate. Since such information does not necessarily reach of the distance of a Tinder-like connection, diseases might then spread less inhibited through the population. In other words, the critical values for certain parameters are probably lowered, enabling more diseases to infect the whole population.

- Common interaction follows a different topology and it's increase should have less effect.

- The same reasons as mentioned above apply for an increased flow of information, although information spreads wider than the disease and its increase might lead to a critical point where it is much less likely to find Tinder-like connections with sufficiently little information.


## References

Funk, S., Salathé, M., & Jansen, V. A. (2010). Modelling the influence of human behaviour on the spread of infectious diseases: a review. Journal of the Royal Society Interface, 7(50), 1247-1256.
Chicago
> General introduction to epidemiological SIR model with behavioral change.
> A contact network restricts the set of susceptible individuals and allows for treating of an inhomogeneous population.

Gross, T., D’Lima, C. J. D., & Blasius, B. (2006). Epidemic dynamics on an adaptive network. Physical review letters, 96(20), 208701.
> Change of contact network topology in response to the network's state.

Funk, S., Gilad, E., Watkins, C., & Jansen, V. A. (2009). The spread of awareness and its impact on epidemic outbreaks. Proceedings of the National Academy of Sciences, 106(16), 6872-6877.
> SIR model on a contact network coupled to an information network.
> Instead of adapting the contact network topology, the transitions take into account the state of the information network.
> We plan to use this model as a starting point for our own simulation, with the generalizations described before.

Woolley-Meza, O., Helbing, D. & Brockmann, D. (2015). Limited information activates resonant epidemic control. Manuscript submitted for publication.
> Dynamics of disease spreading depending on available information.
> We want to incorporate the concept of information neighborhoods as well as described before.

https://github.com/Pascal-Stucheli/Epidemic_Simulation_SS2012
> Epidemic simulation with different SI models on a contact network with transportation. No information network, though.


## Research Methods

- S(E)IR model where possibly R=S
- Contact network that restricts disease spreading channels
- Information network which inhibits disease spreading
- Monte Carlo random sampling


## Other

We intend to use real data provided by Dr. Olivia Woolley comprising "a network of tinder likes, and the Facebook network that goes with it".
