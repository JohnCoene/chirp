---
id: configure
title: Configuration
---

This document details the various options available in `_chirp.yml`.

## Default

Below is the default config file as created by `chirp::build_nest()`.

```yaml
credentials:                    # twitter app credentials
  consumer_key: null
  consumer_secret: null
  access_token: null
  access_secret: null

style:
  theme: paper                          # from: https://rstudio.github.io/shinythemes
  font: Raleway                         # google font
  font_family: "'Raleway', sans-serif"  # font family
  continuous:                           # network color palettes for continuous variable
    - "#BADEFAFF"
    - "#90CAF8FF"
    - "#64B4F6FF"
    - "#41A5F4FF"
    - "#2096F2FF"
    - "#1E87E5FF"
    - "#1976D2FF"
    - "#1465BFFF" 
    - "#0C46A0FF"
  discrete:                             # discrete palette 
    - "#E58606" 
    - "#5D69B1" 
    - "#52BCA3"
    - "#99C945"
    - "#CC61B0"
    - "#24796C" 
    - "#DAA51B"
    - "#2F8AC4"
    - "#764E9F"
    - "#ED645A"
    - "#CC3A8E"
    - "#A5AA99"
  background: 'rgba(0,0,0,0)'           # background of network graph
  edges_color: '#bababa'                # Color of edges

tracking:
  ganalytics: "UA-74544116-1"
```

## Credentials

This holds the credentials for your twitter application so that Chirp can search for tweets. Though in the [quick-start](quick-start.md) section it states that you may not need to specify the `credentials` if you run Chirp locally, chances are, when deploying, this will be necessary. 

You can obtain the necessary keys and tokens by heading to [apps.twitter.com](https://apps.twitter.com) and creating an application. Fill in the form however you see fit, the only thing of importance is to fill in the "Callback URLs" with `http://127.0.0.1:1410`.

## Style

This allows you to customise the look and feel of Chirp.

### Theme
