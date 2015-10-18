# MATLAB Fall 2014 – Research Plan

> * Group Name: Transmissionary
> * Group participants names: Steffen Arnold, Joris Cadow
> * Project Title: Influence of casual relationships through social discovery on epidemics

## General Introduction

(States your motivation clearly: why is it important / interesting to solve this problem?)
Simulations are a fundamental tool to understand the spread of infectious diseases in populations. It depends of course on the chosen model, that is how accurately it represents the real world, which conclusions may be drawn from such a simulation. In this work, we would like to consider the emergence of social discovery platforms such as Tinder. Due to such platforms finding a date outside of one's circle of acquaintances has become easier and thereby more common. This opens new ways for spread of infectious diseases.
(Add real-world examples, if any)
Recently, government agencies of Rhode Island, USA blamed Tinder for the dramatic increase in cases of sexual transmittable diseases (STD's), e.g. 79% increase of Syphilis.
(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)
The structure or connectivity of a social network depicting society is one thing influencing epidemics, but behavior has immense impact as well [Funk, 2009]. Behavior may for example decrease the infection rate due to higher awareness of hygiene or might alter the network structure because sick people isolate themselves or are avoided. Individual behavior is a result of available information. The emergence and propagation of information has a different, though coupled dynamic than the spread of disease. The introduction of social discovery has impact on both respective dynamics, e.g by transmitting a disease at a Tinder date during incubation time, but not letting them know 

## The Model

(Define dependent and independent variables you want to study. Say how you want to measure them.) (Why is your model a good abstraction of the problem you want to study?) (Are you capturing all the relevant aspects of the problem?)
We link an epidemiologic model to a model of a host population, where information emerges and propagates depending on the proximity to Infected people. The amount of information in turn influences the probability of infection.

- We use the epidemiological SIR model. Asymptomatic individuals might be treated through the information network (see below), or otherwise we include a fourth E compartment.

- We have a social network which is an undirected graph. If a link between two nodes (individuals) exists, we call them neighbors.

- We have an information network, where each two individuals share a «perceived contagiousness» of one another, i.e. a directed weighted graph.

- Each node (individual) holds the following data:
1) To which of the SIR compartments is he/she assigned?
2) At which rate is he/she willing to commit to a casual relationship?

- The disease spreads via 2 channels:
1) Locally: At a given rate an infected individual may infect one of his susceptible neighbors.
2) Non-locally: Depending on the «willingness rates» of an infected individual and a randomly selected susceptible individual, the disease may also spread between these two.

- Whenever an individual is newly assigned to the infected compartment, information is created only towards his neighbors about his/her new «perceived contagiousness».

– «Perceived contagiousness» is time-dependent, i.e. it fades away, and it may take some time until it becomes effective.

- «Perceived contagiousness» reduces the probability of an infection in 2 ways:
1) Locally: The «perceived contagiousness» of the susceptible about the infected individual.
2) Globally: The total «perceived contagiousnesses» within an information radius of a susceptible individual.

- «Perceived contagiousness» spreads to neighbors similarly to the disease, but it is reduced from transition to transition to account for authenticity of information.


## Fundamental Questions

(At the end of the project you want to find the answer to these questions)
(Formulate a few, clear questions. Articulate them in sub-questions, from the more general to the more specific. )
- We would like to see whether there is an actual change for the course is there more? influence on  "Threshold" parameters, where epidemic is not stopped

- why is it, could same result happen w/o Tinder

- what change of information propagation would be necessary to remove effect

## Expected Results

(What are the answers to the above questions that you expect to find before starting your research?)
Information about a disease decreases its spread. Since such information is less widespread with the introduction of Tinder connections, diseases might spread less inhibited through a population. In other words, threshold values for a disease's parameters (like infection rate) are lowered, enabling more diseases to infect the whole population.
## References

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)


## Research Methods

(Cellular Automata, Agent-Based Model, Continuous Modeling...) (If you are not sure here: 1. Consult your colleagues, 2. ask the teachers, 3. remember that you can change it afterwards)


## Other

(mention datasets you are going to use)
We intend to use real data provided by Olivia Woolley, comprising " a network of tinder likes, and the Facebook network that goes with it".
