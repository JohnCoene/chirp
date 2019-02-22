---
id: networks
title: Networks
---

## Introduction

The ultimate aim of Chirp is to let one analyse the structure and dynamics of social interactions on Twitter. This includes different interactions displaying different types of structures: this document explores the latter.

In brief, we explore some options available on the network screen under <i class="fas fa-pencil-ruler"></i>.

## Network types

You can build different kinds of networks, you will see three options under "network types," though using additional options you can build five different types of networks.

- Retweets
- Conversations
- Hashtags
- Conversations co-mentions
- Hashtags co-mentions

### Retweets

_Retweets_ is selected by default, it is, to the best of my knowledge, the most widespread form of Twitter network. It displays users as nodes, these users are connected when one retweeted the other. This essentially lets you visualise how the information spread throughout the Twitter network; where the original tweet originates and who shared it.

Note that Twitter differentiates between retweets: 

1. The bare retweet
2. The quoted retweet

The latter is a retweet with a comment while the former is a bare retweet without comment. When selecting the retweet type of network a checkbox appears underneath that enables including or excluding quoted tweets, they are included by default.

This actually does have a great impact on the meaning of the resulting network. Below we plot a _retweet_ network of 1,000 tweets including the term "brexit". 

<img src="/img/brexit_retweet_quotes.svg" />

### Hashtags

Hashtags networks tell you more about the nature of the Twitter discussions. You can either connect users to the hashtags they use in their tweets or connect co-occurences of hashtags in tweets. Note that the former produces a directed network while the latter results in an undirected network.

### Conversations

The _conversations_ network displays how users communicate with each other: each node is a user, they are connected by an edge when one @tagged the other in a tweet. A sub-type of this network also enables you to plot co-mentions of users in tweets.

<img src="/img/brexit_conversations.svg" />
