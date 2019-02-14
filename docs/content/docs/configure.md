+++
title = "Configure"
description = "About _chirp.yml"
weight = 2
draft = false
toc = true
bref = "All you need to know about configuring Chirp"
+++

<h3 class="section-head" id="intro"><a href="#intro">Introduction</a></h3>

All the configuration for Chirp lives in one place: `chirp_yml`. It includes some settings necessary to making Chirp run but also let you customise, amongst other things, its appearance.

You can obtain the configuration file by running:

```r
chirp::build_nest()
```

This will copy the `_chirp.yml` to the working directory and open it in your editor, <a href="https://www.rstudio.com/products/rstudio/" target="_blank">RStudio</a> or other.

<h3 class="section-head" id="credentials"><a href="#credentials">Credentials</a></h3>

<nav class="tabs" data-component="tabs">
    <ul>
        <li class="active">
          <a href="#tab1">I have <i>never</i> used `rtweet`</a>
        </li>
        <li><a href="#tab2">I have <i>already</i> used `rtweet`</a></li>
    </ul>
</nav>


<div id="tab1">
The credentials section of <code>_chirp.yml</code> is the only necessary to fill in. The default file has all the credentials set to <code>null</code>.

{{< highlight yaml >}}
credentials:
  consumer_key: null
  consumer_secret: null
  access_token: null
  access_secret: null
{{< / highlight >}}

You will need to replace all <code>null</code>s with your own credentials. These credentials are <i>keys and tokens</i> that can be obtained from Twitter. Head to <a href="https://apps.twitter.com" target="_blank">apps.twitter.com</a> and create a new app.

<div class="message warning">
    <p class="inverted">Under <strong>Callback URL</strong> put <samp>http://127.0.0.1:1410</samp>.</p>
</div>

<figure>
  <img src="/twitter-app.png"/>
  <figcaption>Twitter application creation process</figcaption>
</figure>

Once the app created, go to the <i>Key and tokens</i> tab and place the given credentials in your <code>_chirp.yml</code>. To obtain something similar to:

{{< highlight yaml >}}
credentials:
  consumer_key: "f91vXbxLkxXxxzxSx8Pxqjxo"
  consumer_secret: "oXXxLX8CV7xxwxXGx7w9sX3xxYzx2XxiixNAxXGxx7xzxxxXeV"
  access_token: "123456789-0hmCXnxRxg10mM4XxXvmxxtXC1WXXTxM9xxXX6sJ"
  access_secret: "XXxZxxXEx2kXeMuxkoX8txn5XLxuXTx1pNvgdV3Xix12x"
{{< / highlight >}}

</div>
<div id="tab2">
  <strong>Great!</strong>
  You can skip this step, Chirp will use your itnernally stored credentials.
  <div class="message warning">
      <p>Keep that in mind when deploying, the credentials should also be stored in your server.</p>
  </div>
</div>

<h3 class="section-head" id="style"><a href="#style">Style</a></h3>

This set of options will let you customise the appearance of Chirp.

<strong>Theme</strong>

Under theme specify a theme from <a href="https://rstudio.github.io/shinythemes" target="_blank">shinythemes</a> by name.

<strong>Font</strong>

Replace the font and font family (`font_family`) with any <a href="https://fonts.google.com/" target="_blank">Google Font</a> of your choice.

<strong>Colours</strong>

You can customise the colors used on the network visualisation by customising, `continuous`, `discrete`, `background`, and `edges_color`.

Chirp uses two different colour palettes depending on the variable used to color the nodes, 1) `continuous` when colouring nodes by size and 2) `discrete` when coloring by cluster. `background` is the background color of the network visualisation, it defaults to transparent. Finally `edges_color` will let you change the color of the edges (lines connecting nodes).

The default configuration of the style is below, which as you will find it after running `chirp::build_nest()`

```yaml
style:
  theme: paper                  
  font: Raleway                       
  font_family: "'Raleway', sans-serif"
  continuous:                     
    - "#E3F2FDFF"
    - "#BADEFAFF"
    - "#90CAF8FF"
    - "#64B4F6FF"
    - "#41A5F4FF"
    - "#2096F2FF"
    - "#1E87E5FF"
    - "#1976D2FF"
    - "#1465BFFF" 
    - "#0C46A0FF"
  discrete:                            
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
  background: 'rgba(0,0,0,0)'   
  edges_color: '#bababa'        
```

<h3 class="section-head" id="ga"><a href="#ga">Tracking</a></h3>

The final item in the configuration file allows you to track the usage of the platform using <a href="https://analytics.google.com" target="_blank">Google Analytics</a> by passing the tracking id to `ganalytics`. Note that this is only relevant is deploying the Chirp.