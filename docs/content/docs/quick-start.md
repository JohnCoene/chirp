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

<button data-component="toggleme" data-target="#togglebox-remotes-installed" data-text="It's installed!">
    I have it installed already
</button>
<button data-component="toggleme" data-target="#togglebox-remotes-not-installed" data-text="It's installed!">
    I _do not_ have it installed already
</button>

<div id="togglebox-remotes-installed" class="hide">
    If you <i>do not</i> have <mark>remotes</mark> installed yet, run the following:
    {{< highlight r >}}
    remotes::install_github("JohnCoene/chirp")
    {{< / highlight >}}
</div>

<div id="togglebox-remotes-not-installed" class="hide">
    If you <i>do</i> have <mark>remotes</mark> installed, run the following:
    {{< highlight r >}}
    install.packages("remotes")
    remotes::install_github("JohnCoene/chirp")
    {{< / highlight >}}
</div>

The above will install Chirp and all of its dependencies. 

<h3 class="section-head" id="functions"><a href="#functions">Functions</a></h3>

Now that Chirp is installed you can work on setting up the platform. It's very easy, Chirp only comes with four functions.

1. `build_nest` - Initialise Chirp.
2. `check_nest` - Check that everything is OK.
3. `chirp` - Launch Chirp
4. `fly` - Convenience function for deployment.

<h3 class="section-head" id="init"><a href="#init">Initialise</a></h3>

We can initialise Chirp with `build_nest`.

```r
chirp::build_nest()
```

The function simply copies the default configuration file (`_chirp.yml`) to the working directory. The file includes numerous options, most of which can be left as is if you are happy with how the platform looks. You will to adapt the `credentials`. It includes four things that need to be filled in:

* `consumer_key`
* `consumer_secret`
* `access_token`
* `access_secret`

You can get those credentials by navigating to <a href="https://apps.twitter.com" target="_blank">apps.twitter.com</a> and create an application.

<div class="message warning">
    <p class="inverted">Under <strong>Callback URL</strong> put <samp>http://127.0.0.1:1410</samp>.</p>
</div>

You will find the necessary credentials under <i>Keys and Access Tokens</i>.

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
