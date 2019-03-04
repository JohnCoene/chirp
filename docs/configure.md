---
id: configure
title: Configuration
---

This document details the various options available in `_chirp.yml`. Note that these options are applied on server launch, therefore after updates the server must be restarted in order for the changes to be reflected.

On a Shiny Community server you can do so with.

```bash
sudo systemctl restart shiny-server
```

_Original_
<img src="/img/chirp_mac_ui.png" width="50%">
_Customised_
<img src="/img/custom_chirp_network.png" width="50%">

## Default

Below is the default config file as created by `chirp::build_nest()`.

```yaml
credentials:                              # twitter app credentials
  consumer_key: null
  consumer_secret: null
  access_token: null
  access_secret: null

options:
  min_tweets: 500                         # Minimum number of tweets one can fetch
  max_tweets: 17000                       # Maximum number of tweets one can fetch

style:
  theme: paper                            # from: https://rstudio.github.io/shinythemes
  font: Raleway                           # google font
  font_family: "'Raleway', sans-serif"    # font family
  sliders: 'rgb(255, 255, 255)'           # background color of sliders
  continuous:                             # network color palettes for continuous variable
    - "#BADEFA"
    - "#90CAF8"
    - "#64B4F6"
    - "#41A5F4"
    - "#2096F2"
    - "#1E87E5"
    - "#1976D2"
    - "#1465BF" 
    - "#0C46A0"
  discrete:                               # discrete palette 
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
  background: 'rgba(0,0,0,0)'             # background of network graph
  vr_background: '#052960'                # VR background color
  edges_color: 'rgba(196, 196, 196, .6)'  # Color of edges
  sentiment_palette:                      # Palette for sentiment edges
    - "#EE6352"
    - "#c4c4c4"
    - "#59CD90"

tracking:
  ganalytics: "UA-74544116-1"
```

## Credentials

This holds the credentials for your twitter application so that Chirp can search for tweets. Though in the [quick-start](quick-start.md) section it states that you may not need to specify the `credentials` if you run Chirp locally, chances are, when deploying, this will be necessary. 

You can obtain the necessary keys and tokens by heading to [apps.twitter.com](https://apps.twitter.com) and creating an application. Fill in the form however you see fit, the only thing of importance is to fill in the "Callback URLs" with `http://127.0.0.1:1410`.

## Options

Currently one can change the range slider determining the number of tweets to fetch. You define the minimum and maximum of the range slider, the selected default value will always be the minimum. This was done out of convenience for the demo deploy, more options might be added later on.

## Style

This allows you to customise the look and feel of Chirp.

### Theme

Since Chirp runs on the [Shiny framework](https://rstudio.github.io/shinythemes/) you can specify a theme from [shinythemes](https://rstudio.github.io/shinythemes/). There is a [theme selector](https://shiny.rstudio.com/gallery/shiny-theme-selector.html) to help you find your favorite.

The available themes are:

- `cerulean`
- `cosmo`
- `cyborg`
- `darkly`
- `flatly`
- `journal`
- `lumen`
- `paper` (default)
- `readble`
- `sandstone`
- `simplex`
- `slate`
- `spacelab`
- `superhero`
- `united`
- `yeti`

### Font & Font Family

You can specify any [Google Font](https://fonts.google.com/) font to use in Chirp, which defaults to [Raleway](https://fonts.google.com/specimen/Raleway).

## Colors

You can specify two color palettes, one for continuous variables and one for discrete variables as well as the background color of the traditional and Virtual Reality network (defaults to transparent), and the color of the edges.

Default _continuous_ palette:

<input class="jscolor" value="BADEFA">
<input class="jscolor" value="90CAF8">
<input class="jscolor" value="64B4F6">
<input class="jscolor" value="41A5F4">
<input class="jscolor" value="2096F2">
<input class="jscolor" value="1E87E5">
<input class="jscolor" value="1976D2">
<input class="jscolor" value="1465BF">
<input class="jscolor" value="0C46A0">

Default _discrete_ palette:

<input class="jscolor" value="E58606">
<input class="jscolor" value="5D69B1">
<input class="jscolor" value="52BCA3">
<input class="jscolor" value="99C945">
<input class="jscolor" value="CC61B0">
<input class="jscolor" value="24796C">
<input class="jscolor" value="DAA51B">
<input class="jscolor" value="2F8AC4">
<input class="jscolor" value="764E9F">
<input class="jscolor" value="ED645A">
<input class="jscolor" value="CC3A8E">
<input class="jscolor" value="A5AA99">

The *sentiment_palette* used to color edges by aggregated sentiment:

Negative
<input class="jscolor" value="EE6352">
Neutral
<input class="jscolor" value="c4c4c4">
Positive
<input class="jscolor" value="59CD90">

There is also a `sliders` options to specify the background color of the various sliders on the network screen. This is generally useful if you changed the theme to a dark one.

### Tracking

You can specify a `ganalytics` to track the usage of Chirp when deployed.
