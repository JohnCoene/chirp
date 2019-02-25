---
title: Early Launch
author: John Coene
authorURL: http://twitter.com/jdatap
---

This is an early launch of Chirp, still much needs to be improved and added. It should still be in development but I really wanted to submit it to the [Shiny Contest](https://blog.rstudio.com/2019/01/07/first-shiny-contest/) to see how it'd fare.

This post gives some idea of how Chirp was put together as well as the roadmap ahead.

<!--truncate-->

## Introduction

I more or less got where I wanted with the look and feel of the platform, I wanted something easy to install and deploy. In fact I aimed at making it so easy that (hopefully) those not familiar with R or even programming can install and deploy it on their own: it's just a `yaml` configuration file and four lines of code after all. 

I also sought to make the interface easy to understand, I tried to reproduce a straightforward search engine sort of feel, from the homepage it is pretty clear what you should do; enter a search, click submit and there is your network!

![](/img/chirp_home.png)

It may look somewhat different than your typical [Shiny](https://shiny.rstudio.com/) app. The first thing that jumps to mind is the lack of navbar. It was just not necessary and thus was removed using the following CSS.

```css
nav{
	display:none;
}
```

Technically the application still is has two tabs, 1) the home page where one enters the search and 2) the network one where the graph is displayed, the navbar is just not visible. Upon hitting the `search` button from the home screen, the user is programmatically redirected to the second (hidden) tab using `shiny::updateTabsetPanel`, below is a basic example.

```r
library(shiny)

ui <- navbarPage(
  "example",
  id = "tabs",
	header = list(
		tags$style("nav{display:none;}")
	),
  tabPanel(
    "home",
    actionButton("switch", "Go to networks tab")
  ),
  tabPanel(
    "networks",
    h3("Hello!")
  )
)

server <- function(input, output, session){
  observeEvent(input$switch, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "networks")
  })
}

shinyApp(ui, server)
```

The above being a minimal example I simply put the CSS in a `style` tag but [in Chirp](https://github.com/JohnCoene/chirp/blob/master/R/zzz.R) I use `shiny::addResourcePath` to add a directory of static files to the web server, this way you I can have custom CSS and JavaScript in their own respective file, then liking to them just like if they were in the `www` folder.

Something else that Chirp uses quite a bit is `session$sendCustomMessage` which lets R send data to JavaScript. This is how the loading screens are shown and hidden. At the beginning of the `reactive` which collects the data from Twitter the loading screen is fired up, to be hidden at the end of the `reactive`. Those loading screens are from [please-wait](http://pathgather.github.io/please-wait/). I believe this actually plays a role in making the app better, [it's not just cosmetics](https://john-coene.com/post/shiny-life/) it gives the user feedback: there is nothing more infuriating than clicking a button and not knowing what is happening or whether it registered.

The last thing that probably plays a big role in the look of the application is [pushbar](https://github.com/JohnCoene/pushbar), which in essence allows "hiding" all the inputs, only making them available when the user wants. I believe that too many inputs visible at once is overwhelming the user. Inputs also take a lot of space, using pushbar to put these aside gives room to visualise the network in its entirety. 

A small digression while we're on the subject, I have recently developped a Shiny app for work with the help of a designer, which put to view quite a few of the design flaws my apps had. The most noteworthy one and the one is what the designer referred to as "proximity": 

> Keep your _inputs_ close to the _outputs_ they affect

Otherwise you just confuse the user who moves a slider in the top left of your application to see some inputs in the bottom right change. The latter coupled with the lack of feedback completely baffles the user. Another thing that came out of my interaction with the designer was the lack of space in my application, `shiny` does not set a [container](https://getbootstrap.com/docs/3.3/css/#overview-container) by default, I would strongly advise using one.

Also, Chirp uses Shiny proxies wherever possible. Proxies, I argue, are greatly underrated and ought to become more popular. Shiny Proxies pertain to [htmlwidgets](https://www.htmlwidgets.org/) and allow interacting with a visualisation without redrawing it in its entirety. I implement those proxies in all my htmlwidgets. In Chirp , the network visualisation is build with the [sigmajs R package](http://sigmajs.john-coene.com) which comes with a lot of proxies. I detail those proxies in the [Shiny documentation](http://sigmajs.john-coene.com/articles/shiny.html) of the package which will also let you better understand how they work and why they are awesome. 

Finally, Chirp makes use of JavaScript events, which also pertains to htmlwidgets. Those allow sending data from JavaScript to R, this is how Chirp picks up which node has been clicked for instance. These are also incredibly easy to incorporate into htmlwidgets.

If you are an htmlwidget developper my blog post on [how to build htmlwidgets](https://john-coene.com/post/how-to-build-htmlwidgets/) might help you integrate them in your package.

Without proxies and events Chirp would not allow:

- Searching for node in the network
- Deleting nodes from the network
- Running and stopping the layout
- Removing node overlap
- Exporting the network to svg or png
- Changing node size and colour
- Displaying tweets on node click
- Displaying node stats on click

Or rather, it could do perhaps do some of those things but would have to redraw the entirety of the network every time which would be quite irritating.

## Notable Dependencies

In gratitude to the many packages without which Chirp would not be possible. Note that the list below excludes many packages from the [tidyverse](https://www.tidyverse.org/).

- [rtweet](https://rtweet.info/) by [Michael Kearney](https://mikewk.com/) to collect the tweets.
- [graphTweets](http://graphtweets.john-coene.com/) by myself to build Twitter networks.
- [sigmajs](http://sigmajs.john-coene.com/) by myself to visualise the networks.
- [tidygraph](https://github.com/thomasp85/tidygraph) by [Thomas Lin Pedersen](https://www.data-imaginist.com/) which is a lifesaver when working with graphs.
- [aforce](https://aforce.john-coene.com/) by myself for the Virtual Reality network.
- [shinyjs](https://deanattali.com/shinyjs/) by [Dean Attali](https://deanattali.com/).
- [shinyparticles](https://github.com/dreamRs/shinyparticles) by [DreamRs](https://www.dreamrs.fr/) on the homepage, a nice touch given Chirp is network-related.
- [reactrend](https://reactrend.john-coene.com/) by myself for the tweets trendline.
- [shinycustomloader](https://github.com/emitanaka/shinycustomloader) by [Emi Tanaka](https://emitanaka.github.io/) for the loader over the graph.
- [shinythemes](https://rstudio.github.io/shinythemes/) by [RStudio](https://www.rstudio.com/) for the themes in `_chirp.yml`.

## Roadmap

There is still much to be added to Chirp, namely in the substance, the platform has the potential to be much more insightful than it is now. The very first thing to do is refactoring.

One core feature that will require a lot of work but I thing could bring a lot is a plugin system to enable adding other visualisations. Currently, like most R packages, the only way someone can make additions to the platform is by making a pull a request which implies two things:

1. Making a lot of research to understand how Chirp works
2. The features added would be _forced_ onto everyone else

A plugin system reduces transactional costs, a developper does not have to do extensive research on the source code to design an additional feature. Plugins are also optional, you can include or exclude it from your own Chirp, which one could hardly do otherwise.

## Known issues

As the title implies there may be some issues, this is by no means an exhaustive list.

- Clusters filters (<i class="fas fa-layer-group"></i> button) stop working after updating the data from the network screen.
