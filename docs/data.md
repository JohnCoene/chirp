---
id: data
title: Data
---

## Introduction

The data source used by Chirp is obviously [Twitter](https://twitter.com), the [Twitter Search API](https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets.html) more precisely, which Chirp calls via the [rtweet package](https://rtweet.info/).

## Search

You can search for tweets by tiping a query in the search bar. Note that it supports boolean operators as well as others specific to Twitter. Note that the [Twitter Search API](https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets.html) limits the number of tweets you can fetch to _18,000 every 15 minutes_. 

<img src="/img/chirp_search_home.gif" style="max-width:100%;">


### Examples

Look for tweets using the #brexit hashtag or mentioning Theresa May.

```text
#brexit OR "theresa may"
```

Look for _safe_ tweets (sensitive content removed) about Trump. 

```text
trump filter:safe
```

You will find more examples in the [official documentation](https://developer.twitter.com/en/docs/tweets/search/guides/standard-operators.html)

### Options

You will find more options by clicking on the <i class="fas fa-plus"></i> button. This will let you specify the number of tweets to fetch. This defaults to 500 but can go as high as 18,000. However, note that you are limited (by the Twitter API) to 18,000 tweets per 15 minute. 

The coordinates and radius will allow you to restrict tweets posted from a certain geographical region. Specify the `longitude` and `latitude` as numerics and the `radius` in either kilometer or miles.

On the network screen you will have an additional option: to append the subsequent search to the previously.

<img src="/img/chirp_search_append.gif" style="max-width:100%;">

### Tip

Search for topics not keywords, a sparingly mentioned keyword that does not resonate will not result in an interesting graph but a mess of scattered nodes with barely any edges. Chirp tagline goes:

> Visualise Twitter Interactions

The emphasis is on _interactions_: Twitter users discussing and interacting with one another. This does not necessarily mean "trending" topics will be appropriate as they are, somehow surprisingly, rarely the result of actual conversations that sprung organically.

## Load

Alternatively, you can load a previously downloaded dataset, which you can obtain in two different ways.

- Downloaded from the network screen click the <i class="fas fa-pencil-ruler"></i> button and hit _Download data_.
- Manually download a dataset using `rtweet::search_tweets` and save the resulting object as a `.RData` file.

Note you can select multiple files as well as combine search and files from the network screen. 

1. Execute your initial search or load your file from the home screen.
2. From the resulting network screen click the <i class="fas fa-database"></i> button.
3. From either the _Search_ or the _load_ tab tick the append check box.

