+++
title = "Configure"
description = "About _chirp.yml"
weight = 2
draft = false
toc = true
bref = "All you need to know about configuring Chirp."
+++

<h3 class="section-head" id="intro"><a href="#intro">Introduction</a></h3>

All the configuration for Chirp lives in one place: `chirp_yml`. It includes some settings necessary to making Chirp run but also let you customise, amongst other things, its appearance.

You can obtain the configuration file by running:

```r
chirp::build_nest()
```

This will copy the `_chirp.yml` to the working directory and open it in your editor, <a href="https://www.rstudio.com/products/rstudio/" target="_blank">RStudio</a> or other.

<h3 class="section-head" id="credentials"><a href="#credentials">Credentials</a></h3>

<div class="message warning">
    <p class="inverted">Under <strong>Callback URL</strong> put <samp>http://127.0.0.1:1410</samp>.</p>
</div>

The credentials section of `_chirp.yml` is the only necessary to fill in. The default file has all the credentials set to `null`.

```yaml
credentials:
  consumer_key: null
  consumer_secret: null
  access_token: null
  access_secret: null
```

You will need to replace all `null`s with your own credentials. These credentials are <i>keys and tokens</i> that can be obtained from Twitter. Head to <a href="https://apps.twitter.com" target="_blank">apps.twitter.com</a> and create a new app.

<div class="message warning">
    <p class="inverted">Under <strong>Callback URL</strong> put <samp>http://127.0.0.1:1410</samp>.</p>
</div>

<img src="/twitter-app.png"/>

Once the app created, go to the <i>Key and tokens</i> tab and place the given credentials in your `_chirp.yml`. To obtain something similar to:

```yaml
credentials:
  consumer_key: "f91vXbxLkxXxxzxSx8Pxqjxo"
  consumer_secret: "oXXxLX8CV7xxwxXGx7w9sX3xxYzx2XxiixNAxXGxx7xzxxxXeV"
  access_token: "123456789-0hmCXnxRxg10mM4XxXvmxxtXC1WXXTxM9xxXX6sJ"
  access_secret: "XXxZxxXEx2kXeMuxkoX8txn5XLxuXTx1pNvgdV3Xix12x"
```
