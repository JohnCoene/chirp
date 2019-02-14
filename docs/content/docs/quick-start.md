+++
title = "Quick Start"
description = "Up and running in under a minute"
weight = 1
draft = false
toc = true
bref = "Easy to install and run."
+++

<div class="message warning">
    <h3 class="">Before you start</h3>
    <br>
    <p class="">Create a new <strong>empty</strong> directory in which we will host the application and follow these instruction from its root.</p>
</div>

<h3 class="section-head" id="install"><a href="#installation">Installation</a></h3>

Chirp is written in <a href="https://www.r-project.org/" target="_blank">R</a>, therefore the latter must be installed on your machine.

Once <a href="https://www.r-project.org/" target="_blank">R</a> installed simply open an R console and install Chirp from <a href="https://github.com/JohnCoene/chirp">Github</a> with the <mark>remotes</mark> package. 

<nav class="tabs" data-component="tabs">
    <ul>
        <li class="active"><a href="#inst">I <i>don't</i> have it installed already</a></li>
        <li><a href="#notinst">I have it <i>already</i> installed</a></li>
    </ul>
</nav>

<div id="inst">
    Install <code>remotes</code> first then Chirp with the following.
    {{< highlight r >}}
    install.packages("remotes")
    remotes::install_github("JohnCoene/chirp")
    {{< / highlight >}}
</div>

<div id="notinst">
    Install Chirp using remotes.
    {{< highlight r >}}
    remotes::install_github("JohnCoene/chirp")
    {{< / highlight >}}
</div>

The above will install Chirp and all of its dependencies. 

<h3 class="section-head" id="init"><a href="#init">Initialise</a></h3>

Once installed we can initialise Chirp with `build_nest`.

```r
chirp::build_nest()
```

The function simply copies the default configuration file (`_chirp.yml`) to the working directory. The file includes numerous options, most of which can be left as is if you are happy with how the platform looks. 

<nav class="tabs" data-component="tabs">
    <ul>
        <li class="active">
          <a href="#tab3">I have <i>never</i> used `rtweet`</a>
        </li>
        <li><a href="#tab4">I have <i>already</i> used `rtweet`</a></li>
    </ul>
</nav>


<div id="tab3">
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

Once the app created, go to the <i>Key and tokens</i> tab and place the given credentials in your <code>_chirp.yml</code>. To obtain something similar to:

{{< highlight yaml >}}
credentials:
  consumer_key: "f91vXbxLkxXxxzxSx8Pxqjxo"
  consumer_secret: "oXXxLX8CV7xxwxXGx7w9sX3xxYzx2XxiixNAxXGxx7xzxxxXeV"
  access_token: "123456789-0hmCXnxRxg10mM4XxXvmxxtXC1WXXTxM9xxXX6sJ"
  access_secret: "XXxZxxXEx2kXeMuxkoX8txn5XLxuXTx1pNvgdV3Xix12x"
{{< / highlight >}}

</div>
<div id="tab4">
  <strong>Great!</strong>
  You can skip this step, Chirp will use your itnernally stored credentials.
</div>

<h3 class="section-head" id="check"><a href="#check">Check</a></h3>

Now you can check to ensure that your configuration file (`_chirp.yml`) is valid.

```r
chirp::check_nest()
```

<h3 class="section-head" id="check"><a href="#check">Run</a></h3>

Launch chirp with:

```r
chirp::chirp()
```
