---
id: data
title: Data
---

## Introduction

The data source used by Chirp is obviously [Twitter](https://twitter.com), the [Twitter Search API](https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets.html) more precisely, which Chirp calls via the [rtweet package](https://rtweet.info/).

## Search

You can search for tweets by tiping a query in the search bar. Note that it supports boolean operators as well as others specific to Twitter.

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
